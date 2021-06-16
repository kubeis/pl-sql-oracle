SELECT cursor_type, sql_text FROM v$open_cursor
WHERE user_name = 'HR'
AND cursor_type != 'DICTIONARY LOOKUP CURSOR CACHED'
ORDER BY cursor_type;
/
       