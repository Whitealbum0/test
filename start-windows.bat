@echo off
echo Запуск сайта-визитки...
echo.

echo 1. Активация виртуального окружения...
cd backend
call venv\Scripts\activate

echo 2. Запуск backend сервера...
start cmd /k "cd /d %cd% && call venv\Scripts\activate && uvicorn server:app --reload --host 0.0.0.0 --port 8001"

echo 3. Запуск frontend...
cd ..\frontend
start cmd /k "cd /d %cd% && npm start"

echo.
echo Серверы запущены!
echo Frontend: http://localhost:3000
echo Backend API: http://localhost:8001/docs
echo Админ-панель: http://localhost:3000/admin
echo.
echo Для остановки закройте окна терминалов.
pause