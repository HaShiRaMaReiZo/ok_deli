# 📍 Location Tracking Rules

## Summary

### **Office Web Panel**
✅ **Can see ALL riders' locations ALWAYS** (when riders are online/active)  
✅ **No status restriction** - visible regardless of package status  
✅ **Real-time updates** - receives all rider location updates continuously  

### **Merchant App**
✅ **Can see rider location ONLY when package status = ON_THE_WAY**  
✅ **Conditional tracking** - triggered when rider clicks "Start Delivery"  
✅ **Stops tracking** when status changes to DELIVERED or RETURN_TO_OFFICE  

---

## Detailed Rules

### 1. Office Web Panel - Rider Location Tracking

#### Visibility Rules
- **Always Visible**: Office can see all riders' locations at all times
- **No Status Restriction**: Rider location visible regardless of:
  - Package status (REGISTERED, ASSIGNED, PICKED_UP, ON_THE_WAY, DELIVERED, etc.)
  - Whether rider has assigned packages or not
  - Rider status (available, busy, offline)

#### When Location is Visible
- **When**: Rider app is active and sending location updates
- **Update Frequency**: Every 10-30 seconds (when rider app is active)
- **Display**: All active riders shown on map simultaneously

#### What Office Sees
- Map with all active riders (different colored markers)
- Rider names/IDs
- Current package count per rider
- Rider status (available, busy, offline)
- Real-time location updates
- Click rider to see assigned packages
- Filter by rider, status, zone

#### Technical Implementation
- Rider app continuously sends location updates to backend
- Backend stores location in `rider_locations` table
- Backend broadcasts to office web panel via WebSocket/Pusher
- Office web panel subscribes to all rider location updates

---

### 2. Merchant App - Package Location Tracking

#### Visibility Rules
- **Conditional**: Merchant can see rider's live location ONLY when:
  - Package status = **ON_THE_WAY**
  - Rider has clicked "Start Delivery" button

#### When Location is Visible
- **Trigger**: Rider clicks "Start Delivery" button
- **Status Change**: Package status changes to **ON_THE_WAY**
- **Update Frequency**: Every 10-30 seconds (while status = ON_THE_WAY)
- **Stops**: When status changes to:
  - **DELIVERED**
  - **RETURN_TO_OFFICE**
  - **CONTACT_FAILED**

#### What Merchant Sees
- Map showing:
  - Rider's current location (moving marker)
  - Customer delivery address (destination marker)
  - Route line (if available)
  - Estimated time remaining
  - Distance remaining
  - Rider name/ID

#### When Location is NOT Visible
- Package status is NOT **ON_THE_WAY**
- Examples:
  - Status = REGISTERED → No location shown
  - Status = ASSIGNED_TO_RIDER → No location shown
  - Status = PICKED_UP → No location shown
  - Status = DELIVERED → No location shown (tracking stopped)

#### Technical Implementation
- Rider app sends location updates to backend
- Backend checks if package status = **ON_THE_WAY**
- If status = **ON_THE_WAY**: Backend broadcasts to merchant app
- If status ≠ **ON_THE_WAY**: Backend does NOT broadcast to merchant app
- Merchant app subscribes to location updates for specific package

---

## Location Update Flow

```
Rider App (Active)
    ↓
Sends location update (every 10-30 seconds)
    ↓
Backend receives location
    ↓
Backend stores in database
    ↓
Backend broadcasts to:
    ├─→ Office Web Panel (ALWAYS - all riders)
    └─→ Merchant App (ONLY if package status = ON_THE_WAY)
```

---

## Status-Based Tracking Logic

### Package Status Flow with Location Tracking

```
REGISTERED
    ↓ (No location tracking for merchant)
ARRIVED_AT_OFFICE
    ↓ (No location tracking for merchant)
ASSIGNED_TO_RIDER
    ↓ (No location tracking for merchant)
PICKED_UP
    ↓ (No location tracking for merchant)
ON_THE_WAY ⭐
    ↓ (Location tracking STARTS for merchant)
    ├─→ DELIVERED (Location tracking STOPS for merchant)
    └─→ RETURN_TO_OFFICE (Location tracking STOPS for merchant)
```

### Office Web Panel Tracking
- **Always Active**: Office can see all riders regardless of package status
- **No Dependency**: Not dependent on any package status

---

## API Endpoints

### For Office Web Panel
```php
GET /api/office/riders/locations
// Returns: All riders' current locations (always available)
// Response: {
//   "riders": [
//     {
//       "rider_id": 1,
//       "name": "Rider 1",
//       "latitude": 23.123,
//       "longitude": 90.456,
//       "status": "available",
//       "package_count": 3,
//       "last_update": "2024-12-01 10:00:00"
//     }
//   ]
// }
```

### For Merchant App
```php
GET /api/merchant/packages/{id}/rider-location
// Returns: Rider location ONLY if package status = ON_THE_WAY
// If status ≠ ON_THE_WAY: Returns null or error
// Response: {
//   "rider_id": 1,
//   "rider_name": "Rider 1",
//   "latitude": 23.123,
//   "longitude": 90.456,
//   "package_status": "on_the_way",
//   "last_update": "2024-12-01 10:00:00"
// }
```

---

## WebSocket/Pusher Channels

### Office Web Panel Channel
```php
Channel: 'office.riders.locations'
// Subscribes to: All rider location updates
// Always receives: All rider location updates
```

### Merchant App Channel
```php
Channel: 'merchant.package.{packageId}.location'
// Subscribes to: Specific package's rider location
// Receives: Location updates ONLY when package status = ON_THE_WAY
// Backend logic: Check package status before broadcasting
```

---

## Database Considerations

### Rider Locations Table
- Stores all rider location updates (for office web panel)
- Can be used for location history
- Indexed by rider_id and created_at

### Package Status Check
- Before broadcasting to merchant app, check:
  ```php
  if ($package->status === 'on_the_way') {
      // Broadcast location to merchant app
  } else {
      // Do not broadcast
  }
  ```

---

## Implementation Checklist

- [ ] Rider app sends location updates continuously (every 10-30 seconds)
- [ ] Backend stores all rider locations in database
- [ ] Backend broadcasts ALL rider locations to office web panel (always)
- [ ] Backend checks package status before broadcasting to merchant app
- [ ] Backend broadcasts to merchant app ONLY when status = ON_THE_WAY
- [ ] Office web panel subscribes to all rider location updates
- [ ] Merchant app subscribes to package-specific location updates
- [ ] Merchant app shows location only when status = ON_THE_WAY
- [ ] Location tracking stops for merchant when status changes

---

## Summary Table

| Feature | Office Web Panel | Merchant App |
|---------|-----------------|--------------|
| **Visibility** | Always (when riders active) | Only when status = ON_THE_WAY |
| **Status Restriction** | None | Must be ON_THE_WAY |
| **Update Frequency** | Every 10-30 seconds | Every 10-30 seconds (when active) |
| **All Riders** | Yes | No (only assigned rider) |
| **Real-time** | Yes | Yes (when active) |
| **Stops When** | Never (always active) | Status changes to DELIVERED/RETURN_TO_OFFICE |

---

Ready to implement! 🚀

