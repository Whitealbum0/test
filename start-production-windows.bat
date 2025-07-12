@echo off
chcp 65001 >nul
echo.
echo 🚀 Запуск portfolio сайта в production режиме (Windows)
echo.

REM Получаем внешний IP
echo 🌐 Определяем внешний IP...
for /f "delims=" %%i in ('curl -s ifconfig.me 2^>nul') do set EXTERNAL_IP=%%i

if "%EXTERNAL_IP%"=="" (
    echo ⚠️  Не удалось получить внешний IP, используем localhost
    set EXTERNAL_IP=localhost
) else (
    echo 🌐 Ваш внешний IP: %EXTERNAL_IP%
)

echo.
echo 📝 Обновляем конфигурацию frontend...

REM Создаем .env.production для frontend
cd frontend
if not exist .env.production (
    echo REACT_APP_BACKEND_URL=http://%EXTERNAL_IP%:8001 > .env.production
) else (
    del .env.production
    echo REACT_APP_BACKEND_URL=http://%EXTERNAL_IP%:8001 > .env.production
)
echo ✅ Конфигурация frontend обновлена
cd ..

echo.
echo 🔄 Запуск backend сервера...

REM Проверяем виртуальное окружение
cd backend
if not exist "venv\Scripts\activate.bat" (
    echo 📦 Создаем виртуальное окружение...
    python -m venv venv
    call venv\Scripts\activate.bat
    pip install -r requirements.txt
) else (
    call venv\Scripts\activate.bat
)

REM Запускаем backend в фоновом режиме
echo 🚀 Запуск FastAPI сервера...
start /min "Portfolio Backend" cmd /c "cd /d "%cd%" && call venv\Scripts\activate.bat && uvicorn server:app --host 0.0.0.0 --port 8001"

echo ✅ Backend запущен на порту 8001
cd ..

echo.
echo 🔄 Запуск frontend...
cd frontend

REM Проверяем node_modules
if not exist "node_modules" (
    echo 📦 Устанавливаем зависимости...
    yarn install
)

REM Запускаем frontend в фоновом режиме
echo 🚀 Запуск React приложения...
start /min "Portfolio Frontend" cmd /c "cd /d %cd% && set REACT_APP_ENV=production && yarn start"

echo ✅ Frontend запущен на порту 3000
cd ..

REM Ждем запуска
echo.
echo ⏳ Ожидание запуска сервисов...
timeout /t 5 /nobreak >nul

echo.
echo 📊 Проверяем доступность сервисов...

REM Проверяем backend
curl -s http://localhost:8001/api/ >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend API: доступен
) else (
    echo ❌ Backend API: недоступен
)

REM Проверяем frontend
curl -s http://localhost:3000 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend: доступен
) else (
    echo ❌ Frontend: недоступен
)

echo.
echo =====================================
echo ✅ Сайт должен быть доступен по адресам:
echo 🌐 Frontend: http://%EXTERNAL_IP%:3000
echo 🔗 API: http://%EXTERNAL_IP%:8001
echo 📚 API документация: http://%EXTERNAL_IP%:8001/docs
echo =====================================
echo.
echo 📋 Настройки роутера для доступа из интернет:
echo • Port 3000 → %EXTERNAL_IP%:3000 (HTTP)
echo • Port 8001 → %EXTERNAL_IP%:8001 (API)
echo.
echo ⚠️  Не забудьте:
echo 1. Настроить проброс портов в роутере
echo 2. Открыть порты в брандмауэре Windows
echo 3. Настроить SSL сертификаты для HTTPS (запустите setup-ssl-windows.bat)
echo.
echo 🛑 Для остановки сервисов используйте: stop-services-windows.bat
echo.
pause