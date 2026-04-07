# ============================================
# EMAIL SERVICE (SIMULATED)
# World Hotels Booking System
# Student: Biplab Prasad Gajurel 25024641
# Instructor: Mr. Dharmaraj Poudel
# Date: January 14, 2026
# ============================================

from datetime import datetime

class EmailService:
    """
    Simulated email service for demonstration purposes
    In production, this would use Flask-Mail or similar service
    """
    
    def __init__(self):
        self.sent_emails = []  # Store sent emails for demo
    
    def send_booking_confirmation(self, booking_data):
        """Send booking confirmation email"""
        email_content = self._generate_booking_confirmation(booking_data)
        
        # Simulate sending email
        email = {
            'to': booking_data['guest_email'],
            'subject': f'Booking Confirmation - #{booking_data["booking_id"]}',
            'body': email_content,
            'sent_at': datetime.now(),
            'type': 'booking_confirmation'
        }
        
        self.sent_emails.append(email)
        
        # In production, we would have used:
        # msg = Message(email['subject'], recipients=[email['to']])
        # msg.body = email['body']
        # mail.send(msg)

        return True
    
    def send_cancellation_confirmation(self, booking_data):
        """Send cancellation confirmation email"""
        email_content = self._generate_cancellation_email(booking_data)
        
        email = {
            'to': booking_data['guest_email'],
            'subject': f'Booking Cancelled - #{booking_data["booking_id"]}',
            'body': email_content,
            'sent_at': datetime.now(),
            'type': 'cancellation'
        }
        
        self.sent_emails.append(email)
        return True
    
    def send_reminder_email(self, booking_data):
        """Send check-in reminder email"""
        email_content = self._generate_reminder_email(booking_data)
        
        email = {
            'to': booking_data['guest_email'],
            'subject': f'Check-in Reminder - {booking_data["hotel_city"]}',
            'body': email_content,
            'sent_at': datetime.now(),
            'type': 'reminder'
        }
        
        self.sent_emails.append(email)
        return True
    
    def _generate_booking_confirmation(self, booking_data):
        """Generate booking confirmation email content"""
        return f"""
Dear {booking_data['guest_name']},

Thank you for booking with World Hotels!

BOOKING CONFIRMATION
====================

Booking ID: #{booking_data['booking_id']}
Status: Confirmed

HOTEL DETAILS
-------------
Hotel: World Hotels {booking_data['hotel_city']}
Address: {booking_data['hotel_address']}

STAY DETAILS
------------
Check-in: {booking_data['check_in_date']} (from 14:00)
Check-out: {booking_data['check_out_date']} (by 11:00)
Nights: {booking_data['nights']}
Room Type: {booking_data['room_type']}
Room Number: {booking_data['room_number']}
Guests: {booking_data['number_of_guests']}

PRICING
-------
Base Price: £{booking_data['base_price']}
Discount ({booking_data['discount_percentage']}%): -£{booking_data['discount_amount']}
Total Amount: £{booking_data['final_price']}

AMENITIES INCLUDED
------------------
✓ Free High-Speed WiFi
✓ Complimentary Breakfast
✓ Mini-bar
✓ Flat-Screen TV
✓ Free Parking

CANCELLATION POLICY
-------------------
- FREE cancellation up to 60 days before check-in
- 50% charge if cancelled 30-60 days before
- 100% charge if cancelled within 30 days

IMPORTANT INFORMATION
---------------------
- Please bring a valid ID and this confirmation at check-in
- Early check-in/late check-out available upon request
- For any queries, contact us at +44 20 1234 5678

We look forward to welcoming you!

Best regards,
World Hotels Team

---
This is an automated confirmation email.
Reply to: reservations@worldhotels.com
"""
    
    def _generate_cancellation_email(self, booking_data):
        """Generate cancellation confirmation email"""
        return f"""
Dear {booking_data['guest_name']},

Your booking has been cancelled as requested.

CANCELLATION DETAILS
====================

Booking ID: #{booking_data['booking_id']}
Status: Cancelled

Original Booking:
- Hotel: World Hotels {booking_data['hotel_city']}
- Check-in: {booking_data['check_in_date']}
- Check-out: {booking_data['check_out_date']}
- Room Type: {booking_data['room_type']}

REFUND INFORMATION
------------------
Booking Amount: £{booking_data['final_price']}
Cancellation Charge: £{booking_data.get('cancellation_charge', 0)}
Refund Amount: £{booking_data['final_price'] - booking_data.get('cancellation_charge', 0)}

The refund will be processed within 7-10 business days.

We hope to serve you again in the future!

Best regards,
World Hotels Team

---
For questions, contact: reservations@worldhotels.com
"""
    
    def _generate_reminder_email(self, booking_data):
        """Generate check-in reminder email"""
        return f"""
Dear {booking_data['guest_name']},

Your stay at World Hotels {booking_data['hotel_city']} is coming up soon!

UPCOMING STAY
=============

Check-in: {booking_data['check_in_date']} (from 14:00)
Booking ID: #{booking_data['booking_id']}

REMINDERS
---------
✓ Bring a valid photo ID
✓ Bring your booking confirmation
✓ Check-in starts at 14:00
✓ Contact us for early check-in requests

HOTEL CONTACT
-------------
Phone: +44 20 1234 5678
Address: {booking_data['hotel_address']}

We're excited to welcome you!

Best regards,
World Hotels Team
"""
    
    def get_sent_emails(self, limit=10):
        """Get recently sent emails (for admin view)"""
        return self.sent_emails[-limit:]

# Create global instance
email_service = EmailService()