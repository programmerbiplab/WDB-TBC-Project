# World Hotels - Deployment Guide

**Version:** 1.0  
**Date:** January 16, 2025  
**Student:** Biplab  
**Target:** Production Deployment

---

## Table of Contents

1. [Deployment Overview](#deployment-overview)
2. [Pre-Deployment Checklist](#pre-deployment-checklist)
3. [Environment Configuration](#environment-configuration)
4. [Database Setup (Production)](#database-setup-production)
5. [Application Deployment](#application-deployment)
6. [Web Server Configuration](#web-server-configuration)
7. [SSL/HTTPS Setup](#sslhttps-setup)
8. [Monitoring & Logging](#monitoring--logging)
9. [Backup & Recovery](#backup--recovery)
10. [Troubleshooting Production Issues](#troubleshooting-production-issues)

---

## Deployment Overview

### Production Architecture
```
Internet
    ↓
[Firewall/CDN (Cloudflare)]
    ↓
[Load Balancer (Optional)]
    ↓
[Nginx (Reverse Proxy)] ← SSL Termination
    ↓
[Gunicorn (WSGI Server)] ← Flask Application
    ↓
[MySQL Database Server]
```

### Recommended Stack

**Operating System:**
- Ubuntu 22.04 LTS (Server)
- Debian 11 or later
- CentOS 8/Rocky Linux 9

**Web Server:**
- Nginx (recommended)
- Apache (alternative)

**WSGI Server:**
- Gunicorn (recommended)
- uWSGI (alternative)

**Database:**
- MySQL 8.0 (dedicated server)
- PostgreSQL 14+ (alternative)

**Caching/Sessions:**
- Redis 7.x (recommended)
- Memcached (alternative)

**Hosting Options:**
- AWS EC2 + RDS
- DigitalOcean Droplets
- Linode
- Heroku (simpler, more expensive)
- Google Cloud Platform
- Azure

---

## Pre-Deployment Checklist

### Security Checklist

**Critical Security Tasks:**

- [ ] **Change `SECRET_KEY`** in config.py
```python
  # Generate new secret key
  import secrets
  secrets.token_hex(32)
  # Use the output as SECRET_KEY
```

- [ ] **Change default admin password**
```sql
  UPDATE users 
  SET password_hash = '[NEW_BCRYPT_HASH]' 
  WHERE email = 'admin@worldhotels.com';
```

- [ ] **Set `DEBUG = False`** in config.py
```python
  DEBUG = False
```

- [ ] **Configure environment variables**
  - Database credentials
  - Email credentials
  - API keys
  - Secret keys

- [ ] **Enable HTTPS** (SSL certificate)

- [ ] **Configure firewall** (UFW, iptables)
```bash
  sudo ufw allow 80/tcp    # HTTP
  sudo ufw allow 443/tcp   # HTTPS
  sudo ufw allow 22/tcp    # SSH
  sudo ufw enable
```

- [ ] **Set secure file permissions**
```bash
  chmod 600 config.py
  chmod 600 .env
```

- [ ] **Remove test/debug code**
  - Remove print statements
  - Remove test routes
  - Remove sample data (if not needed)

### Performance Checklist

- [ ] **Database indexes** verified
- [ ] **Static files** served by Nginx (not Flask)
- [ ] **Gzip compression** enabled
- [ ] **Browser caching** headers set
- [ ] **Database connection pooling** configured
- [ ] **Redis for sessions** (instead of server memory)

### Operational Checklist

- [ ] **Automated backups** scheduled
- [ ] **Monitoring** set up (uptime, errors)
- [ ] **Logging** configured (file rotation)
- [ ] **Email service** configured (SMTP)
- [ ] **Domain name** configured
- [ ] **DNS records** set up
- [ ] **SSL certificate** obtained

---

## Environment Configuration

### Step 1: Create Environment File

Create `.env` file in project root:
```bash
# .env - Production Environment Variables
# DO NOT COMMIT THIS FILE TO GIT!

# Flask Configuration
FLASK_ENV=production
FLASK_DEBUG=False
SECRET_KEY=your_super_secret_key_here_change_this_32_chars_min

# Database Configuration
DB_HOST=your-database-server.com
DB_PORT=3306
DB_USER=worldhotels_app
DB_PASSWORD=strong_database_password_here
DB_NAME=world_hotels_db

# Email Configuration (SMTP)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=noreply@worldhotels.com
MAIL_PASSWORD=your_email_app_password
MAIL_DEFAULT_SENDER=noreply@worldhotels.com

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=redis_password_if_any

# Admin Configuration
ADMIN_EMAIL=admin@worldhotels.com
ADMIN_PASSWORD_HASH=bcrypt_hash_here

# External Services (if any)
STRIPE_PUBLIC_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
GOOGLE_ANALYTICS_ID=UA-...

# Server Configuration
SERVER_NAME=worldhotels.com
PREFERRED_URL_SCHEME=https
```

**Important:** Add `.env` to `.gitignore`!

### Step 2: Update config.py for Production
```python
# config.py
import os
from dotenv import load_dotenv

load_dotenv()  # Load .env file

class Config:
    """Base configuration"""
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-CHANGE-IN-PRODUCTION'
    
    # Database
    MYSQL_HOST = os.environ.get('DB_HOST') or 'localhost'
    MYSQL_USER = os.environ.get('DB_USER') or 'root'
    MYSQL_PASSWORD = os.environ.get('DB_PASSWORD') or 'password'
    MYSQL_DB = os.environ.get('DB_NAME') or 'world_hotels_db'
    
    # Session
    SESSION_COOKIE_SECURE = True  # HTTPS only
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = 'Lax'
    PERMANENT_SESSION_LIFETIME = 604800  # 7 days
    
    # Security
    WTF_CSRF_ENABLED = True
    WTF_CSRF_TIME_LIMIT = None  # No time limit
    
class DevelopmentConfig(Config):
    """Development configuration"""
    DEBUG = True
    TESTING = False
    SESSION_COOKIE_SECURE = False  # Allow HTTP in dev

class ProductionConfig(Config):
    """Production configuration"""
    DEBUG = False
    TESTING = False
    
    # Email
    MAIL_SERVER = os.environ.get('MAIL_SERVER')
    MAIL_PORT = int(os.environ.get('MAIL_PORT') or 587)
    MAIL_USE_TLS = os.environ.get('MAIL_USE_TLS', 'True').lower() == 'true'
    MAIL_USERNAME = os.environ.get('MAIL_USERNAME')
    MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD')
    MAIL_DEFAULT_SENDER = os.environ.get('MAIL_DEFAULT_SENDER')
    
    # Redis
    REDIS_URL = os.environ.get('REDIS_URL') or 'redis://localhost:6379/0'
    
    # Server
    SERVER_NAME = os.environ.get('SERVER_NAME')
    PREFERRED_URL_SCHEME = os.environ.get('PREFERRED_URL_SCHEME') or 'https'

config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}
```

### Step 3: Install python-dotenv
```bash
pip install python-dotenv
pip freeze > requirements.txt
```

---

## Database Setup (Production)

### Step 1: Create Dedicated Database User

**Security best practice:** Don't use root in production!
```sql
-- Login to MySQL as root
mysql -u root -p

-- Create dedicated user
CREATE USER 'worldhotels_app'@'localhost' IDENTIFIED BY 'strong_password_here';

-- Grant only necessary permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON world_hotels_db.* TO 'worldhotels_app'@'localhost';

-- No DROP, CREATE TABLE, or ALTER permissions!

FLUSH PRIVILEGES;
```

### Step 2: Optimize Database for Production
```sql
USE world_hotels_db;

-- Analyze tables for optimization
ANALYZE TABLE users, hotels, rooms, bookings, booking_pricing;

-- Check indexes
SHOW INDEX FROM bookings;
SHOW INDEX FROM rooms;

-- Add composite indexes if needed
CREATE INDEX idx_booking_user_status ON bookings(user_id, status);
CREATE INDEX idx_booking_dates_status ON bookings(check_in_date, check_out_date, status);

-- Set InnoDB buffer pool size (adjust based on RAM)
-- In /etc/mysql/my.cnf:
-- innodb_buffer_pool_size = 2G  # For 8GB RAM server
-- innodb_log_file_size = 512M
```

### Step 3: Configure MySQL for Performance

Edit `/etc/mysql/mysql.conf.d/mysqld.cnf`:
```ini
[mysqld]
# General
max_connections = 200
connect_timeout = 10
wait_timeout = 600

# InnoDB Settings
innodb_buffer_pool_size = 2G
innodb_log_file_size = 512M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT

# Query Cache (MySQL 5.7, deprecated in 8.0)
# query_cache_type = 1
# query_cache_size = 128M

# Slow Query Log
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow-query.log
long_query_time = 2

# Binary Logging (for backups)
log_bin = /var/log/mysql/mysql-bin.log
expire_logs_days = 7
max_binlog_size = 100M
```

**Restart MySQL:**
```bash
sudo systemctl restart mysql
```

### Step 4: Set Up Database Backups

Create backup script: `/home/deploy/backup-db.sh`
```bash
#!/bin/bash
# World Hotels Database Backup Script

# Configuration
DB_NAME="world_hotels_db"
DB_USER="worldhotels_app"
DB_PASS="your_password"
BACKUP_DIR="/var/backups/worldhotels"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/worldhotels_$DATE.sql"

# Create backup directory if doesn't exist
mkdir -p $BACKUP_DIR

# Dump database
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_FILE

# Compress backup
gzip $BACKUP_FILE

# Delete backups older than 30 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete

# Upload to S3 (optional)
# aws s3 cp $BACKUP_FILE.gz s3://your-bucket/backups/

echo "Backup completed: $BACKUP_FILE.gz"
```

**Make executable:**
```bash
chmod +x /home/deploy/backup-db.sh
```

**Schedule daily backups:**
```bash
crontab -e
# Add line:
0 2 * * * /home/deploy/backup-db.sh >> /var/log/worldhotels-backup.log 2>&1
```

---

## Application Deployment

### Step 1: Server Setup (Ubuntu 22.04)
```bash
# Update system
sudo apt update
sudo apt upgrade -y

# Install Python and dependencies
sudo apt install python3 python3-pip python3-venv -y

# Install MySQL client
sudo apt install mysql-client libmysqlclient-dev -y

# Install Redis
sudo apt install redis-server -y

# Install Nginx
sudo apt install nginx -y

# Install system utilities
sudo apt install git curl wget htop -y
```

### Step 2: Create Deployment User
```bash
# Create user for running the app
sudo adduser deploy
sudo usermod -aG sudo deploy

# Switch to deploy user
su - deploy
```

### Step 3: Clone Repository
```bash
cd /home/deploy

# Clone from GitHub
git clone https://github.com/yourusername/world-hotels.git

cd world-hotels
```

### Step 4: Set Up Python Virtual Environment
```bash
# Create virtual environment
python3 -m venv venv

# Activate
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt

# Install production servers
pip install gunicorn
pip install redis

# Update requirements
pip freeze > requirements.txt
```

### Step 5: Configure Environment
```bash
# Create .env file
nano .env

# Paste your production environment variables
# (See Environment Configuration section above)

# Save (Ctrl+O, Enter, Ctrl+X)

# Secure the file
chmod 600 .env
```

### Step 6: Test Application Locally
```bash
# Set Flask environment
export FLASK_ENV=production

# Test run
gunicorn -b 0.0.0.0:8000 app:app

# Test in another terminal
curl http://localhost:8000

# If working, press Ctrl+C to stop
```

---

## Web Server Configuration

### Option 1: Nginx + Gunicorn

## Option 2: SSL/HTTPS Setup

### Using Let's Encrypt (Free SSL)
```bash

# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtain certificate (make sure DNS is pointing to your server)
sudo certbot --nginx -d worldhotels.com -d www.worldhotels.com

# Follow prompts:
# - Enter email address
# - Agree to terms
# - Choose to redirect HTTP to HTTPS (recommended)

# Test automatic renewal
sudo certbot renew --dry-run

# Certbot will auto-renew before expiry
```

**Manual certificate renewal (if needed):**
```bash
sudo certbot renew
sudo systemctl reload nginx
```

---

## Monitoring & Logging

### Step 1: Set Up Log Rotation

Create file: `/etc/logrotate.d/worldhotels`
```
/var/log/worldhotels/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 0640 deploy www-data
    sharedscripts
    postrotate
        systemctl reload worldhotels
    endscript
}
```

### Step 2: Monitor Application

**Check application status:**
```bash
sudo systemctl status worldhotels
```

**View logs:**
```bash
# Application logs
tail -f /var/log/worldhotels/error.log
tail -f /var/log/worldhotels/access.log

# Nginx logs
tail -f /var/log/nginx/worldhotels_error.log
tail -f /var/log/nginx/worldhotels_access.log

# System logs
sudo journalctl -u worldhotels -f
```

### Step 3: Set Up Uptime Monitoring

**Options:**
- **UptimeRobot** (free, simple)
- **Pingdom** (paid, advanced)
- **StatusCake** (free tier available)
- **Self-hosted:** Nagios, Prometheus

**Example with UptimeRobot:**
1. Sign up at uptimerobot.com
2. Add new monitor
3. Type: HTTPS
4. URL: https://worldhotels.com
5. Alert contacts: your email

### Step 4: Error Tracking (Optional)

**Sentry Integration:**
```bash
pip install sentry-sdk[flask]
```

In `app.py`:
```python
import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration

if not app.debug:
    sentry_sdk.init(
        dsn="https://your-sentry-dsn@sentry.io/project-id",
        integrations=[FlaskIntegration()],
        traces_sample_rate=0.1
    )
```

---

## Backup & Recovery

### Automated Backup Strategy

**What to backup:**
1. Database (daily)
2. Uploaded files (if any) (daily)
3. Configuration files (weekly)
4. Application code (on each deployment)

**Backup locations:**
- Local: `/var/backups/worldhotels/`
- Remote: AWS S3, Google Cloud Storage, or Backblaze B2

### Database Backup (Already covered)

See "Database Setup (Production)" section above.

### Application Backup
```bash
#!/bin/bash
# Application backup script

BACKUP_DIR="/var/backups/worldhotels/app"
DATE=$(date +%Y%m%d_%H%M%S)
APP_DIR="/home/deploy/world-hotels"

mkdir -p $BACKUP_DIR

# Backup application files (excluding venv)
tar -czf $BACKUP_DIR/app_$DATE.tar.gz \
    --exclude='venv' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    -C /home/deploy world-hotels

# Backup .env file separately (encrypted)
openssl enc -aes-256-cbc -salt \
    -in $APP_DIR/.env \
    -out $BACKUP_DIR/env_$DATE.enc \
    -pass pass:your-encryption-password

# Clean old backups (keep 7 days)
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
find $BACKUP_DIR -name "*.enc" -mtime +7 -delete
```

### Disaster Recovery Plan

**In case of total failure:**

1. **Provision new server**
2. **Install dependencies** (see Server Setup)
3. **Restore database:**
```bash
   gunzip worldhotels_20250116.sql.gz
   mysql -u root -p world_hotels_db < worldhotels_20250116.sql
```
4. **Restore application:**
```bash
   tar -xzf app_20250116.tar.gz -C /home/deploy
```
5. **Restore .env:**
```bash
   openssl enc -aes-256-cbc -d \
       -in env_20250116.enc \
       -out /home/deploy/world-hotels/.env \
       -pass pass:your-encryption-password
```
6. **Restart services:**
```bash
   sudo systemctl restart worldhotels
   sudo systemctl restart nginx
```

---

## Troubleshooting Production Issues

### Issue: Application Won't Start

**Check service status:**
```bash
sudo systemctl status worldhotels
sudo journalctl -u worldhotels -n 50
```

**Common causes:**
- Syntax error in app.py
- Missing dependencies
- Database connection failure
- Permission issues

**Solution:**
```bash
# Test manually
cd /home/deploy/world-hotels
source venv/bin/activate
python app.py
# Look for error messages
```

### Issue: 502 Bad Gateway

**Cause:** Gunicorn not running or socket issue

**Solution:**
```bash
# Check Gunicorn
sudo systemctl status worldhotels

# Check socket file exists
ls -la /home/deploy/world-hotels/worldhotels.sock

# Check Nginx error log
tail -f /var/log/nginx/worldhotels_error.log

# Restart services
sudo systemctl restart worldhotels
sudo systemctl restart nginx
```

### Issue: Database Connection Errors

**Check MySQL is running:**
```bash
sudo systemctl status mysql
```

**Test connection:**
```bash
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME
```

**Check firewall:**
```bash
sudo ufw status
# to make sure MySQL port is allowed if database is remote
```

### Issue: High Memory Usage

**Check memory:**
```bash
free -h
htop
```

**Reduce Gunicorn workers:**

Edit `/etc/systemd/system/worldhotels.service`:
```ini
# Change --workers 4 to --workers 2
ExecStart=... --workers 2 ...
```
```bash
sudo systemctl daemon-reload
sudo systemctl restart worldhotels
```

### Issue: Slow Performance

**Check database queries:**
```sql
SHOW FULL PROCESSLIST;
```

**Enable slow query log** (see Database Setup)

**Check Nginx access log:**
```bash
tail -f /var/log/nginx/worldhotels_access.log
```

**Add caching** (Redis sessions)

---

## Post-Deployment Tasks

### Security Hardening

- [ ] Configure firewall (UFW)
- [ ] Disable root SSH login
- [ ] Set up fail2ban (SSH brute force protection)
- [ ] Enable automatic security updates
- [ ] Regular security audits

**Fail2ban setup:**
```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### Performance Optimization

- [ ] Enable Redis for sessions
- [ ] Set up CDN (Cloudflare)
- [ ] Optimize images
- [ ] Enable browser caching
- [ ] Minimize CSS/JS (production build)

### Monitoring Setup

- [ ] Uptime monitoring
- [ ] Error tracking (Sentry)
- [ ] Performance monitoring (New Relic)
- [ ] Log aggregation (ELK stack or Papertrail)

---

## Conclusion

Your World Hotels application is now deployed to production!

**Final checklist:**
- Application running on Gunicorn
- Nginx reverse proxy configured
- SSL certificate installed
- Database secured
- Backups scheduled
- Monitoring active
- Logs rotating

**Next steps:**
1. Test thoroughly in production
2. Monitor for first 48 hours
3. Set up email alerts
4. Document any custom configurations

**Production ready for deployment!**

---

*Deployment Guide Version 1.0 - January 15, 2025*