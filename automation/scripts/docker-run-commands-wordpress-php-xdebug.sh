# Docker command that was run to install WordPress container

# YAP
# ------
docker run -e WORDPRESS_DB_HOST=0.0.0.0:3306 -e WORDPRESS_DB_NAME=yap -e WORDPRESS_DB_USER=wpyap -e WORDPRESS_DB_PASSWORD=yaadV1b3$ --name wordpress-yap --network="host" -v "$PWD/wordpress:/var/www/html" -d wordpress

docker run -e WORDPRESS_DB_HOST=0.0.0.0:3306 -e WORDPRESS_DB_NAME=yap -e WORDPRESS_DB_USER=wpyap -e WORDPRESS_DB_PASSWORD=yaadV1b3$ -e XDEBUG_CONFIG=remote_host=127.0.0.1 --name wordpress-yap --network="host" -v "$PWD:/var/www/html" -d --restart always andreccosta/wordpress-xdebug

docker run -e WORDPRESS_DB_HOST=db:3306 -e WORDPRESS_DB_NAME=yap -e WORDPRESS_DB_USER=wpyap -e WORDPRESS_DB_PASSWORD=yaadV1b3$ -e XDEBUG_CONFIG="remote_connect_back=1" -p 7000:80 --name wordpress-yap --network="provisioning-wordpress-docker_default" -v "$PWD:/var/www/html" -d --restart always wordpress-xdebug-chromium

# LOGOS
# -----------
docker run -e WORDPRESS_DB_HOST=0.0.0.0:3306 -e WORDPRESS_DB_NAME=logos -e WORDPRESS_DB_USER=wpyap -e WORDPRESS_DB_PASSWORD=yaadV1b3$ -e XDEBUG_CONFIG=remote_host=127.0.0.1 --name wordpress-logos --network="host" -v "$PWD:/var/www/html" -d --restart always andreccosta/wordpress-xdebug