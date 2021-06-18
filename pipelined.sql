CREATE OR REPLACE TYPE strings_t IS TABLE OF VARCHAR2 (100);
/
CREATE OR REPLACE FUNCTION strings 
return strings_t
IS 
  l_strings strings_t := strings_t ('abc');  
BEGIN 
   RETURN l_strings; 
END;
/
SELECT column_value mystring FROM TABLE (strings ());


CREATE OR REPLACE FUNCTION strings_pl 
return strings_t
pipelined
is
BEGIN 
  PIPE ROW('abc');
  PIPE ROW('def');
  RETURN;
END;
/
SELECT column_value mystring FROM TABLE (strings_pl ());
/

CREATE TABLE stocks
(
   ticker        VARCHAR2 (20),
   trade_date    DATE,
   open_price    NUMBER,
   close_price   NUMBER
)
/

CREATE TABLE tickers
(
   ticker      VARCHAR2 (20),
   pricedate   DATE,
   pricetype   VARCHAR2 (1),
   price       NUMBER
)
/

CREATE TYPE ticker_ot AS OBJECT
(
   ticker VARCHAR2 (20),
   pricedate DATE,
   pricetype VARCHAR2 (1),
   price NUMBER
);
/

CREATE TYPE tickers_nt AS TABLE OF ticker_ot;
/