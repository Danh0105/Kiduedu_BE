import { Controller, Get, Query, Res } from "@nestjs/common";
import type { Response } from "express";

@Controller()
export class CheckinController {
  @Get("checkin")
  redirectCheckin(
    @Query("code") code: string,
    @Res() res: Response
  ) {
    const targetUrl =
      "https://www.kidoedu.edu.vn/checkin" +
      (code ? `?code=${encodeURIComponent(code)}` : "");

    return res.redirect(301, targetUrl);
  }
}
