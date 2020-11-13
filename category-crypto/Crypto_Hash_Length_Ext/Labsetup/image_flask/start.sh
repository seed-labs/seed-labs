#!/bin/bash

# Start the Flask webserver
cd /app && FLASK_APP=/app/www flask run --host 0.0.0.0 --port 80
tail -f /dev/null
