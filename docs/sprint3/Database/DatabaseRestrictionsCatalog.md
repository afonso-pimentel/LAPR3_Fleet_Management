## Database Restrictions

### `Identity restrictions`

|Table               | Column/s   | Restriction type | Restriction name
|:----------|:----------------------------------------|:-------|:-------
| CargoManifest | id | Primary Key | pk_CargoManifest_id
| CargoManifestLine | idContainer <br /> idCargoManifest | Primary Key | pk_CargoManifestLine_idContainer_idCargoManifest
| CargoManifestType | id | Primary Key | pk_CargoManifestType_id
| CargoSite | id | Primary Key | pk_CargoSite_id
| CargoSiteType | id | Primary Key | pk_CargoSiteType_id
| Container | id | Primary Key | pk_Container_id
| Continent | id | Primary Key | pk_Continent_id
| Country | id | Primary Key | pk_Country_id
| PlatformUser | id | Primary Key | pk_PlatformUser_id
| PositionData | idShip <br /> dateTimeReceiveddateTimeReceived | Primary Key | pk_PositionData_idShip_dateTimeReceived
| Role | id | Primary Key | pk_Role_id
| Ship | idTransport | Primary Key | pk_Ship_idTransport
| Transport | id | Primary Key | pk_Transport_id
| TransportType | id | Primary Key | pk_TransportType_id
| Truck | idTransport | Primary Key | pk_Truck_idTransport



### `Domain restrictions`

|Table               | Column/s   | Restriction type | Restriction name
|:----------|:----------------------------------------|:-------|:-------
| CargoManifestLine | xPosition | not null | n/a
| CargoManifestLine | yPosition | not null | n/a
| CargoManifestLine | zPosition | not null | n/a
| CargoManifestLine | grossWeight | not null | n/a
| CargoManifestType | description | not null | n/a
| CargoManifestType | description | unique | un_CargoManifestType_description
| CargoSiteType | description | not null | n/a
| CargoSiteType | description | unique | un_CargoSiteType_description
| Container | identificationNumber | unique | un_Container_identificationNumber
| Container | isoCod | not null | n/a
| Container | maxWeight | not null | n/a
| Container | tareWeight | not null | n/a
| Container | maxVolume | not null | n/a
| Container | repair | not null | n/a
| Container | idCsc | not null | n/a
| Continent | description | not null | n/a
| Continent | description | unique | un_Continent_description
| Country | description | not null | n/a
| PlatformUser | username | not null | n/a
| PlatformUser | username | unique | un_PlatformUser_username
| PlatformUser | password | not null | n/a
| PlatformUser | description | not null | n/a
| PositionData | latitude | not null | n/a
| PositionData | longitude | not null | n/a
| PositionData | sog | not null | n/a
| PositionData | cog | not null | n/a
| PositionData | heading | not null | n/a
| PositionData | position | not null | n/a
| PositionData | transceiverClass | not null | n/a
| Role | description | unique | un_Role_description
| Ship | mmsi | not null | n/a
| Ship | mmsi | unique | un_Ship_mmsi
| Ship | callSign | not null | n/a
| Ship | callSign | unique | un_Ship_callSign
| Ship | imoNumber | not null | n/a
| Ship | imoNumber | unique | un_Ship_imoNumber
| Ship | name | not null | n/a
| Ship | generators | not null | n/a
| Ship | outputGenerator | not null | n/a
| Ship | vesselType | not null | n/a
| Ship | length | not null | n/a
| Ship | width | not null | n/a
| Ship | capacity | not null | n/a
| Ship | draft | not null | n/a
| Transport | active | not null | n/a
| TransportType | description | not null | n/a
| Truck | licensePlate | not null | n/a
| Truck | licensePlate | unique | un_Truck_licensePlate




### `Referential restrictions`

|Table               | Column/s   | Restriction type | Restriction name | References
|:----------|:----------------------------------------|:-------|:-------|:-------
| CargoManifest | idTransport | Foreign Key | fk_CargoManifest_idTransport | Transport
| CargoManifest | idCargoSite | Foreign Key | fk_CargoManifest_idCargoSite | CargoSite
| CargoManifest | idCargoManifestType | Foreign Key | fk_CargoManifest_idCargoManifestType | CargoManifestType
| CargoManifestLine | idContainer | Foreign Key | fk_CargoManifestLine_idContainer | Container
| CargoManifestLine | idCargoManifest | Foreign Key | fk_CargoManifestLine_idCargoManifest | CargoManifest
| CargoSite | idCargoSiteType | Foreign Key | fk_CargoSite_idCargoSiteType | CargoSiteType
| CargoSite | idCountry | Foreign Key | fk_CargoSite_idCountry | Country
| Country | idContinent | Foreign Key | fk_Country_idContinent | Continent
| PlatformUser | idRole | Foreign Key | fk_PlatformUser_idRole | Role(id)
| PositionData | idShip | Foreign Key | fk_PositionData_idShip | Ship(idTransport)
| Ship | idTransport | Foreign Key | fk_Ship_idTransport | Transport(id)
| Transport | idTransportType | Foreign Key | fk_Ship_idTrafk_Transport_idTransportTypensport | TransportType(id)
| Truck | idTransport | Foreign Key | fk_Truck_idTransport | Transport(id)




### `Aplicational restrictions`

|Table               | Column/s   | Restriction type | Restriction name 
|:----------|:----------------------------------------|:-------|:-------
| CargoManifestLine | xPosition | Check ( xPosition >= 0 ) | ck_CargoManifestLine_xPosition
| CargoManifestLine | yPosition | check ( yPosition >= 0 ) | ck_CargoManifestLine_yPosition
| CargoManifestLine | grossWeight | check ( grossWeight > 0 ) | ck_CargoManifestLine_ZPosition
| CargoManifestType | description | check ( description IN ('Load', 'Unload') ) | ck_CargoManifestType_description
| CargoSite | latitude | check ( (latitude >= -90 AND latitude <= 90)  | ck_CargoSite_latitude
| CargoSite | longitude | check ( (longitude >= -90 AND longitude <= 90)  | ck_CargoSite_longitude
| CargoSiteType | description | check ( description IN ('Port', 'Warehouse')  | ck_CargoSiteType_description
| Container | maxWeight | check ( maxWeight > 0 AND maxWeight > tareWeight ) | ck_Container_maxWeight 
| Container | tareWeight | check ( tareWeight > 0 AND tareWeight < maxWeight ) | ck_Container_tareWeight 
| Container | maxVolume | check ( maxVolume > 0 ) | ck_Container_maxVolume 
| PositionData | latitude | check ( (latitude >= -90 AND latitude <= 90) OR latitude = 91 ) | ck_PositionData_latitude 
| PositionData | longitude | (longitude >= -180 AND longitude <= 180) OR longitude = 181 ) | ck_PositionData_longitude 
| PositionData | sog | check (sog >= 0 ) | ck_PositionData_sog 
| PositionData | cog | check (cog >= 0 AND cog <= 359 ) | ck_PositionData_cog 
| PositionData | heading | check ( (heading >= 0 AND heading <= 359) OR heading = 511 ) | ck_PositionData_heading 
| PositionData | transceiverClass | check ( transceiverClass IN ('A', 'B') ) | ck_PositionData_transceiverClass 
| Role | description | check ( description IN ('Client', </br>'Fleet manager, 'Traffic manager', </br>'Warehouse staff, 'Warehouse manager', </br>'Port staff, 'Port manager', </br>'Ship captain, 'Ship chief electrical engineer', </br>'Truck driver') | ck_Role_description 
| Ship | generators | check ( generators >= 0) | ck_Ship_generators 
| Ship | outputGenerator | check ( outputGenerator >= 0) | ck_Ship_outputGenerator 
| Ship | vesselType | check ( vesselType >= 0) | ck_Ship_vesselType 
| Ship | length | check ( length >= 0) | ck_Ship_length 
| Ship | width | check ( width >= 0) | ck_Ship_width 
| Ship | capacity | check ( capacity >= 0) | ck_Ship_capacity 
| Ship | draft | check ( draft >= 0) | ck_Ship_draft
| TransportType | description | check ( description IN ('Ship', 'Truck') | ck_TransportType_description
