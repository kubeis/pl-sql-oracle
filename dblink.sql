CREATE PUBLIC DATABASE LINK dblink CONNECT TO TPCDS identified BY p4ssw0rd 
using '(DESCRIPTION=
                (ADDRESS=(PROTOCOL=TCP)(HOST=137.74.61.84)(PORT=1521))
                (CONNECT_DATA=(SERVICE_NAME=XEPDB1))
            )';