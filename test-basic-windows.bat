@echo off
echo.
echo Test Windows batch functionality
echo.
echo Press any key to start testing...
pause

echo Checking Python...
python --version 2>nul
if errorlevel 1 (
    echo Python: NOT FOUND
) else (
    echo Python: OK
)
pause

echo.
echo Checking Node.js...
node --version 2>nul
if errorlevel 1 (
    echo Node.js: NOT FOUND
) else (
    echo Node.js: OK
)
pause

echo.
echo Checking Yarn...
yarn --version 2>nul
if errorlevel 1 (
    echo Yarn: NOT FOUND
) else (
    echo Yarn: OK
)
pause

echo.
echo Checking curl...
curl --version >nul 2>&1
if errorlevel 1 (
    echo curl: NOT FOUND
) else (
    echo curl: OK
)
pause

echo.
echo Checking ports...
netstat -an | findstr :3000 >nul 2>&1
if errorlevel 1 (
    echo Port 3000: FREE
) else (
    echo Port 3000: BUSY
)

netstat -an | findstr :8001 >nul 2>&1
if errorlevel 1 (
    echo Port 8001: FREE
) else (
    echo Port 8001: BUSY
)
pause

echo.
echo Checking project structure...
if exist "backend\server.py" (
    echo backend\server.py: FOUND
) else (
    echo backend\server.py: NOT FOUND
)

if exist "frontend\package.json" (
    echo frontend\package.json: FOUND
) else (
    echo frontend\package.json: NOT FOUND
)
pause

echo.
echo Basic test completed
echo If everything shows OK/FOUND - you can try main batch files
echo.
echo Press any key to exit...
pause