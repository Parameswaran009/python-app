FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# Copy requirements.txt
COPY requirements.txt .

# Switch to a non-root user
USER nobody

# Install Python and pip
RUN apt-get update && \
    apt-get install -y python3.10 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Switch back to the root user
USER root

# Change the base image to Alpine for the final image
FROM python:3.10.0-alpine3.15

# Set the working directory
WORKDIR /app

# Copy the installed Python dependencies from the Ubuntu image
COPY --from=0 /usr/local/lib/python3.10 /usr/local/lib/python3.10

# Copy other files
COPY . .

# Continue with the rest of the Dockerfile
EXPOSE 5000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=5 \
            CMD curl -f http://localhost:5000/health || exit 1

# Set the entry point for the container
ENTRYPOINT ["python", "./src/app.py"]

