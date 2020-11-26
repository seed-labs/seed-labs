-- MySQL dump 10.13  Distrib 8.0.19, for Linux (x86_64)
--
-- Host: localhost    Database: elgg
-- ------------------------------------------------------
-- Server version	8.0.19-0ubuntu5

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


--
-- Table structure for table `elgg_access_collection_membership`
--

DROP TABLE IF EXISTS `elgg_access_collection_membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_access_collection_membership` (
  `user_guid` int unsigned NOT NULL,
  `access_collection_id` int NOT NULL,
  PRIMARY KEY (`user_guid`,`access_collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_access_collection_membership`
--

LOCK TABLES `elgg_access_collection_membership` WRITE;
/*!40000 ALTER TABLE `elgg_access_collection_membership` DISABLE KEYS */;
/*!40000 ALTER TABLE `elgg_access_collection_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_access_collections`
--

DROP TABLE IF EXISTS `elgg_access_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_access_collections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `owner_guid` int unsigned NOT NULL,
  `subtype` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_guid` (`owner_guid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_access_collections`
--

LOCK TABLES `elgg_access_collections` WRITE;
/*!40000 ALTER TABLE `elgg_access_collections` DISABLE KEYS */;
INSERT INTO `elgg_access_collections` VALUES (3,'friends',49,'friends'),(4,'friends',56,'friends'),(5,'friends',57,'friends'),(6,'friends',58,'friends'),(7,'friends',59,'friends');
/*!40000 ALTER TABLE `elgg_access_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_annotations`
--

DROP TABLE IF EXISTS `elgg_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_annotations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_guid` int unsigned NOT NULL,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value_type` enum('integer','text') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `owner_guid` int unsigned NOT NULL,
  `access_id` int NOT NULL,
  `time_created` int NOT NULL,
  `enabled` enum('yes','no') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`id`),
  KEY `entity_guid` (`entity_guid`),
  KEY `name` (`name`(50)),
  KEY `value` (`value`(50)),
  KEY `owner_guid` (`owner_guid`),
  KEY `access_id` (`access_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_annotations`
--

LOCK TABLES `elgg_annotations` WRITE;
/*!40000 ALTER TABLE `elgg_annotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `elgg_annotations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_api_users`
--

DROP TABLE IF EXISTS `elgg_api_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_api_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `api_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `secret` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `active` int DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_key` (`api_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_api_users`
--

LOCK TABLES `elgg_api_users` WRITE;
/*!40000 ALTER TABLE `elgg_api_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `elgg_api_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_config`
--

DROP TABLE IF EXISTS `elgg_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_config` (
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_config`
--

LOCK TABLES `elgg_config` WRITE;
/*!40000 ALTER TABLE `elgg_config` DISABLE KEYS */;
INSERT INTO `elgg_config` VALUES ('admin_registered','i:1;'),('allow_registration','b:0;'),('allow_user_default_access','s:0:\"\";'),('default_access','s:1:\"2\";'),('default_limit','i:10;'),('installed','i:1587927463;'),('language','s:2:\"en\";'),('lastcache','i:1587931381;'),('processed_upgrades','a:0:{}'),('require_admin_validation','b:0;'),('security_email_require_confirmation','b:1;'),('security_email_require_password','b:1;'),('security_notify_admins','b:1;'),('security_notify_user_password','b:1;'),('security_protect_upgrade','b:1;'),('simplecache_enabled','i:1;'),('simplecache_lastupdate','i:1587931381;'),('simplecache_minify_css','b:1;'),('simplecache_minify_js','b:1;'),('system_cache_enabled','i:1;'),('version','i:2017041200;'),('walled_garden','b:0;'),('__site_secret__','s:32:\"zZ4Ltc9KL550Vi6o6Ip6u4Rl2R8bZdq6\";');
/*!40000 ALTER TABLE `elgg_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_entities`
--

DROP TABLE IF EXISTS `elgg_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_entities` (
  `guid` int unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('object','user','group','site') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `subtype` varchar(252) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `owner_guid` int unsigned NOT NULL,
  `container_guid` int unsigned NOT NULL,
  `access_id` int NOT NULL,
  `time_created` int NOT NULL,
  `time_updated` int NOT NULL,
  `last_action` int NOT NULL DEFAULT '0',
  `enabled` enum('yes','no') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`guid`),
  KEY `type` (`type`),
  KEY `owner_guid` (`owner_guid`),
  KEY `container_guid` (`container_guid`),
  KEY `access_id` (`access_id`),
  KEY `time_created` (`time_created`),
  KEY `time_updated` (`time_updated`),
  KEY `subtype` (`subtype`),
  KEY `type_subtype` (`type`,`subtype`(50)),
  KEY `type_subtype_owner` (`type`,`subtype`(50),`owner_guid`),
  KEY `type_subtype_container` (`type`,`subtype`(50),`container_guid`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_entities`
--

LOCK TABLES `elgg_entities` WRITE;
/*!40000 ALTER TABLE `elgg_entities` DISABLE KEYS */;
INSERT INTO `elgg_entities` VALUES (1,'site','site',0,0,2,1587927463,1587927463,1587927463,'yes'),(2,'object','plugin',1,1,2,1587927463,1587927463,1587927463,'yes'),(3,'object','plugin',1,1,2,1587927463,1587927463,1587927463,'yes'),(4,'object','plugin',1,1,2,1587927463,1587927463,1587927463,'yes'),(5,'object','plugin',1,1,2,1587927463,1587927463,1587927463,'yes'),(6,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(7,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(8,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(9,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(10,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(11,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(12,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(13,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(14,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(15,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(16,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(17,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(18,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(19,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(20,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(21,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(22,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(23,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(24,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(25,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(26,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(27,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(28,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(29,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(30,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(31,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(32,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(33,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(34,'object','plugin',1,1,2,1587927464,1587927464,1587927464,'yes'),(35,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(36,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(37,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(38,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(39,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(40,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(41,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(42,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(43,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(44,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(45,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(46,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(47,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(48,'object','elgg_upgrade',1,1,0,1587927465,1587927465,1587927465,'yes'),(49,'user','user',0,0,2,1587927991,1587927991,1587931545,'yes'),(50,'object','widget',49,49,2,1587927991,1587927991,1587927991,'yes'),(51,'object','widget',49,49,2,1587927991,1587927991,1587927991,'yes'),(52,'object','widget',49,49,2,1587927991,1587927991,1587927991,'yes'),(53,'object','widget',49,49,2,1587927991,1587927991,1587927991,'yes'),(54,'object','widget',49,49,2,1587927991,1587927991,1587927991,'yes'),(56,'user','user',0,0,2,1587928901,1587928901,1587947242,'yes'),(57,'user','user',0,0,2,1587928968,1587928968,1587947274,'yes'),(58,'user','user',0,0,2,1587929000,1587929000,1587929519,'yes'),(59,'user','user',0,0,2,1587929031,1587929031,1587929587,'yes');
/*!40000 ALTER TABLE `elgg_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_entity_relationships`
--

DROP TABLE IF EXISTS `elgg_entity_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_entity_relationships` (
  `id` int NOT NULL AUTO_INCREMENT,
  `guid_one` int unsigned NOT NULL,
  `relationship` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `guid_two` int unsigned NOT NULL,
  `time_created` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `guid_one` (`guid_one`,`relationship`,`guid_two`),
  KEY `relationship` (`relationship`),
  KEY `guid_two` (`guid_two`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_entity_relationships`
--

LOCK TABLES `elgg_entity_relationships` WRITE;
/*!40000 ALTER TABLE `elgg_entity_relationships` DISABLE KEYS */;
INSERT INTO `elgg_entity_relationships` VALUES (2,3,'active_plugin',1,1587927464),(3,4,'active_plugin',1,1587927464),(4,5,'active_plugin',1,1587927464),(5,10,'active_plugin',1,1587927464),(6,11,'active_plugin',1,1587927464),(7,13,'active_plugin',1,1587927464),(8,14,'active_plugin',1,1587927464),(9,15,'active_plugin',1,1587927464),(10,16,'active_plugin',1,1587927464),(11,17,'active_plugin',1,1587927464),(12,18,'active_plugin',1,1587927464),(13,19,'active_plugin',1,1587927464),(14,21,'active_plugin',1,1587927464),(15,22,'active_plugin',1,1587927465),(16,23,'active_plugin',1,1587927465),(17,24,'active_plugin',1,1587927465),(18,25,'active_plugin',1,1587927465),(19,26,'active_plugin',1,1587927465),(20,27,'active_plugin',1,1587927465),(21,28,'active_plugin',1,1587927465),(22,30,'active_plugin',1,1587927465),(23,32,'active_plugin',1,1587927465),(24,33,'active_plugin',1,1587927465);
/*!40000 ALTER TABLE `elgg_entity_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_hmac_cache`
--

DROP TABLE IF EXISTS `elgg_hmac_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_hmac_cache` (
  `hmac` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ts` int NOT NULL,
  PRIMARY KEY (`hmac`),
  KEY `ts` (`ts`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_hmac_cache`
--

LOCK TABLES `elgg_hmac_cache` WRITE;
/*!40000 ALTER TABLE `elgg_hmac_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `elgg_hmac_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_metadata`
--

DROP TABLE IF EXISTS `elgg_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_metadata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_guid` int unsigned NOT NULL,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value_type` enum('integer','text') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `owner_guid` int DEFAULT NULL,
  `access_id` int DEFAULT NULL,
  `time_created` int NOT NULL,
  `enabled` enum('yes','no') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`id`),
  KEY `entity_guid` (`entity_guid`),
  KEY `name` (`name`(50)),
  KEY `value` (`value`(50))
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_metadata`
--

LOCK TABLES `elgg_metadata` WRITE;
/*!40000 ALTER TABLE `elgg_metadata` DISABLE KEYS */;
INSERT INTO `elgg_metadata` VALUES (1,1,'name','Elgg For SEED Labs','text',NULL,NULL,1587927463,'yes'),(2,1,'email','','text',NULL,NULL,1587927463,'yes'),(3,2,'title','activity','text',NULL,NULL,1587927463,'yes'),(4,3,'title','blog','text',NULL,NULL,1587927463,'yes'),(5,4,'title','bookmarks','text',NULL,NULL,1587927463,'yes'),(6,5,'title','ckeditor','text',NULL,NULL,1587927463,'yes'),(7,6,'title','custom_index','text',NULL,NULL,1587927464,'yes'),(8,7,'title','dashboard','text',NULL,NULL,1587927464,'yes'),(9,8,'title','developers','text',NULL,NULL,1587927464,'yes'),(10,9,'title','diagnostics','text',NULL,NULL,1587927464,'yes'),(11,10,'title','discussions','text',NULL,NULL,1587927464,'yes'),(12,11,'title','embed','text',NULL,NULL,1587927464,'yes'),(13,12,'title','externalpages','text',NULL,NULL,1587927464,'yes'),(14,13,'title','file','text',NULL,NULL,1587927464,'yes'),(15,14,'title','friends','text',NULL,NULL,1587927464,'yes'),(16,15,'title','friends_collections','text',NULL,NULL,1587927464,'yes'),(17,16,'title','garbagecollector','text',NULL,NULL,1587927464,'yes'),(18,17,'title','groups','text',NULL,NULL,1587927464,'yes'),(19,18,'title','invitefriends','text',NULL,NULL,1587927464,'yes'),(20,19,'title','likes','text',NULL,NULL,1587927464,'yes'),(21,20,'title','login_as','text',NULL,NULL,1587927464,'yes'),(22,21,'title','members','text',NULL,NULL,1587927464,'yes'),(23,22,'title','messageboard','text',NULL,NULL,1587927464,'yes'),(24,23,'title','messages','text',NULL,NULL,1587927464,'yes'),(25,24,'title','notifications','text',NULL,NULL,1587927464,'yes'),(26,25,'title','pages','text',NULL,NULL,1587927464,'yes'),(27,26,'title','profile','text',NULL,NULL,1587927464,'yes'),(28,27,'title','reportedcontent','text',NULL,NULL,1587927464,'yes'),(29,28,'title','search','text',NULL,NULL,1587927464,'yes'),(30,29,'title','site_notifications','text',NULL,NULL,1587927464,'yes'),(31,30,'title','system_log','text',NULL,NULL,1587927464,'yes'),(32,31,'title','tagcloud','text',NULL,NULL,1587927464,'yes'),(33,32,'title','thewire','text',NULL,NULL,1587927464,'yes'),(34,33,'title','uservalidationbyemail','text',NULL,NULL,1587927464,'yes'),(35,34,'title','web_services','text',NULL,NULL,1587927464,'yes'),(36,49,'banned','no','text',NULL,NULL,1587927991,'yes'),(37,49,'admin','yes','text',NULL,NULL,1587927991,'yes'),(38,49,'language','en','text',NULL,NULL,1587927991,'yes'),(39,49,'prev_last_action','1587931544','integer',NULL,NULL,1587927991,'yes'),(40,49,'last_login','1587931426','integer',NULL,NULL,1587927991,'yes'),(41,49,'prev_last_login','1587931324','integer',NULL,NULL,1587927991,'yes'),(42,49,'username','admin','text',NULL,NULL,1587927991,'yes'),(43,49,'email','elgg_admin@seed-labs.com','text',NULL,NULL,1587927991,'yes'),(44,49,'name','Admin','text',NULL,NULL,1587927991,'yes'),(45,49,'password_hash','$2y$10$j9pvoJTvCp/sLep76yjacOzUItYixgbZKrp/Uf7PL1UCR9lnLdnxK','text',NULL,NULL,1587927991,'yes'),(46,49,'notification:method:email','1','integer',NULL,NULL,1587927991,'yes'),(47,49,'validated','1','integer',NULL,NULL,1587927991,'yes'),(48,49,'validated_method','admin_user','text',NULL,NULL,1587927991,'yes'),(51,56,'banned','no','text',NULL,NULL,1587928901,'yes'),(52,56,'admin','no','text',NULL,NULL,1587928901,'yes'),(53,56,'language','en','text',NULL,NULL,1587928901,'yes'),(54,56,'prev_last_action','1587947241','integer',NULL,NULL,1587928901,'yes'),(55,56,'last_login','1587947239','integer',NULL,NULL,1587928901,'yes'),(56,56,'prev_last_login','1587939994','integer',NULL,NULL,1587928901,'yes'),(57,56,'username','alice','text',NULL,NULL,1587928901,'yes'),(58,56,'email','elgg_alice@seed-labs.com','text',NULL,NULL,1587928901,'yes'),(59,56,'name','Alice','text',NULL,NULL,1587928901,'yes'),(60,56,'password_hash','$2y$10$WrjVZAUAReACb309zIjVzeKh4vsJlwlASGf2N/9CHnG4cqOA4NfN2','text',NULL,NULL,1587928901,'yes'),(61,56,'notification:method:email','1','integer',NULL,NULL,1587928901,'yes'),(62,56,'admin_created','1','integer',NULL,NULL,1587928901,'yes'),(63,56,'created_by_guid','49','integer',NULL,NULL,1587928901,'yes'),(64,57,'banned','no','text',NULL,NULL,1587928968,'yes'),(65,57,'admin','no','text',NULL,NULL,1587928968,'yes'),(66,57,'language','en','text',NULL,NULL,1587928968,'yes'),(67,57,'prev_last_action','1587947259','integer',NULL,NULL,1587928968,'yes'),(68,57,'last_login','1587947253','integer',NULL,NULL,1587928968,'yes'),(69,57,'prev_last_login','1587929453','integer',NULL,NULL,1587928968,'yes'),(70,57,'username','boby','text',NULL,NULL,1587928968,'yes'),(71,57,'email','elgg_boby@seed-labs.com','text',NULL,NULL,1587928968,'yes'),(72,57,'name','Boby','text',NULL,NULL,1587928968,'yes'),(73,57,'password_hash','$2y$10$YEdANR8QtQdOm1Isk5n6.OxPEIzfpSSnw9Yvb4Wlviy3ppp2DEngi','text',NULL,NULL,1587928968,'yes'),(74,57,'notification:method:email','1','integer',NULL,NULL,1587928968,'yes'),(75,57,'admin_created','1','integer',NULL,NULL,1587928968,'yes'),(76,57,'created_by_guid','49','integer',NULL,NULL,1587928968,'yes'),(77,58,'banned','no','text',NULL,NULL,1587929000,'yes'),(78,58,'admin','no','text',NULL,NULL,1587929000,'yes'),(79,58,'language','en','text',NULL,NULL,1587929000,'yes'),(80,58,'prev_last_action','1587929505','integer',NULL,NULL,1587929000,'yes'),(81,58,'last_login','1587929484','integer',NULL,NULL,1587929000,'yes'),(82,58,'prev_last_login','0','integer',NULL,NULL,1587929000,'yes'),(83,58,'username','charlie','text',NULL,NULL,1587929000,'yes'),(84,58,'email','elgg_charlie@seed-labs.com','text',NULL,NULL,1587929000,'yes'),(85,58,'name','Charlie','text',NULL,NULL,1587929000,'yes'),(86,58,'password_hash','$2y$10$VMFH1C0dmAgHcXyAUySxCekz66W4epja5IZVHhR9N0WcounG2iaU.','text',NULL,NULL,1587929000,'yes'),(87,58,'notification:method:email','1','integer',NULL,NULL,1587929000,'yes'),(88,58,'admin_created','1','integer',NULL,NULL,1587929000,'yes'),(89,58,'created_by_guid','49','integer',NULL,NULL,1587929000,'yes'),(90,59,'banned','no','text',NULL,NULL,1587929031,'yes'),(91,59,'admin','no','text',NULL,NULL,1587929031,'yes'),(92,59,'language','en','text',NULL,NULL,1587929031,'yes'),(93,59,'prev_last_action','1587929573','integer',NULL,NULL,1587929031,'yes'),(94,59,'last_login','1587929553','integer',NULL,NULL,1587929031,'yes'),(95,59,'prev_last_login','1587929540','integer',NULL,NULL,1587929031,'yes'),(96,59,'username','samy','text',NULL,NULL,1587929031,'yes'),(97,59,'email','elgg_samy@seed-labs.com','text',NULL,NULL,1587929031,'yes'),(98,59,'name','Samy','text',NULL,NULL,1587929031,'yes'),(99,59,'password_hash','$2y$10$ClmMFwoMicPJaKFSZK84A.dzcLVZbWV4UnK.5fsLRPiFcBBo4qAgS','text',NULL,NULL,1587929031,'yes'),(100,59,'notification:method:email','1','integer',NULL,NULL,1587929031,'yes'),(101,59,'admin_created','1','integer',NULL,NULL,1587929031,'yes'),(102,59,'created_by_guid','49','integer',NULL,NULL,1587929031,'yes'),(103,56,'icontime','1587929076','integer',NULL,NULL,1587929076,'yes'),(104,56,'x1','0','integer',NULL,NULL,1587929076,'yes'),(105,56,'y1','0','integer',NULL,NULL,1587929076,'yes'),(106,56,'x2','384','integer',NULL,NULL,1587929076,'yes'),(107,56,'y2','384','integer',NULL,NULL,1587929076,'yes'),(108,57,'icontime','1587929468','integer',NULL,NULL,1587929468,'yes'),(109,57,'x1','0','integer',NULL,NULL,1587929468,'yes'),(110,57,'y1','0','integer',NULL,NULL,1587929468,'yes'),(111,57,'x2','229','integer',NULL,NULL,1587929468,'yes'),(112,57,'y2','229','integer',NULL,NULL,1587929468,'yes'),(113,58,'icontime','1587929505','integer',NULL,NULL,1587929505,'yes'),(114,58,'x1','0','integer',NULL,NULL,1587929505,'yes'),(115,58,'y1','0','integer',NULL,NULL,1587929505,'yes'),(116,58,'x2','287','integer',NULL,NULL,1587929505,'yes'),(117,58,'y2','287','integer',NULL,NULL,1587929505,'yes'),(118,59,'icontime','1587929565','integer',NULL,NULL,1587929565,'yes'),(119,59,'x1','0','integer',NULL,NULL,1587929565,'yes'),(120,59,'y1','0','integer',NULL,NULL,1587929565,'yes'),(121,59,'x2','728','integer',NULL,NULL,1587929565,'yes'),(122,59,'y2','728','integer',NULL,NULL,1587929565,'yes');
/*!40000 ALTER TABLE `elgg_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_migrations`
--

DROP TABLE IF EXISTS `elgg_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_migrations` (
  `version` bigint NOT NULL,
  `migration_name` varchar(100) DEFAULT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL,
  `breakpoint` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_migrations`
--

LOCK TABLES `elgg_migrations` WRITE;
/*!40000 ALTER TABLE `elgg_migrations` DISABLE KEYS */;
INSERT INTO `elgg_migrations` VALUES (20170728010000,'RemoveSiteGuid','2020-04-26 18:57:14','2020-04-26 18:57:14',0),(20170728020000,'MigrateDatalistsToConfig','2020-04-26 18:57:14','2020-04-26 18:57:14',0),(20170728030000,'DenormalizeMetastrings','2020-04-26 18:57:14','2020-04-26 18:57:14',0),(20170728040000,'ChangeTableEngine','2020-04-26 18:57:14','2020-04-26 18:57:14',0),(20170728050000,'ExpandTextColumnsToLongtext','2020-04-26 18:57:14','2020-04-26 18:57:14',0),(20170728060000,'RemoveLegacyPasswordHashes','2020-04-26 18:57:14','2020-04-26 18:57:14',0),(20170728072548,'CreateAccessCollectionsTable','2020-04-26 18:57:14','2020-04-26 18:57:14',0),(20170728073540,'CreateAccessCollectionMembershipTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728073706,'CreateAnnotationsTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728074504,'CreateApiUsersTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728074600,'CreateEntitiesTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728074645,'CreateEntityRelationshipsTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728074729,'CreateEntitySubtypesTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728074757,'CreateGeoCacheTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728074828,'CreateGroupsEntityTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728074857,'CreateHmacCacheTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728074925,'CreateMetadataTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728074959,'CreateObjectsEntityTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075027,'CreatePrivateSettingsTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075056,'CreateQueueTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075129,'CreateRiverTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075155,'CreateSitesEntityTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075232,'CreateSystemLogTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075306,'CreateUsersApiSessionsTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075337,'CreateUsersEntityTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075418,'CreateUsersRememberMeCookiesTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075454,'CreateUsersSessionsTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170728075716,'CreateConfigTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20170808084728,'DropGeocodeCache','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20171006111953,'DropSitesEntityTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20171006131622,'DropGroupsEntityTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20171009115032,'DropObjectsEntityTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20171010095648,'DropUsersEntityTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20171016113827,'UpdateMetadataColumns','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20171021111005,'AddSubtypeIndexToRiverTable','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20171021111059,'DenormalizeEntitySubtypes','2020-04-26 18:57:15','2020-04-26 18:57:15',0),(20171021111132,'AlignSubtypeColumns','2020-04-26 18:57:15','2020-04-26 18:57:16',0),(20171106100916,'AddAclSubtype','2020-04-26 18:57:16','2020-04-26 18:57:16',0),(20180109135052,'DropTypeSubtypeFromRiverTable','2020-04-26 18:57:16','2020-04-26 18:57:16',0),(20180609152817,'CreateSiteSecret','2020-04-26 18:57:16','2020-04-26 18:57:16',0),(20181107091651,'AddEntitiesSubtypeIndex','2020-04-26 18:57:16','2020-04-26 18:57:16',0),(20190125082345,'EntitiesAddTypeSubtypeIndex','2020-04-26 18:57:16','2020-04-26 18:57:16',0),(20190606111641,'EntitiesAddTypeSubtypeContainerAndOwnerIndexes','2020-04-26 18:57:16','2020-04-26 18:57:16',0),(20191015125417,'SetRiverEnabledToYes','2020-04-26 18:57:16','2020-04-26 18:57:16',0);
/*!40000 ALTER TABLE `elgg_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_private_settings`
--

DROP TABLE IF EXISTS `elgg_private_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_private_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_guid` int unsigned NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `entity_guid` (`entity_guid`,`name`),
  KEY `name` (`name`),
  KEY `value` (`value`(50))
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_private_settings`
--

LOCK TABLES `elgg_private_settings` WRITE;
/*!40000 ALTER TABLE `elgg_private_settings` DISABLE KEYS */;
INSERT INTO `elgg_private_settings` VALUES (1,2,'elgg:internal:priority','2'),(2,3,'elgg:internal:priority','3'),(3,4,'elgg:internal:priority','4'),(4,5,'elgg:internal:priority','5'),(5,6,'elgg:internal:priority','6'),(6,7,'elgg:internal:priority','7'),(7,8,'elgg:internal:priority','8'),(8,9,'elgg:internal:priority','9'),(9,10,'elgg:internal:priority','10'),(10,11,'elgg:internal:priority','11'),(11,12,'elgg:internal:priority','12'),(12,13,'elgg:internal:priority','13'),(13,14,'elgg:internal:priority','14'),(14,15,'elgg:internal:priority','15'),(15,16,'elgg:internal:priority','16'),(16,17,'elgg:internal:priority','17'),(17,18,'elgg:internal:priority','18'),(18,19,'elgg:internal:priority','19'),(19,20,'elgg:internal:priority','20'),(20,21,'elgg:internal:priority','1'),(21,22,'elgg:internal:priority','21'),(22,23,'elgg:internal:priority','22'),(23,24,'elgg:internal:priority','23'),(24,25,'elgg:internal:priority','24'),(25,26,'elgg:internal:priority','25'),(26,27,'elgg:internal:priority','26'),(27,28,'elgg:internal:priority','27'),(28,29,'elgg:internal:priority','28'),(29,30,'elgg:internal:priority','29'),(30,31,'elgg:internal:priority','30'),(31,32,'elgg:internal:priority','31'),(32,33,'elgg:internal:priority','32'),(33,34,'elgg:internal:priority','33'),(34,35,'id','core:2018041801'),(35,35,'class','Elgg\\Upgrades\\DeleteOldPlugins'),(36,35,'title','core:upgrade:2018041801:title'),(37,35,'description','core:upgrade:2018041801:description'),(38,35,'offset','0'),(39,35,'is_completed','1'),(40,36,'id','core:2018041800'),(41,36,'class','Elgg\\Upgrades\\ActivateNewPlugins'),(42,36,'title','core:upgrade:2018041800:title'),(43,36,'description','core:upgrade:2018041800:description'),(44,36,'offset','0'),(45,36,'is_completed','1'),(46,37,'id','core:2017080900'),(47,37,'class','Elgg\\Upgrades\\AlterDatabaseToMultiByteCharset'),(48,37,'title','core:upgrade:2017080900:title'),(49,37,'description','core:upgrade:2017080900:description'),(50,37,'offset','0'),(51,37,'is_completed','1'),(52,38,'id','core:2017080950'),(53,38,'class','Elgg\\Upgrades\\SetSecurityConfigDefaults'),(54,38,'title','core:upgrade:2017080950:title'),(55,38,'description','core:upgrade:2017080950:description'),(56,38,'offset','0'),(57,38,'is_completed','1'),(58,39,'id','core:2017121200'),(59,39,'class','Elgg\\Upgrades\\MigrateFriendsACL'),(60,39,'title','core:upgrade:2017121200:title'),(61,39,'description','core:upgrade:2017121200:description'),(62,39,'offset','0'),(63,39,'is_completed','1'),(64,40,'id','core:2018061401'),(65,40,'class','Elgg\\Upgrades\\MigrateCronLog'),(66,40,'title','core:upgrade:2018061401:title'),(67,40,'description','core:upgrade:2018061401:description'),(68,40,'offset','0'),(69,40,'is_completed','1'),(70,41,'id','core:2019071901'),(71,41,'class','Elgg\\Upgrades\\SecurityEmailChangeConfirmation'),(72,41,'title','core:upgrade:2019071901:title'),(73,41,'description','core:upgrade:2019071901:description'),(74,41,'offset','0'),(75,41,'is_completed','1'),(76,42,'id','discussions:2017112800'),(77,42,'class','\\Elgg\\Discussions\\Upgrades\\MigrateDiscussionReply'),(78,42,'title','discussions:upgrade:2017112800:title'),(79,42,'description','discussions:upgrade:2017112800:description'),(80,42,'offset','0'),(81,42,'is_completed','1'),(82,43,'id','discussions:2017112801'),(83,43,'class','\\Elgg\\Discussions\\Upgrades\\MigrateDiscussionReplyRiver'),(84,43,'title','discussions:upgrade:2017112801:title'),(85,43,'description','discussions:upgrade:2017112801:description'),(86,43,'offset','0'),(87,43,'is_completed','1'),(88,44,'id','groups:2016101900'),(89,44,'class','Elgg\\Groups\\Upgrades\\GroupIconTransfer'),(90,44,'title','groups:upgrade:2016101900:title'),(91,44,'description','groups:upgrade:2016101900:description'),(92,44,'offset','0'),(93,44,'is_completed','1'),(94,45,'id','likes:2017120700'),(95,45,'class','\\Elgg\\Likes\\Upgrades\\PublicLikesAnnotations'),(96,45,'title','likes:upgrade:2017120700:title'),(97,45,'description','likes:upgrade:2017120700:description'),(98,45,'offset','0'),(99,45,'is_completed','1'),(100,46,'id','pages:2017110700'),(101,46,'class','\\Elgg\\Pages\\Upgrades\\MigratePageTop'),(102,46,'title','pages:upgrade:2017110700:title'),(103,46,'description','pages:upgrade:2017110700:description'),(104,46,'offset','0'),(105,46,'is_completed','1'),(106,47,'id','profile:2017040700'),(107,47,'class','ElggPlugin\\Profile\\AnnotationMigration'),(108,47,'title','profile:upgrade:2017040700:title'),(109,47,'description','profile:upgrade:2017040700:description'),(110,47,'offset','0'),(111,47,'is_completed','1'),(112,48,'id','uservalidationbyemail:2019090600'),(113,48,'class','Elgg\\UserValidationByEmail\\Upgrades\\TrackValidationStatus'),(114,48,'title','uservalidationbyemail:upgrade:2019090600:title'),(115,48,'description','uservalidationbyemail:upgrade:2019090600:description'),(116,48,'offset','0'),(117,48,'is_completed','1'),(118,35,'start_time','1587927465'),(119,35,'completed_time','1587927465'),(120,36,'start_time','1587927465'),(121,36,'completed_time','1587927465'),(122,37,'start_time','1587927465'),(123,37,'completed_time','1587927465'),(124,38,'start_time','1587927465'),(125,38,'completed_time','1587927465'),(126,39,'start_time','1587927465'),(127,39,'completed_time','1587927465'),(128,40,'start_time','1587927465'),(129,40,'completed_time','1587927465'),(130,41,'start_time','1587927465'),(131,41,'completed_time','1587927465'),(132,42,'start_time','1587927465'),(133,42,'completed_time','1587927465'),(134,43,'start_time','1587927465'),(135,43,'completed_time','1587927465'),(136,44,'start_time','1587927465'),(137,44,'completed_time','1587927465'),(138,45,'start_time','1587927465'),(139,45,'completed_time','1587927465'),(140,46,'start_time','1587927465'),(141,46,'completed_time','1587927465'),(142,47,'start_time','1587927465'),(143,47,'completed_time','1587927465'),(144,48,'start_time','1587927466'),(145,48,'completed_time','1587927466'),(146,50,'handler','control_panel'),(147,50,'context','admin'),(148,50,'column','1'),(149,50,'order','0'),(150,51,'handler','admin_welcome'),(151,51,'context','admin'),(152,51,'order','10'),(153,51,'column','1'),(154,52,'handler','online_users'),(155,52,'context','admin'),(156,52,'column','2'),(157,52,'order','0'),(158,53,'handler','new_users'),(159,53,'context','admin'),(160,53,'order','10'),(161,53,'column','2'),(162,54,'handler','content_stats'),(163,54,'context','admin'),(164,54,'order','20'),(165,54,'column','2');
/*!40000 ALTER TABLE `elgg_private_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_queue`
--

DROP TABLE IF EXISTS `elgg_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_queue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `data` mediumblob NOT NULL,
  `timestamp` int NOT NULL,
  `worker` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `retrieve` (`timestamp`,`worker`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_queue`
--

LOCK TABLES `elgg_queue` WRITE;
/*!40000 ALTER TABLE `elgg_queue` DISABLE KEYS */;
INSERT INTO `elgg_queue` VALUES (1,'notifications',_binary 'C:48:\"Elgg\\Notifications\\SubscriptionNotificationEvent\":134:{O:8:\"stdClass\":4:{s:6:\"action\";s:10:\"make_admin\";s:9:\"object_id\";i:49;s:11:\"object_type\";s:4:\"user\";s:14:\"object_subtype\";s:4:\"user\";}}',1587927991,NULL);
/*!40000 ALTER TABLE `elgg_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_river`
--

DROP TABLE IF EXISTS `elgg_river`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_river` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `view` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `subject_guid` int unsigned NOT NULL,
  `object_guid` int unsigned NOT NULL,
  `target_guid` int unsigned NOT NULL,
  `annotation_id` int NOT NULL,
  `posted` int NOT NULL,
  `enabled` enum('yes','no') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`id`),
  KEY `action_type` (`action_type`),
  KEY `subject_guid` (`subject_guid`),
  KEY `object_guid` (`object_guid`),
  KEY `target_guid` (`target_guid`),
  KEY `annotation_id` (`annotation_id`),
  KEY `posted` (`posted`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_river`
--

LOCK TABLES `elgg_river` WRITE;
/*!40000 ALTER TABLE `elgg_river` DISABLE KEYS */;
INSERT INTO `elgg_river` VALUES (1,'update','river/user/default/profileiconupdate',56,56,0,0,1587929076,'yes'),(2,'update','river/user/default/profileiconupdate',57,57,0,0,1587929468,'yes'),(3,'update','river/user/default/profileiconupdate',58,58,0,0,1587929505,'yes'),(4,'update','river/user/default/profileiconupdate',59,59,0,0,1587929565,'yes');
/*!40000 ALTER TABLE `elgg_river` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_system_log`
--

DROP TABLE IF EXISTS `elgg_system_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_system_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `object_id` int NOT NULL,
  `object_class` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `object_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `object_subtype` varchar(252) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `event` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `performed_by_guid` int unsigned NOT NULL,
  `owner_guid` int unsigned NOT NULL,
  `access_id` int NOT NULL,
  `enabled` enum('yes','no') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'yes',
  `time_created` int NOT NULL,
  `ip_address` varchar(46) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `object_id` (`object_id`),
  KEY `object_class` (`object_class`),
  KEY `object_type` (`object_type`),
  KEY `object_subtype` (`object_subtype`),
  KEY `event` (`event`),
  KEY `performed_by_guid` (`performed_by_guid`),
  KEY `access_id` (`access_id`),
  KEY `time_created` (`time_created`),
  KEY `river_key` (`object_type`,`object_subtype`,`event`(25))
) ENGINE=InnoDB AUTO_INCREMENT=459 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_system_log`
--

LOCK TABLES `elgg_system_log` WRITE;
/*!40000 ALTER TABLE `elgg_system_log` DISABLE KEYS */;
INSERT INTO `elgg_system_log` VALUES (1,49,'ElggUser','user','user','logout:before',49,0,2,'yes',1587928826,'127.0.0.1'),(2,49,'ElggUser','user','user','logout:after',0,0,2,'yes',1587928826,'127.0.0.1'),(3,49,'ElggUser','user','user','login:before',0,0,2,'yes',1587928842,'127.0.0.1'),(4,41,'ElggMetadata','metadata','prev_last_login','update:before',49,0,2,'yes',1587928842,'127.0.0.1'),(5,41,'ElggMetadata','metadata','prev_last_login','update',49,0,2,'yes',1587928842,'127.0.0.1'),(6,41,'ElggMetadata','metadata','prev_last_login','update:after',49,0,2,'yes',1587928842,'127.0.0.1'),(7,40,'ElggMetadata','metadata','last_login','update:before',49,0,2,'yes',1587928842,'127.0.0.1'),(8,40,'ElggMetadata','metadata','last_login','update',49,0,2,'yes',1587928842,'127.0.0.1'),(9,40,'ElggMetadata','metadata','last_login','update:after',49,0,2,'yes',1587928842,'127.0.0.1'),(10,49,'ElggUser','user','user','login:after',49,0,2,'yes',1587928842,'127.0.0.1'),(11,0,'ElggMetadata','metadata','banned','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(12,51,'ElggMetadata','metadata','banned','create',49,0,2,'yes',1587928901,'127.0.0.1'),(13,51,'ElggMetadata','metadata','banned','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(14,0,'ElggMetadata','metadata','admin','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(15,52,'ElggMetadata','metadata','admin','create',49,0,2,'yes',1587928901,'127.0.0.1'),(16,52,'ElggMetadata','metadata','admin','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(17,0,'ElggMetadata','metadata','language','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(18,53,'ElggMetadata','metadata','language','create',49,0,2,'yes',1587928901,'127.0.0.1'),(19,53,'ElggMetadata','metadata','language','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(20,0,'ElggMetadata','metadata','prev_last_action','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(21,54,'ElggMetadata','metadata','prev_last_action','create',49,0,2,'yes',1587928901,'127.0.0.1'),(22,54,'ElggMetadata','metadata','prev_last_action','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(23,0,'ElggMetadata','metadata','last_login','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(24,55,'ElggMetadata','metadata','last_login','create',49,0,2,'yes',1587928901,'127.0.0.1'),(25,55,'ElggMetadata','metadata','last_login','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(26,0,'ElggMetadata','metadata','prev_last_login','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(27,56,'ElggMetadata','metadata','prev_last_login','create',49,0,2,'yes',1587928901,'127.0.0.1'),(28,56,'ElggMetadata','metadata','prev_last_login','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(29,0,'ElggMetadata','metadata','username','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(30,57,'ElggMetadata','metadata','username','create',49,0,2,'yes',1587928901,'127.0.0.1'),(31,57,'ElggMetadata','metadata','username','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(32,0,'ElggMetadata','metadata','email','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(33,58,'ElggMetadata','metadata','email','create',49,0,2,'yes',1587928901,'127.0.0.1'),(34,58,'ElggMetadata','metadata','email','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(35,0,'ElggMetadata','metadata','name','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(36,59,'ElggMetadata','metadata','name','create',49,0,2,'yes',1587928901,'127.0.0.1'),(37,59,'ElggMetadata','metadata','name','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(38,56,'ElggUser','user','user','create',49,0,2,'yes',1587928901,'127.0.0.1'),(39,0,'ElggMetadata','metadata','password_hash','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(40,60,'ElggMetadata','metadata','password_hash','create',49,0,2,'yes',1587928901,'127.0.0.1'),(41,60,'ElggMetadata','metadata','password_hash','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(42,0,'ElggMetadata','metadata','notification:method:email','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(43,61,'ElggMetadata','metadata','notification:method:email','create',49,0,2,'yes',1587928901,'127.0.0.1'),(44,61,'ElggMetadata','metadata','notification:method:email','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(45,56,'ElggUser','user','user','update',49,0,2,'yes',1587928901,'127.0.0.1'),(46,56,'ElggUser','user','user','update:after',49,0,2,'yes',1587928901,'127.0.0.1'),(47,0,'ElggMetadata','metadata','admin_created','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(48,62,'ElggMetadata','metadata','admin_created','create',49,0,2,'yes',1587928901,'127.0.0.1'),(49,62,'ElggMetadata','metadata','admin_created','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(50,0,'ElggMetadata','metadata','created_by_guid','create:before',49,0,2,'yes',1587928901,'127.0.0.1'),(51,63,'ElggMetadata','metadata','created_by_guid','create',49,0,2,'yes',1587928901,'127.0.0.1'),(52,63,'ElggMetadata','metadata','created_by_guid','create:after',49,0,2,'yes',1587928901,'127.0.0.1'),(53,0,'ElggMetadata','metadata','banned','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(54,64,'ElggMetadata','metadata','banned','create',49,0,2,'yes',1587928968,'127.0.0.1'),(55,64,'ElggMetadata','metadata','banned','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(56,0,'ElggMetadata','metadata','admin','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(57,65,'ElggMetadata','metadata','admin','create',49,0,2,'yes',1587928968,'127.0.0.1'),(58,65,'ElggMetadata','metadata','admin','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(59,0,'ElggMetadata','metadata','language','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(60,66,'ElggMetadata','metadata','language','create',49,0,2,'yes',1587928968,'127.0.0.1'),(61,66,'ElggMetadata','metadata','language','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(62,0,'ElggMetadata','metadata','prev_last_action','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(63,67,'ElggMetadata','metadata','prev_last_action','create',49,0,2,'yes',1587928968,'127.0.0.1'),(64,67,'ElggMetadata','metadata','prev_last_action','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(65,0,'ElggMetadata','metadata','last_login','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(66,68,'ElggMetadata','metadata','last_login','create',49,0,2,'yes',1587928968,'127.0.0.1'),(67,68,'ElggMetadata','metadata','last_login','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(68,0,'ElggMetadata','metadata','prev_last_login','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(69,69,'ElggMetadata','metadata','prev_last_login','create',49,0,2,'yes',1587928968,'127.0.0.1'),(70,69,'ElggMetadata','metadata','prev_last_login','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(71,0,'ElggMetadata','metadata','username','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(72,70,'ElggMetadata','metadata','username','create',49,0,2,'yes',1587928968,'127.0.0.1'),(73,70,'ElggMetadata','metadata','username','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(74,0,'ElggMetadata','metadata','email','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(75,71,'ElggMetadata','metadata','email','create',49,0,2,'yes',1587928968,'127.0.0.1'),(76,71,'ElggMetadata','metadata','email','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(77,0,'ElggMetadata','metadata','name','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(78,72,'ElggMetadata','metadata','name','create',49,0,2,'yes',1587928968,'127.0.0.1'),(79,72,'ElggMetadata','metadata','name','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(80,57,'ElggUser','user','user','create',49,0,2,'yes',1587928968,'127.0.0.1'),(81,0,'ElggMetadata','metadata','password_hash','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(82,73,'ElggMetadata','metadata','password_hash','create',49,0,2,'yes',1587928968,'127.0.0.1'),(83,73,'ElggMetadata','metadata','password_hash','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(84,0,'ElggMetadata','metadata','notification:method:email','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(85,74,'ElggMetadata','metadata','notification:method:email','create',49,0,2,'yes',1587928968,'127.0.0.1'),(86,74,'ElggMetadata','metadata','notification:method:email','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(87,57,'ElggUser','user','user','update',49,0,2,'yes',1587928968,'127.0.0.1'),(88,57,'ElggUser','user','user','update:after',49,0,2,'yes',1587928968,'127.0.0.1'),(89,0,'ElggMetadata','metadata','admin_created','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(90,75,'ElggMetadata','metadata','admin_created','create',49,0,2,'yes',1587928968,'127.0.0.1'),(91,75,'ElggMetadata','metadata','admin_created','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(92,0,'ElggMetadata','metadata','created_by_guid','create:before',49,0,2,'yes',1587928968,'127.0.0.1'),(93,76,'ElggMetadata','metadata','created_by_guid','create',49,0,2,'yes',1587928968,'127.0.0.1'),(94,76,'ElggMetadata','metadata','created_by_guid','create:after',49,0,2,'yes',1587928968,'127.0.0.1'),(95,0,'ElggMetadata','metadata','banned','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(96,77,'ElggMetadata','metadata','banned','create',49,0,2,'yes',1587929000,'127.0.0.1'),(97,77,'ElggMetadata','metadata','banned','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(98,0,'ElggMetadata','metadata','admin','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(99,78,'ElggMetadata','metadata','admin','create',49,0,2,'yes',1587929000,'127.0.0.1'),(100,78,'ElggMetadata','metadata','admin','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(101,0,'ElggMetadata','metadata','language','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(102,79,'ElggMetadata','metadata','language','create',49,0,2,'yes',1587929000,'127.0.0.1'),(103,79,'ElggMetadata','metadata','language','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(104,0,'ElggMetadata','metadata','prev_last_action','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(105,80,'ElggMetadata','metadata','prev_last_action','create',49,0,2,'yes',1587929000,'127.0.0.1'),(106,80,'ElggMetadata','metadata','prev_last_action','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(107,0,'ElggMetadata','metadata','last_login','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(108,81,'ElggMetadata','metadata','last_login','create',49,0,2,'yes',1587929000,'127.0.0.1'),(109,81,'ElggMetadata','metadata','last_login','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(110,0,'ElggMetadata','metadata','prev_last_login','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(111,82,'ElggMetadata','metadata','prev_last_login','create',49,0,2,'yes',1587929000,'127.0.0.1'),(112,82,'ElggMetadata','metadata','prev_last_login','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(113,0,'ElggMetadata','metadata','username','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(114,83,'ElggMetadata','metadata','username','create',49,0,2,'yes',1587929000,'127.0.0.1'),(115,83,'ElggMetadata','metadata','username','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(116,0,'ElggMetadata','metadata','email','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(117,84,'ElggMetadata','metadata','email','create',49,0,2,'yes',1587929000,'127.0.0.1'),(118,84,'ElggMetadata','metadata','email','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(119,0,'ElggMetadata','metadata','name','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(120,85,'ElggMetadata','metadata','name','create',49,0,2,'yes',1587929000,'127.0.0.1'),(121,85,'ElggMetadata','metadata','name','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(122,58,'ElggUser','user','user','create',49,0,2,'yes',1587929000,'127.0.0.1'),(123,0,'ElggMetadata','metadata','password_hash','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(124,86,'ElggMetadata','metadata','password_hash','create',49,0,2,'yes',1587929000,'127.0.0.1'),(125,86,'ElggMetadata','metadata','password_hash','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(126,0,'ElggMetadata','metadata','notification:method:email','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(127,87,'ElggMetadata','metadata','notification:method:email','create',49,0,2,'yes',1587929000,'127.0.0.1'),(128,87,'ElggMetadata','metadata','notification:method:email','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(129,58,'ElggUser','user','user','update',49,0,2,'yes',1587929000,'127.0.0.1'),(130,58,'ElggUser','user','user','update:after',49,0,2,'yes',1587929000,'127.0.0.1'),(131,0,'ElggMetadata','metadata','admin_created','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(132,88,'ElggMetadata','metadata','admin_created','create',49,0,2,'yes',1587929000,'127.0.0.1'),(133,88,'ElggMetadata','metadata','admin_created','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(134,0,'ElggMetadata','metadata','created_by_guid','create:before',49,0,2,'yes',1587929000,'127.0.0.1'),(135,89,'ElggMetadata','metadata','created_by_guid','create',49,0,2,'yes',1587929000,'127.0.0.1'),(136,89,'ElggMetadata','metadata','created_by_guid','create:after',49,0,2,'yes',1587929000,'127.0.0.1'),(137,0,'ElggMetadata','metadata','banned','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(138,90,'ElggMetadata','metadata','banned','create',49,0,2,'yes',1587929031,'127.0.0.1'),(139,90,'ElggMetadata','metadata','banned','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(140,0,'ElggMetadata','metadata','admin','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(141,91,'ElggMetadata','metadata','admin','create',49,0,2,'yes',1587929031,'127.0.0.1'),(142,91,'ElggMetadata','metadata','admin','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(143,0,'ElggMetadata','metadata','language','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(144,92,'ElggMetadata','metadata','language','create',49,0,2,'yes',1587929031,'127.0.0.1'),(145,92,'ElggMetadata','metadata','language','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(146,0,'ElggMetadata','metadata','prev_last_action','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(147,93,'ElggMetadata','metadata','prev_last_action','create',49,0,2,'yes',1587929031,'127.0.0.1'),(148,93,'ElggMetadata','metadata','prev_last_action','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(149,0,'ElggMetadata','metadata','last_login','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(150,94,'ElggMetadata','metadata','last_login','create',49,0,2,'yes',1587929031,'127.0.0.1'),(151,94,'ElggMetadata','metadata','last_login','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(152,0,'ElggMetadata','metadata','prev_last_login','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(153,95,'ElggMetadata','metadata','prev_last_login','create',49,0,2,'yes',1587929031,'127.0.0.1'),(154,95,'ElggMetadata','metadata','prev_last_login','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(155,0,'ElggMetadata','metadata','username','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(156,96,'ElggMetadata','metadata','username','create',49,0,2,'yes',1587929031,'127.0.0.1'),(157,96,'ElggMetadata','metadata','username','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(158,0,'ElggMetadata','metadata','email','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(159,97,'ElggMetadata','metadata','email','create',49,0,2,'yes',1587929031,'127.0.0.1'),(160,97,'ElggMetadata','metadata','email','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(161,0,'ElggMetadata','metadata','name','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(162,98,'ElggMetadata','metadata','name','create',49,0,2,'yes',1587929031,'127.0.0.1'),(163,98,'ElggMetadata','metadata','name','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(164,59,'ElggUser','user','user','create',49,0,2,'yes',1587929031,'127.0.0.1'),(165,0,'ElggMetadata','metadata','password_hash','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(166,99,'ElggMetadata','metadata','password_hash','create',49,0,2,'yes',1587929031,'127.0.0.1'),(167,99,'ElggMetadata','metadata','password_hash','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(168,0,'ElggMetadata','metadata','notification:method:email','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(169,100,'ElggMetadata','metadata','notification:method:email','create',49,0,2,'yes',1587929031,'127.0.0.1'),(170,100,'ElggMetadata','metadata','notification:method:email','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(171,59,'ElggUser','user','user','update',49,0,2,'yes',1587929031,'127.0.0.1'),(172,59,'ElggUser','user','user','update:after',49,0,2,'yes',1587929031,'127.0.0.1'),(173,0,'ElggMetadata','metadata','admin_created','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(174,101,'ElggMetadata','metadata','admin_created','create',49,0,2,'yes',1587929031,'127.0.0.1'),(175,101,'ElggMetadata','metadata','admin_created','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(176,0,'ElggMetadata','metadata','created_by_guid','create:before',49,0,2,'yes',1587929031,'127.0.0.1'),(177,102,'ElggMetadata','metadata','created_by_guid','create',49,0,2,'yes',1587929031,'127.0.0.1'),(178,102,'ElggMetadata','metadata','created_by_guid','create:after',49,0,2,'yes',1587929031,'127.0.0.1'),(179,49,'ElggUser','user','user','logout:before',49,0,2,'yes',1587929044,'127.0.0.1'),(180,49,'ElggUser','user','user','logout:after',0,0,2,'yes',1587929044,'127.0.0.1'),(181,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587929051,'127.0.0.1'),(182,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587929051,'127.0.0.1'),(183,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587929051,'127.0.0.1'),(184,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587929051,'127.0.0.1'),(185,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587929051,'127.0.0.1'),(186,0,'ElggMetadata','metadata','icontime','create:before',56,0,2,'yes',1587929076,'127.0.0.1'),(187,103,'ElggMetadata','metadata','icontime','create',56,0,2,'yes',1587929076,'127.0.0.1'),(188,103,'ElggMetadata','metadata','icontime','create:after',56,0,2,'yes',1587929076,'127.0.0.1'),(189,0,'ElggMetadata','metadata','x1','create:before',56,0,2,'yes',1587929076,'127.0.0.1'),(190,104,'ElggMetadata','metadata','x1','create',56,0,2,'yes',1587929076,'127.0.0.1'),(191,104,'ElggMetadata','metadata','x1','create:after',56,0,2,'yes',1587929076,'127.0.0.1'),(192,0,'ElggMetadata','metadata','y1','create:before',56,0,2,'yes',1587929076,'127.0.0.1'),(193,105,'ElggMetadata','metadata','y1','create',56,0,2,'yes',1587929076,'127.0.0.1'),(194,105,'ElggMetadata','metadata','y1','create:after',56,0,2,'yes',1587929076,'127.0.0.1'),(195,0,'ElggMetadata','metadata','x2','create:before',56,0,2,'yes',1587929076,'127.0.0.1'),(196,106,'ElggMetadata','metadata','x2','create',56,0,2,'yes',1587929076,'127.0.0.1'),(197,106,'ElggMetadata','metadata','x2','create:after',56,0,2,'yes',1587929076,'127.0.0.1'),(198,0,'ElggMetadata','metadata','y2','create:before',56,0,2,'yes',1587929076,'127.0.0.1'),(199,107,'ElggMetadata','metadata','y2','create',56,0,2,'yes',1587929076,'127.0.0.1'),(200,107,'ElggMetadata','metadata','y2','create:after',56,0,2,'yes',1587929076,'127.0.0.1'),(201,56,'ElggUser','user','user','profileiconupdate',56,0,2,'yes',1587929076,'127.0.0.1'),(202,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587929444,'127.0.0.1'),(203,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587929444,'127.0.0.1'),(204,57,'ElggUser','user','user','login:before',0,0,2,'yes',1587929453,'127.0.0.1'),(205,68,'ElggMetadata','metadata','last_login','update:before',57,0,2,'yes',1587929453,'127.0.0.1'),(206,68,'ElggMetadata','metadata','last_login','update',57,0,2,'yes',1587929453,'127.0.0.1'),(207,68,'ElggMetadata','metadata','last_login','update:after',57,0,2,'yes',1587929453,'127.0.0.1'),(208,57,'ElggUser','user','user','login:after',57,0,2,'yes',1587929453,'127.0.0.1'),(209,0,'ElggMetadata','metadata','icontime','create:before',57,0,2,'yes',1587929468,'127.0.0.1'),(210,108,'ElggMetadata','metadata','icontime','create',57,0,2,'yes',1587929468,'127.0.0.1'),(211,108,'ElggMetadata','metadata','icontime','create:after',57,0,2,'yes',1587929468,'127.0.0.1'),(212,0,'ElggMetadata','metadata','x1','create:before',57,0,2,'yes',1587929468,'127.0.0.1'),(213,109,'ElggMetadata','metadata','x1','create',57,0,2,'yes',1587929468,'127.0.0.1'),(214,109,'ElggMetadata','metadata','x1','create:after',57,0,2,'yes',1587929468,'127.0.0.1'),(215,0,'ElggMetadata','metadata','y1','create:before',57,0,2,'yes',1587929468,'127.0.0.1'),(216,110,'ElggMetadata','metadata','y1','create',57,0,2,'yes',1587929468,'127.0.0.1'),(217,110,'ElggMetadata','metadata','y1','create:after',57,0,2,'yes',1587929468,'127.0.0.1'),(218,0,'ElggMetadata','metadata','x2','create:before',57,0,2,'yes',1587929468,'127.0.0.1'),(219,111,'ElggMetadata','metadata','x2','create',57,0,2,'yes',1587929468,'127.0.0.1'),(220,111,'ElggMetadata','metadata','x2','create:after',57,0,2,'yes',1587929468,'127.0.0.1'),(221,0,'ElggMetadata','metadata','y2','create:before',57,0,2,'yes',1587929468,'127.0.0.1'),(222,112,'ElggMetadata','metadata','y2','create',57,0,2,'yes',1587929468,'127.0.0.1'),(223,112,'ElggMetadata','metadata','y2','create:after',57,0,2,'yes',1587929468,'127.0.0.1'),(224,57,'ElggUser','user','user','profileiconupdate',57,0,2,'yes',1587929468,'127.0.0.1'),(225,57,'ElggUser','user','user','logout:before',57,0,2,'yes',1587929477,'127.0.0.1'),(226,57,'ElggUser','user','user','logout:after',0,0,2,'yes',1587929477,'127.0.0.1'),(227,58,'ElggUser','user','user','login:before',0,0,2,'yes',1587929484,'127.0.0.1'),(228,81,'ElggMetadata','metadata','last_login','update:before',58,0,2,'yes',1587929484,'127.0.0.1'),(229,81,'ElggMetadata','metadata','last_login','update',58,0,2,'yes',1587929484,'127.0.0.1'),(230,81,'ElggMetadata','metadata','last_login','update:after',58,0,2,'yes',1587929484,'127.0.0.1'),(231,58,'ElggUser','user','user','login:after',58,0,2,'yes',1587929484,'127.0.0.1'),(232,0,'ElggMetadata','metadata','icontime','create:before',58,0,2,'yes',1587929505,'127.0.0.1'),(233,113,'ElggMetadata','metadata','icontime','create',58,0,2,'yes',1587929505,'127.0.0.1'),(234,113,'ElggMetadata','metadata','icontime','create:after',58,0,2,'yes',1587929505,'127.0.0.1'),(235,0,'ElggMetadata','metadata','x1','create:before',58,0,2,'yes',1587929505,'127.0.0.1'),(236,114,'ElggMetadata','metadata','x1','create',58,0,2,'yes',1587929505,'127.0.0.1'),(237,114,'ElggMetadata','metadata','x1','create:after',58,0,2,'yes',1587929505,'127.0.0.1'),(238,0,'ElggMetadata','metadata','y1','create:before',58,0,2,'yes',1587929505,'127.0.0.1'),(239,115,'ElggMetadata','metadata','y1','create',58,0,2,'yes',1587929505,'127.0.0.1'),(240,115,'ElggMetadata','metadata','y1','create:after',58,0,2,'yes',1587929505,'127.0.0.1'),(241,0,'ElggMetadata','metadata','x2','create:before',58,0,2,'yes',1587929505,'127.0.0.1'),(242,116,'ElggMetadata','metadata','x2','create',58,0,2,'yes',1587929505,'127.0.0.1'),(243,116,'ElggMetadata','metadata','x2','create:after',58,0,2,'yes',1587929505,'127.0.0.1'),(244,0,'ElggMetadata','metadata','y2','create:before',58,0,2,'yes',1587929505,'127.0.0.1'),(245,117,'ElggMetadata','metadata','y2','create',58,0,2,'yes',1587929505,'127.0.0.1'),(246,117,'ElggMetadata','metadata','y2','create:after',58,0,2,'yes',1587929505,'127.0.0.1'),(247,58,'ElggUser','user','user','profileiconupdate',58,0,2,'yes',1587929505,'127.0.0.1'),(248,58,'ElggUser','user','user','logout:before',58,0,2,'yes',1587929519,'127.0.0.1'),(249,58,'ElggUser','user','user','logout:after',0,0,2,'yes',1587929519,'127.0.0.1'),(250,59,'ElggUser','user','user','login:before',0,0,2,'yes',1587929540,'127.0.0.1'),(251,94,'ElggMetadata','metadata','last_login','update:before',59,0,2,'yes',1587929540,'127.0.0.1'),(252,94,'ElggMetadata','metadata','last_login','update',59,0,2,'yes',1587929540,'127.0.0.1'),(253,94,'ElggMetadata','metadata','last_login','update:after',59,0,2,'yes',1587929540,'127.0.0.1'),(254,59,'ElggUser','user','user','login:after',59,0,2,'yes',1587929540,'127.0.0.1'),(255,59,'ElggUser','user','user','logout:before',59,0,2,'yes',1587929545,'127.0.0.1'),(256,59,'ElggUser','user','user','logout:after',0,0,2,'yes',1587929545,'127.0.0.1'),(257,59,'ElggUser','user','user','login:before',0,0,2,'yes',1587929553,'127.0.0.1'),(258,95,'ElggMetadata','metadata','prev_last_login','update:before',59,0,2,'yes',1587929553,'127.0.0.1'),(259,95,'ElggMetadata','metadata','prev_last_login','update',59,0,2,'yes',1587929553,'127.0.0.1'),(260,95,'ElggMetadata','metadata','prev_last_login','update:after',59,0,2,'yes',1587929553,'127.0.0.1'),(261,94,'ElggMetadata','metadata','last_login','update:before',59,0,2,'yes',1587929553,'127.0.0.1'),(262,94,'ElggMetadata','metadata','last_login','update',59,0,2,'yes',1587929553,'127.0.0.1'),(263,94,'ElggMetadata','metadata','last_login','update:after',59,0,2,'yes',1587929553,'127.0.0.1'),(264,59,'ElggUser','user','user','login:after',59,0,2,'yes',1587929553,'127.0.0.1'),(265,0,'ElggMetadata','metadata','icontime','create:before',59,0,2,'yes',1587929565,'127.0.0.1'),(266,118,'ElggMetadata','metadata','icontime','create',59,0,2,'yes',1587929565,'127.0.0.1'),(267,118,'ElggMetadata','metadata','icontime','create:after',59,0,2,'yes',1587929565,'127.0.0.1'),(268,0,'ElggMetadata','metadata','x1','create:before',59,0,2,'yes',1587929565,'127.0.0.1'),(269,119,'ElggMetadata','metadata','x1','create',59,0,2,'yes',1587929565,'127.0.0.1'),(270,119,'ElggMetadata','metadata','x1','create:after',59,0,2,'yes',1587929565,'127.0.0.1'),(271,0,'ElggMetadata','metadata','y1','create:before',59,0,2,'yes',1587929565,'127.0.0.1'),(272,120,'ElggMetadata','metadata','y1','create',59,0,2,'yes',1587929565,'127.0.0.1'),(273,120,'ElggMetadata','metadata','y1','create:after',59,0,2,'yes',1587929565,'127.0.0.1'),(274,0,'ElggMetadata','metadata','x2','create:before',59,0,2,'yes',1587929565,'127.0.0.1'),(275,121,'ElggMetadata','metadata','x2','create',59,0,2,'yes',1587929565,'127.0.0.1'),(276,121,'ElggMetadata','metadata','x2','create:after',59,0,2,'yes',1587929565,'127.0.0.1'),(277,0,'ElggMetadata','metadata','y2','create:before',59,0,2,'yes',1587929565,'127.0.0.1'),(278,122,'ElggMetadata','metadata','y2','create',59,0,2,'yes',1587929565,'127.0.0.1'),(279,122,'ElggMetadata','metadata','y2','create:after',59,0,2,'yes',1587929565,'127.0.0.1'),(280,59,'ElggUser','user','user','profileiconupdate',59,0,2,'yes',1587929565,'127.0.0.1'),(281,59,'ElggUser','user','user','logout:before',59,0,2,'yes',1587929587,'127.0.0.1'),(282,59,'ElggUser','user','user','logout:after',0,0,2,'yes',1587929587,'127.0.0.1'),(283,49,'ElggUser','user','user','login:before',0,0,2,'yes',1587929601,'127.0.0.1'),(284,41,'ElggMetadata','metadata','prev_last_login','update:before',49,0,2,'yes',1587929601,'127.0.0.1'),(285,41,'ElggMetadata','metadata','prev_last_login','update',49,0,2,'yes',1587929601,'127.0.0.1'),(286,41,'ElggMetadata','metadata','prev_last_login','update:after',49,0,2,'yes',1587929601,'127.0.0.1'),(287,40,'ElggMetadata','metadata','last_login','update:before',49,0,2,'yes',1587929601,'127.0.0.1'),(288,40,'ElggMetadata','metadata','last_login','update',49,0,2,'yes',1587929601,'127.0.0.1'),(289,40,'ElggMetadata','metadata','last_login','update:after',49,0,2,'yes',1587929601,'127.0.0.1'),(290,49,'ElggUser','user','user','login:after',49,0,2,'yes',1587929601,'127.0.0.1'),(291,49,'ElggUser','user','user','logout:before',49,0,2,'yes',1587929650,'127.0.0.1'),(292,49,'ElggUser','user','user','logout:after',0,0,2,'yes',1587929650,'127.0.0.1'),(293,49,'ElggUser','user','user','login:before',0,0,2,'yes',1587929904,'127.0.0.1'),(294,41,'ElggMetadata','metadata','prev_last_login','update:before',49,0,2,'yes',1587929904,'127.0.0.1'),(295,41,'ElggMetadata','metadata','prev_last_login','update',49,0,2,'yes',1587929904,'127.0.0.1'),(296,41,'ElggMetadata','metadata','prev_last_login','update:after',49,0,2,'yes',1587929904,'127.0.0.1'),(297,40,'ElggMetadata','metadata','last_login','update:before',49,0,2,'yes',1587929904,'127.0.0.1'),(298,40,'ElggMetadata','metadata','last_login','update',49,0,2,'yes',1587929904,'127.0.0.1'),(299,40,'ElggMetadata','metadata','last_login','update:after',49,0,2,'yes',1587929904,'127.0.0.1'),(300,49,'ElggUser','user','user','login:after',49,0,2,'yes',1587929904,'127.0.0.1'),(301,1,'ElggRelationship','relationship','active_plugin','delete',49,0,2,'yes',1587930138,'127.0.0.1'),(302,49,'ElggUser','user','user','logout:before',49,0,2,'yes',1587930149,'127.0.0.1'),(303,49,'ElggUser','user','user','logout:after',0,0,2,'yes',1587930149,'127.0.0.1'),(304,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587930157,'127.0.0.1'),(305,56,'ElggMetadata','metadata','prev_last_login','update:before',56,0,2,'yes',1587930157,'127.0.0.1'),(306,56,'ElggMetadata','metadata','prev_last_login','update',56,0,2,'yes',1587930157,'127.0.0.1'),(307,56,'ElggMetadata','metadata','prev_last_login','update:after',56,0,2,'yes',1587930157,'127.0.0.1'),(308,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587930157,'127.0.0.1'),(309,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587930157,'127.0.0.1'),(310,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587930157,'127.0.0.1'),(311,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587930157,'127.0.0.1'),(312,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587930190,'127.0.0.1'),(313,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587930190,'127.0.0.1'),(314,49,'ElggUser','user','user','login:before',0,0,2,'yes',1587930219,'127.0.0.1'),(315,41,'ElggMetadata','metadata','prev_last_login','update:before',49,0,2,'yes',1587930219,'127.0.0.1'),(316,41,'ElggMetadata','metadata','prev_last_login','update',49,0,2,'yes',1587930219,'127.0.0.1'),(317,41,'ElggMetadata','metadata','prev_last_login','update:after',49,0,2,'yes',1587930219,'127.0.0.1'),(318,40,'ElggMetadata','metadata','last_login','update:before',49,0,2,'yes',1587930219,'127.0.0.1'),(319,40,'ElggMetadata','metadata','last_login','update',49,0,2,'yes',1587930219,'127.0.0.1'),(320,40,'ElggMetadata','metadata','last_login','update:after',49,0,2,'yes',1587930219,'127.0.0.1'),(321,49,'ElggUser','user','user','login:after',49,0,2,'yes',1587930219,'127.0.0.1'),(322,25,'ElggRelationship','relationship','active_plugin','create',49,0,2,'yes',1587930229,'127.0.0.1'),(323,49,'ElggUser','user','user','logout:before',49,0,2,'yes',1587930306,'127.0.0.1'),(324,49,'ElggUser','user','user','logout:after',0,0,2,'yes',1587930306,'127.0.0.1'),(325,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587930322,'127.0.0.1'),(326,56,'ElggMetadata','metadata','prev_last_login','update:before',56,0,2,'yes',1587930322,'127.0.0.1'),(327,56,'ElggMetadata','metadata','prev_last_login','update',56,0,2,'yes',1587930322,'127.0.0.1'),(328,56,'ElggMetadata','metadata','prev_last_login','update:after',56,0,2,'yes',1587930322,'127.0.0.1'),(329,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587930322,'127.0.0.1'),(330,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587930322,'127.0.0.1'),(331,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587930322,'127.0.0.1'),(332,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587930322,'127.0.0.1'),(333,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587930359,'127.0.0.1'),(334,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587930359,'127.0.0.1'),(335,49,'ElggUser','user','user','login:before',0,0,2,'yes',1587930363,'127.0.0.1'),(336,41,'ElggMetadata','metadata','prev_last_login','update:before',49,0,2,'yes',1587930363,'127.0.0.1'),(337,41,'ElggMetadata','metadata','prev_last_login','update',49,0,2,'yes',1587930363,'127.0.0.1'),(338,41,'ElggMetadata','metadata','prev_last_login','update:after',49,0,2,'yes',1587930363,'127.0.0.1'),(339,40,'ElggMetadata','metadata','last_login','update:before',49,0,2,'yes',1587930363,'127.0.0.1'),(340,40,'ElggMetadata','metadata','last_login','update',49,0,2,'yes',1587930363,'127.0.0.1'),(341,40,'ElggMetadata','metadata','last_login','update:after',49,0,2,'yes',1587930363,'127.0.0.1'),(342,49,'ElggUser','user','user','login:after',49,0,2,'yes',1587930363,'127.0.0.1'),(343,55,'ElggAdminNotice','object','admin_notice','delete:before',49,0,0,'yes',1587930400,'127.0.0.1'),(344,55,'ElggAdminNotice','object','admin_notice','delete',49,0,0,'yes',1587930400,'127.0.0.1'),(345,49,'ElggMetadata','metadata','admin_notice_id','delete',49,0,2,'yes',1587930401,'127.0.0.1'),(346,50,'ElggMetadata','metadata','description','delete',49,0,2,'yes',1587930401,'127.0.0.1'),(347,55,'ElggAdminNotice','object','admin_notice','delete:after',49,0,0,'yes',1587930401,'127.0.0.1'),(348,49,'ElggUser','user','user','logout:before',49,0,2,'yes',1587930542,'127.0.0.1'),(349,49,'ElggUser','user','user','logout:after',0,0,2,'yes',1587930542,'127.0.0.1'),(350,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587930727,'127.0.0.1'),(351,56,'ElggMetadata','metadata','prev_last_login','update:before',56,0,2,'yes',1587930727,'127.0.0.1'),(352,56,'ElggMetadata','metadata','prev_last_login','update',56,0,2,'yes',1587930727,'127.0.0.1'),(353,56,'ElggMetadata','metadata','prev_last_login','update:after',56,0,2,'yes',1587930727,'127.0.0.1'),(354,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587930727,'127.0.0.1'),(355,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587930727,'127.0.0.1'),(356,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587930727,'127.0.0.1'),(357,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587930727,'127.0.0.1'),(358,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587930797,'127.0.0.1'),(359,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587930797,'127.0.0.1'),(360,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587930974,'127.0.0.1'),(361,56,'ElggMetadata','metadata','prev_last_login','update:before',56,0,2,'yes',1587930974,'127.0.0.1'),(362,56,'ElggMetadata','metadata','prev_last_login','update',56,0,2,'yes',1587930974,'127.0.0.1'),(363,56,'ElggMetadata','metadata','prev_last_login','update:after',56,0,2,'yes',1587930974,'127.0.0.1'),(364,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587930974,'127.0.0.1'),(365,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587930974,'127.0.0.1'),(366,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587930974,'127.0.0.1'),(367,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587930974,'127.0.0.1'),(368,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587931115,'127.0.0.1'),(369,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587931115,'127.0.0.1'),(370,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587931126,'127.0.0.1'),(371,56,'ElggMetadata','metadata','prev_last_login','update:before',56,0,2,'yes',1587931126,'127.0.0.1'),(372,56,'ElggMetadata','metadata','prev_last_login','update',56,0,2,'yes',1587931126,'127.0.0.1'),(373,56,'ElggMetadata','metadata','prev_last_login','update:after',56,0,2,'yes',1587931126,'127.0.0.1'),(374,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587931126,'127.0.0.1'),(375,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587931126,'127.0.0.1'),(376,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587931126,'127.0.0.1'),(377,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587931126,'127.0.0.1'),(378,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587931154,'127.0.0.1'),(379,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587931154,'127.0.0.1'),(380,49,'ElggUser','user','user','login:before',0,0,2,'yes',1587931191,'127.0.0.1'),(381,41,'ElggMetadata','metadata','prev_last_login','update:before',49,0,2,'yes',1587931191,'127.0.0.1'),(382,41,'ElggMetadata','metadata','prev_last_login','update',49,0,2,'yes',1587931191,'127.0.0.1'),(383,41,'ElggMetadata','metadata','prev_last_login','update:after',49,0,2,'yes',1587931191,'127.0.0.1'),(384,40,'ElggMetadata','metadata','last_login','update:before',49,0,2,'yes',1587931191,'127.0.0.1'),(385,40,'ElggMetadata','metadata','last_login','update',49,0,2,'yes',1587931191,'127.0.0.1'),(386,40,'ElggMetadata','metadata','last_login','update:after',49,0,2,'yes',1587931191,'127.0.0.1'),(387,49,'ElggUser','user','user','login:after',49,0,2,'yes',1587931191,'127.0.0.1'),(388,25,'ElggRelationship','relationship','active_plugin','delete',49,0,2,'yes',1587931273,'127.0.0.1'),(389,49,'ElggUser','user','user','logout:before',49,0,2,'yes',1587931279,'127.0.0.1'),(390,49,'ElggUser','user','user','logout:after',0,0,2,'yes',1587931279,'127.0.0.1'),(391,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587931283,'127.0.0.1'),(392,56,'ElggMetadata','metadata','prev_last_login','update:before',56,0,2,'yes',1587931283,'127.0.0.1'),(393,56,'ElggMetadata','metadata','prev_last_login','update',56,0,2,'yes',1587931283,'127.0.0.1'),(394,56,'ElggMetadata','metadata','prev_last_login','update:after',56,0,2,'yes',1587931283,'127.0.0.1'),(395,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587931283,'127.0.0.1'),(396,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587931283,'127.0.0.1'),(397,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587931283,'127.0.0.1'),(398,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587931283,'127.0.0.1'),(399,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587931315,'127.0.0.1'),(400,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587931315,'127.0.0.1'),(401,49,'ElggUser','user','user','login:before',0,0,2,'yes',1587931324,'127.0.0.1'),(402,41,'ElggMetadata','metadata','prev_last_login','update:before',49,0,2,'yes',1587931324,'127.0.0.1'),(403,41,'ElggMetadata','metadata','prev_last_login','update',49,0,2,'yes',1587931324,'127.0.0.1'),(404,41,'ElggMetadata','metadata','prev_last_login','update:after',49,0,2,'yes',1587931324,'127.0.0.1'),(405,40,'ElggMetadata','metadata','last_login','update:before',49,0,2,'yes',1587931324,'127.0.0.1'),(406,40,'ElggMetadata','metadata','last_login','update',49,0,2,'yes',1587931324,'127.0.0.1'),(407,40,'ElggMetadata','metadata','last_login','update:after',49,0,2,'yes',1587931324,'127.0.0.1'),(408,49,'ElggUser','user','user','login:after',49,0,2,'yes',1587931324,'127.0.0.1'),(409,49,'ElggUser','user','user','logout:before',49,0,2,'yes',1587931388,'127.0.0.1'),(410,49,'ElggUser','user','user','logout:after',0,0,2,'yes',1587931388,'127.0.0.1'),(411,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587931396,'127.0.0.1'),(412,56,'ElggMetadata','metadata','prev_last_login','update:before',56,0,2,'yes',1587931396,'127.0.0.1'),(413,56,'ElggMetadata','metadata','prev_last_login','update',56,0,2,'yes',1587931396,'127.0.0.1'),(414,56,'ElggMetadata','metadata','prev_last_login','update:after',56,0,2,'yes',1587931396,'127.0.0.1'),(415,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587931396,'127.0.0.1'),(416,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587931396,'127.0.0.1'),(417,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587931396,'127.0.0.1'),(418,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587931396,'127.0.0.1'),(419,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587931423,'127.0.0.1'),(420,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587931423,'127.0.0.1'),(421,49,'ElggUser','user','user','login:before',0,0,2,'yes',1587931426,'127.0.0.1'),(422,41,'ElggMetadata','metadata','prev_last_login','update:before',49,0,2,'yes',1587931426,'127.0.0.1'),(423,41,'ElggMetadata','metadata','prev_last_login','update',49,0,2,'yes',1587931426,'127.0.0.1'),(424,41,'ElggMetadata','metadata','prev_last_login','update:after',49,0,2,'yes',1587931426,'127.0.0.1'),(425,40,'ElggMetadata','metadata','last_login','update:before',49,0,2,'yes',1587931426,'127.0.0.1'),(426,40,'ElggMetadata','metadata','last_login','update',49,0,2,'yes',1587931426,'127.0.0.1'),(427,40,'ElggMetadata','metadata','last_login','update:after',49,0,2,'yes',1587931426,'127.0.0.1'),(428,49,'ElggUser','user','user','login:after',49,0,2,'yes',1587931426,'127.0.0.1'),(429,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587939994,'127.0.0.1'),(430,56,'ElggMetadata','metadata','prev_last_login','update:before',56,0,2,'yes',1587939994,'127.0.0.1'),(431,56,'ElggMetadata','metadata','prev_last_login','update',56,0,2,'yes',1587939994,'127.0.0.1'),(432,56,'ElggMetadata','metadata','prev_last_login','update:after',56,0,2,'yes',1587939994,'127.0.0.1'),(433,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587939994,'127.0.0.1'),(434,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587939994,'127.0.0.1'),(435,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587939994,'127.0.0.1'),(436,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587939994,'127.0.0.1'),(437,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587947209,'127.0.0.1'),(438,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587947209,'127.0.0.1'),(439,56,'ElggUser','user','user','login:before',0,0,2,'yes',1587947239,'127.0.0.1'),(440,56,'ElggMetadata','metadata','prev_last_login','update:before',56,0,2,'yes',1587947239,'127.0.0.1'),(441,56,'ElggMetadata','metadata','prev_last_login','update',56,0,2,'yes',1587947239,'127.0.0.1'),(442,56,'ElggMetadata','metadata','prev_last_login','update:after',56,0,2,'yes',1587947239,'127.0.0.1'),(443,55,'ElggMetadata','metadata','last_login','update:before',56,0,2,'yes',1587947239,'127.0.0.1'),(444,55,'ElggMetadata','metadata','last_login','update',56,0,2,'yes',1587947239,'127.0.0.1'),(445,55,'ElggMetadata','metadata','last_login','update:after',56,0,2,'yes',1587947239,'127.0.0.1'),(446,56,'ElggUser','user','user','login:after',56,0,2,'yes',1587947239,'127.0.0.1'),(447,56,'ElggUser','user','user','logout:before',56,0,2,'yes',1587947242,'127.0.0.1'),(448,56,'ElggUser','user','user','logout:after',0,0,2,'yes',1587947242,'127.0.0.1'),(449,57,'ElggUser','user','user','login:before',0,0,2,'yes',1587947253,'127.0.0.1'),(450,69,'ElggMetadata','metadata','prev_last_login','update:before',57,0,2,'yes',1587947253,'127.0.0.1'),(451,69,'ElggMetadata','metadata','prev_last_login','update',57,0,2,'yes',1587947253,'127.0.0.1'),(452,69,'ElggMetadata','metadata','prev_last_login','update:after',57,0,2,'yes',1587947253,'127.0.0.1'),(453,68,'ElggMetadata','metadata','last_login','update:before',57,0,2,'yes',1587947253,'127.0.0.1'),(454,68,'ElggMetadata','metadata','last_login','update',57,0,2,'yes',1587947253,'127.0.0.1'),(455,68,'ElggMetadata','metadata','last_login','update:after',57,0,2,'yes',1587947253,'127.0.0.1'),(456,57,'ElggUser','user','user','login:after',57,0,2,'yes',1587947253,'127.0.0.1'),(457,57,'ElggUser','user','user','logout:before',57,0,2,'yes',1587947274,'127.0.0.1'),(458,57,'ElggUser','user','user','logout:after',0,0,2,'yes',1587947274,'127.0.0.1');
/*!40000 ALTER TABLE `elgg_system_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_users_apisessions`
--

DROP TABLE IF EXISTS `elgg_users_apisessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_users_apisessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_guid` int unsigned NOT NULL,
  `token` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `expires` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_guid` (`user_guid`),
  KEY `token` (`token`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_users_apisessions`
--

LOCK TABLES `elgg_users_apisessions` WRITE;
/*!40000 ALTER TABLE `elgg_users_apisessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `elgg_users_apisessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_users_remember_me_cookies`
--

DROP TABLE IF EXISTS `elgg_users_remember_me_cookies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_users_remember_me_cookies` (
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `guid` int unsigned NOT NULL,
  `timestamp` int unsigned NOT NULL,
  PRIMARY KEY (`code`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_users_remember_me_cookies`
--

LOCK TABLES `elgg_users_remember_me_cookies` WRITE;
/*!40000 ALTER TABLE `elgg_users_remember_me_cookies` DISABLE KEYS */;
/*!40000 ALTER TABLE `elgg_users_remember_me_cookies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elgg_users_sessions`
--

DROP TABLE IF EXISTS `elgg_users_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elgg_users_sessions` (
  `session` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ts` int unsigned NOT NULL DEFAULT '0',
  `data` mediumblob,
  PRIMARY KEY (`session`),
  KEY `ts` (`ts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elgg_users_sessions`
--

LOCK TABLES `elgg_users_sessions` WRITE;
/*!40000 ALTER TABLE `elgg_users_sessions` DISABLE KEYS */;
INSERT INTO `elgg_users_sessions` VALUES ('00d4uuner2rv206kvpirg1cp0d',1587931324,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"HvY0AeR5KnFH4e4BKn839B\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:49;}_sf2_meta|a:3:{s:1:\"u\";i:1587931324;s:1:\"c\";i:1587931315;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('18u5ckq61vl9tlilktr284d33c',1587931426,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"ho5vwtCLo2iKucpKmR2Ik1\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:49;}_sf2_meta|a:3:{s:1:\"u\";i:1587931426;s:1:\"c\";i:1587931423;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('1forrktql2qlsu5ir4t3jn6vh1',1587928842,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"CtyVuNbukiVimZI86jvGhq\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:49;}_sf2_meta|a:3:{s:1:\"u\";i:1587928842;s:1:\"c\";i:1587928826;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('293ohuhhm6cpkr2f3kn7rc9uui',1587947239,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"xt7333gWTylWoY85YwXYhY\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587947239;s:1:\"c\";i:1587947209;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('2ftcif6o1go23g1e3lmbdako1d',1587947253,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"NSM42RAaap_k7jRj8_8FKJ\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:57;}_sf2_meta|a:3:{s:1:\"u\";i:1587947253;s:1:\"c\";i:1587947242;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('3bujaomi8oicb7ane5crjc8ij5',1587939994,_binary '_sf2_attributes|a:2:{s:14:\"__elgg_session\";s:22:\"v82sv_3F1cw33uo2nUFQZN\";s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587939994;s:1:\"c\";i:1587939990;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('4c782qt1kqufv1kr1erlrro547',1587930219,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"iage_wMEL9rRtfUcuMXFve\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:49;}_sf2_meta|a:3:{s:1:\"u\";i:1587930219;s:1:\"c\";i:1587930190;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('6770i8gbir06ec9scbcphrdf6u',1587931545,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"ho5vwtCLo2iKucpKmR2Ik1\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:49;}_sf2_meta|a:3:{s:1:\"u\";i:1587931545;s:1:\"c\";i:1587931423;s:1:\"l\";s:1:\"0\";}'),('6i1g0oj6gvpgld8r3g3nas4hvr',1587939974,_binary '_sf2_attributes|a:2:{s:14:\"__elgg_session\";s:22:\"8Jek1CYpkdkL-hY7sk-mlx\";s:10:\"_elgg_msgs\";a:1:{s:5:\"error\";a:1:{i:0;s:38:\"Form is missing __token or __ts fields\";}}}_sf2_meta|a:3:{s:1:\"u\";i:1587939974;s:1:\"c\";i:1587939974;s:1:\"l\";s:1:\"0\";}'),('7nksth5ru3o68nikau0s9pi9fd',1587929553,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"4XLk9bPlSRA08ALwLBWIxG\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:59;}_sf2_meta|a:3:{s:1:\"u\";i:1587929552;s:1:\"c\";i:1587929545;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('8lm9a65tehtru62h6b1v243htb',1587930363,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"BVpkDtsmDNBkQmgEH13Cux\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:49;}_sf2_meta|a:3:{s:1:\"u\";i:1587930363;s:1:\"c\";i:1587930359;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('93nrke0491go9h255g974q54rn',1587931396,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"pgH5PjrFxFm89Rjz6bxQ1C\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587931396;s:1:\"c\";i:1587931388;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('b1ugofd7ml30nl62v26l8skss3',1587930727,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"BfT5PjYqzwpPyZcCW_8Ye6\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587930727;s:1:\"c\";i:1587930542;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('cs6md9rm57revn9d9quq2dsgp3',1587931191,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"VYzFZ1DJDpe-Qgz2gqIhXz\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:49;}_sf2_meta|a:3:{s:1:\"u\";i:1587931191;s:1:\"c\";i:1587931154;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('dclp3r07q8frleahb9uh3l5isq',1587929484,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"2liwVZXG3-kFhDZ64lv-PK\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:58;}_sf2_meta|a:3:{s:1:\"u\";i:1587929484;s:1:\"c\";i:1587929477;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('dedi803v9kmijjctu8e4cp2071',1587929540,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"nkaGI5twoPvxk6x2utuTJt\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:59;}_sf2_meta|a:3:{s:1:\"u\";i:1587929540;s:1:\"c\";i:1587929519;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('egudlsmbjak394slr1a9buo0uc',1587929601,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"cyHZ7rvkrRbTV_gQya528T\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:49;}_sf2_meta|a:3:{s:1:\"u\";i:1587929601;s:1:\"c\";i:1587929587;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('fn66nm4da67qp7hs3veo8t240a',1587931283,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"OH4tczzsFrPmJ97Sj4HeVn\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587931283;s:1:\"c\";i:1587931279;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('fvbn75pfgp4mnriq9h1krc8l4d',1587929904,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"nVfcZ-qFGeypnjP2XKKuBW\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:49;}_sf2_meta|a:3:{s:1:\"u\";i:1587929904;s:1:\"c\";i:1587929650;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('hpa2dmg91brs4up0o55jln1l6s',1587929051,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"SI4QRNzCZ8YaTMJ3kusnzD\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587929051;s:1:\"c\";i:1587929044;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('ht76t67j6bs51bpada1skcji63',1587930322,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"zcevT9z2Bm6Yg8J4vTB7g_\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587930322;s:1:\"c\";i:1587930306;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('ip6ejqf33unrgqvbe9q51ftbhm',1587940104,_binary '_sf2_attributes|a:2:{s:14:\"__elgg_session\";s:22:\"CM2KDGMB6MBQakfHRjaZiQ\";s:10:\"_elgg_msgs\";a:1:{s:5:\"error\";a:1:{i:0;s:38:\"Form is missing __token or __ts fields\";}}}_sf2_meta|a:3:{s:1:\"u\";i:1587940104;s:1:\"c\";i:1587940104;s:1:\"l\";s:1:\"0\";}'),('l23qa1rpr76p9sas1smcvagajh',1587939972,_binary '_sf2_attributes|a:2:{s:14:\"__elgg_session\";s:22:\"EcA2dAodSYueAHZWRLqNVt\";s:10:\"_elgg_msgs\";a:1:{s:5:\"error\";a:1:{i:0;s:38:\"Form is missing __token or __ts fields\";}}}_sf2_meta|a:3:{s:1:\"u\";i:1587939972;s:1:\"c\";i:1587939972;s:1:\"l\";s:1:\"0\";}'),('le3pjc41ea3g2mt5jngt8d7703',1587929453,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"D2cFnagLugMl0t7nY2gAEK\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:57;}_sf2_meta|a:3:{s:1:\"u\";i:1587929453;s:1:\"c\";i:1587929444;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('mhoqe68aqoklladv5josglroel',1587939968,_binary '_sf2_attributes|a:2:{s:14:\"__elgg_session\";s:22:\"U-xP4oE1_V07fO-jncBHD4\";s:10:\"_elgg_msgs\";a:1:{s:5:\"error\";a:1:{i:0;s:38:\"Form is missing __token or __ts fields\";}}}_sf2_meta|a:3:{s:1:\"u\";i:1587939968;s:1:\"c\";i:1587939968;s:1:\"l\";s:1:\"0\";}'),('nsrifro9pg1r137mk2dlq68fj6',1587930157,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"FGo3-q9Dg-vdImZ6WGciwC\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587930157;s:1:\"c\";i:1587930149;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('orbulnps77avm8tdietdr45e50',1587947274,_binary '_sf2_attributes|a:2:{s:14:\"__elgg_session\";s:22:\"0IRKLg07Jsh5LvsT6WWiGN\";s:10:\"_elgg_msgs\";a:0:{}}_sf2_meta|a:3:{s:1:\"u\";i:1587947274;s:1:\"c\";i:1587947274;s:1:\"l\";s:1:\"0\";}'),('q0m1gieof92tm82aqip3h2l4of',1587929728,_binary '_sf2_attributes|a:1:{s:14:\"__elgg_session\";s:22:\"vqLkKyX1pHtoLfP8pBF2FY\";}_sf2_meta|a:3:{s:1:\"u\";i:1587929728;s:1:\"c\";i:1587929728;s:1:\"l\";s:1:\"0\";}'),('q5te00nqbgf7e05k4uedfsdlim',1587940119,_binary '_sf2_attributes|a:2:{s:14:\"__elgg_session\";s:22:\"KkriJYthT2pwFI-qMdISny\";s:10:\"_elgg_msgs\";a:1:{s:5:\"error\";a:1:{i:0;s:38:\"Form is missing __token or __ts fields\";}}}_sf2_meta|a:3:{s:1:\"u\";i:1587940119;s:1:\"c\";i:1587940119;s:1:\"l\";s:1:\"0\";}'),('qiukh75cqmvb38qk8j27oenjbn',1587930974,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"5gNzP84TXJG4v9-CZtWvHh\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587930974;s:1:\"c\";i:1587930797;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}'),('t6e76ghletvathi7j9upmjn4ef',1587927991,_binary '_sf2_attributes|a:2:{s:14:\"__elgg_session\";s:22:\"_0AliSwFMxBZoDegI_gFhQ\";s:4:\"guid\";i:49;}_symfony_flashes|a:0:{}_sf2_meta|a:3:{s:1:\"u\";i:1587927991;s:1:\"c\";i:1587927991;s:1:\"l\";s:1:\"0\";}'),('v7msjac49204c7jml7psf6rv4v',1587931126,_binary '_sf2_attributes|a:3:{s:14:\"__elgg_session\";s:22:\"AB6sUZ01XY7kKfuaeBQurB\";s:10:\"_elgg_msgs\";a:0:{}s:4:\"guid\";i:56;}_sf2_meta|a:3:{s:1:\"u\";i:1587931126;s:1:\"c\";i:1587931115;s:1:\"l\";s:1:\"0\";}_symfony_flashes|a:0:{}');
/*!40000 ALTER TABLE `elgg_users_sessions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-04-26 20:30:41
