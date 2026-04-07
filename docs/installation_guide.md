# World Hotels - Installation & Setup Guide

**Version:** 1.0  
**Date:** January 17, 2025  
**Student:** Biplab Prasad Gajurel 25024641

---

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Prerequisites Installation](#prerequisites-installation)
3. [Project Setup](#project-setup)
4. [Database Setup](#database-setup)
5. [Application Configuration](#application-configuration)
6. [Running the Application](#running-the-application)
7. [Verification & Testing](#verification--testing)
8. [Troubleshooting](#troubleshooting)
9. [Deployment Considerations](#deployment-considerations)

---

## System Requirements

### Hardware Requirements

**Minimum:**
- **CPU:** Dual-core processor (2 GHz+)
- **RAM:** 4 GB
- **Storage:** 1 GB free space
- **Network:** Internet connection for dependencies

**Recommended:**
- **CPU:** Quad-core processor (2.5 GHz+)
- **RAM:** 8 GB or more
- **Storage:** 5 GB free space
- **Network:** Broadband internet connection

### Software Requirements

**Operating System:**
- Windows 10/11
- macOS 10.14+
- Linux (Ubuntu 20.04+, Debian, CentOS)

**Required Software:**
- **Python:** 3.8 or higher
- **MySQL:** 8.0 or higher
- **Git:** 2.30 or higher
- **Web Browser:** Chrome, Firefox, Safari, or Edge (latest version)

---

## Prerequisites Installation

### 1. Install Python

#### Windows:
1. Download from: https://www.python.org/downloads/
2. Run installer
3. **IMPORTANT:** Check "Add Python to PATH"
4. Click "Install Now"
5. Verify installation:
```bash
python --version
# Should show: Python 3.x.x
```

#### macOS:
```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Python
brew install python3

# Verify
python3 --version
```

#### Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv
python3 --version
```

### 2. Install MySQL

#### Windows:
1. Download from: https://dev.mysql.com/downloads/installer/
2. Run MySQL Installer
3. Choose "Developer Default"
4. Set root password (remember this!)
5. Complete installation
6. Verify:
```bash
mysql --version
```

#### macOS:
```bash
brew install mysql
brew services start mysql
mysql_secure_installation
# Follow prompts, set root password
```

#### Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo mysql_secure_installation
# Follow prompts, set root password
```

### 3. Install Git

#### Windows:
1. Download from: https://git-scm.com/download/win
2. Run installer
3. Use default settings
4. Verify:
```bash
git --version
```

#### macOS:
```bash
brew install git
git --version
```

#### Linux:
```bash
sudo apt install git
git --version
```

---

## Project Setup

### Step 1: Clone Repository
```bash
# Navigate to desired location
cd Desktop

# Clone the repository
git clone https://github.com/biplab12696969/design-and-development-of-a-website-biplab12696969.git

# Navigate into project
cd design-and-development-of-a-website-biplab12696969
```

**OR download ZIP:**
1. Go to GitHub repository
2. Click "Code" → "Download ZIP"
3. Extract to desired location
4. Open terminal/command prompt in that folder

### Step 2: Create Virtual Environment

**Windows:**
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
venv\Scripts\activate

# You should see (venv) in your prompt
```

**macOS/Linux:**
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# You should see (venv) in your prompt
```

### Step 3: Install Dependencies
```bash
# Make sure virtual environment is activated!
# You should see (venv) in prompt

# Install all required packages
pip install -r requirements.txt

# This installs:
# - Flask (web framework)
# - PyMySQL (database connector)
# - bcrypt (password hashing)
# - Flask-WTF (CSRF protection)
```

**Verify installation:**
```bash
pip list
# Should show Flask, PyMySQL, bcrypt, Flask-WTF, etc.
```

---

## Database Setup

### Step 1: Start MySQL Server

**Windows:**
```bash
# Start MySQL service
net start MySQL

# Or use MySQL Workbench
```

**macOS:**
```bash
brew services start mysql
```

**Linux:**
```bash
sudo systemctl start mysql
```

### Step 2: Login to MySQL
```bash
mysql -u root -p
# Enter your MySQL root password when prompted
```

You should see:
```
mysql>
```

### Step 3: Create Database Schema

**From MySQL prompt:**
```bash
# Exit MySQL first
exit;

# Run schema file
mysql -u root -p < database/schema.sql
# Enter password when prompted
```

**Verify:**
```bash
mysql -u root -p
# Enter password

# Inside MySQL:
USE world_hotels_db;
SHOW TABLES;
# Should show 9 tables
```

### Step 4: Load Sample Data
```bash
# Exit MySQL
exit;

# Load sample data
mysql -u root -p < database/sample_data.sql
# Enter password
```

**Verify data loaded:**
```bash
mysql -u root -p
USE world_hotels_db;

SELECT COUNT(*) FROM hotels;
-- Should show: 17

SELECT COUNT(*) FROM rooms;
-- Should show: 1740

SELECT COUNT(*) FROM users;
-- Should show: 6 (1 admin + 5 test users)

exit;
```

### Alternative: Manual Database Setup

**If schema.sql doesn't work:**

1. Login to MySQL:
```bash
mysql -u root -p
```

2. Create database manually:
```sql
CREATE DATABASE world_hotels_db;
USE world_hotels_db;
```

3. Copy and paste table creation SQL from `database/schema.sql`
4. Copy and paste sample data SQL from `database/sample_data.sql`

---

## Application Configuration

### Step 1: Configure Database Connection

**Open:** `config.py`

**Find this section:**
```python
MYSQL_HOST = 'localhost'
MYSQL_USER = 'root'
MYSQL_PASSWORD = 'Powerranger14$'
MYSQL_DB = 'world_hotels_db'
```

**Update:**
- Change `MYSQL_PASSWORD` to your actual MySQL root password
- Example: `MYSQL_PASSWORD = 'MyPassword123'`

**Save the file** (Ctrl+S)

### Step 2: Verify Configuration

**Test database connection:**

Create temporary test file: `test_connection.py`
```python
import pymysql
from config import config

try:
    connection = pymysql.connect(
        host=config['development'].MYSQL_HOST,
        user=config['development'].MYSQL_USER,
        password=config['development'].MYSQL_PASSWORD,
        database=config['development'].MYSQL_DB
    )
    print("Database connection successful!")
    connection.close()
except Exception as e:
    print(f"Connection failed: {e}")
```

**Run test:**
```bash
python test_connection.py
```

**Should see:** Database connection successful!

**Delete test file after verification**

---

## Running the Application

### Step 1: Activate Virtual Environment

**Make sure venv is activated!**

**Windows:**
```bash
venv\Scripts\activate
```

**macOS/Linux:**
```bash
source venv/bin/activate
```

You should see `(venv)` in your prompt.

### Step 2: Start Flask Application
```bash
python app.py
```

**You should see:**
```
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server. Do not use it in production.
 * Running on http://0.0.0.0:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
```

### Step 3: Access Application

**Open web browser and go to:**
```
http://localhost:5000
```

**You should see the World Hotels homepage!** 🎉

### Default Ports

- **Application:** http://localhost:5000
- **MySQL:** localhost:3306

**If port 5000 is in use:**

Edit `app.py`, find last line:
```python
app.run(debug=True, host='0.0.0.0', port=5000)
```

Change to different port:
```python
app.run(debug=True, host='0.0.0.0', port=8000)
```

Then access: http://localhost:8000

---

## Verification & Testing

### Step 1: Test Homepage

Homepage loads  
Navigation menu appears  
Search form visible  
Footer displays  

### Step 2: Test User Registration

1. Click "Register"
2. Fill in form:
   - First Name: Test
   - Last Name: User
   - Email: test@example.com
   - Phone: +44 7700 900000
   - Password: Password123
   - Confirm Password: Password123
3. Click "Create Account"
4. Should redirect to login page

### Step 3: Test Login

1. Click "Login"
2. Email: test@example.com
3. Password: Password123
4. Click "Login"
5. Should redirect to homepage
6. Navigation should show "My Profile" and "Logout"

### Step 4: Test Hotel Search

1. Go to "Hotels" page
2. Should see 17 hotels listed
3. Try filter by city (London)
4. Should show 1 hotel
5. Click "View Details" on a hotel
6. Should see hotel detail page

### Step 5: Test Booking

1. On hotel detail page
2. Select dates (future dates)
3. Select room type
4. Click "Continue to Booking"
5. Fill in booking form
6. Click "Confirm Booking"
7. Should see receipt page

### Step 6: Test Admin Access

1. Logout from regular account
2. Login with admin:
   - Email: admin@worldhotels.com
   - Password: admin123
3. Should see "Admin Panel" in navigation
4. Click "Admin Dashboard"
5. Should see statistics

### Verification Checklist

Homepage loads correctly  
User can register  
User can login  
Hotels display (17 total)  
Search/filter works  
Hotel details show  
Booking process works  
Receipt generates  
Admin can login  
Admin dashboard shows statistics  
No console errors  

---

## Troubleshooting

### Issue: "Module not found" Error

**Problem:**
```
ModuleNotFoundError: No module named 'flask'
```

**Solution:**
1. Make sure virtual environment is activated
2. Reinstall dependencies:
```bash
pip install -r requirements.txt
```

### Issue: "Can't connect to MySQL server"

**Problem:**
```
Can't connect to MySQL server on 'localhost'
```

**Solutions:**

**1. Check if MySQL is running:**

**Windows:**
```bash
net start MySQL
```

**macOS:**
```bash
brew services list
# MySQL should show "started"

# If not:
brew services start mysql
```

**Linux:**
```bash
sudo systemctl status mysql

# If not running:
sudo systemctl start mysql
```

**2. Verify credentials in config.py:**
- Check username (should be 'root')
- Check password matches MySQL root password
- Check database name is 'world_hotels_db'

**3. Test MySQL connection:**
```bash
mysql -u root -p
# If this fails, MySQL credentials are wrong
```

### Issue: "Access denied for user 'root'"

**Problem:**
```
Access denied for user 'root'@'localhost'
```

**Solution:**

Reset MySQL root password:

**Windows/Linux:**
```bash
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
exit;
```

Then update `config.py` with new password.

### Issue: Database doesn't exist

**Problem:**
```
Unknown database 'world_hotels_db'
```

**Solution:**

Create database:
```bash
mysql -u root -p
CREATE DATABASE world_hotels_db;
exit;

# Then run schema
mysql -u root -p < database/schema.sql
mysql -u root -p < database/sample_data.sql
```

### Issue: Port 5000 already in use

**Problem:**
```
Address already in use
```

**Solutions:**

**Option 1: Kill process using port 5000:**

**Windows:**
```bash
netstat -ano | findstr :5000
# Find PID
taskkill /PID [PID] /F
```

**macOS/Linux:**
```bash
lsof -ti:5000 | xargs kill -9
```

**Option 2: Use different port:**

Edit `app.py`:
```python
app.run(debug=True, host='0.0.0.0', port=8000)
```

### Issue: CSRF Token Missing

**Problem:**
```
The CSRF token is missing
```

**Solution:**

1. Clear browser cookies
2. Hard refresh (Ctrl+Shift+R)
3. Make sure JavaScript is enabled
4. Check form has CSRF token:
```html
<input type="hidden" name="csrf_token" value="{{ csrf_token() }}">
```

### Issue: Static files not loading (no CSS)

**Problem:**
- Page loads but no styling
- Looks like plain HTML

**Solution:**

1. Check static folder exists
2. Check CSS files are in `static/css/`
3. Hard refresh (Ctrl+F5)
4. Check browser console for errors
5. Verify URL in base.html:
```html
<link rel="stylesheet" href="{{ url_for('static', filename='css/styles.css') }}">
```

### Issue: Import errors in utils

**Problem:**
```
ImportError: cannot import name 'InputValidator'
```

**Solution:**

1. Check `utils/__init__.py` exists
2. Verify all utility files exist:
   - utils/validators.py
   - utils/email_service.py
   - utils/security.py
   - utils/error_handlers.py
   - utils/performance.py

3. Restart Flask application

### Getting Help

**If issues persist:**

1. Check error logs in terminal
2. Check browser console (F12)
3. Review this troubleshooting section
4. Check GitHub repository for updates
5. Contact: support@worldhotels.com

---

## Deployment Considerations

### Production Deployment Checklist

**This is a development/demo system. For production:**

**Security:**
- Change `SECRET_KEY` in config.py
- Change default admin password
- Use environment variables for credentials
- Enable HTTPS (SSL certificate)
- Use production WSGI server (Gunicorn/uWSGI)
- Configure firewall rules

**Database:**
- Use dedicated database user (not root)
- Enable database backups
- Configure connection pooling
- Optimize database indexes
- Regular maintenance schedule

**Application:**
- Set `DEBUG = False`
- Configure logging to files
- Set up monitoring (error tracking)
- Configure email service (real SMTP)
- Set up payment gateway
- Load testing

**Server:**
- Use nginx/Apache as reverse proxy
- Configure SSL/TLS
- Set up domain name
- Configure CDN for static files
- Implement rate limiting at server level

### Recommended Production Stack

**Web Server:** Nginx  
**WSGI Server:** Gunicorn  
**Database:** MySQL 8.0 (dedicated server)  
**Cache:** Redis (for sessions and rate limiting)  
**Monitoring:** Sentry, New Relic, or similar  
**Hosting:** AWS, DigitalOcean, Heroku, or similar  

---

## Quick Reference Commands

### Start Everything
```bash
# 1. Activate virtual environment
venv\Scripts\activate  # Windows
source venv/bin/activate  # macOS/Linux

# 2. Start MySQL (if not running)
net start MySQL  # Windows
brew services start mysql  # macOS
sudo systemctl start mysql  # Linux

# 3. Start Flask
python app.py
```

### Stop Everything
```bash
# 1. Stop Flask
# Press Ctrl+C in terminal

# 2. Deactivate virtual environment
deactivate

# 3. Stop MySQL (optional)
net stop MySQL  # Windows
brew services stop mysql  # macOS
sudo systemctl stop mysql  # Linux
```

### Backup Database
```bash
mysqldump -u root -p world_hotels_db > backup.sql
```

### Restore Database
```bash
mysql -u root -p world_hotels_db < backup.sql
```

---

## Appendix

### Project Structure
```
design-and-development-of-a-website-biplab12696969/
├── app.py                 # Main application
├── config.py             # Configuration
├── requirements.txt      # Dependencies
├── database/
│   ├── schema.sql        # Database schema
│   ├── sample_data.sql   # Sample data
│   └── world_hotels_dump.sql
├── templates/            # HTML templates
│   ├── base.html
│   ├── index.html
│   └── ...
├── static/              # Static files
│   ├── css/
│   ├── js/
│   └── images/
├── utils/               # Utility modules
│   ├── validators.py
│   ├── security.py
│   └── ...
├── docs/                # Documentation
│   ├── user_guide.md
│   ├── admin_guide.md
│   └── ...
└── logs/                # Log files
```

### Default Test Accounts

**Admin Account:**
- Email: admin@worldhotels.com
- Password: admin123

**Test User:**
- Email: biplab@example.com
- Password: password123

**Change these in production!**

---

## Conclusion

Congratulations! If you've followed this guide, you should now have:

Python, MySQL, and Git installed  
Project cloned and set up  
Virtual environment created  
Dependencies installed  
Database created and populated  
Application running successfully  
All features tested and working  

**Next Steps:**
1. Read the User Guide (docs/user_guide.md)
2. Read the Admin Guide (docs/admin_guide.md)
3. Start using the system!

**Enjoy World Hotels!** 🏨✨

---

*Installation Guide Version 1.0 - January 16, 2025*