#!/usr/bin/env bash

cd $HOME

# Disable Copy On Write
sudo chattr +C /var/lib/mysql/

case $1 in
    mariadb)
        # For MariaDB
        sudo pacman -S mariadb
        sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
        # systemctl enable --now mariadb
        systemctl enable --now mysqld
        sudo mysql_secure_installation
        ;;

    mysql)
        # For MySQL
        paru mysql
        paru mysql-clients
        sudo mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql
        systemctl enable --now mysqld
        sudo mysql_secure_installation
        ;;
    *)
esac

# Workbench
sudo pacman -S mysql-workbench
