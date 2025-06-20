FROM python:3.11-slim

WORKDIR /app

# Copy everything from local app/ into /app inside the container
COPY . .

# Install dependencies from /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

#ENV FLASK_APP=app.py
#CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
CMD ["python", "app.py"]
