## Data Management Plan (Iteration 1) for Food Bank Management System

#### Summary of Data to Store:
The Food Bank Management System aims to store comprehensive data to efficiently manage food distribution, donor information, volunteer records, and inventory tracking. The following fields will be included:

**User**: User_ID primary key, Username, Password, Role, Email;

**Administrator**: Admin_ID primary key, FOREIGN KEY (User_ID) REFERENCES User (User_ID));

**Donor**: Donor_ID int primary key, FOREIGN KEY (User_ID) REFERENCES User (User_ID));

**Recipient**: Recipient_ID int primary key, FOREIGN KEY (User_ID) REFERENCES User (User_ID));

**Volunteer**: Volunteer_ID int primary key, FOREIGN KEY (User_ID) REFERENCES User (User_ID));

**Inventory**: Item_ID int primary key, Donor_id, Item_name, Qunatity, Expiration_date, Allergen_Info 

**Order**: Order_ID int primary key, Order_date, FOREIGN KEY (Recipient_ID) REFERENCES Recipient (Recipient_ID)

**Distribution**: Distribution_ID int primary key, Distribution_date, FOREIGN KEY (Recipient_ID) REFERENCES Recipient (Recipient_ID), FOREIGN KEY (Donor_ID) REFERENCES Donor (Donor_ID)

**Donation**: Donation_ID int primary key, FOREIGN KEY (Donor_ID) REFERENCES Donor (Donor_ID), Donation_date, Quantity, Item_name, Expiration_date 

**Notification**: Notification_ID int primary key, Notification_date, Notification_type, Notification_content, FOREIGN KEY (User_ID) REFERENCES User (User_ID));


![image](https://github.com/GDP-Team01/GDPProject_Team01/assets/26596363/57280fb5-b490-460d-9d64-b5123df7f3d8)


#### Initial Plans to Secure Data:

####  A. Access Restriction:

Role-based access control will be implemented to ensure that only authorized personnel can access specific data. Access to donor and volunteer data will be limited to authorized administrators. Distribution records will be accessible only to authorized staff involved in distribution management.

####  B. Encryption:

To prevent unwanted access, industry-standard encryption techniques will be used to encrypt sensitive data, including donor contact information. To guarantee data integrity and secrecy, encryption will be used during data transmission between clients and the server via secure communication protocols (such as HTTPS).

####  Mapping of Functional Requirements to Data Storage:

1. User Management: User Table stores information like name, contact information, and user type.
2. Donation Management: Donation Table records donation transactions, including the donor (via User ID), date, quantity, type, and expiration date.
3. Food Item Management: Food Item Table contains detailed information about food items, including name, category, allergen information, and nutritional information.
4. Inventory Management: Inventory Table tracks the inventory of food items, including quantity and location, linked to Food Item via Food Item ID.
5. Recipient Management: Recipient Table stores recipient information, including eligibility status and family size, linked to User via User ID.
6. Distribution Event Management: Distribution Events are tracked in the Distribution Event Table along with the date, location, and number of volunteers.

[FoodBank Management System.pdf](https://github.com/GDP-Team01/GDPProject_Team01/files/14429274/FoodBank.Management.System.pdf)


