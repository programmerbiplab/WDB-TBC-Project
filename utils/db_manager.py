"""
Database Connection Manager
Ensures all connections are properly closed
"""
import mysql.connector
from contextlib import contextmanager
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class DatabaseManager:
    """Manages database connections properly"""
    
    def __init__(self, config):
        """Initialize with database configuration"""
        self.config = {
            'host': config.get('MYSQL_HOST'),
            'port': config.get('MYSQL_PORT', 3306),
            'user': config.get('MYSQL_USER'),
            'password': config.get('MYSQL_PASSWORD'),
            'database': config.get('MYSQL_DB'),
            'autocommit': True,
            'pool_name': 'mypool',
            'pool_size': 5,
            'pool_reset_session': True
        }
        
    @contextmanager
    def get_db_connection(self):
        """
        Context manager for database connections.
        Automatically closes connection when done.
        
        Usage:
            with db_manager.get_db_connection() as (conn, cursor):
                cursor.execute("SELECT * FROM users")
                results = cursor.fetchall()
        """
        conn = None
        cursor = None
        try:
            # Create connection
            conn = mysql.connector.connect(**self.config)
            cursor = conn.cursor(dictionary=True)
            
            logger.info("Database connection opened")
            
            # Yield connection and cursor
            yield conn, cursor
            
            # Commit any pending transactions
            if conn.in_transaction:
                conn.commit()
                logger.info("Transaction committed")
                
        except mysql.connector.Error as err:
            # Rollback on error
            if conn and conn.in_transaction:
                conn.rollback()
                logger.error(f"Transaction rolled back: {err}")
            raise
            
        finally:
            # ALWAYS close cursor and connection
            if cursor:
                cursor.close()
                logger.info("Cursor closed")
            if conn and conn.is_connected():
                conn.close()
                logger.info("Database connection closed")
    
    def execute_query(self, query, params=None, fetch_one=False, fetch_all=True):
        """
        Execute a SELECT query safely
        
        Args:
            query: SQL query string
            params: Query parameters (tuple or dict)
            fetch_one: Return single result
            fetch_all: Return all results
        
        Returns:
            Query results or None
        """
        with self.get_db_connection() as (conn, cursor):
            cursor.execute(query, params or ())
            
            if fetch_one:
                return cursor.fetchone()
            elif fetch_all:
                return cursor.fetchall()
            else:
                return None
    
    def execute_update(self, query, params=None):
        """
        Execute an INSERT/UPDATE/DELETE query safely
        
        Args:
            query: SQL query string
            params: Query parameters (tuple or dict)
        
        Returns:
            Number of affected rows, or lastrowid for INSERT
        """
        with self.get_db_connection() as (conn, cursor):
            cursor.execute(query, params or ())
            
            # Return last inserted ID for INSERT queries
            if query.strip().upper().startswith('INSERT'):
                return cursor.lastrowid
            else:
                return cursor.rowcount
    
    def test_connection(self):
        """Test database connection"""
        try:
            with self.get_db_connection() as (conn, cursor):
                cursor.execute("SELECT 1")
                result = cursor.fetchone()
                logger.info("Database connection test: SUCCESS")
                return True
        except Exception as e:
            logger.error(f"Database connection test: FAILED - {e}")
            return False