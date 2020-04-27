--RAM HDD CPU NETZ (vermeide * Abfragen)
--

HDD

Trenne  Log von Daten
egtl pro DB


tempdb 
	trenne log von Daten
	pro CPU eine Datendatei (max 8)
	alle Dateien sollte automatisch gleich wachsen -T1118
		wenn man manuell vergrößert werden ncht alle glechzetg vergrößert

DBDesign
Datentyp statt char varchar
Partitionierung (Sicht--braucht aber CHECK Contraints)
                (Physikalisch: Dgruppe, F(), Scheme)

Kompression weniger RAM Verbraúch druch geringere HDD Last
wird aber bezahlt mit CPU


Lege die Tabelle t1 auf das schZahl
--Achtung Optionen Designer : Änderungen
--Plan, Messen
-- SCAN   SEEK!
set statistics io on
select * from t1 where id = 10


dbcc showcontig('t1') --200???..hat aber 20000

--der ist veraltet.. 

--sys.dm_db_index_phyiscal_Stats(dbid, objectid, null, null,'detailed')

--Beim verschieben von Tabellen auf Dateigruppen oder Schema: Vorsicht:. Sperren von anderen Tabellen












alles wrd von der HDD 1:1 -> RAM geschoben

create table txy (id int, spx varchar(4100), sp2 varchar(4100) not null)

--Eindeutig ist auch cool












--Abfragen