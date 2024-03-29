# Use an official PHP Apache image as the base
FROM php:8.0-apache

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the application files to the container
COPY . /var/www/html/

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    unzip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions required by your application
RUN docker-php-ext-install pdo pdo_mysql

# Install application dependencies using Composer
RUN composer install --no-interaction --optimize-autoloader

# Set up Apache virtual host
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Generate application key
RUN php artisan key:generate

# Run migrations
RUN php artisan migrate

# Install Passport
RUN php artisan passport:install

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/storage

# Start Apache server
CMD ["apache2-foreground"]
