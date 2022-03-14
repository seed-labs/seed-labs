-- MySQL dump 10.13  Distrib 5.5.32, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: Users
-- ------------------------------------------------------
-- Server version	5.5.32-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `credential`
--

DROP TABLE IF EXISTS `credential`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credential` (
  `ID` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  `EID` varchar(20) DEFAULT NULL,
  `Salary` int(9) DEFAULT NULL,
  `birth` varchar(20) DEFAULT NULL,
  `SSN` varchar(20) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT NULL,
  `Address` varchar(300) DEFAULT NULL,
  `Email` varchar(300) DEFAULT NULL,
  `NickName` varchar(300) DEFAULT NULL,
  `Password` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credential`
--

LOCK TABLES `credential` WRITE;
/*!40000 ALTER TABLE `credential` DISABLE KEYS */;
INSERT INTO `credential` VALUES 
(1,'Alice','10000',20000,'9/20','10211002','','','','','fdbe918bdae83000aa54747fc95fe0470fff4976'),
(2,'Boby','20000',30000,'4/20','10213352','','','','','b78ed97677c161c1c82c142906674ad15242b2d4'),
(3,'Ryan','30000',50000,'4/10','98993524','','','','','a3c50276cb120637cca669eb38fb9928b017e9ef'),
(4,'Samy','40000',90000,'1/11','32193525','','','','','995b8b8c183f349b3cab0ae7fccd39133508d2af'),
(5,'Ted','50000',110000,'11/3','32111111','','','','','99343bff28a7bb51cb6f22cb20a618701a2c2f58'),
(6,'Admin','99999','400000','3/5','43254314','','','','','a5bdf35a1df4ea895905f6f6618e83951a6effc0');
/*!40000 ALTER TABLE `credential` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-10-25 10:57:28
