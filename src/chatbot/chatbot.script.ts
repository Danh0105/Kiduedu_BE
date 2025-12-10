export const chatbotScript = {
    welcome: {
        text: "Xin chào! Bạn cần hỗ trợ gì từ KIDO?",
        options: [
            { key: "about", label: "ℹ️ Giới thiệu về KIDO" },
            { key: "contact", label: "📞 Liên hệ / Tư vấn 24/7" }
        ]
    },

    about: {
        text: "KIDO EDU là doanh nghiệp hoạt động đa lĩnh vực trong hệ sinh thái công nghệ – giáo dục – dịch vụ kỹ thuật số, định hướng phát triển bền vững dựa trên nền tảng đổi mới sáng tạo và ứng dụng công nghệ cao. Công ty chuyên sản xuất, phân phối và phát triển các giải pháp công nghệ thông minh, đồng thời là đơn vị tiên phong cung cấp phần mềm giáo dục, dịch vụ đào tạo kỹ năng và giải pháp chuyển đổi số cho trường học, doanh nghiệp và cơ quan hành chính.",
        options: [
            { key: "why", label: "Tại sao chọn KIDO?" },
            { key: "back", label: "⬅️ Quay lại", backTo: "welcome" }
        ]
    },
    contact: {
        text: "📞 Hotline tư vấn 24/7: 0789-636-979\n📧 Email: lytran@ichiskill.edu.vn\nHoặc để lại số điện thoại, chúng tôi sẽ liên hệ lại sớm!",
        options: [
            { key: "back", label: "⬅️ Quay lại", backTo: "welcome" }
        ]
    }
}
