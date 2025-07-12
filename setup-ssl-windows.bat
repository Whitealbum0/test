@echo off
chcp 65001 >nul
echo.
echo 🔒 Настройка SSL сертификатов для HTTPS (Windows)
echo.

echo Этот скрипт поможет настроить HTTPS для вашего portfolio сайта на Windows.
echo.

echo 📋 Варианты настройки HTTPS на Windows:
echo.
echo 1. 🌐 Cloudflare (Рекомендуется)
echo    • Бесплатно
echo    • Простая настройка
echo    • Автоматическое обновление сертификатов
echo.
echo 2. 🔒 Let's Encrypt с nginx на Windows
echo    • Бесплатно
echo    • Требует настройки nginx
echo.
echo 3. 💰 Платный SSL сертификат
echo    • Покупка у провайдера
echo    • Установка в IIS или nginx
echo.

:menu
echo Выберите вариант:
echo [1] Инструкции по Cloudflare (Рекомендуется)
echo [2] Установка nginx + Let's Encrypt
echo [3] Инструкции по платным сертификатам
echo [4] Настройка самоподписанного сертификата (для тестирования)
echo [0] Выход
echo.
set /p choice="Введите номер варианта: "

if "%choice%"=="1" goto cloudflare
if "%choice%"=="2" goto nginx_setup
if "%choice%"=="3" goto paid_ssl
if "%choice%"=="4" goto self_signed
if "%choice%"=="0" goto end
goto menu

:cloudflare
echo.
echo 🌐 === НАСТРОЙКА CLOUDFLARE (РЕКОМЕНДУЕТСЯ) ===
echo.
echo 1. Зарегистрируйтесь на cloudflare.com
echo 2. Добавьте ваш домен в Cloudflare
echo 3. Измените DNS серверы домена на предоставленные Cloudflare
echo 4. В настройках Cloudflare:
echo    • SSL/TLS → Overview → Full (strict)
echo    • SSL/TLS → Edge Certificates → Always Use HTTPS: ON
echo.
echo 5. Создайте A записи:
echo    • @ → %EXTERNAL_IP% (корень домена)
echo    • www → %EXTERNAL_IP% (www поддомен)
echo.
echo 6. Настройте Page Rules (опционально):
echo    • *yourdomain.com/* → Always Use HTTPS
echo.
echo 7. Cloudflare автоматически предоставит SSL сертификат!
echo.
echo ✅ После настройки ваш сайт будет доступен по HTTPS
echo.
pause
goto menu

:nginx_setup
echo.
echo 🔒 === УСТАНОВКА NGINX + LET'S ENCRYPT ===
echo.
echo 1. Скачайте nginx для Windows: http://nginx.org/en/download.html
echo 2. Распакуйте в C:\nginx
echo.
echo 3. Создайте конфигурацию nginx...

REM Создаем директорию для nginx конфигурации
if not exist "nginx-config" mkdir nginx-config

REM Создаем базовую конфигурацию nginx
echo server { > nginx-config\portfolio.conf
echo     listen 80; >> nginx-config\portfolio.conf
echo     server_name your-domain.com www.your-domain.com; >> nginx-config\portfolio.conf
echo. >> nginx-config\portfolio.conf
echo     # Frontend >> nginx-config\portfolio.conf
echo     location / { >> nginx-config\portfolio.conf
echo         proxy_pass http://127.0.0.1:3000; >> nginx-config\portfolio.conf
echo         proxy_set_header Host $host; >> nginx-config\portfolio.conf
echo         proxy_set_header X-Real-IP $remote_addr; >> nginx-config\portfolio.conf
echo         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; >> nginx-config\portfolio.conf
echo         proxy_set_header X-Forwarded-Proto $scheme; >> nginx-config\portfolio.conf
echo     } >> nginx-config\portfolio.conf
echo. >> nginx-config\portfolio.conf
echo     # Backend API >> nginx-config\portfolio.conf
echo     location /api/ { >> nginx-config\portfolio.conf
echo         proxy_pass http://127.0.0.1:8001/api/; >> nginx-config\portfolio.conf
echo         proxy_set_header Host $host; >> nginx-config\portfolio.conf
echo         proxy_set_header X-Real-IP $remote_addr; >> nginx-config\portfolio.conf
echo         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; >> nginx-config\portfolio.conf
echo         proxy_set_header X-Forwarded-Proto $scheme; >> nginx-config\portfolio.conf
echo     } >> nginx-config\portfolio.conf
echo } >> nginx-config\portfolio.conf

echo ✅ Конфигурация nginx создана в nginx-config\portfolio.conf
echo.
echo 4. Скопируйте конфигурацию в C:\nginx\conf\
echo 5. Для SSL используйте win-acme: https://www.win-acme.com/
echo    • Скачайте win-acme
echo    • Запустите от имени администратора
echo    • Следуйте инструкциям для автоматического получения сертификата
echo.
echo 6. Запустите nginx:
echo    C:\nginx\nginx.exe
echo.
pause
goto menu

:paid_ssl
echo.
echo 💰 === ПЛАТНЫЕ SSL СЕРТИФИКАТЫ ===
echo.
echo 1. Купите SSL сертификат у провайдера:
echo    • GoDaddy, Namecheap, DigiCert и др.
echo.
echo 2. Получите файлы сертификата:
echo    • .crt или .pem файл (сертификат)
echo    • .key файл (приватный ключ)
echo.
echo 3. Установите сертификат в:
echo    • IIS (Internet Information Services)
echo    • или nginx для Windows
echo.
echo 4. Настройте переадресацию HTTP → HTTPS
echo.
pause
goto menu

:self_signed
echo.
echo 🛠️  === САМОПОДПИСАННЫЙ СЕРТИФИКАТ (ТОЛЬКО ДЛЯ ТЕСТИРОВАНИЯ) ===
echo.
echo ⚠️  ВНИМАНИЕ: Самоподписанные сертификаты НЕ подходят для production!
echo.
echo Для создания самоподписанного сертификата нужен OpenSSL.
echo.
echo 1. Установите OpenSSL для Windows
echo 2. Выполните команды:
echo.
echo openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
echo.
echo 3. Используйте cert.pem и key.pem в вашем веб-сервере
echo.
echo ⚠️  Браузеры будут показывать предупреждение о безопасности!
echo.
pause
goto menu

:end
echo.
echo 🔒 Настройка SSL завершена.
echo.
echo 📚 Дополнительные ресурсы:
echo • Cloudflare: https://www.cloudflare.com/
echo • Let's Encrypt: https://letsencrypt.org/
echo • nginx для Windows: http://nginx.org/
echo • win-acme: https://www.win-acme.com/
echo.
pause