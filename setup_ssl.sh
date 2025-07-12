#!/bin/bash

echo "🔒 Установка SSL сертификатов для HTTPS"

# Установка Certbot
sudo apt update
sudo apt install -y certbot

# Установка Nginx
sudo apt install -y nginx

# Создание конфигурации Nginx
sudo tee /etc/nginx/sites-available/portfolio << EOF
server {
    listen 80;
    server_name your-domain.com;  # Замените на ваш домен
    
    # Redirect HTTP to HTTPS
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl;
    server_name your-domain.com;  # Замените на ваш домен
    
    # SSL certificates (получить через certbot)
    # ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    # ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    # Frontend
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
    
    # Backend API
    location /api/ {
        proxy_pass http://localhost:8001/api/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

echo "✅ Конфигурация Nginx создана"
echo "🔧 Для завершения настройки:"
echo "1. Купите домен и направьте его на ваш IP: 34.121.6.206"
echo "2. Выполните: sudo certbot --nginx -d your-domain.com"
echo "3. Включите сайт: sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/"
echo "4. Перезапустите Nginx: sudo systemctl restart nginx"