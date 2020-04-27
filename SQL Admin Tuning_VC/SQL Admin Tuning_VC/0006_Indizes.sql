--Indizes

--Planverhalten
--Seek oder Scan..ohne where SCAN.. Table SCAN.. CL IX SCAN
--
--PK wird immer als CL IX eindeutig gesetzt.. muss aber gar nicht sein
--Eindeutigkeit ist einzoge Bedingung , daher ist PK auf ID oft Verschwendung

select * into ku1 from ku

--Kopie in ku1

alter table ku1 add id int identity


--Was ist ku1? Heap oder CL IX--> HEAP

select id from ku1 where id = 100
-->      Table  SCAN-- CXPACKET 

set statistics io, time on
--60052  250ms  47ms

--Wieviele Seiten besitzt diese tabelle

dbcc showcontig('ku1') --47414... der ist veraltet

select * from sys.dm_db_index_physical_stats(db_id(), object_id('ku'), NULL, NULL, 'detailed')

-->forward_record_Counts  12638 gibts nur bei HEAPS

--versaut die Tabelle
--Die ID muss zum Datensatz wieder rein (Seite)--> CL IX

--Tipp: Jede Tabelle sollte auf forward_record_counts geprüft werden
--tabelle mit CL IX haben nie frc, warum also HEaps haben;-)


select * into ku2 from ku1

alter table ku add id int identity


--CL IX: orderdate
select id from ku1 where id = 100 --table SCAN

--NIX_ID --3 Seiten

--IX SEEK auf ID muss aber im Hreap nachschauen (Lookup)
select id, city from ku1 where id < 100


--besser, wenn man die Spakte in den IX mitaufnimmt
--NIX_ID_CITY  zusammmengesetzter IX
select id, city from ku1 where id < 100 --reinen Seek

--Plan-- Lookup(Heap)
select id, city,country, freight from ku1 where id = 100

--Idee Countr ynoch in IX dazunehmen: 
--schlechte Idee, da zusm. IX nur max 16 Spalten haben können

--IX mit eing Spalten
select id, city,country, freight from ku1 where id = 100


--was wenn
select id, city,country, freight from ku1 where id = 100 or unitsinstock < 2




select country, sum(unitprice*quantity) from ku1
where freight < 0.2
group by country


--Sicht ist eigtl was?
--View: benannte Abfrage, hat keine Daten


--Indizierte 

select productname, count(*) from ku1
group by productname


create view vdemo
as
select productname, count(*) as Anzahl from ku1
group by productname

select * from vdemo

alter view vdemo with schemabinding -- exakt 
as
select productname, count_big(*) as Anzahl from dbo.ku1
group by productname


--Super--es muss count_big

--Anzahl der Bestellungen pro Land--weltweit  -- 1000 Mrd DS
--Sicht würde wieviele Seiten brauchen: 2!--> 200 Länder





select * into kux from ku1

select * into kuy from ku1


select top 3 * from kux


--Ideal: where , Aggr

---
--NIX_Cy_IN_CIDupqu
set statistics io, time on
select customerid, sum(unitprice*quantity) from kux
where country = 'USA'
group by customerid

CREATE NONCLUSTERED INDEX nix1
ON [dbo].[kux] ([Country])
INCLUDE ([CustomerID],[UnitPrice],[Quantity])

-- 992--- 30ms 


select customerid, sum(unitprice*quantity) from kuy
where country = 'USA'
group by customerid
--wat???   16ms 4   keine Seiten???


--immer schneller
select customerid, sum(unitprice*quantity) from kuy
where freight < 1
group by customerid


--??  kux ist 420MB und kuy ist nur 4,2 MB???
--stimmt das oder nicht ? Stimmt, dann muss das Ding aber komprimiert  sein
--Seitenkompression würde aer nur auf 119 MB kommen
--> von 370MB auf 3,0 MB----> auch im RAM

--PowerPivot=Columnstore

--was tut allen IX weh!!! I UP D



USE [Northwind]

GO


--.der Columnstore frägt nach keinerlei Spalten
CREATE CLUSTERED COLUMNSTORE INDEX [CSIX] ON [dbo].[kuy] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
GO





















