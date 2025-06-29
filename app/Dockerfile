# Use a Python base image
FROM python:3.13-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app code
COPY . .

# Set the environment variable for the collector endpoint
# The endpoint is injected by the OTel Operator at runtime, but it's possible to set a default here
ENV OTEL_EXPORTER_OTLP_ENDPOINT="http://otel-collector-opentelemetry-collector.default.svc.cluster.local:4317"

# Set opentelemetry-instrument as the container's entrypoint
ENTRYPOINT ["opentelemetry-instrument"]
CMD ["python", "app.py"]