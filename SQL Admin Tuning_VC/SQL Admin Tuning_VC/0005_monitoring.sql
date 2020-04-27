--Monitoring

/*
Taskmanager 
ist es denn der SQL Server
mslaugh.exe teakids.exe

live... Ist es der SQL Server.. Eingrenzen auf DB


Aktivitätsmonitor


DMVs 

select * from sys.dm_os_wait_stats


--ABFRAGE--> Ressourcen finden sind die frei --

--0-----------------100ms--------150ms-- jetzt beginnt die Arbeit

-------------------------------> wait_time  (150)

--                     -------> 50ms signal_time

--Wait_time-signal_time = Wartezeit auf Ressource

--Aufzeichnung..






*/

select * from sysprocesses where spid > 50