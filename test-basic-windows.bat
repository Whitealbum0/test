@echo off
chcp 65001 >nul
echo.
echo 🧪 Тест базовой функциональности Windows батников
echo.

echo 🔍 Проверка Python...
python --version
if %errorlevel% neq 0 (
    echo ❌ Python не найден
    goto :test_node
) else (
    echo ✅ Python найден
)

:test_node
echo.
echo 🔍 Проверка Node.js...
node --version
if %errorlevel% neq 0 (
    echo ❌ Node.js не найден
    goto :test_yarn
) else (
    echo ✅ Node.js найден
)

:test_yarn
echo.
echo 🔍 Проверка Yarn...
yarn --version
if %errorlevel% neq 0 (
    echo ❌ Yarn не найден
    goto :test_curl
) else (
    echo ✅ Yarn найден
)

:test_curl
echo.
echo 🔍 Проверка curl...
curl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ curl не найден
    goto :test_ports
) else (
    echo ✅ curl найден
)

:test_ports
echo.
echo 🔍 Проверка портов...
netstat -an | findstr :3000 >nul 2>&1
if errorlevel 1 (
    echo ✅ Порт 3000: свободен
) else (
    echo ⚠️  Порт 3000: занят
)

netstat -an | findstr :8001 >nul 2>&1
if errorlevel 1 (
    echo ✅ Порт 8001: свободен
) else (
    echo ⚠️  Порт 8001: занят
)

echo.
echo 🔍 Проверка структуры проекта...
if exist "backend\server.py" (
    echo ✅ backend\server.py найден
) else (
    echo ❌ backend\server.py не найден
)

if exist "frontend\package.json" (
    echo ✅ frontend\package.json найден
) else (
    echo ❌ frontend\package.json не найден
)

echo.
echo 🧪 Базовый тест завершен
echo Если все пункты с ✅ - можете пробовать запускать основные батники
echo.
pause