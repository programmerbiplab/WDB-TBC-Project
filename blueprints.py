"""
Blueprint structure for World Hotels application
"""

from flask import Blueprint

# Create blueprints
auth_bp = Blueprint('auth', __name__, template_folder='templates')
booking_bp = Blueprint('booking', __name__, template_folder='templates')
hotels_bp = Blueprint('hotels', __name__, template_folder='templates')
admin_bp = Blueprint('admin', __name__, template_folder='templates/admin', url_prefix='/admin')
main_bp = Blueprint('main', __name__, template_folder='templates')

# Import routes (to be defined in separate files)
from . import auth_routes, booking_routes, hotel_routes, admin_routes, main_routes

# Register routes with blueprints
# This will be implemented in the route files