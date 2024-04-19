# **Functional Requirements for Food Bank Management System.**

### **User Registration and Profiles:**

*  The system **MUST** provide a registration form that includes username, password, email address, and role selection fields.
* User input for email addresses **MUST** be validated for the correct format.
*  Passwords **MUST** adhere to a defined strength policy.
* Administrators **MUST** have access to view and manage user profiles for monitoring and support purposes.

### **Donation Management:**

* Donors **MUST** register on the platform using a registration form with fields for username, password, email address, and organization details.
* Users **MUST NOT** have the ability to delete donor profiles without appropriate administrative permissions to prevent data loss.
* The system **MUST NOT** store donor passwords in plain text.
* Donors **MUST** have access to a donation entry form that includes fields for quantity, type of items, and expiration dates.
* Upon successful donation entry, the system **SHALL** automatically generate a donation receipt containing details such as donor information, item details, quantity, and date of donation.
* Users **MUST NOT** have the ability to tamper with the content or format of automatically generated donation receipts.

### **Inventory Management:**

* The system **MUST** have a centralized database to store and manage food inventory data in real time.
* The system **SHALL** supports a labeling system for efficient organization, allowing users to assign item labels or tags.
* The system **MUST** generate automatic alerts when the quantity of a specific item falls below a predefined threshold, indicating low stock levels.
* Users **MUST NOT** have the ability to modify the database structure to maintain data integrity directly.
* Unauthorized users **MUST NOT** access or attempt to alter the centralized database.
* Users **MUST NOT** be able to delete predefined system-wide categories to prevent unintentional data loss or inconsistency in categorization.
* Users **MUST NOT** have the capability to override or suppress critical alerts without proper authorization.

### **Volunteer Management:**

* Volunteers **MUST** register on the platform using a registration form with fields for username, password, email address, and organization details.
* Users **MUST NOT** have the ability to delete volunteer profiles without appropriate administrative permissions to prevent data loss.
* The system **MUST NOT** store volunteer passwords in plain text.
* Volunteers **MUST** have access to a volunteer entry form that includes fields for availability, skills. 
* Upon successful volunteer entry, the system SHALL automatically schedule for events like recruiting, assigning and tracking volunteer activities.
* Volunteers **MUST NOT** have the ability to tamper with the content or format of automatically generated volunteer entry forms.

### **Analytics and Announcing:**

* The graph generated **MUST** provide comprehensive dashboards displaying trends and insights across donations, distributions, inventory, and nutritional value of food items.
* The data **MUST** enable filtering and drill-down capabilities to analyze data by category, timeframe, donor, and recipient demographics.
* The dashboard **SHALL** integrate data visualization tools for a clear and impactful presentation of analytics.
* The data visualization **SHALL** allow exporting data for further analysis in external tools.
* The charts **MUST NOT** allow for the personalization of data, graphs with user names, and other relevant information.

