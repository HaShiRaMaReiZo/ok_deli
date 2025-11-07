# 🏗️ System Architecture

## Tech Stack

### Backend
- **Framework**: Laravel 11.x
- **API**: RESTful API with Laravel Sanctum for authentication
- **Real-time**: Laravel Echo + Pusher/WebSockets
- **Queue**: Laravel Queue (Redis/Database driver)
- **Database**: MySQL/PostgreSQL
- **Cache**: Redis
- **File Storage**: AWS S3 / DigitalOcean Spaces / Local

### Frontend (Mobile Apps)
- **Framework**: Flutter
- **State Management**: Provider / Riverpod / Bloc
- **HTTP Client**: Dio / http
- **Local Storage**: SharedPreferences / Hive
- **Maps**: Google Maps / Mapbox
- **Real-time**: Socket.io client / WebSocket

### Office Web Panel
- **Framework**: Laravel Blade / Vue.js / React
- **UI Framework**: Tailwind CSS / Bootstrap
- **Maps**: Google Maps JavaScript API
- **Charts**: Chart.js / ApexCharts

---

## Project Structure

```
deli/
├── deli_backend/              # Laravel Backend
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/
│   │   │   │   ├── Api/
│   │   │   │   │   ├── AuthController.php
│   │   │   │   │   ├── PackageController.php
│   │   │   │   │   ├── RiderController.php
│   │   │   │   │   ├── MerchantController.php
│   │   │   │   │   ├── TrackingController.php
│   │   │   │   │   ├── CodController.php
│   │   │   │   │   └── NotificationController.php
│   │   │   │   └── Web/
│   │   │   │       ├── DashboardController.php
│   │   │   │       ├── PackageManagementController.php
│   │   │   │       └── ReportController.php
│   │   │   ├── Middleware/
│   │   │   │   ├── CheckRole.php
│   │   │   │   └── EnsureApiKey.php
│   │   │   └── Requests/
│   │   │       ├── CreatePackageRequest.php
│   │   │       └── UpdateStatusRequest.php
│   │   ├── Models/
│   │   │   ├── User.php
│   │   │   ├── Merchant.php
│   │   │   ├── Rider.php
│   │   │   ├── Package.php
│   │   │   ├── PackageStatusHistory.php
│   │   │   ├── RiderLocation.php
│   │   │   ├── DeliveryProof.php
│   │   │   └── CodCollection.php
│   │   ├── Services/
│   │   │   ├── TrackingCodeService.php
│   │   │   ├── NotificationService.php
│   │   │   ├── RouteOptimizationService.php
│   │   │   ├── LocationService.php
│   │   │   └── CodService.php
│   │   ├── Jobs/
│   │   │   ├── SendSmsNotification.php
│   │   │   ├── SendEmailNotification.php
│   │   │   └── UpdateRiderLocation.php
│   │   ├── Events/
│   │   │   ├── PackageStatusChanged.php
│   │   │   ├── RiderLocationUpdated.php
│   │   │   └── CodCollected.php
│   │   └── Listeners/
│   │       ├── NotifyMerchantOnStatusChange.php
│   │       └── NotifyCustomerOnStatusChange.php
│   ├── database/
│   │   ├── migrations/
│   │   └── seeders/
│   ├── routes/
│   │   ├── api.php
│   │   └── web.php
│   └── config/
│
├── merchant_app/              # Flutter Merchant App
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   ├── services/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   └── pubspec.yaml
│
├── rider_app/                 # Flutter Rider App
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   ├── services/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   └── pubspec.yaml
│
└── office_web/                # Office Web Panel (Optional separate)
    └── (Laravel Blade views or separate Vue/React app)
```

---

## API Endpoints Structure

### Authentication
```
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/logout
POST   /api/auth/refresh
GET    /api/auth/user
```

### Packages (Merchant)
```
GET    /api/merchant/packages
POST   /api/merchant/packages
GET    /api/merchant/packages/{id}
PUT    /api/merchant/packages/{id}
DELETE /api/merchant/packages/{id}
GET    /api/merchant/packages/{id}/track
GET    /api/merchant/packages/{id}/history
```

### Packages (Office)
```
GET    /api/office/packages
GET    /api/office/packages/{id}
PUT    /api/office/packages/{id}/status
POST   /api/office/packages/{id}/assign
POST   /api/office/packages/bulk-assign
GET    /api/office/packages/arrived
```

### Packages (Rider)
```
GET    /api/rider/packages
GET    /api/rider/packages/{id}
PUT    /api/rider/packages/{id}/status
POST   /api/rider/packages/{id}/start-delivery    // Start delivery (status → ON_THE_WAY)
POST   /api/rider/packages/{id}/contact-customer  // Log contact attempt
POST   /api/rider/packages/{id}/proof
POST   /api/rider/packages/{id}/cod
```

### Tracking (Merchant)
```
GET    /api/merchant/packages/{id}/track
GET    /api/merchant/packages/{id}/live-location
```

### Rider Location
```
POST   /api/rider/location              // Update rider's current location (continuously)
GET    /api/rider/{id}/location         // Get rider's current location
GET    /api/rider/{id}/route            // Get rider's route
GET    /api/office/riders/locations     // Get all riders' locations (ALWAYS available)
GET    /api/merchant/packages/{id}/rider-location  // Get rider location (ONLY when status = ON_THE_WAY)
```

### COD Management
```
GET    /api/rider/cod/summary
GET    /api/office/cod/reports
POST   /api/office/cod/settle
```

### Notifications
```
GET    /api/notifications
PUT    /api/notifications/{id}/read
POST   /api/notifications/mark-all-read
```

---

## Real-time Events

### Broadcasting Channels
```php
// Private channels
'merchant.{merchantId}'     // Merchant-specific updates
'rider.{riderId}'           // Rider-specific updates
'office'                    // Office staff updates

// Public channel
'tracking.{trackingCode}'   // Public tracking updates
```

### Events
```php
PackageStatusChanged        // When package status changes
RiderLocationUpdated        // When rider location updates
PackageAssigned             // When package assigned to rider
CodCollected                // When COD is collected
DeliveryCompleted           // When delivery is completed
```

---

## Key Services

### 1. TrackingCodeService
- Generates unique tracking codes
- Format: `DELI-{YYYYMMDD}-{RANDOM}` or custom format
- Ensures uniqueness

### 2. NotificationService
- Sends SMS via Twilio/Nexmo
- Sends Email via Laravel Mail
- Sends Push notifications
- Queues notifications for reliability

### 3. RouteOptimizationService
- Calculates optimal delivery sequence
- Uses Google Maps Directions API
- Considers traffic, distance, time

### 4. LocationService
- Handles geocoding (address → coordinates)
- Reverse geocoding (coordinates → address)
- Distance calculations
- Geofencing checks

### 5. CodService
- Tracks COD collections
- Generates COD reports
- Handles COD settlements

---

## Security Considerations

1. **Authentication**: Laravel Sanctum for API tokens
2. **Authorization**: Role-based middleware
3. **Rate Limiting**: API rate limits
4. **Data Validation**: Form requests
5. **File Upload**: Validation and virus scanning
6. **SQL Injection**: Eloquent ORM (parameterized queries)
7. **XSS Protection**: Input sanitization
8. **CORS**: Configured for mobile apps

---

## Deployment Considerations

### Backend
- Use Laravel Forge / Vapor / traditional hosting
- Queue workers running
- WebSocket server (Laravel Echo Server / Pusher)
- Redis for cache and queues
- Database backups

### Mobile Apps
- Build APK/IPA files
- Deploy to Play Store / App Store
- Use Firebase for push notifications
- Configure deep linking

---

## Environment Variables

```env
# App
APP_NAME="Deli Express"
APP_ENV=production
APP_DEBUG=false

# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=deli_express
DB_USERNAME=root
DB_PASSWORD=

# Redis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

# Queue
QUEUE_CONNECTION=redis

# Broadcasting
BROADCAST_DRIVER=pusher
PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_APP_CLUSTER=

# Maps
GOOGLE_MAPS_API_KEY=

# SMS
TWILIO_SID=
TWILIO_TOKEN=
TWILIO_FROM=

# Storage
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=
AWS_BUCKET=
```

---

## Next Steps

1. Set up database migrations
2. Create API controllers and routes
3. Implement authentication
4. Build Flutter app structure
5. Set up real-time broadcasting
6. Integrate maps and location services
7. Implement notification system

Would you like me to start implementing any of these components?

