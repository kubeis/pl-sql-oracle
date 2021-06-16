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
```
## Installation de Docker
Voir fichier UBUNTU.md

## install portainer
```shell 
docker run -d -p 9000:9000 --name portainer -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer -H unix:///var/run/docker.sock 
```

## Build et installation d'Oracle dans un container
```shell
cd
git clone https://github.com/oracle/docker-images.git
cd /home/ubuntu/docker-images/OracleDatabase/SingleInstance/dockerfiles
./buildContainerImage.sh -v 18.4.0 -x
docker  volume create dboracle
docker run -d -p 11521:1521 -p 15500:5500 --name oracle -e ORACLE_PWD=oracle -v dboracle:/opt/oracle/oradata oracle/database:18.4.0-xe
```


## Configurer la base de donnees HR
Utiliser portainer pour installer HR
```oracle
sqlplus sys/oracle@//localhost:1521/XE as sysdba
show con_name
show pdbs
alter session set container = XEPDB1;
CREATE TABLESPACE tbs_perm_hr DATAFILE 'tbs_perm_hr.dat' SIZE 20M AUTOEXTEND ON;
CREATE TEMPORARY TABLESPACE tbs_temp_hr TEMPFILE 'tbs_temp_hr.dbf' SIZE 5M autoextend ON;
```


# Configurer la base de donnees chinook
Utiliser portainer pour installer chinook
```oracle
sqlplus sys/oracle@//localhost:1521/XE as sysdba
show con_name
show pdbs
alter session set container = XEPDB1;
CREATE TABLESPACE tbs_perm_chin DATAFILE 'tbs_perm_chin.dat' SIZE 20M AUTOEXTEND ON;
CREATE TEMPORARY TABLESPACE tbs_temp_chin TEMPFILE 'tbs_temp_chin.dbf' SIZE 5M autoextend ON;
```

GRANT create session TO chinook;
GRANT create table TO chinook;
GRANT create view TO chinook;
GRANT create any trigger TO chinook;
GRANT create any procedure TO chinook;
GRANT create sequence TO chinook;
GRANT create synonym TO chinook;
GRANT DEBUG CONNECT SESSION to chinook;

## Chinook data
https://github.com/lerocha/chinook-database.git


sqlplus sys/oracle@//localhost:1521/XEPDB1 as sysdba