# 🗄️ Database Schema Design

## Core Tables

### 1. **users** (Extended from Laravel default)
```sql
- id (bigint, primary key)
- name (string)
- email (string, unique)
- password (string, hashed)
- phone (string, nullable)
- role (enum: 'super_admin', 'office_manager', 'office_staff', 'merchant', 'rider')
- status (enum: 'active', 'inactive', 'suspended')
- email_verified_at (timestamp, nullable)
- remember_token (string, nullable)
- created_at, updated_at
```

### 2. **merchants**
```sql
- id (bigint, primary key)
- user_id (bigint, foreign key → users.id)
- business_name (string)
- business_address (text)
- business_phone (string)
- business_email (string)
- registration_number (string, nullable)
- status (enum: 'pending', 'approved', 'suspended')
- rating (decimal, default 0)
- total_deliveries (integer, default 0)
- created_at, updated_at
```

### 3. **riders**
```sql
- id (bigint, primary key)
- user_id (bigint, foreign key → users.id)
- name (string)
- phone (string)
- vehicle_type (enum: 'bike', 'motorcycle', 'car', 'van')
- vehicle_number (string, nullable)
- license_number (string, nullable)
- zone_id (bigint, foreign key → zones.id, nullable)
- status (enum: 'available', 'busy', 'offline', 'on_break')
- current_latitude (decimal, nullable)
- current_longitude (decimal, nullable)
- last_location_update (timestamp, nullable)
- rating (decimal, default 0)
- total_deliveries (integer, default 0)
- created_at, updated_at
```

### 4. **zones**
```sql
- id (bigint, primary key)
- name (string)
- description (text, nullable)
- boundaries (json) // GeoJSON polygon
- status (enum: 'active', 'inactive')
- created_at, updated_at
```

### 5. **packages**
```sql
- id (bigint, primary key)
- tracking_code (string, unique, indexed)
- merchant_id (bigint, foreign key → merchants.id)
- customer_name (string)
- customer_phone (string)
- customer_email (string, nullable)
- delivery_address (text)
- delivery_latitude (decimal, nullable)
- delivery_longitude (decimal, nullable)
- payment_type (enum: 'cod', 'prepaid')
- amount (decimal, default 0) // COD amount or prepaid amount
- package_image (string, nullable) // URL to image
- package_description (text, nullable)
- status (enum: 'registered', 'arrived_at_office', 'assigned_to_rider', 
          'picked_up', 'on_the_way', 'delivered', 'contact_failed', 
          'return_to_office', 'cancelled')
- current_rider_id (bigint, foreign key → riders.id, nullable)
- assigned_at (timestamp, nullable)
- picked_up_at (timestamp, nullable)
- delivered_at (timestamp, nullable)
- delivery_attempts (integer, default 0)
- delivery_notes (text, nullable)
- created_at, updated_at
```

### 6. **package_status_history**
```sql
- id (bigint, primary key)
- package_id (bigint, foreign key → packages.id)
- status (string)
- changed_by_user_id (bigint, foreign key → users.id, nullable)
- changed_by_type (enum: 'merchant', 'office', 'rider', 'system')
- notes (text, nullable)
- latitude (decimal, nullable)
- longitude (decimal, nullable)
- created_at
```

### 7. **rider_assignments**
```sql
- id (bigint, primary key)
- package_id (bigint, foreign key → packages.id)
- rider_id (bigint, foreign key → riders.id)
- assigned_by_user_id (bigint, foreign key → users.id)
- assigned_at (timestamp)
- delivery_sequence (integer, nullable) // Order in delivery route
- status (enum: 'assigned', 'picked_up', 'delivered', 'cancelled')
- created_at, updated_at
```

### 8. **delivery_proofs**
```sql
- id (bigint, primary key)
- package_id (bigint, foreign key → packages.id)
- rider_id (bigint, foreign key → riders.id)
- proof_type (enum: 'photo', 'signature', 'otp')
- proof_data (text) // URL to image or signature data
- delivery_latitude (decimal, nullable)
- delivery_longitude (decimal, nullable)
- delivered_to_name (string, nullable) // Name of person who received
- delivered_to_phone (string, nullable)
- notes (text, nullable)
- created_at
```

### 9. **cod_collections**
```sql
- id (bigint, primary key)
- package_id (bigint, foreign key → packages.id)
- rider_id (bigint, foreign key → riders.id)
- amount (decimal)
- collected_at (timestamp)
- collection_proof (string, nullable) // URL to image
- status (enum: 'pending', 'collected', 'settled')
- settled_at (timestamp, nullable)
- settled_by_user_id (bigint, foreign key → users.id, nullable)
- created_at, updated_at
```

### 10. **rider_locations** (For tracking history)
```sql
- id (bigint, primary key)
- rider_id (bigint, foreign key → riders.id)
- package_id (bigint, foreign key → packages.id, nullable)
- latitude (decimal)
- longitude (decimal)
- speed (decimal, nullable)
- heading (decimal, nullable)
- created_at (timestamp, indexed)
```

### 11. **notifications**
```sql
- id (bigint, primary key)
- user_id (bigint, foreign key → users.id, nullable)
- type (string) // 'package_status', 'cod_collection', etc.
- title (string)
- message (text)
- data (json, nullable) // Additional data
- read_at (timestamp, nullable)
- created_at
```

### 12. **customer_feedback** (Optional - for future use)
```sql
- id (bigint, primary key)
- package_id (bigint, foreign key → packages.id)
- customer_phone (string)
- rating (integer) // 1-5
- comment (text, nullable)
- created_at
```

### 13. **financial_transactions**
```sql
- id (bigint, primary key)
- type (enum: 'cod_collection', 'merchant_payment', 'rider_payment', 'delivery_fee')
- merchant_id (bigint, foreign key → merchants.id, nullable)
- rider_id (bigint, foreign key → riders.id, nullable)
- package_id (bigint, foreign key → packages.id, nullable)
- amount (decimal)
- status (enum: 'pending', 'completed', 'cancelled')
- transaction_date (timestamp)
- notes (text, nullable)
- created_at, updated_at
```

### 14. **delivery_exceptions** (Optional - can be handled via status)
```sql
- id (bigint, primary key)
- package_id (bigint, foreign key → packages.id)
- exception_type (enum: 'address_issue', 'customer_unavailable', 
                  'damaged_package', 'wrong_address', 'refused', 'contact_failed')
- description (text)
- reported_by_user_id (bigint, foreign key → users.id)
- resolved (boolean, default false)
- resolution_notes (text, nullable)
- created_at, updated_at
```

### 15. **office_settings**
```sql
- id (bigint, primary key)
- key (string, unique)
- value (text)
- description (text, nullable)
- created_at, updated_at
```

---

## Indexes (For Performance)

```sql
-- Packages
CREATE INDEX idx_packages_tracking_code ON packages(tracking_code);
CREATE INDEX idx_packages_merchant_id ON packages(merchant_id);
CREATE INDEX idx_packages_status ON packages(status);
CREATE INDEX idx_packages_rider_id ON packages(current_rider_id);
CREATE INDEX idx_packages_created_at ON packages(created_at);

-- Status History
CREATE INDEX idx_status_history_package_id ON package_status_history(package_id);
CREATE INDEX idx_status_history_created_at ON package_status_history(created_at);

-- Rider Locations
CREATE INDEX idx_rider_locations_rider_id ON rider_locations(rider_id);
CREATE INDEX idx_rider_locations_created_at ON rider_locations(created_at);
CREATE INDEX idx_rider_locations_package_id ON rider_locations(package_id);

-- Notifications
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_read_at ON notifications(read_at);

-- COD Collections
CREATE INDEX idx_cod_collections_rider_id ON cod_collections(rider_id);
CREATE INDEX idx_cod_collections_status ON cod_collections(status);
```

---

## Relationships Summary

```
users (1) ──→ (1) merchants
users (1) ──→ (1) riders

merchants (1) ──→ (N) packages
riders (1) ──→ (N) packages (via current_rider_id)
riders (1) ──→ (N) rider_assignments
riders (1) ──→ (N) rider_locations
zones (1) ──→ (N) riders

packages (1) ──→ (N) package_status_history
packages (1) ──→ (N) rider_assignments
packages (1) ──→ (1) delivery_proofs
packages (1) ──→ (1) cod_collections
packages (1) ──→ (1) customer_feedback
packages (1) ──→ (N) delivery_exceptions
```

---

## Sample Laravel Migrations Structure

Would you like me to create the actual Laravel migration files for these tables?

