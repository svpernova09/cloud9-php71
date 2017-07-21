#!/bin/bash
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y

sudo apt-get install php7.1-curl php7.1-cli php7.1-dev php7.1-gd php7.1-intl php7.1-mcrypt php7.1-json php7.1-mysql php7.1-opcache php7.1-bcmath php7.1-mbstring php7.1-soap php7.1-xml php7.1-zip -y

sudo mv /etc/apache2/envvars /etc/apache2/envvars.bak
sudo apt-get remove libapache2-mod-php5 -y
sudo apt-get install libapache2-mod-php7.1 -y
sudo cp /etc/apache2/envvars.bak /etc/apache2/envvars

sudo a2dismod php5
sudo a2enmod php7.1

sudo service apache2 restart

# Install MySQL

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password secret"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password secret"
sudo apt-get install -y mysql-server

mysql --user="root" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
sudo service mysql restart

mysql --user="root" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" -e "FLUSH PRIVILEGES;"
mysql --user="root" -e "CREATE DATABASE homestead character set UTF8mb4 collate utf8mb4_bin;"
sudo service mysql restart

# Add Timezone Support To MySQL

sudo mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root mysql
