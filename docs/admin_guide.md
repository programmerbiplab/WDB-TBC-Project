# World Hotels - Administrator Guide

**Version:** 1.0  
**Date:** January 16, 2025  
**Student:** Biplab  
**Audience:** System Administrators

---

## Table of Contents

1. [Introduction](#introduction)
2. [Admin Access](#admin-access)
3. [Admin Dashboard](#admin-dashboard)
4. [Managing Hotels](#managing-hotels)
5. [Managing Bookings](#managing-bookings)
6. [User Management](#user-management)
7. [Reports & Analytics](#reports--analytics)
8. [System Maintenance](#system-maintenance)
9. [Security Best Practices](#security-best-practices)
10. [Troubleshooting](#troubleshooting)
11. [Database Management](#database-management)

---

## Introduction

### Purpose of This Guide

This guide is for **system administrators** who manage the World Hotels booking system. It covers:
- Admin panel navigation
- Hotel and booking management
- User administration
- System maintenance
- Security practices

### Admin Responsibilities

As an administrator, you are responsible for:
- ✅ Monitoring system performance
- ✅ Managing hotel information
- ✅ Handling booking issues
- ✅ Ensuring data integrity
- ✅ Maintaining security
- ✅ Generating reports

---

## Admin Access

### Admin Account Credentials

**Default Admin Account:**
- **Email:** admin@worldhotels.com
- **Password:** admin123

⚠️ **IMPORTANT:** Change the default password immediately after first login!

### Logging In as Admin

1. Go to homepage
2. Click **"Login"**
3. Enter admin credentials
4. You'll be redirected to **Admin Dashboard** (not homepage)

### Admin Navigation

After login, you'll see additional menu items:
- **Admin Panel** (in navigation bar)
- **Admin Dashboard**
- **Manage Hotels**
- **Manage Bookings**
- **Reports**

---

## Admin Dashboard

### Overview

The Admin Dashboard is your central hub for:
- 📊 Key statistics
- 📈 Recent activity
- ⚠️ Alerts and notifications
- 🔍 Quick access to admin functions

### Dashboard Statistics

#### Key Metrics Displayed:

**Total Bookings**
- Count of all bookings in system
- Includes: confirmed, cancelled, completed

**Active Bookings**
- Currently confirmed bookings
- Future check-in dates only

**Total Revenue**
- Sum of all booking payments
- Displayed in GBP (base currency)

**Total Users**
- Count of registered users
- Excludes admin accounts

### Recent Bookings

Dashboard shows **last 10 bookings** with:
- Booking ID
- Guest name
- Hotel city
- Check-in date
- Total amount
- Status

### Quick Actions

From dashboard, you can:
- **View all bookings** → Manage Bookings
- **View all hotels** → Manage Hotels
- **Export data** → Reports section
- **View users** → User Management

---

## Managing Hotels

### View All Hotels

1. Click **"Manage Hotels"** in admin navigation
2. See complete list of all 17 hotels

### Hotel Information Displayed

For each hotel:
- **Hotel ID:** Unique identifier
- **City:** Hotel location
- **Capacity:** Total number of rooms
- **Address:** Full address
- **Created Date:** When added to system

### Add New Hotel

**Note:** Currently implemented as database-only feature.

To add a hotel manually:
1. Access database (MySQL)
2. Run SQL command:
```sql
INSERT INTO hotels (city, capacity, address) 
VALUES ('CityName', 100, 'Full Address Here');
```

3. Generate rooms for the new hotel:
```sql
-- Use stored procedure (if available)
CALL generate_rooms_for_hotel(hotel_id, capacity);
```

4. Add pricing for all room types and seasons

### Edit Hotel Information

**Current Implementation:**
1. Go to **Manage Hotels**
2. Find hotel to edit
3. Click **"Edit"** button
4. Update:
   - City name (if needed)
   - Capacity (room count)
   - Address
5. Click **"Save Changes"**

### Hotel Capacity Management

**Understanding Capacity:**
- Total number of rooms in hotel
- Distribution: 30% Standard, 50% Double, 20% Family

**Example:**
- Capacity: 100 rooms
- Standard: 30 rooms
- Double: 50 rooms
- Family: 20 rooms

**Changing Capacity:**
⚠️ Changing capacity requires room regeneration in database

---

## Managing Bookings

### View All Bookings

1. Click **"Manage Bookings"** in admin navigation
2. Complete list of all bookings displayed

### Booking Information

Each booking shows:
- **Booking ID:** Unique identifier (e.g., #12345)
- **Guest Name:** Customer full name
- **Email:** Guest contact
- **Hotel:** City location
- **Room:** Type and room number
- **Check-in/Check-out:** Stay dates
- **Nights:** Duration of stay
- **Guests:** Number of people
- **Amount:** Total payment
- **Discount:** If applicable
- **Status:** Confirmed/Cancelled/Completed
- **Booked On:** Booking date/time

### Filter Bookings

Use filters to find specific bookings:

**By Status:**
- All Statuses
- Confirmed
- Cancelled
- Completed

**By Hotel:**
- Select specific city
- Shows only that hotel's bookings

**By Date Range:**
- From Date: Start of range
- To Date: End of range
- Filters by check-in date

**By Search:**
- Search by Booking ID
- Search by Guest Name
- Search by Email

### Update Booking Status

**To change a booking status:**

1. Find the booking
2. Click **"Actions"** dropdown
3. Select new status:
   - Confirmed
   - Cancelled
   - Completed
4. Confirm the change

**Status Meanings:**
- **Confirmed:** Active, upcoming booking
- **Cancelled:** Booking cancelled by user or admin
- **Completed:** Guest has checked out

### Cancel Booking (Admin)

**To cancel a booking as admin:**

1. Find the booking in list
2. Click **"Cancel"** button
3. Review cancellation policy
4. Confirm cancellation

**Admin Cancellation:**
- Can cancel any booking
- Cancellation charges still apply per policy
- Guest receives cancellation email
- Refund processed automatically

### View Booking Details

1. Click **"View"** on any booking
2. See complete booking information
3. View payment breakdown
4. See cancellation policy for that booking

### Export Bookings

**Export all bookings to CSV:**

1. Go to **Manage Bookings**
2. Click **"📥 Export All Bookings"** (top right)
3. CSV file downloads automatically
4. Open in Excel/Google Sheets

**CSV Contains:**
- All booking details
- Guest information
- Payment information
- Booking dates
- Status

**Use Cases:**
- Financial reporting
- Backup records
- Data analysis
- Accounting integration

---

## User Management

### View All Users

**Current Implementation:**
Access via database query:
```sql
SELECT user_id, email, first_name, last_name, user_type, created_at
FROM users
ORDER BY created_at DESC;
```

### User Information

For each user:
- **User ID:** Unique identifier
- **Email:** Login credential
- **Full Name:** First + Last name
- **Phone:** Contact number
- **User Type:** standard or admin
- **Created:** Registration date
- **Total Bookings:** Count of bookings made

### Promote User to Admin

**To make a user an admin:**
```sql
UPDATE users 
SET user_type = 'admin' 
WHERE user_id = [USER_ID];
```

⚠️ **Caution:** Admins have full system access!

### Demote Admin to Standard User

**To remove admin privileges:**
```sql
UPDATE users 
SET user_type = 'standard' 
WHERE user_id = [USER_ID];
```

### Delete User Account

**Only if:**
- User has no active bookings
- User requests account deletion
- Legal/compliance requirement

**Process:**
```sql
-- Check for active bookings first
SELECT COUNT(*) FROM bookings 
WHERE user_id = [USER_ID] 
AND status = 'confirmed' 
AND check_in_date >= CURDATE();

-- If no active bookings, proceed
DELETE FROM users WHERE user_id = [USER_ID];
```

⚠️ **Note:** This will CASCADE delete all user's booking history

### Reset User Password

**Currently:** Manual process

**Steps:**
1. Generate new password (use bcrypt)
2. Update database:
```python
# Python example
from bcrypt import hashpw, gensalt

new_password = "NewPassword123"
hashed = hashpw(new_password.encode('utf-8'), gensalt())

# Then update in database
UPDATE users 
SET password_hash = '[HASHED_PASSWORD]' 
WHERE user_id = [USER_ID];
```

3. Email user their new password
4. User should change on first login

---

## Reports & Analytics

### Available Reports

#### 1. Booking Summary Report

**What it shows:**
- Total bookings
- Revenue by month
- Popular hotels
- Booking trends

**How to generate:**
```sql
SELECT 
    MONTH(booking_date) as month,
    COUNT(*) as total_bookings,
    SUM(bp.final_price) as revenue
FROM bookings b
JOIN booking_pricing bp ON b.booking_id = bp.booking_id
WHERE YEAR(booking_date) = YEAR(CURDATE())
GROUP BY MONTH(booking_date)
ORDER BY month;
```

#### 2. Revenue Report

**Total revenue by hotel:**
```sql
SELECT 
    h.city,
    COUNT(b.booking_id) as total_bookings,
    SUM(bp.final_price) as total_revenue,
    AVG(bp.final_price) as avg_booking_value
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
JOIN bookings b ON r.room_id = b.room_id
JOIN booking_pricing bp ON b.booking_id = bp.booking_id
GROUP BY h.city
ORDER BY total_revenue DESC;
```

#### 3. Occupancy Report

**Room occupancy by hotel:**
```sql
SELECT 
    h.city,
    h.capacity as total_rooms,
    COUNT(DISTINCT r.room_id) as booked_rooms,
    ROUND(COUNT(DISTINCT r.room_id) / h.capacity * 100, 2) as occupancy_rate
FROM hotels h
JOIN rooms r ON h.hotel_id = r.hotel_id
JOIN bookings b ON r.room_id = b.room_id
WHERE b.status = 'confirmed'
AND CURDATE() BETWEEN b.check_in_date AND b.check_out_date
GROUP BY h.city, h.capacity;
```

#### 4. Cancellation Report

**Cancellation rates:**
```sql
SELECT 
    h.city,
    COUNT(b.booking_id) as total_bookings,
    SUM(CASE WHEN b.status = 'cancelled' THEN 1 ELSE 0 END) as cancelled,
    ROUND(SUM(CASE WHEN b.status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(b.booking_id) * 100, 2) as cancellation_rate
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
JOIN hotels h ON r.hotel_id = h.hotel_id
GROUP BY h.city;
```

#### 5. User Activity Report

**Most active users:**
```sql
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) as user_name,
    u.email,
    COUNT(b.booking_id) as total_bookings,
    SUM(bp.final_price) as total_spent
FROM users u
JOIN bookings b ON u.user_id = b.user_id
JOIN booking_pricing bp ON b.booking_id = bp.booking_id
GROUP BY u.user_id, user_name, u.email
ORDER BY total_bookings DESC
LIMIT 10;
```

### Exporting Reports

**Method 1: CSV Export from Admin Panel**
- Use "Export" button on reports page
- Downloads as CSV file

**Method 2: Database Export**
```bash
mysql -u root -p world_hotels_db -e "SELECT * FROM view_name" > report.csv
```

**Method 3: Python Script**
```python
import pymysql
import csv

connection = pymysql.connect(host='localhost', user='root', password='password', database='world_hotels_db')
cursor = connection.cursor()
cursor.execute("SELECT * FROM bookings")
results = cursor.fetchall()

with open('report.csv', 'w') as f:
    writer = csv.writer(f)
    writer.writerows(results)
```

---

## System Maintenance

### Database Backup

**Daily Backup (Recommended):**
```bash
# Create backup
mysqldump -u root -p world_hotels_db > backup_$(date +%Y%m%d).sql

# Compress backup
gzip backup_$(date +%Y%m%d).sql
```

**Automated Backup Script:**
```bash
#!/bin/bash
# Save as: backup.sh

BACKUP_DIR="/path/to/backups"
DATE=$(date +%Y%m%d_%H%M%S)
FILENAME="world_hotels_$DATE.sql"

mysqldump -u root -p[PASSWORD] world_hotels_db > $BACKUP_DIR/$FILENAME
gzip $BACKUP_DIR/$FILENAME

# Keep only last 30 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete

echo "Backup completed: $FILENAME.gz"
```

**Run daily via cron:**
```bash
crontab -e
# Add line:
0 2 * * * /path/to/backup.sh
```

### Database Restore

**From backup file:**
```bash
# Decompress if needed
gunzip backup_20250116.sql.gz

# Restore
mysql -u root -p world_hotels_db < backup_20250116.sql
```

### Clear Old Data

**Remove completed bookings older than 2 years:**
```sql
DELETE FROM bookings 
WHERE status = 'completed' 
AND check_out_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
```

⚠️ **Warning:** This permanently deletes data!

### Performance Optimization

**Analyze slow queries:**
```sql
-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2; -- queries slower than 2 seconds

-- View slow queries
SELECT * FROM mysql.slow_log;
```

**Optimize tables:**
```sql
OPTIMIZE TABLE bookings;
OPTIMIZE TABLE rooms;
OPTIMIZE TABLE users;
```

**Rebuild indexes:**
```sql
ANALYZE TABLE bookings;
ANALYZE TABLE rooms;
```

### Server Monitoring

**Check database size:**
```sql
SELECT 
    table_schema as 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) as 'Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'world_hotels_db';
```

**Check table sizes:**
```sql
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) as 'Size (MB)',
    table_rows
FROM information_schema.TABLES
WHERE table_schema = 'world_hotels_db'
ORDER BY (data_length + index_length) DESC;
```

---

## Security Best Practices

### Admin Password Security

**Requirements for admin passwords:**
- ✅ Minimum 12 characters
- ✅ Mix of uppercase and lowercase
- ✅ Include numbers
- ✅ Include special characters
- ✅ Not based on dictionary words
- ✅ Changed every 90 days

**Example strong passwords:**
- `Adm!n2025$Secure`
- `H0tel#Mgmt@2025`
- `W0rld$H0tels!Adm`

### Access Control

**Principle of Least Privilege:**
- Only give admin access when necessary
- Limit number of admin accounts
- Audit admin actions regularly

**Admin Actions to Log:**
- User promotions/demotions
- Booking cancellations
- Data exports
- System configuration changes

### Regular Security Checks

**Weekly Tasks:**
1. Review failed login attempts
2. Check for suspicious bookings
3. Monitor unusual database activity
4. Review error logs

**Monthly Tasks:**
1. Update dependencies (pip list --outdated)
2. Review admin accounts (remove unused)
3. Check security headers
4. Test backup restoration

**Quarterly Tasks:**
1. Change admin passwords
2. Security audit
3. Penetration testing (basic)
4. Review access logs

### Secure Database Access

**Best practices:**
1. Never use root account for application
2. Create dedicated database user:
```sql
CREATE USER 'worldhotels_app'@'localhost' IDENTIFIED BY 'strong_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON world_hotels_db.* TO 'worldhotels_app'@'localhost';
FLUSH PRIVILEGES;
```

3. Restrict remote access
4. Use SSL for database connections (production)

### Monitoring Failed Logins

**Check failed login attempts:**
```sql
-- Assuming we log failed attempts
SELECT 
    ip_address,
    COUNT(*) as attempts,
    MAX(timestamp) as last_attempt
FROM failed_logins
WHERE timestamp > DATE_SUB(NOW(), INTERVAL 1 HOUR)
GROUP BY ip_address
HAVING attempts > 5;
```

**Block suspicious IPs:**
- Use firewall rules
- Implement IP blacklisting
- Consider fail2ban for automated blocking

---

## Troubleshooting

### Common Admin Issues

#### Can't Access Admin Dashboard

**Symptoms:**
- Logged in but no admin menu
- Redirected to homepage instead of dashboard

**Solutions:**
1. Check user_type in database:
```sql
SELECT user_type FROM users WHERE email = 'admin@worldhotels.com';
```

2. Should be 'admin', if not:
```sql
UPDATE users SET user_type = 'admin' WHERE email = 'admin@worldhotels.com';
```

3. Clear session and login again

#### Bookings Not Showing

**Symptoms:**
- Dashboard shows 0 bookings
- Manage Bookings page empty

**Solutions:**
1. Check database connection
2. Verify bookings exist:
```sql
SELECT COUNT(*) FROM bookings;
```

3. Check for SQL errors in logs
4. Restart Flask application

#### Export Not Working

**Symptoms:**
- CSV export fails
- Download doesn't start

**Solutions:**
1. Check file permissions on server
2. Verify CSV module installed:
```bash
pip show csv
```

3. Check browser popup blocker
4. Try different browser

#### Statistics Incorrect

**Symptoms:**
- Dashboard numbers don't match reality
- Revenue total seems wrong

**Solutions:**
1. Verify queries in admin routes
2. Check database for data integrity:
```sql
-- Check for orphaned records
SELECT COUNT(*) FROM booking_pricing bp
LEFT JOIN bookings b ON bp.booking_id = b.booking_id
WHERE b.booking_id IS NULL;
```

3. Recalculate statistics manually
4. Check for NULL values:
```sql
SELECT COUNT(*) FROM booking_pricing WHERE final_price IS NULL;
```

### Database Issues

#### Connection Errors

**Error:** "Can't connect to MySQL server"

**Solutions:**
1. Check MySQL is running:
```bash
# Windows
net start MySQL

# Linux
sudo systemctl start mysql
```

2. Verify credentials in config.py
3. Check MySQL port (default 3306)
4. Ping database server

#### Slow Queries

**Symptoms:**
- Pages load slowly
- Timeouts on complex queries

**Solutions:**
1. Add indexes to frequently queried columns
2. Optimize queries (use EXPLAIN)
3. Increase MySQL cache size
4. Consider query caching

#### Data Corruption

**Symptoms:**
- Missing data
- Inconsistent foreign keys
- NULL values where shouldn't be

**Solutions:**
1. Restore from backup
2. Run integrity checks:
```sql
CHECK TABLE bookings;
CHECK TABLE users;
```

3. Repair if needed:
```sql
REPAIR TABLE bookings;
```

---

## Database Management

### Database Schema

**Current Tables (9):**
1. **users** - User accounts
2. **hotels** - Hotel locations
3. **room_types** - Room categories
4. **rooms** - Individual rooms
5. **seasons** - Pricing seasons
6. **prices** - Price matrix
7. **bookings** - Customer bookings
8. **booking_pricing** - Pricing details
9. **exchange_rates** - Currency rates

### Adding Sample Data

**For testing purposes:**
```sql
-- Add test user
INSERT INTO users (email, password_hash, first_name, last_name, phone, user_type)
VALUES ('test@example.com', '$2b$12$...', 'Test', 'User', '+44 7700 900000', 'standard');

-- Add test booking
INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, status)
VALUES (1, 101, '2025-06-01', '2025-06-05', 2, 'confirmed');
```

### Updating Prices

**Seasonal price update:**
```sql
-- Increase all prices by 10%
UPDATE prices 
SET price_gbp = price_gbp * 1.10 
WHERE season_id = 1; -- Peak season

-- Set specific hotel price
UPDATE prices 
SET price_gbp = 250.00 
WHERE hotel_id = 8 -- London
AND room_type_id = 3 -- Family
AND season_id = 1; -- Peak
```

### Adding New Currency
```sql
INSERT INTO exchange_rates (currency_code, currency_name, rate_to_gbp, effective_date, is_active)
VALUES ('CHF', 'Swiss Franc', 0.880000, CURDATE(), TRUE);
```

### Database Maintenance Commands

**Check database status:**
```sql
SHOW TABLE STATUS FROM world_hotels_db;
```

**Show all indexes:**
```sql
SHOW INDEX FROM bookings;
```

**Table information:**
```sql
DESCRIBE bookings;
```

**View constraints:**
```sql
SELECT * FROM information_schema.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'world_hotels_db';
```

---

## Appendix

### Useful SQL Queries

**Find booking by ID:**
```sql
SELECT * FROM bookings WHERE booking_id = 12345;
```

**Get user's all bookings:**
```sql
SELECT * FROM bookings WHERE user_id = 5 ORDER BY booking_date DESC;
```

**Today's check-ins:**
```sql
SELECT * FROM bookings WHERE check_in_date = CURDATE() AND status = 'confirmed';
```

**Available rooms for date range:**
```sql
SELECT r.* FROM rooms r
WHERE r.status = 'available'
AND r.room_id NOT IN (
    SELECT room_id FROM bookings
    WHERE status = 'confirmed'
    AND check_in_date <= '2025-06-05'
    AND check_out_date > '2025-06-01'
);
```

### Emergency Contacts

**Developer:** biplab@example.com  
**Database Admin:** dbadmin@worldhotels.com  
**Security Team:** security@worldhotels.com  
**Support:** support@worldhotels.com

### Quick Reference

**Admin Credentials:**
- Email: admin@worldhotels.com
- Password: [Set securely]

**Database:**
- Host: localhost
- Port: 3306
- Database: world_hotels_db

**Backup Location:**
- Path: /backups/world_hotels/
- Retention: 30 days

---

## Conclusion

This guide covers essential admin functions for the World Hotels system. For additional support or questions not covered here, please contact the development team.

**Remember:**
- Always backup before major changes
- Test in development environment first
- Document all configuration changes
- Follow security best practices
- Monitor system regularly

**Happy Administering!** 🛠️

---

*Admin Guide Version 1.0 - January 16, 2025*