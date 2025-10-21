// ecosystem.config.js
module.exports = {
    apps: [
        {
            name: "kiduedu-be",
            cwd: "/var/www/Kiduedu_BE",
            script: "dist/main.js",

            // Dùng Node LTS tuyệt đối cho PM2 (đổi path này đúng bản Node trên server bạn)
            interpreter: "/root/.nvm/versions/node/v20.11.1/bin/node",

            instances: 1,                // hoặc "max"
            exec_mode: "fork",           // hoặc "cluster"
            max_memory_restart: "512M",
            node_args: ["--enable-source-maps"],

            watch: false,
            ignore_watch: ["node_modules", "logs", ".git"],

            time: true,
            merge_logs: true,
            log_date_format: "YYYY-MM-DD HH:mm:ss Z",
            error_file: "/var/www/Kiduedu_BE/logs/kiduedu-be-error.log",
            out_file: "/var/www/Kiduedu_BE/logs/kiduedu-be-out.log",

            // Nạp biến từ .env
            env_file: ".env",

            env: {
                NODE_ENV: "development",
                PORT: "3000",
            },
            env_production: {
                NODE_ENV: "production",
            },

            autorestart: true,
            restart_delay: 2000,
        },
    ],
};
