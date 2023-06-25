# Dictionary


| **_Table_**  | **_Column_** | **_Description_**                                           |                                       
|:------------------------|:-----------------|:--------------------------------------------|
| PlatformUser |  | Application User |
| Role |  | Application User Role |
| PositionData |  | Ship position data |
| PositionData | dataTimeReceived | Ship position data reception timestamp |
| PositionData | sog | Acronym for Speed Over Ground, Speed of the Ship relative to the surface of the earth |
| PositionData | cog | Acronym for Course Over Ground, Actual course of a ship through the water |
| PositionData | heading | Ship compass direction in which the bow or nose is pointed (measured in degrees) |
| PositionData | position | mmsi of closest ship |
| PositionData | transcieverClass | Class of vessel (A,B) |
| Container |  | Portable compartment used to transport materials by truck, ship, and train |
| Container | identificationNumber | Container number is the most important and complex marking on the door and is a unique alpha-numeric sequence of four letters and seven numbers to identify containers internationally |
| Container | isoCod | Iso code, first character represents the length, the second character represents width and height and the third character is an identifier for container type and other characteristics. The 4th position is a new type of container code that indicates a container of reduced strength. |
| Container | maxWeight | Max weight of cargo container (kg)|
| Container | tareWeight | Weight of cargo container without payload (kg)|
| Container | maxVolume | Volume of cargo container without payload (m^3)|
| Container | repair | Final date of repair inspection |
| Container | temperature | Expected temperature of container (c) |
| TransportType |  | Type of transport (Ship, Truck) |
| Transport |  | Cargo transport |
| Ship | mmsi | Acronym for Maritime Mobile Service Identity |
| Ship | callSIgn | Ship unique identifier used in radio transmitions |
| Ship | imoNumber | Acronym for International Maritime Organization |
| Ship | numGen | Ship number of generators |
| Ship | genOutput | Ship total generator output |
| Ship | draft | Vertical distance between the waterline and the bottom of the ship's hull, in meters |
| CargoManifestLine | grossWeight | Total weight of container |
| CargoManifestType |  | Type of cargo manifest (Load, Unload) |
| CargoManifest |  | Group of cargo manifest lines |
| CargoSite |  | Location of container load and unload |
| CargoSiteType |  | Type of cargo site (Port, Warehouse) |
| Truck |  | Terrestrial cargo transport vehicle |
| Truck | licensePlate | Truck identification |
|  | latitude | Geographic coordinate the north-south position of a point on the Earth's surface ranging from -90 to 90 |
|  | longitude | Geographic coordinate the east-west position of a point on the Earth's surface ranging from -180 to 180 |
