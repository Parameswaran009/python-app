# Use Python 3.10 with Alpine as the base image
FROM python:3.10.0-alpine3.15

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apk update && apk add --no-cache curl

# Install pip
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Copy requirements.txt
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy other files
COPY . .

# Expose port 5000
EXPOSE 5000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=5 \
            CMD curl -f http://localhost:5000/health || exit 1

# Set the entry point for the container
ENTRYPOINT ["python", "./src/app.py"]

