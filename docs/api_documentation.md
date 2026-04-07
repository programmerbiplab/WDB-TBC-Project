# World Hotels - API Documentation

**Version:** 1.0  
**Date:** January 17, 2025  
**Student:** Biplab Prasad Gajurel
**Base URL:** http://localhost:5000

---

## Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Public Endpoints](#public-endpoints)
4. [User Endpoints](#user-endpoints)
5. [Admin Endpoints](#admin-endpoints)
6. [Response Formats](#response-formats)
7. [Error Codes](#error-codes)
8. [Rate Limiting](#rate-limiting)

---

## Overview

### API Description

The World Hotels API provides programmatic access to the hotel booking system. This is a RESTful API that uses standard HTTP methods and returns JSON responses.

### Base Information

- **Protocol:** HTTP
- **Base URL:** `http://localhost:5000`
- **Response Format:** JSON (for errors) or HTML (for pages)
- **Authentication:** Session-based cookies
- **Rate Limiting:** Yes (varies by endpoint)

### API Characteristics

- **Stateful:** Uses server-side sessions
- **CSRF Protected:** All POST/PUT/DELETE require CSRF token
- **Rate Limited:** Protection against abuse
- **Secure:** Input validation, SQL injection prevention

---

## Authentication

### Session-Based Authentication

The API uses **cookie-based sessions** for authentication.

**Login Process:**
1. POST to `/login` with credentials
2. Server sets session cookie
3. Include cookie in subsequent requests
4. Cookie expires after 7 days or logout

**Headers Required:**
```
Cookie: session=[SESSION_ID]
```

**CSRF Token:**
All state-changing requests (POST, PUT, DELETE) require CSRF token:
```html

```

---

## Public Endpoints

### GET /

**Description:** Homepage  
**Authentication:** Not required  
**Rate Limit:** 60/minute

**Request:**
```http
GET / HTTP/1.1
Host: localhost:5000
```

**Response:**
```
200 OK
Content-Type: text/html

[HTML content]
```

---

### GET /hotels

**Description:** List all hotels with optional filters  
**Authentication:** Not required  
**Rate Limit:** 60/minute

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| city | string | No | Filter by city name |
| room_type | string | No | Filter by room type (Standard/Double/Family) |
| check_in | date | No | Check-in date (YYYY-MM-DD) |
| check_out | date | No | Check-out date (YYYY-MM-DD) |
| guests | integer | No | Number of guests |
| min_price | decimal | No | Minimum price per night |
| max_price | decimal | No | Maximum price per night |
| sort_by | string | No | Sort order (city/price_asc/price_desc/capacity) |

**Request Example:**
```http
GET /hotels?city=London&room_type=Double&sort_by=price_asc HTTP/1.1
Host: localhost:5000
```

**Response:**
```
200 OK
Content-Type: text/html

[HTML with filtered hotel list]
```

---

### GET /hotel/<hotel_id>

**Description:** Get hotel details  
**Authentication:** Not required  
**Rate Limit:** 60/minute

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| hotel_id | integer | Yes | Hotel ID (1-17) |

**Request Example:**
```http
GET /hotel/8 HTTP/1.1
Host: localhost:5000
```

**Response:**
```
200 OK
Content-Type: text/html

[HTML with hotel details]
```

**Errors:**
- `404 Not Found` - Hotel doesn't exist

---

### GET /about

**Description:** About page  
**Authentication:** Not required  
**Rate Limit:** 60/minute

---

### GET /contact

**Description:** Contact page  
**Authentication:** Not required  
**Rate Limit:** 60/minute

---

### POST /contact

**Description:** Submit contact form  
**Authentication:** Not required  
**Rate Limit:** 10/hour

**Request Body (form-data):**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| csrf_token | string | Yes | CSRF protection token |
| name | string | Yes | Full name |
| email | string | Yes | Email address |
| phone | string | No | Phone number |
| subject | string | Yes | Message subject |
| booking_ref | string | No | Booking reference |
| message | string | Yes | Message content |

**Request Example:**
```http
POST /contact HTTP/1.1
Host: localhost:5000
Content-Type: application/x-www-form-urlencoded

csrf_token=abc123&name=John+Smith&email=john@example.com&subject=booking&message=Hello
```

**Response:**
```
302 Found
Location: /contact

[Flash message: "Thank you for contacting us!"]
```

---

## User Endpoints

### POST /register

**Description:** Register new user account  
**Authentication:** Not required  
**Rate Limit:** 3 registrations per 15 minutes per IP

**Request Body (form-data):**

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| csrf_token | string | Yes | Valid CSRF token |
| first_name | string | Yes | 1-100 chars, letters only |
| last_name | string | Yes | 1-100 chars, letters only |
| email | string | Yes | Valid email format, unique |
| phone | string | Yes | Valid phone format |
| password | string | Yes | Min 8 chars, letter + number |
| confirm_password | string | Yes | Must match password |
| accept_terms | boolean | Yes | Must be checked |
| marketing_consent | boolean | No | Optional |

**Request Example:**
```http
POST /register HTTP/1.1
Host: localhost:5000
Content-Type: application/x-www-form-urlencoded

csrf_token=abc123&first_name=John&last_name=Smith&email=john@example.com&phone=+447700900000&password=Password123&confirm_password=Password123&accept_terms=on
```

**Success Response:**
```
302 Found
Location: /login

[Flash message: "Registration successful! Please login."]
```

**Error Responses:**
```json
400 Bad Request
{
  "error": "Email already registered"
}
```
```json
400 Bad Request
{
  "error": "Password must be at least 8 characters"
}
```

---

### POST /login

**Description:** User login  
**Authentication:** Not required  
**Rate Limit:** 5 attempts per 5 minutes per IP

**Request Body (form-data):**

| Field | Type | Required |
|-------|------|----------|
| csrf_token | string | Yes |
| email | string | Yes |
| password | string | Yes |
| remember_me | boolean | No |

**Request Example:**
```http
POST /login HTTP/1.1
Host: localhost:5000
Content-Type: application/x-www-form-urlencoded

csrf_token=abc123&email=john@example.com&password=Password123
```

**Success Response:**
```
302 Found
Location: /
Set-Cookie: session=[SESSION_ID]; HttpOnly; SameSite=Lax

[Flash message: "Welcome back, John!"]
```

**Error Response:**
```
302 Found
Location: /login

[Flash message: "Invalid email or password"]
```

---

### GET /logout

**Description:** User logout  
**Authentication:** Required  
**Rate Limit:** 60/minute

**Request:**
```http
GET /logout HTTP/1.1
Host: localhost:5000
Cookie: session=[SESSION_ID]
```

**Response:**
```
302 Found
Location: /
Set-Cookie: session=; Expires=Thu, 01 Jan 1970 00:00:00 GMT

[Flash message: "You have been logged out successfully."]
```

---

### GET /profile

**Description:** View user profile  
**Authentication:** Required (user or admin)  
**Rate Limit:** 60/minute

**Request:**
```http
GET /profile HTTP/1.1
Host: localhost:5000
Cookie: session=[SESSION_ID]
```

**Response:**
```
200 OK
Content-Type: text/html

[HTML with user profile data]
```

---

### POST /profile/update

**Description:** Update user profile  
**Authentication:** Required  
**Rate Limit:** 30/hour

**Request Body:**

| Field | Type | Required |
|-------|------|----------|
| csrf_token | string | Yes |
| first_name | string | Yes |
| last_name | string | Yes |
| phone | string | Yes |

---

### POST /profile/change-password

**Description:** Change user password  
**Authentication:** Required  
**Rate Limit:** 10/hour

**Request Body:**

| Field | Type | Required |
|-------|------|----------|
| csrf_token | string | Yes |
| current_password | string | Yes |
| new_password | string | Yes |
| confirm_new_password | string | Yes |

---

### GET /my-bookings

**Description:** View user's bookings  
**Authentication:** Required  
**Rate Limit:** 60/minute

**Response:**
```
200 OK
Content-Type: text/html

[HTML with bookings list]
```

---

### GET /my-bookings/export

**Description:** Export user's bookings to CSV  
**Authentication:** Required  
**Rate Limit:** 10/hour

**Response:**
```
200 OK
Content-Type: text/csv
Content-Disposition: attachment; filename=world_hotels_bookings_20250116.csv

Booking ID,Booking Date,Hotel City,Room Type,...
```

---

### POST /booking/create

**Description:** Create new booking  
**Authentication:** Required  
**Rate Limit:** 10 bookings per 10 minutes

**Request Body:**

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| csrf_token | string | Yes | Valid token |
| hotel_id | integer | Yes | Valid hotel (1-17) |
| check_in | date | Yes | Future date, YYYY-MM-DD |
| check_out | date | Yes | After check-in, max 30 days |
| room_type | integer | Yes | 1-3 (Standard/Double/Family) |
| num_guests | integer | Yes | Within room capacity |

**Business Rules Validated:**
- Check-in must be today or future
- Check-out must be after check-in
- Maximum stay: 30 days
- Maximum advance booking: 90 days
- Guests must not exceed room capacity
- Room must be available for dates

**Success Response:**
302 Found
Location: /receipt/[BOOKING_ID]
[Flash message: "Booking confirmed! Confirmation email sent."]

---

### GET /receipt/<booking_id>

**Description:** View booking receipt  
**Authentication:** Required (owner or admin)  
**Rate Limit:** 60/minute

**Path Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| booking_id | integer | Booking ID |

**Authorization:** User can only view their own bookings (admins can view all)

---

### GET /booking/cancel/<booking_id>

**Description:** Cancel a booking  
**Authentication:** Required (owner or admin)  
**Rate Limit:** 30/hour

**Cancellation Charges:**
- 60+ days before: Free (0%)
- 30-60 days before: 50% charge
- <30 days before: 100% charge (no refund)

---

### POST /set-currency

**Description:** Set preferred currency  
**Authentication:** Not required  
**Rate Limit:** 60/minute  
**CSRF:** Exempt

**Request Body:**

| Field | Type | Required | Options |
|-------|------|----------|---------|
| currency | string | Yes | GBP/USD/EUR/NPR/INR |

---

## Admin Endpoints

### GET /admin/dashboard

**Description:** Admin dashboard with statistics  
**Authentication:** Required (admin only)  
**Rate Limit:** 60/minute

**Authorization:** `user_type = 'admin'`

**Response Data:**
- Total bookings count
- Active bookings count
- Total revenueContinue1:59 PM
- Total users count
- Recent bookings (last 10)

**Response:**
```
200 OK
Content-Type: text/html

[HTML with admin dashboard]
```

---

### GET /admin/bookings

**Description:** View all bookings (admin)  
**Authentication:** Required (admin only)  
**Rate Limit:** 60/minute

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| status | string | Filter by status (confirmed/cancelled/completed) |
| hotel_id | integer | Filter by hotel |
| from_date | date | Filter by check-in date (start) |
| to_date | date | Filter by check-in date (end) |

---

### POST /admin/bookings/update/<booking_id>

**Description:** Update booking status  
**Authentication:** Required (admin only)  
**Rate Limit:** 30/hour

**Request Body:**

| Field | Type | Required | Options |
|-------|------|----------|---------|
| csrf_token | string | Yes | Valid token |
| status | string | Yes | confirmed/cancelled/completed |

---

### GET /admin/bookings/export

**Description:** Export all bookings to CSV  
**Authentication:** Required (admin only)  
**Rate Limit:** 10/hour

**Response:**
```
200 OK
Content-Type: text/csv
Content-Disposition: attachment; filename=world_hotels_all_bookings_20250116.csv

Booking ID,Guest Name,Email,Phone,Hotel City,...
```

---

### GET /admin/hotels

**Description:** View all hotels (admin)  
**Authentication:** Required (admin only)  
**Rate Limit:** 60/minute

---

### POST /admin/hotels/add

**Description:** Add new hotel  
**Authentication:** Required (admin only)  
**Rate Limit:** 10/hour

**Request Body:**

| Field | Type | Required |
|-------|------|----------|
| csrf_token | string | Yes |
| city | string | Yes |
| capacity | integer | Yes |
| address | string | Yes |

---

### POST /admin/hotels/edit/<hotel_id>

**Description:** Edit hotel information  
**Authentication:** Required (admin only)  
**Rate Limit:** 30/hour

**Request Body:**

| Field | Type | Required |
|-------|------|----------|
| csrf_token | string | Yes |
| city | string | Yes |
| capacity | integer | Yes |
| address | string | Yes |

---

## Response Formats

### Success Response (HTML)

Most endpoints return HTML pages:
```
200 OK
Content-Type: text/html; charset=utf-8
Content-Length: [size]

<!DOCTYPE html>
<html>
...
</html>
```

### Success Response (Redirect)

State-changing operations redirect:
```
302 Found
Location: /target-page
Set-Cookie: session=[ID]

[Flash message in session]
```

### Success Response (CSV Export)

Export endpoints return CSV files:
```
200 OK
Content-Type: text/csv
Content-Disposition: attachment; filename=export.csv

Header1,Header2,Header3
Value1,Value2,Value3
```

### Error Response (Flash Messages)

Errors shown via flash messages:
```
302 Found
Location: /previous-page

[Flash message: "Error description" (category: error)]
```

### Error Response (JSON - Rate Limiting)

Rate limit exceeded returns JSON:
```json
429 Too Many Requests
Content-Type: application/json

{
  "error": "Rate limit exceeded. Max 5 requests per 5 minute(s)."
}
```

---

## Error Codes

### Standard HTTP Status Codes

| Code | Meaning | When It Occurs |
|------|---------|---------------|
| 200 | OK | Successful request |
| 302 | Found (Redirect) | After form submission |
| 400 | Bad Request | Invalid input data |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |

### Application Error Messages

**Validation Errors:**
- "Email already registered"
- "Password must be at least 8 characters"
- "Invalid email format"
- "Passwords do not match"
- "Invalid date format"

**Authentication Errors:**
- "Invalid email or password"
- "Please login to continue"
- "Access denied"
- "Admin access required"

**Booking Errors:**
- "No rooms available for selected dates"
- "Check-in date cannot be in the past"
- "Check-out must be after check-in"
- "Maximum stay is 30 days"
- "Cannot book more than 90 days in advance"
- "Maximum X guests for this room type"

**Database Errors:**
- "Database connection error"
- "Booking not found"
- "Hotel not found"

---

## Rate Limiting

### Rate Limits by Endpoint

| Endpoint | Limit | Window | Purpose |
|----------|-------|--------|---------|
| /login | 5 requests | 5 minutes | Prevent brute force |
| /register | 3 requests | 15 minutes | Prevent spam accounts |
| /booking/create | 10 requests | 10 minutes | Prevent abuse |
| /my-bookings/export | 10 requests | 1 hour | Limit exports |
| /admin/bookings/export | 10 requests | 1 hour | Limit exports |
| Most other endpoints | 60 requests | 1 minute | General protection |

### Rate Limit Headers

When rate limited, response includes:
```
429 Too Many Requests
Retry-After: 300

{
  "error": "Rate limit exceeded. Max 5 requests per 5 minute(s)."
}
```

### Rate Limit Implementation

Rate limiting is:
- **IP-based:** Tracked per IP address
- **Endpoint-specific:** Different limits per route
- **Sliding window:** Time window slides with each request
- **In-memory:** Stored in server memory (for demo)

**Production Recommendation:** Use Redis for distributed rate limiting

---

## Security

### CSRF Protection

**All state-changing requests require CSRF token.**

**How to get CSRF token:**
1. Load page (GET request)
2. Extract token from hidden input:
```html
<input type="hidden" name="csrf_token" value="ABC123...">
```
3. Include in POST request

**Example:**
```http
POST /login HTTP/1.1
Host: localhost:5000
Content-Type: application/x-www-form-urlencoded

csrf_token=ABC123...&email=user@example.com&password=Password123
```

### SQL Injection Prevention

**All queries use parameterized statements:**
```python
# SAFE
sql = "SELECT * FROM users WHERE email = %s"
cursor.execute(sql, (email,))

# UNSAFE (never used)
# sql = f"SELECT * FROM users WHERE email = '{email}'"
```

### XSS Prevention

**Input sanitization applied:**
- HTML tags stripped
- Special characters escaped
- Jinja2 auto-escaping enabled

### Password Security

**Passwords are:**
- Hashed with bcrypt
- Salted automatically
- Never stored in plain text
- Never logged
- Never sent in emails

---

## Usage Examples

### Example 1: User Registration Flow

**Step 1: Load registration page**
```http
GET /register HTTP/1.1
Host: localhost:5000
```

**Step 2: Submit registration**
```http
POST /register HTTP/1.1
Host: localhost:5000
Content-Type: application/x-www-form-urlencoded

csrf_token=ABC123&first_name=John&last_name=Smith&email=john@example.com&phone=+447700900000&password=Password123&confirm_password=Password123&accept_terms=on
```

**Step 3: Redirect to login**
```
302 Found
Location: /login
```

---

### Example 2: Login and Create Booking

**Step 1: Login**
```http
POST /login HTTP/1.1
Host: localhost:5000
Content-Type: application/x-www-form-urlencoded

csrf_token=ABC123&email=john@example.com&password=Password123
```

**Step 2: Browse hotels**
```http
GET /hotels?city=London HTTP/1.1
Host: localhost:5000
Cookie: session=XYZ789
```

**Step 3: View hotel**
```http
GET /hotel/8 HTTP/1.1
Host: localhost:5000
Cookie: session=XYZ789
```

**Step 4: Create booking**
```http
POST /booking/create HTTP/1.1
Host: localhost:5000
Cookie: session=XYZ789
Content-Type: application/x-www-form-urlencoded

csrf_token=ABC123&hotel_id=8&check_in=2025-06-01&check_out=2025-06-05&room_type=2&num_guests=2
```

**Step 5: View receipt**
```
302 Found
Location: /receipt/123
```

---

### Example 3: Admin Export Bookings

**Step 1: Login as admin**
```http
POST /login HTTP/1.1
Host: localhost:5000
Content-Type: application/x-www-form-urlencoded

csrf_token=ABC123&email=admin@worldhotels.com&password=admin123
```

**Step 2: Access admin dashboard**
```http
GET /admin/dashboard HTTP/1.1
Host: localhost:5000
Cookie: session=ADMIN_SESSION
```

**Step 3: Export all bookings**
```http
GET /admin/bookings/export HTTP/1.1
Host: localhost:5000
Cookie: session=ADMIN_SESSION
```

**Response:**
```
200 OK
Content-Type: text/csv
Content-Disposition: attachment; filename=world_hotels_all_bookings_20250116.csv

Booking ID,Guest Name,Email,Phone,Hotel City,Room Type,Room Number,Check-in,Check-out,Nights,Guests,Total Price (£),Status,Booking Date
1,John Smith,john@example.com,+447700900000,London,Double,201,2025-06-01,2025-06-05,4,2,280.00,confirmed,2025-01-16 14:30:00
...
```

---

## Testing the API

### Using cURL

**Registration:**
```bash
curl -X POST http://localhost:5000/register \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "csrf_token=TOKEN&first_name=John&last_name=Smith&email=john@example.com&phone=+447700900000&password=Password123&confirm_password=Password123&accept_terms=on"
```

**Login:**
```bash
curl -X POST http://localhost:5000/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "csrf_token=TOKEN&email=john@example.com&password=Password123" \
  -c cookies.txt
```

**View hotels (with session):**
```bash
curl http://localhost:5000/hotels \
  -b cookies.txt
```

### Using Postman

1. **Import Collection:** Create new collection "World Hotels API"
2. **Set Base URL:** http://localhost:5000
3. **Enable Cookies:** Settings → Enable cookie jar
4. **Get CSRF Token:** 
   - Send GET request to page
   - Extract token from HTML
   - Add to form-data
5. **Make Requests:** Use form-data format for POST

### Using Python Requests
```python
import requests

# Create session to handle cookies
session = requests.Session()

# Base URL
BASE_URL = "http://localhost:5000"

# Step 1: Get CSRF token
response = session.get(f"{BASE_URL}/register")
# Parse HTML to extract csrf_token (using BeautifulSoup)

# Step 2: Register
data = {
    'csrf_token': csrf_token,
    'first_name': 'John',
    'last_name': 'Smith',
    'email': 'john@example.com',
    'phone': '+447700900000',
    'password': 'Password123',
    'confirm_password': 'Password123',
    'accept_terms': 'on'
}
response = session.post(f"{BASE_URL}/register", data=data)

# Step 3: Login
login_data = {
    'csrf_token': csrf_token,
    'email': 'john@example.com',
    'password': 'Password123'
}
response = session.post(f"{BASE_URL}/login", data=login_data)

# Step 4: Browse hotels
response = session.get(f"{BASE_URL}/hotels?city=London")
print(response.text)
```

---

## Limitations

### Current Limitations

1. **No REST API:** Primarily HTML-based, not pure REST API
2. **Session-based:** Not suitable for mobile apps without WebView
3. **CSRF Required:** Makes programmatic access more complex
4. **No OAuth:** No token-based authentication
5. **No API Versioning:** Single version only
6. **No Pagination:** All results returned at once
7. **No Webhooks:** No event notifications
8. **Rate Limiting In-Memory:** Not distributed-safe

### Future Enhancements

For a production API, consider:
- RESTful JSON API endpoints
- JWT token authentication
- OAuth 2.0 support
- API versioning (v1, v2)
- Pagination for large datasets
- GraphQL alternative
- Webhooks for events
- API documentation with Swagger/OpenAPI
- SDK libraries (Python, JavaScript)
- Redis for rate limiting

---

## Appendix

### Common Use Cases

**Use Case 1: Integration with Mobile App**
- Current limitation: Session-based auth
- Workaround: Use WebView to maintain session
- Recommended: Implement JWT tokens for mobile

**Use Case 2: Third-party Integration**
- Current limitation: CSRF protection
- Workaround: Create API-specific routes without CSRF
- Recommended: OAuth 2.0 authentication

**Use Case 3: Automated Bookings**
- Current: Can use Python requests library
- Maintain session across requests
- Extract and include CSRF tokens

**Use Case 4: Reporting/Analytics**
- Use CSV export endpoints
- Process exported data
- Schedule regular exports

### Status Enumerations

**Booking Status:**
- `confirmed` - Active, upcoming booking
- `cancelled` - Cancelled by user or admin
- `completed` - Guest has checked out

**User Type:**
- `standard` - Regular user
- `admin` - Administrator

**Room Status:**
- `available` - Room can be booked
- `maintenance` - Room unavailable
- `occupied` - Currently booked

**Room Types:**
1. Standard (1 guest)
2. Double (2 guests)
3. Family (4 guests)

**Seasons:**
1. Peak (June-August)
2. Shoulder (April-May, September-October)
3. Off-Peak (November-February)
4. Holiday (March, December)

---

## Support

### Getting Help

**Documentation:**
- User Guide: `/docs/user_guide.md`
- Admin Guide: `/docs/admin_guide.md`
- Installation Guide: `/docs/installation_guide.md`

**Contact:**
- Email: api-support@worldhotels.com
- GitHub: Create an issue in repository

### Reporting Bugs

**Include:**
1. Request details (endpoint, method, parameters)
2. Expected behavior
3. Actual behavior
4. Error messages
5. Steps to reproduce

---

## Changelog

### Version 1.0 (January 16, 2025)

**Initial Release:**
- User authentication endpoints
- Hotel search and filtering
- Booking creation and management
- Admin panel endpoints
- CSV export functionality
- Rate limiting
- CSRF protection
- Multi-currency support

---

## Conclusion

This API provides comprehensive access to the World Hotels booking system. While primarily HTML-based for demonstration purposes, it follows RESTful principles and includes robust security measures.

For production use, consider implementing:
- Token-based authentication (JWT)
- Pure JSON REST API
- API versioning
- Enhanced documentation (Swagger/OpenAPI)
- SDK libraries

---

*API Documentation Version 1.0 - January 16, 2025*