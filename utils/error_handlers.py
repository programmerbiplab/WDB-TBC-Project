# ============================================
# ERROR HANDLERS & USER FEEDBACK
# Instructor: Mr. Dharmaraj Poudel

# World Hotels Booking System
# Student: Biplab Prasad Gajurel 2502461
# Date: January 16, 2025
# ============================================

from flask import render_template, request, jsonify
import traceback
from datetime import datetime

class ErrorHandler:
    """Centralized error handling"""
    
    @staticmethod
    def log_error(error, context=""):
        """Log error details for debugging"""
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        error_type = type(error).__name__
        error_message = str(error)
        
        log_entry = f"""
{'='*60}
ERROR LOG
{'='*60}
Timestamp: {timestamp}
Type: {error_type}
Message: {error_message}
Context: {context}
Request: {request.method} {request.path}
IP: {request.remote_addr}
User Agent: {request.user_agent.string}
{'='*60}
Traceback:
{traceback.format_exc()}
{'='*60}
"""
        
        # In production, this would go to a logging service
        print(log_entry)
        
        # Optionally write to file
        try:
            with open('logs/errors.log', 'a') as f:
                f.write(log_entry)
        except:
            pass  # If logging fails, don't break the app
    
    @staticmethod
    def handle_404(error):
        """Handle 404 errors"""
        if request.path.startswith('/api/'):
            return jsonify({'error': 'Resource not found'}), 404
        return render_template('errors/404.html'), 404
    
    @staticmethod
    def handle_500(error):
        """Handle 500 errors"""
        ErrorHandler.log_error(error, "Internal Server Error")
        
        if request.path.startswith('/api/'):
            return jsonify({'error': 'Internal server error'}), 500
        return render_template('errors/500.html'), 500
    
    @staticmethod
    def handle_403(error):
        """Handle 403 Forbidden errors"""
        if request.path.startswith('/api/'):
            return jsonify({'error': 'Access forbidden'}), 403
        return render_template('errors/403.html'), 403
    
    @staticmethod
    def handle_400(error):
        """Handle 400 Bad Request errors"""
        if request.path.startswith('/api/'):
            return jsonify({'error': 'Bad request'}), 400
        return render_template('errors/400.html'), 400
    
    @staticmethod
    def handle_429(error):
        """Handle 429 Rate Limit errors"""
        if request.path.startswith('/api/'):
            return jsonify({'error': 'Too many requests. Please slow down.'}), 429
        return render_template('errors/429.html'), 429


class UserFeedback:
    """Helper for user feedback messages"""
    
    # Success messages
    SUCCESS = {
        'registration': 'Registration successful! Please login to continue.',
        'login': 'Welcome back! You have successfully logged in.',
        'logout': 'You have been logged out successfully.',
        'booking_created': 'Booking confirmed! Confirmation email sent.',
        'booking_cancelled': 'Booking cancelled successfully.',
        'profile_updated': 'Profile updated successfully!',
        'password_changed': 'Password changed successfully!',
        'preferences_updated': 'Preferences saved!',
    }
    
    # Error messages
    ERROR = {
        'db_connection': 'Database connection error. Please try again later.',
        'invalid_credentials': 'Invalid email or password. Please try again.',
        'email_exists': 'This email is already registered. Please login instead.',
        'weak_password': 'Password must be at least 8 characters with letters and numbers.',
        'password_mismatch': 'Passwords do not match. Please try again.',
        'booking_failed': 'Booking failed. Please try again.',
        'no_availability': 'No rooms available for the selected dates.',
        'invalid_dates': 'Invalid dates selected. Please check and try again.',
        'permission_denied': 'You do not have permission to perform this action.',
        'not_found': 'The requested resource was not found.',
        'rate_limited': 'Too many attempts. Please try again later.',
    }
    
    # Warning messages
    WARNING = {
        'login_required': 'Please login to access this page.',
        'admin_required': 'Admin access required for this page.',
        'cancellation_charge': 'Cancellation charges apply based on our policy.',
        'approaching_limit': 'You are approaching the booking limit.',
    }
    
    # Info messages
    INFO = {
        'test_mode': 'This is a demonstration system. No real payments are processed.',
        'email_simulated': 'Email notifications are simulated in this demo.',
        'advanced_booking': 'Book 45+ days in advance for up to 30% discount!',
    }