@echo off
echo.
echo=== SIMPLE DIAGNOSTIC TEST ===
echo.

echo Step 1: Basic echo test
pause

echo Step 2: Check current directory
echo Current dir: %cd%
pause

echo Step 3: List files
dir
pause

echo Step 4: Check Python
python --version
echo Python check completed
pause

echo Step 5: Check Node
node --version
echo Node check completed
pause

echo Step 6: Check Yarn
yarn --version
echo Yarn check completed
pause

echo Step 7: Check project structure
if exist backend echo Backend folder found
if exist frontend echo Frontend folder found
if exist backend\server.py echo Backend server.py found
if exist frontend\package.json echo Frontend package.json found
pause

echo.
echo=== TEST COMPLETED ===
echo If you see this message, the batch file is working
echo.
pause
echo Press any key to exit...
pause >nul