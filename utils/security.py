# ============================================
# SECURITY UTILITIES
# World Hotels Booking System
# Student: Biplab Prasad Gajurel 25024641
# Instructor: Mr. Dharmaraj Poudel
# Date: January 15, 2025
# ============================================

from functools import wraps
from flask import request, jsonify
from datetime import datetime, timedelta
import hashlib

class RateLimiter:
    """
    Simple rate limiter to prevent abuse
    In production, use Redis or similar for distributed systems
    """
    
    def __init__(self):
        self.requests = {}  # {ip: [(timestamp, endpoint), ...]}
        self.cleanup_interval = 300  # Clean old entries every 5 minutes
        self.last_cleanup = datetime.now()
    
    def _cleanup_old_requests(self):
        """Remove requests older than 1 hour"""
        if (datetime.now() - self.last_cleanup).seconds > self.cleanup_interval:
            cutoff_time = datetime.now() - timedelta(hours=1)
            for ip in list(self.requests.keys()):
                self.requests[ip] = [
                    (ts, ep) for ts, ep in self.requests[ip] if ts > cutoff_time
                ]
                if not self.requests[ip]:
                    del self.requests[ip]
            self.last_cleanup = datetime.now()
    
    def check_rate_limit(self, ip, endpoint, max_requests=60, window_minutes=1):
        """
        Check if request is within rate limit
        Default: 60 requests per minute per IP per endpoint
        """
        self._cleanup_old_requests()
        
        now = datetime.now()
        cutoff = now - timedelta(minutes=window_minutes)
        
        # Get requests for this IP
        if ip not in self.requests:
            self.requests[ip] = []
        
        # Filter to recent requests for this endpoint
        recent_requests = [
            (ts, ep) for ts, ep in self.requests[ip]
            if ts > cutoff and ep == endpoint
        ]
        
        # Check if limit exceeded
        if len(recent_requests) >= max_requests:
            return False, f"Rate limit exceeded. Max {max_requests} requests per {window_minutes} minute(s)."
        
        # Add this request
        self.requests[ip].append((now, endpoint))
        
        return True, None
    
    def rate_limit(self, max_requests=60, window_minutes=1):
        """
        Decorator for rate limiting routes
        Usage: @rate_limiter.rate_limit(max_requests=10, window_minutes=1)
        """
        def decorator(f):
            @wraps(f)
            def wrapped(*args, **kwargs):
                ip = request.remote_addr
                endpoint = request.endpoint
                
                allowed, message = self.check_rate_limit(
                    ip, endpoint, max_requests, window_minutes
                )
                
                if not allowed:
                    return jsonify({'error': message}), 429
                
                return f(*args, **kwargs)
            return wrapped
        return decorator


class SecurityHeaders:
    """Security headers to prevent common attacks"""
    
    @staticmethod
    def add_security_headers(response):
        """Add security headers to response"""
        
        # Prevent clickjacking
        response.headers['X-Frame-Options'] = 'SAMEORIGIN'
        
        # Prevent MIME type sniffing
        response.headers['X-Content-Type-Options'] = 'nosniff'
        
        # Enable XSS protection
        response.headers['X-XSS-Protection'] = '1; mode=block'
        
        # Strict Transport Security (HTTPS only - commented for development)
        # response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
        
        # Content Security Policy (basic)
        response.headers['Content-Security-Policy'] = (
            "default-src 'self'; "
            "script-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com; "
            "style-src 'self' 'unsafe-inline'; "
            "img-src 'self' data: https:; "
            "font-src 'self' data:; "
            "connect-src 'self';"
        )
        
        # Referrer Policy
        response.headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        
        # Permissions Policy
        response.headers['Permissions-Policy'] = 'geolocation=(), microphone=(), camera=()'
        
        return response


class PasswordSecurity:
    """Additional password security utilities"""
    
    @staticmethod
    def check_password_strength(password):
        """
        Check password strength and return score
        Returns: (score 0-5, list of requirements met, list of suggestions)
        """
        score = 0
        met = []
        suggestions = []
        
        # Length check
        if len(password) >= 8:
            score += 1
            met.append("Minimum 8 characters")
        else:
            suggestions.append("Use at least 8 characters")
        
        if len(password) >= 12:
            score += 1
            met.append("12+ characters (strong)")
        
        # Character type checks
        if any(c.isupper() for c in password):
            score += 1
            met.append("Contains uppercase letter")
        else:
            suggestions.append("Add uppercase letter")
        
        if any(c.islower() for c in password):
            met.append("Contains lowercase letter")
        else:
            suggestions.append("Add lowercase letter")
        
        if any(c.isdigit() for c in password):
            score += 1
            met.append("Contains number")
        else:
            suggestions.append("Add number")
        
        if any(c in '!@#$%^&*()_+-=[]{}|;:,.<>?' for c in password):
            score += 1
            met.append("Contains special character")
        else:
            suggestions.append("Add special character (!@#$%^&* etc.)")
        
        return score, met, suggestions
    
    @staticmethod
    def is_common_password(password):
        """Check against common passwords (simple check)"""
        common_passwords = [
            'password', '12345678', 'qwerty', 'abc123', 'password123',
            'admin', 'letmein', 'welcome', 'monkey', '1234567890',
            'password1', 'admin123', 'root', 'test', 'user'
        ]
        return password.lower() in common_passwords


# Create global instances
rate_limiter = RateLimiter()
security_headers = SecurityHeaders()
password_security = PasswordSecurity()
from flask import session, redirect, url_for, abort
from functools import wraps

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # User not logged in
        if 'user_id' not in session:
            return redirect(url_for('login'))
        
        # Logged in but not admin
        if session.get('user_type') != 'admin':
            abort(403)
        
        return f(*args, **kwargs)
    return decorated_function
