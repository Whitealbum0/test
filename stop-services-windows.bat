@echo off
chcp 65001 >nul
echo.
echo 🛑 Остановка portfolio сервисов (Windows)
echo.

echo 🔍 Поиск запущенных процессов...

REM Останавливаем процессы по портам
echo 🔄 Остановка backend (порт 8001)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8001') do (
    taskkill /F /PID %%a >nul 2>&1
    if not errorlevel 1 echo ✅ Backend процесс (PID: %%a) остановлен
)

echo 🔄 Остановка frontend (порт 3000)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000') do (
    taskkill /F /PID %%a >nul 2>&1
    if not errorlevel 1 echo ✅ Frontend процесс (PID: %%a) остановлен
)

REM Останавливаем процессы по именам
echo 🔄 Остановка Python/uvicorn процессов...
taskkill /F /IM python.exe /T >nul 2>&1
if not errorlevel 1 echo ✅ Python процессы остановлены

echo 🔄 Остановка Node.js процессов...
taskkill /F /IM node.exe /T >nul 2>&1
if not errorlevel 1 echo ✅ Node.js процессы остановлены

REM Проверяем что порты освободились
echo.
echo 🔍 Проверка портов...
netstat -an | findstr :3000 >nul 2>&1
if errorlevel 1 (
    echo ✅ Порт 3000: свободен
) else (
    echo ⚠️  Порт 3000: всё ещё занят
)

netstat -an | findstr :8001 >nul 2>&1
if errorlevel 1 (
    echo ✅ Порт 8001: свободен
) else (
    echo ⚠️  Порт 8001: всё ещё занят
)

echo.
echo ✅ Остановка сервисов завершена!
echo.
echo 💡 Для повторного запуска используйте:
echo • start-production-windows.bat (production режим)
echo • start-windows.bat (development режим)
echo.
pause