# World Hotels - User Guide

**Version:** 1.0  
**Date:** January 17, 2025  
**Student:** Biplab Prasad Gajurel 25024641

---

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Creating an Account](#creating-an-account)
4. [Logging In](#logging-in)
5. [Searching for Hotels](#searching-for-hotels)
6. [Making a Booking](#making-a-booking)
7. [Managing Your Bookings](#managing-your-bookings)
8. [Cancelling a Booking](#cancelling-a-booking)
9. [Your Profile](#your-profile)
10. [Multi-Currency Support](#multi-currency-support)
11. [Troubleshooting](#troubleshooting)
12. [FAQs](#faqs)

---

## Introduction

Welcome to **World Hotels** - your trusted partner for hotel bookings across 17 beautiful UK cities!

### What is World Hotels?

World Hotels is an online hotel booking system that allows you to:
- 🏨 Browse hotels in 17 UK cities
- 💷 View real-time pricing with seasonal rates
- 📅 Book rooms up to 90 days in advance
- 🎁 Get up to 30% discount on advance bookings
- 💳 Manage all your bookings in one place
- 🌍 View prices in multiple currencies

### System Requirements

- **Browser:** Chrome, Firefox, Safari, or Edge (latest version)
- **Internet Connection:** Required
- **JavaScript:** Must be enabled
- **Cookies:** Must be enabled for login

---

## Getting Started

### Accessing the System

1. Open your web browser
2. Navigate to: `http://localhost:5000` (or the URL provided)
3. You'll see the homepage with a search bar

### No Account Needed for Browsing!

You can:
- Browse all hotels
- View hotel details
- Check prices
- Use search filters

### Account Required for Booking

To make a booking, you need to:
- Create an account (free!)
- Login

---

## Creating an Account

### Step-by-Step Registration

1. **Click "Register"** in the top navigation bar
   
2. **Fill in your details:**
   - **First Name:** Your first name
   - **Last Name:** Your last name
   - **Email:** Valid email address (used for login)
   - **Phone:** Your contact number
   - **Password:** At least 8 characters, must include letters and numbers
   - **Confirm Password:** Re-enter your password

3. **Review Terms & Conditions**
   - Check the box to accept
   - Optionally, subscribe to promotions

4. **Click "Create Account"**

5. **Success!** You'll be redirected to login

### Password Requirements

Your password must:
- Be at least 8 characters long
- Contain at least one letter
- Contain at least one number

**Example Good Passwords:**
- `MyPassword123`
- `Hotel2025Stay`
- `Booking4Me!`

**Example Weak Passwords (rejected):**
- `password` (too common)
- `12345678` (no letters)
- `short1` (too short)

### Registration Tips

**Tip:** Use a real email address - you'll receive booking confirmations!

**Tip:** Choose a memorable password - you'll need it to login

**Tip:** Keep your phone number updated for booking communications

---

## Logging In

### How to Login

1. **Click "Login"** in the top navigation bar

2. **Enter your credentials:**
   - Email address (used during registration)
   - Password

3. **Optional:** Check "Remember me" to stay logged in

4. **Click "Login"**

### Forgot Your Password?

Currently, password reset is handled by administrators.

**Contact support:** info@worldhotels.com

### Login Troubleshooting

**Problem:** "Invalid email or password"  
**Solution:** 
- Check for typos
- Ensure Caps Lock is OFF
- Try resetting your password

**Problem:** "Too many login attempts"  
**Solution:** 
- Wait 5 minutes
- You're rate-limited for security

**Problem:** "Email not found"  
**Solution:** 
- You may not have registered
- Check if you used a different email
- Register a new account

---

## Searching for Hotels

### Quick Search (Homepage)

1. **On the homepage**, you'll see a search form
2. **Select:**
   - Destination city
   - Check-in date
   - Check-out date
   - Number of guests
3. **Click "Search Hotels"**

### Advanced Search (Hotels Page)

1. **Go to "Hotels"** in the navigation
2. **Use filters:**
   - **City:** Select specific city or "All Cities"
   - **Room Type:** Standard, Double, or Family
   - **Guests:** Number of people
   - **Check-in/Check-out:** Your stay dates
   - **Price Range:** Min and max price per night

3. **Sort results by:**
   - City (A-Z)
   - Price (Low to High)
   - Price (High to Low)
   - Capacity (Large to Small)

4. **Click "Apply Filters"**

### Understanding Search Results

Each hotel card shows:
- **Hotel Name:** World Hotels [City]
- **Address:** Full hotel address
- **Price From:** Starting price per night
- **Room Types:** Available room categories
- **Amenities:** WiFi, breakfast, etc.

### Clear All Filters

Click **"Clear"** button to reset all filters and see all hotels

---

## Making a Booking

### Step 1: Select a Hotel

1. Browse hotels using search/filters
2. Click **"View Details"** on your chosen hotel
3. Review hotel information and amenities

### Step 2: Choose Your Dates

On the hotel detail page:
1. **Check-in Date:** Select your arrival date
2. **Check-out Date:** Select your departure date
3. **Room Type:** Choose Standard, Double, or Family
4. **Number of Guests:** Select guest count

**Rules:**
- Maximum stay: 30 days
- Book up to 90 days in advance
- Guests must not exceed room capacity

### Step 3: Review Pricing

The booking summary shows:
- **Room Rate:** Base price per night × nights
- **Discount:** If applicable (see discount section)
- **Total:** Final amount to pay

### Step 4: Complete Booking

1. **Click "Continue to Booking"**
2. **Review your information** (pre-filled from your account)
3. **Add special requests** (optional)
4. **Select payment method** (demo only)
5. **Accept terms and conditions**
6. **Click "Confirm Booking"**

### Step 5: Confirmation

**Booking confirmed!**
- You'll see your booking receipt
- Confirmation email sent (simulated)
- Booking added to "My Bookings"

---

## Advance Booking Discounts

### How Discounts Work

Book in advance and save money!

| Booking Window | Discount |
|----------------|----------|
| 80-90 days in advance | **30% OFF** 🎉 |
| 60-79 days in advance | **20% OFF** 🎊 |
| 45-59 days in advance | **10% OFF** 🎈 |
| Less than 45 days | No discount |

### Example

**Hotel:** London, Standard Room  
**Price:** £100/night  
**Stay:** 3 nights  
**Base Total:** £300

**If you book 85 days in advance:**
- Discount: 30% = £90
- **Final Price: £210**

---

## Managing Your Bookings

### View All Bookings

1. **Login** to your account
2. **Click "My Bookings"** in navigation
3. See all your bookings (past and upcoming)

### Filter Bookings

Use tabs to filter:
- **Upcoming:** Confirmed future bookings
- **Past:** Completed stays
- **Cancelled:** Cancelled bookings
- **All Bookings:** Everything

### View Booking Details

For each booking, you can see:
- Booking ID
- Hotel and room details
- Check-in and check-out dates
- Number of nights
- Number of guests
- Price breakdown
- Booking status
- Discount applied (if any)

### Download Booking Receipt

1. **Find your booking** in "My Bookings"
2. **Click "View Receipt"**
3. **Click "Print Receipt"** or **"Download PDF"**

### Export All Bookings

1. **Go to "My Bookings"**
2. **Click "Export to CSV"** (top right)
3. CSV file downloads with all your bookings
4. Open in Excel or Google Sheets

---

## Cancelling a Booking

### Cancellation Policy

**Free Cancellation:**
- Cancel **60+ days** before check-in: **NO CHARGE**

**Partial Charge:**
- Cancel **30-60 days** before check-in: **50% charge**

**Full Charge:**
- Cancel **less than 30 days** before check-in: **100% charge (no refund)**

### How to Cancel

1. **Go to "My Bookings"**
2. **Find the booking** you want to cancel
3. **Click "Cancel Booking"** button
4. **Read the cancellation charge notice**
5. **Confirm cancellation**

### After Cancellation

- Booking status changes to "Cancelled"
- Cancellation email sent
- Refund processed (if applicable) in 7-10 days
- Room becomes available for others

---

## Your Profile

### View Profile

1. **Login** to your account
2. **Click "My Profile"** in navigation

### Update Personal Information

1. **Click "Edit"** button
2. **Update:**
   - First name
   - Last name
   - Phone number
3. **Click "Save Changes"**

**Note:** Email cannot be changed (security reason)

### Change Password

1. **Go to your profile**
2. **Scroll to "Security & Password"**
3. **Click "Change Password"**
4. **Enter:**
   - Current password
   - New password (must meet requirements)
   - Confirm new password
5. **Click "Update Password"**

### Update Preferences

Set your preferences:
- **Preferred Currency:** GBP, USD, EUR, NPR, INR
- **Email Notifications:**
  - Booking confirmations
  - Promotional offers
  - Stay reminders

---

## Multi-Currency Support

### Available Currencies

- 🇬🇧 **GBP** - British Pound (£)
- 🇺🇸 **USD** - US Dollar ($)
- 🇪🇺 **EUR** - Euro (€)
- 🇳🇵 **NPR** - Nepalese Rupee (रू)
- 🇮🇳 **INR** - Indian Rupee (₹)

### How to Change Currency

**Method 1: Navigation Bar**
1. **Look for currency selector** (top right)
2. **Select your currency** from dropdown
3. All prices update automatically

**Method 2: Profile Settings**
1. **Go to "My Profile"**
2. **Click "Preferences"**
3. **Select "Preferred Currency"**
4. **Click "Save Preferences"**

### Notes on Currency

- Prices shown are **estimates** based on exchange rates
- **Actual payment** processes in GBP
- Exchange rates updated regularly
- Conversion is for display only

---

## Troubleshooting

### Common Issues & Solutions

#### Can't Login

**Problem:** Login keeps failing  
**Solutions:**
1. Check email and password spelling
2. Ensure Caps Lock is OFF
3. Try "Forgot Password"
4. Clear browser cache and cookies
5. Try a different browser

#### Booking Not Showing

**Problem:** Made a booking but can't see it  
**Solutions:**
1. Check "My Bookings" page
2. Ensure you're logged into correct account
3. Check "All Bookings" tab (not just "Upcoming")
4. Refresh the page (F5)
5. Contact support if issue persists

#### No Rooms Available

**Problem:** "No rooms available" message  
**Solutions:**
1. Try different dates
2. Try different room type
3. Check if dates are more than 90 days ahead
4. Try a different hotel in same city

#### Price Seems Wrong

**Problem:** Price doesn't match expected amount  
**Solutions:**
1. Check which season (Peak vs Off-Peak)
2. Check room type (Family costs more)
3. Check if discount applied
4. Verify currency (might be in different currency)
5. Check number of nights

#### Can't Export CSV

**Problem:** Export button not working  
**Solutions:**
1. Ensure you have bookings to export
2. Check popup blocker settings
3. Try different browser
4. Check download folder permissions

---

## FAQs

### General Questions

**Q: Is this a real booking system?**  
A: This is a student demonstration project. No real payments are processed.

**Q: How many hotels are available?**  
A: 17 hotels across major UK cities.

**Q: Can I book multiple rooms?**  
A: Currently, one room per booking. Make multiple bookings if needed.

**Q: What payment methods are accepted?**  
A: This is a demo system. Payment is simulated.

### Booking Questions

**Q: How far in advance can I book?**  
A: Up to 90 days in advance.

**Q: What's the maximum stay?**  
A: 30 consecutive days.

**Q: Can I modify a booking?**  
A: Currently, you need to cancel and rebook.

**Q: When do I get charged?**  
A: At the time of booking confirmation.

### Discount Questions

**Q: How do I get a discount?**  
A: Book 45+ days in advance automatically applies discount.

**Q: Can I use multiple discounts?**  
A: No, only one discount applies per booking.

**Q: Do discounts apply to all rooms?**  
A: Yes, all room types eligible for advance booking discounts.

### Cancellation Questions

**Q: Can I cancel for free?**  
A: Yes, if you cancel 60+ days before check-in.

**Q: How long for refund?**  
A: 7-10 business days (in real system).

**Q: Can I cancel partially?**  
A: No, you must cancel entire booking.

### Account Questions

**Q: Can I delete my account?**  
A: Contact admin. Cannot delete if you have active bookings.

**Q: Can I change my email?**  
A: No, email is permanent. Create new account if needed.

**Q: Is my data safe?**  
A: Yes, passwords are encrypted, and we follow security best practices.

---

## Getting Help

### Contact Support

**Email:** info@worldhotels.com  
**Phone:** +44 20 1234 5678  
**Hours:** Monday-Friday, 9am-6pm GMT

### Report a Bug

If you encounter technical issues:
1. Note what you were trying to do
2. Take a screenshot if possible
3. Email details to: support@worldhotels.com

### Feedback

We value your feedback!
- Email suggestions to: feedback@worldhotels.com
- Rate your experience after checkout

---

## Tips for Best Experience

### Booking Tips

1. **Book Early:** Get up to 30% off by booking 80-90 days ahead
2. **Off-Peak Travel:** January-March and September-October have lower prices
3. **Flexible Dates:** Check nearby dates for better prices
4. **Room Type:** Standard rooms are most affordable

### Account Tips

1. **Use Strong Password:** Protect your account
2. **Keep Email Updated:** Receive important notifications
3. **Save Currency Preference:** Set it once, applies everywhere
4. **Export Bookings:** Keep records in CSV for your files

### Security Tips

1. **Logout After Use:** Especially on shared computers
2. **Don't Share Password:** Keep credentials private
3. **Check URLs:** Ensure you're on the correct website
4. **Beware Phishing:** We never ask for passwords via email

---

## Appendix

### Keyboard Shortcuts

- **Ctrl + F:** Search on page
- **F5:** Refresh page
- **Ctrl + P:** Print (for receipts)

### Browser Compatibility

| Browser | Minimum Version |
|---------|-----------------|
| Chrome | 90+ |
| Firefox | 88+ |
| Safari | 14+ |
| Edge | 90+ |

### Screen Resolutions Supported

- Desktop: 1920×1080 and above
- Laptop: 1366×768 and above
- Tablet: 768×1024
- Mobile: 375×667 and above

---

## Conclusion

Thank you for choosing **World Hotels**!

We hope this guide helps you have a smooth booking experience. If you have any questions not covered here, please don't hesitate to contact our support team.

**Happy Booking!**✨

---

*User Guide Version 1.0 - January 16, 2025*