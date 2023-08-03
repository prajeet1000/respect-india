# Base image
FROM ubuntu

# Set debconf to automatically select Indian geographic area
RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections \
    && echo "tzdata tzdata/Areas select Indian" | debconf-set-selections \
    && echo "tzdata tzdata/Zones/Indian select Kolkata" | debconf-set-selections

# Install Git, Apache, and Python
RUN apt-get update && apt-get install -y git apache2 python3 python3-pip
RUN apt update && apt install -y php php-cli php-mbstring composer && apt update && apt install -y nodejs npm


# enable apache header permission and configuration
RUN a2enmod headers
RUN echo "ServerTokens Prod" >> /etc/apache2/apache2.conf \
    && echo "ServerSignature Off" >> /etc/apache2/apache2.conf \
    && echo "Header always unset X-Powered-By" >> /etc/apache2/apache2.conf \
    && echo "Header always append X-Powered-By Prajeet-devops" >> /etc/apache2/apache2.conf

RUN echo "Header always set X-Frame-Options SAMEORIGIN" >> /etc/apache2/apache2.conf \
    && echo "Header always set X-Content-Type-Options nosniff" >> /etc/apache2/apache2.conf \
    && echo "Header always set X-XSS-Protection '1; mode=block'" >> /etc/apache2/apache2.conf \
    && echo "Header always set Cache-Control 'no-store'" >> /etc/apache2/apache2.conf \
    && echo "Header always set Strict-Transport-Security 'max-age=31536000; includeSubDomains; preload'" >> /etc/apache2/apache2.conf \
    && echo "Header always set Access-Control-Allow-Origin '*'" >> /etc/apache2/apache2.conf \
    && echo "Header always set Content-Security-Policy \"default-src 'self'\"" >> /etc/apache2/apache2.conf
RUN sed -i '/<VirtualHost \*:443>/a SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1' /etc/apache2/sites-available/default-ssl.conf \
    && sed -i '/<VirtualHost \*:443>/a SSLProtocol +TLSv1.2 +TLSv1.3' /etc/apache2/sites-available/default-ssl.conf

     # Remove X-Powered-By header
RUN echo "Header unset X-Powered-By" >> /etc/apache2/conf-available/docker-php.conf \
    && a2enconf docker-php




# Clone the code from GitHub repository
RUN git clone https://github.com/prajeet1000/respect-india.git

# Copy the code to the Apache web root
RUN cp -r respect-india/* /var/www/html/

# Expose ports for Apache and Python backend
ENV PORT 80
EXPOSE 80

# Start Apache and Python backend when the container starts
CMD ["apache2ctl", "-D", "DONTFOREGROUND"]

