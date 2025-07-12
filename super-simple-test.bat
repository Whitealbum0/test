@echo off
echo Hello! This is a test batch file.
echo.
echo Current directory: %cd%
echo.
echo Listing files:
dir /b
echo.
echo Testing Python:
python --version 2>nul
if errorlevel 1 (
    echo Python NOT found
) else (
    echo Python found
)
echo.
echo Testing Node:
node --version 2>nul  
if errorlevel 1 (
    echo Node NOT found
) else (
    echo Node found
)
echo.
echo This is the end of the test.
echo.
pause