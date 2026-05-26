# Use a small Python base image
FROM python:3.12-slim

# Create app directory
WORKDIR /app

# Copy dependency file first (better Docker caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Flask app
COPY app.py .

# The container will listen on 5000 by default
EXPOSE 5000

# Run the app
# (We use python app.py; PORT can be overridden by env variable if needed)
CMD ["python", "app.py"]

