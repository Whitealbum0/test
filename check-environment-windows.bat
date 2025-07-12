@echo off
chcp 65001 >nul
echo.
echo 🔍 Проверка окружения для portfolio сайта (Windows)
echo.

REM Цвета для вывода
set "ESC="

echo ======================================
echo 📋 ПРОВЕРКА СИСТЕМНЫХ ТРЕБОВАНИЙ
echo ======================================

REM Проверка Python
echo 🐍 Проверка Python...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('python --version 2^>^&1') do echo ✅ %%i
) else (
    echo ❌ Python не найден
    echo 💡 Скачайте Python с https://python.org
    set "errors=1"
)

REM Проверка Node.js
echo.
echo 📦 Проверка Node.js...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('node --version 2^>^&1') do echo ✅ Node.js %%i
) else (
    echo ❌ Node.js не найден
    echo 💡 Скачайте Node.js с https://nodejs.org
    set "errors=1"
)

REM Проверка Yarn
echo.
echo 🧶 Проверка Yarn...
yarn --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('yarn --version 2^>^&1') do echo ✅ Yarn v%%i
) else (
    echo ❌ Yarn не найден
    echo 💡 Установите Yarn: npm install -g yarn
    set "errors=1"
)

REM Проверка Git
echo.
echo 🔄 Проверка Git...
git --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('git --version 2^>^&1') do echo ✅ %%i
) else (
    echo ⚠️  Git не найден (опционально)
    echo 💡 Скачайте Git с https://git-scm.com
)

REM Проверка curl
echo.
echo 🌐 Проверка curl...
curl --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ curl доступен
) else (
    echo ⚠️  curl не найден (опционально)
    echo 💡 curl входит в Windows 10 по умолчанию
)

echo.
echo ======================================
echo 📂 ПРОВЕРКА СТРУКТУРЫ ПРОЕКТА
echo ======================================

REM Проверка backend файлов
echo.
echo 🔧 Backend:
if exist "backend\server.py" (
    echo ✅ server.py найден
) else (
    echo ❌ backend\server.py не найден
    set "errors=1"
)

if exist "backend\requirements.txt" (
    echo ✅ requirements.txt найден
) else (
    echo ❌ backend\requirements.txt не найден
    set "errors=1"
)

REM Проверка frontend файлов
echo.
echo 🎨 Frontend:
if exist "frontend\package.json" (
    echo ✅ package.json найден
) else (
    echo ❌ frontend\package.json не найден
    set "errors=1"
)

if exist "frontend\src\App.js" (
    echo ✅ App.js найден
) else (
    echo ❌ frontend\src\App.js не найден
    set "errors=1"
)

echo.
echo ======================================
echo 🌐 ПРОВЕРКА ПОРТОВ
echo ======================================

REM Проверка занятости портов
echo.
echo 🔍 Проверка портов...
netstat -an | findstr :3000 >nul 2>&1
if errorlevel 1 (
    echo ✅ Порт 3000: свободен
) else (
    echo ⚠️  Порт 3000: занят
    echo 💡 Остановите процесс или используйте другой порт
)

netstat -an | findstr :8001 >nul 2>&1
if errorlevel 1 (
    echo ✅ Порт 8001: свободен
) else (
    echo ⚠️  Порт 8001: занят
    echo 💡 Остановите процесс или используйте другой порт
)

echo.
echo ======================================
echo 🛡️  ПРОВЕРКА БРАНДМАУЭРА
echo ======================================

echo.
echo 🔥 Проверка правил брандмауэра...
netsh advfirewall firewall show rule name="Portfolio Backend" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Правило для Backend (8001) не найдено
    echo 💡 Выполните: netsh advfirewall firewall add rule name="Portfolio Backend" dir=in action=allow protocol=TCP localport=8001
) else (
    echo ✅ Правило для Backend найдено
)

netsh advfirewall firewall show rule name="Portfolio Frontend" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Правило для Frontend (3000) не найдено
    echo 💡 Выполните: netsh advfirewall firewall add rule name="Portfolio Frontend" dir=in action=allow protocol=TCP localport=3000
) else (
    echo ✅ Правило для Frontend найдено
)

echo.
echo ======================================
echo 📊 РЕЗУЛЬТАТЫ ПРОВЕРКИ
echo ======================================

if defined errors (
    echo.
    echo ❌ Обнаружены проблемы!
    echo 💡 Исправьте указанные ошибки перед запуском
    echo.
    echo 📋 Что нужно сделать:
    echo 1. Установите отсутствующие компоненты
    echo 2. Проверьте структуру проекта
    echo 3. Освободите занятые порты
    echo 4. Настройте брандмауэр (при необходимости)
) else (
    echo.
    echo ✅ Окружение готово к работе!
    echo 🚀 Можете запускать приложение:
    echo.
    echo 🔧 Development: start-windows-improved.bat
    echo 🚀 Production: start-production-windows.bat
    echo 📊 Управление: PowerShell -ExecutionPolicy Bypass -File manage-services.ps1 status
)

echo.
echo 🛠️  Дополнительные инструменты:
echo • stop-services-windows.bat - остановка всех сервисов
echo • setup-ssl-windows.bat - настройка HTTPS
echo • manage-services.ps1 - PowerShell управление сервисами
echo.
pause