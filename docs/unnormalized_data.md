# Unnormalized Data Structure (UNF)

**Date:** January 10, 2025

---

## Single Table Representation (Before Normalization)
```
HOTEL_BOOKING_EVERYTHING (Unnormalized Form):
==============================================

BOOKING DATA:
- booking_id
- booking_date
- booking_status

USER DATA:
- user_id
- user_email
- user_password
- user_first_name
- user_last_name
- user_phone
- user_type
- user_created_date

HOTEL DATA:
- hotel_id
- hotel_city
- hotel_capacity
- hotel_address

ROOM DATA:
- room_id
- room_number
- room_type
- room_status
- has_wifi
- has_minibar
- has_tv
- includes_breakfast

PRICING DATA (REPEATING GROUPS):
- standard_room_peak_price
- standard_room_offpeak_price
- double_room_peak_price
- double_room_offpeak_price
- family_room_peak_price
- family_room_offpeak_price

BOOKING DETAILS:
- check_in_date
- check_out_date
- number_of_nights
- number_of_guests
- base_price
- discount_percentage
- discount_amount
- final_price
- cancellation_charge

CURRENCY DATA:
- currency_code
- currency_name
- exchange_rate
- price_in_currency

SEASON DATA:
- season_type
- season_start_month
- season_end_month
```

---

## Problems Identified

### 1. Data Redundancy
- Hotel info repeated for every booking
- User info duplicated across bookings
- Pricing data stored in 6 separate columns

### 2. Update Anomalies
- Changing hotel price requires updating multiple rows
- Risk of inconsistent data
- Difficult to maintain

### 3. Insertion Anomalies
- Cannot add hotel without booking
- Cannot add prices without actual bookings
- Cannot store user without booking

### 4. Deletion Anomalies
- Deleting bookings removes hotel info
- Loss of user data
- Loss of pricing history

### 5. Repeating Groups
- 6 price columns (3 room types × 2 seasons)
- Difficult to add new room types
- Hard to query specific prices

### 6. Poor Performance
- Very large table
- Slow queries
- Difficult indexing

---

## Solution: Normalize to 3NF

Separate into multiple related tables:
- users
- hotels
- room_types
- rooms
- seasons
- prices
- bookings
- booking_pricing
- exchange_rates

This eliminates redundancy and ensures data integrity.

---

*Document created: January 10, 2025*