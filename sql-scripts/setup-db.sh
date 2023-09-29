#!/bin/bash

sudo apt-get update
sudo apt-get install mariadb-server -y
mariadb -h terraform-20230928203833529700000001.cwbpnqbobcb0.ap-southeast-2.rds.amazonaws.com -u admin -p < ./schema.sql
mariadb -h terraform-20230928203833529700000001.cwbpnqbobcb0.ap-southeast-2.rds.amazonaws.com -u admin -p < ./insert.sql

sudo systemctl stop mariadb -y
sudo apt-get purge --auto-remove mariadb-server mariadb-client -y
sudo apt-get autoremove -y