FROM richarvey/nginx-php-fpm:3.1.2
RUN apk add -U --no-cache nghttp2-dev nodejs npm unzip tzdata
RUN docker-php-ext-install bcmath
COPY . /var/www/html

ENV SKIP_COMPOSER 0
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Laravel config
ENV APP_KEY base64:B6l/H5fSpR60Y+MpcKP22Z1B4Us7adD+jJrln8XOcpQ=
ENV APP_ENV production
ENV APP_DEBUG true
ENV LOG_CHANNEL stderr
ENV APP_URL 0.0.0.0

# Allow composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV NODEJS_ALLOW_SUPERUSER 1
ENV NPM_ALLOW_SUPERUSER 1
ENV YARN_ALLOW_SUPERUSER 1
ENV NPX_ALLOW_SUPERUSER 1
RUN chmod 777 ./*
RUN npm install && composer install
RUN php artisan db:wipe --drop-types --force 
RUN php artisan migrate:install
#RUN export APP_KEY=$( php artisan:key generate --show )
#RUN php artisan migrate:fresh --force
RUN php artisan db:seed --force
RUN php artisan filament:assets && npm run build
EXPOSE 81
