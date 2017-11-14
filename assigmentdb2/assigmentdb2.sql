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


CREATE UNDO TABLESPACE undotbs
     DATAFILE 'tempDataFile06.dbf' SIZE 5M REUSE AUTOEXTEND ON;


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

/*Lock the users associate with profiles: manager and finance*/
ALTER USER user1 ACCOUNT LOCK;
ALTER USER user2 ACCOUNT LOCK;

/*DROP TABLESPACE test_purposes*/
DROP TABLESPACE test_purposes
   INCLUDING CONTENTS AND DATAFILES;
   

/*Vehicles Sequences*/
CREATE SEQUENCE VEHICLES_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE NEW_VEHICLES_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE MANUFACTURE_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE VEHICLES_FOR_SALE_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE TRADE_IN_VEHICLES_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE HISTORICAL_DATA_VEHICLES_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

/*Accesories Sequences*/
CREATE SEQUENCE ACCESORIES_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

/*INVOICE Sequences*/
CREATE SEQUENCE INVOICE_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


/*INVOCE_DETAIL Sequences*/
CREATE SEQUENCE INVOICE_DETAIL_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


/*INVOCE_DETAIL Sequences*/
CREATE SEQUENCE ACCESORIES_INVENTORY_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


/*SALES_PERSON Sequences*/
CREATE SEQUENCE SALES_PERSON_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

/*CUSTOMER Sequences*/
CREATE SEQUENCE CUSTOMER_SEQ
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
  year varchar2(255)
);

CREATE TABLE NEW_VEHICLES (
  id number PRIMARY KEY,
  vehicle_for_sale_id number not null,
  manufacture_id number not null,
  cost number(10,2) not null
);

CREATE TABLE MANUFACTURES (
  id number PRIMARY KEY,
  name varchar2(255) not null,
  address varchar2(255) not null,
  city varchar2(255) not null
);

CREATE TABLE VEHICLES_FOR_SALE (
  id number PRIMARY KEY,
  vehicle_id number not null,
  description varchar2(255) not null
);

CREATE TABLE TRADE_IN_VEHICLES (
  id number PRIMARY KEY,
  vehicle_for_sale_id number not null,
  cost number(10,2) not null,
  other_details varchar2(255) null
);


CREATE TABLE HISTORICAL_DATA_FOR_VEHICLES (
  id number PRIMARY KEY,
  vehicle_for_sale_id number null,
  invoice_id number null,
  status varchar2(255) null
);

CREATE TABLE ACCESORIES (
  ID number primary key,
  CODE varchar2(255),
  DESCRIPTION varchar(255),
  COST NUMBER(10,2),
  SELLING_PRICE NUMBER(10,2),
  MANUFACURE_ID NUMBER(10,2) not null
) ;

CREATE TABLE INVOICE(
ID NUMBER PRIMARY KEY,
CUSTOMER_ID NUMBER not null,
VEHICLE_FOR_SALE_ID NUMBER,
FINAL_PRICE NUMBER(10,2),
PLUS NUMBER(10,2),
TAXES NUMBER(10,2),
LICENSE_FEES NUMBER(10,2),
SALES_PERSON_ID NUMBER,
TRADE_IN_VEHICLE_ID NUMBER
);

CREATE TABLE INVOICE_DETAIL(
ID NUMBER PRIMARY KEY,
INVOICE_ID NUMBER,
ACCESORIES_ID NUMBER,
COST NUMBER(10,2) NOT NULL
);

CREATE TABLE ACCESORIES_INVENTORY(
ID NUMBER PRIMARY KEY,
accesory_ID NUMBER not null,
units_available number default 30
);

CREATE TABLE SALES_PERSON(
  ID number primary key,
  NAME varchar2(255)
);

CREATE TABLE CUSTOMER(
  ID number primary key,
  NAME varchar2(255),
  ADDRESS VARCHAR2(255) default NULL,
  PHONE varchar2(100) default NULL
);

/*FOREIGN KEYS*/
ALTER TABLE NEW_VEHICLES ADD CONSTRAINT FK_VEHICLE_FOR_SALE
      FOREIGN KEY (VEHICLE_FOR_SALE_ID) REFERENCES VEHICLES_FOR_SALE (ID);
      
ALTER TABLE NEW_VEHICLES ADD CONSTRAINT FK_MANUFACTURE
      FOREIGN KEY (MANUFACTURE_ID) REFERENCES MANUFACTURES (ID);
      
ALTER TABLE VEHICLES_FOR_SALE ADD CONSTRAINT FK_VEHICLE
      FOREIGN KEY (VEHICLE_ID) REFERENCES VEHICLES (ID);
      
ALTER TABLE TRADE_IN_VEHICLES ADD CONSTRAINT FK_TRADE_VEHICLE_FOR_SALE
      FOREIGN KEY (VEHICLE_FOR_SALE_ID) REFERENCES VEHICLES_FOR_SALE (ID);

ALTER TABLE HISTORICAL_DATA_FOR_VEHICLES ADD CONSTRAINT FK_HIST_VEHICLE_FOR_SALE
      FOREIGN KEY (VEHICLE_FOR_SALE_ID) REFERENCES VEHICLES_FOR_SALE (ID);
      
ALTER TABLE HISTORICAL_DATA_FOR_VEHICLES ADD CONSTRAINT FK_HIST_INVOICE
      FOREIGN KEY (INVOICE_ID) REFERENCES INVOICE (ID);

ALTER TABLE INVOICE ADD CONSTRAINT FK_CUSTOMER
      FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (ID);
      
ALTER TABLE INVOICE ADD CONSTRAINT FK_INVOICE_VEHICLE_FOR_SALE
      FOREIGN KEY (VEHICLE_FOR_SALE_ID) REFERENCES VEHICLES_FOR_SALE (ID);  
      
      
ALTER TABLE INVOICE ADD CONSTRAINT FK_INVOICE_TRADE_IN_VEHICLE
      FOREIGN KEY (TRADE_IN_VEHICLE_ID) REFERENCES TRADE_IN_VEHICLES (ID);  
      
ALTER TABLE INVOICE ADD CONSTRAINT FK_SALES_PERSON
      FOREIGN KEY (SALES_PERSON_ID) REFERENCES SALES_PERSON (ID);
      
ALTER TABLE INVOICE_DETAIL ADD CONSTRAINT FK_INVDETAIL_INVOICE
      FOREIGN KEY (INVOICE_ID) REFERENCES INVOICE (ID);

ALTER TABLE INVOICE_DETAIL ADD CONSTRAINT FK_INVDETAIL_ACCESORY
      FOREIGN KEY (ACCESORIES_ID) REFERENCES ACCESORIES (ID);      

ALTER TABLE ACCESORIES_INVENTORY ADD CONSTRAINT FK_ACCINV_ACCESORY
      FOREIGN KEY (accesory_ID) REFERENCES ACCESORIES (ID);    

alter table HISTORICAL_DATA_FOR_VEHICLES
    add  constraint ckHistoricalTable check (status in ('NEW', 'TRADE', 'SOLD'));
    

/*Create a view in order to display those products which are under 5 units availables, the view should
have the id, the name of the product, code and the name of the manufacturer*/
create or replace view accesories_under_five_units as
select ac.id, ac.description as name, ac.code, mf.name as manufacturer from accesories ac inner join accesories_inventory acinv on ac.id = acinv.accesory_ID
inner join MANUFACTURES mf on mf.id = ac.MANUFACURE_ID
where acinv.units_available < 5;

/*INSERT DATA*/
/*MANUFACTURES*/
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Elit Erat Vitae Company','883-4455 Amet Avda.','Vetlanda'); 
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Tortor Nunc Company','Apartado núm.: 444, 6248 Tortor Avenida','Fabro');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'In Cursus Et LLP','Apartado núm.: 171, 1761 Auctor Ctra.','Blenheim');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'In Incorporated','289-913 Elit. C/','Zoetermeer');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ornare Facilisis Eget Industries','472-8025 Sapien, Avenida','Gravataí');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Lacus Etiam Bibendum PC','1238 Nec Calle','Paglieta');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Euismod In Dolor Ltd','Apartado núm.: 631, 6138 Metus ','Columbus');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Mus Company','Apdo.:581-5458 Tellus, Ctra.','Paternopoli');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Quis Company','Apartado núm.: 621, 7102 Velit C/','Sgonico');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Et Netus Inc.','5005 Nec, Av.','Colomiers');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Suspendisse Sed Dolor Industries','2042 Iaculis C.','Carunchio');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Nullam Ut Nisi Limited','Apartado núm.: 337, 5759 In Avda.','Idaho Falls');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Lorem Ut Aliquam LLC','324-9285 Non ','Solre-Saint-GŽry');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Commodo Consulting','781-1426 Molestie ','Schönebeck');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Morbi Limited','361-6844 Ridiculus Ctra.','Molfetta');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Eleifend Foundation','Apdo.:396-7504 Consectetuer Calle','Atlanta');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ridiculus Mus Consulting','200-9616 Risus Carretera','Ponte nelle Alpi');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Cursus Associates','Apartado núm.: 440, 5357 Tristique C.','Bernburg');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Malesuada Consulting','265-4272 Nibh Avda.','Lerum');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Eros Incorporated','Apartado núm.: 647, 7731 Egestas Carretera','Calder');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Nullam Enim Corp.','8026 Iaculis Avenida','Langholm');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ut Pharetra LLC','Apdo.:772-3077 Cras C/','Thames');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Aliquam Ornare Consulting','6438 Eu Ctra.','Sirsa');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Felis Adipiscing Company','942 Ante Calle','Workum');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Congue Elit Sed PC','786-3511 Mi ','Kraków');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ultricies Ligula Institute','437-732 Quam. Avda.','Cessnock');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Suspendisse Commodo Tincidunt Foundation','Apartado núm.: 561, 1918 Auctor Avenida','Lake Cowichan');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Id Corporation','9104 Tincidunt, C.','Parramatta');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Porttitor Ltd','786-1308 Vel C/','Dégelis');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ad Ltd','Apartado núm.: 171, 2609 Convallis C/','Cagli');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ut Molestie In Industries','3419 Malesuada C/','Barrie');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'At Auctor Ullamcorper Industries','Apartado núm.: 245, 6502 Amet Carretera','Spaniard''s Bay');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Dolor LLC','475-967 Non Ctra.','St. Clears');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Vel Nisl LLC','959 Est Avda.','Laarne');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Nunc Associates','Apartado núm.: 111, 3237 Sed C.','Sutton');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Libero Institute','Apdo.:503-3321 Risus. Calle','Cuenca');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Magna Ltd','313-2959 Aliquam Av.','Curanilahue');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Velit In Aliquet LLP','Apartado núm.: 859, 834 Consequat C.','Körfez');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Aenean Gravida Limited','389-7842 Mauris Carretera','Belgrade');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Nunc Est Mollis Inc.','Apdo.:384-6572 Consequat, C/','Westmalle');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Pellentesque Tellus Sem Limited','Apartado núm.: 564, 2739 A, Avenida','Stratford');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Semper Inc.','8798 Lobortis, ','Melle');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Rutrum LLC','Apartado núm.: 628, 6322 Molestie. Avenida','Maidstone');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Litora Torquent Per PC','Apdo.:546-1743 Elit Avda.','San Piero a Sieve');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Cursus Institute','Apartado núm.: 168, 6760 Sem Ctra.','Zamo??');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Enim Non Nisi Associates','6386 Facilisis Avenida','Ambresin');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Rhoncus Id Associates','1907 Ultrices C.','Upplands Väsby');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Et Tristique Pellentesque LLC','Apdo.:547-3151 Elementum, ','Eckernförde');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Vel Company','8747 Pharetra, Av.','Koninksem');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ac PC','Apartado núm.: 157, 8859 Sed, C/','Melazzo');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Arcu Eu Institute','Apartado núm.: 963, 1088 Non Avda.','Cinco Esquinas');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Non Enim Mauris Company','Apdo.:762-317 Sodales Avenida','San Benedetto del Tronto');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Rhoncus Proin Foundation','5821 Elementum Avenida','Hoorn');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ornare Ltd','712-7980 Sed Av.','Roccamena');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Erat Incorporated','Apdo.:944-300 Molestie ','Eigenbrakel');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Duis Dignissim Tempor Inc.','7524 Orci Av.','Alessandria');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Parturient Inc.','6712 Dolor. Av.','Duncan');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Phasellus PC','Apdo.:820-2696 Mauris ','Rotterdam');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Consectetuer Euismod Limited','Apdo.:529-1376 Est. Ctra.','Ibadan');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Et Associates','3150 Mollis. C/','Firozabad');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Pellentesque Tincidunt Foundation','Apdo.:675-1649 Ac, C.','Putaendo');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Non Bibendum Incorporated','2875 Quam C/','Morhet');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Tellus Industries','4669 Fusce Avda.','Sant''Elia a Pianisi');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Tincidunt Company','490 Risus. Avenida','Butte');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Rhoncus Id Mollis Company','Apdo.:795-1814 Accumsan Avenida','Esen');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Nec Ltd','Apartado núm.: 172, 6688 Risus, Av.','Rossignol');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Nec Euismod Consulting','Apdo.:442-4806 Vulputate, Carretera','Bhuj');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Erat Neque Non Inc.','4779 Sodales C.','Rae-Edzo');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Elit Pede Institute','Apartado núm.: 423, 9444 Suspendisse Avda.','Tübingen');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Velit Aliquam Industries','514-6838 Tincidunt C/','Frankfurt');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Scelerisque Dui Corp.','311-5554 Diam Carretera','Lauw');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'In Faucibus Industries','Apdo.:360-550 Lorem, C/','Dunoon');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ridiculus Corp.','Apdo.:512-6365 Nonummy Calle','Cumberland');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Tempor Diam LLC','Apdo.:684-2636 Donec C/','Todi');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Adipiscing Enim Mi Corp.','Apdo.:673-6099 Nibh. C/','Miramichi');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Quam Pellentesque Ltd','997-4994 Ante. ','Souvret');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ipsum Ltd','4589 Iaculis Calle','Comblain-au-Pont');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Lorem Ipsum Dolor Company','698-9391 In, C.','Cavasso Nuovo');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ornare In Incorporated','Apartado núm.: 711, 2891 Fames C.','Sint-Kruis');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ipsum Donec Consulting','4216 Nisi Avda.','Annapolis');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Facilisis Limited','Apartado núm.: 760, 4768 Malesuada Calle','Sint-Pieters-Woluwe');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Ornare Ltd','Apdo.:412-9024 Eu Carretera','Abbateggio');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Sed Corporation','Apdo.:515-9974 Aliquam Avenida','Kalken');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Diam Sed Inc.','Apdo.:576-6464 Egestas C.','Antofagasta');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Sit Incorporated','8449 Ante. C/','Town of Yarmouth');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Proin Non Corp.','1441 Dictum C.','Pica');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Non Lorem LLP','4999 Sociis Ctra.','Lozzo Atestino');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Sed Neque Sed Consulting','687-6701 Accumsan ','Wroc?aw');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Felis Eget Ltd','Apdo.:652-9513 Libero. Calle','Gorzów Wielkopolski');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Porttitor Tellus Non Limited','Apdo.:224-3581 Dui, Av.','Montemignaio');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Semper Dui Lectus Ltd','Apdo.:556-3352 Dui Av.','Bargagli');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Non Leo Industries','389-8279 Nec Av.','Stewart');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Sit Amet Ultricies LLP','765-8109 Ligula. Avda.','Wimbledon');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'At Velit Cras Corp.','8584 Mollis Av.','Arbre');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Penatibus Et Magnis Consulting','771-1332 Facilisis, Carretera','Polpenazze del Garda');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Elit A Feugiat Foundation','Apdo.:792-4433 Aliquam C.','Tongue');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Magna Corp.','Apartado núm.: 272, 1253 Faucibus. Avda.','Marystown');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Elit Pharetra Ut Ltd','Apdo.:278-426 Nisi. Carretera','Harnoncourt');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Porttitor Vulputate PC','4543 Aliquam Avenida','Trento');
INSERT INTO MANUFACTURES (id,name,address,city) VALUES (MANUFACTURE_SEQ.NEXTVAL,'Augue Institute','310-2856 Duis ','Bergen op Zoom');

/*Vechicles*/
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16751024-8839','Mauris nulla. Integer urna. Vivamus molestie dapibus','379508',2005);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16970501-0743','turpis egestas. Aliquam fringilla cursus','354991',2018);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16761203-7692','laoreet lectus quis massa. Mauris vestibulum, neque sed dictum eleifend, nunc risus varius orci, in','955928',2016);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16040308-8941','odio semper cursus. Integer mollis. Integer tincidunt aliquam arcu. Aliquam ultrices','433438',2009);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16360530-6285','vestibulum. Mauris magna. Duis dignissim tempor arcu.','978729',2015);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16121107-9890','magna tellus faucibus leo, in lobortis tellus justo sit amet nulla. Donec non justo.','687622',2017);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16900129-2979','odio vel est tempor bibendum. Donec felis orci, adipiscing non, luctus','200855',2006);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16961118-3519','et,','466367',2008);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16130413-6813','at pede. Cras','224791',2014);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16210913-9168','mauris. Integer sem elit, pharetra ut,','840158',2005);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16601028-1704','molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean','770679',2001);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16891208-3154','convallis ligula. Donec','881088',2018);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16220425-6610','torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam','521644',2017);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16130828-8420','sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum magna. Cras convallis convallis dolor. Quisque tincidunt pede','882387',2010);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16860208-0973','Nulla facilisi. Sed neque. Sed eget','474147',2014);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16460204-9142','vulputate eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris elit, dictum eu,','579522',2012);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16431209-7019','dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut','786702',2005);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16710420-1046','dolor. Quisque tincidunt pede ac urna. Ut tincidunt vehicula risus. Nulla','999084',2005);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16881221-2754','Sed pharetra, felis eget varius ultrices, mauris ipsum porta elit, a','632092',2002);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16410503-4393','lorem ut aliquam iaculis, lacus pede sagittis augue, eu tempor erat neque non quam.','820968',2002);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16491109-9358','Vivamus non lorem vitae odio sagittis semper. Nam tempor diam','713322',2002);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16421112-6075','vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia.','844001',2018);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16920424-1302','nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas','361396',2001);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16700602-0650','blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed consequat','822584',2010);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16010517-4957','mauris a nunc. In at pede. Cras vulputate velit eu sem. Pellentesque ut ipsum ac mi','487153',2005);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16780601-9381','dolor','347905',2000);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16320708-1484','ac mattis velit justo nec ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate,','476050',2012);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16631006-7274','nec luctus felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et,','150289',2014);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16000429-3205','Quisque','539346',2001);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16740317-8374','fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a,','711997',2016);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16470610-1328','a felis ullamcorper viverra. Maecenas iaculis','212808',2005);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16970704-5101','vel est tempor bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus ut, nulla. Cras','346323',2001);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16210802-8347','pellentesque, tellus sem mollis','454930',2007);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16730506-0191','erat, in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque','246366',2008);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16140915-5965','vehicula risus. Nulla eget metus eu erat semper rutrum. Fusce dolor quam, elementum','922600',2010);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16480404-9981','sapien. Aenean massa. Integer vitae nibh. Donec est mauris, rhoncus id,','431787',2006);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16740111-8331','magna, malesuada vel, convallis in, cursus et, eros. Proin ultrices.','251734',2013);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16750718-5788','ut, molestie in, tempus eu,','872104',2011);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16120814-5621','ipsum leo elementum sem, vitae aliquam eros turpis non enim.','656173',2006);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16671004-7405','urna. Nullam lobortis quam a felis ullamcorper','247175',2013);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16030506-1160','sit amet, risus. Donec nibh','692276',2015);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16080426-9629','nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu.','517571',2014);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16380402-6619','egestas blandit.','995080',2001);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16061029-5677','Proin vel nisl. Quisque fringilla euismod enim. Etiam','388274',2002);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'NEW','16490221-6458','et','827922',2005);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16801104-3992','nisi','783081',2003);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16830823-6085','et magnis dis parturient','787402',201200);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16980323-3429','Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra.','723070',201400);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16620122-3069','pede. Nunc sed','349725',2017);
INSERT INTO VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) VALUES (VEHICLES_SEQ.NEXTVAL,'USED','16360414-5460','metus. Aliquam erat volutpat. Nulla facilisis.','997551',2000);

/*VEHICLES_FOR_SALE*/
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,1,'magnis dis parturient');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,2,'ac facilisis facilisis, magna');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,3,'Maecenas libero est, congue a,');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,4,'Mauris vel');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,5,'amet, risus. Donec nibh enim, gravida sit amet,');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,6,'condimentum eget, volutpat');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,7,'in molestie');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,8,'eget massa. Suspendisse eleifend. Cras');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,9,'tellus');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,10,'mauris ut mi. Duis risus odio, auctor vitae, aliquet nec,');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,11,'Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu.');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,12,'sem ut dolor');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,13,'Sed et libero. Proin mi. Aliquam');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,14,'eu augue porttitor interdum. Sed auctor odio');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,15,'vulputate');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,16,'pellentesque. Sed');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,17,'at, nisi. Cum sociis natoque penatibus et magnis');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,18,'sem, consequat nec, mollis vitae, posuere at, velit. Cras lorem');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,19,'tellus, imperdiet non, vestibulum nec, euismod in,');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,20,'ornare. Fusce mollis. Duis sit amet diam eu dolor');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,21,'auctor vitae, aliquet nec, imperdiet nec, leo.');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,22,'convallis in, cursus et, eros. Proin ultrices. Duis');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,23,'Pellentesque');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,24,'risus. Duis a');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,25,'blandit at, nisi. Cum sociis natoque penatibus et');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,26,'velit justo nec ante. Maecenas');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,27,'In at pede. Cras vulputate velit');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,28,'accumsan convallis, ante');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,29,'orci lobortis augue scelerisque mollis. Phasellus libero mauris, aliquam eu,');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,30,'non ante');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,31,'sed');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,32,'pellentesque eget, dictum placerat, augue.');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,33,'arcu. Vivamus sit amet risus. Donec egestas. Aliquam');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,34,'quam dignissim pharetra. Nam ac nulla. In tincidunt congue');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,35,'pede blandit congue. In scelerisque scelerisque dui. Suspendisse');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,36,'at');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,37,'in magna. Phasellus dolor elit, pellentesque a, facilisis non,');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,38,'aliquet, sem ut');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,39,'sem mollis dui, in sodales elit');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,40,'vitae risus. Duis a mi');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,41,'dolor');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,42,'et magnis dis parturient montes, nascetur ridiculus');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,43,'Nulla semper tellus id');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,44,'vel nisl. Quisque fringilla euismod enim. Etiam gravida');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,45,'arcu.');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,46,'lacus. Ut nec urna et');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,47,'Sed molestie. Sed id risus');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,48,'Duis cursus, diam at pretium aliquet,');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,49,'ac urna. Ut tincidunt vehicula risus. Nulla eget metus');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,50,'magna nec quam. Curabitur vel lectus.');
INSERT INTO VEHICLES_FOR_SALE (id,vehicle_id,description) VALUES (VEHICLES_FOR_SALE_SEQ.NEXTVAL,51,'mollis vitae, posuere at, velit. Cras lorem lorem, luctus ut,');

/*NEW_VEHICLES*/
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,1,1,49220881.86);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,2,2,65902308.50);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,3,3,66140526.09);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,4,4,47714693.56);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,5,5,63347723.68);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,6,6,31612120.83);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,7,7,17164970.58);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,8,8,34253901.84);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,9,9,51605015.07);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,10,10,26423445.32);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,11,11,58629496.81);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,12,12,51411917.53);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,13,13,67523003.58);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,14,14,52809371.68);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,15,15,34733482.60);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,16,16,49468496.33);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,17,17,56458997.78);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,18,18,64045452.28);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,19,19,52363171.63);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,20,20,33659852.22);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,21,21,49421792.00);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,22,22,35997344.82);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,23,23,23042638.86);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,24,24,53049661.53);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,25,25,35596598.04);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,26,26,66894661.76);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,27,27,26400389.43);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,28,28,48879012.70);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,29,29,54859337.30);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,30,30,47753286.70);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,31,31,63172345.88);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,32,32,47187069.87);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,33,33,17070828.87);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,34,34,26642367.63);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,35,35,45987196.20);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,36,36,39356001.08);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,37,37,32527956.30);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,38,38,29024609.19);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,39,39,15283799.95);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,40,40,32066314.96);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,41,41,41304294.12);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,42,42,49467793.66);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,43,43,67092158.60);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,44,44,55483824.58);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,45,45,62539457.27);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,46,46,20283091.36);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,47,47,67605950.33);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,48,48,48524139.32);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,49,49,44222452.64);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,50,50,22032444.67);
INSERT INTO NEW_VEHICLES (id,vehicle_for_sale_id,manufacture_id,cost) VALUES (NEW_VEHICLES_SEQ.NEXTVAL,51,51,46231606.18);

/*TRADE_IN_VEHICLES*/
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,1,50914503.80,'dignissim. Maecenas ornare egestas ligula.');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,2,42068874.73,'hendrerit consectetuer, cursus et, magna.');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,3,38599313.80,'consequat purus. Maecenas libero est,');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,4,28570380.41,'velit. Cras lorem lorem, luctus');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,5,46676790.07,'penatibus et magnis dis parturient');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,6,54653807.43,'Integer urna. Vivamus molestie dapibus');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,7,20651034.58,'ut lacus. Nulla tincidunt, neque');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,8,57708666.66,'bibendum. Donec felis orci, adipiscing');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,9,29697341.50,'dolor vitae dolor. Donec fringilla.');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,10,62893977.68,'Sed eget lacus. Mauris non');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,11,40654515.33,'at, iaculis quis, pede. Praesent');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,12,21188338.99,'ante. Vivamus non lorem vitae');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,13,23839989.83,'sem. Pellentesque ut ipsum ac');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,14,49331108.62,'Nam consequat dolor vitae dolor.');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,15,24894502.17,'semper erat, in consectetuer ipsum');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,16,67418639.39,'nibh. Quisque nonummy ipsum non');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,17,20976859.06,'venenatis lacus. Etiam bibendum fermentum');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,18,48597364.77,'non, bibendum sed, est. Nunc');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,19,55708665.11,'non, egestas a, dui. Cras');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,20,24100292.43,'orci luctus et ultrices posuere');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,21,50353889.95,'Proin velit. Sed malesuada augue');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,22,23065720.54,'nec, cursus a, enim. Suspendisse');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,23,56596866.96,'imperdiet non, vestibulum nec, euismod');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,24,35716589.46,'primis in faucibus orci luctus');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,25,52755960.47,'justo. Proin non massa non');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,26,31541260.39,'cubilia Curae; Donec tincidunt. Donec');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,27,26372067.05,'Vivamus molestie dapibus ligula. Aliquam');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,28,34439860.60,'pellentesque, tellus sem mollis dui,');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,29,41746154.32,'vitae erat vel pede blandit');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,30,35340529.69,'commodo auctor velit. Aliquam nisl.');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,31,43959203.04,'fermentum risus, at fringilla purus');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,32,23010314.24,'ut eros non enim commodo');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,33,35768517.08,'eget, venenatis a, magna. Lorem');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,34,20588859.60,'habitant morbi tristique senectus et');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,35,20816879.50,'commodo auctor velit. Aliquam nisl.');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,36,66517063.79,'nunc, ullamcorper eu, euismod ac,');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,37,31342145.99,'quis, tristique ac, eleifend vitae,');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,38,61828583.02,'amet orci. Ut sagittis lobortis');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,39,63822248.50,'pede. Cras vulputate velit eu');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,40,45285680.80,'massa rutrum magna. Cras convallis');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,41,18610929.37,'ipsum primis in faucibus orci');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,42,67691043.57,'nibh. Donec est mauris, rhoncus');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,43,50833918.96,'mauris eu elit. Nulla facilisi.');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,44,18942135.51,'consectetuer euismod est arcu ac');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,45,54490383.17,'accumsan sed, facilisis vitae, orci.');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,46,19547307.28,'enim. Suspendisse aliquet, sem ut');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,47,68392850.53,'non nisi. Aenean eget metus.');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,48,62411036.40,'habitant morbi tristique senectus et');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,49,16460147.84,'vitae odio sagittis semper. Nam');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,50,30642436.84,'dolor elit, pellentesque a, facilisis');
INSERT INTO TRADE_IN_VEHICLES (id,vehicle_for_sale_id,cost,other_details) VALUES (TRADE_IN_VEHICLES_SEQ.NEXTVAL,51,15466327.48,'nascetur ridiculus mus. Proin vel');

/*SALES_PERSON*/
INSERT INTO SALES_PERSON (ID,NAME) VALUES (SALES_PERSON_SEQ.NEXTVAL,'Kimberley');
INSERT INTO SALES_PERSON (ID,NAME) VALUES (SALES_PERSON_SEQ.NEXTVAL,'Leila');
INSERT INTO SALES_PERSON (ID,NAME) VALUES (SALES_PERSON_SEQ.NEXTVAL,'Desirae');
INSERT INTO SALES_PERSON (ID,NAME) VALUES (SALES_PERSON_SEQ.NEXTVAL,'Callie');
INSERT INTO SALES_PERSON (ID,NAME) VALUES (SALES_PERSON_SEQ.NEXTVAL,'Raphael');

/*CUSTOMER*/
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Cody','Ap #730-7523 Euismod Rd.','1-809-860-5549');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Rhonda','Ap #275-8514 Consectetuer Av.','1-524-963-0431');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Armando','208-7117 Proin Rd.','1-837-587-6539');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Regina','579-9578 Aliquam Rd.','1-153-896-6594');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Tate','Ap #784-5647 Sed Rd.','1-299-940-9526');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Orson','Ap #192-1757 In Road','1-272-611-8059');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Chava','P.O. Box 643, 2485 Duis Rd.','1-452-493-5834');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Jessica','P.O. Box 105, 4328 Malesuada Ave','1-384-690-5912');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Lev','Ap #748-6966 Faucibus. Rd.','1-976-646-5941');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Ulla','161-4415 Orci Avenue','1-183-642-8158');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Rebecca','P.O. Box 566, 1017 Nulla Rd.','1-184-462-9304');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Anjolie','P.O. Box 489, 4390 Augue, Ave','1-157-881-9091');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Kaye','P.O. Box 361, 9112 Eu Rd.','1-103-886-5222');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'James','P.O. Box 358, 1335 Cras Av.','1-767-406-3600');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Kevyn','9152 Sem, St.','1-731-177-0243');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Bethany','3135 Enim Avenue','1-145-848-3990');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Malachi','833-3797 Neque Ave','1-757-173-2061');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Asher','4790 Adipiscing Rd.','1-998-366-7672');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Eve','3204 Egestas. Av.','1-479-719-4357');
INSERT INTO CUSTOMER (ID,NAME,ADDRESS,PHONE) VALUES (CUSTOMER_SEQ.NEXTVAL,'Destiny','P.O. Box 561, 9434 Aliquam Road','1-723-101-1898');

/*ACCESORIES*/
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9077','Aliquam adipiscing lobortis risus. In mi pede, nonummy ut, molestie',215188.57,385735.38,50);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1754','montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque',173853.84,364218.47,24);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8165','at, velit. Cras lorem lorem, luctus ut, pellentesque eget, dictum',272295.26,473442.70,37);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9878','auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus',250359.78,651182.49,58);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'6931','aliquet molestie tellus. Aenean egestas hendrerit neque. In ornare sagittis',187732.25,355510.06,46);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5017','neque et nunc. Quisque ornare tortor at risus. Nunc ac',296847.74,565575.80,14);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'4852','Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros.',266905.01,537681.23,6);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7909','Mauris blandit enim consequat purus. Maecenas libero est, congue a,',190639.66,663587.79,8);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'4969','vulputate velit eu sem. Pellentesque ut ipsum ac mi eleifend',172580.22,524423.40,64);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3766','dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae,',148924.43,359372.07,49);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7774','nulla ante, iaculis nec, eleifend non, dapibus rutrum, justo. Praesent',138268.31,453520.71,3);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7980','habitant morbi tristique senectus et netus et malesuada fames ac',271355.66,653231.14,100);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9517','id, mollis nec, cursus a, enim. Suspendisse aliquet, sem ut',148810.38,673425.11,58);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'4105','ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet',258128.46,670837.35,25);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5896','nulla. Donec non justo. Proin non massa non ante bibendum',233342.21,493010.96,43);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7944','id ante dictum cursus. Nunc mauris elit, dictum eu, eleifend',271750.86,469091.35,91);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'2335','Curabitur dictum. Phasellus in felis. Nulla tempor augue ac ipsum.',107458.84,500764.06,49);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3927','hendrerit id, ante. Nunc mauris sapien, cursus in, hendrerit consectetuer,',243490.29,672196.50,9);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'6352','pede. Praesent eu dui. Cum sociis natoque penatibus et magnis',257007.22,365299.37,1);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9661','neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris eu turpis.',109294.67,693390.96,57);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3386','eu erat semper rutrum. Fusce dolor quam, elementum at, egestas',250107.15,685850.91,33);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9665','orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec',192994.22,546875.82,55);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'4346','vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu.',164620.05,640944.20,90);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5191','tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh',250518.38,418700.91,28);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9294','id sapien. Cras dolor dolor, tempus non, lacinia at, iaculis',201923.63,460436.10,21);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7557','sodales purus, in molestie tortor nibh sit amet orci. Ut',203470.91,410543.86,21);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5192','ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate,',289112.06,495390.27,7);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'4159','mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus.',154973.28,500550.13,54);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5070','Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc',205397.02,662819.26,43);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7404','Nullam velit dui, semper et, lacinia vitae, sodales at, velit.',161884.87,681834.04,67);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8386','erat, eget tincidunt dui augue eu tellus. Phasellus elit pede,',196506.32,438890.43,65);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5265','et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien,',253420.00,539394.30,2);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8412','erat semper rutrum. Fusce dolor quam, elementum at, egestas a,',147406.46,383061.32,13);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'2345','mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam',180597.84,398277.84,85);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9478','eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat',210875.10,670851.37,33);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9248','nunc sed libero. Proin sed turpis nec mauris blandit mattis.',293037.96,556732.61,23);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'6149','risus, at fringilla purus mauris a nunc. In at pede.',260036.98,627579.30,37);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7229','lorem, auctor quis, tristique ac, eleifend vitae, erat. Vivamus nisi.',171492.41,390078.96,31);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9809','in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla',211255.26,578397.70,80);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9936','magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna',243170.57,484745.61,64);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1745','sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris',269101.56,355089.58,81);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7271','Vestibulum ante ipsum primis in faucibus orci luctus et ultrices',204995.49,518336.37,89);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1707','In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum',213430.71,567082.58,41);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7263','erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor.',285361.25,409383.86,48);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'2392','sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus',199233.65,480051.80,37);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8072','In mi pede, nonummy ut, molestie in, tempus eu, ligula.',223528.94,397061.23,59);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3812','vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie',194211.71,591768.11,56);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9718','blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae',220562.75,569043.37,88);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7568','sem egestas blandit. Nam nulla magna, malesuada vel, convallis in,',254171.32,353544.74,82);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1197','non magna. Nam ligula elit, pretium et, rutrum non, hendrerit',149005.18,482691.65,63);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7987','eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus',215234.20,660786.50,77);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1831','ac mattis velit justo nec ante. Maecenas mi felis, adipiscing',173212.66,667540.95,92);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'4016','ac libero nec ligula consectetuer rhoncus. Nullam velit dui, semper',215834.51,532013.23,71);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5536','nec, leo. Morbi neque tellus, imperdiet non, vestibulum nec, euismod',149411.02,477245.76,99);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1802','mauris a nunc. In at pede. Cras vulputate velit eu',126140.27,661769.12,23);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'2840','Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper',200834.75,511515.94,54);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'6546','urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum',274872.71,637555.44,13);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7572','neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris eu turpis.',112013.69,443218.06,89);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8981','bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus',113393.64,668504.26,40);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7063','ut erat. Sed nunc est, mollis non, cursus non, egestas',191222.96,500278.02,1);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'2549','vel, vulputate eu, odio. Phasellus at augue id ante dictum',267832.16,463015.73,25);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7333','velit. Pellentesque ultricies dignissim lacus. Aliquam rutrum lorem ac risus.',134657.13,577839.86,52);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5117','egestas. Aliquam fringilla cursus purus. Nullam scelerisque neque sed sem',177903.84,684573.43,10);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9438','urna, nec luctus felis purus ac tellus. Suspendisse sed dolor.',269397.76,559648.21,40);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5337','Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit',281514.16,420044.15,53);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8015','Integer urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla',233293.45,387367.48,21);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1216','sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos.',213769.42,427472.01,55);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3113','est. Nunc laoreet lectus quis massa. Mauris vestibulum, neque sed',271191.91,592331.94,53);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'6274','metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec',203082.98,557834.57,98);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9907','quis accumsan convallis, ante lectus convallis est, vitae sodales nisi',157127.69,378669.67,19);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9993','justo eu arcu. Morbi sit amet massa. Quisque porttitor eros',138070.40,364286.76,32);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5740','ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam',220108.16,377167.93,37);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3402','tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel,',244730.56,389865.67,54);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3506','Mauris ut quam vel sapien imperdiet ornare. In faucibus. Morbi',143551.22,689220.21,97);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3033','accumsan neque et nunc. Quisque ornare tortor at risus. Nunc',142072.42,390403.99,70);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'4782','ipsum cursus vestibulum. Mauris magna. Duis dignissim tempor arcu. Vestibulum',275383.65,643518.73,14);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5308','quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod',103868.84,453813.72,90);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9010','massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit',212283.04,586133.14,56);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'6706','malesuada fames ac turpis egestas. Fusce aliquet magna a neque.',278394.88,552287.22,90);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9352','ante. Vivamus non lorem vitae odio sagittis semper. Nam tempor',262010.98,667899.00,31);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8644','arcu. Morbi sit amet massa. Quisque porttitor eros nec tellus.',197346.14,643569.35,56);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8324','non enim. Mauris quis turpis vitae purus gravida sagittis. Duis',193877.29,641079.53,84);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'7348','nibh. Donec est mauris, rhoncus id, mollis nec, cursus a,',195507.20,647937.05,54);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9128','elit sed consequat auctor, nunc nulla vulputate dui, nec tempus',196096.71,464950.29,24);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3321','turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy ut,',268758.94,649790.28,24);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'6454','semper auctor. Mauris vel turpis. Aliquam adipiscing lobortis risus. In',291171.30,463144.21,19);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9650','auctor odio a purus. Duis elementum, dui quis accumsan convallis,',187181.80,437672.21,13);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1476','eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce',299782.24,355822.82,40);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'9387','erat semper rutrum. Fusce dolor quam, elementum at, egestas a,',141661.62,425465.51,44);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'4461','arcu. Vivamus sit amet risus. Donec egestas. Aliquam nec enim.',252934.61,512119.60,5);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8440','tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum',204996.90,432004.00,25);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1250','diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent',121204.20,620892.45,9);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1168','et, eros. Proin ultrices. Duis volutpat nunc sit amet metus.',102919.49,480178.76,7);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'1650','vitae semper egestas, urna justo faucibus lectus, a sollicitudin orci',129585.14,474874.01,15);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'6098','placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet,',263763.14,645787.42,56);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3470','bibendum sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum,',210383.58,489093.84,27);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'5370','varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem',206470.88,517564.58,4);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'8386','urna convallis erat, eget tincidunt dui augue eu tellus. Phasellus',200009.91,362190.79,78);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'3181','purus sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam',172043.80,505318.39,65);
INSERT INTO ACCESORIES (id,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) VALUES (ACCESORIES_SEQ.NEXTVAL,'6941','euismod in, dolor. Fusce feugiat. Lorem ipsum dolor sit amet,',278085.11,551980.12,94);

/*ACCESORIES_INVENTORY*/
SELECT * FROM ACCESORIES_INVENTORY;
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,1,21);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,2,17);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,3,28);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,4,6);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,5,8);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,6,22);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,7,40);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,8,48);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,9,18);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,10,26);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,11,10);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,12,14);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,13,26);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,14,9);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,15,2);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,16,5);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,17,40);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,18,22);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,19,36);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,20,31);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,21,47);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,22,38);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,23,8);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,24,18);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,25,1);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,26,15);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,27,31);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,28,1);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,29,3);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,30,37);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,31,7);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,32,2);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,33,3);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,34,6);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,35,41);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,36,38);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,37,48);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,38,20);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,39,5);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,40,5);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,41,18);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,42,25);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,43,41);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,44,47);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,45,29);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,46,50);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,47,39);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,48,23);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,49,18);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,50,39);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,51,22);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,52,33);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,53,27);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,54,47);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,55,22);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,56,14);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,57,2);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,58,5);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,59,46);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,60,46);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,61,29);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,62,49);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,63,20);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,64,17);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,65,47);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,66,17);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,67,13);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,68,4);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,69,50);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,70,5);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,71,41);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,72,37);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,73,1);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,74,43);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,75,31);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,76,31);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,77,21);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,78,3);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,79,6);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,80,4);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,81,50);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,82,23);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,83,24);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,84,13);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,85,36);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,86,11);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,87,3);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,88,22);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,89,46);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,90,10);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,91,38);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,92,11);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,93,37);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,94,50);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,95,20);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,96,39);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,97,17);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,98,16);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,99,7);
INSERT INTO ACCESORIES_INVENTORY (id,accesory_ID,units_available) VALUES (ACCESORIES_INVENTORY_SEQ.NEXTVAL,100,2);

/*INVOICE - INVOICE_DETAIL - HISTORICAL_DATA_FOR_VEHICLE*/
