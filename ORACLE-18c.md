# Install oracle 18c
```shell
sudo dnf -y update
#sudo dnf -y install epel-release
#sudo dnf -y install terminator
curl -o oracle-database-preinstall-18c-1.0-1.e17.x86_64.rpm https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm
sudo yum -y localinstall oracle-database-preinstall-18c-1.0-1.e17.x86_64.rpm
curl -o compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
sudo yum -y localinstall compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
sudo yum -y localinstall oracle-database-preinstall-18c-1.0-1.e17.x86_64.rpm
curl -o compat-libcap1-1.10-7.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/compat-libcap1-1.10-7.el7.x86_64.rpm
sudo yum -y localinstall compat-libcap1-1.10-7.el7.x86_64.rpm
sudo yum -y localinstall oracle-database-preinstall-18c-1.0-1.e17.x86_64.rpm
curl -OL https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-18c-1.0-1.x86_64.rpm
sudo yum  -y install java-11-openjdk-devel
sudo yum  -y install libnsl
sudo yum -y localinstall oracle-database-xe-18c-1.0-1.x86_64.rpm
sudo /etc/init.d/oracle-xe-18c configure
```

## check firewalld and start command
```shell
sudo firewall-cmd --state   # check firewalld 
sudo systemctl stop firewalld # stop it
sudo firewall-cmd --state   # check 
netstat -nlp  # find port 1521 
sudo /etc/init.d/oracle-xe-18c start  # how to start oracle cluster
```

## Switch to PDB in sqlplus
```shell
alter session set container = XEPDB1;
# debug sqlplus 
strace sqlplus tpcds@p4ssw0rd@XEPDB1 
```

## Remove quota for a user
```shell
ALTER USER <your user> quota unlimited on USERS;
```

## Increase Temp tablespace 
`ALTER TABLESPACE TEMP ADD TEMPFILE '+DATAC1' SIZE 10G AUTOEXTEND ON NEXT 1G MAXSIZE 32767M;`

## check tablespaces size
```sql92
set echo off feedback off verify off pages 75
col tablespace_name format a20 head 'Tablespace Name'
col total format 999,999,999,999 head 'Total(KB)'
col used format 999,999,999,999 head 'Used(KB)'
col free format 999,999,999,999 head 'Free(KB)'
col pct format 999 head 'Percent|Used'
break on report
compute sum of total on report
compute sum of used on report
compute sum of free on report
select    tbs.tablespace_name,
tot.bytes/1024 total,
tot.bytes/1024-sum(nvl(fre.bytes,0))/1024 used,
sum(nvl(fre.bytes,0))/1024 free,
(1-sum(nvl(fre.bytes,0))/tot.bytes)*100 pct
from      dba_free_space fre,
(select  tablespace_name, sum(bytes) bytes
from      dba_data_files
group by tablespace_name) tot,
dba_tablespaces tbs
where   tot.tablespace_name    = tbs.tablespace_name
and        fre.tablespace_name(+) = tbs.tablespace_name
group by tbs.tablespace_name, tot.bytes/1024, tot.bytes
union
select    tsh.tablespace_name,
dtf.bytes/1024 total,
sum(nvl(tsh.bytes_used,0))/1024 used,
sum(nvl(tsh.bytes_free,0))/1024 free,
(1-sum(nvl(tsh.bytes_free,0))/dtf.bytes)*100 pct
from             v$temp_space_header tsh,
(select tablespace_name, sum(bytes) bytes
from dba_temp_files
group by tablespace_name) dtf
where   dtf.tablespace_name     = tsh.tablespace_name(+)
group by tsh.tablespace_name, dtf.bytes/1024, dtf.bytes
order by 1
/
```