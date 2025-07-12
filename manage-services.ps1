# Portfolio Services Manager для Windows
# PowerShell скрипт для управления сервисами

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("start", "stop", "restart", "status")]
    [string]$Action
)

# Настройки
$BackendPort = 8001
$FrontendPort = 3000
$ProjectPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Функция для отображения цветного текста
function Write-ColoredText {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

# Функция проверки процесса на порту
function Get-ProcessOnPort {
    param([int]$Port)
    $netstatOutput = netstat -ano | Select-String ":$Port"
    if ($netstatOutput) {
        $pid = ($netstatOutput -split '\s+')[-1]
        return $pid
    }
    return $null
}

# Функция остановки процесса на порту
function Stop-ProcessOnPort {
    param([int]$Port, [string]$ServiceName)
    $pid = Get-ProcessOnPort -Port $Port
    if ($pid) {
        try {
            Stop-Process -Id $pid -Force
            Write-ColoredText "✅ $ServiceName (PID: $pid) остановлен" "Green"
            return $true
        }
        catch {
            Write-ColoredText "❌ Ошибка остановки $ServiceName (PID: $pid)" "Red"
            return $false
        }
    }
    else {
        Write-ColoredText "ℹ️  $ServiceName не запущен" "Yellow"
        return $true
    }
}

# Функция запуска backend
function Start-Backend {
    Write-ColoredText "🚀 Запуск Backend..." "Cyan"
    $backendPath = Join-Path $ProjectPath "backend"
    
    # Проверяем виртуальное окружение
    $venvPath = Join-Path $backendPath "venv\Scripts\activate.bat"
    if (-not (Test-Path $venvPath)) {
        Write-ColoredText "📦 Создание виртуального окружения..." "Yellow"
        Set-Location $backendPath
        python -m venv venv
        & $venvPath
        pip install -r requirements.txt
    }
    
    # Запускаем backend
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "cmd.exe"
    $startInfo.Arguments = "/c `"cd /d $backendPath && call venv\Scripts\activate.bat && uvicorn server:app --host 0.0.0.0 --port $BackendPort`""
    $startInfo.UseShellExecute = $true
    $startInfo.WindowStyle = "Minimized"
    
    $process = [System.Diagnostics.Process]::Start($startInfo)
    Start-Sleep 3
    
    if (Get-ProcessOnPort -Port $BackendPort) {
        Write-ColoredText "✅ Backend запущен на порту $BackendPort" "Green"
        return $true
    }
    else {
        Write-ColoredText "❌ Ошибка запуска Backend" "Red"
        return $false
    }
}

# Функция запуска frontend
function Start-Frontend {
    Write-ColoredText "🚀 Запуск Frontend..." "Cyan"
    $frontendPath = Join-Path $ProjectPath "frontend"
    
    # Проверяем node_modules
    $nodeModulesPath = Join-Path $frontendPath "node_modules"
    if (-not (Test-Path $nodeModulesPath)) {
        Write-ColoredText "📦 Установка зависимостей..." "Yellow"
        Set-Location $frontendPath
        yarn install
    }
    
    # Запускаем frontend
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "cmd.exe"
    $startInfo.Arguments = "/c `"cd /d $frontendPath && yarn start`""
    $startInfo.UseShellExecute = $true
    $startInfo.WindowStyle = "Minimized"
    
    $process = [System.Diagnostics.Process]::Start($startInfo)
    Start-Sleep 5
    
    if (Get-ProcessOnPort -Port $FrontendPort) {
        Write-ColoredText "✅ Frontend запущен на порту $FrontendPort" "Green"
        return $true
    }
    else {
        Write-ColoredText "❌ Ошибка запуска Frontend" "Red"
        return $false
    }
}

# Функция проверки статуса
function Get-ServicesStatus {
    Write-ColoredText "📊 Статус сервисов:" "Cyan"
    
    $backendPid = Get-ProcessOnPort -Port $BackendPort
    if ($backendPid) {
        Write-ColoredText "✅ Backend: работает (PID: $backendPid, порт: $BackendPort)" "Green"
    }
    else {
        Write-ColoredText "❌ Backend: не запущен" "Red"
    }
    
    $frontendPid = Get-ProcessOnPort -Port $FrontendPort
    if ($frontendPid) {
        Write-ColoredText "✅ Frontend: работает (PID: $frontendPid, порт: $FrontendPort)" "Green"
    }
    else {
        Write-ColoredText "❌ Frontend: не запущен" "Red"
    }
    
    # Проверяем доступность HTTP
    try {
        $backendResponse = Invoke-WebRequest -Uri "http://localhost:$BackendPort/api/" -TimeoutSec 5 -UseBasicParsing
        Write-ColoredText "✅ Backend API: доступен" "Green"
    }
    catch {
        Write-ColoredText "❌ Backend API: недоступен" "Red"
    }
    
    try {
        $frontendResponse = Invoke-WebRequest -Uri "http://localhost:$FrontendPort" -TimeoutSec 5 -UseBasicParsing
        Write-ColoredText "✅ Frontend: доступен" "Green"
    }
    catch {
        Write-ColoredText "❌ Frontend: недоступен" "Red"
    }
}

# Основная логика
Write-ColoredText "🛠️  Portfolio Services Manager" "Magenta"
Write-ColoredText "================================" "Magenta"

switch ($Action.ToLower()) {
    "start" {
        Write-ColoredText "🚀 Запуск сервисов..." "Cyan"
        $backendStarted = Start-Backend
        $frontendStarted = Start-Frontend
        
        if ($backendStarted -and $frontendStarted) {
            Write-ColoredText "`n✅ Все сервисы запущены успешно!" "Green"
            Write-ColoredText "🌐 Frontend: http://localhost:$FrontendPort" "White"
            Write-ColoredText "🔗 Backend API: http://localhost:$BackendPort/docs" "White"
        }
        else {
            Write-ColoredText "`n❌ Ошибки при запуске сервисов" "Red"
        }
    }
    
    "stop" {
        Write-ColoredText "🛑 Остановка сервисов..." "Cyan"
        Stop-ProcessOnPort -Port $BackendPort -ServiceName "Backend"
        Stop-ProcessOnPort -Port $FrontendPort -ServiceName "Frontend"
        Write-ColoredText "`n✅ Все сервисы остановлены" "Green"
    }
    
    "restart" {
        Write-ColoredText "🔄 Перезапуск сервисов..." "Cyan"
        Stop-ProcessOnPort -Port $BackendPort -ServiceName "Backend"
        Stop-ProcessOnPort -Port $FrontendPort -ServiceName "Frontend"
        Start-Sleep 2
        Start-Backend
        Start-Frontend
        Write-ColoredText "`n✅ Перезапуск завершен" "Green"
    }
    
    "status" {
        Get-ServicesStatus
    }
}

Write-ColoredText "`nИспользование:" "Yellow"
Write-ColoredText "PowerShell -ExecutionPolicy Bypass -File manage-services.ps1 start" "Gray"
Write-ColoredText "PowerShell -ExecutionPolicy Bypass -File manage-services.ps1 stop" "Gray"
Write-ColoredText "PowerShell -ExecutionPolicy Bypass -File manage-services.ps1 restart" "Gray"
Write-ColoredText "PowerShell -ExecutionPolicy Bypass -File manage-services.ps1 status" "Gray"