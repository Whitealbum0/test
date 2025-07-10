# Сайт-визитка - Инструкция по развертыванию

## О проекте

Это современный адаптивный сайт-визитка с возможностью редактирования контента через админ-панель.

### Технологии:
- **Frontend**: React 19 + Tailwind CSS
- **Backend**: FastAPI (Python)
- **База данных**: MongoDB
- **Особенности**: Загрузка изображений, адаптивный дизайн, панель администратора

## Структура проекта

```
/
├── backend/                # FastAPI сервер
│   ├── server.py          # Основной файл сервера
│   ├── requirements.txt   # Python зависимости
│   └── .env              # Переменные окружения
├── frontend/              # React приложение
│   ├── src/
│   │   ├── App.js        # Главный компонент
│   │   └── components/   # Компоненты
│   ├── package.json      # Node.js зависимости
│   └── .env             # Переменные окружения
└── README.md            # Эта инструкция
```

## Быстрый старт

### Предварительные требования

1. **Python 3.8+** - https://python.org
2. **Node.js 16+** - https://nodejs.org
3. **MongoDB** - https://mongodb.com/try/download/community

### Установка и запуск

1. **Клонируйте или скачайте проект**
   ```bash
   git clone <repository-url>
   cd website-portfolio
   ```

2. **Настройте Backend**
   ```bash
   cd backend
   python -m venv venv
   venv\Scripts\activate  # Windows
   # source venv/bin/activate  # Linux/Mac
   pip install -r requirements.txt
   ```

3. **Настройте Frontend**
   ```bash
   cd frontend
   npm install
   ```

4. **Запустите MongoDB**
   - Убедитесь, что MongoDB запущен на `mongodb://localhost:27017`

5. **Запустите приложение**
   
   **Backend (в одном терминале):**
   ```bash
   cd backend
   venv\Scripts\activate
   uvicorn server:app --reload --host 0.0.0.0 --port 8001
   ```
   
   **Frontend (в другом терминале):**
   ```bash
   cd frontend
   npm start
   ```

6. **Откройте в браузере**
   - Сайт: http://localhost:3000
   - Админ-панель: http://localhost:3000/admin
   - API документация: http://localhost:8001/docs

## Настройка переменных окружения

### Backend (.env в папке backend)
```env
MONGO_URL=mongodb://localhost:27017
DB_NAME=portfolio_database
```

### Frontend (.env в папке frontend)
```env
REACT_APP_BACKEND_URL=http://localhost:8001
```

## Функциональность

### Главная страница
- Адаптивный дизайн
- Разделы: Главная, Обо мне, Навыки, Опыт, Проекты, Контакты
- Плавная прокрутка между разделами
- Социальные сети

### Панель администратора (/admin)
- **Основное**: Имя, профессия, описание, контакты
- **Изображения**: Загрузка аватара и фонового изображения
- **Социальные сети**: LinkedIn, GitHub, Twitter и др.
- **Навыки**: Добавление навыков с уровнем владения
- **Опыт**: Управление опытом работы
- **Проекты**: Портфолио проектов с ссылками

### API Endpoints
- `GET /api/profile` - Получить профиль
- `PUT /api/profile` - Обновить профиль
- `POST /api/profile/upload-image` - Загрузить изображение

## Развертывание в продакшене

### Сборка для продакшена

1. **Frontend**
   ```bash
   cd frontend
   npm run build
   ```

2. **Backend**
   ```bash
   cd backend
   pip install gunicorn
   gunicorn server:app -w 4 -k uvicorn.workers.UvicornWorker
   ```

### Настройка веб-сервера (Nginx/Apache)

```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    # Frontend статические файлы
    location / {
        root /path/to/frontend/build;
        try_files $uri $uri/ /index.html;
    }
    
    # Backend API
    location /api {
        proxy_pass http://localhost:8001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Устранение неполадок

### Распространенные проблемы

1. **MongoDB не подключается**
   - Проверьте, что MongoDB запущен
   - Проверьте строку подключения в .env

2. **CORS ошибки**
   - Убедитесь, что REACT_APP_BACKEND_URL правильно настроен
   - Проверьте, что backend запущен на правильном порту

3. **Изображения не загружаются**
   - Проверьте, что Pillow установлен: `pip install Pillow`
   - Проверьте права доступа к папкам

4. **Frontend не собирается**
   - Удалите node_modules и package-lock.json
   - Запустите `npm install` заново

### Логи и отладка

- Backend логи: Консоль где запущен uvicorn
- Frontend логи: Консоль браузера (F12)
- MongoDB логи: Проверьте логи MongoDB

## Безопасность

### Для продакшена обязательно:

1. Измените SECRET_KEY в backend/.env
2. Настройте HTTPS
3. Ограничьте CORS origins
4. Настройте firewall
5. Регулярно обновляйте зависимости

## Поддержка

Если у вас возникли вопросы:
1. Проверьте логи в консоли
2. Убедитесь, что все зависимости установлены
3. Проверьте версии Python и Node.js
4. Посмотрите открытые порты

## Лицензия

Этот проект создан для личного использования.