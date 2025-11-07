# 🚀 Start Production Server

## Quick Start

### Option 1: Use Production Start Script (Recommended)
```powershell
cd deli_backend
.\start-production.ps1
```

### Option 2: Manual Start
```powershell
cd deli_backend
php artisan serve --host=127.0.0.1 --port=8000
```

---

## ✅ Production Mode Status

Your application is configured for production:

- ✅ **Environment**: Production
- ✅ **Debug**: Disabled
- ✅ **URL**: http://localhost:8000
- ✅ **All Caches**: Optimized
- ✅ **Migrations**: Complete

---

## 📋 Server Information

- **Base URL**: http://localhost:8000
- **API Base**: http://localhost:8000/api
- **Health Check**: http://localhost:8000/api/up

---

## 🔧 If You Need to Re-run Setup

If you need to re-run the production setup:

```powershell
cd deli_backend
.\setup-production.ps1
```

This will:
- Configure .env for production
- Clear all caches
- Rebuild all caches
- Run migrations
- Optimize autoloader

---

## 📱 Flutter Apps

Make sure your Flutter apps are pointing to:
```
http://127.0.0.1:8000/api
```

---

**Ready to start! Run `.\start-production.ps1` in the `deli_backend` directory.**

