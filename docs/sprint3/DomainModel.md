# OO Analysis #

The construction process of the domain model is based on the client specifications, especially the nouns (for _concepts_) and verbs (for _relations_) used. 

## Rationale to identify domain conceptual classes ##
To identify domain conceptual classes, start by making a list of candidate conceptual classes inspired by the list of categories suggested in the book "Applying UML and Patterns: An Introduction to Object-Oriented Analysis and Design and Iterative Development". 


### _Conceptual Class Category List_ ###

**Business Transactions**

* Container

---

**Transaction Line Itemss**

* Containers

---

**Product/Service related to a Transaction or Transaction Line Item**

* Containers
* Transportation
* Storage

---


**Transaction Records**

* Cargo Manifest (Load/Unload)

---  


**Roles of People or Organizations**

* Client
* Traffic Manager
* Ship Captain
* Truck Driver
* Ship Chief Eletrical Engineer
* Fleet Manager
* Port Staff
* Port Manager
* Warehouse Manager
* Warehouse Staff

---


**Places**

* Port
* Warehouse  

---

**Noteworthy Events**

* 

---


**Physical Objects**

* Container
* Truck
* Ship

---


**Descriptions of Things**

* Various containers


---


**Catalogs**

*  

---


**Containers**

*  

---


**Elements of Containers**

*  

---


**Organizations**

* Logistic Company  

---

**Other External/Collaborating Systems**

* 

---


**Records of finance, work, contracts, legal matters**

*

---


**Financial Instruments**

*  

---


**Documents mentioned/used to perform some work/**

* 
---



## **Rationale to identify associations between conceptual classes** ##
| Concept (A) 		            |  Association   |  Concept (B)                   |
|----------	   		            |:-------------: |------:                         |
| User  	                    | is a           | Client                         |
| User  	                    | is a           | Traffic Manager                |
| Traffic Manager  	            | Controls       | Ship                           |
| Traffic Manager  	            | Controls       | Truck                          |
| User  	                    | is a           | Ship Captain                   |
| Ship Captain                  | Oversees       | Ship                           |
| User  	                    | is a           | Ship Chief Eletrical Engineer  |
| Ship Chief Eletrical Engineer | Manages        | Ship                           |
| User  	                    | is a           | Truck Driver                   |
| Truck Driver                  | Controls       | Truck                          |
| User  	                    | is a           | Fleet Manager                  |
| Fleet Manager   	            | Controls       | Fleet                          |
| User  	                    | is a           | Port Staff                     |
| Port Staff  	                | Works at       | CargoSite                      |
| Port Staff  	                | Loads/Unloads  | Container                      |
| User  	                    | is a           | Port Manager                   |
| Port Manager                  | Manages        | CargoSite                      |
| User  	                    | is a           | Warehouse Manager              |
| Warehouse Manager             | Manages        | CargoSite                      |
| User  	                    | is a           | Warehouse Staff                |
| Warehouse Staff               | Works at       | CargoSite                      |
| Warehouse Staff               | Loads/Unloads  | Container                      |
| CargoSite                     | Stores         | Container                      |
| CargoSite                     | Has            | CargoSiteType                  |
| Manifest                      | Has            | ManifestType                   |
| Manifest                      | Has            | Inventory                      |
| Manifest                      | Has            | Client                         |
| Inventory                     | Has            | Container                      |
| Fleet                         | Has            | Ship                           |
| Fleet                         | Has            | Truck                          |
| Ship                          | Transports     | Inventory                      |
| Ship                          | Generates      | PositionalData                 |
| Truck                         | Transports     | Inventory                      |



---
# Domain Model
![DM.svg](DM.svg)



