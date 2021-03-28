# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vfurmane <vfurmane@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/03/27 20:13:44 by vfurmane          #+#    #+#              #
#    Updated: 2021/03/28 17:28:38 by vfurmane         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL image=ft_server

RUN apt-get update && apt-get install -y \
    php7.3-fpm \
	php7.3-mysqli \
	php7.3-xml \
	php7.3-mbstring \
    nginx \
	default-mysql-server \
	curl \
    xz-utils \
	tar
	
WORKDIR /usr/src/ft_server

# Install phpMyAdmin

ENV PMA_VERSION 5.1.0
ENV PMA_DIR phpMyAdmin-${PMA_VERSION}-all-languages
ENV PMA_URL https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/${PMA_DIR}.tar.xz
ENV PMA_ARCHIVE phpMyAdmin.tar.xz
ENV PMA_PATH /usr/share/

RUN curl -fLsS -o $PMA_ARCHIVE $PMA_URL; \
    mkdir -p $PMA_PATH; \
    tar -xf $PMA_ARCHIVE -C $PMA_PATH; \
	rm -f $PMA_ARCHIVE; \
	mv $PMA_PATH/$PMA_DIR $PMA_PATH/phpmyadmin; \
	chown -R www-data:www-data $PMA_PATH/phpmyadmin;

# Install WordPress

ENV WP_VERSION 5.7
ENV WP_URL https://wordpress.org/wordpress-${WP_VERSION}.tar.gz
ENV WP_ARCHIVE wordpress.tar.gz
ENV WP_PATH /usr/share/

RUN curl -fLsS -o $WP_ARCHIVE $WP_URL; \
    mkdir -p $WP_PATH; \
    tar -xzf $WP_ARCHIVE -C $WP_PATH; \
	rm -f $WP_ARCHIVE; \
	chown -R www-data:www-data $PMA_PATH/wordpress;
COPY srcs/wp-config.php $WP_PATH/wordpress/

# Configure NGINX

ENV NGINX_PATH /etc/nginx

COPY srcs/nginx/sites-available/* $NGINX_PATH/sites-available/
RUN ln -s $NGINX_PATH/sites-available/phpmyadmin $NGINX_PATH/sites-enabled; \
    ln -s $NGINX_PATH/sites-available/wordpress $NGINX_PATH/sites-enabled; \
    rm -rf /var/www/html/*

# End configration

COPY srcs/* ./
ENTRYPOINT ["./start.sh"]

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
