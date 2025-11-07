# 📦 Package Status Flow

## Complete Status Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    MERCHANT APP                              │
│  Creates Package → Status: REGISTERED                      │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ↓
┌─────────────────────────────────────────────────────────────┐
│                  OFFICE WEB PANEL                            │
│  Receives Package → Status: ARRIVED_AT_OFFICE              │
│  Assigns to Rider → Status: ASSIGNED_TO_RIDER              │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ↓
┌─────────────────────────────────────────────────────────────┐
│                    RIDER APP                                 │
│  Picks Package → Status: PICKED_UP                          │
│                                                              │
│  ┌──────────────────────────────────────────┐              │
│  │ Contact Customer Button                   │              │
│  │  ├─ Success → Continue                    │              │
│  │  └─ Failed → Status: CONTACT_FAILED       │              │
│  └──────────────────────────────────────────┘              │
│                                                              │
│  ┌──────────────────────────────────────────┐              │
│  │ START DELIVERY Button                     │              │
│  │ → Status: ON_THE_WAY                      │              │
│  │ → LIVE TRACKING STARTS                    │              │
│  │ → Merchant sees live location             │              │
│  └──────────────────────────────────────────┘              │
│                                                              │
│  ┌──────────────────────────────────────────┐              │
│  │ Delivery Options:                         │              │
│  │  ├─ DELIVERED (success)                   │              │
│  │  └─ CONTACT_FAILED → RETURN_TO_OFFICE    │              │
│  └──────────────────────────────────────────┘              │
└─────────────────────────────────────────────────────────────┘
```

---

## Status Definitions

### 1. **REGISTERED**
- **When**: Merchant creates a new package
- **Updated By**: Merchant App
- **Next Action**: Office receives package physically

### 2. **ARRIVED_AT_OFFICE**
- **When**: Package physically arrives at office
- **Updated By**: Office Web Panel
- **Next Action**: Office assigns to a rider

### 3. **ASSIGNED_TO_RIDER**
- **When**: Office assigns package to a rider
- **Updated By**: Office Web Panel
- **Next Action**: Rider picks up package

### 4. **PICKED_UP**
- **When**: Rider picks package from office
- **Updated By**: Rider App
- **Next Action**: Rider contacts customer or starts delivery

### 5. **ON_THE_WAY** ⭐ (Live Tracking Active)
- **When**: Rider clicks "Start Delivery" button
- **Updated By**: Rider App
- **Special**: 
  - **Live location tracking starts**
  - **Merchant app shows rider's live location**
  - **Office web panel shows rider's live location**
- **Next Action**: Delivery attempt

### 6. **DELIVERED**
- **When**: Package successfully delivered to customer
- **Updated By**: Rider App
- **Requirements**: 
  - Delivery proof (photo/signature)
  - COD collection (if applicable)
- **Final Status**: ✅ Complete

### 7. **CONTACT_FAILED**
- **When**: Rider cannot contact customer
- **Updated By**: Rider App
- **Next Action**: Return to office

### 8. **RETURN_TO_OFFICE**
- **When**: Package needs to be returned to office
- **Updated By**: Rider App or Office Web Panel
- **Reason**: Contact failed or delivery failed
- **Next Action**: Office handles return

### 9. **CANCELLED**
- **When**: Package cancelled before dispatch
- **Updated By**: Merchant App or Office Web Panel
- **Final Status**: ❌ Cancelled

---

## Status Transition Rules

### Allowed Transitions

```
REGISTERED
    ↓
ARRIVED_AT_OFFICE
    ↓
ASSIGNED_TO_RIDER
    ↓
PICKED_UP
    ↓
    ├─→ ON_THE_WAY (when rider clicks "Start Delivery")
    │       ↓
    │   DELIVERED ✅
    │
    └─→ CONTACT_FAILED (if rider can't contact)
            ↓
        RETURN_TO_OFFICE
```

### Special Rules

1. **ON_THE_WAY** can only be set by:
   - Rider clicking "Start Delivery" button
   - Cannot be set directly

2. **CONTACT_FAILED** can only be set by:
   - Rider after attempting to contact customer
   - Must be followed by RETURN_TO_OFFICE

3. **Live Tracking** is only active when:
   - Status = **ON_THE_WAY**
   - Rider app is sending location updates

4. **Location Updates Stop** when:
   - Status changes to **DELIVERED**
   - Status changes to **RETURN_TO_OFFICE**
   - Status changes to **CONTACT_FAILED**

---

## Rider Workflow Details

### Step 1: View Assigned Packages
- Rider sees list of assigned packages
- Each package shows:
  - Customer name, address, phone
  - Payment type (COD/Prepaid)
  - Amount (if COD)
  - Package image

### Step 2: Pick Up Package
- Rider clicks "Picked Up" button
- Status: **PICKED_UP**

### Step 3: Contact Customer (Optional but Recommended)
- Rider clicks "Contact Customer" button
- Opens phone dialer with customer number
- **If contact successful**: Continue to delivery
- **If contact failed**: 
  - Update status to **CONTACT_FAILED**
  - Option to mark for **RETURN_TO_OFFICE**

### Step 4: Start Delivery
- Rider clicks **"Start Delivery"** button
- Status changes to **ON_THE_WAY**
- **Live location tracking begins**
- Rider app starts sending location updates (every 10-30 seconds)
- Merchant app shows live map with rider location
- Office web panel shows rider on map

### Step 5: Navigate to Customer
- Rider uses navigation to reach customer
- Location updates continue while status = **ON_THE_WAY**

### Step 6: Complete Delivery
- **Option A - Successful Delivery**:
  - Rider clicks "Delivered" button
  - Capture delivery proof (photo/signature)
  - Collect COD (if applicable)
  - Status: **DELIVERED**
  - Live tracking stops

- **Option B - Failed Delivery**:
  - Rider clicks "Contact Failed" or "Return to Office"
  - Status: **CONTACT_FAILED** → **RETURN_TO_OFFICE**
  - Live tracking stops
  - Return to office

---

## Live Tracking Implementation

### When Live Tracking Starts

#### For Merchant App:
- **Trigger**: Rider clicks "Start Delivery" button
- **Status Change**: Status → **ON_THE_WAY**
- **Backend Action**: 
  - Create entry in `rider_locations` table
  - Start broadcasting location updates to merchant app
  - Notify merchant app (WebSocket/Pusher)
- **When Status Changes**: Stop broadcasting to merchant app

#### For Office Web Panel:
- **Always Active**: Office can see all riders' locations at all times
- **No Status Restriction**: Rider location visible regardless of package status
- **Backend Action**: 
  - Rider app continuously sends location updates (when app is active)
  - Office web panel receives all rider location updates
  - Updates every 10-30 seconds

### Location Update Frequency
- **Rider App**: Sends location updates every 10-30 seconds (when app is active)
- **Office Web Panel**: Receives all rider location updates (always)
- **Merchant App**: Receives location updates only when package status = **ON_THE_WAY**

### What Merchant Sees
- **Condition**: Only when package status = **ON_THE_WAY**
- Map with:
  - Rider's current location (moving marker)
  - Customer delivery address (destination marker)
  - Route line (if available)
  - Estimated time remaining
  - Distance remaining
  - Rider name/ID
- **When status changes**: Live tracking stops (no location shown)

### What Office Sees
- **Condition**: ALWAYS (when riders are online/active)
- **No Status Restriction**: Can see all riders' locations regardless of package status
- Map with:
  - All active riders (different colored markers)
  - Rider names/IDs
  - Current package count per rider
  - Rider status (available, busy, offline)
  - Click rider to see assigned packages
  - Filter by rider, status, zone
  - Real-time location updates for all riders

---

## Contact Customer Feature

### Implementation
- **Button**: "Contact Customer" in rider app
- **Action**: Opens phone dialer with customer number
- **Result Handling**:
  - **Success**: Rider continues delivery
  - **Failed**: Rider updates status to **CONTACT_FAILED**

### Status Updates
- **If Contact Successful**: No status change, continue to "Start Delivery"
- **If Contact Failed**: 
  1. Status → **CONTACT_FAILED**
  2. Option to mark → **RETURN_TO_OFFICE**
  3. Rider returns package to office

---

## Status History Timeline

Every status change should be logged in `package_status_history` table:

```
Package #12345 Timeline:
─────────────────────────────────────────
2024-12-01 10:00 → REGISTERED (by Merchant: John)
2024-12-01 14:30 → ARRIVED_AT_OFFICE (by Office: Admin)
2024-12-01 15:00 → ASSIGNED_TO_RIDER (by Office: Admin, Rider: Rider001)
2024-12-01 16:00 → PICKED_UP (by Rider: Rider001)
2024-12-01 16:15 → ON_THE_WAY (by Rider: Rider001) [Live tracking started]
2024-12-01 17:00 → DELIVERED (by Rider: Rider001)
```

---

## Error Handling

### Invalid Status Transitions
- Backend should validate status transitions
- Return error if invalid transition attempted
- Example: Cannot go from REGISTERED directly to DELIVERED

### Missing Location Updates
- If rider stops sending location updates:
  - Show last known location
  - Mark as "Location update delayed"
  - Alert office if no updates for > 5 minutes

### Contact Failed Handling
- If rider marks CONTACT_FAILED:
  - Log reason (optional)
  - Allow retry (change back to PICKED_UP)
  - Or proceed to RETURN_TO_OFFICE

---

## Next Steps

1. Implement status validation in backend
2. Create "Start Delivery" button in rider app
3. Set up live location tracking
4. Create merchant app live map view
5. Create office web panel rider tracking map
6. Implement contact customer feature

Ready to implement! 🚀

