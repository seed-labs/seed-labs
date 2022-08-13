# CTF - SQL Injection

---

## Docker

The `docker-compose.yml` file specifies two services and one network for Docker application.
One service is a frontend web application and the other service is a backend database; and the two services use the specified internal network to communicate with each other.

### Frontend Web Application

The frontend web application is an Apache web server with PHP.
There is one argument that can be specified for the fronted web app in the `docker-compose.yml` file: `hard_mode`, which accepts a value of `0` or `1`.
When `hard_mode` is set to `0`, the web app will show the user the results of successful SQL queries that are injected via the frontend.
When `hard_mode` is set to `1`, the web app will only show the user the results of failed SQL queries that are injected via the frontend.
* Example:
   * When `hard_mode==0`, successfully injecting the **valid** SQL query `SHOW TABLES` will show a webpage containing the results of the valid SQL query: the names of the tables in the database.
   * When `hard_mode==1`, successfully injecting the **valid** SQL query `SHOW TABLES` will not show the results of the valid SQL query; it will show the main to-do list page with all of the tasks in the list.
   * When `hard_mode==0`, successfully injecting the **invalid** SQL query `SHOOOW TTTABLES` will not show any output from the invalid SQL query; it will show the main to-do list page with all of the tasks in the list.
   * When `hard_mode==1`, successfully injecting the **invalid** SQL query `SHOOOW TTTABLES` will show a webpage displaying the error message describing the invalid SQL query.

### Backend Database

The backend database uses MySQL to maintain the data used by the frontend.
The database is initially populated with two tables, specified in `ctf_sql_database.sql`.
The two tables have the same simple layout, consisting of two columns: an int named `id`, and a string named `task`.
The database credentials are specified in the Dockerfile at `image_mysql/Dockerfile`.

### Internal Network

The internal network that the frontend and backend use to communicate with each other has subnet `10.9.0.0/24`, and the frontend web app has IP address `10.9.0.2`, and the backend database has IP address `10.9.0.3`.

### Running the Application

There are three provided shell scripts, `build.sh`, `start.sh`, and `stop.sh` that do as their filename suggests.
If the `hard_mode` argument is modifed for the frontend web application service defined in `docker-compose.yml`, then the application should be built again.
If there are any issues that arise while the application is running, the easiest form of troubleshooting will be to stop the application, build it again, and start it up.
**Building the application will delete any data other than the initial tables from the database.**
Users can access the application from a web browser, and should specify port `808` for non-TLS connections, and should specify port `4434` for TLS enabled connections. 

## Implementation

Whenever a web client connects to the web app, a new PHP session will be started.
Upon creation of a new PHP session, a copy of the two initial tables in the database will be made for each session.
This is so that each client will have their own copy of data in the database to manipulate.

### Known Defect

The system does not perform any cleanup of the database.
Since each new web client that is connected starts a new PHP session, which in turn will create two new tables in the database, this poses a risk for the database to grow too large.
It is a shortcoming of PHP to require input from a client before it can do anything, so PHP is not aware that a web client has disconnected because it's looking for input, which it won't receive since the client has disconnected.
If you suspect that the database is growing too large, you can manually delete tables from the database by connecting to the Docker container hosting the database, or simply delete the database by rebuilding the application.
