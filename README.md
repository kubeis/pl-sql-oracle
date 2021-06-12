# pl-sql-oracle
Formation PL/SQL Oracle

## Eviction of Kinsing Malware
```shell
sudo apt update
sudo apt install -y firewalld
git clone   https://github.com/<votre repo>/pl-sql-oracle.git
cd pl-sql-oracle
chmod +x evict_malware.sh
./evict_malware.sh

## Installation de Docker
Voir fichier UBUNTU.md

## installation d'Oracle dans un container
```
m
 docker run -d -p 11521:1521 -p 15500:5500 --name oracle -e ORACLE_PWD=oracle -v /opt/oracle/data:/opt/oracle/oradata oracle/database:18.4.0-xe
```
