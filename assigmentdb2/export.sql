--------------------------------------------------------
-- Archivo creado  - sábado-noviembre-18-2017   
--------------------------------------------------------
DROP VIEW "SYSTEM"."ACCESORIES_UNDER_FIVE_UNITS";
DROP VIEW "SYSTEM"."INFO_INVOICE";
DROP VIEW "SYSTEM"."PRODUCT_PRIVS";
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
--  DDL for View PRODUCT_PRIVS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SYSTEM"."PRODUCT_PRIVS" ("PRODUCT", "USERID", "ATTRIBUTE", "SCOPE", "NUMERIC_VALUE", "CHAR_VALUE", "DATE_VALUE", "LONG_VALUE") AS 
  SELECT PRODUCT, USERID, ATTRIBUTE, SCOPE,
         NUMERIC_VALUE, CHAR_VALUE, DATE_VALUE, LONG_VALUE
  FROM SQLPLUS_PRODUCT_PROFILE
  WHERE USERID = 'PUBLIC' OR USER LIKE USERID
;
  GRANT SELECT ON "SYSTEM"."PRODUCT_PRIVS" TO PUBLIC;
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
