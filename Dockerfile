# Dockerfile

# Fix 1: Use ECR Public Gallery for the base image to avoid rate limits.
FROM public.ecr.aws/docker/library/python:3.10-slim

WORKDIR /app

# Copy requirements before copying the rest of the application.
COPY requirements.txt .

# Fix 2: Install system build tools (build-essential) necessary for many Python packages 
# (like Flask dependencies) in minimal OS images.
RUN apt-get update && \
    apt-get install -y build-essential && \
    pip install --no-cache-dir -r requirements.txt && \
    # Clean up and remove build-essential to reduce the final image size
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]