DROP DATABASE IF EXISTS ctf_sql;
CREATE DATABASE IF NOT EXISTS ctf_sql;
USE ctf_sql;

DROP TABLE IF EXISTS Secret;
CREATE TABLE IF NOT EXISTS Secret (
   id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
   task VARCHAR(1024) NOT NULL
);

INSERT INTO Secret(id, task)
VALUES
   (1, 'Not the flag'),
   (2, 'Not the flag'),
   (3, 'Not the flag'),
   (4, 'Not the flag'),
   (5, 'Not the flag'),
   (6, 'Not the flag'),
   (7, 'The flag is: secret'),
   (8, 'Not the flag'),
   (9, 'Not the flag'),
   (10, 'Not the flag');

DROP TABLE IF EXISTS ToDos;
CREATE TABLE IF NOT EXISTS ToDos (
   id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
   task VARCHAR(1024) NOT NULL
);

INSERT INTO ToDos(id, task)
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
