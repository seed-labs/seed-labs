FROM handsonsecurity/seed-server:flask-arm


# Copy the Flask app to the image
COPY app  /app
COPY bashrc /root/.bashrc

RUN pip3 install flask --upgrade

WORKDIR /app

CMD FLASK_APP=/app/www flask run --host 0.0.0.0 --port 80
