# World Hotels - Requirements Analysis

**Date:** January 10, 2025  
**Student:** Biplab Prasad Gajurel 
**Student ID:** 25024641

---

## 1. Case Study Overview

World Hotels (WH) operates across 17 UK cities and requires an online booking system for:
- Customer online room booking
- Booking management
- Business intelligence reports

---

## 2. Key Entities

### 2.1 Hotels (17 UK Cities)

| City | Capacity | Peak Price (£) | Off-Peak (£) |
|------|----------|---------------|--------------|
| Aberdeen | 90 | 140 | 70 |
| Belfast | 80 | 130 | 70 |
| Birmingham | 110 | 150 | 75 |
| Bristol | 100 | 140 | 70 |
| Cardiff | 90 | 130 | 70 |
| Edinburgh | 120 | 160 | 80 |
| Glasgow | 140 | 150 | 75 |
| London | 160 | 200 | 100 |
| Manchester | 150 | 180 | 90 |
| Newcastle | 90 | 120 | 70 |
| Norwich | 90 | 130 | 70 |
| Nottingham | 110 | 130 | 70 |
| Oxford | 90 | 180 | 90 |
| Plymouth | 80 | 180 | 90 |
| Swansea | 70 | 130 | 70 |
| Bournemouth | 90 | 130 | 70 |
| Kent | 100 | 140 | 80 |

### 2.2 Room Types

**Standard Room (30% capacity)**
- Maximum 1 guest
- Base price

**Double Room (50% capacity)**
- Maximum 2 guests  
- Base price + 20%
- Extra guest: +10% of base

**Family Room (20% capacity)**
- Maximum 4 guests
- Base price + 50%

**Features:** WiFi, Mini-bar, TV, Breakfast

### 2.3 Users

**Standard Users:**
- Register via website
- Book, view, cancel bookings
- Update profile

**Admin Users:**
- Manage hotels, prices, users
- Generate reports
- Full system access

### 2.4 Seasons

**Peak Season:**
- April to August (inclusive)
- November to December (inclusive)

**Off-Peak Season:**
- January to March
- September to October

**Determination:** Based on check-in date

---

## 3. Business Rules

### 3.1 Booking Rules

**Advance Booking:** Up to 90 days (3 months)  
**Maximum Stay:** 30 days per booking  
**Unique Booking ID:** Auto-generated  
**Receipt:** Generated after booking

### 3.2 Discount Structure

| Days in Advance | Discount |
|----------------|----------|
| 80-90 days | 30% |
| 60-79 days | 20% |
| 45-59 days | 10% |
| Under 45 days | 0% |

### 3.3 Cancellation Policy

| Days Before Check-in | Charge |
|---------------------|--------|
| Before 60 days | 0% |
| 30-60 days | 50% |
| Within 30 days | 100% |

---

## 4. Functional Requirements

### 4.1 End User Features

- Browse hotels by city
- Search (city, dates, room type, guests)
- Filter and sort results
- Multi-currency pricing
- User registration/login
- Password management
- Create bookings
- View booking history
- Cancel bookings
- Download receipts
- Profile updates
- Email notifications

### 4.2 Admin Features

- Admin dashboard
- Hotel CRUD operations
- Price management
- Currency/exchange rates
- Room status management
- User management
- Reports:
  - Monthly sales
  - Sales per hotel
  - Top customers
  - Profit/loss analysis

---

## 5. Non-Functional Requirements

### 5.1 Security
- Password hashing (Bcrypt)
- SQL injection prevention
- XSS protection
- CSRF tokens
- Secure sessions
- Input validation

### 5.2 Performance
- Page load < 3 seconds
- Efficient queries
- Proper indexing

### 5.3 Usability
- Intuitive navigation
- Responsive design
- Clear error messages
- Max 5-step booking

---

## 6. LESP Considerations

**Legal:** GDPR, Privacy policy, Terms of service  
**Ethical:** Transparent pricing, Fair policies  
**Social:** Accessibility, Multi-device support  
**Professional:** Code quality, Documentation, Testing

---

## 7. Constraints

- Python Flask (backend only)
- MySQL database
- 3NF normalization
- No WYSIWYG editors
- Python 3.7+
- No real payment (simulation OK)
- 8-minute demo video max

---

## 8. Success Criteria

- **Element 1 (15%):** 3NF database + ERD + normalization
- **Element 2 (15%):** Responsive design (3+ screens)
- **Element 3 (30%):** All features + security
- **Element 4 (20%):** Demo + understanding + LESP
- **Element 5 (20%):** Daily commits

**Target:** 100/100

---

*Analysis completed: January 10, 2025*