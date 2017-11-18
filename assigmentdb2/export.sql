--------------------------------------------------------
-- Archivo creado  - sábado-noviembre-18-2017   
--------------------------------------------------------
DROP VIEW "SYSTEM"."ACCESORIES_UNDER_FIVE_UNITS";
DROP VIEW "SYSTEM"."INFO_INVOICE";
DROP TYPE "SYSTEM"."REPCAT$_OBJECT_NULL_VECTOR";
DROP TABLE "SYSTEM"."ACCESORIES";
DROP TABLE "SYSTEM"."ACCESORIES_INVENTORY";
DROP TABLE "SYSTEM"."CUSTOMER";
DROP TABLE "SYSTEM"."HISTORICAL_DATA_FOR_VEHICLES";
DROP TABLE "SYSTEM"."INVOICE";
DROP TABLE "SYSTEM"."INVOICE_DETAIL";
DROP TABLE "SYSTEM"."MANUFACTURES";
DROP TABLE "SYSTEM"."NEW_VEHICLES";
DROP TABLE "SYSTEM"."SALES_PERSON";
DROP TABLE "SYSTEM"."TRADE_IN_VEHICLES";
DROP TABLE "SYSTEM"."VEHICLES";
DROP TABLE "SYSTEM"."VEHICLES_FOR_SALE";
DROP SEQUENCE "SYSTEM"."ACCESORIES_INVENTORY_SEQ";
DROP SEQUENCE "SYSTEM"."ACCESORIES_SEQ";
DROP SEQUENCE "SYSTEM"."CUSTOMER_SEQ";
DROP SEQUENCE "SYSTEM"."HISTORICAL_DATA_VEHICLES_SEQ";
DROP SEQUENCE "SYSTEM"."INVOICE_DETAIL_SEQ";
DROP SEQUENCE "SYSTEM"."INVOICE_SEQ";
DROP SEQUENCE "SYSTEM"."MANUFACTURE_SEQ";
DROP SEQUENCE "SYSTEM"."NEW_VEHICLES_SEQ";
DROP SEQUENCE "SYSTEM"."SALES_PERSON_SEQ";
DROP SEQUENCE "SYSTEM"."TRADE_IN_VEHICLES_SEQ";
DROP SEQUENCE "SYSTEM"."VEHICLES_FOR_SALE_SEQ";
DROP SEQUENCE "SYSTEM"."VEHICLES_SEQ";
DROP PROCEDURE "SYSTEM"."INSERT_HISTORICAL_DATA_VEHI";
DROP PROCEDURE "SYSTEM"."INSERT_INVOICE_DETAIL_PROC";
DROP PROCEDURE "SYSTEM"."REORDER_UNITS";
DROP PACKAGE "SYSTEM"."DBMS_REPCAT_AUTH";
DROP PACKAGE BODY "SYSTEM"."DBMS_REPCAT_AUTH";
DROP SYNONYM "SYSTEM"."CATALOG";
DROP SYNONYM "SYSTEM"."COL";
DROP SYNONYM "SYSTEM"."PRODUCT_USER_PROFILE";
DROP SYNONYM "SYSTEM"."PUBLICSYN";
DROP SYNONYM "SYSTEM"."SYSCATALOG";
DROP SYNONYM "SYSTEM"."SYSFILES";
DROP SYNONYM "SYSTEM"."TAB";
DROP SYNONYM "SYSTEM"."TABQUOTAS";
begin
DBMS_AQADM.DROP_QUEUE(queue_name=>'DEF$_AQERROR', auto_commit=>TRUE);
end;
/
begin
DBMS_AQADM.DROP_QUEUE(queue_name=>'DEF$_AQCALL', auto_commit=>TRUE);
end;
/
begin
DBMS_AQADM.DROP_QUEUE_TABLE(queue_table=>'DEF$_AQCALL', force=>TRUE);
end;
/
begin
DBMS_AQADM.DROP_QUEUE_TABLE(queue_table=>'DEF$_AQERROR', force=>TRUE);
end;
/
--------------------------------------------------------
--  DDL for View ACCESORIES_UNDER_FIVE_UNITS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SYSTEM"."ACCESORIES_UNDER_FIVE_UNITS" ("ID", "NAME", "CODE", "MANUFACTURER", "UNITS_AVAILABLE") AS 
  SELECT ac.id, 
       ac.description as name, 
       ac.code, mf.name as manufacturer,
       acinv.units_available
  FROM accesories ac 
 INNER JOIN accesories_inventory acinv 
    ON ac.id = acinv.accesory_ID
 INNER JOIN MANUFACTURES mf on mf.id = ac.MANUFACURE_ID
 WHERE acinv.units_available < 5
;
--------------------------------------------------------
--  DDL for View INFO_INVOICE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SYSTEM"."INFO_INVOICE" ("BILL_ID", "SALES_PERSON_ID", "NAME_OF_SALESPERSON", "CLIENT_ID", "NAME_OF_CLIENT", "VEHICLE_ID", "BRAND_OF_VEHICLE", "MANUFACTURER_OF_VEHICLE", "ACCESORY_ID", "NAME_OF_ACCESORY") AS 
  SELECT i.ID bill_id,
           I.SALES_PERSON_ID,
           S.NAME name_of_salesperson,
           i.CUSTOMER_ID client_id,
           c.NAME name_of_client,
           i.VEHICLE_FOR_SALE_ID vehicle_id,
           V.MODEL brand_of_vehicle,
           M.NAME manufacturer_of_vehicle,
           AC.ID accesory_id,
           AC.DESCRIPTION name_of_accesory
      FROM INVOICE I
     INNER JOIN INVOICE_DETAIL I_D ON I.ID = I_D.INVOICE_ID
      LEFT JOIN ACCESORIES AC ON AC.ID = I_D.ACCESORIES_ID
     INNER JOIN SALES_PERSON S ON S.ID = i.SALES_PERSON_ID
     INNER join CUSTOMER c ON i.CUSTOMER_ID = c.ID
      LEFT JOIN VEHICLES_FOR_SALE VS ON VS.ID = i.VEHICLE_FOR_SALE_ID
      LEFT JOIN VEHICLES V ON V.ID = VS.VEHICLE_ID
      LEFT JOIN NEW_VEHICLES NV ON NV.VEHICLE_FOR_SALE_ID = VS.ID
      LEFT JOIN MANUFACTURES M ON M.ID = NV.MANUFACTURE_ID
;
--------------------------------------------------------
--  DDL for Type REPCAT$_OBJECT_NULL_VECTOR
--------------------------------------------------------

  CREATE OR REPLACE TYPE "SYSTEM"."REPCAT$_OBJECT_NULL_VECTOR" AS OBJECT
(
  -- type owner, name, hashcode for the type represented by null_vector
  type_owner      VARCHAR2(30),
  type_name       VARCHAR2(30),
  type_hashcode   RAW(17),
  -- null_vector for a particular object instance
  -- ROBJ REVISIT: should only contain the null image, and not version#
  null_vector     RAW(2000)
)

/
--------------------------------------------------------
--  DDL for Table ACCESORIES
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."ACCESORIES" 
   (	"ID" NUMBER, 
	"CODE" VARCHAR2(255 BYTE), 
	"DESCRIPTION" VARCHAR2(255 BYTE), 
	"COST" NUMBER(10,2), 
	"SELLING_PRICE" NUMBER(10,2), 
	"MANUFACURE_ID" NUMBER(10,2)
   ) ;
--------------------------------------------------------
--  DDL for Table ACCESORIES_INVENTORY
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."ACCESORIES_INVENTORY" 
   (	"ID" NUMBER, 
	"ACCESORY_ID" NUMBER, 
	"UNITS_AVAILABLE" NUMBER DEFAULT 30
   ) ;
--------------------------------------------------------
--  DDL for Table CUSTOMER
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."CUSTOMER" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(255 BYTE), 
	"ADDRESS" VARCHAR2(255 BYTE) DEFAULT NULL, 
	"PHONE" VARCHAR2(100 BYTE) DEFAULT NULL
   ) ;
--------------------------------------------------------
--  DDL for Table HISTORICAL_DATA_FOR_VEHICLES
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."HISTORICAL_DATA_FOR_VEHICLES" 
   (	"ID" NUMBER, 
	"VEHICLE_FOR_SALE_ID" NUMBER, 
	"INVOICE_ID" NUMBER, 
	"STATUS" VARCHAR2(255 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table INVOICE
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."INVOICE" 
   (	"ID" NUMBER, 
	"CUSTOMER_ID" NUMBER, 
	"VEHICLE_FOR_SALE_ID" NUMBER, 
	"FINAL_PRICE" NUMBER(10,2), 
	"PLUS" NUMBER(10,2), 
	"TAXES" NUMBER(10,2), 
	"LICENSE_FEES" NUMBER(10,2), 
	"SALES_PERSON_ID" NUMBER, 
	"TRADE_IN_VEHICLE_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table INVOICE_DETAIL
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."INVOICE_DETAIL" 
   (	"ID" NUMBER, 
	"INVOICE_ID" NUMBER, 
	"ACCESORIES_ID" NUMBER, 
	"COST" NUMBER(10,2)
   ) ;
--------------------------------------------------------
--  DDL for Table MANUFACTURES
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."MANUFACTURES" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(255 BYTE), 
	"ADDRESS" VARCHAR2(255 BYTE), 
	"CITY" VARCHAR2(255 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table NEW_VEHICLES
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."NEW_VEHICLES" 
   (	"ID" NUMBER, 
	"VEHICLE_FOR_SALE_ID" NUMBER, 
	"MANUFACTURE_ID" NUMBER, 
	"COST" NUMBER(10,2)
   ) ;
--------------------------------------------------------
--  DDL for Table SALES_PERSON
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."SALES_PERSON" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(255 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TRADE_IN_VEHICLES
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."TRADE_IN_VEHICLES" 
   (	"ID" NUMBER, 
	"VEHICLE_FOR_SALE_ID" NUMBER, 
	"COST" NUMBER(10,2), 
	"OTHER_DETAILS" VARCHAR2(255 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table VEHICLES
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."VEHICLES" 
   (	"ID" NUMBER, 
	"STATUS" VARCHAR2(36 BYTE), 
	"VIN" VARCHAR2(255 BYTE), 
	"NAME" VARCHAR2(255 BYTE) DEFAULT NULL, 
	"MODEL" VARCHAR2(11 BYTE) DEFAULT NULL, 
	"YEAR" VARCHAR2(255 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table VEHICLES_FOR_SALE
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."VEHICLES_FOR_SALE" 
   (	"ID" NUMBER, 
	"VEHICLE_ID" NUMBER, 
	"DESCRIPTION" VARCHAR2(255 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Sequence ACCESORIES_INVENTORY_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."ACCESORIES_INVENTORY_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 101 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence ACCESORIES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."ACCESORIES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 101 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence CUSTOMER_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."CUSTOMER_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence HISTORICAL_DATA_VEHICLES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."HISTORICAL_DATA_VEHICLES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 100 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence INVOICE_DETAIL_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."INVOICE_DETAIL_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 197 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence INVOICE_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."INVOICE_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 198 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence MANUFACTURE_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."MANUFACTURE_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 101 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence NEW_VEHICLES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."NEW_VEHICLES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 51 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SALES_PERSON_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."SALES_PERSON_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 6 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence TRADE_IN_VEHICLES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."TRADE_IN_VEHICLES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 51 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence VEHICLES_FOR_SALE_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."VEHICLES_FOR_SALE_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 51 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence VEHICLES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."VEHICLES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 51 NOCACHE  NOORDER  NOCYCLE ;
REM INSERTING into SYSTEM.ACCESORIES
SET DEFINE OFF;
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('1','9077','Aliquam adipiscing lobortis risus. In mi pede, nonummy ut, molestie','215188,57','385735,38','50');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('2','1754','montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque','173853,84','364218,47','24');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('3','8165','at, velit. Cras lorem lorem, luctus ut, pellentesque eget, dictum','272295,26','473442,7','37');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('4','9878','auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus','250359,78','651182,49','58');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('5','6931','aliquet molestie tellus. Aenean egestas hendrerit neque. In ornare sagittis','187732,25','355510,06','46');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('6','5017','neque et nunc. Quisque ornare tortor at risus. Nunc ac','296847,74','565575,8','14');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('7','4852','Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros.','266905,01','537681,23','6');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('8','7909','Mauris blandit enim consequat purus. Maecenas libero est, congue a,','190639,66','663587,79','8');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('9','4969','vulputate velit eu sem. Pellentesque ut ipsum ac mi eleifend','172580,22','524423,4','64');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('10','3766','dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae,','148924,43','359372,07','49');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('11','7774','nulla ante, iaculis nec, eleifend non, dapibus rutrum, justo. Praesent','138268,31','453520,71','3');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('12','7980','habitant morbi tristique senectus et netus et malesuada fames ac','271355,66','653231,14','100');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('13','9517','id, mollis nec, cursus a, enim. Suspendisse aliquet, sem ut','148810,38','673425,11','58');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('14','4105','ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet','258128,46','670837,35','25');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('15','5896','nulla. Donec non justo. Proin non massa non ante bibendum','233342,21','493010,96','43');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('16','7944','id ante dictum cursus. Nunc mauris elit, dictum eu, eleifend','271750,86','469091,35','91');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('17','2335','Curabitur dictum. Phasellus in felis. Nulla tempor augue ac ipsum.','107458,84','500764,06','49');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('18','3927','hendrerit id, ante. Nunc mauris sapien, cursus in, hendrerit consectetuer,','243490,29','672196,5','9');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('19','6352','pede. Praesent eu dui. Cum sociis natoque penatibus et magnis','257007,22','365299,37','1');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('20','9661','neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris eu turpis.','109294,67','693390,96','57');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('21','3386','eu erat semper rutrum. Fusce dolor quam, elementum at, egestas','250107,15','685850,91','33');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('22','9665','orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec','192994,22','546875,82','55');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('23','4346','vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu.','164620,05','640944,2','90');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('24','5191','tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh','250518,38','418700,91','28');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('25','9294','id sapien. Cras dolor dolor, tempus non, lacinia at, iaculis','201923,63','460436,1','21');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('26','7557','sodales purus, in molestie tortor nibh sit amet orci. Ut','203470,91','410543,86','21');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('27','5192','ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate,','289112,06','495390,27','7');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('28','4159','mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus.','154973,28','500550,13','54');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('29','5070','Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc','205397,02','662819,26','43');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('30','7404','Nullam velit dui, semper et, lacinia vitae, sodales at, velit.','161884,87','681834,04','67');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('31','8386','erat, eget tincidunt dui augue eu tellus. Phasellus elit pede,','196506,32','438890,43','65');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('32','5265','et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien,','253420','539394,3','2');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('33','8412','erat semper rutrum. Fusce dolor quam, elementum at, egestas a,','147406,46','383061,32','13');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('34','2345','mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam','180597,84','398277,84','85');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('35','9478','eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat','210875,1','670851,37','33');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('36','9248','nunc sed libero. Proin sed turpis nec mauris blandit mattis.','293037,96','556732,61','23');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('37','6149','risus, at fringilla purus mauris a nunc. In at pede.','260036,98','627579,3','37');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('38','7229','lorem, auctor quis, tristique ac, eleifend vitae, erat. Vivamus nisi.','171492,41','390078,96','31');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('39','9809','in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla','211255,26','578397,7','80');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('40','9936','magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna','243170,57','484745,61','64');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('41','1745','sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris','269101,56','355089,58','81');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('42','7271','Vestibulum ante ipsum primis in faucibus orci luctus et ultrices','204995,49','518336,37','89');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('43','1707','In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum','213430,71','567082,58','41');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('44','7263','erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor.','285361,25','409383,86','48');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('45','2392','sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus','199233,65','480051,8','37');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('46','8072','In mi pede, nonummy ut, molestie in, tempus eu, ligula.','223528,94','397061,23','59');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('47','3812','vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie','194211,71','591768,11','56');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('48','9718','blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae','220562,75','569043,37','88');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('49','7568','sem egestas blandit. Nam nulla magna, malesuada vel, convallis in,','254171,32','353544,74','82');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('50','1197','non magna. Nam ligula elit, pretium et, rutrum non, hendrerit','149005,18','482691,65','63');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('51','7987','eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus','215234,2','660786,5','77');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('52','1831','ac mattis velit justo nec ante. Maecenas mi felis, adipiscing','173212,66','667540,95','92');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('53','4016','ac libero nec ligula consectetuer rhoncus. Nullam velit dui, semper','215834,51','532013,23','71');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('54','5536','nec, leo. Morbi neque tellus, imperdiet non, vestibulum nec, euismod','149411,02','477245,76','99');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('55','1802','mauris a nunc. In at pede. Cras vulputate velit eu','126140,27','661769,12','23');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('56','2840','Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper','200834,75','511515,94','54');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('57','6546','urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum','274872,71','637555,44','13');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('58','7572','neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris eu turpis.','112013,69','443218,06','89');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('59','8981','bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus','113393,64','668504,26','40');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('60','7063','ut erat. Sed nunc est, mollis non, cursus non, egestas','191222,96','500278,02','1');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('61','2549','vel, vulputate eu, odio. Phasellus at augue id ante dictum','267832,16','463015,73','25');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('62','7333','velit. Pellentesque ultricies dignissim lacus. Aliquam rutrum lorem ac risus.','134657,13','577839,86','52');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('63','5117','egestas. Aliquam fringilla cursus purus. Nullam scelerisque neque sed sem','177903,84','684573,43','10');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('64','9438','urna, nec luctus felis purus ac tellus. Suspendisse sed dolor.','269397,76','559648,21','40');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('65','5337','Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit','281514,16','420044,15','53');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('66','8015','Integer urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla','233293,45','387367,48','21');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('67','1216','sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos.','213769,42','427472,01','55');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('68','3113','est. Nunc laoreet lectus quis massa. Mauris vestibulum, neque sed','271191,91','592331,94','53');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('69','6274','metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec','203082,98','557834,57','98');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('70','9907','quis accumsan convallis, ante lectus convallis est, vitae sodales nisi','157127,69','378669,67','19');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('71','9993','justo eu arcu. Morbi sit amet massa. Quisque porttitor eros','138070,4','364286,76','32');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('72','5740','ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam','220108,16','377167,93','37');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('73','3402','tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel,','244730,56','389865,67','54');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('74','3506','Mauris ut quam vel sapien imperdiet ornare. In faucibus. Morbi','143551,22','689220,21','97');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('75','3033','accumsan neque et nunc. Quisque ornare tortor at risus. Nunc','142072,42','390403,99','70');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('76','4782','ipsum cursus vestibulum. Mauris magna. Duis dignissim tempor arcu. Vestibulum','275383,65','643518,73','14');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('77','5308','quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod','103868,84','453813,72','90');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('78','9010','massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit','212283,04','586133,14','56');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('79','6706','malesuada fames ac turpis egestas. Fusce aliquet magna a neque.','278394,88','552287,22','90');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('80','9352','ante. Vivamus non lorem vitae odio sagittis semper. Nam tempor','262010,98','667899','31');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('81','8644','arcu. Morbi sit amet massa. Quisque porttitor eros nec tellus.','197346,14','643569,35','56');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('82','8324','non enim. Mauris quis turpis vitae purus gravida sagittis. Duis','193877,29','641079,53','84');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('83','7348','nibh. Donec est mauris, rhoncus id, mollis nec, cursus a,','195507,2','647937,05','54');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('84','9128','elit sed consequat auctor, nunc nulla vulputate dui, nec tempus','196096,71','464950,29','24');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('85','3321','turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy ut,','268758,94','649790,28','24');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('86','6454','semper auctor. Mauris vel turpis. Aliquam adipiscing lobortis risus. In','291171,3','463144,21','19');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('87','9650','auctor odio a purus. Duis elementum, dui quis accumsan convallis,','187181,8','437672,21','13');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('88','1476','eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce','299782,24','355822,82','40');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('89','9387','erat semper rutrum. Fusce dolor quam, elementum at, egestas a,','141661,62','425465,51','44');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('90','4461','arcu. Vivamus sit amet risus. Donec egestas. Aliquam nec enim.','252934,61','512119,6','5');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('91','8440','tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum','204996,9','432004','25');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('92','1250','diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent','121204,2','620892,45','9');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('93','1168','et, eros. Proin ultrices. Duis volutpat nunc sit amet metus.','102919,49','480178,76','7');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('94','1650','vitae semper egestas, urna justo faucibus lectus, a sollicitudin orci','129585,14','474874,01','15');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('95','6098','placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet,','263763,14','645787,42','56');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('96','3470','bibendum sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum,','210383,58','489093,84','27');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('97','5370','varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem','206470,88','517564,58','4');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('98','8386','urna convallis erat, eget tincidunt dui augue eu tellus. Phasellus','200009,91','362190,79','78');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('99','3181','purus sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam','172043,8','505318,39','65');
Insert into SYSTEM.ACCESORIES (ID,CODE,DESCRIPTION,COST,SELLING_PRICE,MANUFACURE_ID) values ('100','6941','euismod in, dolor. Fusce feugiat. Lorem ipsum dolor sit amet,','278085,11','551980,12','94');
REM INSERTING into SYSTEM.ACCESORIES_INVENTORY
SET DEFINE OFF;
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('1','1','21');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('2','2','17');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('3','3','28');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('4','4','6');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('5','5','8');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('6','6','22');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('7','7','40');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('8','8','48');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('9','9','18');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('10','10','26');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('11','11','10');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('12','12','14');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('13','13','26');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('14','14','9');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('15','15','2');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('16','16','5');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('17','17','40');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('18','18','22');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('19','19','36');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('20','20','31');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('21','21','47');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('22','22','38');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('23','23','8');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('24','24','18');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('25','25','1');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('26','26','15');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('27','27','31');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('28','28','1');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('29','29','3');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('30','30','37');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('31','31','7');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('32','32','2');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('33','33','3');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('34','34','6');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('35','35','41');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('36','36','38');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('37','37','48');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('38','38','20');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('39','39','5');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('40','40','5');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('41','41','18');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('42','42','25');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('43','43','41');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('44','44','47');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('45','45','29');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('46','46','50');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('47','47','39');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('48','48','23');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('49','49','18');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('50','50','39');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('51','51','22');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('52','52','33');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('53','53','27');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('54','54','47');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('55','55','22');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('56','56','14');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('57','57','2');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('58','58','5');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('59','59','46');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('60','60','46');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('61','61','29');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('62','62','49');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('63','63','20');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('64','64','17');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('65','65','47');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('66','66','17');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('67','67','13');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('68','68','4');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('69','69','50');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('70','70','5');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('71','71','41');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('72','72','37');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('73','73','1');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('74','74','43');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('75','75','31');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('76','76','31');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('77','77','21');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('78','78','3');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('79','79','6');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('80','80','4');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('81','81','50');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('82','82','23');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('83','83','24');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('84','84','13');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('85','85','36');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('86','86','11');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('87','87','3');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('88','88','22');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('89','89','46');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('90','90','10');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('91','91','38');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('92','92','11');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('93','93','37');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('94','94','50');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('95','95','20');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('96','96','39');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('97','97','17');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('98','98','16');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('99','99','7');
Insert into SYSTEM.ACCESORIES_INVENTORY (ID,ACCESORY_ID,UNITS_AVAILABLE) values ('100','100','2');
REM INSERTING into SYSTEM.CUSTOMER
SET DEFINE OFF;
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('1','Cody','Ap #730-7523 Euismod Rd.','1-809-860-5549');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('2','Rhonda','Ap #275-8514 Consectetuer Av.','1-524-963-0431');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('3','Armando','208-7117 Proin Rd.','1-837-587-6539');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('4','Regina','579-9578 Aliquam Rd.','1-153-896-6594');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('5','Tate','Ap #784-5647 Sed Rd.','1-299-940-9526');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('6','Orson','Ap #192-1757 In Road','1-272-611-8059');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('7','Chava','P.O. Box 643, 2485 Duis Rd.','1-452-493-5834');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('8','Jessica','P.O. Box 105, 4328 Malesuada Ave','1-384-690-5912');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('9','Lev','Ap #748-6966 Faucibus. Rd.','1-976-646-5941');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('10','Ulla','161-4415 Orci Avenue','1-183-642-8158');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('11','Rebecca','P.O. Box 566, 1017 Nulla Rd.','1-184-462-9304');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('12','Anjolie','P.O. Box 489, 4390 Augue, Ave','1-157-881-9091');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('13','Kaye','P.O. Box 361, 9112 Eu Rd.','1-103-886-5222');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('14','James','P.O. Box 358, 1335 Cras Av.','1-767-406-3600');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('15','Kevyn','9152 Sem, St.','1-731-177-0243');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('16','Bethany','3135 Enim Avenue','1-145-848-3990');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('17','Malachi','833-3797 Neque Ave','1-757-173-2061');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('18','Asher','4790 Adipiscing Rd.','1-998-366-7672');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('19','Eve','3204 Egestas. Av.','1-479-719-4357');
Insert into SYSTEM.CUSTOMER (ID,NAME,ADDRESS,PHONE) values ('20','Destiny','P.O. Box 561, 9434 Aliquam Road','1-723-101-1898');
REM INSERTING into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES
SET DEFINE OFF;
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('2','37','103','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('3','9','104','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('4','14','105','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('5','22','106','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('6','9','107','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('7','14','108','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('8','14','109','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('9','31','110','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('10','25','111','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('11','11','112','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('12','6','113','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('13','45','114','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('14','47','115','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('15','33','116','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('16','47','117','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('17','23','118','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('18','47','119','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('19','9','120','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('20','15','121','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('21','19','122','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('22','47','123','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('23','7','124','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('24','30','125','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('25','2','126','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('26','18','127','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('27','25','128','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('28','37','129','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('29','8','130','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('30','30','131','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('31','24','132','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('32','24','133','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('33','20','134','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('34','33','135','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('35','14','136','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('36','30','137','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('37','1','138','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('38','30','139','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('39','33','140','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('40','43','141','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('41','45','142','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('42','28','143','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('43','27','144','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('44','27','145','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('45','1','146','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('46','20','147','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('47','37','148','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('48','23','149','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('49','22','150','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('50','28','151','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('51','16','152','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('52','28','153','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('53','33','154','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('54','40','155','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('55','21','156','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('56','27','157','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('57','11','158','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('58','36','159','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('59','20','160','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('60','50','161','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('61','36','162','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('62','36','163','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('63','2','164','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('64','3','165','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('65','42','166','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('66','5','167','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('67','16','168','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('68','3','169','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('69','49','170','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('70','46','171','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('71','20','172','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('72','45','173','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('73','12','174','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('74','13','175','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('75','7','176','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('76','16','177','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('77','31','178','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('78','33','179','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('79','28','180','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('80','32','181','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('81','5','182','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('82','39','183','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('83','32','184','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('84','7','185','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('85','9','186','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('86','31','187','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('87','35','188','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('88','3','189','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('89','4','190','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('90','28','191','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('91','17','192','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('92','22','193','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('93','18','194','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('94','19','195','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('95','5','196','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('96','8','197','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('97','23','100','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('98','11','101','TRADE');
Insert into SYSTEM.HISTORICAL_DATA_FOR_VEHICLES (ID,VEHICLE_FOR_SALE_ID,INVOICE_ID,STATUS) values ('99','39','102','TRADE');
REM INSERTING into SYSTEM.INVOICE
SET DEFINE OFF;
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('103','9','37','1000540,12','88883','91042','158846','3','37');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('104','17','9','873577,44','58436','56525','121061','3','9');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('105','13','14','795063,3','59745','87311','108613','4','14');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('106','12','22','748409,35','57998','63623','157697','1','22');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('107','13','9','742943,76','64332','72686','125747','2','9');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('108','8','14','857052,4','72324','86107','174198','3','14');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('109','11','14','919832,2','54045','53923','170920','5','14');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('110','14','31','681350,67','79635','54858','156992','5','31');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('111','4','25','810671,3','88429','56701','126147','3','25');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('112','9','11','713549,32','73460','69381','187647','5','11');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('113','20','6','659790,76','59106','92415','143983','5','6');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('114','1','45','1006551,79','59544','92613','190807','1','45');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('115','14','47','751753,51','89299','64378','172611','2','47');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('116','15','33','689257,32','97011','78993','130192','1','33');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('117','6','47','968722,45','71408','91157','185265','4','47');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('118','5','23','746201,35','53015','89811','134284','3','23');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('119','12','47','974381,28','74888','92281','157422','1','47');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('120','9','9','936739,26','99580','66800','101855','2','9');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('121','5','15','918761,7','63788','89714','186862','1','15');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('122','3','19','732488,67','71475','87201','183947','4','19');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('123','10','47','838764,37','90983','79270','150175','3','47');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('124','6','7','937095,79','52369','90434','130705','3','7');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('125','14','30','855423,84','79929','99626','186775','3','30');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('126','15','2','830745,58','77636','76901','109126','3','2');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('127','3','18','909369,37','55262','94708','190356','4','18');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('128','12','25','794364,27','91802','91087','116085','3','25');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('129','4','37','726107,43','65112','65139','156966','1','37');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('130','4','8','671476,84','54694','97808','120697','5','8');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('131','11','30','824558,02','98381','97807','128092','3','30');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('132','16','24','727027,35','52363','74005','131568','5','24');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('133','10','24','949447,42','96789','77839','129032','3','24');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('134','4','20','732147,06','53404','84313','151212','3','20');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('135','10','33','736043,93','83545','96791','178540','5','33');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('136','11','14','978491,14','83026','98724','143510','3','14');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('137','20','30','939505,04','62334','88981','106356','4','30');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('138','13','1','793059,6','94265','51238','135437','3','1');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('139','14','30','781730,23','88045','55587','100417','2','30');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('140','4','33','828016,27','94885','93475','144266','3','33');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('141','16','43','608718,58','68861','57657','127111','3','43');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('142','15','45','893277,3','84327','74736','106635','3','45');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('143','13','28','802707,96','82280','82892','144525','1','28');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('144','15','27','772465,76','54849','65511','171927','4','27');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('145','12','27','698007,43','74256','82369','102492','4','27');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('146','7','1','705373,67','99671','53880','173153','5','1');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('147','8','20','801477,84','81385','93391','137608','4','20');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('148','1','37','849091,82','98198','66226','137792','5','37');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('149','2','23','693689,23','50021','53257','193350','5','23');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('150','9','22','887024,7','98111','87731','122785','2','22');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('151','10','28','1047270,35','93738','86751','195944','4','28');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('152','14','16','832785,65','73314','93516','183264','5','16');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('153','1','28','753987,1','69329','69394','154828','1','28');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('154','6','33','793944,02','99802','68481','125383','5','33');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('155','9','40','626140,93','58775','53180','137018','2','40');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('156','2','21','850471,3','89730','85784','135563','1','21');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('157','8','27','985478,5','51727','75427','197538','2','27');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('158','4','11','688230,47','72246','62777','188989','1','11');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('159','18','36','970387,53','85253','53905','190150','1','36');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('160','1','20','738099,73','56948','88320','129816','4','20');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('161','4','50','670026,74','93653','98096','124733','5','50');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('162','18','36','841830,23','79910','95984','133923','4','36');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('163','9','36','973940,2','75878','95280','161838','3','36');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('164','12','2','953678,5','58858','61718','160906','4','2');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('165','8','3','997787,04','86514','54436','175003','3','3');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('166','13','42','955095,49','98481','86655','118777','1','42');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('167','6','5','722650,86','99074','86500','127693','2','5');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('168','5','16','768986,39','60522','64984','138162','5','16');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('169','14','3','800282,58','61229','69079','152410','3','3');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('170','14','49','1030760,42','99301','97162','188510','3','49');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('171','2','46','780433,06','62249','93599','181367','4','46');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('172','15','20','651162,32','70719','63470','133912','1','20');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('173','3','45','896124,5','58600','76058','100680','2','45');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('174','17','12','761183,39','58165','76594','121106','1','12');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('175','16','13','980852,95','99470','97934','115908','2','13');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('176','10','7','921230,94','69197','75243','184459','5','7');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('177','7','16','792581,37','93283','64632','116330','4','16');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('178','15','31','692276,96','81795','72458','147945','2','31');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('179','6','33','955728,26','82566','67399','142944','4','33');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('180','20','28','673271,58','68039','72980','177163','4','28');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('181','18','32','972645','55368','98331','151047','5','32');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('182','10','5','762388,02','64032','77469','120609','5','5');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('183','11','39','681852,99','64449','52439','174561','5','39');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('184','4','32','912923,12','55222','88092','107840','1','32');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('185','14','7','821696,76','71736','81359','188423','2','7');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('186','4','9','841592,3','94607','88438','119153','1','9');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('187','15','31','906624,11','91878','56138','166840','3','31');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('188','5','35','676522,23','51877','57948','169636','4','35');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('189','6','3','962922,26','85443','89602','119373','3','3');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('190','16','4','761471,76','84597','51661','147968','1','4');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('191','9','28','667348,93','66899','91217','132065','4','28');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('192','1','17','830756,72','97640','87908','191395','3','17');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('193','14','22','854945,58','67211','73477','147175','5','22');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('194','18','18','974127,26','83207','59508','168593','2','18');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('195','3','19','659309,86','74706','66270','108950','2','19');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('196','1','5','655927,67','97059','50780','129419','5','5');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('197','16','8','855298,7','74249','64679','137973','5','8');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('100','1','23','742150,15','85701','87074','149331','1','23');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('101','7','11','983786,3','87414','88144','180649','5','11');
Insert into SYSTEM.INVOICE (ID,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) values ('102','16','39','604618,07','70712','69740','104794','3','39');
REM INSERTING into SYSTEM.INVOICE_DETAIL
SET DEFINE OFF;
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('102','103','55','661769,12');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('103','104','57','637555,44');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('104','105','32','539394,3');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('105','106','16','469091,35');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('106','107','93','480178,76');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('107','108','9','524423,4');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('108','109','23','640944,2');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('109','110','73','389865,67');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('110','111','32','539394,3');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('111','112','33','383061,32');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('112','113','71','364286,76');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('113','114','8','663587,79');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('114','115','89','425465,51');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('115','116','33','383061,32');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('116','117','92','620892,45');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('117','118','16','469091,35');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('118','119','85','649790,28');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('119','120','59','668504,26');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('120','121','39','578397,7');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('121','122','73','389865,67');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('122','123','42','518336,37');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('123','124','8','663587,79');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('124','125','96','489093,84');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('125','126','43','567082,58');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('126','127','48','569043,37');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('127','128','27','495390,27');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('128','129','31','438890,43');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('129','130','34','398277,84');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('130','131','60','500278,02');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('131','132','16','469091,35');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('132','133','95','645787,42');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('133','134','58','443218,06');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('134','135','72','377167,93');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('135','136','12','653231,14');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('136','137','30','681834,04');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('137','138','90','512119,6');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('138','139','7','537681,23');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('139','140','27','495390,27');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('140','141','41','355089,58');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('141','142','37','627579,3');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('142','143','15','493010,96');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('143','144','93','480178,76');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('144','145','31','438890,43');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('145','146','70','378669,67');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('146','147','96','489093,84');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('147','148','22','546875,82');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('148','149','46','397061,23');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('149','150','39','578397,7');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('150','151','14','670837,35');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('151','152','50','482691,65');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('152','153','25','460436,1');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('153','154','60','500278,02');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('154','155','72','377167,93');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('155','156','32','539394,3');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('156','157','51','660786,5');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('157','158','2','364218,47');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('158','159','82','641079,53');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('159','160','61','463015,73');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('160','161','49','353544,74');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('161','162','53','532013,23');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('162','163','23','640944,2');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('163','164','18','672196,5');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('164','165','30','681834,04');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('165','166','4','651182,49');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('166','167','44','409383,86');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('167','168','99','505318,39');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('168','169','97','517564,58');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('169','170','95','645787,42');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('170','171','58','443218,06');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('171','172','33','383061,32');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('172','173','51','660786,5');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('173','174','99','505318,39');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('174','175','52','667540,95');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('175','176','68','592331,94');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('176','177','42','518336,37');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('177','178','38','390078,96');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('178','179','29','662819,26');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('179','180','41','355089,58');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('180','181','80','667899');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('181','182','60','500278,02');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('182','183','75','390403,99');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('183','184','55','661769,12');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('184','185','93','480178,76');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('185','186','32','539394,3');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('186','187','47','591768,11');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('187','188','46','397061,23');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('188','189','59','668504,26');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('189','190','54','477245,76');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('190','191','72','377167,93');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('191','192','77','453813,72');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('192','193','43','567082,58');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('193','194','29','662819,26');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('194','195','44','409383,86');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('195','196','70','378669,67');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('196','197','39','578397,7');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('99','100','65','420044,15');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('100','101','37','627579,3');
Insert into SYSTEM.INVOICE_DETAIL (ID,INVOICE_ID,ACCESORIES_ID,COST) values ('101','102','10','359372,07');
REM INSERTING into SYSTEM.MANUFACTURES
SET DEFINE OFF;
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('1','Elit Erat Vitae Company','883-4455 Amet Avda.','Vetlanda');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('2','Tortor Nunc Company','Apartado núm.: 444, 6248 Tortor Avenida','Fabro');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('3','In Cursus Et LLP','Apartado núm.: 171, 1761 Auctor Ctra.','Blenheim');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('4','In Incorporated','289-913 Elit. C/','Zoetermeer');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('5','Ornare Facilisis Eget Industries','472-8025 Sapien, Avenida','Gravataí');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('6','Lacus Etiam Bibendum PC','1238 Nec Calle','Paglieta');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('7','Euismod In Dolor Ltd','Apartado núm.: 631, 6138 Metus ','Columbus');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('8','Mus Company','Apdo.:581-5458 Tellus, Ctra.','Paternopoli');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('9','Quis Company','Apartado núm.: 621, 7102 Velit C/','Sgonico');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('10','Et Netus Inc.','5005 Nec, Av.','Colomiers');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('11','Suspendisse Sed Dolor Industries','2042 Iaculis C.','Carunchio');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('12','Nullam Ut Nisi Limited','Apartado núm.: 337, 5759 In Avda.','Idaho Falls');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('13','Lorem Ut Aliquam LLC','324-9285 Non ','Solre-Saint-GŽry');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('14','Commodo Consulting','781-1426 Molestie ','Schönebeck');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('15','Morbi Limited','361-6844 Ridiculus Ctra.','Molfetta');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('16','Eleifend Foundation','Apdo.:396-7504 Consectetuer Calle','Atlanta');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('17','Ridiculus Mus Consulting','200-9616 Risus Carretera','Ponte nelle Alpi');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('18','Cursus Associates','Apartado núm.: 440, 5357 Tristique C.','Bernburg');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('19','Malesuada Consulting','265-4272 Nibh Avda.','Lerum');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('20','Eros Incorporated','Apartado núm.: 647, 7731 Egestas Carretera','Calder');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('21','Nullam Enim Corp.','8026 Iaculis Avenida','Langholm');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('22','Ut Pharetra LLC','Apdo.:772-3077 Cras C/','Thames');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('23','Aliquam Ornare Consulting','6438 Eu Ctra.','Sirsa');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('24','Felis Adipiscing Company','942 Ante Calle','Workum');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('25','Congue Elit Sed PC','786-3511 Mi ','Kraków');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('26','Ultricies Ligula Institute','437-732 Quam. Avda.','Cessnock');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('27','Suspendisse Commodo Tincidunt Foundation','Apartado núm.: 561, 1918 Auctor Avenida','Lake Cowichan');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('28','Id Corporation','9104 Tincidunt, C.','Parramatta');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('29','Porttitor Ltd','786-1308 Vel C/','Dégelis');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('30','Ad Ltd','Apartado núm.: 171, 2609 Convallis C/','Cagli');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('31','Ut Molestie In Industries','3419 Malesuada C/','Barrie');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('32','At Auctor Ullamcorper Industries','Apartado núm.: 245, 6502 Amet Carretera','Spaniard''s Bay');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('33','Dolor LLC','475-967 Non Ctra.','St. Clears');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('34','Vel Nisl LLC','959 Est Avda.','Laarne');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('35','Nunc Associates','Apartado núm.: 111, 3237 Sed C.','Sutton');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('36','Libero Institute','Apdo.:503-3321 Risus. Calle','Cuenca');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('37','Magna Ltd','313-2959 Aliquam Av.','Curanilahue');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('38','Velit In Aliquet LLP','Apartado núm.: 859, 834 Consequat C.','Körfez');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('39','Aenean Gravida Limited','389-7842 Mauris Carretera','Belgrade');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('40','Nunc Est Mollis Inc.','Apdo.:384-6572 Consequat, C/','Westmalle');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('41','Pellentesque Tellus Sem Limited','Apartado núm.: 564, 2739 A, Avenida','Stratford');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('42','Semper Inc.','8798 Lobortis, ','Melle');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('43','Rutrum LLC','Apartado núm.: 628, 6322 Molestie. Avenida','Maidstone');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('44','Litora Torquent Per PC','Apdo.:546-1743 Elit Avda.','San Piero a Sieve');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('45','Cursus Institute','Apartado núm.: 168, 6760 Sem Ctra.','Zamo??');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('46','Enim Non Nisi Associates','6386 Facilisis Avenida','Ambresin');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('47','Rhoncus Id Associates','1907 Ultrices C.','Upplands Väsby');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('48','Et Tristique Pellentesque LLC','Apdo.:547-3151 Elementum, ','Eckernförde');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('49','Vel Company','8747 Pharetra, Av.','Koninksem');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('50','Ac PC','Apartado núm.: 157, 8859 Sed, C/','Melazzo');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('51','Arcu Eu Institute','Apartado núm.: 963, 1088 Non Avda.','Cinco Esquinas');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('52','Non Enim Mauris Company','Apdo.:762-317 Sodales Avenida','San Benedetto del Tronto');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('53','Rhoncus Proin Foundation','5821 Elementum Avenida','Hoorn');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('54','Ornare Ltd','712-7980 Sed Av.','Roccamena');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('55','Erat Incorporated','Apdo.:944-300 Molestie ','Eigenbrakel');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('56','Duis Dignissim Tempor Inc.','7524 Orci Av.','Alessandria');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('57','Parturient Inc.','6712 Dolor. Av.','Duncan');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('58','Phasellus PC','Apdo.:820-2696 Mauris ','Rotterdam');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('59','Consectetuer Euismod Limited','Apdo.:529-1376 Est. Ctra.','Ibadan');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('60','Et Associates','3150 Mollis. C/','Firozabad');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('61','Pellentesque Tincidunt Foundation','Apdo.:675-1649 Ac, C.','Putaendo');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('62','Non Bibendum Incorporated','2875 Quam C/','Morhet');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('63','Tellus Industries','4669 Fusce Avda.','Sant''Elia a Pianisi');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('64','Tincidunt Company','490 Risus. Avenida','Butte');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('65','Rhoncus Id Mollis Company','Apdo.:795-1814 Accumsan Avenida','Esen');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('66','Nec Ltd','Apartado núm.: 172, 6688 Risus, Av.','Rossignol');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('67','Nec Euismod Consulting','Apdo.:442-4806 Vulputate, Carretera','Bhuj');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('68','Erat Neque Non Inc.','4779 Sodales C.','Rae-Edzo');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('69','Elit Pede Institute','Apartado núm.: 423, 9444 Suspendisse Avda.','Tübingen');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('70','Velit Aliquam Industries','514-6838 Tincidunt C/','Frankfurt');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('71','Scelerisque Dui Corp.','311-5554 Diam Carretera','Lauw');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('72','In Faucibus Industries','Apdo.:360-550 Lorem, C/','Dunoon');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('73','Ridiculus Corp.','Apdo.:512-6365 Nonummy Calle','Cumberland');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('74','Tempor Diam LLC','Apdo.:684-2636 Donec C/','Todi');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('75','Adipiscing Enim Mi Corp.','Apdo.:673-6099 Nibh. C/','Miramichi');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('76','Quam Pellentesque Ltd','997-4994 Ante. ','Souvret');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('77','Ipsum Ltd','4589 Iaculis Calle','Comblain-au-Pont');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('78','Lorem Ipsum Dolor Company','698-9391 In, C.','Cavasso Nuovo');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('79','Ornare In Incorporated','Apartado núm.: 711, 2891 Fames C.','Sint-Kruis');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('80','Ipsum Donec Consulting','4216 Nisi Avda.','Annapolis');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('81','Facilisis Limited','Apartado núm.: 760, 4768 Malesuada Calle','Sint-Pieters-Woluwe');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('82','Ornare Ltd','Apdo.:412-9024 Eu Carretera','Abbateggio');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('83','Sed Corporation','Apdo.:515-9974 Aliquam Avenida','Kalken');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('84','Diam Sed Inc.','Apdo.:576-6464 Egestas C.','Antofagasta');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('85','Sit Incorporated','8449 Ante. C/','Town of Yarmouth');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('86','Proin Non Corp.','1441 Dictum C.','Pica');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('87','Non Lorem LLP','4999 Sociis Ctra.','Lozzo Atestino');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('88','Sed Neque Sed Consulting','687-6701 Accumsan ','Wroc?aw');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('89','Felis Eget Ltd','Apdo.:652-9513 Libero. Calle','Gorzów Wielkopolski');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('90','Porttitor Tellus Non Limited','Apdo.:224-3581 Dui, Av.','Montemignaio');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('91','Semper Dui Lectus Ltd','Apdo.:556-3352 Dui Av.','Bargagli');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('92','Non Leo Industries','389-8279 Nec Av.','Stewart');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('93','Sit Amet Ultricies LLP','765-8109 Ligula. Avda.','Wimbledon');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('94','At Velit Cras Corp.','8584 Mollis Av.','Arbre');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('95','Penatibus Et Magnis Consulting','771-1332 Facilisis, Carretera','Polpenazze del Garda');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('96','Elit A Feugiat Foundation','Apdo.:792-4433 Aliquam C.','Tongue');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('97','Magna Corp.','Apartado núm.: 272, 1253 Faucibus. Avda.','Marystown');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('98','Elit Pharetra Ut Ltd','Apdo.:278-426 Nisi. Carretera','Harnoncourt');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('99','Porttitor Vulputate PC','4543 Aliquam Avenida','Trento');
Insert into SYSTEM.MANUFACTURES (ID,NAME,ADDRESS,CITY) values ('100','Augue Institute','310-2856 Duis ','Bergen op Zoom');
REM INSERTING into SYSTEM.NEW_VEHICLES
SET DEFINE OFF;
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('1','1','1','49220881,86');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('2','2','2','65902308,5');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('3','3','3','66140526,09');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('4','4','4','47714693,56');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('5','5','5','63347723,68');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('6','6','6','31612120,83');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('7','7','7','17164970,58');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('8','8','8','34253901,84');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('9','9','9','51605015,07');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('10','10','10','26423445,32');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('11','11','11','58629496,81');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('12','12','12','51411917,53');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('13','13','13','67523003,58');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('14','14','14','52809371,68');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('15','15','15','34733482,6');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('16','16','16','49468496,33');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('17','17','17','56458997,78');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('18','18','18','64045452,28');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('19','19','19','52363171,63');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('20','20','20','33659852,22');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('21','21','21','49421792');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('22','22','22','35997344,82');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('23','23','23','23042638,86');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('24','24','24','53049661,53');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('25','25','25','35596598,04');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('26','26','26','66894661,76');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('27','27','27','26400389,43');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('28','28','28','48879012,7');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('29','29','29','54859337,3');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('30','30','30','47753286,7');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('31','31','31','63172345,88');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('32','32','32','47187069,87');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('33','33','33','17070828,87');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('34','34','34','26642367,63');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('35','35','35','45987196,2');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('36','36','36','39356001,08');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('37','37','37','32527956,3');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('38','38','38','29024609,19');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('39','39','39','15283799,95');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('40','40','40','32066314,96');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('41','41','41','41304294,12');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('42','42','42','49467793,66');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('43','43','43','67092158,6');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('44','44','44','55483824,58');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('45','45','45','62539457,27');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('46','46','46','20283091,36');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('47','47','47','67605950,33');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('48','48','48','48524139,32');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('49','49','49','44222452,64');
Insert into SYSTEM.NEW_VEHICLES (ID,VEHICLE_FOR_SALE_ID,MANUFACTURE_ID,COST) values ('50','50','50','22032444,67');
REM INSERTING into SYSTEM.SALES_PERSON
SET DEFINE OFF;
Insert into SYSTEM.SALES_PERSON (ID,NAME) values ('1','Kimberley');
Insert into SYSTEM.SALES_PERSON (ID,NAME) values ('2','Leila');
Insert into SYSTEM.SALES_PERSON (ID,NAME) values ('3','Desirae');
Insert into SYSTEM.SALES_PERSON (ID,NAME) values ('4','Callie');
Insert into SYSTEM.SALES_PERSON (ID,NAME) values ('5','Raphael');
REM INSERTING into SYSTEM.TRADE_IN_VEHICLES
SET DEFINE OFF;
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('1','1','50914503,8','dignissim. Maecenas ornare egestas ligula.');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('2','2','42068874,73','hendrerit consectetuer, cursus et, magna.');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('3','3','38599313,8','consequat purus. Maecenas libero est,');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('4','4','28570380,41','velit. Cras lorem lorem, luctus');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('5','5','46676790,07','penatibus et magnis dis parturient');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('6','6','54653807,43','Integer urna. Vivamus molestie dapibus');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('7','7','20651034,58','ut lacus. Nulla tincidunt, neque');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('8','8','57708666,66','bibendum. Donec felis orci, adipiscing');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('9','9','29697341,5','dolor vitae dolor. Donec fringilla.');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('10','10','62893977,68','Sed eget lacus. Mauris non');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('11','11','40654515,33','at, iaculis quis, pede. Praesent');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('12','12','21188338,99','ante. Vivamus non lorem vitae');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('13','13','23839989,83','sem. Pellentesque ut ipsum ac');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('14','14','49331108,62','Nam consequat dolor vitae dolor.');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('15','15','24894502,17','semper erat, in consectetuer ipsum');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('16','16','67418639,39','nibh. Quisque nonummy ipsum non');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('17','17','20976859,06','venenatis lacus. Etiam bibendum fermentum');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('18','18','48597364,77','non, bibendum sed, est. Nunc');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('19','19','55708665,11','non, egestas a, dui. Cras');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('20','20','24100292,43','orci luctus et ultrices posuere');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('21','21','50353889,95','Proin velit. Sed malesuada augue');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('22','22','23065720,54','nec, cursus a, enim. Suspendisse');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('23','23','56596866,96','imperdiet non, vestibulum nec, euismod');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('24','24','35716589,46','primis in faucibus orci luctus');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('25','25','52755960,47','justo. Proin non massa non');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('26','26','31541260,39','cubilia Curae; Donec tincidunt. Donec');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('27','27','26372067,05','Vivamus molestie dapibus ligula. Aliquam');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('28','28','34439860,6','pellentesque, tellus sem mollis dui,');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('29','29','41746154,32','vitae erat vel pede blandit');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('30','30','35340529,69','commodo auctor velit. Aliquam nisl.');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('31','31','43959203,04','fermentum risus, at fringilla purus');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('32','32','23010314,24','ut eros non enim commodo');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('33','33','35768517,08','eget, venenatis a, magna. Lorem');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('34','34','20588859,6','habitant morbi tristique senectus et');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('35','35','20816879,5','commodo auctor velit. Aliquam nisl.');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('36','36','66517063,79','nunc, ullamcorper eu, euismod ac,');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('37','37','31342145,99','quis, tristique ac, eleifend vitae,');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('38','38','61828583,02','amet orci. Ut sagittis lobortis');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('39','39','63822248,5','pede. Cras vulputate velit eu');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('40','40','45285680,8','massa rutrum magna. Cras convallis');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('41','41','18610929,37','ipsum primis in faucibus orci');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('42','42','67691043,57','nibh. Donec est mauris, rhoncus');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('43','43','50833918,96','mauris eu elit. Nulla facilisi.');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('44','44','18942135,51','consectetuer euismod est arcu ac');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('45','45','54490383,17','accumsan sed, facilisis vitae, orci.');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('46','46','19547307,28','enim. Suspendisse aliquet, sem ut');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('47','47','68392850,53','non nisi. Aenean eget metus.');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('48','48','62411036,4','habitant morbi tristique senectus et');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('49','49','16460147,84','vitae odio sagittis semper. Nam');
Insert into SYSTEM.TRADE_IN_VEHICLES (ID,VEHICLE_FOR_SALE_ID,COST,OTHER_DETAILS) values ('50','50','30642436,84','dolor elit, pellentesque a, facilisis');
REM INSERTING into SYSTEM.VEHICLES
SET DEFINE OFF;
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('1','NEW','16751024-8839','Mauris nulla. Integer urna. Vivamus molestie dapibus','379508','2005');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('2','NEW','16970501-0743','turpis egestas. Aliquam fringilla cursus','354991','2018');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('3','NEW','16761203-7692','laoreet lectus quis massa. Mauris vestibulum, neque sed dictum eleifend, nunc risus varius orci, in','955928','2016');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('4','NEW','16040308-8941','odio semper cursus. Integer mollis. Integer tincidunt aliquam arcu. Aliquam ultrices','433438','2009');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('5','NEW','16360530-6285','vestibulum. Mauris magna. Duis dignissim tempor arcu.','978729','2015');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('6','USED','16121107-9890','magna tellus faucibus leo, in lobortis tellus justo sit amet nulla. Donec non justo.','687622','2017');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('7','USED','16900129-2979','odio vel est tempor bibendum. Donec felis orci, adipiscing non, luctus','200855','2006');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('8','USED','16961118-3519','et,','466367','2008');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('9','USED','16130413-6813','at pede. Cras','224791','2014');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('10','USED','16210913-9168','mauris. Integer sem elit, pharetra ut,','840158','2005');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('11','NEW','16601028-1704','molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean','770679','2001');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('12','NEW','16891208-3154','convallis ligula. Donec','881088','2018');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('13','NEW','16220425-6610','torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam','521644','2017');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('14','NEW','16130828-8420','sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum magna. Cras convallis convallis dolor. Quisque tincidunt pede','882387','2010');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('15','NEW','16860208-0973','Nulla facilisi. Sed neque. Sed eget','474147','2014');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('16','USED','16460204-9142','vulputate eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris elit, dictum eu,','579522','2012');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('17','USED','16431209-7019','dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut','786702','2005');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('18','USED','16710420-1046','dolor. Quisque tincidunt pede ac urna. Ut tincidunt vehicula risus. Nulla','999084','2005');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('19','USED','16881221-2754','Sed pharetra, felis eget varius ultrices, mauris ipsum porta elit, a','632092','2002');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('20','USED','16410503-4393','lorem ut aliquam iaculis, lacus pede sagittis augue, eu tempor erat neque non quam.','820968','2002');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('21','NEW','16491109-9358','Vivamus non lorem vitae odio sagittis semper. Nam tempor diam','713322','2002');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('22','NEW','16421112-6075','vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia.','844001','2018');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('23','NEW','16920424-1302','nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas','361396','2001');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('24','NEW','16700602-0650','blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed consequat','822584','2010');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('25','NEW','16010517-4957','mauris a nunc. In at pede. Cras vulputate velit eu sem. Pellentesque ut ipsum ac mi','487153','2005');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('26','USED','16780601-9381','dolor','347905','2000');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('27','USED','16320708-1484','ac mattis velit justo nec ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate,','476050','2012');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('28','USED','16631006-7274','nec luctus felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et,','150289','2014');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('29','USED','16000429-3205','Quisque','539346','2001');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('30','USED','16740317-8374','fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a,','711997','2016');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('31','NEW','16470610-1328','a felis ullamcorper viverra. Maecenas iaculis','212808','2005');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('32','NEW','16970704-5101','vel est tempor bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus ut, nulla. Cras','346323','2001');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('33','NEW','16210802-8347','pellentesque, tellus sem mollis','454930','2007');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('34','NEW','16730506-0191','erat, in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque','246366','2008');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('35','NEW','16140915-5965','vehicula risus. Nulla eget metus eu erat semper rutrum. Fusce dolor quam, elementum','922600','2010');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('36','USED','16480404-9981','sapien. Aenean massa. Integer vitae nibh. Donec est mauris, rhoncus id,','431787','2006');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('37','USED','16740111-8331','magna, malesuada vel, convallis in, cursus et, eros. Proin ultrices.','251734','2013');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('38','USED','16750718-5788','ut, molestie in, tempus eu,','872104','2011');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('39','USED','16120814-5621','ipsum leo elementum sem, vitae aliquam eros turpis non enim.','656173','2006');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('40','USED','16671004-7405','urna. Nullam lobortis quam a felis ullamcorper','247175','2013');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('41','NEW','16030506-1160','sit amet, risus. Donec nibh','692276','2015');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('42','NEW','16080426-9629','nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu.','517571','2014');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('43','NEW','16380402-6619','egestas blandit.','995080','2001');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('44','NEW','16061029-5677','Proin vel nisl. Quisque fringilla euismod enim. Etiam','388274','2002');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('45','NEW','16490221-6458','et','827922','2005');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('46','USED','16801104-3992','nisi','783081','2003');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('47','USED','16830823-6085','et magnis dis parturient','787402','201200');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('48','USED','16980323-3429','Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra.','723070','201400');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('49','USED','16620122-3069','pede. Nunc sed','349725','2017');
Insert into SYSTEM.VEHICLES (ID,STATUS,VIN,NAME,MODEL,YEAR) values ('50','USED','16360414-5460','metus. Aliquam erat volutpat. Nulla facilisis.','997551','2000');
REM INSERTING into SYSTEM.VEHICLES_FOR_SALE
SET DEFINE OFF;
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('1','1','magnis dis parturient');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('2','2','ac facilisis facilisis, magna');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('3','3','Maecenas libero est, congue a,');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('4','4','Mauris vel');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('5','5','amet, risus. Donec nibh enim, gravida sit amet,');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('6','6','condimentum eget, volutpat');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('7','7','in molestie');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('8','8','eget massa. Suspendisse eleifend. Cras');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('9','9','tellus');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('10','10','mauris ut mi. Duis risus odio, auctor vitae, aliquet nec,');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('11','11','Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu.');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('12','12','sem ut dolor');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('13','13','Sed et libero. Proin mi. Aliquam');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('14','14','eu augue porttitor interdum. Sed auctor odio');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('15','15','vulputate');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('16','16','pellentesque. Sed');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('17','17','at, nisi. Cum sociis natoque penatibus et magnis');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('18','18','sem, consequat nec, mollis vitae, posuere at, velit. Cras lorem');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('19','19','tellus, imperdiet non, vestibulum nec, euismod in,');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('20','20','ornare. Fusce mollis. Duis sit amet diam eu dolor');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('21','21','auctor vitae, aliquet nec, imperdiet nec, leo.');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('22','22','convallis in, cursus et, eros. Proin ultrices. Duis');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('23','23','Pellentesque');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('24','24','risus. Duis a');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('25','25','blandit at, nisi. Cum sociis natoque penatibus et');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('26','26','velit justo nec ante. Maecenas');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('27','27','In at pede. Cras vulputate velit');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('28','28','accumsan convallis, ante');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('29','29','orci lobortis augue scelerisque mollis. Phasellus libero mauris, aliquam eu,');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('30','30','non ante');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('31','31','sed');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('32','32','pellentesque eget, dictum placerat, augue.');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('33','33','arcu. Vivamus sit amet risus. Donec egestas. Aliquam');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('34','34','quam dignissim pharetra. Nam ac nulla. In tincidunt congue');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('35','35','pede blandit congue. In scelerisque scelerisque dui. Suspendisse');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('36','36','at');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('37','37','in magna. Phasellus dolor elit, pellentesque a, facilisis non,');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('38','38','aliquet, sem ut');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('39','39','sem mollis dui, in sodales elit');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('40','40','vitae risus. Duis a mi');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('41','41','dolor');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('42','42','et magnis dis parturient montes, nascetur ridiculus');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('43','43','Nulla semper tellus id');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('44','44','vel nisl. Quisque fringilla euismod enim. Etiam gravida');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('45','45','arcu.');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('46','46','lacus. Ut nec urna et');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('47','47','Sed molestie. Sed id risus');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('48','48','Duis cursus, diam at pretium aliquet,');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('49','49','ac urna. Ut tincidunt vehicula risus. Nulla eget metus');
Insert into SYSTEM.VEHICLES_FOR_SALE (ID,VEHICLE_ID,DESCRIPTION) values ('50','50','magna nec quam. Curabitur vel lectus.');
REM INSERTING into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS
SET DEFINE OFF;
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('32','et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien,','5265','Tortor Nunc Company','2');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('87','auctor odio a purus. Duis elementum, dui quis accumsan convallis,','9650','Lorem Ut Aliquam LLC','3');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('57','urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum','6546','Lorem Ut Aliquam LLC','2');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('33','erat semper rutrum. Fusce dolor quam, elementum at, egestas a,','8412','Lorem Ut Aliquam LLC','3');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('25','id sapien. Cras dolor dolor, tempus non, lacinia at, iaculis','9294','Nullam Enim Corp.','1');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('80','ante. Vivamus non lorem vitae odio sagittis semper. Nam tempor','9352','Ut Molestie In Industries','4');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('29','Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc','5070','Rutrum LLC','3');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('15','nulla. Donec non justo. Proin non massa non ante bibendum','5896','Rutrum LLC','2');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('68','est. Nunc laoreet lectus quis massa. Mauris vestibulum, neque sed','3113','Rhoncus Proin Foundation','4');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('73','tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel,','3402','Ornare Ltd','1');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('28','mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus.','4159','Ornare Ltd','1');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('78','massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit','9010','Duis Dignissim Tempor Inc.','3');
Insert into SYSTEM.ACCESORIES_UNDER_FIVE_UNITS (ID,NAME,CODE,MANUFACTURER,UNITS_AVAILABLE) values ('100','euismod in, dolor. Fusce feugiat. Lorem ipsum dolor sit amet,','6941','At Velit Cras Corp.','2');
REM INSERTING into SYSTEM.INFO_INVOICE
SET DEFINE OFF;
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('158','1','Kimberley','4','Regina','11','770679','Suspendisse Sed Dolor Industries','2','montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('166','1','Kimberley','13','Kaye','42','517571','Semper Inc.','4','auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('139','2','Leila','14','James','30','711997','Ad Ltd','7','Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('124','3','Desirae','6','Orson','7','200855','Euismod In Dolor Ltd','8','Mauris blandit enim consequat purus. Maecenas libero est, congue a,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('114','1','Kimberley','1','Cody','45','827922','Cursus Institute','8','Mauris blandit enim consequat purus. Maecenas libero est, congue a,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('108','3','Desirae','8','Jessica','14','882387','Commodo Consulting','9','vulputate velit eu sem. Pellentesque ut ipsum ac mi eleifend');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('102','3','Desirae','16','Bethany','39','656173','Aenean Gravida Limited','10','dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('136','3','Desirae','11','Rebecca','14','882387','Commodo Consulting','12','habitant morbi tristique senectus et netus et malesuada fames ac');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('151','4','Callie','10','Ulla','28','150289','Id Corporation','14','ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('143','1','Kimberley','13','Kaye','28','150289','Id Corporation','15','nulla. Donec non justo. Proin non massa non ante bibendum');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('132','5','Raphael','16','Bethany','24','822584','Felis Adipiscing Company','16','id ante dictum cursus. Nunc mauris elit, dictum eu, eleifend');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('118','3','Desirae','5','Tate','23','361396','Aliquam Ornare Consulting','16','id ante dictum cursus. Nunc mauris elit, dictum eu, eleifend');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('106','1','Kimberley','12','Anjolie','22','844001','Ut Pharetra LLC','16','id ante dictum cursus. Nunc mauris elit, dictum eu, eleifend');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('164','4','Callie','12','Anjolie','2','354991','Tortor Nunc Company','18','hendrerit id, ante. Nunc mauris sapien, cursus in, hendrerit consectetuer,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('148','5','Raphael','1','Cody','37','251734','Magna Ltd','22','orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('163','3','Desirae','9','Lev','36','431787','Libero Institute','23','vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('109','5','Raphael','11','Rebecca','14','882387','Commodo Consulting','23','vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('153','1','Kimberley','1','Cody','28','150289','Id Corporation','25','id sapien. Cras dolor dolor, tempus non, lacinia at, iaculis');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('140','3','Desirae','4','Regina','33','454930','Dolor LLC','27','ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('128','3','Desirae','12','Anjolie','25','487153','Congue Elit Sed PC','27','ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('194','2','Leila','18','Asher','18','999084','Cursus Associates','29','Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('179','4','Callie','6','Orson','33','454930','Dolor LLC','29','Donec egestas. Aliquam nec enim. Nunc ut erat. Sed nunc');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('165','3','Desirae','8','Jessica','3','955928','In Cursus Et LLP','30','Nullam velit dui, semper et, lacinia vitae, sodales at, velit.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('137','4','Callie','20','Destiny','30','711997','Ad Ltd','30','Nullam velit dui, semper et, lacinia vitae, sodales at, velit.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('145','4','Callie','12','Anjolie','27','476050','Suspendisse Commodo Tincidunt Foundation','31','erat, eget tincidunt dui augue eu tellus. Phasellus elit pede,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('129','1','Kimberley','4','Regina','37','251734','Magna Ltd','31','erat, eget tincidunt dui augue eu tellus. Phasellus elit pede,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('186','1','Kimberley','4','Regina','9','224791','Quis Company','32','et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('156','1','Kimberley','2','Rhonda','21','713322','Nullam Enim Corp.','32','et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('111','3','Desirae','4','Regina','25','487153','Congue Elit Sed PC','32','et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('105','4','Callie','13','Kaye','14','882387','Commodo Consulting','32','et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('172','1','Kimberley','15','Kevyn','20','820968','Eros Incorporated','33','erat semper rutrum. Fusce dolor quam, elementum at, egestas a,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('116','1','Kimberley','15','Kevyn','33','454930','Dolor LLC','33','erat semper rutrum. Fusce dolor quam, elementum at, egestas a,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('112','5','Raphael','9','Lev','11','770679','Suspendisse Sed Dolor Industries','33','erat semper rutrum. Fusce dolor quam, elementum at, egestas a,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('130','5','Raphael','4','Regina','8','466367','Mus Company','34','mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('101','5','Raphael','7','Chava','11','770679','Suspendisse Sed Dolor Industries','37','risus, at fringilla purus mauris a nunc. In at pede.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('142','3','Desirae','15','Kevyn','45','827922','Cursus Institute','37','risus, at fringilla purus mauris a nunc. In at pede.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('178','2','Leila','15','Kevyn','31','212808','Ut Molestie In Industries','38','lorem, auctor quis, tristique ac, eleifend vitae, erat. Vivamus nisi.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('197','5','Raphael','16','Bethany','8','466367','Mus Company','39','in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('150','2','Leila','9','Lev','22','844001','Ut Pharetra LLC','39','in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('121','1','Kimberley','5','Tate','15','474147','Morbi Limited','39','in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('180','4','Callie','20','Destiny','28','150289','Id Corporation','41','sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('141','3','Desirae','16','Bethany','43','995080','Rutrum LLC','41','sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('177','4','Callie','7','Chava','16','579522','Eleifend Foundation','42','Vestibulum ante ipsum primis in faucibus orci luctus et ultrices');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('123','3','Desirae','10','Ulla','47','787402','Rhoncus Id Associates','42','Vestibulum ante ipsum primis in faucibus orci luctus et ultrices');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('193','5','Raphael','14','James','22','844001','Ut Pharetra LLC','43','In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('126','3','Desirae','15','Kevyn','2','354991','Tortor Nunc Company','43','In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('195','2','Leila','3','Armando','19','632092','Malesuada Consulting','44','erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('167','2','Leila','6','Orson','5','978729','Ornare Facilisis Eget Industries','44','erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('188','4','Callie','5','Tate','35','922600','Nunc Associates','46','In mi pede, nonummy ut, molestie in, tempus eu, ligula.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('149','5','Raphael','2','Rhonda','23','361396','Aliquam Ornare Consulting','46','In mi pede, nonummy ut, molestie in, tempus eu, ligula.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('187','3','Desirae','15','Kevyn','31','212808','Ut Molestie In Industries','47','vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('127','4','Callie','3','Armando','18','999084','Cursus Associates','48','blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('161','5','Raphael','4','Regina','50','997551','Ac PC','49','sem egestas blandit. Nam nulla magna, malesuada vel, convallis in,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('152','5','Raphael','14','James','16','579522','Eleifend Foundation','50','non magna. Nam ligula elit, pretium et, rutrum non, hendrerit');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('173','2','Leila','3','Armando','45','827922','Cursus Institute','51','eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('157','2','Leila','8','Jessica','27','476050','Suspendisse Commodo Tincidunt Foundation','51','eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('175','2','Leila','16','Bethany','13','521644','Lorem Ut Aliquam LLC','52','ac mattis velit justo nec ante. Maecenas mi felis, adipiscing');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('162','4','Callie','18','Asher','36','431787','Libero Institute','53','ac libero nec ligula consectetuer rhoncus. Nullam velit dui, semper');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('190','1','Kimberley','16','Bethany','4','433438','In Incorporated','54','nec, leo. Morbi neque tellus, imperdiet non, vestibulum nec, euismod');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('184','1','Kimberley','4','Regina','32','346323','At Auctor Ullamcorper Industries','55','mauris a nunc. In at pede. Cras vulputate velit eu');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('103','3','Desirae','9','Lev','37','251734','Magna Ltd','55','mauris a nunc. In at pede. Cras vulputate velit eu');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('104','3','Desirae','17','Malachi','9','224791','Quis Company','57','urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('171','4','Callie','2','Rhonda','46','783081','Enim Non Nisi Associates','58','neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris eu turpis.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('134','3','Desirae','4','Regina','20','820968','Eros Incorporated','58','neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris eu turpis.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('189','3','Desirae','6','Orson','3','955928','In Cursus Et LLP','59','bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('120','2','Leila','9','Lev','9','224791','Quis Company','59','bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('182','5','Raphael','10','Ulla','5','978729','Ornare Facilisis Eget Industries','60','ut erat. Sed nunc est, mollis non, cursus non, egestas');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('154','5','Raphael','6','Orson','33','454930','Dolor LLC','60','ut erat. Sed nunc est, mollis non, cursus non, egestas');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('131','3','Desirae','11','Rebecca','30','711997','Ad Ltd','60','ut erat. Sed nunc est, mollis non, cursus non, egestas');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('160','4','Callie','1','Cody','20','820968','Eros Incorporated','61','vel, vulputate eu, odio. Phasellus at augue id ante dictum');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('100','1','Kimberley','1','Cody','23','361396','Aliquam Ornare Consulting','65','Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('176','5','Raphael','10','Ulla','7','200855','Euismod In Dolor Ltd','68','est. Nunc laoreet lectus quis massa. Mauris vestibulum, neque sed');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('196','5','Raphael','1','Cody','5','978729','Ornare Facilisis Eget Industries','70','quis accumsan convallis, ante lectus convallis est, vitae sodales nisi');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('146','5','Raphael','7','Chava','1','379508','Elit Erat Vitae Company','70','quis accumsan convallis, ante lectus convallis est, vitae sodales nisi');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('113','5','Raphael','20','Destiny','6','687622','Lacus Etiam Bibendum PC','71','justo eu arcu. Morbi sit amet massa. Quisque porttitor eros');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('191','4','Callie','9','Lev','28','150289','Id Corporation','72','ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('155','2','Leila','9','Lev','40','247175','Nunc Est Mollis Inc.','72','ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('135','5','Raphael','10','Ulla','33','454930','Dolor LLC','72','ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('122','4','Callie','3','Armando','19','632092','Malesuada Consulting','73','tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('110','5','Raphael','14','James','31','212808','Ut Molestie In Industries','73','tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('183','5','Raphael','11','Rebecca','39','656173','Aenean Gravida Limited','75','accumsan neque et nunc. Quisque ornare tortor at risus. Nunc');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('192','3','Desirae','1','Cody','17','786702','Ridiculus Mus Consulting','77','quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('181','5','Raphael','18','Asher','32','346323','At Auctor Ullamcorper Industries','80','ante. Vivamus non lorem vitae odio sagittis semper. Nam tempor');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('159','1','Kimberley','18','Asher','36','431787','Libero Institute','82','non enim. Mauris quis turpis vitae purus gravida sagittis. Duis');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('119','1','Kimberley','12','Anjolie','47','787402','Rhoncus Id Associates','85','turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy ut,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('115','2','Leila','14','James','47','787402','Rhoncus Id Associates','89','erat semper rutrum. Fusce dolor quam, elementum at, egestas a,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('138','3','Desirae','13','Kaye','1','379508','Elit Erat Vitae Company','90','arcu. Vivamus sit amet risus. Donec egestas. Aliquam nec enim.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('117','4','Callie','6','Orson','47','787402','Rhoncus Id Associates','92','diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('185','2','Leila','14','James','7','200855','Euismod In Dolor Ltd','93','et, eros. Proin ultrices. Duis volutpat nunc sit amet metus.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('144','4','Callie','15','Kevyn','27','476050','Suspendisse Commodo Tincidunt Foundation','93','et, eros. Proin ultrices. Duis volutpat nunc sit amet metus.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('107','2','Leila','13','Kaye','9','224791','Quis Company','93','et, eros. Proin ultrices. Duis volutpat nunc sit amet metus.');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('170','3','Desirae','14','James','49','349725','Vel Company','95','placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('133','3','Desirae','10','Ulla','24','822584','Felis Adipiscing Company','95','placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('147','4','Callie','8','Jessica','20','820968','Eros Incorporated','96','bibendum sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('125','3','Desirae','14','James','30','711997','Ad Ltd','96','bibendum sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum,');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('169','3','Desirae','14','James','3','955928','In Cursus Et LLP','97','varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('174','1','Kimberley','17','Malachi','12','881088','Nullam Ut Nisi Limited','99','purus sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam');
Insert into SYSTEM.INFO_INVOICE (BILL_ID,SALES_PERSON_ID,NAME_OF_SALESPERSON,CLIENT_ID,NAME_OF_CLIENT,VEHICLE_ID,BRAND_OF_VEHICLE,MANUFACTURER_OF_VEHICLE,ACCESORY_ID,NAME_OF_ACCESORY) values ('168','5','Raphael','5','Tate','16','579522','Eleifend Foundation','99','purus sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam');
REM INSERTING into SYSTEM.PRODUCT_PRIVS
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index SYS_C007005
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C007005" ON "SYSTEM"."ACCESORIES" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007011
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C007011" ON "SYSTEM"."ACCESORIES_INVENTORY" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007013
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C007013" ON "SYSTEM"."CUSTOMER" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007003
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C007003" ON "SYSTEM"."HISTORICAL_DATA_FOR_VEHICLES" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007007
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C007007" ON "SYSTEM"."INVOICE" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007009
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C007009" ON "SYSTEM"."INVOICE_DETAIL" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C006996
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C006996" ON "SYSTEM"."MANUFACTURES" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C006992
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C006992" ON "SYSTEM"."NEW_VEHICLES" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007012
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C007012" ON "SYSTEM"."SALES_PERSON" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C007002
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C007002" ON "SYSTEM"."TRADE_IN_VEHICLES" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C006988
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C006988" ON "SYSTEM"."VEHICLES" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index SYS_C006999
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYSTEM"."SYS_C006999" ON "SYSTEM"."VEHICLES_FOR_SALE" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Trigger UPDATE_INVENTORY
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SYSTEM"."UPDATE_INVENTORY" 
AFTER INSERT ON INVOICE_DETAIL 
  FOR EACH ROW
BEGIN
  UPDATE ACCESORIES_INVENTORY 
     SET UNITS_AVAILABLE = UNITS_AVAILABLE - 1
   WHERE ACCESORY_ID = :new.ACCESORIES_ID;
END;

/
ALTER TRIGGER "SYSTEM"."UPDATE_INVENTORY" ENABLE;
--------------------------------------------------------
--  DDL for Procedure INSERT_HISTORICAL_DATA_VEHI
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."INSERT_HISTORICAL_DATA_VEHI" IS
    C_INVOICE_ID INVOICE.ID%TYPE;
    C_VFS_ID INVOICE.VEHICLE_FOR_SALE_ID%TYPE;

    CURSOR CURSOR_INVOICE IS 
    SELECT I.ID,I.VEHICLE_FOR_SALE_ID FROM INVOICE I;    
BEGIN 
    OPEN CURSOR_INVOICE;    
    LOOP
    FETCH CURSOR_INVOICE INTO C_INVOICE_ID,C_VFS_ID;
        EXIT WHEN CURSOR_INVOICE%NOTFOUND;
        INSERT INTO HISTORICAL_DATA_FOR_VEHICLES (id,vehicle_for_sale_id,invoice_id,status)
        VALUES(HISTORICAL_DATA_VEHICLES_SEQ.NEXTVAL,C_VFS_ID,C_INVOICE_ID,'TRADE');
        COMMIT;
    END LOOP;
    CLOSE CURSOR_INVOICE;
END INSERT_HISTORICAL_DATA_VEHI;

/
--------------------------------------------------------
--  DDL for Procedure INSERT_INVOICE_DETAIL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."INSERT_INVOICE_DETAIL_PROC" (
    ID_IN IN NUMBER,
    CUSTOMER_ID_IN IN NUMBER,
    VEHICLE_FOR_SALE_ID_IN IN NUMBER,
    FINAL_PRICE_IN IN NUMBER,
    PLUS_IN IN NUMBER,TAXES_IN IN NUMBER,
    LICENSE_FEES_IN IN NUMBER,SALES_PERSON_ID_IN IN NUMBER,TRADE_IN_VEHICLE_ID_IN IN NUMBER)
IS       
    ID NUMBER := ID_IN;
    CUSTOMER_ID NUMBER := CUSTOMER_ID_IN;
    --VEHICLE_FOR_SALE_ID NUMBER := VEHICLE_FOR_SALE_ID_IN;
    --FINAL_PRICE NUMBER(10,2) := FINAL_PRICE_IN;
    PLUS NUMBER(10,2) := PLUS_IN;
    TAXES NUMBER(10,2) := TAXES_IN;
    LICENSE_FEES NUMBER(10,2) := LICENSE_FEES_IN; 
    SALES_PERSON_ID NUMBER := SALES_PERSON_ID_IN;
    TRADE_IN_VEHICLE_ID NUMBER := TRADE_IN_VEHICLE_ID_IN;

    RANDOM_ID_ACC NUMBER := 0;
    VFS_ID TRADE_IN_VEHICLES.VEHICLE_FOR_SALE_ID%TYPE := 1;
    F_PRICE INVOICE.FINAL_PRICE%TYPE := 0;
    S_PRICE ACCESORIES.SELLING_PRICE%TYPE := 0;
    COSTO_DETAIL ACCESORIES.COST%TYPE := 0;    
BEGIN        
    SELECT CEIL(DBMS_RANDOM.VALUE(1,100)) INTO RANDOM_ID_ACC FROM DUAL;--RANDOM ID TO SELECT ACCESORIES    
    SELECT TIV.VEHICLE_FOR_SALE_ID INTO VFS_ID FROM TRADE_IN_VEHICLES TIV WHERE TIV.ID = TRADE_IN_VEHICLE_ID; 
    SELECT ACC.SELLING_PRICE INTO COSTO_DETAIL FROM ACCESORIES ACC WHERE ACC.ID = RANDOM_ID_ACC; 
    SELECT ACC.SELLING_PRICE INTO S_PRICE FROM ACCESORIES ACC WHERE ACC.ID = RANDOM_ID_ACC;    

    /*FINAL PRICE*/
    F_PRICE := S_PRICE + LICENSE_FEES + PLUS + TAXES;

    INSERT INTO INVOICE (id,CUSTOMER_ID,VEHICLE_FOR_SALE_ID,FINAL_PRICE,PLUS,TAXES,
        LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID) 
    VALUES (ID,CUSTOMER_ID,VFS_ID,F_PRICE,PLUS,TAXES,LICENSE_FEES,SALES_PERSON_ID,TRADE_IN_VEHICLE_ID);

    INSERT INTO INVOICE_DETAIL(ID,INVOICE_ID,ACCESORIES_ID,COST) 
    VALUES(INVOICE_DETAIL_SEQ.NEXTVAL,ID,RANDOM_ID_ACC,COSTO_DETAIL);
    COMMIT;
END INSERT_INVOICE_DETAIL_PROC; 

/
--------------------------------------------------------
--  DDL for Procedure REORDER_UNITS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SYSTEM"."REORDER_UNITS" AS
  A_ID ACCESORIES_UNDER_FIVE_UNITS.ID%TYPE;
  A_NAME ACCESORIES_UNDER_FIVE_UNITS.NAME%TYPE;
  A_CODE ACCESORIES_UNDER_FIVE_UNITS.CODE%TYPE;
  A_MANUFACTURER ACCESORIES_UNDER_FIVE_UNITS.MANUFACTURER%TYPE;
  A_UNITS_AVAILABLE ACCESORIES_UNDER_FIVE_UNITS.UNITS_AVAILABLE%TYPE;
CURSOR UA IS 
    SELECT ID, 
           NAME, 
           CODE, 
           MANUFACTURER, 
           (UNITS_AVAILABLE+20) AS UNITS_AVAILABLE 
      FROM ACCESORIES_UNDER_FIVE_UNITS;   
BEGIN 
    OPEN UA;    
    LOOP
    FETCH UA INTO A_ID,A_NAME,A_CODE,A_MANUFACTURER,A_UNITS_AVAILABLE;
        EXIT WHEN UA%NOTFOUND;
    END LOOP;
CLOSE UA;
END REORDER_UNITS;

/
--------------------------------------------------------
--  DDL for Package DBMS_REPCAT_AUTH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "SYSTEM"."DBMS_REPCAT_AUTH" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
9
bf d6
0cfc6e4Sm6mfaMYwsbW2JygBepcwg/BKmJ4VZy/pO06UXsVUMejsissTcGWYR4qeK4TPqfDK
q7UPH+SmKP6nW9zmxMZnuK1VDzM0Iv9O4E4SvvsnHWn+EPF9hR+oBFe3fEro6RQ5R5Ejd1nr
e+fAK010dExf76gg/c6ZB3YxGPHDOqkGI4lV6HNsd57gKLwTd0bxan5UwJriIpt7Vjc=

/
--------------------------------------------------------
--  DDL for Package Body DBMS_REPCAT_AUTH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SYSTEM"."DBMS_REPCAT_AUTH" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
b9d 39c
PBMGkNCh5NDAdLezCHsLvZaVi/swg5UrNSCDfI4Zvp0VB6GpRld+By6E2nVdlFHT2g2kK9zM
8jSnsuee7mkmJD+W3Mo36HQvUfOe7jH5vP7tu1i0jDykzR0pUhJZUcY6xVrSwNPoNVPcT72N
eHhGwyRBj2+0vKbgTmcZKBMJzETRfOl2YGDDVB3FvKBSixMMqfWSX8uh3wPGOi8W9vOASC3z
0UvPqL7KR78SykUEoBCxpMGmE8pgElC/dagmVpIIt7QA6sneMlNb2OO/1zTN44ACRsm+2JAo
zD41TcuGaNUqDYNDRbPEKzeRZeXxrx1UvOWsYTNaO6icaV/NrtZbmXpDuGA/sqnz4jnKFK8S
0VC+Yjh2iJEV5edD2+8pyMgx44NVDiAQ+sjjDkpGc0IxXrm/v52yduhnj/xnkualIm/RyAv0
Q/YzRAHy7NvyavbajIvCFoZWpbO3Jw8NwkoU25ysfgvXZJrw4vPjh4hHR4Mpto6jFMM+dZPW
3N9HL971bTBgyAL0BjASEFXe83D+IoBYX0VQVk5+t7p7iUsmfyK5t+cECNpNOL6UaACcsAYB
Le+yLOAqFHSvCXlWcECxG7wXjAA2/XmBwvKBNLcggXKVp3i9cNzab0Mq9qSAcIYgRFxRdAOe
sTDZNOx6HkJTbCRKCMiJzgjQQW476DlOZD+9Gwh+AA/Y3PIDOfyhlvXT6HsjW33mASJUuORB
la5Jb3rB4syO6QO2a5vSHu26Gwib2EflS8bqC1hZhpHsvM+mAaWJ2x72JyrPe8V7Ohjbre49
gRsjAtspIYfP5958sSnHdkz32nGAXnrEY95lEHGwkuXLlj9y6I21aAyd3/lJkuEAEBxzZVnm
IaNJBwl8u33+SqGLZzILy1QxmA+pF8yUaQ+yRU/5+3n1mY4=

/
--------------------------------------------------------
--  DDL for Synonymn CATALOG
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "SYSTEM"."CATALOG" FOR "SYS"."CATALOG";
--------------------------------------------------------
--  DDL for Synonymn COL
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "SYSTEM"."COL" FOR "SYS"."COL";
--------------------------------------------------------
--  DDL for Synonymn PRODUCT_USER_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "SYSTEM"."PRODUCT_USER_PROFILE" FOR "SYSTEM"."SQLPLUS_PRODUCT_PROFILE";
--------------------------------------------------------
--  DDL for Synonymn PUBLICSYN
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "SYSTEM"."PUBLICSYN" FOR "SYS"."PUBLICSYN";
--------------------------------------------------------
--  DDL for Synonymn SYSCATALOG
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "SYSTEM"."SYSCATALOG" FOR "SYS"."SYSCATALOG";
--------------------------------------------------------
--  DDL for Synonymn SYSFILES
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "SYSTEM"."SYSFILES" FOR "SYS"."SYSFILES";
--------------------------------------------------------
--  DDL for Synonymn TAB
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "SYSTEM"."TAB" FOR "SYS"."TAB";
--------------------------------------------------------
--  DDL for Synonymn TABQUOTAS
--------------------------------------------------------

  CREATE OR REPLACE SYNONYM "SYSTEM"."TABQUOTAS" FOR "SYS"."TABQUOTAS";
--------------------------------------------------------
--  DDL for Queue DEF$_AQERROR
--------------------------------------------------------

   BEGIN DBMS_AQADM.CREATE_QUEUE(
     Queue_name          => 'SYSTEM.DEF$_AQERROR',
     Queue_table         => 'SYSTEM.DEF$_AQERROR',
     Queue_type          =>  0,
     Max_retries         =>  5,
     Retry_delay         =>  0,
     dependency_tracking =>  TRUE,
     comment             => 'Error Queue for Deferred RPCs');
  END;
/
--------------------------------------------------------
--  DDL for Queue DEF$_AQCALL
--------------------------------------------------------

   BEGIN DBMS_AQADM.CREATE_QUEUE(
     Queue_name          => 'SYSTEM.DEF$_AQCALL',
     Queue_table         => 'SYSTEM.DEF$_AQCALL',
     Queue_type          =>  0,
     Max_retries         =>  5,
     Retry_delay         =>  0,
     dependency_tracking =>  TRUE,
     comment             => 'Deferred RPC Queue');
  END;
/

  GRANT SELECT ON "SYSTEM"."DEF$_AQCALL" TO "SYS" WITH GRANT OPTION;
--------------------------------------------------------
--  DDL for Queue Table DEF$_AQCALL
--------------------------------------------------------

   BEGIN DBMS_AQADM.CREATE_QUEUE_TABLE(
     Queue_table        => '"SYSTEM"."DEF$_AQCALL"',
     Queue_payload_type => 'VARIANT',
     storage_clause     => 'PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 TABLESPACE SYSTEM',
     Sort_list          => 'ENQ_TIME',
     Compatible         => '8.0.3');
  END;
/

  GRANT SELECT ON "SYSTEM"."DEF$_AQCALL" TO "SYS" WITH GRANT OPTION;
--------------------------------------------------------
--  DDL for Queue Table DEF$_AQERROR
--------------------------------------------------------

   BEGIN DBMS_AQADM.CREATE_QUEUE_TABLE(
     Queue_table        => '"SYSTEM"."DEF$_AQERROR"',
     Queue_payload_type => 'VARIANT',
     storage_clause     => 'PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 TABLESPACE SYSTEM',
     Sort_list          => 'ENQ_TIME',
     Compatible         => '8.0.3');
  END;
/
--------------------------------------------------------
--  Constraints for Table ACCESORIES
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."ACCESORIES" ADD PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."ACCESORIES" MODIFY ("MANUFACURE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ACCESORIES_INVENTORY
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."ACCESORIES_INVENTORY" ADD PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."ACCESORIES_INVENTORY" MODIFY ("ACCESORY_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CUSTOMER
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."CUSTOMER" ADD PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table HISTORICAL_DATA_FOR_VEHICLES
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."HISTORICAL_DATA_FOR_VEHICLES" ADD CONSTRAINT "CKHISTORICALTABLE" CHECK (status in ('NEW', 'TRADE', 'SOLD')) ENABLE;
  ALTER TABLE "SYSTEM"."HISTORICAL_DATA_FOR_VEHICLES" ADD PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table INVOICE
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."INVOICE" ADD PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."INVOICE" MODIFY ("CUSTOMER_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table INVOICE_DETAIL
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."INVOICE_DETAIL" ADD PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."INVOICE_DETAIL" MODIFY ("COST" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table MANUFACTURES
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."MANUFACTURES" ADD PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."MANUFACTURES" MODIFY ("CITY" NOT NULL ENABLE);
  ALTER TABLE "SYSTEM"."MANUFACTURES" MODIFY ("ADDRESS" NOT NULL ENABLE);
  ALTER TABLE "SYSTEM"."MANUFACTURES" MODIFY ("NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table NEW_VEHICLES
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."NEW_VEHICLES" ADD PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."NEW_VEHICLES" MODIFY ("COST" NOT NULL ENABLE);
  ALTER TABLE "SYSTEM"."NEW_VEHICLES" MODIFY ("MANUFACTURE_ID" NOT NULL ENABLE);
  ALTER TABLE "SYSTEM"."NEW_VEHICLES" MODIFY ("VEHICLE_FOR_SALE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table SALES_PERSON
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."SALES_PERSON" ADD PRIMARY KEY ("ID") ENABLE;
--------------------------------------------------------
--  Constraints for Table TRADE_IN_VEHICLES
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."TRADE_IN_VEHICLES" ADD PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."TRADE_IN_VEHICLES" MODIFY ("COST" NOT NULL ENABLE);
  ALTER TABLE "SYSTEM"."TRADE_IN_VEHICLES" MODIFY ("VEHICLE_FOR_SALE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VEHICLES
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."VEHICLES" ADD PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."VEHICLES" MODIFY ("STATUS" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VEHICLES_FOR_SALE
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."VEHICLES_FOR_SALE" ADD PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."VEHICLES_FOR_SALE" MODIFY ("DESCRIPTION" NOT NULL ENABLE);
  ALTER TABLE "SYSTEM"."VEHICLES_FOR_SALE" MODIFY ("VEHICLE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table ACCESORIES_INVENTORY
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."ACCESORIES_INVENTORY" ADD CONSTRAINT "FK_ACCINV_ACCESORY" FOREIGN KEY ("ACCESORY_ID")
	  REFERENCES "SYSTEM"."ACCESORIES" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table HISTORICAL_DATA_FOR_VEHICLES
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."HISTORICAL_DATA_FOR_VEHICLES" ADD CONSTRAINT "FK_HIST_INVOICE" FOREIGN KEY ("INVOICE_ID")
	  REFERENCES "SYSTEM"."INVOICE" ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."HISTORICAL_DATA_FOR_VEHICLES" ADD CONSTRAINT "FK_HIST_VEHICLE_FOR_SALE" FOREIGN KEY ("VEHICLE_FOR_SALE_ID")
	  REFERENCES "SYSTEM"."VEHICLES_FOR_SALE" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table INVOICE
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."INVOICE" ADD CONSTRAINT "FK_CUSTOMER" FOREIGN KEY ("CUSTOMER_ID")
	  REFERENCES "SYSTEM"."CUSTOMER" ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."INVOICE" ADD CONSTRAINT "FK_INVOICE_TRADE_IN_VEHICLE" FOREIGN KEY ("TRADE_IN_VEHICLE_ID")
	  REFERENCES "SYSTEM"."TRADE_IN_VEHICLES" ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."INVOICE" ADD CONSTRAINT "FK_INVOICE_VEHICLE_FOR_SALE" FOREIGN KEY ("VEHICLE_FOR_SALE_ID")
	  REFERENCES "SYSTEM"."VEHICLES_FOR_SALE" ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."INVOICE" ADD CONSTRAINT "FK_SALES_PERSON" FOREIGN KEY ("SALES_PERSON_ID")
	  REFERENCES "SYSTEM"."SALES_PERSON" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table INVOICE_DETAIL
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."INVOICE_DETAIL" ADD CONSTRAINT "FK_INVDETAIL_ACCESORY" FOREIGN KEY ("ACCESORIES_ID")
	  REFERENCES "SYSTEM"."ACCESORIES" ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."INVOICE_DETAIL" ADD CONSTRAINT "FK_INVDETAIL_INVOICE" FOREIGN KEY ("INVOICE_ID")
	  REFERENCES "SYSTEM"."INVOICE" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table NEW_VEHICLES
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."NEW_VEHICLES" ADD CONSTRAINT "FK_MANUFACTURE" FOREIGN KEY ("MANUFACTURE_ID")
	  REFERENCES "SYSTEM"."MANUFACTURES" ("ID") ENABLE;
  ALTER TABLE "SYSTEM"."NEW_VEHICLES" ADD CONSTRAINT "FK_VEHICLE_FOR_SALE" FOREIGN KEY ("VEHICLE_FOR_SALE_ID")
	  REFERENCES "SYSTEM"."VEHICLES_FOR_SALE" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TRADE_IN_VEHICLES
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."TRADE_IN_VEHICLES" ADD CONSTRAINT "FK_TRADE_VEHICLE_FOR_SALE" FOREIGN KEY ("VEHICLE_FOR_SALE_ID")
	  REFERENCES "SYSTEM"."VEHICLES_FOR_SALE" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table VEHICLES_FOR_SALE
--------------------------------------------------------

  ALTER TABLE "SYSTEM"."VEHICLES_FOR_SALE" ADD CONSTRAINT "FK_VEHICLE" FOREIGN KEY ("VEHICLE_ID")
	  REFERENCES "SYSTEM"."VEHICLES" ("ID") ENABLE;
