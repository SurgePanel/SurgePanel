FROM php:8.0-cli

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y \
    libzip-dev \
    && docker-php-ext-install zip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install

EXPOSE 10000

CMD ["php", "-S", "0.0.0.0:10000", "-t", "web"]
