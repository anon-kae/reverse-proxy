#!/bin/bash
apt update
apt install -y certbot curl lsb-release

# ขอใบรับรอง
read -p "โปรดระบุโดเมนของคุณ (เช่น example.com): " DOMAIN
sudo certbot certonly --standalone -d $DOMAIN -d www.$DOMAIN

# แสดงข้อมูลการต่ออายุใบรับรอง
sudo certbot renew --dry-run

echo "การตั้งค่าเสร็จสมบูรณ์! กรุณาตรวจสอบการตั้งค่าเซิร์ฟเวอร์ของคุณเพื่อใช้ใบรับรองนี้."

# สร้างไฟล์ config จาก template โดยอิงตาม env
envsubst '$DOMAIN,$BACKEND_SERVICE' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# สั่งให้ Nginx โหลด config ใหม่
nginx -s reload