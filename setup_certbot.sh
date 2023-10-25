#!/bin/bash

# ขั้นตอนการติดตั้ง Certbot
if [[ $(lsb_release -is) == "Ubuntu" ]]; then
    sudo apt update
    sudo apt install -y certbot
elif [[ $(lsb_release -is) == "CentOS" ]]; then
    sudo yum install -y epel-release
    sudo yum install -y certbot
else
    echo "ระบบปฏิบัติการนี้ไม่ได้รับการสนับสนุนในสคริปต์นี้"
    exit 1
fi

# ขอใบรับรอง
read -p "โปรดระบุโดเมนของคุณ (เช่น example.com): " DOMAIN
sudo certbot certonly --standalone -d $DOMAIN -d www.$DOMAIN

# แสดงข้อมูลการต่ออายุใบรับรอง
sudo certbot renew --dry-run

echo "การตั้งค่าเสร็จสมบูรณ์! กรุณาตรวจสอบการตั้งค่าเซิร์ฟเวอร์ของคุณเพื่อใช้ใบรับรองนี้."

# สร้างไฟล์ config จาก template โดยอิงตาม env
envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# สั่งให้ Nginx โหลด config ใหม่
nginx -s reload