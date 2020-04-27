create database testdb

--Wieviele Fehler haben wir gemacht??

/*
Wie groß ist die DB jetzt? Seit SQL 2016... 16MB(8MB/8MB)
Wie groß ist die Wachstumsrate? .. seit SQL 2016.. 64MB 

--Vor SQL 2016
--5+2 MB---7MB
--Wachstumsrate : 1MB für Daten und 10% für Logfile


*/
use testdb


create table t1 (id int identity, spx char(4100))


insert into t1
select 'XY'
GO 20000

--Dauer 28 Sekunden--> 20 Sek nachdem die Größen optimiert wurden


--versuche Vergrößerungen zu vermeiden


--Was wäre also besser:
--Wie groß soll die sein? Wie groß om 3 Jahren--> 300 GB
--Backup??? sichert keine Leeräume


--

select 156*7-- > 1 Sek



*/