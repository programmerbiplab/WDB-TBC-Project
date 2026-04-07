# ============================================
# PERFORMANCE OPTIMIZATION UTILITIES
# Instructor = Mr. Dharmaraj Poudel
# World Hotels Booking System
# Student: Biplab Prasad Gajurel 25024641
# Date: January 16, 2025
# ============================================

from functools import wraps
from flask import request, g
import time

class PerformanceMonitor:
    """Monitor and optimize application performance"""
    
    def __init__(self):
        self.slow_queries = []
        self.request_times = []
    
    def monitor_request(self, f):
        """Decorator to monitor request execution time"""
        @wraps(f)
        def decorated_function(*args, **kwargs):
            start_time = time.time()
            
            result = f(*args, **kwargs)
            
            execution_time = time.time() - start_time
            
            # Log slow requests (>1 second)
            if execution_time > 1.0:
                self.slow_queries.append({
                    'endpoint': request.endpoint,
                    'method': request.method,
                    'time': execution_time,
                    'timestamp': time.time()
                })
                print(f"⚠️ Slow request: {request.endpoint} took {execution_time:.2f}s")
            
            # Track for analytics
            self.request_times.append({
                'endpoint': request.endpoint,
                'time': execution_time
            })
            
            # Keep only last 1000 entries
            if len(self.request_times) > 1000:
                self.request_times = self.request_times[-1000:]
            
            return result
        
        return decorated_function
    
    def get_average_response_time(self):
        """Get average response time across all requests"""
        if not self.request_times:
            return 0
        
        total_time = sum(req['time'] for req in self.request_times)
        return total_time / len(self.request_times)
    
    def get_slow_endpoints(self, limit=10):
        """Get slowest endpoints"""
        return sorted(self.slow_queries, key=lambda x: x['time'], reverse=True)[:limit]


class DatabaseOptimizer:
    """Database query optimization helpers"""
    
    @staticmethod
    def create_indexes_sql():
        """
        SQL to create performance indexes
        These are already in schema.sql but this documents them
        """
        return """
        -- Performance indexes for common queries
        
        -- User lookups by email (login)
        CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
        
        -- Hotel searches by city
        CREATE INDEX IF NOT EXISTS idx_hotels_city ON hotels(city);
        
        -- Room availability checks
        CREATE INDEX IF NOT EXISTS idx_rooms_hotel_type ON rooms(hotel_id, room_type_id);
        CREATE INDEX IF NOT EXISTS idx_rooms_status ON rooms(status);
        
        -- Booking queries
        CREATE INDEX IF NOT EXISTS idx_bookings_user ON bookings(user_id);
        CREATE INDEX IF NOT EXISTS idx_bookings_room ON bookings(room_id);
        CREATE INDEX IF NOT EXISTS idx_bookings_dates ON bookings(check_in_date, check_out_date);
        CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
        
        -- Pricing lookups
        CREATE INDEX IF NOT EXISTS idx_prices_lookup ON prices(hotel_id, room_type_id, season_id);
        
        -- Currency conversions
        CREATE INDEX IF NOT EXISTS idx_exchange_active ON exchange_rates(currency_code, is_active);
        """
    
    @staticmethod
    def optimize_query_tips():
        """Tips for query optimization"""
        return """
        Database Query Optimization Tips:
        
        1. Use SELECT specific columns instead of SELECT *
        2. Use LIMIT when you don't need all results
        3. Use indexes on frequently searched columns
        4. Avoid N+1 query problem - use JOINs instead of loops
        5. Use connection pooling
        6. Cache frequently accessed data
        7. Use prepared statements (we do this with parameterized queries)
        8. Avoid LIKE queries with leading wildcards (%text)
        9. Use EXPLAIN to analyze query performance
        10. Regularly update database statistics
        """


class CacheHelper:
    """Simple in-memory cache for frequently accessed data"""
    
    def __init__(self):
        self.cache = {}
        self.cache_times = {}
        self.ttl = 300  # 5 minutes default TTL
    
    def get(self, key):
        """Get cached value if still valid"""
        if key not in self.cache:
            return None
        
        # Check if expired
        if time.time() - self.cache_times[key] > self.ttl:
            del self.cache[key]
            del self.cache_times[key]
            return None
        
        return self.cache[key]
    
    def set(self, key, value, ttl=None):
        """Set cache value"""
        self.cache[key] = value
        self.cache_times[key] = time.time()
        
        if ttl:
            # Could implement per-key TTL if needed
            pass
    
    def clear(self):
        """Clear all cache"""
        self.cache = {}
        self.cache_times = {}
    
    def delete(self, key):
        """Delete specific cache key"""
        if key in self.cache:
            del self.cache[key]
            del self.cache_times[key]


class ResponseOptimizer:
    """Optimize HTTP responses"""
    
    @staticmethod
    def compress_response(response):
        """
        Add compression headers
        In production, use nginx/Apache for actual compression
        """
        # Set cache headers for static content
        if request.path.startswith('/static/'):
            response.headers['Cache-Control'] = 'public, max-age=31536000'  # 1 year
        else:
            response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
        
        return response
    
    @staticmethod
    def add_etag(response):
        """Add ETag for caching validation"""
        # Flask handles this automatically for most responses
        return response


# Create global instances
performance_monitor = PerformanceMonitor()
cache_helper = CacheHelper()
response_optimizer = ResponseOptimizer()