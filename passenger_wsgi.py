import importlib.util

import os

import sys

# Add the directory of the application to the system path

sys.path.insert(0, os.path.dirname(__file__))

# Load the application from app.py

spec = importlib.util.spec_from_file_location('wsgi', 'app.py')

wsgi = importlib.util.module_from_spec(spec)

spec.loader.exec_module(wsgi)

# Set the application variable

application = wsgi.app
