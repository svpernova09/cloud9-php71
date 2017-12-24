#!/bin/bash
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y

sudo apt-get install php7.2-curl php7.2-cli php7.2-dev php7.2-gd php7.2-intl php7.2-mcrypt php7.2-json php7.2-mysql php7.2-opcache php7.2-bcmath php7.2-mbstring php7.2-soap php7.2-xml php7.2-zip -y

sudo mv /etc/apache2/envvars /etc/apache2/envvars.bak
sudo apt-get remove libapache2-mod-php5 -y
sudo apt-get install libapache2-mod-php7.2 -y
sudo cp /etc/apache2/envvars.bak /etc/apache2/envvars

sudo a2dismod php5
sudo a2enmod php7.2

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
