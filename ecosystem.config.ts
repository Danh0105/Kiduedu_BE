// ecosystem.config.ts
// PM2 sẽ đọc biến từ .env thay vì hard-code vào file này.
// Đảm bảo .env của bạn chứa các biến như bạn đã đưa: JWT_SECRET, OPENAI_API_KEY, MOMO_*, POSTGRES_*, ...

// LƯU Ý: PM2 không biên dịch TS cho "script" ứng dụng.
// "script" phải trỏ tới file JS đã build (dist/main.js).
// Riêng file ecosystem .ts thường vẫn chạy OK nếu bạn dùng PM2 >= 5 và có ts-node,
// còn nếu PM2 của bạn không đọc được .ts, hãy đổi tên file này thành ecosystem.config.js (nội dung giữ nguyên cú pháp CJS).

module.exports = {
    apps: [
        {
            name: "kiduedu-be",
            cwd: "/var/www/Kiduedu_BE",          // đổi nếu khác
            script: "dist/main.js",              // NestJS build output
            // Dùng Node LTS cố định cho PM2 (tránh lệch version so với shell)
            // Cập nhật đường dẫn Node LTS đúng với máy bạn:
            interpreter: "/root/.nvm/versions/node/v20.11.1/bin/node",

            // Hiệu năng & độ ổn định
            instances: 1,                        // hoặc "max" để cluster theo số CPU
            exec_mode: "fork",                   // hoặc "cluster"
            max_memory_restart: "512M",
            node_args: ["--enable-source-maps"],

            // Watch: nên tắt ở production
            watch: false,
            ignore_watch: ["node_modules", "logs", ".git"],

            // Log
            time: true,
            merge_logs: true,
            log_date_format: "YYYY-MM-DD HH:mm:ss Z",
            error_file: "/var/www/Kiduedu_BE/logs/kiduedu-be-error.log",
            out_file: "/var/www/Kiduedu_BE/logs/kiduedu-be-out.log",

            // Nạp biến môi trường từ file .env (PM2 sẽ merge vào process.env)
            // PM2 hỗ trợ trực tiếp trường env_file
            env_file: ".env",

            // Mặc định môi trường development (nếu bạn chạy `pm2 start` không kèm --env)
            env: {
                NODE_ENV: "development",
                PORT: "3000",
                // Bạn có thể để trống các biến để lấy từ .env:
                // POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, ...
            },

            // Khi chạy `pm2 start ecosystem.config.ts --env production` sẽ dùng block này
            env_production: {
                NODE_ENV: "production",
                // PORT: "3000", // nếu cần giữ nguyên
                // Nếu cần override khác với .env.production thì điền thêm ở đây
            },

            // Tự khởi động lại khi crash
            autorestart: true,
            restart_delay: 2000,
        },
    ],
};
