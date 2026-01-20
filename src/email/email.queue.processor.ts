// src/email/email.queue.processor.ts
import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';
import nodemailer, { SentMessageInfo, Transporter } from 'nodemailer';
import { SettingsService } from '../settings/services/setting-email.service';

@Processor('emailQueue')
export class EmailQueueProcessor extends WorkerHost {
  private transporterCache: Transporter | null = null;

  constructor(
    private readonly settingsService: SettingsService
  ) {
    super();
  }

  /* =================== QUEUE PROCESS =================== */

  async process(job: Job<any>) {
    console.log("WORKER RECEIVED JOB →", job.name, job.data);

    switch (job.name) {
      case 'sendVerifyEmail':
        return this.sendVerifyEmail(job.data.email, job.data.token);

      case 'sendOrderSuccessNotify':
        return this.sendOrderSuccessNotify(job.data);

      case 'sendYepInvitation':
        return this.sendYepInvitation(job.data);
    }
  }


  /* =======================================================
     CREATE TRANSPORTER (reuse để tránh lỗi overload)
  ======================================================== */

  private async getTransporter(user: string, pass: string): Promise<Transporter> {
    if (!this.transporterCache) {
      this.transporterCache = nodemailer.createTransport({
        host: "smtp.gmail.com",
        port: 465,
        secure: true,
        auth: { user, pass }
      });
    }
    return this.transporterCache;
  }

  /* =======================================================
                   SEND VERIFY EMAIL
  ======================================================== */

  private async sendVerifyEmail(email: string, token: string): Promise<SentMessageInfo | void> {
    const MAIL_USER = await this.settingsService.get("MAIL_USER_SENT");
    const MAIL_PASS = await this.settingsService.get("MAIL_PASS_SENT");

    if (!MAIL_USER || !MAIL_PASS) {
      console.error("❌ MAIL_USER / MAIL_PASS thiếu trong DB");
      return;
    }

    const transporter = await this.getTransporter(MAIL_USER, MAIL_PASS);

    try {
      console.log("🔍 Checking SMTP connection...");
      await transporter.verify();
      console.log("✅ SMTP READY!");

      const link = `https://www.kidoedu.vn/users/verify-email?token=${token}`;

      const result = await transporter.sendMail({
        from: `Kido <${MAIL_USER}>`,
        to: email,
        subject: "Xác thực email tài khoản",
        html: this.buildVerifyEmailHTML(link)
      });

      console.log("📨 VERIFY EMAIL SENT →", result.accepted);
      return result;

    } catch (err) {
      console.error("❌ EMAIL ERROR:", err);
    }
  }

  private buildVerifyEmailHTML(link: string): string {
    return `
<table width="100%" cellpadding="0" cellspacing="0" style="background:#f8f9fa;padding:40px 0;">
  <tr>
    <td align="center">

      <table width="600" cellpadding="0" cellspacing="0" style="background:white;border-radius:8px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,0.08);font-family:Arial,Helvetica,sans-serif;">
        
        <!-- HEADER -->
        <tr>
          <td style="background:#2de42f4d;padding:20px;text-align:center;">
            <img src="https://www.kidoedu.edu.vn/static/media/Logo.b35816c78d7c3753c12d.png"
                 width="120"
                 alt="Kido Logo"
                 style="display:block;margin:auto;" />
          </td>
        </tr>

        <!-- BODY -->
        <tr>
          <td style="padding:30px 40px;color:#212529;font-size:16px;line-height:1.6;">
            <h2 style="color:#0d6efd;margin-top:0;">Xác thực email tài khoản</h2>

            <p>Xin chào,</p>
            <p>Cảm ơn bạn đã đăng ký trên hệ thống Kido.
            Nhấn vào nút dưới đây để xác thực email.</p>

            <div style="text-align:center;margin:30px 0;">
              <a href="${link}"
                 style="
                   background:#0d6efd;
                   color:white;
                   padding:12px 24px;
                   font-size:16px;
                   text-decoration:none;
                   border-radius:6px;
                   display:inline-block;
                 ">
                Xác thực tài khoản
              </a>
            </div>

            <p>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>

            <p style="margin-top:30px;">
              Trân trọng,<br/>
              <strong>Đội ngũ Kido</strong>
            </p>
          </td>
        </tr>

        <!-- FOOTER -->
        <tr>
          <td style="background:#f1f3f5;padding:15px;text-align:center;color:#6c757d;font-size:13px;">
            © ${new Date().getFullYear()} Kido — All rights reserved.
          </td>
        </tr>

      </table>

    </td>
  </tr>
</table>`;
  }

  /* =======================================================
               SEND ADMIN ORDER NOTIFICATION
  ======================================================== */

  private async sendOrderSuccessNotify(data: any): Promise<SentMessageInfo | void> {
    const MAIL_USER = await this.settingsService.get("MAIL_USER");
    const MAIL_PASS = await this.settingsService.get("MAIL_PASS");

    if (!MAIL_USER || !MAIL_PASS) {
      console.error("❌ MAIL_NOTIFY / MAIL_PASS thiếu trong DB");
      return;
    }

    const transporter = await this.getTransporter(MAIL_USER, MAIL_PASS);

    const html = `
        <table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f6f8;padding:40px 0;font-family:Arial, sans-serif;">
  <tr>
    <td align="center">

      <table width="600" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 6px 20px rgba(0,0,0,0.08);">
        
        <!-- HEADER -->
        <tr>
          <td style="background:#2de42f4d;padding:18px 0;text-align:center;">
            <img src="https://www.kidoedu.edu.vn/static/media/Logo.b35816c78d7c3753c12d.png" 
                 width="120" 
                 alt="Kido Logo"
                 style="display:block;margin:auto;">
          </td>
        </tr>

        <!-- TITLE -->
        <tr>
          <td style="padding:30px;text-align:center;">
            <h2 style="color:#333;margin:0;font-size:24px;">📦 Bạn có đơn hàng mới!</h2>
            <p style="color:#666;margin-top:10px;font-size:15px;">
              Một đơn hàng mới vừa được đặt trên hệ thống Kido.
            </p>
          </td>
        </tr>

        <!-- ORDER INFO BOX -->
        <tr>
          <td style="padding:0 30px 20px;">
            <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #e5e7eb;border-radius:8px;padding:20px;">
              
              <tr>
                <td style="color:#555;font-size:15px;padding-bottom:12px;">
                  <b>Khách hàng:</b> ${data.userEmail}
                </td>
              </tr>

              <tr>
                <td style="color:#555;font-size:15px;padding-bottom:12px;">
                  <b>Mã đơn hàng:</b> ${data.orderId}
                </td>
              </tr>

              <tr>
                <td style="color:#555;font-size:15px;">
                  <b>Tổng tiền:</b> 
                  <span style="color:#d63384;font-weight:bold;">
                    ${Number(data.total).toLocaleString()}₫
                  </span>
                </td>
              </tr>

            </table>
          </td>
        </tr>

        <!-- CTA BUTTON -->
        <tr>
          <td style="text-align:center;padding:20px 0;">
            <a href="https://kidoedu.vn/admin/orders"
               style="
                 background:#0d6efd;
                 padding:12px 28px;
                 color:white;
                 text-decoration:none;
                 border-radius:6px;
                 font-size:15px;
                 display:inline-block;
               ">
              Xem chi tiết đơn hàng
            </a>
          </td>
        </tr>

        <!-- FOOTER -->
        <tr>
          <td style="background:#f1f3f5;text-align:center;padding:15px;color:#777;font-size:13px;">
            © ${new Date().getFullYear()} Kido — Hệ thống quản lý & giáo dục công nghệ
          </td>
        </tr>

      </table>

    </td>
  </tr>
</table>

        `;

    const result = await transporter.sendMail({
      from: `Kido Shop <${MAIL_USER}>`,
      to: MAIL_USER,
      subject: "🔔 Có đơn hàng mới!",
      html,
    });

    console.log("📨 Order notify email sent →", result.accepted);
    return result;
  }
  private async sendYepInvitation(data: {
    email: string;
    fullName: string;
    qrCode: string;
  }) {
    const MAIL_USER = await this.settingsService.get("MAIL_USER_SENT");
    const MAIL_PASS = await this.settingsService.get("MAIL_PASS_SENT");

    if (!MAIL_USER || !MAIL_PASS) {
      console.error("❌ MAIL_USER / MAIL_PASS thiếu trong DB");
      return;
    }

    const transporter = await this.getTransporter(MAIL_USER, MAIL_PASS);

    const checkinUrl =
      `https://www.kidoedu.vn/checkin?code=${data.qrCode}`;

    const qrImage =
      `https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=${encodeURIComponent(checkinUrl)}`;

    const html = this.buildYepInvitationHTML(
      data.fullName,
      checkinUrl,
      qrImage,
    );

    const result = await transporter.sendMail({
      from: `Kido YEP <${MAIL_USER}>`,
      to: data.email,
      subject: "🎉 Thư mời tham dự Year End Party 2026",
      html,
    });

    console.log("📨 YEP INVITE SENT →", result.accepted);
    return result;
  }
  private buildYepInvitationHTML(
    fullName: string,
    checkinUrl: string,
    qrImage: string,
  ): string {
    return `
<table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f6f8;padding:40px 0;">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:10px;overflow:hidden;
box-shadow:0 6px 20px rgba(0,0,0,0.08);font-family:Arial">

<tr>
<td style="background:#2de42f4d;padding:20px;text-align:center;">
  <img src="https://www.kidoedu.edu.vn/static/media/Logo.b35816c78d7c3753c12d.png"
       width="120" />
</td>
</tr>

<tr>
<td style="padding:30px;color:#212529;">
  <h2>🎉 Thư mời Year End Party 🎉</h2>

  <p>Xin chào <b>${fullName}</b>,</p>

  <p>
    Kido trân trọng kính mời bạn tham dự <b>Year End Party 2025</b>.
  </p>

  <ul>
    <li><b>⏰ Thời gian:</b> 10:00 – 12:00, 01/02/2026</li>
    <li><b>📍 Địa điểm:</b>OSCAR PALACE</li>
    <li><b>👔 Dress code:</b> Smart Casual</li>
  </ul>

  <p><b>Vui lòng mang theo mã QR bên dưới để check-in:</b></p>

  <div style="text-align:center;margin:20px 0;">
    <img src="${qrImage}" width="220" />
  </div>

  <p style="text-align:center">
    👉 <a href="${checkinUrl}">${checkinUrl}</a>
  </p>

  <p>Hẹn gặp bạn tại buổi tiệc! 🥂</p>

  <p>
    Trân trọng,<br/>
    <b>Ban tổ chức YEP</b>
  </p>
</td>
</tr>

<tr>
<td style="background:#f1f3f5;padding:15px;text-align:center;
color:#6c757d;font-size:13px;">
© ${new Date().getFullYear()} Kido — All rights reserved
</td>
</tr>

</table>

</td>
</tr>
</table>
`;
  }



}
