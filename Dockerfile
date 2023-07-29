# Base image
FROM ubuntu

# Set debconf to automatically select Indian geographic area
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections \
    && echo "tzdata tzdata/Areas select Indian" | debconf-set-selections \
    && echo "tzdata tzdata/Zones/Indian select Kolkata" | debconf-set-selections

# Install Git, Apache, and Python
RUN apt-get update && apt-get install -y git apache2 python3 python3-pip
RUN apt update && apt install -y php php-cli php-mbstring composer && apt update && apt install -y nodejs npm

# Clone the code from GitHub repository
RUN git clone https://github.com/prajeet1000/respect-india.git

# Copy the code to the Apache web root
RUN cp -r respect-india/* /var/www/html/

# Expose ports for Apache and Python backend
EXPOSE 80
EXPOSE 8000

# Start Apache and Python backend when the container starts
RUN service apache2 start 
