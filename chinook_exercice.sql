SELECT BillingCountry, COUNT(Invoiceid) AS invoices_number
FROM Invoice
GROUP BY BillingCountry
ORDER BY 2 DESC
/
SELECT /* +INDEX(Invoices(invoiceid)) */  BillingCountry, COUNT(Invoiceid) AS invoices_number
FROM Invoice
GROUP BY BillingCountry
ORDER BY 2 DESC
/

analyze table invoice compute statistics;
/

CREATE INDEX idx_billingcountry ON invoice(BillingCountry);
/

SELECT
  FirstName || ' ' || LastName AS Name,
  CustomerId,
  Country
FROM Customer
WHERE Country <> 'USA';
/
SELECT t.Name, count(t.Name) AS TEST
FROM Track t
JOIN InvoiceLine l on l.TrackId =t.Trackid
group by t.Name
order by test desc
FETCH FIRST 5 ROWS ONLY;
/

SELECT /*+ FIRST_ROWS(5) */ t.Name, count(t.Name) AS TEST
FROM Track t
JOIN InvoiceLine l on l.TrackId =t.Trackid
group by t.Name
order by test desc;
/

SELECT p.Name, COUNT(pt.TrackID) as Number_of_tracks
FROM Playlist p JOIN playlisttrack pt
using (playlistid)
GROUP BY p.name;
/

select * from employee;
/

SELECT lastname, employeeid, reportsto , LEVEL  from employee 
start with reportsto is null
connect by prior employeeid = reportsto;



SELECT lastname, employeeid from employee
start with reportsto is null
connect by prior employeeid = reportsto;
/
select * from employee;
/
select employeeid from employee;





