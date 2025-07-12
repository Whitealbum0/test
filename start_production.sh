#!/bin/bash

echo "🚀 Запуск portfolio сайта в production режиме"

# Узнаем внешний IP
EXTERNAL_IP=$(curl -s ifconfig.me)
echo "🌐 Ваш внешний IP: $EXTERNAL_IP"

# Обновляем конфигурацию frontend
echo "📝 Обновляем конфигурацию frontend..."
echo "REACT_APP_BACKEND_URL=http://$EXTERNAL_IP:8001" > /app/frontend/.env.production

# Перезапускаем сервисы
echo "🔄 Перезапуск backend..."
sudo supervisorctl restart backend

echo "🔄 Перезапуск frontend..."
sudo supervisorctl restart frontend

# Ждем запуска
sleep 5

# Проверяем статус
echo "📊 Статус сервисов:"
sudo supervisorctl status

echo ""
echo "✅ Сайт должен быть доступен по адресам:"
echo "🌐 Frontend: http://$EXTERNAL_IP:3000"
echo "🔗 API: http://$EXTERNAL_IP:8001"
echo ""
echo "📋 Настройки роутера:"
echo "Port 3000 → $EXTERNAL_IP:3000 (HTTP)"
echo "Port 8001 → $EXTERNAL_IP:8001 (API)"
echo ""
echo "⚠️  Не забудьте:"
echo "1. Настроить проброс портов в роутере"
echo "2. Открыть порты в брандмауэре"
echo "3. Настроить SSL сертификаты для HTTPS"