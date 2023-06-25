/***************************************************************************************************
Script:             Database Creation
Create Date:        06-11-2021
Author:             Ricardo Ribeiro (1181350)
Description:        This script consists in the drop off all existing table and then recreate them.

Execution Order:    DROP TABLES
                    CREATE TABLES (structure only)
                    ALTER TABLES (add constrains and Primary Keys)

Affected table(s):  [Ship]
                    [Role]
                    [Truck]
                    [Border]
                    [Seadist]
                    [Country]
                    [Transport]
                    [CargoSite]
                    [Continent]
                    [Container]
                    [PositionData]
                    [PlatformUser]
                    [CargoManifest]
                    [TransportType]
                    [CargoSiteType]
                    [CargoManifestLine]
                    [CargoManifestType]
                    [DatabaseAccountLink]
                    [LogContainerOperations]

Script Usage:       To have feedback from the script you should activate "Enable DBMS_OUTPUT"
                    This script do not create the database, it should be created first and then
                    this script should run in it.
***************************************************************************************************
SUMMARY OF CHANGES
Date(dd-MM-yyyy)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
  22-11-2021        Ricardo Ribeiro     Add Date fields, origin and destination cargo site to
                    (1181350)           CargoManifest Table
------------------- ------------------- ------------------------------------------------------------
  15-12-2021        Ricardo Ribeiro     - Add Table DatabaseAccountLink
                    (1181350)           - Add Leasing Client into CargoManifestLine
                                        - Add Capitan into Ship
------------------- ------------------- ------------------------------------------------------------
  23-12-2021        Ricardo Ribeiro     - Add Table Border
                    (1181350)           - Remove Id from Continent and Country
                                        - Add Table Seadist
------------------- ------------------- ------------------------------------------------------------
  30-12-2021        Ricardo Ribeiro     - Add Table LogContainerOperations
                    (1181350)           
------------------- ------------------- ------------------------------------------------------------
***************************************************************************************************/
/*****************************
  Drop All Tables If Exists
*****************************/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE LogContainerOperations';
    DBMS_OUTPUT.PUT_LINE('Table LogContainerOperations Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (LogContainerOperations).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Border';
    DBMS_OUTPUT.PUT_LINE('Table Border Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (Border).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Seadist';
    DBMS_OUTPUT.PUT_LINE('Table Seadist Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (Seadist).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE DatabaseAccountLink';
    DBMS_OUTPUT.PUT_LINE('Table DatabaseAccountLink Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (DatabaseAccountLink).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CargoManifestLine';
    DBMS_OUTPUT.PUT_LINE('Table CargoManifestLine Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (CargoManifestLine).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CargoManifest';
    DBMS_OUTPUT.PUT_LINE('Table CargoManifest Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (CargoManifest).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE PositionData';
    DBMS_OUTPUT.PUT_LINE('Table PositionData Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (PositionData).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Ship';
    DBMS_OUTPUT.PUT_LINE('Table Ship Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (Ship).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Truck';
    DBMS_OUTPUT.PUT_LINE('Table Truck Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (Truck).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Transport';
    DBMS_OUTPUT.PUT_LINE('Table Transport Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (Transport).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CargoSite';
    DBMS_OUTPUT.PUT_LINE('Table CargoSite Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (CargoSite).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE PlatformUser';
    DBMS_OUTPUT.PUT_LINE('Table PlatformUser Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (PlatformUser).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Role';
    DBMS_OUTPUT.PUT_LINE('Table Role Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (Role).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Country';
    DBMS_OUTPUT.PUT_LINE('Table Country Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (Country).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Continent';
    DBMS_OUTPUT.PUT_LINE('Table Continent Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (Continent).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Container';
    DBMS_OUTPUT.PUT_LINE('Table Container Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (Container).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CargoManifestType';
    DBMS_OUTPUT.PUT_LINE('Table CargoManifestType Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (CargoManifestType).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE TransportType';
    DBMS_OUTPUT.PUT_LINE('Table TransportType Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (TransportType).');
END;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CargoSiteType';
    DBMS_OUTPUT.PUT_LINE('Table CargoSiteType Dropped.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Table do not exist (CargoSiteType).');
END;

/*****************************
  Create All Tables Structure
*****************************/
CREATE TABLE Ship
(
    idTransport     NUMBER(19),
    mmsi            NUMBER(9) NOT NULL,
    callSign        VARCHAR(10) NOT NULL,
    name            VARCHAR(50) NOT NULL,
    imoNumber       NUMBER(7) NOT NULL,
    generators      NUMBER(3) NOT NULL,
    outputGenerator NUMBER(6) NOT NULL,
    vesselType      NUMBER(4) NOT NULL,
    length          NUMBER(4) NOT NULL,
    width           NUMBER(3) NOT NULL,
    capacity        NUMBER(7) NOT NULL,
    draft           DECIMAL(3, 1) NOT NULL,
    idCapitan       NUMBER(19)

);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: Ship'); END;
CREATE TABLE Role
(
    id          NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    description VARCHAR(255) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: Role'); END;
CREATE TABLE Truck
(
    idTransport  NUMBER(19),
    licensePlate VARCHAR(20) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: Truck'); END;
CREATE TABLE Border
(
    idCountryBase VARCHAR(50) NOT NULL,
    idCountryBorder VARCHAR(50) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: Border'); END;
CREATE TABLE Seadist
(
    idCargoSiteFrom NUMBER(19),
    idCargoSiteTo NUMBER(19),
    distance NUMBER(5) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: Seadist'); END;
CREATE TABLE Country
(
    description VARCHAR(50) NOT NULL,
    alpha2_Code VARCHAR(2) NOT NULL,
    alpha3_Code VARCHAR(3) NOT NULL,
    population DECIMAL(5,2) NOT NULL,
    capital VARCHAR(50) NOT NULL,
    latitude DECIMAL(8,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    idContinent VARCHAR(50) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: Country'); END;
CREATE TABLE Transport
(
    id              NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    active          CHAR(1) NOT NULL,
    idTransportType NUMBER(19) NOT NULL

);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: Transport'); END;
CREATE TABLE CargoSite
(
    id                  NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    name                VARCHAR(50) NOT NULL,
    latitude            DECIMAL(8, 5) NOT NULL,
    longitude           DECIMAL(8, 5) NOT NULL,
    idCountry           VARCHAR(50) NOT NULL,
    idCargoSiteType     NUMBER(19) NOT NULL,
    containerCapacity   NUMBER(9) NOT NULL,
    shipCapacity        NUMBER(9) NOT NULL,
    truckCapacity       NUMBER(9) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: CargoSite'); END;
CREATE TABLE Continent
(
    description VARCHAR(50) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: Continent'); END;
CREATE TABLE Container
(
    id NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    identificationNumber VARCHAR(11) NOT NULL,
    isoCod               VARCHAR(4) NOT NULL,
    maxWeight            NUMBER(5) NOT NULL,
    tareWeight           NUMBER(5) NOT NULL,
    maxVolume            DECIMAL(3, 1) NOT NULL,
    repair               DATE NOT NULL,
    temperature          DECIMAL(5, 2) NULL,
    idCsc                VARCHAR(15) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: Container'); END;
CREATE TABLE PositionData
(
    idShip           NUMBER(19),
    dateTimeReceived TIMESTAMP,
    latitude         DECIMAL(8, 6) NOT NULL,
    longitude        DECIMAL(9, 6) NOT NULL,
    sog              DECIMAL(4, 1) NOT NULL,
    cog              DECIMAL(4, 1) NOT NULL,
    heading          NUMBER(3) NOT NULL,
    position         NUMBER(9) NOT NULL,
    transceiverClass CHAR(1) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: PositionData'); END;
CREATE TABLE PlatformUser
(
    id          NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    username    VARCHAR(20) NOT NULL,
    password    VARCHAR(20) NOT NULL,
    description VARCHAR(255) NOT NULL,
    idRole      NUMBER(19) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: PlatformUser'); END;
CREATE TABLE DatabaseAccountLink
(
    dbUser      VARCHAR(90),
    idCapitan   NUMBER(19)
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: PlatformUser'); END;
CREATE TABLE CargoManifest
(
    id                     NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    idTransport            NUMBER(19) NOT NULL,
    idCargoSiteOrigin      NUMBER(19) NOT NULL,
    idCargoSiteDestination NUMBER(19) NOT NULL,
    idCargoManifestType    NUMBER(19) NOT NULL,
    dateStart              TIMESTAMP,
    dateFinish             TIMESTAMP,
    dateStartEstimated     TIMESTAMP NOT NULL,
    dateFinishEstimated    TIMESTAMP  NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: CargoManifest'); END;
CREATE TABLE TransportType
(
    id          NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    description VARCHAR(30) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: TransportType'); END;
CREATE TABLE CargoSiteType
(
    id          NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    description VARCHAR(30) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: CargoSiteType'); END;
CREATE TABLE CargoManifestLine
(
    idContainer        NUMBER(19),
    idCargoManifest    NUMBER(19),
    grossWeight        NUMBER(5) NOT NULL,
    xPosition          NUMBER(3) NOT NULL,
    yPosition          NUMBER(3) NOT NULL,
    zPosition          NUMBER(3) NOT NULL,
    idLeasingClient    NUMBER(19)
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: CargoManifestLine'); END;
CREATE TABLE CargoManifestType
(
    id          NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    description VARCHAR(30) NOT NULL
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: CargoManifestType'); END;
CREATE TABLE LogContainerOperations
(
    id                 NUMBER(19) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    datetime           TIMESTAMP NOT NULL,
    type               VARCHAR(6) NOT NULL,
    dbUser             VARCHAR(90) NOT NULL,
    idContainer        NUMBER(19) NOT NULL,
    idCargoManifest    NUMBER(19) NOT NULL,
    grossWeight        NUMBER(5) NOT NULL,
    xPosition          NUMBER(3) NOT NULL,
    yPosition          NUMBER(3) NOT NULL,
    zPosition          NUMBER(3) NOT NULL,
    idLeasingClient    NUMBER(19)
);
BEGIN DBMS_OUTPUT.PUT_LINE('Created Table: LogContainerOperations'); END;

/*****************************
  Alter To Add Primary Keys
*****************************/
ALTER TABLE Ship
    ADD CONSTRAINT pk_Ship_idTransport PRIMARY KEY (idTransport);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "idTransport" to table "Ship".'); END;

ALTER TABLE Role
    ADD CONSTRAINT pk_Role_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "Role".'); END;

ALTER TABLE Truck
    ADD CONSTRAINT pk_Truck_idTransport PRIMARY KEY (idTransport);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "idTransport" to table "Truck".'); END;

ALTER TABLE Border
    ADD CONSTRAINT pk_Border_idCountryBase_idCountryBorder PRIMARY KEY (idCountryBase, idCountryBorder);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key fields "idCountryBase" & "idCountryBorder" to table "Border".'); END;

ALTER TABLE Seadist
    ADD CONSTRAINT pk_Seadist_idCargoSiteFrom_idCargoSiteTo PRIMARY KEY (idCargoSiteFrom, idCargoSiteTo);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key fields "idCargoSiteFrom" & "idCargoSiteTo" to table "Seadist".'); END;

ALTER TABLE Country
    ADD CONSTRAINT pk_Country_description PRIMARY KEY (description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "description" to table "Country".'); END;

ALTER TABLE Transport
    ADD CONSTRAINT pk_Transport_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "Transport".'); END;

ALTER TABLE CargoSite
    ADD CONSTRAINT pk_CargoSite_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "CargoSite".'); END;

ALTER TABLE Continent
    ADD CONSTRAINT pk_Continent_description PRIMARY KEY (description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "description" to table "Continent".'); END;

ALTER TABLE Container
    ADD CONSTRAINT pk_Container_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "Container".'); END;

ALTER TABLE PositionData
    ADD CONSTRAINT pk_PositionData_idShip_dateTimeReceived PRIMARY KEY (idShip,dateTimeReceived);
BEGIN DBMS_OUTPUT.PUT_LINE('Add composed Primary Key fields "idShip" & "dateTimeReceived" to table "PositionData".'); END;

ALTER TABLE PlatformUser
    ADD CONSTRAINT pk_PlatformUser_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "PlatformUser".'); END;

ALTER TABLE DatabaseAccountLink
    ADD CONSTRAINT pk_DatabaseAccountLink_dbUser PRIMARY KEY (dbUser);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "dbUser" to table "DatabaseAccountLink".'); END;

ALTER TABLE CargoManifest
    ADD CONSTRAINT pk_CargoManifest_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "CargoManifest".'); END;

ALTER TABLE TransportType
    ADD CONSTRAINT pk_TransportType_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "TransportType".'); END;

ALTER TABLE CargoSiteType
    ADD CONSTRAINT pk_CargoSiteType_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "CargoSiteType".'); END;

ALTER TABLE CargoManifestLine
    ADD CONSTRAINT pk_CargoManifestLine_idContainer_idCargoManifest PRIMARY KEY (idContainer,idCargoManifest);
BEGIN DBMS_OUTPUT.PUT_LINE('Add composed Primary Key fields "idContainer" & "idCargoManifest" to table "CargoManifestLine".'); END;

ALTER TABLE CargoManifestType
    ADD CONSTRAINT pk_CargoManifestType_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "CargoManifestType".'); END;

ALTER TABLE LogContainerOperations
    ADD CONSTRAINT pk_LogContainerOperations_id PRIMARY KEY (id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Primary Key field "id" to table "LogContainerOperations".'); END;

/*****************************
  Alter To Add Foreign Keys
*****************************/
ALTER TABLE Ship
    ADD CONSTRAINT fk_Ship_idTransport FOREIGN KEY (idTransport) REFERENCES Transport(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idTransport" to table "Ship" references table "Transport".'); END;
ALTER TABLE Ship
    ADD CONSTRAINT fk_Ship_idCapitan FOREIGN KEY (idCapitan) REFERENCES PlatformUser(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCapitan" to table "Ship" references table "PlatformUser".'); END;

ALTER TABLE Truck
    ADD CONSTRAINT fk_Truck_idTransport FOREIGN KEY (idTransport) REFERENCES Transport(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idTransport" to table "Truck" references table "Transport".'); END;

ALTER TABLE Border
    ADD CONSTRAINT fk_Border_idCountryBase FOREIGN KEY (idCountryBase) REFERENCES Country(description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCountryBase" to table "Border" references table "Country".'); END;
ALTER TABLE Border
    ADD CONSTRAINT fk_Border_idCountryBorder FOREIGN KEY (idCountryBorder) REFERENCES Country(description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCountryBorder" to table "Border" references table "Country".'); END;

ALTER TABLE Seadist
    ADD CONSTRAINT fk_BSeadist_idCargoSiteFrom FOREIGN KEY (idCargoSiteFrom) REFERENCES CargoSite(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCargoSiteFrom" to table "Seadist" references table "CargoSite".'); END;
ALTER TABLE Seadist
    ADD CONSTRAINT fk_Seadist_idCargoSiteTo FOREIGN KEY (idCargoSiteTo) REFERENCES CargoSite(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCargoSiteTo" to table "Seadist" references table "CargoSite".'); END;

ALTER TABLE Country
    ADD CONSTRAINT fk_Country_idContinent FOREIGN KEY (idContinent) REFERENCES Continent(description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idContinent" to table "Country" references table "Continent".'); END;

ALTER TABLE Transport
    ADD CONSTRAINT fk_Transport_idTransportType FOREIGN KEY (idTransportType) REFERENCES TransportType(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idTransportType" to table "Transport" references table "TransportType".'); END;

ALTER TABLE CargoSite
    ADD CONSTRAINT fk_CargoSite_idCargoSiteType FOREIGN KEY (idCargoSiteType) REFERENCES CargoSiteType(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCargoSiteType" to table "CargoSite" references table "CargoSiteType".'); END;
ALTER TABLE CargoSite
    ADD CONSTRAINT fk_CargoSite_idCountry FOREIGN KEY (idCountry) REFERENCES Country(description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCountry" to table "CargoSite" references table "Country".'); END;

ALTER TABLE PositionData
    ADD CONSTRAINT fk_PositionData_idShip FOREIGN KEY (idShip) REFERENCES Ship(idTransport);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idShip" to table "PositionData" references table "Ship".'); END;

ALTER TABLE PlatformUser
    ADD CONSTRAINT fk_PlatformUser_idRole FOREIGN KEY (idRole) REFERENCES Role(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idRole" to table "PlatformUser" references table "Role".'); END;

ALTER TABLE DatabaseAccountLink
    ADD CONSTRAINT fk_DatabaseAccountLink_idCapitan FOREIGN KEY (idCapitan) REFERENCES PlatformUser(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCapitan" to table "DatabaseAccountLink" references table "PlatformUser".'); END;

ALTER TABLE CargoManifest
    ADD CONSTRAINT fk_CargoManifest_idTransport FOREIGN KEY (idTransport) REFERENCES Transport(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idTransport" to table "CargoManifest" references table "Transport".'); END;
ALTER TABLE CargoManifest
    ADD CONSTRAINT fk_CargoManifest_idCargoSiteOrigin FOREIGN KEY (idCargoSiteOrigin) REFERENCES CargoSite(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCargoSiteOrigin" to table "CargoManifest" references table "CargoSite".'); END;
ALTER TABLE CargoManifest
    ADD CONSTRAINT fk_CargoManifest_idCargoSiteDestination FOREIGN KEY (idCargoSiteDestination) REFERENCES CargoSite(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCargoSiteDestination" to table "CargoManifest" references table "CargoSite".'); END;
ALTER TABLE CargoManifest
    ADD CONSTRAINT fk_CargoManifest_idCargoManifestType FOREIGN KEY (idCargoManifestType) REFERENCES CargoManifestType(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCargoManifestType" to table "CargoManifest" references table "CargoManifestType".'); END;

ALTER TABLE CargoManifestLine
    ADD CONSTRAINT fk_CargoManifestLine_idContainer FOREIGN KEY (idContainer) REFERENCES Container(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idContainer" to table "CargoManifestLine" references table "Container".'); END;
ALTER TABLE CargoManifestLine
    ADD CONSTRAINT fk_CargoManifestLine_idCargoManifest FOREIGN KEY (idCargoManifest) REFERENCES CargoManifest(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCargoManifest" to table "CargoManifestLine" references table "CargoManifest".'); END;
ALTER TABLE CargoManifestLine
    ADD CONSTRAINT fk_CargoManifestLine_idLeasingClient FOREIGN KEY (idLeasingClient) REFERENCES PlatformUser(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idLeasingClient" to table "CargoManifestLine" references table "PlatformUser".'); END;

ALTER TABLE LogContainerOperations
    ADD CONSTRAINT fk_LogContainerOperations_idContainer FOREIGN KEY (idContainer) REFERENCES Container(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idContainer" to table "LogContainerOperations" references table "Container".'); END;
ALTER TABLE LogContainerOperations
    ADD CONSTRAINT fk_LogContainerOperations_idCargoManifest FOREIGN KEY (idCargoManifest) REFERENCES CargoManifest(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idCargoManifest" to table "LogContainerOperations" references table "CargoManifest".'); END;
ALTER TABLE LogContainerOperations
    ADD CONSTRAINT fk_LogContainerOperations_idLeasingClient FOREIGN KEY (idLeasingClient) REFERENCES PlatformUser(id);
BEGIN DBMS_OUTPUT.PUT_LINE('Add Foreign Key field "idLeasingClient" to table "LogContainerOperations" references table "PlatformUser".'); END;

/*****************************
  Alter To Add Unique Constraint
*****************************/
ALTER TABLE Ship
    ADD CONSTRAINT un_Ship_mmsi UNIQUE (mmsi);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "mmsi" to table "Ship".'); END;
ALTER TABLE Ship
    ADD CONSTRAINT un_Ship_callSign UNIQUE (callSign);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "callSign" to table "Ship".'); END;
ALTER TABLE Ship
    ADD CONSTRAINT un_Ship_imoNumber UNIQUE (imoNumber);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "imoNumber" to table "Ship".'); END;

ALTER TABLE Truck
    ADD CONSTRAINT un_Truck_licensePlate UNIQUE (licensePlate);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "licensePlate" to table "Truck".'); END;

ALTER TABLE CargoSiteType
    ADD CONSTRAINT un_CargoSiteType_description UNIQUE (description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "description" to table "CargoSiteType".'); END;

ALTER TABLE Container
    ADD CONSTRAINT un_Container_identificationNumber UNIQUE (identificationNumber);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "identificationNumber" to table "Container".'); END;

ALTER TABLE PlatformUser
    ADD CONSTRAINT un_PlatformUser_username UNIQUE (username);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "username" to table "PlatformUser".'); END;

ALTER TABLE CargoManifestType
    ADD CONSTRAINT un_CargoManifestType_description UNIQUE (description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "username" to table "CargoManifestType".'); END;

ALTER TABLE TransPortType
    ADD CONSTRAINT un_TransPortType_description UNIQUE (description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "username" to table "TransPortType".'); END;

ALTER TABLE Role
    ADD CONSTRAINT un_Role_description UNIQUE (description);
BEGIN DBMS_OUTPUT.PUT_LINE('Add unique field "username" to table "Role".'); END;


/*****************************
  Alter To Add Check Constraint
*****************************/
/*ALTER TABLE Ship
ADD CONSTRAINT ck_Ship_idTransport check
    ( EXISTS(
        SELECT Transport.id
        FROM Transport
        INNER JOIN TransportType on TransportType.id = Transport.idTransportType
        WHERE Transport.id = idTransport AND TransportType.description = 'Ship')
    );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "idTransport" to table "Ship".'); END;*/
ALTER TABLE Ship
ADD CONSTRAINT ck_Ship_generators check ( generators >= 0);
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "generators" to table "Ship".'); END;
ALTER TABLE Ship
ADD CONSTRAINT ck_Ship_outputGenerator check ( outputGenerator >= 0);
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "outputGenerator" to table "Ship".'); END;
ALTER TABLE Ship
ADD CONSTRAINT ck_Ship_vesselType check ( vesselType >= 0);
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "vesselType" to table "Ship".'); END;
ALTER TABLE Ship
ADD CONSTRAINT ck_Ship_length check ( length >= 0);
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "length" to table "Ship".'); END;
ALTER TABLE Ship
ADD CONSTRAINT ck_Ship_width check ( width >= 0);
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "width" to table "Ship".'); END;
ALTER TABLE Ship
ADD CONSTRAINT ck_Ship_capacity check ( capacity >= 0);
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "capacity" to table "Ship".'); END;
ALTER TABLE Ship
ADD CONSTRAINT ck_Ship_draft check ( draft >= 0);
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "draft" to table "Ship".'); END;

ALTER TABLE Role
ADD CONSTRAINT ck_Role_description check
    ( description IN
        ('Client'
        ,'Fleet manager'
        ,'Traffic manager'
        ,'Warehouse staff'
        ,'Warehouse manager'
        ,'Port staff'
        ,'Port manager'
        ,'Ship captain'
        ,'Ship chief electrical engineer'
        ,'Truck driver')
    );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "description" to table "Role".'); END;

/*ALTER TABLE Truck
ADD CONSTRAINT ck_Truck_idTransport check
    ( EXISTS(
        SELECT Transport.id
        FROM Transport
        INNER JOIN TransportType on TransportType.id = Transport.idTransportType
        WHERE Transport.id = Truck.idTransport AND TransportType.description = 'Truck')
    );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "idTransport" to table "Truck".'); END;*/

ALTER TABLE Container
ADD CONSTRAINT ck_Container_maxWeight check ( maxWeight > 0 AND maxWeight > tareWeight );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "maxWeight" to table "Container".'); END;

ALTER TABLE Container
ADD CONSTRAINT ck_Container_tareWeight check ( tareWeight > 0 AND tareWeight < maxWeight );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "tareWeight" to table "Container".'); END;
ALTER TABLE Container
ADD CONSTRAINT ck_Container_maxVolume check ( maxVolume > 0 );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "maxVolume" to table "Container".'); END;
/*ALTER TABLE Container
ADD CONSTRAINT ck_Container_repair check ( repair > SYSDATE);
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "repair" to table "Container".'); END;*/

ALTER TABLE CargoSite
ADD CONSTRAINT ck_CargoSite_latitude check ( (latitude >= -90 AND latitude <= 90) );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "latitude" to table "CargoSite".'); END;
ALTER TABLE CargoSite
ADD CONSTRAINT ck_CargoSite_longitude check ( (longitude >= -180 AND longitude <= 180) );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "longitude" to table "CargoSite".'); END;

ALTER TABLE PositionData
ADD CONSTRAINT ck_PositionData_latitude check ( (latitude >= -90 AND latitude <= 90) OR latitude = 91 );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "latitude" to table "PositionData".'); END;
ALTER TABLE PositionData
ADD CONSTRAINT ck_PositionData_longitude check ( (longitude >= -180 AND longitude <= 180) OR longitude = 181 );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "longitude" to table "PositionData".'); END;
ALTER TABLE PositionData
ADD CONSTRAINT ck_PositionData_sog check (sog >= 0 );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "sog" to table "PositionData".'); END;
ALTER TABLE PositionData
ADD CONSTRAINT ck_PositionData_cog check (cog >= 0 AND cog <= 359 );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "cog" to table "PositionData".'); END;
ALTER TABLE PositionData
ADD CONSTRAINT ck_PositionData_heading check ( (heading >= 0 AND heading <= 359) OR heading = 511 );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "heading" to table "PositionData".'); END;
ALTER TABLE PositionData
ADD CONSTRAINT ck_PositionData_transceiverClass check ( transceiverClass IN ('A', 'B') );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "transceiverClass" to table "PositionData".'); END;

ALTER TABLE TransportType
ADD CONSTRAINT ck_TransportType_description check ( description IN ('Ship', 'Truck') );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "description" to table "TransportType".'); END;

ALTER TABLE CargoSiteType
ADD CONSTRAINT ck_CargoSiteType_description check ( description IN ('Port', 'Warehouse') );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "description" to table "CargoSiteType".'); END;

ALTER TABLE CargoManifestLine
ADD CONSTRAINT ck_CargoManifestLine_xPosition check ( xPosition >= 0 );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "xPosition" to table "CargoManifestLine".'); END;
ALTER TABLE CargoManifestLine
ADD CONSTRAINT ck_CargoManifestLine_yPosition check ( yPosition >= 0 );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "yPosition" to table "CargoManifestLine".'); END;
ALTER TABLE CargoManifestLine
ADD CONSTRAINT ck_CargoManifestLine_grossWeight check ( grossWeight > 0 );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "grossWeight" to table "CargoManifestLine".'); END;

ALTER TABLE CargoManifestType
ADD CONSTRAINT ck_CargoManifestType_description check ( description IN ('Load', 'Unload') );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "description" to table "CargoManifestType".'); END;

ALTER TABLE LogContainerOperations
ADD CONSTRAINT ck_LogContainerOperations_type check ( type IN ('Insert', 'Update', 'Delete') );
BEGIN DBMS_OUTPUT.PUT_LINE('Add check field "type" to table "LogContainerOperations".'); END;
