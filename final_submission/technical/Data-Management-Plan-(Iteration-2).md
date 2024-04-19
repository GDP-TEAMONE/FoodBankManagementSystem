Data Management Plan (Iteration 2)


Here below we have defined each functionality with the fields in respective tables.

## User:
This table stores general information about users of the system.
User_ID serves as the primary key, uniquely identifying each user.
Username stores the username chosen by the user for login.
Password stores the hashed password of the user for authentication.
Role specifies the role of the user within the system (e.g., administrator, donor, recipient, volunteer).
Email stores the email address of the user for communication purposes.

## Administrator:
This table holds additional information specific to administrators.
Admin_ID serves as the primary key, uniquely identifying each administrator.
User_ID is a foreign key referencing the User table, linking each administrator to their corresponding user account.

## Donor:
This table represents donors, who contribute items to the inventory.
Donor_ID serves as the primary key, uniquely identifying each donor.
User_ID is a foreign key referencing the User table, associating each donor with their user account.

## Recipient:
This table represents recipients, who receive items through orders or distributions.
Recipient_ID serves as the primary key, uniquely identifying each recipient.
User_ID is a foreign key referencing the User table, connecting each recipient to their user account.

## Volunteer:
This table represents volunteers who might participate in various activities within the system.
Volunteer_ID serves as the primary key, uniquely identifying each volunteer.
User_ID is a foreign key referencing the User table, linking each volunteer to their user account.

## Inventory:
This table maintains information about items available in the inventory.
Item_ID serves as the primary key, uniquely identifying each inventory item.
Donor_ID is a foreign key referencing the Donor table, indicating the donor who contributed the item.
Item_name stores the name or description of the item.
Quantity specifies the quantity of the item available in the inventory.
Expiration_date records the expiration date of the item.
Allergen_Info provides information about any allergens present in the item.

## Order:
This table records orders placed by recipients.
Order_ID serves as the primary key, uniquely identifying each order.
Order_date stores the date when the order was placed.
Recipient_ID is a foreign key referencing the Recipient table, identifying the recipient who placed the order.

## Distribution:
This table tracks distributions of items from donors to recipients.
Distribution_ID serves as the primary key, uniquely identifying each distribution.
Distribution_date records the date when the distribution occurred.
Recipient_ID is a foreign key referencing the Recipient table, specifying the recipient who received the distribution.
Donor_ID is a foreign key referencing the Donor table, indicating the donor who provided the items for distribution.

## Donation:
This table records donations made by donors.
Donation_ID serves as the primary key, uniquely identifying each donation.
Donor_ID is a foreign key referencing the Donor table, identifying the donor who made the donation.
Donation_date stores the date when the donation was made.
Quantity specifies the quantity of the donated item.
Item_name stores the name or description of the donated item.
Expiration_date records the expiration date of the donated item.

## Notification:
This table stores notifications for users.
Notification_ID serves as the primary key, uniquely identifying each notification.
Notification_date records the date when the notification was generated.
Notification_type specifies the type of notification.
Notification_content contains the content or message of the notification.
User_ID is a foreign key referencing the User table, identifying the user to whom the notification is addressed.