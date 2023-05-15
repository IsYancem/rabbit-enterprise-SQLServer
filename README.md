# rabbit-enterprise-SQLServer
---
<h1 align="center">Rabbit Enterprise Sales Management System</h1>

---

This project implements a database for a sales management system using SQL Server. The database is designed to manage user roles, sales, and customers.

<h2>Tables</h2>
The database schema includes the following tables:

**Users:** Stores system's users, including their role.
**Roles:** Defines the available user roles.
**Sales:** Records the sales made, including the employee who made the sale and the customer it was sold to.
**Customers:** Stores information about the customers.

<h2>Stored Procedures</h2>
The project includes stored procedures for performing CRUD (create, read, update, delete) operations on each table. The procedures are designed to respect the user role hierarchy, i.e., certain operations can only be performed by users with a specific role.

<h2>Triggers</h2>
Triggers are used to keep the tracking information in the tables up-to-date when modifications are made.

<h2>Database Backup</h2>
The project also includes a stored procedure for performing a database backup at the end of the day.

<h2>Installation</h2>
To install this project, you will need to have SQL Server installed on your machine. Then, you can run the provided SQL scripts to create the database, tables, stored procedures, and triggers.

<h2>Contribution</h2>
To contribute to this project, please fork the repository and create a pull request.
