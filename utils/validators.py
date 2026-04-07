# ============================================
# INPUT VALIDATION UTILITIES
# World Hotels Booking System
# Student: Biplab Prasad Gajurel 25024641
# Instructor: Mr. Dharmaraj Poudel
# Date: January 15, 2025
# ============================================

import re
from datetime import datetime, timedelta

class InputValidator:
    """
    Comprehensive input validation for security and data integrity
    Prevents SQL injection, XSS, and ensures business rule compliance
    """
    
    @staticmethod
    def validate_email(email):
        """Validate email format"""
        if not email or len(email) > 255:
            return False, "Email is required and must be under 255 characters"
        
        # RFC 5322 compliant email regex (simplified)
        email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        
        if not re.match(email_pattern, email):
            return False, "Invalid email format"
        
        return True, None
    
    @staticmethod
    def validate_password(password):
        """
        Validate password strength
        Requirements:
        - At least 8 characters
        - Contains at least one letter
        - Contains at least one number
        """
        if not password:
            return False, "Password is required"
        
        if len(password) < 8:
            return False, "Password must be at least 8 characters long"
        
        if len(password) > 128:
            return False, "Password too long (max 128 characters)"
        
        if not re.search(r'[a-zA-Z]', password):
            return False, "Password must contain at least one letter"
        
        if not re.search(r'\d', password):
            return False, "Password must contain at least one number"
        
        return True, None
    
    @staticmethod
    def validate_name(name, field_name="Name"):
        """Validate name fields (first name, last name)"""
        if not name or not name.strip():
            return False, f"{field_name} is required"
        
        if len(name) > 100:
            return False, f"{field_name} must be under 100 characters"
        
        # Allow letters, spaces, hyphens, apostrophes
        if not re.match(r"^[a-zA-Z\s\-']+$", name):
            return False, f"{field_name} contains invalid characters"
        
        return True, None
    
    @staticmethod
    def validate_phone(phone):
        """Validate phone number"""
        if not phone or not phone.strip():
            return False, "Phone number is required"
        
        # Remove spaces and common separators
        cleaned = re.sub(r'[\s\-\(\)\.]', '', phone)
        
        # Should be 10-15 digits, optionally starting with +
        if not re.match(r'^\+?\d{10,15}$', cleaned):
            return False, "Invalid phone number format (10-15 digits required)"
        
        return True, None
    
    @staticmethod
    def validate_date(date_str, field_name="Date"):
        """Validate date format and parse"""
        if not date_str:
            return False, None, f"{field_name} is required"
        
        try:
            date_obj = datetime.strptime(date_str, '%Y-%m-%d').date()
            return True, date_obj, None
        except ValueError:
            return False, None, f"Invalid {field_name} format (YYYY-MM-DD required)"
    
    @staticmethod
    def validate_booking_dates(check_in_str, check_out_str):
        """
        Validate booking dates according to business rules:
        - Check-in must be in the future
        - Check-out must be after check-in
        - Maximum stay: 30 days
        - Maximum advance booking: 90 days
        """
        # Validate check-in date
        valid, check_in, error = InputValidator.validate_date(check_in_str, "Check-in date")
        if not valid:
            return False, None, None, error
        
        # Validate check-out date
        valid, check_out, error = InputValidator.validate_date(check_out_str, "Check-out date")
        if not valid:
            return False, None, None, error
        
        today = datetime.now().date()
        
        # Check-in must be today or future
        if check_in < today:
            return False, None, None, "Check-in date cannot be in the past"
        
        # Check-out must be after check-in
        if check_out <= check_in:
            return False, None, None, "Check-out date must be after check-in date"
        
        # Calculate nights
        nights = (check_out - check_in).days
        
        # Maximum 30 days stay
        if nights > 30:
            return False, None, None, "Maximum stay is 30 days"
        
        # Maximum 90 days advance booking
        days_advance = (check_in - today).days
        if days_advance > 90:
            return False, None, None, "Cannot book more than 90 days in advance"
        
        return True, check_in, check_out, None
    
    @staticmethod
    def validate_integer(value, field_name="Value", min_val=None, max_val=None):
        """Validate integer input with optional range"""
        if value is None or value == '':
            return False, None, f"{field_name} is required"
        
        try:
            int_val = int(value)
        except (ValueError, TypeError):
            return False, None, f"{field_name} must be a number"
        
        if min_val is not None and int_val < min_val:
            return False, None, f"{field_name} must be at least {min_val}"
        
        if max_val is not None and int_val > max_val:
            return False, None, f"{field_name} must be at most {max_val}"
        
        return True, int_val, None
    
    @staticmethod
    def validate_decimal(value, field_name="Value", min_val=None, max_val=None):
        """Validate decimal/float input with optional range"""
        if value is None or value == '':
            return False, None, f"{field_name} is required"
        
        try:
            decimal_val = float(value)
        except (ValueError, TypeError):
            return False, None, f"{field_name} must be a number"
        
        if min_val is not None and decimal_val < min_val:
            return False, None, f"{field_name} must be at least {min_val}"
        
        if max_val is not None and decimal_val > max_val:
            return False, None, f"{field_name} must be at most {max_val}"
        
        return True, decimal_val, None
    
    @staticmethod
    def sanitize_string(value, max_length=None):
        """
        Sanitize string input to prevent XSS
        Strips HTML tags and dangerous characters
        """
        if not value:
            return ""
        
        # Convert to string
        value = str(value)
        
        # Strip leading/trailing whitespace
        value = value.strip()
        
        # Remove HTML tags (basic protection)
        value = re.sub(r'<[^>]*>', '', value)
        
        # Remove null bytes
        value = value.replace('\x00', '')
        
        # Truncate if needed
        if max_length and len(value) > max_length:
            value = value[:max_length]
        
        return value
    
    @staticmethod
    def validate_guest_count(count, room_type_max_guests):
        """Validate number of guests against room capacity"""
        valid, count_int, error = InputValidator.validate_integer(
            count, "Number of guests", min_val=1, max_val=10
        )
        
        if not valid:
            return False, None, error
        
        if count_int > room_type_max_guests:
            return False, None, f"This room type accommodates maximum {room_type_max_guests} guests"
        
        return True, count_int, None
    
    @staticmethod
    def validate_hotel_id(hotel_id):
        """Validate hotel ID exists and is valid"""
        valid, id_int, error = InputValidator.validate_integer(
            hotel_id, "Hotel ID", min_val=1
        )
        return valid, id_int, error
    
    @staticmethod
    def validate_room_type_id(room_type_id):
        """Validate room type ID"""
        valid, id_int, error = InputValidator.validate_integer(
            room_type_id, "Room type", min_val=1, max_val=3
        )
        return valid, id_int, error
    
    @staticmethod
    def validate_enum(value, allowed_values, field_name="Value"):
        """Validate value is in allowed set"""
        if value not in allowed_values:
            return False, f"Invalid {field_name}. Allowed values: {', '.join(allowed_values)}"
        return True, None
    
    @staticmethod
    def validate_currency_code(code):
        """Validate currency code"""
        allowed_currencies = ['GBP', 'USD', 'EUR', 'NPR', 'INR', 'AUD', 'CAD', 'JPY']
        return InputValidator.validate_enum(code, allowed_currencies, "Currency code")


class SecurityValidator:
    """Additional security checks"""
    
    @staticmethod
    def check_sql_injection_patterns(value):
        """
        Basic SQL injection pattern detection
        Note: We use parameterized queries, but this adds extra layer
        """
        if not value:
            return True
        
        # Convert to string
        value_str = str(value).lower()
        
        # Dangerous patterns
        patterns = [
            r"(\b(union|select|insert|update|delete|drop|create|alter|exec|execute)\b)",
            r"(--|\#|\/\*|\*\/)",
            r"(\bor\b.*=.*\b)",
            r"(\band\b.*=.*\b)",
            r"(;.*\b(drop|delete|update)\b)"
        ]
        
        for pattern in patterns:
            if re.search(pattern, value_str):
                return False
        
        return True
    
    @staticmethod
    def validate_session_user(session, required_user_type=None):
        """Validate user session is active and authorized"""
        if 'user_id' not in session:
            return False, "Please login to continue"
        
        if required_user_type and session.get('user_type') != required_user_type:
            return False, "Insufficient permissions"
        
        return True, None