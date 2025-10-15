# Sử dụng Node 18 làm base image
FROM node:18-alpine

# Tạo thư mục làm việc trong container
WORKDIR /usr/src/app

# Copy file package trước để tối ưu cache
COPY package*.json ./

# Cài đặt dependencies
RUN npm install

# Copy toàn bộ mã nguồn vào container
COPY . .

# Build NestJS project (nếu bạn dùng TypeScript)
RUN npm run build

# Mở cổng 3000 (Nest mặc định)
EXPOSE 3000

# Lệnh khởi động app
CMD ["npm", "run", "start:prod","start:dev"]
