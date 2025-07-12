@echo off
echo.
echo Starting portfolio site (Development mode - NPM version)
echo.

echo Setting up backend...
cd backend

REM Check virtual environment
if not exist "venv\Scripts\activate.bat" (
    echo Creating virtual environment...
    python -m venv venv
    if errorlevel 1 (
        echo Error creating virtual environment
        echo Make sure Python is installed and available in PATH
        pause
        exit /b 1
    )
    call venv\Scripts\activate.bat
    echo Installing dependencies...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo Error installing dependencies
        pause
        exit /b 1
    )
) else (
    call venv\Scripts\activate.bat
)

echo Backend environment ready
echo Starting FastAPI server...
start "Portfolio Backend" cmd /k "cd /d "%cd%" && call venv\Scripts\activate.bat && echo Backend running at http://localhost:8001 && echo API docs: http://localhost:8001/docs && uvicorn server:app --reload --host 0.0.0.0 --port 8001"

cd ..

echo.
echo Setting up frontend...
cd frontend

REM Check node_modules
if not exist "node_modules" (
    echo Installing dependencies with npm...
    npm install
    if errorlevel 1 (
        echo Error installing dependencies
        echo Make sure Node.js is installed
        pause
        exit /b 1
    )
)

echo Frontend environment ready
echo Starting React application...
start "Portfolio Frontend" cmd /k "cd /d "%cd%" && echo Frontend running at http://localhost:3000 && npm start"

cd ..

echo.
echo Servers started!
echo.
echo Available addresses:
echo Frontend: http://localhost:3000
echo Backend API: http://localhost:8001/docs
echo Admin panel: http://localhost:3000/admin
echo.
echo To stop use: stop-services-simple.bat
echo.
echo Waiting for services to start (30 sec)...
timeout /t 30 /nobreak >nul

echo Checking availability...
curl -s http://localhost:8001/api/ >nul 2>&1
if not errorlevel 1 (
    echo Backend: working
) else (
    echo Backend: check backend console
)

curl -s http://localhost:3000 >nul 2>&1
if not errorlevel 1 (
    echo Frontend: working
) else (
    echo Frontend: check frontend console
)

echo.
echo Development ready!
pause