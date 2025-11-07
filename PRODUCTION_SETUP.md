# 🚀 Production Setup Guide

## ✅ Production Mode Configuration

This project is configured to run in **production mode** on **localhost:8000**.

---

## 📋 Quick Start

### Windows (PowerShell)
```powershell
cd deli_backend
.\setup-production.ps1
.\start-production.ps1
```

### Linux/Mac (Bash)
```bash
cd deli_backend
chmod +x setup-production.sh start-production.sh
./setup-production.sh
./start-production.sh
```

---

## 🔧 Manual Setup

### 1. Configure Environment

Update `.env` file:
```env
APP_ENV=production
APP_DEBUG=false
APP_URL=http://localhost:8000

# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=delivery_db
DB_USERNAME=root
DB_PASSWORD=

# Broadcasting (for WebSockets)
BROADCAST_DRIVER=log  # Use 'pusher' or 'redis' for real WebSockets

# Cache
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
```

### 2. Generate Application Key
```bash
php artisan key:generate
```

### 3. Run Migrations
```bash
php artisan migrate --force
```

### 4. Optimize for Production
```bash
# Clear caches
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan event:clear

# Cache for production
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# Optimize autoloader
composer install --optimize-autoloader --no-dev
```

### 5. Create Storage Link
```bash
php artisan storage:link
```

### 6. Start Server
```bash
php artisan serve --host=127.0.0.1 --port=8000
```

---

## 🌐 Server Configuration

### Running on localhost:8000

The server is configured to run on:
- **Host**: `127.0.0.1`
- **Port**: `8000`
- **URL**: `http://localhost:8000`

### API Endpoints

- **Base URL**: `http://localhost:8000/api`
- **Health Check**: `http://localhost:8000/up`

---

## 🔒 Security Settings

### Production Mode Features

✅ **APP_DEBUG=false** - Disables debug mode  
✅ **APP_ENV=production** - Production environment  
✅ **Optimized Caches** - Config, routes, views cached  
✅ **CORS Configured** - API accessible from localhost  
✅ **Sanctum Auth** - Token-based authentication  

---

## 📱 Flutter Apps Configuration

### Merchant App (`merchant_app`)

Update `lib/core/api_endpoints.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

### Rider App (`rider_app`)

Update `lib/core/api_endpoints.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

---

## 🔄 WebSockets Configuration

### For Real-time Updates

**Option 1: Pusher (Recommended)**
```env
BROADCAST_DRIVER=pusher
PUSHER_APP_ID=your_app_id
PUSHER_APP_KEY=your_app_key
PUSHER_APP_SECRET=your_app_secret
PUSHER_APP_CLUSTER=your_cluster
```

**Option 2: Laravel Echo Server**
```bash
npm install -g laravel-echo-server
laravel-echo-server init
laravel-echo-server start
```

```env
BROADCAST_DRIVER=redis
```

**Option 3: Log (Default for localhost)**
```env
BROADCAST_DRIVER=log
```

---

## 📊 Performance Optimization

### Production Optimizations Applied

✅ **Config Caching** - Faster config loading  
✅ **Route Caching** - Faster route resolution  
✅ **View Caching** - Faster view rendering  
✅ **Event Caching** - Faster event handling  
✅ **Optimized Autoloader** - Faster class loading  

### Additional Optimizations

```bash
# Clear all caches
php artisan optimize:clear

# Re-optimize
php artisan optimize
```

---

## 🐛 Troubleshooting

### Issue: 500 Internal Server Error

**Solution:**
```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
```

### Issue: Storage Link Not Working

**Solution:**
```bash
php artisan storage:link
```

### Issue: CORS Errors

**Solution:**
- Check `config/cors.php` configuration
- Ensure `APP_URL` matches your frontend URL
- Check Sanctum stateful domains in `config/sanctum.php`

### Issue: WebSocket Not Working

**Solution:**
- Configure `BROADCAST_DRIVER` in `.env`
- Start broadcasting server (Pusher/Echo Server)
- Check channel authorization in `routes/channels.php`

---

## 📝 Notes

- **Production mode** is optimized for performance
- **Debug mode** is disabled for security
- **Caches** are enabled for faster response times
- **API** is accessible from localhost:8000
- **WebSockets** require additional setup (see WebSockets Configuration)

---

## ✅ Checklist

- [x] Environment configured for production
- [x] Application key generated
- [x] Migrations run
- [x] Caches optimized
- [x] Storage link created
- [x] CORS configured
- [x] Server runs on localhost:8000
- [ ] WebSockets configured (optional)
- [ ] Database configured
- [ ] Flutter apps configured

---

**🎉 Your Laravel backend is ready for production on localhost:8000!**

