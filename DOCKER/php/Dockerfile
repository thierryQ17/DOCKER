FROM php:8.2-fpm

# Installation des extensions PHP nécessaires
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Installation d'outils supplémentaires
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Copier le code de l'application (à copier depuis le contexte de build)

# Définir les permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm"]
