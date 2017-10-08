/*START DATABASE*/

/*Create tablespaces*/
create tablespace gofar_travel datafile ',tempDataFile01.dbf' size 500m,'tempDataFile02.dbf' size 300m,'tempDataFile03.dbf' size 224m
autoextend on maxsize 1024m
extent management local
segment space management auto
online;

create tablespace test_purposes datafile ',tempDataFile04.dbf' size 500m
autoextend on maxsize 500m
extent management local
segment space management auto
online;

create tablespace test_purposes datafile ',tempDataFile04.dbf' size 500m
autoextend on maxsize 500m
extent management local
segment space management auto
online;

create tablespace Undo datafile ',tempDataFile05.dbf' size 5m
autoextend on maxsize 5m
extent management local
segment space management auto
online;



SELECT TABLESPACE_NAME "TABLESPACE",
   INITIAL_EXTENT "INITIAL_EXT",
   NEXT_EXTENT "NEXT_EXT",
   MIN_EXTENTS "MIN_EXT",
   MAX_EXTENTS "MAX_EXT",
   PCT_INCREASE
   FROM DBA_TABLESPACES; 
