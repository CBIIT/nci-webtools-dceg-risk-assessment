# Use an official Python runtime as a parent image
FROM python:3.6

# Set environment variables
ENV APP_NAME=mrisktool

# Install system packages
RUN apt-get update && apt-get install -y sudo

# Set up Python environment
RUN pip install flask==1.1

# Create and set working directory
WORKDIR /usr/src/app

# Copy the rest of your project files into the container
COPY . .

# Expose the port your Flask app runs on
EXPOSE 8030

# Command to run your Flask application
CMD ["python", "mratRest.py"]