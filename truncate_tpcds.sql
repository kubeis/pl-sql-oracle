TRUNCATE TABLE CALL_CENTER;
TRUNCATE TABLE 	CATALOG_PAGE;	
TRUNCATE TABLE 	CATALOG_returns;
TRUNCATE TABLE 	CATALOG_SALES;	
TRUNCATE TABLE 	CUSTOMER;
TRUNCATE TABLE 	CUSTOMER_ADDRESS;		
TRUNCATE TABLE 	CUSTOMER_DEMOGRAPHICS;	
TRUNCATE TABLE 	DATE_DIM;	
TRUNCATE TABLE 	DBGEN_VERSION;	
TRUNCATE TABLE 	HOUSEHOLD_DEMOGRAPHICS;	
TRUNCATE TABLE 	INCOME_BAND;
TRUNCATE TABLE 	INVENTORY;	
TRUNCATE TABLE 	ITEM;	
TRUNCATE TABLE 	PROMOTION;	
TRUNCATE TABLE 	REASON;	
TRUNCATE TABLE 	SHIP_MODE;	
TRUNCATE TABLE 	STORE;		
TRUNCATE TABLE 	STORE_returns;	
TRUNCATE TABLE 	STORE_SALES;	
TRUNCATE TABLE 	TIME_DIM;	
TRUNCATE TABLE 	WAREHOUSE;		
TRUNCATE TABLE 	WEB_PAGE;	
TRUNCATE TABLE 	WEB_returns;		
TRUNCATE TABLE 	WEB_SALES;	
TRUNCATE TABLE 	WEB_SITE;	



CREATE OR REPLACE PROCEDURE trnct_table (i_table_name IN VARCHAR2)
IS
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || i_table_name;

   DBMS_OUTPUT.put_line (
      'Table ' || i_table_name || ' truncated successfully.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Truncate table failed.');
END;

BEGIN
trnct_table('CALL_CENTER');
trnct_table('CATALOG_PAGE');
trnct_table('CATALOG_returns');
trnct_table('CATALOG_SALES');
trnct_table('CUSTOMER');
trnct_table('CUSTOMER_ADDRESS');
trnct_table('CUSTOMER_DEMOGRAPHICS');
trnct_table('DATE_DIM');
trnct_table('DBGEN_VERSION');
trnct_table('HOUSEHOLD_DEMOGRAPHICS');
trnct_table('INCOME_BAND');
trnct_table('INVENTORY');
trnct_table('ITEM');
trnct_table('PROMOTION');
trnct_table('REASON');
trnct_table('SHIP_MODE');
trnct_table('STORE');
trnct_table('STORE_returns');
trnct_table('STORE_SALES');
trnct_table('TIME_DIM');
trnct_table('WAREHOUSE');
trnct_table('WEB_PAGE');
trnct_table('WEB_returns');
trnct_table('WEB_SALES');
trnct_table('WEB_SITE');	
END;	
TRUNCATE TABLE 	CATALOG_returns;
TRUNCATE TABLE 	CATALOG_SALES;	
TRUNCATE TABLE 	CUSTOMER;
TRUNCATE TABLE 	CUSTOMER_ADDRESS;		
TRUNCATE TABLE 	CUSTOMER_DEMOGRAPHICS;	
TRUNCATE TABLE 	DATE_DIM;	
TRUNCATE TABLE 	DBGEN_VERSION;	
TRUNCATE TABLE 	HOUSEHOLD_DEMOGRAPHICS;	
TRUNCATE TABLE 	INCOME_BAND;
TRUNCATE TABLE 	INVENTORY;	
TRUNCATE TABLE 	ITEM;	
TRUNCATE TABLE 	PROMOTION;	
TRUNCATE TABLE 	REASON;	
TRUNCATE TABLE 	SHIP_MODE;	
TRUNCATE TABLE 	STORE;		
TRUNCATE TABLE 	STORE_returns;	
TRUNCATE TABLE 	STORE_SALES;	
TRUNCATE TABLE 	TIME_DIM;	
TRUNCATE TABLE 	WAREHOUSE;		
TRUNCATE TABLE 	WEB_PAGE;	
TRUNCATE TABLE 	WEB_returns;		
TRUNCATE TABLE 	WEB_SALES;	
TRUNCATE TABLE 	WEB_SITE;
END;
/



alter user TPCDS quota 2048M on USERS;