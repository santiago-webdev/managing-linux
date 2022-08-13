#!/usr/bin/env bash

# # MariaDB
# sudo pacman -S mariadb
# sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
# systemctl enable --now mysqld
# sudo mysql_secure_installation

# # MySQL
# paru mysql
# paru mysql-clients
# sudo mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql
# systemctl enable --now mysqld
# sudo mysql_secure_installation

# MYSQL running on podman, using a docker image
podman pull mysql
podman run --name=mysqlserver -p 3306:3306 -e=MYSQL_ROOT_PASSWORD=mysqlserver -d mysql

# Workbench
sudo pacman -S mysql-workbench
