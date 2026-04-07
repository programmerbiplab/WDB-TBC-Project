# Database Normalization Process

**Student:** Biplab Prasad Gajurel  
**Student ID:** 25024641 
**Date:** January 10, 2025

---

## Overview

This document demonstrates the complete normalization process for the World Hotels booking system, transforming an unnormalized structure into Third Normal Form (3NF) using project-specific examples.

---

## Normalization Goals

1. Eliminate data redundancy
2. Ensure data integrity
3. Improve query performance
4. Enable easier maintenance and updates
5. Prevent update, insertion, and deletion anomalies

---

# STEP 1: FIRST NORMAL FORM (1NF)

## Rules for 1NF:
1. Eliminate repeating groups
2. Each cell contains only atomic (single) values
3. Each row must be unique (has primary key)
4. Each column contains values of a single type

---

## Problems in Unnormalized Form

### Issue 1: Repeating Groups (Pricing)

**Before (UNF):**
```
BOOKING_TABLE:
- booking_id
- hotel_city
- standard_room_peak_price      Repeating group
- standard_room_offpeak_price   Repeating group
- double_room_peak_price        Repeating group
- double_room_offpeak_price     Repeating group
- family_room_peak_price        Repeating group
- family_room_offpeak_price     Repeating group
```

**Problem:** 6 different price columns for combinations of room types and seasons

### Issue 2: Non-Atomic Values (Room Features)

**Before (UNF):**
```
- room_features: "WiFi, Mini-bar, TV, Breakfast"  ← Multiple values in one cell
```

### Issue 3: Multiple Entities in One Table

All booking, user, hotel, room, and pricing data in single table causing massive redundancy.

---

## Converting to 1NF

### Table 1: users
```sql
users
-----
user_id INT PRIMARY KEY AUTO_INCREMENT
email VARCHAR(255) UNIQUE NOT NULL
password_hash VARCHAR(255) NOT NULL
first_name VARCHAR(100)
last_name VARCHAR(100)
phone VARCHAR(20)
user_type ENUM('standard', 'admin') DEFAULT 'standard'
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

**Why 1NF:**
- ✅ Each column contains atomic values
- ✅ No repeating groups
- ✅ Primary key (user_id) makes each row unique
- ✅ All values in a column are of the same type

**Example Data:**
| user_id | email | first_name | last_name | user_type |
|---------|-------|------------|-----------|-----------|
| 1 | biplab@example.com | Biplab | Gajurel | standard |
| 2 | admin@worldhotels.com | Admin | User | admin |

---

### Table 2: hotels
```sql
hotels
------
hotel_id INT PRIMARY KEY AUTO_INCREMENT
city VARCHAR(100) NOT NULL
capacity INT NOT NULL
address TEXT
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

**Why 1NF:**
- Single value per cell
- Unique identifier (hotel_id)
- No repeating groups

**Example Data (17 Hotels):**
| hotel_id | city | capacity | address |
|----------|------|----------|---------|
| 1 | Aberdeen | 90 | 10 Union Street, Aberdeen |
| 2 | Belfast | 80 | 15 Royal Avenue, Belfast |
| 3 | Birmingham | 110 | 25 High Street, Birmingham |
| 8 | London | 160 | 100 Oxford Street, London |
| ... | ... | ... | ... |

---

### Table 3: room_types
```sql
room_types
----------
room_type_id INT PRIMARY KEY AUTO_INCREMENT
type_name VARCHAR(50) NOT NULL
max_guests INT NOT NULL
price_multiplier DECIMAL(3,2) NOT NULL
has_wifi BOOLEAN DEFAULT TRUE
has_minibar BOOLEAN DEFAULT TRUE
has_tv BOOLEAN DEFAULT TRUE
includes_breakfast BOOLEAN DEFAULT TRUE
```

**Why 1NF:**
- ✅ Room features now stored as separate atomic boolean columns
- ✅ No "WiFi, Mini-bar, TV" in single cell
- ✅ Each feature is independent atomic value

**Example Data:**
| room_type_id | type_name | max_guests | price_multiplier |
|--------------|-----------|------------|------------------|
| 1 | Standard | 1 | 1.00 |
| 2 | Double | 2 | 1.20 |
| 3 | Family | 4 | 1.50 |

**Explanation:**
- Standard room: base price × 1.00 = base price
- Double room: base price × 1.20 = base + 20%
- Family room: base price × 1.50 = base + 50%

---

### Table 4: rooms
```sql
rooms
-----
room_id INT PRIMARY KEY AUTO_INCREMENT
hotel_id INT NOT NULL
room_type_id INT NOT NULL
room_number VARCHAR(10) NOT NULL
status ENUM('available', 'booked', 'maintenance') DEFAULT 'available'
FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
```

**Why 1NF:**
- ✅ Each room is a separate row
- ✅ Atomic values only
- ✅ Foreign keys link to other tables

**Example Data (London - 160 rooms):**
| room_id | hotel_id | room_type_id | room_number | status |
|---------|----------|--------------|-------------|---------|
| 1 | 8 | 1 | 101 | available |
| 2 | 8 | 1 | 102 | available |
| ... | 8 | 1 | ... | available | (48 Standard = 30%)
| 49 | 8 | 2 | 201 | available |
| ... | 8 | 2 | ... | available | (80 Double = 50%)
| 129 | 8 | 3 | 301 | available |
| ... | 8 | 3 | ... | available | (32 Family = 20%)

---

### Table 5: seasons
```sql
seasons
-------
season_id INT PRIMARY KEY AUTO_INCREMENT
season_name VARCHAR(20) NOT NULL
start_month INT NOT NULL
end_month INT NOT NULL
```

**Why 1NF:**
- ✅ Seasons separated from pricing
- ✅ Atomic values
- ✅ No repeating columns

**Example Data:**
| season_id | season_name | start_month | end_month |
|-----------|-------------|-------------|-----------|
| 1 | Peak | 4 | 8 |
| 2 | Peak | 11 | 12 |
| 3 | Off-Peak | 1 | 3 |
| 4 | Off-Peak | 9 | 10 |

**Note:** Peak season has 2 rows (Apr-Aug and Nov-Dec)

---

### Table 6: prices
```sql
prices
------
price_id INT PRIMARY KEY AUTO_INCREMENT
hotel_id INT NOT NULL
room_type_id INT NOT NULL
season_id INT NOT NULL
price_gbp DECIMAL(10,2) NOT NULL
FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
FOREIGN KEY (season_id) REFERENCES seasons(season_id)
```

**Why 1NF:**
- ✅ Instead of 6 price columns, we have ROWS for each combination
- ✅ Each price is atomic
- ✅ Eliminates repeating groups

**Example Data (London):**
| price_id | hotel_id | room_type_id | season_id | price_gbp |
|----------|----------|--------------|-----------|-----------|
| 1 | 8 (London) | 1 (Standard) | 1 (Peak Apr-Aug) | 200.00 |
| 2 | 8 (London) | 1 (Standard) | 2 (Peak Nov-Dec) | 200.00 |
| 3 | 8 (London) | 1 (Standard) | 3 (Off-Peak Jan-Mar) | 100.00 |
| 4 | 8 (London) | 1 (Standard) | 4 (Off-Peak Sep-Oct) | 100.00 |
| 5 | 8 (London) | 2 (Double) | 1 (Peak) | 240.00 |
| 6 | 8 (London) | 2 (Double) | 3 (Off-Peak) | 120.00 |
| ... | ... | ... | ... | ... |

**Total rows per hotel:** 4 seasons × 3 room types = 12 rows per hotel

---

### Table 7: bookings
```sql
bookings
--------
booking_id INT PRIMARY KEY AUTO_INCREMENT
user_id INT NOT NULL
room_id INT NOT NULL
check_in_date DATE NOT NULL
check_out_date DATE NOT NULL
number_of_guests INT NOT NULL
booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
status ENUM('confirmed', 'cancelled', 'completed') DEFAULT 'confirmed'
FOREIGN KEY (user_id) REFERENCES users(user_id)
FOREIGN KEY (room_id) REFERENCES rooms(room_id)
```

**Why 1NF:**
- ✅ One booking per row
- ✅ All values atomic
- ✅ Unique booking_id

---

### Table 8: booking_pricing
```sql
booking_pricing
---------------
pricing_id INT PRIMARY KEY AUTO_INCREMENT
booking_id INT NOT NULL UNIQUE
base_price DECIMAL(10,2) NOT NULL
discount_percentage INT DEFAULT 0
discount_amount DECIMAL(10,2) DEFAULT 0.00
final_price DECIMAL(10,2) NOT NULL
cancellation_charge DECIMAL(10,2) DEFAULT 0.00
currency_code VARCHAR(3) DEFAULT 'GBP'
FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
```

**Why 1NF:**
- ✅ Pricing details separated from booking
- ✅ One-to-one relationship with booking
- ✅ All values atomic

---

### Table 9: exchange_rates
```sql
exchange_rates
--------------
rate_id INT PRIMARY KEY AUTO_INCREMENT
currency_code VARCHAR(3) UNIQUE NOT NULL
currency_name VARCHAR(50) NOT NULL
rate_to_gbp DECIMAL(10,6) NOT NULL
effective_date DATE NOT NULL
is_active BOOLEAN DEFAULT TRUE
```

**Why 1NF:**
- ✅ Each currency is separate row
- ✅ Atomic values
- ✅ No multiple currencies in one cell

**Example Data:**
| rate_id | currency_code | currency_name | rate_to_gbp |
|---------|---------------|---------------|-------------|
| 1 | GBP | British Pound | 1.000000 |
| 2 | USD | US Dollar | 0.790000 |
| 3 | EUR | Euro | 0.860000 |
| 4 | NPR | Nepalese Rupee | 0.006000 |

---

## Result: All Tables are now in 1NF

All tables now have:
- Atomic values only
- No repeating groups
- Primary keys
- Single data type per column

---

# STEP 2: SECOND NORMAL FORM (2NF)

## Rules for 2NF:
1. Must be in 1NF first
2. Remove partial dependencies (non-key attributes depending on only PART of a composite key)

---

## Analysis for Partial Dependencies

**Key Concept:** Partial dependency occurs when a non-key attribute depends on only PART of a composite primary key, not the whole key.

### Checking Each Table:

#### Table: users
- **Primary Key:** user_id (SINGLE column)
- **Analysis:** Since primary key is single column, NO possibility of partial dependency
- **Result:** Already in 2NF

#### Table: hotels
- **Primary Key:** hotel_id (SINGLE column)
- **Analysis:** All attributes (city, capacity, address) depend on complete primary key
- **Result:** Already in 2NF

#### Table: room_types
- **Primary Key:** room_type_id (SINGLE column)
- **Analysis:** No composite key, no partial dependency possible
- **Result:** Already in 2NF

#### Table: rooms
- **Primary Key:** room_id (SINGLE column)
- **Analysis:** hotel_id, room_type_id, room_number all depend on full room_id
- **Result:** Already in 2NF

#### Table: seasons
- **Primary Key:** season_id (SINGLE column)
- **Result:** Already in 2NF

#### Table: prices
- **Primary Key:** price_id (SINGLE column, surrogate key)
- **Alternative:** Could use composite key (hotel_id, room_type_id, season_id)

**Let's analyze the composite key scenario:**

If we used composite key (hotel_id, room_type_id, season_id):
- Does price_gbp depend on ONLY hotel_id? **NO**
- Does price_gbp depend on ONLY room_type_id? **NO**
- Does price_gbp depend on ONLY season_id? **NO**
- Does price_gbp depend on ALL THREE? **YES!**

**Explanation:** 
- London's price ≠ just depends on London
- Double room price ≠ just depends on room type
- Peak price ≠ just depends on season
- **Price depends on the COMBINATION**: London + Double + Peak = £240

**Result:** Already in 2NF (no partial dependency)

#### Table: bookings
- **Primary Key:** booking_id (SINGLE column)
- **Result:** Already in 2NF

#### Table: booking_pricing
- **Primary Key:** pricing_id (SINGLE column)
- **Result:** Already in 2NF

#### Table: exchange_rates
- **Primary Key:** rate_id (SINGLE column)
- **Result:** Already in 2NF

---

## Why Using Single-Column Primary Keys Helps

By using surrogate keys (auto-increment integers) instead of composite keys, we:
- Automatically avoid partial dependencies
- Simplify foreign key references
- Improve join performance
- Make queries easier to write

---

## Result: All Tables in 2NF ✅

All tables satisfy 2NF because:
- They are in 1NF
- No partial dependencies exist
- All non-key attributes depend on complete primary key

---

# STEP 3: THIRD NORMAL FORM (3NF)

## Rules for 3NF:
1. Must be in 2NF first
2. Remove transitive dependencies (non-key attributes depending on other non-key attributes)

---

## What is Transitive Dependency?

**Definition:** A → B → C (where A is primary key)
- If column B depends on A (primary key)
- And column C depends on B (non-key)
- Then C transitively depends on A through B
- **This violates 3NF!**

---

## Checking Each Table for Transitive Dependencies

### Table: users

**Attributes:** user_id (PK), email, password_hash, first_name, last_name, phone, user_type, created_at

**Check for transitive dependencies:**

Does any non-key attribute depend on another non-key attribute?

- email → depends directly on user_id 
- password_hash → depends directly on user_id 
- first_name → depends directly on user_id 
- last_name → depends directly on user_id 
- phone → depends directly on user_id 
- user_type → depends directly on user_id 
- created_at → depends directly on user_id 

**Question:** Does first_name depend on email?
**Answer:** NO - first_name is directly associated with the user

**Result:** No transitive dependencies - Already in 3NF

---

### Table: hotels

**Attributes:** hotel_id (PK), city, capacity, address, created_at

**Critical Analysis:**

**Question 1:** Does capacity depend on city?
- If YES, we'd have: hotel_id → city → capacity (transitive!)
- But NO! Different hotels in same city can have different capacities
  - Example: London Hotel A = 160 rooms
  - Example: London Hotel B = 150 rooms (if we had multiple London hotels)

**Question 2:** Does address depend on city?
- If YES, we'd have: hotel_id → city → address (transitive!)
- But NO! Address is specific to each individual hotel
  - City is just PART of the address
  - Full address includes street, number, postcode

**Result:** No transitive dependencies - Already in 3NF

---

### Table: room_types

**Attributes:** room_type_id (PK), type_name, max_guests, price_multiplier, has_wifi, has_minibar, has_tv, includes_breakfast

**Check:**

**Question:** Does max_guests depend on type_name?
- Standard → 1 guest
- Double → 2 guests
- Family → 4 guests

**Analysis:** This MIGHT seem like transitive dependency, but:
- type_name is essentially an alternate key (unique identifier)
- max_guests is a defining characteristic of the room type
- Both depend directly on room_type_id
- They don't depend ON EACH OTHER, they're both properties of the same entity

**Result:** No transitive dependencies - Already in 3NF

---

### Table: rooms

**Attributes:** room_id (PK), hotel_id (FK), room_type_id (FK), room_number, status

**Check:**

All attributes either:
- Are foreign keys linking to other tables 
- Or depend directly on room_id 

**Result:** No transitive dependencies - Already in 3NF

---

### Table: seasons

**Attributes:** season_id (PK), season_name, start_month, end_month

**Check:**

Does end_month depend on start_month?
- NO - both are independent properties of a season
- They happen to define a range, but neither determines the other

**Result:** No transitive dependencies - Already in 3NF

---

### Table: prices

**Attributes:** price_id (PK), hotel_id (FK), room_type_id (FK), season_id (FK), price_gbp

**Check:**

price_gbp depends on the COMBINATION of hotel, room type, and season.
- It doesn't depend on any single foreign key
- It's not derived from other non-key attributes

**Result:** No transitive dependencies - Already in 3NF

---

### Table: bookings

**Attributes:** booking_id (PK), user_id (FK), room_id (FK), check_in_date, check_out_date, number_of_guests, booking_date, status

**Critical Check:**

**Question:** Does check_out_date depend on check_in_date?
**Answer:** NO! 
- User can choose any checkout date (up to 30 days after check-in)
- check_out is independent choice, not calculated from check_in
- Both depend directly on booking_id

**Question:** Does number_of_guests depend on room_id?
**Answer:** NO!
- room_id determines MAX guests allowed
- But actual number_of_guests is user's choice (up to that max)
- Example: Family room (max 4) can be booked for 2 guests

**Result:** No transitive dependencies - Already in 3NF

---

### Table: booking_pricing

**Attributes:** pricing_id (PK), booking_id (FK), base_price, discount_percentage, discount_amount, final_price, cancellation_charge, currency_code

**POTENTIAL ISSUE FOUND!**

**Question:** Does discount_amount depend on discount_percentage?

**Analysis:**
- discount_amount = base_price × (discount_percentage / 100)
- So discount_amount IS calculated from other attributes!
- This creates: pricing_id → base_price, discount_percentage → discount_amount

**Is this a 3NF violation?**

**Answer:** YES, technically this is a transitive dependency!

**But:** discount_amount is a **derived/calculated attribute**
- It's stored for performance (avoid recalculation)
- It's for historical record (if prices change later)

**Solution Options:**

**Option 1:** Remove discount_amount (pure 3NF)
```sql
booking_pricing
---------------
pricing_id (PK)
booking_id (FK)
base_price
discount_percentage
final_price  -- Only store final result
cancellation_charge
currency_code
```

**Option 2:** Keep it with justification (practical approach)
- Storing for audit trail
- Avoiding calculation errors
- Performance optimization
- **This is acceptable in real-world applications!**

**Our Choice:** Option 2 (with documentation)

**Justification:**
- Booking prices must be immutable once created
- discount_amount serves as audit trail
- Prevents recalculation errors
- Industry best practice for financial data

**Result:** Functionally in 3NF (with documented exception for audit purposes)

---

### Table: exchange_rates

**Attributes:** rate_id (PK), currency_code, currency_name, rate_to_gbp, effective_date, is_active

**Check:**

Does currency_name depend on currency_code?
- USD → "US Dollar"
- This COULD be seen as transitive

**Analysis:**
- currency_code is essentially an alternate key (unique)
- But we store currency_name for convenience
- In pure 3NF, we might normalize further

**Real-world decision:** Keep it
- Both are defining characteristics of currency
- currency_code is internationally standardized (ISO 4217)
- Minor denormalization for usability

**Result:** Acceptable 3NF (minor denormalization documented)

---

## Final 3NF Schema

All tables are in 3NF with justified exceptions for:
1. booking_pricing.discount_amount (audit trail)
2. exchange_rates.currency_name (usability)

These are **intentional design decisions** for real-world functionality, not oversights.

---

# SUMMARY OF NORMALIZATION

## From UNF to 3NF:

### Unnormalized Form (UNF)
- One massive table
- Repeating groups (6 price columns)
- Non-atomic values (room features in one cell)
- Massive redundancy
- Update/insertion/deletion anomalies

### First Normal Form (1NF)
- 9 separate tables
- All atomic values
- No repeating groups
- Primary keys for all tables
- Eliminated most redundancy

### Second Normal Form (2NF)
- No partial dependencies
- All non-key attributes depend on complete primary key
- Used surrogate keys to simplify

### Third Normal Form (3NF)
- No transitive dependencies
- All non-key attributes depend ONLY on primary key
- Two justified exceptions for business requirements

---

## Benefits Achieved

1. **Data Integrity:** No inconsistent data possible
2. **No Redundancy:** Each fact stored once
3. **Easy Updates:** Change price in one place
4. **Scalability:** Easy to add new hotels, room types, currencies
5. **Performance:** Efficient queries with proper indexing
6. **Maintainability:** Clear, logical structure

---

## Project-Specific Example: Adding New Hotel

**UNF:** Would require adding data to massive table with all booking history

**3NF:**
```sql
-- Simply insert into hotels table
INSERT INTO hotels (city, capacity, address) 
VALUES ('Liverpool', 120, '50 Bold Street, Liverpool');

-- Add rooms (automated script would generate 120 rooms)
-- Add prices (12 rows: 4 seasons × 3 room types)
```

**Result:** Clean, efficient, no impact on existing data!

---

*Normalization documentation completed: January 10, 2025*
*All design decisions justified with project-specific examples*