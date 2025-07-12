@echo off
echo.
echo 🛡️  Настройка брандмауэра Windows для Portfolio сайта
echo.

REM Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Этот скрипт требует права администратора!
    echo 💡 Запустите как администратор:
    echo    1. Щелкните правой кнопкой по файлу
    echo    2. Выберите "Запуск от имени администратора"
    echo.
    pause
    exit /b 1
)

echo ✅ Права администратора подтверждены
echo.

echo 🔥 Настройка правил брандмауэра...

REM Удаляем существующие правила (если есть)
echo 🗑️  Удаление старых правил...
netsh advfirewall firewall delete rule name="Portfolio Backend" >nul 2>&1
netsh advfirewall firewall delete rule name="Portfolio Frontend" >nul 2>&1
netsh advfirewall firewall delete rule name="Portfolio Backend Out" >nul 2>&1
netsh advfirewall firewall delete rule name="Portfolio Frontend Out" >nul 2>&1

REM Добавляем новые правила
echo 📥 Добавление правил для входящих соединений...

REM Backend (порт 8001)
netsh advfirewall firewall add rule name="Portfolio Backend" dir=in action=allow protocol=TCP localport=8001 description="Portfolio Backend API server"
if %errorlevel% equ 0 (
    echo ✅ Backend (8001): правило добавлено
) else (
    echo ❌ Backend (8001): ошибка добавления правила
)

REM Frontend (порт 3000)
netsh advfirewall firewall add rule name="Portfolio Frontend" dir=in action=allow protocol=TCP localport=3000 description="Portfolio Frontend React server"
if %errorlevel% equ 0 (
    echo ✅ Frontend (3000): правило добавлено
) else (
    echo ❌ Frontend (3000): ошибка добавления правила
)

echo 📤 Добавление правил для исходящих соединений...

REM Backend исходящие
netsh advfirewall firewall add rule name="Portfolio Backend Out" dir=out action=allow protocol=TCP localport=8001 description="Portfolio Backend API server outbound"
if %errorlevel% equ 0 (
    echo ✅ Backend исходящие: правило добавлено
) else (
    echo ❌ Backend исходящие: ошибка добавления правила
)

REM Frontend исходящие
netsh advfirewall firewall add rule name="Portfolio Frontend Out" dir=out action=allow protocol=TCP localport=3000 description="Portfolio Frontend React server outbound"
if %errorlevel% equ 0 (
    echo ✅ Frontend исходящие: правило добавлено
) else (
    echo ❌ Frontend исходящие: ошибка добавления правила
)

echo.
echo 🔍 Проверка созданных правил...
netsh advfirewall firewall show rule name="Portfolio Backend"
netsh advfirewall firewall show rule name="Portfolio Frontend"

echo.
echo ======================================
echo ✅ НАСТРОЙКА БРАНДМАУЭРА ЗАВЕРШЕНА
echo ======================================
echo.
echo 🌐 Доступ разрешен для портов:
echo • 3000 (Frontend React приложение)
echo • 8001 (Backend FastAPI сервер)
echo.
echo 📋 Что это означает:
echo • Локальный доступ: http://localhost:3000 и http://localhost:8001
echo • Сетевой доступ: http://ваш_IP:3000 и http://ваш_IP:8001
echo • Интернет доступ: требует настройки роутера
echo.
echo 🔧 Дополнительные настройки для интернет доступа:
echo 1. Настройте проброс портов в роутере
echo 2. Получите статический IP или используйте DDNS
echo 3. Настройте SSL сертификаты (setup-ssl-windows.bat)
echo.
echo 💡 Для отключения правил выполните:
echo netsh advfirewall firewall delete rule name="Portfolio Backend"
echo netsh advfirewall firewall delete rule name="Portfolio Frontend"
echo.
pause