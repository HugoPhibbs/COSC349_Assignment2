#!/bin/bash

# Change this on redeploys of the RDS DB
export DB_HOST=terraform-20230930001142041200000005.cwbpnqbobcb0.ap-southeast-2.rds.amazonaws.com

# MySQL is surprisingly hard to get via apt-get, so use MariaDB instead - its compatible with MySQL.
sudo apt-get update
sudo apt-get install mariadb-server -y
mariadb -h $DB_HOST -u admin -p < ./schema.sql
mariadb -h $DB_HOST -u admin -p < ./insert.sql

sudo systemctl stop mariadb -y
sudo apt-get purge --auto-remove mariadb-server mariadb-client -y
sudo apt-get autoremove -y