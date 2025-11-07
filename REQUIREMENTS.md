# 🚚 Parcel Delivery Service - System Requirements

## 📱 Applications Overview

### 1. **Merchant App** (Flutter Mobile App)
- **Purpose**: Merchants register packages and track deliveries
- **Features**:
  - Register new packages (customer info, payment type, amount, package image)
  - View all packages with status
  - Track packages using unique tracking code
  - **Live Location Tracking**: When package status is "On the Way", show rider's live location on map
  - View package history and status timeline
  - Filter packages by status, date, tracking code

### 2. **Office Web Panel** (Laravel Web Application)
- **Purpose**: Central management system for sorting, managing, and tracking
- **Features**:
  - View all packages from all merchants
  - Filter and sort packages (by merchant, date, status, tracking code)
  - Mark packages as "Arrived at Office" when physically received
  - Assign packages to riders
  - **Track all riders' live locations ALWAYS** (when riders are online/active, regardless of package status)
  - View rider status (available, busy, offline)
  - View package conditions and status updates
  - Reports and analytics
  - Manage merchants and riders

### 3. **Rider App** (Flutter Mobile App)
- **Purpose**: Riders handle assigned deliveries
- **Features**:
  - View assigned packages with customer details
  - Update package delivery status
  - **Contact Customer**: Call customer from app
    - If contact successful → Continue delivery
    - If contact failed → Update status to "Contact Failed" → "Return to Office"
  - **Start Delivery**: Click button to change status to "On the Way" (triggers live tracking)
  - Update status: Picked Up → On the Way → Delivered
  - Navigation to customer address
  - Capture delivery proof (photo/signature)
  - COD collection tracking
  - **Live location updates** sent to backend (for merchant and office to see)

---

## 📦 Package Status Flow

```
REGISTERED (by Merchant)
    ↓
ARRIVED_AT_OFFICE (marked by Office)
    ↓
ASSIGNED_TO_RIDER (assigned by Office)
    ↓
PICKED_UP (rider picks from office)
    ↓
ON_THE_WAY (rider clicks "Start Delivery" → Live tracking starts)
    ↓
    ├─→ DELIVERED (successful delivery)
    │
    └─→ CONTACT_FAILED (if rider can't contact customer)
            ↓
        RETURN_TO_OFFICE
```

---

## 🔄 Detailed Workflow

### **Merchant Workflow**
1. Merchant creates package:
   - Enter customer name, address, phone
   - Select payment type (COD/Prepaid)
   - Enter amount
   - Upload package image
   - System generates unique tracking code
   - Status: **REGISTERED**

2. Merchant tracks package:
   - View all packages with current status
   - When status = **ON_THE_WAY**:
     - Show live map with rider's current location
     - Update location in real-time
     - Show estimated delivery time
   - View complete status history

### **Office Workflow**
1. View all packages from merchants
2. When package physically arrives:
   - Mark as **ARRIVED_AT_OFFICE**
3. Assign package to rider:
   - Select rider from available riders
   - Status changes to **ASSIGNED_TO_RIDER**
4. Monitor:
   - **View all riders on map with live locations (ALWAYS available, regardless of package status)**
   - Track package status updates
   - View package conditions/status
   - See rider status (available, busy, offline)
   - Generate reports

### **Rider Workflow**
1. View assigned packages:
   - List of packages with customer details
   - Customer address, phone, payment info
2. Pick up package:
   - Update status to **PICKED_UP**
3. **Contact Customer**:
   - Click "Contact Customer" button (calls customer)
   - **If contact successful**: Continue to delivery
   - **If contact failed**: 
     - Update status to **CONTACT_FAILED**
     - Option to mark for **RETURN_TO_OFFICE**
4. **Start Delivery**:
   - Click "Start Delivery" button
   - Status changes to **ON_THE_WAY**
   - **Live location tracking begins** (merchant can now see rider location)
   - Navigate to customer address
5. Update status:
   - **DELIVERED**: When package handed to customer
     - Capture delivery proof (photo/signature)
     - Collect COD if applicable
   - **CONTACT_FAILED**: If can't reach customer
     - Update status
     - Return to office

---

## 📍 Live Location Tracking

### **Office Web Panel - Rider Location Tracking**
- **Always Available**: Office can see ALL riders' locations at ALL TIMES (when riders are online/active)
- **No Status Restriction**: Rider location visible regardless of package status
- **Location Updates**: Rider app sends location updates continuously (every 10-30 seconds when app is active)
- **Map View**: Shows all active riders with live locations, rider status, and assigned packages

### **Merchant App - Package Location Tracking**
- **Conditional**: Merchant can see rider's live location ONLY when package status is **ON_THE_WAY**
- **Trigger**: When rider clicks "Start Delivery" button, status changes to **ON_THE_WAY**
- **Location Updates**: Rider app sends location updates while status = **ON_THE_WAY**
- **Map View**: Shows rider's current location, customer address, route, and ETA
- **When Status Changes**: Live tracking stops when status changes to **DELIVERED** or **RETURN_TO_OFFICE**

### **Location Update Frequency**
- **Rider App**: Sends location updates every 10-30 seconds when app is active
- **Office Web Panel**: Receives all rider location updates (always visible)
- **Merchant App**: Receives location updates only when package status = **ON_THE_WAY**

---

## 🎯 Key Features Summary

### **Merchant App**
✅ Package registration  
✅ Package tracking  
✅ **Live location tracking** (ONLY when status = ON_THE_WAY)  
✅ Status history  
✅ Filter and search packages  

### **Office Web Panel**
✅ Package management  
✅ Rider assignment  
✅ **Track all riders' live locations ALWAYS** (when riders are online/active)  
✅ View package status and conditions  
✅ Reports and analytics  
✅ Filter and sort packages  

### **Rider App**
✅ View assigned packages  
✅ Contact customer (call from app)  
✅ **Start Delivery** button (triggers live tracking)  
✅ Update delivery status  
✅ Navigation to address  
✅ Capture delivery proof  
✅ COD collection  
✅ **Send live location updates**  

---

## ❌ What We DON'T Have

- ❌ Customer App (no customer-facing app)
- ❌ Public tracking portal (customers don't track directly)
- ❌ Customer notifications (SMS/Email to customers)

---

## ✅ Status Definitions

| Status | Description | Updated By |
|--------|-------------|------------|
| **REGISTERED** | Package created by merchant | Merchant |
| **ARRIVED_AT_OFFICE** | Package physically received at office | Office |
| **ASSIGNED_TO_RIDER** | Package assigned to a rider | Office |
| **PICKED_UP** | Rider picked package from office | Rider |
| **ON_THE_WAY** | Rider started delivery (live tracking active) | Rider |
| **DELIVERED** | Package successfully delivered | Rider |
| **CONTACT_FAILED** | Rider couldn't contact customer | Rider |
| **RETURN_TO_OFFICE** | Package returned to office | Rider/Office |

---

## 🔑 Key Technical Requirements

1. **Real-time Location Updates**
   - **Rider App**: Continuously sends GPS coordinates to backend (every 10-30 seconds when app is active)
   - **Backend Broadcasting**:
     - **Office Web Panel**: Receives ALL rider location updates (always)
     - **Merchant App**: Receives location updates ONLY when package status = **ON_THE_WAY**
   - Use WebSockets or Server-Sent Events for real-time updates

2. **Contact Customer Feature**
   - Rider app has "Call Customer" button
   - Opens phone dialer with customer number
   - Rider manually updates status based on contact result

3. **Start Delivery Button**
   - Changes status to **ON_THE_WAY**
   - Activates location tracking
   - Enables live map view in merchant app

4. **Unique Tracking Code**
   - Auto-generated for each package
   - Format: Can be custom (e.g., DELI-20241201-ABC123)
   - Used by merchant to track packages

---

## 📊 Data Flow

```
Merchant App → Creates Package → Backend → Office Web Panel
                                    ↓
                              Office assigns to Rider
                                    ↓
                              Rider App receives assignment
                                    ↓
Rider App → Sends location updates (continuously) → Backend
                                    ↓
                              Backend broadcasts to:
                                    ├─→ Office Web Panel (ALL riders, ALWAYS)
                                    └─→ Merchant App (ONLY when status = ON_THE_WAY)
                                    ↓
Rider clicks "Start Delivery" → Status: ON_THE_WAY
                                    ↓
                              Merchant App now receives location updates
                                    ↓
Rider location updates → Backend → Broadcasts to:
                                    ├─→ Merchant App (for that package, while ON_THE_WAY)
                                    └─→ Office Web Panel (all riders, always)
```

---

## 🎨 UI/UX Considerations

### **Merchant App - Live Tracking View**
- Map showing:
  - Rider's current location (moving marker)
  - Customer delivery address (destination marker)
  - Route line (if available)
  - Estimated time remaining
  - Distance remaining

### **Office Web Panel - Rider Tracking**
- Map showing:
  - All active riders (different colored markers)
  - Rider names/IDs
  - Current package count per rider
  - Click rider to see assigned packages

### **Rider App - Delivery Screen**
- Large "Start Delivery" button
- "Contact Customer" button (prominent)
- Navigation button
- Status update buttons
- Current location display

---

## Next Steps

1. Create database schema with these statuses
2. Implement API endpoints for all workflows
3. Set up real-time location tracking
4. Build Flutter apps with these features
5. Create office web panel with management features

Ready to start implementation! 🚀

