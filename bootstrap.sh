#!/bin/bash
bootstrap(){
if [ ! -x "$0" ]; then
    chmod +x "$0"
    exec "$0" "$@"  # Restart script with execution permissions
fi

# Define directories
DOCKER_DIR="./docker"
NGINX_DIR="./nginx"

# Prompt for hostname if nginx config doesn't exist
if [ ! -f "$NGINX_DIR/default.conf" ]; then
    echo "Enter the hostname (e.g., ci4.local) and update it as the base URL in your CI4 Application:"
    read -r APP_HOST_NAME

    # Ensure nginx directory exists
    mkdir -p "$NGINX_DIR"

    # Write nginx default.conf
    cat <<EOF > "$NGINX_DIR/default.conf"
server {
    listen 80;
    server_name $APP_HOST_NAME;
    root /var/www/html/public;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass ci4-php:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
    echo "✅ nginx/default.conf created successfully with server_name: $APP_HOST_NAME"
else
    echo "⚡ nginx/default.conf already exists. Skipping..."
fi

# Create Dockerfile if it doesn't exist
if [ ! -f "$DOCKER_DIR/Dockerfile" ]; then
    mkdir -p "$DOCKER_DIR"

    cat <<EOF > "$DOCKER_DIR/Dockerfile"
FROM php:8.2-fpm-alpine

# Install required system dependencies
RUN apk update && apk add --no-cache \
    zip unzip git curl icu-dev icu-data-full \
    libpng-dev libjpeg-turbo-dev freetype-dev \
    oniguruma-dev

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring gd intl mysqli

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application source code
COPY ./src /var/www/html

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www/html
RUN git config --global --add safe.directory /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
EOF
    echo "✅ Dockerfile created successfully in $DOCKER_DIR."
else
    echo "⚡ Dockerfile already exists. Skipping..."
fi

# Create docker-compose.yml if it doesn't exist
if [ ! -f "docker-compose.yml" ]; then
    cat <<EOF > docker-compose.yml
version: '3.8'

services:
  ci4-php:
    build:
      context: .
      dockerfile: docker/Dockerfile
    container_name: ci4-php
    volumes:
      - ./src:/var/www/html:delegated
    networks:
      - ci4-network
    depends_on:
      - mariadb

  nginx:
    image: nginx:latest
    container_name: ci4-nginx
    ports:
      - "8081:80"
    volumes:
      - ./src:/var/www/html
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    networks:
      - ci4-network
    depends_on:
      - ci4-php

  mariadb:
    image: mariadb:latest
    container_name: ci4-mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: ci4db
      MYSQL_USER: ci4user
      MYSQL_PASSWORD: ci4password
    volumes:
      - mariadb_data:/var/lib/mysql
    networks:
      - ci4-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: ci4-phpmyadmin
    restart: always
    ports:
      - "8080:80"
    environment:
      PMA_HOST: mariadb
      MYSQL_ROOT_PASSWORD: root
    networks:
      - ci4-network
    depends_on:
      - mariadb

networks:
  ci4-network:

volumes:
  mariadb_data:

EOF
    echo "✅ docker-compose.yml created successfully!"
else
    echo "⚡ docker-compose.yml already exists. Skipping..."
fi

echo "🚀 Project is already bootstrapped! Please use docker/sdk up  to start the services"
}
