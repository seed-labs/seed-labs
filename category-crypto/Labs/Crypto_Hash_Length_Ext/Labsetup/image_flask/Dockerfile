FROM handsonsecurity/seed-server:flask

# Copy the Flask app to the image
COPY app  /app
COPY bashrc /root/.bashrc

WORKDIR /app

CMD FLASK_APP=/app/www flask run --host 0.0.0.0 --port 80
