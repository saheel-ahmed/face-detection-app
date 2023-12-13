# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Clean up package cache
RUN rm -rf /var/lib/apt/lists/*

# Remove existing dlib directory if it exists
RUN rm -rf /app/dlib

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libboost-all-dev \
    libopenblas-dev \
    liblapack-dev \
    libjpeg-dev \
    git

# Upgrade pip and setuptools
RUN pip install --upgrade pip setuptools


# Clone the dlib repository
RUN git clone -b v19.21 --single-branch https://github.com/davisking/dlib.git

# Navigate to the build directory
WORKDIR /app/dlib/build

# Build and install dlib
RUN cmake .. -DUSE_OPENBLAS=OFF && \
    cmake --build . && \
    make install && \
    cd .. && \
    python setup.py install

# Set OpenBLAS num_threads to 1
ENV OPENBLAS_NUM_THREADS 1


# Install Flask and scikit-image
RUN pip install --no-cache-dir Flask requests scikit-image

# Make port 3223 available to the world outside this container
EXPOSE 3223

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "/app/app.py"]
