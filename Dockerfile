# # Use an official PHP image with Apache as the base image.
# FROM php:8.2-apache

# # Set environment variables.
# ENV ACCEPT_EULA=Y

# # Install system dependencies.
# RUN apt-get update && apt-get install -y \
#     libpng-dev \
#     libjpeg-dev \
#     libfreetype6-dev \
#     zip \
#     unzip \
#     git \
#     && rm -rf /var/lib/apt/lists/*

# # Enable Apache modules required for Laravel.
# RUN a2enmod rewrite

# # Set the Apache document root
# ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# # Update the default Apache site configuration
# COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# # Install PHP extensions.
# RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
#     && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql

# # Install Composer globally.
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# # Create a directory for your Laravel application.
# WORKDIR /var/www/html

# # Copy the Laravel application files into the container.
# COPY . .

# # Install Laravel dependencies using Composer.
# RUN composer install --no-interaction --optimize-autoloader

# # Set permissions for Laravel.
# RUN chown -R www-data:www-data storage bootstrap/cache

# RUN chmod -R 765 /var/www/html

# RUN chown -R $USER:$USER /var/www/html

# RUN DocumentRoot /var/www/html


# # Expose port 80 for Apache.
# EXPOSE 80

# # Start Apache web server.
# CMD ["apache2-foreground"]



# Use an official PHP image with Apache as the base image.
# FROM php:8.2-apache
FROM php:8.2-fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 80
CMD ["php-fpm"]

