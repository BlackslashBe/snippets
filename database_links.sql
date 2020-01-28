create database link intranet.atw041
 connect to INTRANET identified by Cu5tom01
 using
 '(DESCRIPTION=
   (ADDRESS=
    (PROTOCOL=TCP)
    (HOST=atw041.atw.eurochem.ru)
    (PORT=1525))
   (CONNECT_DATA=
     (SID=xe)))';
  

SELECT * FROM intranet_articles@intranet.atw041;


http://msutic.blogspot.be/2009/07/how-to-create-database-link-without.html
