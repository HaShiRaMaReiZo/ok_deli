# 🚀 Quick Start Guide

## Choose Your Environment

### 🧪 Test/Development Mode
For development, testing, and debugging.

```powershell
cd deli_backend
.\setup-test.ps1      # Setup test environment
.\start-test.ps1      # Start test server
```

**Features:**
- ✅ Debug mode enabled
- ✅ Detailed error messages
- ✅ No caching (easier development)
- ✅ Hot reloading support

---

### 🚀 Production Mode
For production-ready, optimized performance.

```powershell
cd deli_backend
.\setup-production.ps1      # Setup production environment
.\start-production.ps1      # Start production server
```

**Features:**
- ✅ Debug mode disabled
- ✅ All caches enabled
- ✅ Optimized performance
- ✅ Production-ready

---

## 🔄 Quick Switch

Switch between environments easily:

```powershell
cd deli_backend
.\switch-env.ps1 test         # Switch to test mode
.\switch-env.ps1 production    # Switch to production mode
```

---

## 📋 Both Environments

Both environments run on:
- **URL**: http://localhost:8000
- **API**: http://localhost:8000/api

---

## 📝 Available Scripts

### Setup Scripts
- `setup-test.ps1` - Configure for test/development
- `setup-production.ps1` - Configure for production
- `switch-env.ps1` - Quick switch between environments

### Start Scripts
- `start-test.ps1` - Start test/development server
- `start-production.ps1` - Start production server

---

## ✅ Verification

Check current environment:
```powershell
php artisan config:show app.env
php artisan config:show app.debug
```

---

**Both test and production environments are ready!** 🎉

