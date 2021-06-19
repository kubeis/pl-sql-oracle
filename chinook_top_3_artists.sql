SELECT * FROM
    (SELECT ar.NAME
        , SUM(i.QUANTITY) qte 
    FROM track t, invoiceline i, album al, artist ar
    WHERE i.TRACKID = t.TRACKID
        AND al.ALBUMID = t.ALBUMID
        AND ar.ARTISTID = al.ARTISTID
    GROUP BY ar.NAME
    ORDER BY qte DESC, ar.NAME)
WHERE ROWNUM < 4
/
SELECT  /*+ FIRST_ROWS(3) */
  ar.Name,
  COUNT(*)
FROM InvoiceLine il
LEFT JOIN Track t ON t.TrackId = il.TrackId 
LEFT JOIN Album al ON al.AlbumId = t.AlbumId
LEFT JOIN Artist ar ON ar.ArtistId = al.ArtistId
GROUP BY ar.name
ORDER BY COUNT(*) DESC
FETCH NEXT 3 ROWS ONLY 
/

SELECT ar.NAME
    , COUNT(*) qte 
FROM invoiceline il
    LEFT JOIN track t ON il.TRACKID = t.TRACKID
    LEFT JOIN album al ON t.ALBUMID = al.ALBUMID
    LEFT JOIN artist ar ON al.ARTISTID = ar.ARTISTID
    LEFT JOIN Invoice i ON il.INVOICEID = i.INVOICEID
WHERE TO_CHAR(i.INVOICEDATE, 'YYYY') = '2013'  
GROUP BY ar.NAME
ORDER BY qte DESC
FETCH NEXT 3 ROWS ONLY
;
