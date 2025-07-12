@echo off
echo.
echo Starting portfolio site in production mode (NPM version)
echo.

REM Get external IP
echo Getting external IP...
for /f "delims=" %%i in ('curl -s ifconfig.me 2^>nul') do set EXTERNAL_IP=%%i

if "%EXTERNAL_IP%"=="" (
    echo Could not get external IP, using localhost
    set EXTERNAL_IP=localhost
) else (
    echo Your external IP: %EXTERNAL_IP%
)

echo.
echo Updating frontend configuration...

REM Create .env.production for frontend
cd frontend
if not exist .env.production (
    echo REACT_APP_BACKEND_URL=http://%EXTERNAL_IP%:8001 > .env.production
) else (
    del .env.production
    echo REACT_APP_BACKEND_URL=http://%EXTERNAL_IP%:8001 > .env.production
)
echo Frontend configuration updated
cd ..

echo.
echo Starting backend server...

REM Check virtual environment
cd backend
if not exist "venv\Scripts\activate.bat" (
    echo Creating virtual environment...
    python -m venv venv
    call venv\Scripts\activate.bat
    pip install -r requirements.txt
) else (
    call venv\Scripts\activate.bat
)

REM Start backend in background
echo Starting FastAPI server...
start /min "Portfolio Backend" cmd /c "cd /d "%cd%" && call venv\Scripts\activate.bat && uvicorn server:app --host 0.0.0.0 --port 8001"

echo Backend started on port 8001
cd ..

echo.
echo Starting frontend...
cd frontend

REM Check node_modules
if not exist "node_modules" (
    echo Installing dependencies with npm...
    npm install
)

REM Start frontend in background
echo Starting React application...
start /min "Portfolio Frontend" cmd /c "cd /d "%cd%" && set REACT_APP_ENV=production && npm start"

echo Frontend started on port 3000
cd ..

REM Wait for startup
echo.
echo Waiting for services to start...
timeout /t 5 /nobreak >nul

echo.
echo Checking service availability...

REM Check backend
curl -s http://localhost:8001/api/ >nul 2>&1
if not errorlevel 1 (
    echo Backend API: available
) else (
    echo Backend API: unavailable
)

REM Check frontend
curl -s http://localhost:3000 >nul 2>&1
if not errorlevel 1 (
    echo Frontend: available
) else (
    echo Frontend: unavailable
)

echo.
echo =====================================
echo Site should be available at:
echo Frontend: http://%EXTERNAL_IP%:3000
echo API: http://%EXTERNAL_IP%:8001
echo API docs: http://%EXTERNAL_IP%:8001/docs
echo =====================================
echo.
echo Router settings for internet access:
echo Port 3000 -^> %EXTERNAL_IP%:3000 (HTTP)
echo Port 8001 -^> %EXTERNAL_IP%:8001 (API)
echo.
echo Don't forget:
echo 1. Configure port forwarding in router
echo 2. Open ports in Windows firewall
echo 3. Setup SSL certificates for HTTPS
echo.
echo To stop services use: stop-services-simple.bat
echo.
pause