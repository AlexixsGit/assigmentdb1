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
   
SELECT * FROM USER_TABLESPACES;

/*USER DBA and assign it to the tablespace called "gofar_travel"*/
CREATE USER DBA_USER 
IDENTIFIED BY dba_user
DEFAULT TABLESPACE gofar_travel 
QUOTA UNLIMITED  ON gofar_travel;

/*Assign dba role and permissions to connect to the user just created*/
GRANT DBA TO DBA_USER;
GRANT CONNECT TO DBA_USER;

/*Profiles*/
CREATE PROFILE manager LIMIT
PASSWORD_LIFE_TIME 40
SESSIONS_PER_USER 1
IDLE_TIME 15
FAILED_LOGIN_ATTEMPTS 4;

CREATE PROFILE finance LIMIT
PASSWORD_LIFE_TIME 15
SESSIONS_PER_USER 1
IDLE_TIME 3
FAILED_LOGIN_ATTEMPTS 2;

CREATE PROFILE development LIMIT
PASSWORD_LIFE_TIME 100
SESSIONS_PER_USER 2
IDLE_TIME 30;

/*Users*/
CREATE USER user1 
IDENTIFIED BY user123
DEFAULT TABLESPACE gofar_travel 
profile manager;

GRANT CONNECT TO user1;

CREATE USER user2 
IDENTIFIED BY user2
DEFAULT TABLESPACE gofar_travel 
profile finance;

GRANT CONNECT TO user2;

CREATE USER user3 
IDENTIFIED BY user3
DEFAULT TABLESPACE gofar_travel 
profile development;

GRANT CONNECT TO user3;

CREATE USER user4 
IDENTIFIED BY user4
DEFAULT TABLESPACE gofar_travel 
profile development;

GRANT CONNECT TO user4;

/*DROP TABLESPACE test_purposes*/
DROP TABLESPACE test_purposes
   INCLUDING CONTENTS AND DATAFILES;
   
/*Lock the users associate with profiles: manager and finance*/
ALTER USER user1 ACCOUNT LOCK;
ALTER USER user2 ACCOUNT LOCK;

/*Vehicles Sequences*/
CREATE SEQUENCE VEHICLES_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


/*CREATE TABLES*/
CREATE TABLE VEHICLES (
  id number PRIMARY KEY,
  status varchar2(36) NOT NULL,
  vin varchar2(255),
  name varchar2(255) default NULL,
  model varchar2(11) default NULL,
  year varchar2(255),
  name_manufacturer varchar2(255),
  cost NUMBER(10,2)  
);

CREATE TABLE ACCESORIES (
  ID number primary key,
  CODE varchar2(255),
  DESCRIPTION varchar2(255) default NULL,
  COST NUMBER(10,2),
  SELLING_PRICE NUMBER(10,2)  
) ;

CREATE TABLE CUSTOMER(
  ID number primary key,
  NAME varchar2(255),
  ADDRESS VARCHAR2(255) default NULL,
  PHONE varchar2(100) default NULL
) ;

CREATE TABLE SALES_PERSON(
  ID number primary key,
  NAME varchar2(255)
) ;

CREATE TABLE INVOICE(
ID NUMBER PRIMARY KEY,
CUSTOMER_ID NUMBER,
VEHICLE_ID NUMBER,
FINAL_PRICE NUMBER(10,2),
PLUS NUMBER(10,2),
TAXES NUMBER(10,2),
LICENSE_FEES NUMBER(10,2),
SALES_PERSON_ID NUMBER
);

CREATE TABLE INVOICE_DETAIL(
ID NUMBER PRIMARY KEY,
INVOICE_ID NUMBER,
ACCESORIES_ID NUMBER
);

    
/*FOREIGN KEYS*/
ALTER TABLE INVOICE_DETAIL ADD CONSTRAINT FK_INVOICE
      FOREIGN KEY (INVOICE_ID) REFERENCES INVOICE (ID);
      
ALTER TABLE INVOICE_DETAIL ADD CONSTRAINT FK_ACCESORIES
      FOREIGN KEY (ACCESORIES_ID) REFERENCES ACCESORIES (ID);
      
ALTER TABLE INVOICE ADD CONSTRAINT FK_CUSTOMER
      FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (ID);

ALTER TABLE INVOICE ADD CONSTRAINT FK_VEHICLE
      FOREIGN KEY (VEHICLE_ID) REFERENCES VEHICLES (ID);
      
ALTER TABLE INVOICE ADD CONSTRAINT FK_SALES_PERSON
      FOREIGN KEY (SALES_PERSON_ID) REFERENCES SALES_PERSON (ID);




