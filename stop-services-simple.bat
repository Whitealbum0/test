@echo off
echo.
echo Stopping portfolio services (Windows)
echo.

echo Finding running processes...

REM Stop processes by ports
echo Stopping backend (port 8001)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8001') do (
    taskkill /F /PID %%a >nul 2>&1
    if not errorlevel 1 echo Backend process (PID: %%a) stopped
)

echo Stopping frontend (port 3000)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000') do (
    taskkill /F /PID %%a >nul 2>&1
    if not errorlevel 1 echo Frontend process (PID: %%a) stopped
)

REM Stop processes by names
echo Stopping Python/uvicorn processes...
taskkill /F /IM python.exe /T >nul 2>&1
if not errorlevel 1 echo Python processes stopped

echo Stopping Node.js processes...
taskkill /F /IM node.exe /T >nul 2>&1
if not errorlevel 1 echo Node.js processes stopped

REM Check that ports are freed
echo.
echo Checking ports...
netstat -an | findstr :3000 >nul 2>&1
if errorlevel 1 (
    echo Port 3000: free
) else (
    echo Port 3000: still busy
)

netstat -an | findstr :8001 >nul 2>&1
if errorlevel 1 (
    echo Port 8001: free
) else (
    echo Port 8001: still busy
)

echo.
echo Service shutdown completed!
echo.
echo To restart use:
echo start-windows-simple.bat (development mode)
echo start-production-windows-fixed.bat (production mode)
echo.
pause