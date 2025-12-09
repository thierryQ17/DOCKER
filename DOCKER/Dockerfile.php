FROM php:8.2-fpm

# Installation des dépendances pour GD
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    git \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Configuration et installation de GD avec support PNG, JPEG, WEBP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd

# Installation des extensions PHP nécessaires
RUN docker-php-ext-install mysqli pdo pdo_mysql

WORKDIR /var/www/html

# Copier le code de l'application
COPY www/ /var/www/html/

# Définir les permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm"]
