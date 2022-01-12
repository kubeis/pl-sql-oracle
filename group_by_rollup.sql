-- group by roll up

DROP TABLE dimension_tab;
CREATE TABLE dimension_tab (
  fact_1_id   NUMBER NOT NULL,
  fact_2_id   NUMBER NOT NULL,
  fact_3_id   NUMBER NOT NULL,
  fact_4_id   NUMBER NOT NULL,
  sales_value NUMBER(10,2) NOT NULL
);
INSERT INTO dimension_tab
SELECT TRUNC(DBMS_RANDOM.value(low => 1, high => 3)) AS fact_1_id,
       TRUNC(DBMS_RANDOM.value(low => 1, high => 6)) AS fact_2_id,
       TRUNC(DBMS_RANDOM.value(low => 1, high => 11)) AS fact_3_id,
       TRUNC(DBMS_RANDOM.value(low => 1, high => 11)) AS fact_4_id,
       ROUND(DBMS_RANDOM.value(low => 1, high => 100), 2) AS sales_value
FROM   dual
CONNECT BY level <= 1000;
COMMIT;

SELECT SUM(sales_value) AS sales_value
FROM   dimension_tab;

SELECT fact_1_id,
       COUNT(*) AS num_rows,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY fact_1_id
ORDER BY fact_1_id;


SELECT fact_1_id,
       fact_2_id,
       COUNT(*) AS num_rows,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY fact_1_id, fact_2_id
ORDER BY fact_1_id, fact_2_id;


SELECT fact_1_id,
       fact_2_id,
       fact_3_id,
       COUNT(*) AS num_rows,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY fact_1_id, fact_2_id, fact_3_id
ORDER BY fact_1_id, fact_2_id, fact_3_id;

SELECT fact_1_id,
       fact_2_id,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY ROLLUP (fact_1_id, fact_2_id)
ORDER BY fact_1_id, fact_2_id;




