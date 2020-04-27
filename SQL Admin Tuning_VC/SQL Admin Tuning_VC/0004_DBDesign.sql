--DBSettings

/*
Normalisierung, PK--FK, Beziehung, Datentypen
vs
Physik


Datentypen:


'Otto'

varchar 50    'otto'  4
varchar max geht bs 2 GB
char 50      'otto                              ' 50
char max
nvarchar 50  'Otto'  4  mal 2    8
nchar 50     'Otto                  ' 50 mal 2 100
text ncht mehr verwenden! image veraltet

Datentypenverschwendung wirkt si´ch im RAM aus...


Diagramm der Northwind mit Tabellen Customers, orders order detals und products und employees

Ändert die Ansicht so, dass wir Identity und NULL werte sehen (SPName und DAtentypen)



datetime ms
date
time
smalldatetime s
datetime2 ns
datetimeoffset Zeitzone

--Horror datetime
*/
--langsam aber richtig
select * from orders where year(orderdate) = 1997  --408

select * from orders where orderdate between '1.1.1997' and '31.12.1997' --00:00:00.000   23:59:59.999

--schnell und falsch
select * from orders where orderdate between '1.1.1997' and '31.12.1997 23:59:59.999'  --411

--datetime in INT gespeichert 2 bis 4 ms
*/

datetime in ms auf GebDatum.. macht keinen Sinn+
Lieferdatum auf ms macht keinen Sinn..

Abfragen auf ms sind problematisch, da SQL datetime intern in int speichert


--Dateigruppe BIG
create table t3 (id int) on HOT

--kein Befehl zum Verschieben von Tab auf andere Dgruppen! (ausser...)



und daher der wert nur "ungefähr" ist. HJahresabfragen können falsche Werte bekommen...


use testdb


select * from t1

--Datentypen: int + char(4100) * 20000

==> 80 MB

--pHysik wichtig:




*/

dbcc showcontig('t1')
--- Gescannte Seiten.............................: 20000
--- Mittlere Seitendichte (voll).....................: 50.79%

dbcc showcontig('customers')--- ..>Vorsicht bei großen Tabellen

--was kann man tun, damit die Auslastung einer Seite besser wird..:
--Datentyp.. statt char(4100)--> varchar(4100)---> Software..nö mach ich nicht mehr mit

--Mittel , was die Anwendung nicht merkt

--------Kompression---------------------------------------------

--Zeilenkompression... fixe Datentypen.. Leeräume raus
--Seitenkompression verwendet zuerst Zeilenkompression


--t1 160MB --> viel

--t1 160MB---> 160MB RAM


-->ZIEL: IO senken

--t1 1/x MB  --> 160MB  RAM gleich

--CPU: höher

--IO: geringer



----KOMPRESSION-------------------------------------------
select * into t2 from t1



set statistics io, time on
select * from testdb..t1-- 320MB direkt in RAM
--20000  CPU-Zeit = 297 ms, verstrichene Zeit = 1518 ms.


set statistics io, time on
select * from testdb..t2

--Effekt: CPU steigt. RAM Sinkt, IO Sinkt

--Eigtl ist die Kompresssion gedacht RA zu sparen, damit andere ihn besser verwenden


--Advanced: Partitionierte Sicht-------------------------------------

create table u2018 (id int identity, jahr int, spx char(4100)) 
create table u2019 (id int identity, jahr int, spx char(4100))
create table u2020 (id int identity, jahr int, spx char(4100))



create view Umsatz 
as
select * from u2018
UNION ALL--nicht nach doppelten Zeilen suchen..UNION alleine macht distinct
Select * from u2019
UNION ALL
select * from u2020
GO


--aber ist das jetzt schneller-- PLAN
select * from umsatz where jahr = 2018 --geht alle Tabellen durch

---CHECK Contraints

ALTER TABLE dbo.u2020 ADD CONSTRAINT
	CK_u2020 CHECK ((jahr=2020))

ALTER TABLE dbo.u2019 ADD CONSTRAINT
	CK_u2019 CHECK ((jahr=2019))


select * from umsatz where id = 2018 and jahr = 2018

--Das ist nur dann günstig , wenn sich die Tabellen nicht mehr ändern
--INS UP -- > PK über Jahr und ID und es darf kein Identity mehr vorhanden
--

--wäre auch denkkbar für uJan uFeb 

--WSS_Logging
	ULSpartition0
	..

	ULSpartition31


	---Partionierung!!

	--DGruppen: bis100, bis200, rest bis5000


	------100]-------------------200]--------------
	-- 1               2              3


	create partition function fzahl(int) --max 15000 Bereiche
	as
	RANGE LEFT FOR VALUES (100,200) --Grenzen +1 = Bereiche

	select $partition.fzahl(117) -- >2

	--japp.. BWIN--> 1000HDDs für eine Tabelle
	--kein Problem mit HDDs.. aber mit RAM
	--Amazon 12 MIO TX pro Tag
	--BWIN: 100000/sek


	create partition scheme schZahl
	as
	partition fzahl to (bis100,bis200,rest)
	---                  1       2     3


	create table ptab(id int identity, nummer int, spx char(4100))
	ON schZahl(nummer)



	declare @i as int=1

	while @i< 20000
	begin
		insert into ptab values(@i, 'XX')
		set @i+=1
	end

	--15 Sekunden-. warum schneller


	--was ist schneller?
	set statistics io, time on


	--Was ist ein Batch
	select * from ptab where id = 117
	select * from ptab where nummer = 117

	--SCAN im Plan oder SEEK !!!!!!!! besser
	--SEEK.. Sucheim Telefonbuch einen Neuer, Manuel.. 15 Sek

	--SCAN .. Manuel im Telefonbuch..wie lange dauerts jetzt? Boah lang!!

	--a bis z Suche
	--herauspicken SEEK

	--HEAP ist ein Sauhaufen


	--Partitionierung ist manipulierbar

	-------------2016-----2017---2020----2021

	--------100------------200----------------5000--------
	-- 1             2               3            4

	select * from ptab where nummer = 201

	--Neue Grenze bei 500

	--TAB, F(), scheme
	--nie Tabelle anfassen
	--zuerst scheme anpassen, dann f()

	alter partition scheme schZahl next used bis5000


	select $partition.fzahl(nummer), min(nummer), max(nummer),
		count(*)
	from ptab group by $partition.fzahl(nummer)

	------------100----200-----------------5000-------------------

	alter partition function fzahl() split range (5000)


	select * from ptab where nummer = 5201


	------200---5000---6000---7000-9000---10000


	--Grenze entfernen
	--TAB, F() , Scheme
	--nie Tab...
	--F() !

	alter partition function fzahl() merge range (100) 

	--Cool!!


	--Partitionierung kann auch archivieren 


	select * from ptab where id = 2

	--evtl brauchen wir fast nie den Bereich bis 200--> tabelle archiv

	create table archiv(id int not null, nummer int, spx char(4100)) on bis200


	--ein TSQL Befehl für verschieben von Daten

	alter table ptab switch partition 1 to archiv

	select * from archiv

	select * from ptab order by nummer

	--100MB/Se

	--100000000000MB -->10 Se --> ms

	----2017]---2018]---2019]
	create partition function fdatum(datetme) --max 15000 Bereiche
	as
	RANGE LEFT FOR VALUES ('31.12.2017','') --ms!!!


	--A --> m    n --> r    s --> z
	create partition function fdatum(varchar50)) --max 15000 Bereiche
	as
	RANGE LEFT FOR VALUES ('n','s')

	-------------m]-----------------s

	ma
	mo
	m
	

		create partition scheme schZahl
	as
	partition fzahl to (PRMARY,PRMARY,PRMARY)

	--VLDB --

	select  * from ptab where nummer = 5001








































