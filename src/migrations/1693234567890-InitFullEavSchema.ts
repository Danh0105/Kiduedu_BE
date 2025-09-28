import { MigrationInterface, QueryRunner } from "typeorm";

export class InitFullEavSchema1693234567890 implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        // addresses
        await queryRunner.query(`
      INSERT INTO public.addresses (address_id, full_name, phone_number, street, ward, district, city, is_default, "userUserId")
      VALUES (22, 'Nguyen Xuan Danh', '0326968216', '256/10', 'Xã Khánh An', 'Huyện An Phú', 'Tỉnh An Giang', true, 84)
      ON CONFLICT DO NOTHING;
    `);

        // carts
        await queryRunner.query(`
      INSERT INTO public.carts (cart_id, created_at, user_id) VALUES
      (1,  '2025-09-18 10:00:46.065957', 10),
      (2,  '2025-09-19 03:09:05.140572', 9),
      (20, '2025-09-26 03:35:27.89795', 84)
      ON CONFLICT DO NOTHING;
    `);

        // categories
        await queryRunner.query(`
      INSERT INTO public.categories (category_id, category_name, description, parent_category_id) VALUES
      (1, 'Robotic', NULL, NULL),
      (2, 'ORC', NULL, 1),
      (4, 'Robot Rover', NULL, 1),
      (5, 'Sa bàn Robocon', NULL, NULL),
      (6, 'Rover', NULL, 5),
      (7, 'Rio', NULL, 5)
      ON CONFLICT DO NOTHING;
    `);

        // migrations (domain table)
        await queryRunner.query(`
      INSERT INTO public.migrations (id, "timestamp", name)
      VALUES (1, 1693234567890, 'InitFullEavSchema1693234567890')
      ON CONFLICT DO NOTHING;
    `);

        // orders
        await queryRunner.query(`
      INSERT INTO public.orders (order_id, subtotal, discount_amount, total_amount, status, order_date, user_id, promotion_id) VALUES
      (5,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:35:27.89795', 84, NULL),
      (6,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:35:56.613784', 9, NULL),
      (7,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:01.851011', 9, NULL),
      (8,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:02.84628', 9, NULL),
      (9,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.011192', 9, NULL),
      (10, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.16815', 9, NULL),
      (11, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.318233', 9, NULL),
      (12, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.47517', 9, NULL),
      (13, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.642199', 9, NULL),
      (14, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.767173', 9, NULL),
      (15, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 07:20:02.179685', 9, NULL),
      (16, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 07:32:47.915818', 9, NULL),
      (17, 547000.00, 0.00, 585000.00, 'Pending', '2025-09-26 07:48:13.497137', 9, NULL),
      (18, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 07:48:56.617404', 9, NULL),
      (19, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 07:50:41.09864', 9, NULL),
      (20, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 08:15:45.068795', 9, NULL),
      (21, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 08:16:41.040723', 9, NULL),
      (22, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 00:43:05.600714', 9, NULL),
      (23, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:11:27.69483', 9, NULL),
      (24, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:14:42.470122', 9, NULL),
      (25, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:15:00.40493', 9, NULL),
      (26, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:17:22.966989', 9, NULL),
      (27, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:20:16.19578', 9, NULL),
      (28, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:21:03.273355', 9, NULL),
      (29, 1357000.00, 0.00, 1395000.00, 'Pending', '2025-09-27 04:22:30.631856', 9, NULL)
      ON CONFLICT DO NOTHING;
    `);

        // order_items
        await queryRunner.query(`
      INSERT INTO public.order_items (order_item_id, quantity, price_per_unit, order_id, product_id) VALUES
      (9,1,108000.00,5,8),(10,1,108000.00,5,6),(11,1,108000.00,5,9),(12,1,108000.00,5,7),
      (13,1,108000.00,6,8),(14,1,108000.00,6,6),(15,1,108000.00,6,9),(16,1,108000.00,6,7),
      (17,1,108000.00,7,8),(18,1,108000.00,7,6),(19,1,108000.00,7,9),(20,1,108000.00,7,7),
      (21,1,108000.00,8,8),(22,1,108000.00,8,6),(23,1,108000.00,8,9),(24,1,108000.00,8,7),
      (25,1,108000.00,9,8),(26,1,108000.00,9,6),(27,1,108000.00,9,9),(28,1,108000.00,9,7),
      (29,1,108000.00,10,8),(30,1,108000.00,10,6),(31,1,108000.00,10,9),(32,1,108000.00,10,7),
      (33,1,108000.00,11,8),(34,1,108000.00,11,6),(35,1,108000.00,11,9),(36,1,108000.00,11,7),
      (37,1,108000.00,12,8),(38,1,108000.00,12,6),(39,1,108000.00,12,9),(40,1,108000.00,12,7),
      (41,1,108000.00,13,8),(42,1,108000.00,13,6),(43,1,108000.00,13,9),(44,1,108000.00,13,7),
      (45,1,108000.00,14,8),(46,1,108000.00,14,6),(47,1,108000.00,14,9),(48,1,108000.00,14,7),
      (49,1,108000.00,15,8),(50,1,439000.00,15,6),(51,1,54000.00,15,9),(52,1,378000.00,15,7),
      (53,1,108000.00,16,8),(54,1,439000.00,16,6),(55,1,54000.00,16,9),(56,1,378000.00,16,7),
      (57,1,108000.00,17,8),(58,1,439000.00,17,6),(59,1,108000.00,18,8),(60,1,439000.00,18,6),
      (61,1,54000.00,18,9),(62,1,378000.00,18,7),(63,1,108000.00,19,8),(64,1,439000.00,19,6),
      (65,1,54000.00,19,9),(66,1,378000.00,19,7),(67,1,108000.00,20,8),(68,1,439000.00,20,6),
      (69,1,54000.00,20,9),(70,1,378000.00,20,7),(71,1,108000.00,21,8),(72,1,439000.00,21,6),
      (73,1,54000.00,21,9),(74,1,378000.00,21,7),(75,1,108000.00,22,8),(76,1,439000.00,22,6),
      (77,1,54000.00,22,9),(78,1,378000.00,22,7),(79,1,108000.00,23,8),(80,1,439000.00,23,6),
      (81,1,54000.00,23,9),(82,1,378000.00,23,7),(83,1,108000.00,24,8),(84,1,439000.00,24,6),
      (85,1,54000.00,24,9),(86,1,378000.00,24,7),(87,1,108000.00,25,8),(88,1,439000.00,25,6),
      (89,1,54000.00,25,9),(90,1,378000.00,25,7),(91,1,108000.00,26,8),(92,1,439000.00,26,6),
      (93,1,54000.00,26,9),(94,1,378000.00,26,7),(95,1,108000.00,27,8),(96,1,439000.00,27,6),
      (97,1,54000.00,27,9),(98,1,378000.00,27,7),(99,1,108000.00,28,8),(100,1,439000.00,28,6),
      (101,1,54000.00,28,9),(102,1,378000.00,28,7),(103,1,108000.00,29,8),(104,1,439000.00,29,6),
      (105,1,54000.00,29,9),(106,2,378000.00,29,7)
      ON CONFLICT DO NOTHING;
    `);

        // product_images
        await queryRunner.query(`
      INSERT INTO public.product_images (image_id, image_url, alt_text, is_primary, product_id) VALUES
      (1,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1757995711/dudhjbk1sq1orgm8cynh.png',NULL,false,1),
      (2,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1757995718/iuhp40d6sfwqxz3cfhxk.png',NULL,false,1),
      (3,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1757995731/stfp3cgubrgaxcv9dehk.png',NULL,false,1),
      (4,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758072957/xmrjjkcqhxlefbpbeavy.png',NULL,false,2),
      (5,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758072958/dsfdo84ydb6cmiwn7ekp.png',NULL,false,2),
      (6,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758072959/bc2vgpw76cdeetcn5l5f.png',NULL,false,2),
      (7,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758072959/fvygdmuttnvfxtcriyai.png',NULL,false,2),
      (12,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073151/ghjmmbyczggkinptlxhq.png',NULL,false,4),
      (13,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073152/hmoxd2inu6jzmuq2gemy.png',NULL,false,4),
      (14,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073153/kdumhybjm6ojzcnst7zw.png',NULL,false,4),
      (15,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073154/epvhr6tn8c2m3igodqfs.png',NULL,false,4),
      (20,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073253/v2sfcnjtmhczk2kfnka0.jpg',NULL,false,6),
      (21,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073254/hnwjzkrco664cvlwpfeb.jpg',NULL,false,6),
      (22,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073352/hquatfltex1ynxnbmh1j.png',NULL,false,7),
      (23,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073355/ccnfft1haut5pqkhhesi.png',NULL,false,7),
      (24,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073355/zacwprfyy1g6usta7j17.png',NULL,false,7),
      (25,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073358/wvgsezjnzwurjqcvomp1.png',NULL,false,7),
      (26,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073798/qp78nkgbruv2tog5qgrd.jpg',NULL,false,8),
      (27,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073863/nigmqi5qyctqe1wj2pb7.jpg',NULL,false,9)
      ON CONFLICT DO NOTHING;
    `);

        // products
        await queryRunner.query(`
      INSERT INTO public.products
      (product_id, product_name, sku, long_description, short_description, status, price, stock_quantity, created_at, updated_at, category_id)
      VALUES
      (1, 'Module GPS+BDS ATGM336H (kèm dây, anten giao tiếp UART và hộp)', 'SKU-1757995730604',
        $$<p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Module GPS BDS ATGM336H định vị có thiết kế nhỏ gọn sử dụng IC chính SoC GNSS AT6558 thế hệ thứ 4, với khả năng tiết kiệm năng lượng vượt trội, mạch bắt tín hiệu định vị và thời gian nên các hệ thống GPS/US, Beidou/CN, GLONASS/RU, Galileo/EU, QZSS/JP, SBAS/enhanced system qua 32 kênh tracking chanel.</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Mạch định vị GPS BDS ATGM336H có chuẩn đầu ra tín hiệu của mạch tương thích với các module của Ublox (NEO-6M / NEO-7/ NEO-M8N) nên có thể thay thế dễ dàng, sử dụng chung code mẫu Arduino và phần mềm U-Center trên máy tính, phù hợp với các ứng dụng định vị vị trí và lấy thời gian qua GPS.</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Module GPS có 4 chân, và mỗi chân có chức năng như sau:</span></p><table><tbody><tr><td data-row="1"><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">STT</strong></td><td data-row="1"><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Chân</strong></td><td data-row="1"><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Chức năng</strong></td></tr><tr><td data-row="2"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">1</span></td><td data-row="2"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">GND</span></td><td data-row="2"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Nối đất</span></td></tr><tr><td data-row="3"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">2</span></td><td data-row="3"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">VCC</span></td><td data-row="3"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Cấp nguồn (3.3V)</span></td></tr><tr><td data-row="4"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">3</span></td><td data-row="4"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">RX</span></td><td data-row="4"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Đầu nhận tín hiệu</span></td></tr><tr><td data-row="5"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">4</span></td><td data-row="5"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">TX</span></td><td data-row="5"><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Đầu gửi tín hiệu</span></td></tr></tbody></table><h2><strong style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);">Thông số kỹ thuật của module GPS định vị</strong></h2><ol><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Điện áp cấp: 3.3~ 5VDC</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">IC chính: SoC GNSS AT6558</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Giao tiếp UART/TTL.</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Baudrate: 9600 (Default), 1200, 2400, 4800, 19200, 38400, 57600, 115200, 230400, 460800, 921600.</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Tracking channels: 32</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">GNSS engine for GPS/US, Beidou/CN, GLONASS/RU, Galileo/EU, QZSS/JP, SBAS/enhanced system.</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Support A-GNSS</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Cold start capture sensitivity: -148dBm</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Tracking sensitivity: -162dBm</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Positioning accuracy: 2.5 meters (CEP50, open area)</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">First positioning time: 32 seconds</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Low power consumption: continuous operation <25mA (@ 3.3V)</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Kích thước: 15.7 x 13.1 mm</span></li></ol><p><br></p>$$,
        $$Module GPS BDS ATGM336H định vị có thiết kế nhỏ gọn sử dụng IC chính SoC GNSS AT6558 thế hệ thứ 4, với khả năng tiết kiệm năng lượng vượt trội, mạch bắt tín hiệu định vị và thời gian nên các hệ thống GPS/US, Beidou/CN, GLONASS/RU, Galileo/EU, QZSS/JP, SBAS/enhanced system qua 32 kênh tracking chanel.$$,
        1, 2000000.00, 1, '2025-09-16 04:08:52.529988', '2025-09-16 04:08:52.529988', 2
      ),
      (2, 'Robot giáo dục STEM Rover V2', 'SKU-1758072957128',
        $$<p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Robot STEM Rover – Coding kit sử dụng mạch lập trình </span><strong style="background-color: initial; color: rgb(254, 70, 65);"><a href="https://ohstem.vn/product/bo-stem-kit-yolobit-starter-pack-v4/" rel="noopener noreferrer" target="_blank">Yolo:Bit</a></strong><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">, giúp làm quen với thế giới lập trình Robot dễ dàng và thú vị. Các bạn có thể tự tay lắp ráp, điều khiển và lập trình các tính năng hấp dẫn của một chú Robot theo phương pháp giáo dục STEM hiện đại.</span></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/MzJu-qNp4VA?feature=oembed&amp;enablejsapi=1&amp;origin=https://ohstem.vn" height="360" width="640"></iframe><p><br></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Rover có lối thiết kế nhỏ gọn, dễ dàng lắp ráp và có khả năng mở rộng cao, tích hợp AI &amp; IoT – phù hợp cho giảng dạy STEM.</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2024/06/Robot-stem-rover-version-2-tai-ohstem-tich-hop-AI.png" alt="Robot STEM Rover version 2 tại OhStem - Robot tích hợp IAI" height="296" width="700"></span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2024/06/Robot-stem-rover-version-2-tai-ohstem-tich-hop-iot.png" alt="Robot STEM Rover version 2 tại OhStem - Robot tích hợp IoT" height="337" width="700"></span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2024/07/Robot-STEM-rover-version-2-tai-ohstem-13.png" alt="Robot Rover v2 tại OHStem với nhiều tính năng dò đường, né vật cản thú vị" height="365" width="700"></span></p><h2 class="ql-align-center"><strong style="background-color: rgb(255, 255, 255); color: rgb(26, 26, 26);">Cải tiến mới trên robot Rover version 2</strong></h2><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2024/07/Robot-STEM-rover-version-2-tai-ohstem-7.png" alt="Robot STEM Rover v2 tại OhStem đã nâng cấp nguồn điện mạnh mẽ hơn" height="467" width="700"><img src="https://ohstem.vn/wp-content/uploads/2024/07/Robot-STEM-rover-version-2-tai-ohstem-8.png" alt="Robot STEM Rover v2 tại OhStem đã nâng cấp cảm biến dò line" height="467" width="700"></span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2024/07/Robot-STEM-rover-version-2-tai-ohstem-6-1.png" alt="Robot STEM Rover v2 tại OhStem có thêm đèn báo pin" height="467" width="700"></span></p><ol><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Nâng cấp nguồn điện:</strong><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"> Giúp robot chạy nhanh hơn, hỗ trợ động cơ Servo loại lớn như MG995/MG996 và hạn chế hư hỏng khi sử dụng sai cốc sạc</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Tự động học đường line bằng chỉ bằng 1 nút nhấn:</strong><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"> Độ chính xác cao và nhanh chóng hơn so với vặn biến trở như v1, tiết kiệm thời gian và công sức cho bạn, đặc biệt là với người mới tiếp cận robot.</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Đèn báo pin:</strong><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"> Theo dõi lượng pin hiện tại trong robot, giúp người dùng chủ động hơn trong việc sử dụng</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Nút nhấn nguồn:</strong><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"> Bật và tắt robot dễ dàng hơn</span></li></ol><p><br></p>$$,
        $$Robot STEM Rover là dòng robot có lối thiết kế nhỏ gọn, dễ dàng lắp ráp và có khả năng mở rộng cao, tích hợp AI & IoT – phù hợp cho giảng dạy STEM.Phiên bản 2 có nhiều cải tiến mới, để bạn sử dụng dễ dàng hơn.$$,
        123, 2000000.00, 1, '2025-09-17 01:36:00.347634', '2025-09-17 01:36:00.347634', 4
      ),
      (4, 'Phụ kiện Rover – Kit xe tăng', 'SKU-1758073151552',
        $$<p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Bộ phụ kiện giúp nâng cấp </span><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">robot Rover</strong><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"> thành robot xe tăng vượt địa hình mạnh mẽ! Sản phẩm có thể di chuyển tốt trên các địa hình gồ ghề, cho phép chúng ta sáng tạo nhiều ứng dụng hơn, đặc biệt là trong các cuộc thi Robocon.</span></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/CPhZ2tD2kxM?feature=oembed" height="360" width="640"></iframe><p><br></p><h2 class="ql-align-center"><strong style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);">Dễ dàng lắp ráp và sử dụng</strong></h2><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Sản phẩm gồm bánh xích nhựa với độ bám cao và các thanh Lego® dễ dàng lắp ráp, mang đến trải nghiệm Robotics thú vị. Đây là phụ kiện Robotics lý tưởng để trẻ em tiếp cận với cơ khí và kỹ thuật.</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Bộ phụ kiện có chất liệu nhựa bền, với thiết kế an toàn cho trẻ em và màu sắc trắng, xanh, đen đẹp mắt.</span></p><h2 class="ql-align-center"><strong style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);">Vượt địa hình mạnh mẽ</strong></h2><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Trong các cuộc thi Robocon, Rover xe tăng có thể dễ dàng vượt qua các địa hình nghiêng dốc, các bề mặt không bằng phẳng,… để hoàn thành thử thách đặt ra.</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Bạn cũng có thể ứng dụng sản phẩm này để sáng tạo các cuộc đua robot ngoài trời, điều khiển robot vượt qua các địa hình đất đá theo mọi hướng: tiến, lùi, trái, phải hoặc quay góc dễ dàng, để về tới đích nhanh nhất!</span></p><h2 class="ql-align-center"><strong style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);">Thành phần sản phẩm</strong></h2><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2023/08/phu-kien-rover-tank.jpg" alt="Robot Tank Rover bao gồm những gì?" height="600" width="600"></span></p><p><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Lưu ý: Đây là phụ kiện riêng lẻ, bạn cần có robot Rover để sử dụng. </strong><strong style="background-color: initial; color: rgb(254, 70, 65);"><a href="https://ohstem.vn/product/robot-stem-rover/" rel="noopener noreferrer" target="_blank">Mua Rover tại đây</a></strong></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2023/01/robot-tank-rover-ket-hop-rover.jpg" alt="Kit xe tăng kết hợp robot Rover" height="600" width="600"></span></p><h2 class="ql-align-center"><strong style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);">Hướng dẫn lắp ráp</strong></h2><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Bộ phụ kiện được thiết kế để nâng cấp robot Rover thành robot xe tăng. Tham khảo hướng dẫn:</span></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/3tUX7bidhsE?feature=oembed" height="360" width="640"></iframe><p><br></p><p><br></p>$$,
        $$Bộ phụ kiện giúp nâng cấp robot Rover thành robot xe tăng vượt địa hình mạnh mẽ!Lưu ý: Đây là phụ kiện riêng lẻ, bạn cần có robot Rover để sử dụng. Mua Rover tại đây(Giá bán đã bao gồm thuế GTGT)Out of stock$$,
        123, 439000.00, 1, '2025-09-17 01:39:14.771563', '2025-09-17 01:39:14.771563', 4
      ),
      (6, 'Tay gắp Robot Gripper – Rover', 'SKU-1758073252274',
        $$<h3 class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);">Sản phẩm đã ngưng sản xuất. Trải nghiệm phiên bản nâng cấp </span><strong style="background-color: initial; color: rgb(254, 70, 65);"><a href="https://ohstem.vn/product/tay-gap-2-bac/" rel="noopener noreferrer" target="_blank">tay gắp robot 2 bậc</a></strong><span style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);"> kết hợp nâng và gắp!</span></h3><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Tay gắp Robot Rover được thiết kế từ động cơ Servo MG90S, cho khả năng gắp và thả vật linh hoạt, dễ dàng.</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Đây là phụ kiện mở rộng của robot STEM Rover. Bạn có thể tham khảo mua robot Rover </span><strong style="background-color: initial; color: rgb(254, 70, 65);"><a href="https://ohstem.vn/product/robot-stem-rover/" rel="noopener noreferrer" target="_blank">tại đây</a></strong></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/J46WzkG8D4I?feature=oembed&amp;enablejsapi=1&amp;origin=https://ohstem.vn" height="360" width="640"></iframe><h2><br></h2><p><br></p>$$,
        $$Sản phẩm đã ngưng sản xuất. Trải nghiệm phiên bản nâng cấp tay gắp robot 2 bậc kết hợp nâng và gắp!$$,
        123, 439000.00, 1, '2025-09-17 01:40:55.486836', '2025-09-17 01:40:55.486836', 4
      ),
      (7, 'Đầu nâng Robot Rover', 'SKU-1758073355687',
        $$<p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Đầu nâng Robot Rover là thiết bị giúp Rover có thể nâng đồ vật lên xuống một cách đơn giản. Bạn có thể ứng dụng đầu nâng này vào các cuộc thi đấu Robocon để thực hiện những nhiệm vụ, thử thách tùy theo quy tắc của cuộc thi.</span></p>$$,
        $$Sử dụng Servo MG90S cho lực kéo khỏe, độ bền caoLà bộ kit mở rộng của Robot Rover$$,
        123, 378000.00, 1, '2025-09-17 01:42:38.908384', '2025-09-17 01:42:38.908384', 4
      ),
      (8, 'Sa bàn giảng dạy Robotics khổ A0 in hiflex', 'SKU-1758073796293',
        $$<p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Sa bàn giảng dạy Robotics khổ A0 in bạt được dùng để hỗ trợ trong các buổi dạy và học về Robotics. Sản phẩm được thiết kế để hỗ trợ robot thực hiện nhiều thử thách khác nhau, từ robot đi theo vạch đen, robot gắp vật thể cho đến né tránh vật cản,… tùy thích.</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2023/04/sa-ban-giang-day-robotics-kho-a0-in-bat-2.jpg" alt="Các thử thách trên sa bàn giảng dạy Robotics khổ A0" height="471" width="716">Một số thử thách mẫu trên sa bàn</span></p><p><br></p>$$,
        $$Sa bàn giảng dạy Robotics khổ A0 in bạt được dùng để hỗ trợ trong các buổi dạy và học về Robotics. Sản phẩm được thiết kế để hỗ trợ robot thực hiện nhiều thử thách khác nhau, từ robot đi theo vạch đen, robot gắp vật thể cho đến né tránh vật cản,… tùy thích.$$,
        4, 108000.00, 1, '2025-09-17 01:49:59.515704', '2025-09-17 01:49:59.515704', 6
      ),
      (9, 'Sa bàn giảng dạy khổ A0', 'SKU-1758073860534',
        $$<p><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Sa bàn giảng dạy khổ A0</strong><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"> này được sử dụng để phục vụ cho các dự án robot dò line trong giảng dạy hoặc thi đấu robot trong các buổi học.</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2022/03/bang-do-do-line-a0-robot.jpg" alt="Bản đồ dò line xBot - kích cỡ A0" height="600" width="600"></span></p><h2 class="ql-align-center"><strong style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);">Các nhiệm vụ trên sa bàn</strong></h2><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Với bản đồ này, bạn có thể cho robot thực hiện những nhiệm vụ sau, theo thứ tự từ dễ đến khó:</span></p><p><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">1. Robot di chuyển và tự dừng trước vạch đen</strong></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Ở phần này, robot cần nhận diện và phát hiện vạch đen trước mặt:</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2021/09/Robot-dung-truoc-vach-den.jpg" alt="Robot dừng trước vạch đen" height="300" width="420"></span></p><p><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">2. Robot qua đường và tự dừng lại</strong></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2021/09/robot-qua-duong.jpg" alt="Robot qua đường" height="300" width="420"></span></p><p><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">3. Robot dò đường – Tự đi theo vạch đen</strong></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Robot sẽ tự dò đường và đi 1 vòng trên sa bàn.</span></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2021/09/robot-do-duong.jpg" alt="Robot dò đường" height="300" width="420"></span></p><p><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">4. Robot dò đường kết hợp né vật cản</strong></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2021/08/do_line_ne_vat_can.png" alt="Nhiệm vụ robot dò line &amp; né vật cản trên bản đồ dò line" height="470" width="614"></span></p><p><strong style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">5. Robot tự đậu xe vào bãi xe số 3 bằng cách nhận diện các vạch đen</strong></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2021/08/robot_dau_xe.png" alt="Robot đậu xe trên bản đồ dò line kích cỡ A0" height="260" width="600"></span></p><p><strong style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);">6. Robot tự động tìm kiếm và đậu xe vào bất kỳ bãi xe nào còn chỗ trống:</strong></p><p><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);"><img src="https://ohstem.vn/wp-content/uploads/2020/01/1-ban-do-do-line-kich-co-A0.jpg" alt="Bản đồ dò line kích cỡ A0" height="295" width="600"></span></p><h2><strong style="background-color: rgb(255, 255, 255); color: rgb(34, 34, 34);">Thành phần sản phẩm</strong></h2><ol><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">1 x sa bàn kích cỡ A0, chất liệu bằng giấy hoặc bạt tùy chọn</span></li><li data-list="bullet"><span class="ql-ui" contenteditable="false"></span><span style="background-color: rgb(255, 255, 255); color: rgb(68, 68, 68);">Luật thi tham khảo kèm hướng dẫn (xem online)</span></li></ol><p><br></p>$$,
        $$Sa bàn giảng dạy khổ A0 này được sử dụng để phục vụ cho các dự án robot dò line trong giảng dạy hoặc thi đấu robot trong các buổi học.$$,
        4, 54000.00, 1, '2025-09-17 01:51:03.760706', '2025-09-17 01:51:03.760706', 7
      )
      ON CONFLICT DO NOTHING;
    `);

        // user_profile_individual
        await queryRunner.query(`
      INSERT INTO public.user_profile_individual (user_id, full_name, date_of_birth)
      VALUES (84, 'Nguyen Xuan Danh', '2025-09-05')
      ON CONFLICT DO NOTHING;
    `);

        // users
        await queryRunner.query(`
      INSERT INTO public.users (user_id, username, email, password_hash, full_name, role, created_at, customer_type, avatar_url, images_url, address, phone_number) VALUES
      (9,  'Nguyễn Xuân Danh', 'danh010500@gmail.com', '$2b$10$C96tVNrwpgdR0wvF71zhZOD/KO1SWZRD7BfWBDaE7VLg.GW/nlA/S', NULL, 'customer', '2025-09-18 07:20:15.494312', NULL, NULL, NULL, NULL, NULL),
      (10, 'Danh', 'danh@gmail.com', '$2b$10$TUK83pDiJczyuxwBH0ndQew16edIC8OsxudIrBFBMKHy04TJQTpOm', NULL, 'customer', '2025-09-18 10:00:46.05424', NULL, NULL, NULL, NULL, NULL),
      (84, 'danh0105001', 'danh0105010@gmail.com', NULL, NULL, 'customer', '2025-09-26 03:35:27.89795', 'individual', NULL, NULL, NULL, NULL)
      ON CONFLICT DO NOTHING;
    `);

        // sequences
        await queryRunner.query(`SELECT setval('public.addresses_address_id_seq', 22, true);`);
        await queryRunner.query(`SELECT setval('public.attributes_attribute_id_seq', 1, false);`);
        await queryRunner.query(`SELECT setval('public.banners_banner_id_seq', 1, false);`);
        await queryRunner.query(`SELECT setval('public.cart_items_cart_item_id_seq', 23, true);`);
        await queryRunner.query(`SELECT setval('public.carts_cart_id_seq', 20, true);`);
        await queryRunner.query(`SELECT setval('public.categories_category_id_seq', 7, true);`);
        await queryRunner.query(`SELECT setval('public.migrations_id_seq', 1, true);`);
        await queryRunner.query(`SELECT setval('public.order_items_order_item_id_seq', 106, true);`);
        await queryRunner.query(`SELECT setval('public.orders_order_id_seq', 29, true);`);
        await queryRunner.query(`SELECT setval('public.product_attribute_values_value_id_seq', 1, false);`);
        await queryRunner.query(`SELECT setval('public.product_images_image_id_seq', 27, true);`);
        await queryRunner.query(`SELECT setval('public.products_product_id_seq', 9, true);`);
        await queryRunner.query(`SELECT setval('public.promotion_applicability_applicability_id_seq', 1, false);`);
        await queryRunner.query(`SELECT setval('public.promotions_promotion_id_seq', 1, false);`);
        await queryRunner.query(`SELECT setval('public.users_user_id_seq', 85, true);`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // revert in order of FKs
        await queryRunner.query(`DELETE FROM public.order_items WHERE order_item_id BETWEEN 9 AND 106;`);
        await queryRunner.query(`DELETE FROM public.orders WHERE order_id BETWEEN 5 AND 29;`);
        await queryRunner.query(`DELETE FROM public.product_images WHERE image_id IN (1,2,3,4,5,6,7,12,13,14,15,20,21,22,23,24,25,26,27);`);
        await queryRunner.query(`DELETE FROM public.products WHERE product_id IN (1,2,4,6,7,8,9);`);
        await queryRunner.query(`DELETE FROM public.addresses WHERE address_id = 22;`);
        await queryRunner.query(`DELETE FROM public.carts WHERE cart_id IN (1,2,20);`);
        await queryRunner.query(`DELETE FROM public.categories WHERE category_id IN (1,2,4,5,6,7);`);
        await queryRunner.query(`DELETE FROM public.migrations WHERE id = 1;`);
        await queryRunner.query(`DELETE FROM public.user_profile_individual WHERE user_id = 84;`);
        await queryRunner.query(`DELETE FROM public.users WHERE user_id IN (9,10,84);`);
    }
}
