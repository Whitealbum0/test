@echo off
chcp 65001 >nul
echo.
echo 🚀 Запуск portfolio сайта (Development режим)
echo.

echo 📦 Настройка backend...
cd backend

REM Проверяем виртуальное окружение
if not exist "venv\Scripts\activate.bat" (
    echo 📦 Создаем виртуальное окружение...
    python -m venv venv
    if errorlevel 1 (
        echo ❌ Ошибка создания виртуального окружения
        echo 💡 Убедитесь что Python установлен и доступен в PATH
        pause
        exit /b 1
    )
    call venv\Scripts\activate.bat
    echo 📦 Устанавливаем зависимости...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo ❌ Ошибка установки зависимостей
        pause
        exit /b 1
    )
) else (
    call venv\Scripts\activate.bat
)

echo ✅ Backend окружение готово
echo 🚀 Запуск FastAPI сервера...
start "Portfolio Backend" cmd /k "cd /d %cd% && call venv\Scripts\activate.bat && echo Backend запущен на http://localhost:8001 && echo API документация: http://localhost:8001/docs && uvicorn server:app --reload --host 0.0.0.0 --port 8001"

cd ..

echo.
echo 📦 Настройка frontend...
cd frontend

REM Проверяем node_modules
if not exist "node_modules" (
    echo 📦 Устанавливаем зависимости...
    yarn install
    if errorlevel 1 (
        echo ❌ Ошибка установки зависимостей
        echo 💡 Убедитесь что Node.js и Yarn установлены
        pause
        exit /b 1
    )
)

echo ✅ Frontend окружение готово
echo 🚀 Запуск React приложения...
start "Portfolio Frontend" cmd /k "cd /d %cd% && echo Frontend запущен на http://localhost:3000 && yarn start"

cd ..

echo.
echo ✅ Серверы запущены!
echo.
echo 📱 Доступные адреса:
echo • Frontend: http://localhost:3000
echo • Backend API: http://localhost:8001/docs
echo • Админ-панель: http://localhost:3000/admin
echo.
echo 🛑 Для остановки используйте: stop-services-windows.bat
echo 🚀 Для production запуска: start-production-windows.bat
echo.
echo ⏳ Ожидание запуска сервисов (30 сек)...
timeout /t 30 /nobreak >nul

echo 🔍 Проверка доступности...
curl -s http://localhost:8001/api/ >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend: работает
) else (
    echo ⚠️  Backend: проверьте консоль backend
)

curl -s http://localhost:3000 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend: работает
) else (
    echo ⚠️  Frontend: проверьте консоль frontend
)

echo.
echo 🎉 Разработка готова к работе!
pause