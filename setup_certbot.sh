#!/bin/bash
domain=$DOMAIN
email=$EMAIL
echo "Domain from ENV: $domain"

apt update
apt install -y certbot curl lsb-release

# ขอใบรับรอง
# read -p "โปรดระบุโดเมนของคุณ (เช่น example.com): " DOMAIN
echo "Domain entered: $domain"
certbot certonly --standalone -d $domain --email $email --non-interactive --agree-tos

# แสดงข้อมูลการต่ออายุใบรับรอง
certbot renew --dry-run

echo "การตั้งค่าเสร็จสมบูรณ์! กรุณาตรวจสอบการตั้งค่าเซิร์ฟเวอร์ของคุณเพื่อใช้ใบรับรองนี้."

# สร้างไฟล์ config จาก template โดยอิงตาม env
envsubst '$DOMAIN,$BACKEND_SERVICE' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# สั่งให้ Nginx โหลด config ใหม่
nginx -s reload