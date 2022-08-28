DROP DATABASE IF EXISTS ctf_sql;
CREATE DATABASE IF NOT EXISTS ctf_sql;
USE ctf_sql;

DROP TABLE IF EXISTS initCompleted;
CREATE TABLE IF NOT EXISTS initCompleted (
   id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
   task VARCHAR(1024) NOT NULL
);

INSERT INTO initCompleted(id, task)
VALUES
   (1, '<!--The flag is: m1nd_the_SQL_!nj3cti0n-->'); -- Wrap in HTML comment so it is hidden when printed to HTML page

DROP TABLE IF EXISTS initToDos;
CREATE TABLE IF NOT EXISTS initToDos (
   id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
   task VARCHAR(1024) NOT NULL
);

INSERT INTO initToDos(id, task)
VALUES
   (1, 'Mow the lawn'),
   (2, 'Go grocery shopping'),
   (3, 'Take out the trash'),
   (4, 'Wash the dishes'),
   (5, 'Paint the house'),
   (6, 'Pay the bills'),
   (7, 'Walk the dog'),
   (8, 'Fill the car with gas'),
   (9, 'Pickup dry cleaning'),
   (10, 'Check the mail');
