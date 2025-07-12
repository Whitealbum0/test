# 🌐 Portfolio Website - Инструкция для Windows 10

## 🚨 Решение проблем с sudo на Windows

У вас Windows 10 и не работают команды `sudo` в скриптах? Мы создали полноценные Windows-версии всех скриптов!

## 🛠 Системные требования для Windows

- Windows 10/11
- Python 3.8+ 
- Node.js 16+
- Yarn (рекомендуется)
- Git (опционально)

## 🔧 Быстрая установка

1. **Проверьте окружение:**
```batch
check-environment-windows.bat
```

2. **Настройте брандмауэр (от имени администратора):**
```batch
setup-firewall-windows.bat
```

3. **Запустите приложение:**
```batch
start-windows-improved.bat
```

## 🚀 Доступные скрипты для Windows

### 🔧 Development режим
```batch
start-windows-improved.bat
```
- Запуск в режиме разработки
- Автоперезагрузка при изменениях
- Отладочная информация

### 🚀 Production режим
```batch
start-production-windows.bat
```
- Определение внешнего IP
- Настройка production конфигурации
- Оптимизированный запуск

### 🛑 Остановка сервисов
```batch
stop-services-windows.bat
```
- Полная остановка всех процессов
- Освобождение портов
- Проверка статуса

### 🔒 Настройка HTTPS
```batch
setup-ssl-windows.bat
```
- Cloudflare (рекомендуется)
- nginx + Let's Encrypt
- Самоподписанные сертификаты

### 🔍 Проверка окружения
```batch
check-environment-windows.bat
```
- Проверка всех зависимостей
- Диагностика проблем
- Рекомендации по исправлению

### 🛡️ Настройка брандмауэра
```batch
setup-firewall-windows.bat
```
⚠️ **Требует права администратора!**
- Автоматическое создание правил
- Открытие портов 3000 и 8001
- Поддержка локального и сетевого доступа

## 💻 PowerShell управление (расширенное)

```powershell
# Запуск всех сервисов
PowerShell -ExecutionPolicy Bypass -File manage-services.ps1 start

# Остановка всех сервисов
PowerShell -ExecutionPolicy Bypass -File manage-services.ps1 stop

# Перезапуск сервисов
PowerShell -ExecutionPolicy Bypass -File manage-services.ps1 restart

# Проверка статуса
PowerShell -ExecutionPolicy Bypass -File manage-services.ps1 status
```

## 🌐 Доступ к приложению

После запуска приложение будет доступно:

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:8001/docs
- **Админ-панель:** http://localhost:3000/admin

## 🔧 Решение проблем

### ❌ Ошибка "python не найден"
```batch
# Установите Python с python.org
# Убедитесь что Python добавлен в PATH
```

### ❌ Ошибка "node не найден"
```batch
# Установите Node.js с nodejs.org
# Рекомендуется LTS версия
```

### ❌ Ошибка "yarn не найден"
```batch
npm install -g yarn
```

### ❌ Порты заняты
```batch
# Остановите все процессы
stop-services-windows.bat

# Или найдите процесс вручную
netstat -ano | findstr :3000
taskkill /F /PID <номер_процесса>
```

### 🛡️ Проблемы с брандмауэром
```batch
# Запустите от имени администратора
setup-firewall-windows.bat
```

## 🌍 Доступ из интернета

### 1. Настройка роутера
В роутере настройте проброс портов:
- `80 → ваш_IP:3000` (HTTP)
- `443 → ваш_IP:3000` (HTTPS)
- `8001 → ваш_IP:8001` (API)

### 2. Получение внешнего IP
```batch
curl ifconfig.me
```

### 3. Настройка HTTPS
```batch
setup-ssl-windows.bat
```

## 📂 Структура Windows файлов

```
/app/
├── start-windows-improved.bat     # Development запуск
├── start-production-windows.bat   # Production запуск
├── stop-services-windows.bat      # Остановка сервисов
├── setup-ssl-windows.bat          # Настройка HTTPS
├── setup-firewall-windows.bat     # Настройка брандмауэра
├── check-environment-windows.bat  # Проверка окружения
├── manage-services.ps1            # PowerShell управление
└── README-Windows.md              # Эта инструкция
```

## 🆚 Сравнение с Linux версиями

| Linux команда | Windows аналог |
|---------------|----------------|
| `sudo supervisorctl restart` | `start-production-windows.bat` |
| `./start_production.sh` | `start-production-windows.bat` |
| `./setup_ssl.sh` | `setup-ssl-windows.bat` |
| `sudo apt install` | Ручная установка или chocolatey |

## 🔒 Безопасность

- Брандмауэр настраивается автоматически
- SSL сертификаты через Cloudflare или Let's Encrypt
- Переменные окружения защищены
- CORS настроен для production

## 📞 Поддержка

Если возникли проблемы:

1. Запустите `check-environment-windows.bat`
2. Проверьте логи в окнах терминалов
3. Убедитесь что порты свободны
4. Проверьте права брандмауэра

## 🎯 Часто задаваемые вопросы

**Q: Почему не работает sudo?**
A: sudo - это Linux команда. На Windows используйте наши .bat скрипты

**Q: Как запустить от имени администратора?**
A: Правый клик → "Запуск от имени администратора"

**Q: Можно ли использовать npm вместо yarn?**
A: Можно, но yarn рекомендуется для стабильности

**Q: Как настроить автозапуск?**
A: Используйте Task Scheduler или создайте Windows Service

## 🌟 Автор

Создано специально для Windows 10 пользователей!
Все sudo команды заменены на Windows-совместимые аналоги.