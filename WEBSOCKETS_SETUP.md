# 🔌 WebSockets Setup Guide

## ✅ Backend Implementation Complete

### Events Created
- ✅ `RiderLocationUpdated` - Broadcasts rider location updates
- ✅ `PackageStatusChanged` - Broadcasts package status changes

### Broadcasting Channels
- ✅ `office.riders.locations` - Office can see all riders (always)
- ✅ `merchant.package.{packageId}.location` - Merchant sees rider location (only when status = on_the_way)
- ✅ `merchant.{merchantId}` - Merchant receives package updates
- ✅ `office.packages` - Office receives package updates

### Controllers Updated
- ✅ `RiderLocationController` - Broadcasts location updates
- ✅ `RiderPackageController` - Broadcasts status changes
- ✅ `MerchantPackageController` - Broadcasts package creation
- ✅ `OfficePackageController` - Broadcasts status changes and assignments

---

## 📋 Configuration Required

### Option 1: Using Pusher (Recommended for Production)

1. **Install Pusher PHP SDK** (already included in Laravel)
2. **Configure `.env`**:
   ```env
   BROADCAST_DRIVER=pusher
   PUSHER_APP_ID=your_app_id
   PUSHER_APP_KEY=your_app_key
   PUSHER_APP_SECRET=your_app_secret
   PUSHER_APP_CLUSTER=your_cluster
   ```

3. **Get Pusher credentials** from https://pusher.com

### Option 2: Using Laravel Echo Server (Self-hosted)

1. **Install Laravel Echo Server**:
   ```bash
   npm install -g laravel-echo-server
   ```

2. **Initialize**:
   ```bash
   laravel-echo-server init
   ```

3. **Configure `.env`**:
   ```env
   BROADCAST_DRIVER=redis
   ```

4. **Start Echo Server**:
   ```bash
   laravel-echo-server start
   ```

### Option 3: Using Redis + Socket.io

1. **Install Redis** (if not installed)
2. **Configure `.env`**:
   ```env
   BROADCAST_DRIVER=redis
   REDIS_HOST=127.0.0.1
   REDIS_PASSWORD=null
   REDIS_PORT=6379
   ```

3. **Use Socket.io server** (custom implementation needed)

---

## 📱 Flutter Apps - WebSocket Client Setup

### Merchant App

Add to `pubspec.yaml`:
```yaml
dependencies:
  socket_io_client: ^2.0.3+1
  # or
  web_socket_channel: ^2.4.0
```

### Rider App

Same as merchant app - add WebSocket client package.

---

## 🔧 Next Steps

1. **Choose broadcasting driver** (Pusher recommended)
2. **Configure `.env`** with broadcasting credentials
3. **Start broadcasting server** (if using Echo Server)
4. **Update Flutter apps** to listen to WebSocket channels
5. **Test real-time updates**

---

## 📝 Current Status

✅ **Backend WebSocket events implemented**  
✅ **Broadcasting channels configured**  
✅ **Events fire on location/status updates**  
⏳ **Flutter apps need WebSocket client integration**  
⏳ **Broadcasting server needs to be configured**

---

**Note**: The backend is ready for WebSockets. You need to:
1. Configure broadcasting driver (Pusher/Echo Server)
2. Add WebSocket client to Flutter apps
3. Connect to channels and listen for events

