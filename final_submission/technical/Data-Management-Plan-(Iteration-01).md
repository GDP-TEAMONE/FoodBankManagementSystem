### Data Management Plan (Iteration 1) for Food Bank Management System

#### Summary of Data to Store:

The Food Bank Management System aims to store comprehensive data to efficiently manage food distribution, donor information, volunteer records, and inventory tracking. The following fields will be included:

1.	##### User Data:  User ID (primary key), Name, Contact Details, User Type (Donor, Recipient, Volunteer, Administrator), Password (hashed and salted), Volunteer ID.
2.	##### Donation Data:  Donation ID (primary key), User ID (foreign key to User), Date, Quantity, Type, Expiration Date.
3.	##### Food Item Data:  Food Item ID (primary key), Name, Category, Allergen Info, Nutritional Info.
4.	##### Inventory Data:  Inventory ID (primary key), Food Item ID (foreign key to Food Item), Quantity, Location
5.	##### Recipient Data:  Recipient ID (primary key), User ID (foreign key to User), Eligibility Status, Family Size.
6.	##### Distribution Event Data:  Event ID (primary key), Date, Location, Volunteer Count.




![image](https://github.com/GDP-Team01/GDPProject_Team01/assets/137800301/33750bbc-1e3d-4933-b240-9639981d6822)




#### Initial Plans to Secure Data:

##### A.       Access Restriction:
Role-based access control will be implemented to ensure that only authorized personnel can access specific data.
Access to donor and volunteer data will be limited to authorized administrators.
Distribution records will be accessible only to authorized staff involved in distribution management.
##### B.	 Encryption:
To prevent unwanted access, industry-standard encryption techniques will be used to encrypt sensitive data, including donor contact information. To guarantee data integrity and secrecy, encryption will be used during data transmission between clients and the server via secure communication protocols (such as HTTPS).

#### Mapping of Functional Requirements to Data Storage:

##### 1.	User Management:   User Table stores information like name, contact information, and user type.

##### 2.	Donation Management:  Donation Table records donation transactions, including the donor (via User ID), date, quantity, type, and expiration date.

##### 3.	Food Item Management:  Food Item Table contains detailed information about food items, including name, category, allergen information, and nutritional information.

##### 4.	Inventory Management:  Inventory Table tracks the inventory of food items, including quantity and location, linked to Food Item via Food Item ID.

##### 5.	Recipient Management:  Recipient Table stores recipient information, including eligibility status and family size, linked to User via User  ID.

##### 6.	Distribution Event Management:    Distribution Events are tracked in the Distribution Event Table along with the date, location, and number of volunteers.
  


[FoodBankManagementSystem.pdf](https://github.com/GDP-Team01/GDPProject_Team01/files/14317475/FoodBankManagementSystem.3.1.pdf)


