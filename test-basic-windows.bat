@echo off
echo.
echo Test Windows batch functionality
echo.

echo Checking Python...
python --version >nul 2>&1
if not errorlevel 1 (
    echo Python: OK
    goto test_node
) else (
    echo Python: NOT FOUND
    goto test_node
)

:test_node
echo.
echo Checking Node.js...
node --version >nul 2>&1
if not errorlevel 1 (
    echo Node.js: OK
    goto test_yarn
) else (
    echo Node.js: NOT FOUND
    goto test_yarn
)

:test_yarn
echo.
echo Checking Yarn...
yarn --version >nul 2>&1
if not errorlevel 1 (
    echo Yarn: OK
    goto test_curl
) else (
    echo Yarn: NOT FOUND
    goto test_curl
)

:test_curl
echo.
echo Checking curl...
curl --version >nul 2>&1
if not errorlevel 1 (
    echo curl: OK
    goto test_ports
) else (
    echo curl: NOT FOUND
    goto test_ports
)

:test_ports
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

echo.
echo Basic test completed
echo If everything shows OK/FOUND - you can try main batch files
echo.
pause