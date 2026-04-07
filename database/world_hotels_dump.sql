-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: world_hotels_db
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Temporary view structure for view `available_rooms_with_pricing`
--

DROP TABLE IF EXISTS `available_rooms_with_pricing`;
/*!50001 DROP VIEW IF EXISTS `available_rooms_with_pricing`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `available_rooms_with_pricing` AS SELECT 
 1 AS `room_id`,
 1 AS `room_number`,
 1 AS `hotel_id`,
 1 AS `city`,
 1 AS `address`,
 1 AS `room_type`,
 1 AS `max_guests`,
 1 AS `price_gbp`,
 1 AS `season_name`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `booking_pricing`
--

DROP TABLE IF EXISTS `booking_pricing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_pricing` (
  `pricing_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `base_price` decimal(10,2) NOT NULL COMMENT 'Price from prices table ├ù nights',
  `discount_percentage` int DEFAULT '0' COMMENT '0, 10, 20, or 30% based on advance days',
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `final_price` decimal(10,2) NOT NULL COMMENT 'base_price - discount_amount',
  `cancellation_charge` decimal(10,2) DEFAULT '0.00' COMMENT '0%, 50%, or 100% of final_price',
  `currency_code` varchar(3) DEFAULT 'GBP',
  PRIMARY KEY (`pricing_id`),
  UNIQUE KEY `booking_id` (`booking_id`),
  CONSTRAINT `booking_pricing_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `booking_pricing_chk_1` CHECK ((`discount_percentage` in (0,10,20,30))),
  CONSTRAINT `booking_pricing_chk_2` CHECK ((`discount_amount` >= 0)),
  CONSTRAINT `booking_pricing_chk_3` CHECK ((`final_price` >= 0)),
  CONSTRAINT `booking_pricing_chk_4` CHECK ((`cancellation_charge` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Booking pricing snapshot - one-to-one with bookings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_pricing`
--

LOCK TABLES `booking_pricing` WRITE;
/*!40000 ALTER TABLE `booking_pricing` DISABLE KEYS */;
INSERT INTO `booking_pricing` VALUES (1,1,600.00,30,180.00,420.00,0.00,'GBP'),(2,2,768.00,20,153.60,614.40,0.00,'GBP'),(3,3,1350.00,10,135.00,1215.00,0.00,'GBP');
/*!40000 ALTER TABLE `booking_pricing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `booking_summary`
--

DROP TABLE IF EXISTS `booking_summary`;
/*!50001 DROP VIEW IF EXISTS `booking_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `booking_summary` AS SELECT 
 1 AS `booking_id`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `email`,
 1 AS `hotel_city`,
 1 AS `room_type`,
 1 AS `room_number`,
 1 AS `check_in_date`,
 1 AS `check_out_date`,
 1 AS `nights`,
 1 AS `number_of_guests`,
 1 AS `final_price`,
 1 AS `status`,
 1 AS `booking_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `room_id` int NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `number_of_guests` int NOT NULL COMMENT 'Up to room type max_guests',
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('confirmed','cancelled','completed') DEFAULT 'confirmed',
  PRIMARY KEY (`booking_id`),
  KEY `idx_user_bookings` (`user_id`),
  KEY `idx_room_bookings` (`room_id`),
  KEY `idx_check_in` (`check_in_date`),
  KEY `idx_status` (`status`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `bookings_chk_1` CHECK ((`check_out_date` > `check_in_date`)),
  CONSTRAINT `bookings_chk_2` CHECK (((to_days(`check_out_date`) - to_days(`check_in_date`)) <= 30)),
  CONSTRAINT `bookings_chk_3` CHECK ((`number_of_guests` >= 1))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Customer bookings - max 30 days, 90 days advance';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,2,1201,'2025-04-15','2025-04-18',1,'2026-01-10 18:39:10','confirmed'),(2,3,721,'2025-06-01','2025-06-05',2,'2026-01-10 18:39:10','confirmed'),(3,4,1351,'2025-07-10','2025-07-15',4,'2026-01-10 18:39:10','confirmed');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exchange_rates`
--

DROP TABLE IF EXISTS `exchange_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exchange_rates` (
  `rate_id` int NOT NULL AUTO_INCREMENT,
  `currency_code` varchar(3) NOT NULL COMMENT 'ISO 4217: GBP, USD, EUR, NPR, etc.',
  `currency_name` varchar(50) NOT NULL,
  `rate_to_gbp` decimal(10,6) NOT NULL COMMENT 'Exchange rate to GBP (GBP = 1.0)',
  `effective_date` date NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`rate_id`),
  UNIQUE KEY `currency_code` (`currency_code`),
  KEY `idx_currency` (`currency_code`),
  KEY `idx_active` (`is_active`),
  CONSTRAINT `exchange_rates_chk_1` CHECK ((`rate_to_gbp` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Currency exchange rates - base currency GBP';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange_rates`
--

LOCK TABLES `exchange_rates` WRITE;
/*!40000 ALTER TABLE `exchange_rates` DISABLE KEYS */;
INSERT INTO `exchange_rates` VALUES (1,'GBP','British Pound',1.000000,'2025-01-01',1),(2,'USD','US Dollar',0.790000,'2025-01-01',1),(3,'EUR','Euro',0.860000,'2025-01-01',1),(4,'NPR','Nepalese Rupee',0.006000,'2025-01-01',1),(5,'INR','Indian Rupee',0.009500,'2025-01-01',1),(6,'AUD','Australian Dollar',0.520000,'2025-01-01',1),(7,'CAD','Canadian Dollar',0.590000,'2025-01-01',1),(8,'JPY','Japanese Yen',0.005300,'2025-01-01',1);
/*!40000 ALTER TABLE `exchange_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotels` (
  `hotel_id` int NOT NULL AUTO_INCREMENT,
  `city` varchar(100) NOT NULL COMMENT 'One of 17 UK cities',
  `capacity` int NOT NULL COMMENT 'Total number of rooms',
  `address` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`hotel_id`),
  KEY `idx_city` (`city`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Hotel information for 17 UK cities';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotels`
--

LOCK TABLES `hotels` WRITE;
/*!40000 ALTER TABLE `hotels` DISABLE KEYS */;
INSERT INTO `hotels` VALUES (1,'Aberdeen',90,'10 Union Street, Aberdeen AB10 1DD, UK','2026-01-10 18:39:09'),(2,'Belfast',80,'15 Royal Avenue, Belfast BT1 1DA, UK','2026-01-10 18:39:09'),(3,'Birmingham',110,'25 New Street, Birmingham B2 4BQ, UK','2026-01-10 18:39:09'),(4,'Bristol',100,'30 Broad Street, Bristol BS1 2EJ, UK','2026-01-10 18:39:09'),(5,'Cardiff',90,'45 Queen Street, Cardiff CF10 2BU, UK','2026-01-10 18:39:09'),(6,'Edinburgh',120,'50 Princes Street, Edinburgh EH2 2BY, UK','2026-01-10 18:39:09'),(7,'Glasgow',140,'60 Buchanan Street, Glasgow G1 3JN, UK','2026-01-10 18:39:09'),(8,'London',160,'100 Oxford Street, London W1D 1LL, UK','2026-01-10 18:39:09'),(9,'Manchester',150,'80 Deansgate, Manchester M3 2ER, UK','2026-01-10 18:39:09'),(10,'Newcastle',90,'20 Grey Street, Newcastle NE1 6AE, UK','2026-01-10 18:39:09'),(11,'Norwich',90,'35 Gentleman Walk, Norwich NR2 1NA, UK','2026-01-10 18:39:09'),(12,'Nottingham',110,'40 Market Square, Nottingham NG1 2DP, UK','2026-01-10 18:39:09'),(13,'Oxford',90,'55 High Street, Oxford OX1 4AP, UK','2026-01-10 18:39:09'),(14,'Plymouth',80,'65 Royal Parade, Plymouth PL1 1DS, UK','2026-01-10 18:39:09'),(15,'Swansea',70,'70 Wind Street, Swansea SA1 1EE, UK','2026-01-10 18:39:09'),(16,'Bournemouth',90,'75 Old Christchurch Road, Bournemouth BH1 1EW, UK','2026-01-10 18:39:09'),(17,'Kent',100,'85 High Street, Canterbury, Kent CT1 2JE, UK','2026-01-10 18:39:09');
/*!40000 ALTER TABLE `hotels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prices`
--

DROP TABLE IF EXISTS `prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prices` (
  `price_id` int NOT NULL AUTO_INCREMENT,
  `hotel_id` int NOT NULL,
  `room_type_id` int NOT NULL,
  `season_id` int NOT NULL,
  `price_gbp` decimal(10,2) NOT NULL COMMENT 'Base price in GBP',
  PRIMARY KEY (`price_id`),
  UNIQUE KEY `unique_price` (`hotel_id`,`room_type_id`,`season_id`),
  KEY `room_type_id` (`room_type_id`),
  KEY `season_id` (`season_id`),
  KEY `idx_hotel_pricing` (`hotel_id`,`room_type_id`,`season_id`),
  CONSTRAINT `prices_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prices_ibfk_2` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`room_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `prices_ibfk_3` FOREIGN KEY (`season_id`) REFERENCES `seasons` (`season_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Pricing matrix: hotel ├ù room_type ├ù season';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prices`
--

LOCK TABLES `prices` WRITE;
/*!40000 ALTER TABLE `prices` DISABLE KEYS */;
INSERT INTO `prices` VALUES (1,1,1,1,140.00),(2,1,1,2,140.00),(3,1,1,3,70.00),(4,1,1,4,70.00),(5,1,2,1,168.00),(6,1,2,2,168.00),(7,1,2,3,84.00),(8,1,2,4,84.00),(9,1,3,1,210.00),(10,1,3,2,210.00),(11,1,3,3,105.00),(12,1,3,4,105.00),(13,2,1,1,130.00),(14,2,1,2,130.00),(15,2,1,3,70.00),(16,2,1,4,70.00),(17,2,2,1,156.00),(18,2,2,2,156.00),(19,2,2,3,84.00),(20,2,2,4,84.00),(21,2,3,1,195.00),(22,2,3,2,195.00),(23,2,3,3,105.00),(24,2,3,4,105.00),(25,3,1,1,150.00),(26,3,1,2,150.00),(27,3,1,3,75.00),(28,3,1,4,75.00),(29,3,2,1,180.00),(30,3,2,2,180.00),(31,3,2,3,90.00),(32,3,2,4,90.00),(33,3,3,1,225.00),(34,3,3,2,225.00),(35,3,3,3,112.50),(36,3,3,4,112.50),(37,4,1,1,140.00),(38,4,1,2,140.00),(39,4,1,3,70.00),(40,4,1,4,70.00),(41,4,2,1,168.00),(42,4,2,2,168.00),(43,4,2,3,84.00),(44,4,2,4,84.00),(45,4,3,1,210.00),(46,4,3,2,210.00),(47,4,3,3,105.00),(48,4,3,4,105.00),(49,5,1,1,130.00),(50,5,1,2,130.00),(51,5,1,3,70.00),(52,5,1,4,70.00),(53,5,2,1,156.00),(54,5,2,2,156.00),(55,5,2,3,84.00),(56,5,2,4,84.00),(57,5,3,1,195.00),(58,5,3,2,195.00),(59,5,3,3,105.00),(60,5,3,4,105.00),(61,6,1,1,160.00),(62,6,1,2,160.00),(63,6,1,3,80.00),(64,6,1,4,80.00),(65,6,2,1,192.00),(66,6,2,2,192.00),(67,6,2,3,96.00),(68,6,2,4,96.00),(69,6,3,1,240.00),(70,6,3,2,240.00),(71,6,3,3,120.00),(72,6,3,4,120.00),(73,7,1,1,150.00),(74,7,1,2,150.00),(75,7,1,3,75.00),(76,7,1,4,75.00),(77,7,2,1,180.00),(78,7,2,2,180.00),(79,7,2,3,90.00),(80,7,2,4,90.00),(81,7,3,1,225.00),(82,7,3,2,225.00),(83,7,3,3,112.50),(84,7,3,4,112.50),(85,8,1,1,200.00),(86,8,1,2,200.00),(87,8,1,3,100.00),(88,8,1,4,100.00),(89,8,2,1,240.00),(90,8,2,2,240.00),(91,8,2,3,120.00),(92,8,2,4,120.00),(93,8,3,1,300.00),(94,8,3,2,300.00),(95,8,3,3,150.00),(96,8,3,4,150.00),(97,9,1,1,180.00),(98,9,1,2,180.00),(99,9,1,3,90.00),(100,9,1,4,90.00),(101,9,2,1,216.00),(102,9,2,2,216.00),(103,9,2,3,108.00),(104,9,2,4,108.00),(105,9,3,1,270.00),(106,9,3,2,270.00),(107,9,3,3,135.00),(108,9,3,4,135.00),(109,10,1,1,120.00),(110,10,1,2,120.00),(111,10,1,3,70.00),(112,10,1,4,70.00),(113,10,2,1,144.00),(114,10,2,2,144.00),(115,10,2,3,84.00),(116,10,2,4,84.00),(117,10,3,1,180.00),(118,10,3,2,180.00),(119,10,3,3,105.00),(120,10,3,4,105.00),(121,11,1,1,130.00),(122,11,1,2,130.00),(123,11,1,3,70.00),(124,11,1,4,70.00),(125,11,2,1,156.00),(126,11,2,2,156.00),(127,11,2,3,84.00),(128,11,2,4,84.00),(129,11,3,1,195.00),(130,11,3,2,195.00),(131,11,3,3,105.00),(132,11,3,4,105.00),(133,12,1,1,130.00),(134,12,1,2,130.00),(135,12,1,3,70.00),(136,12,1,4,70.00),(137,12,2,1,156.00),(138,12,2,2,156.00),(139,12,2,3,84.00),(140,12,2,4,84.00),(141,12,3,1,195.00),(142,12,3,2,195.00),(143,12,3,3,105.00),(144,12,3,4,105.00),(145,13,1,1,180.00),(146,13,1,2,180.00),(147,13,1,3,90.00),(148,13,1,4,90.00),(149,13,2,1,216.00),(150,13,2,2,216.00),(151,13,2,3,108.00),(152,13,2,4,108.00),(153,13,3,1,270.00),(154,13,3,2,270.00),(155,13,3,3,135.00),(156,13,3,4,135.00),(157,14,1,1,180.00),(158,14,1,2,180.00),(159,14,1,3,90.00),(160,14,1,4,90.00),(161,14,2,1,216.00),(162,14,2,2,216.00),(163,14,2,3,108.00),(164,14,2,4,108.00),(165,14,3,1,270.00),(166,14,3,2,270.00),(167,14,3,3,135.00),(168,14,3,4,135.00),(169,15,1,1,130.00),(170,15,1,2,130.00),(171,15,1,3,70.00),(172,15,1,4,70.00),(173,15,2,1,156.00),(174,15,2,2,156.00),(175,15,2,3,84.00),(176,15,2,4,84.00),(177,15,3,1,195.00),(178,15,3,2,195.00),(179,15,3,3,105.00),(180,15,3,4,105.00),(181,16,1,1,130.00),(182,16,1,2,130.00),(183,16,1,3,70.00),(184,16,1,4,70.00),(185,16,2,1,156.00),(186,16,2,2,156.00),(187,16,2,3,84.00),(188,16,2,4,84.00),(189,16,3,1,195.00),(190,16,3,2,195.00),(191,16,3,3,105.00),(192,16,3,4,105.00),(193,17,1,1,140.00),(194,17,1,2,140.00),(195,17,1,3,80.00),(196,17,1,4,80.00),(197,17,2,1,168.00),(198,17,2,2,168.00),(199,17,2,3,96.00),(200,17,2,4,96.00),(201,17,3,1,210.00),(202,17,3,2,210.00),(203,17,3,3,120.00),(204,17,3,4,120.00);
/*!40000 ALTER TABLE `prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_types`
--

DROP TABLE IF EXISTS `room_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_types` (
  `room_type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL COMMENT 'Standard, Double, or Family',
  `max_guests` int NOT NULL COMMENT '1, 2, or 4 guests maximum',
  `price_multiplier` decimal(3,2) NOT NULL COMMENT '1.0, 1.2, or 1.5',
  `has_wifi` tinyint(1) DEFAULT '1',
  `has_minibar` tinyint(1) DEFAULT '1',
  `has_tv` tinyint(1) DEFAULT '1',
  `includes_breakfast` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`room_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Room type definitions with features';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_types`
--

LOCK TABLES `room_types` WRITE;
/*!40000 ALTER TABLE `room_types` DISABLE KEYS */;
INSERT INTO `room_types` VALUES (1,'Standard',1,1.00,1,1,1,1),(2,'Double',2,1.20,1,1,1,1),(3,'Family',4,1.50,1,1,1,1);
/*!40000 ALTER TABLE `room_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `hotel_id` int NOT NULL,
  `room_type_id` int NOT NULL,
  `room_number` varchar(10) NOT NULL COMMENT 'Room number within hotel',
  `status` enum('available','booked','maintenance') DEFAULT 'available',
  PRIMARY KEY (`room_id`),
  UNIQUE KEY `unique_hotel_room` (`hotel_id`,`room_number`),
  KEY `room_type_id` (`room_type_id`),
  KEY `idx_hotel_room` (`hotel_id`,`room_type_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`hotel_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rooms_ibfk_2` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`room_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1761 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Individual rooms - 30% Standard, 50% Double, 20% Family';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,1,1,'101','available'),(2,1,1,'102','available'),(3,1,1,'103','available'),(4,1,1,'104','available'),(5,1,1,'105','available'),(6,1,1,'106','available'),(7,1,1,'107','available'),(8,1,1,'108','available'),(9,1,1,'109','available'),(10,1,1,'110','available'),(11,1,1,'111','available'),(12,1,1,'112','available'),(13,1,1,'113','available'),(14,1,1,'114','available'),(15,1,1,'115','available'),(16,1,1,'116','available'),(17,1,1,'117','available'),(18,1,1,'118','available'),(19,1,1,'119','available'),(20,1,1,'120','available'),(21,1,1,'121','available'),(22,1,1,'122','available'),(23,1,1,'123','available'),(24,1,1,'124','available'),(25,1,1,'125','available'),(26,1,1,'126','available'),(27,1,1,'127','available'),(28,1,2,'201','available'),(29,1,2,'202','available'),(30,1,2,'203','available'),(31,1,2,'204','available'),(32,1,2,'205','available'),(33,1,2,'206','available'),(34,1,2,'207','available'),(35,1,2,'208','available'),(36,1,2,'209','available'),(37,1,2,'210','available'),(38,1,2,'211','available'),(39,1,2,'212','available'),(40,1,2,'213','available'),(41,1,2,'214','available'),(42,1,2,'215','available'),(43,1,2,'216','available'),(44,1,2,'217','available'),(45,1,2,'218','available'),(46,1,2,'219','available'),(47,1,2,'220','available'),(48,1,2,'221','available'),(49,1,2,'222','available'),(50,1,2,'223','available'),(51,1,2,'224','available'),(52,1,2,'225','available'),(53,1,2,'226','available'),(54,1,2,'227','available'),(55,1,2,'228','available'),(56,1,2,'229','available'),(57,1,2,'230','available'),(58,1,2,'231','available'),(59,1,2,'232','available'),(60,1,2,'233','available'),(61,1,2,'234','available'),(62,1,2,'235','available'),(63,1,2,'236','available'),(64,1,2,'237','available'),(65,1,2,'238','available'),(66,1,2,'239','available'),(67,1,2,'240','available'),(68,1,2,'241','available'),(69,1,2,'242','available'),(70,1,2,'243','available'),(71,1,2,'244','available'),(72,1,2,'245','available'),(73,1,3,'301','available'),(74,1,3,'302','available'),(75,1,3,'303','available'),(76,1,3,'304','available'),(77,1,3,'305','available'),(78,1,3,'306','available'),(79,1,3,'307','available'),(80,1,3,'308','available'),(81,1,3,'309','available'),(82,1,3,'310','available'),(83,1,3,'311','available'),(84,1,3,'312','available'),(85,1,3,'313','available'),(86,1,3,'314','available'),(87,1,3,'315','available'),(88,1,3,'316','available'),(89,1,3,'317','available'),(90,1,3,'318','available'),(91,2,1,'101','available'),(92,2,1,'102','available'),(93,2,1,'103','available'),(94,2,1,'104','available'),(95,2,1,'105','available'),(96,2,1,'106','available'),(97,2,1,'107','available'),(98,2,1,'108','available'),(99,2,1,'109','available'),(100,2,1,'110','available'),(101,2,1,'111','available'),(102,2,1,'112','available'),(103,2,1,'113','available'),(104,2,1,'114','available'),(105,2,1,'115','available'),(106,2,1,'116','available'),(107,2,1,'117','available'),(108,2,1,'118','available'),(109,2,1,'119','available'),(110,2,1,'120','available'),(111,2,1,'121','available'),(112,2,1,'122','available'),(113,2,1,'123','available'),(114,2,1,'124','available'),(115,2,2,'201','available'),(116,2,2,'202','available'),(117,2,2,'203','available'),(118,2,2,'204','available'),(119,2,2,'205','available'),(120,2,2,'206','available'),(121,2,2,'207','available'),(122,2,2,'208','available'),(123,2,2,'209','available'),(124,2,2,'210','available'),(125,2,2,'211','available'),(126,2,2,'212','available'),(127,2,2,'213','available'),(128,2,2,'214','available'),(129,2,2,'215','available'),(130,2,2,'216','available'),(131,2,2,'217','available'),(132,2,2,'218','available'),(133,2,2,'219','available'),(134,2,2,'220','available'),(135,2,2,'221','available'),(136,2,2,'222','available'),(137,2,2,'223','available'),(138,2,2,'224','available'),(139,2,2,'225','available'),(140,2,2,'226','available'),(141,2,2,'227','available'),(142,2,2,'228','available'),(143,2,2,'229','available'),(144,2,2,'230','available'),(145,2,2,'231','available'),(146,2,2,'232','available'),(147,2,2,'233','available'),(148,2,2,'234','available'),(149,2,2,'235','available'),(150,2,2,'236','available'),(151,2,2,'237','available'),(152,2,2,'238','available'),(153,2,2,'239','available'),(154,2,2,'240','available'),(155,2,3,'301','available'),(156,2,3,'302','available'),(157,2,3,'303','available'),(158,2,3,'304','available'),(159,2,3,'305','available'),(160,2,3,'306','available'),(161,2,3,'307','available'),(162,2,3,'308','available'),(163,2,3,'309','available'),(164,2,3,'310','available'),(165,2,3,'311','available'),(166,2,3,'312','available'),(167,2,3,'313','available'),(168,2,3,'314','available'),(169,2,3,'315','available'),(170,2,3,'316','available'),(171,3,1,'101','available'),(172,3,1,'102','available'),(173,3,1,'103','available'),(174,3,1,'104','available'),(175,3,1,'105','available'),(176,3,1,'106','available'),(177,3,1,'107','available'),(178,3,1,'108','available'),(179,3,1,'109','available'),(180,3,1,'110','available'),(181,3,1,'111','available'),(182,3,1,'112','available'),(183,3,1,'113','available'),(184,3,1,'114','available'),(185,3,1,'115','available'),(186,3,1,'116','available'),(187,3,1,'117','available'),(188,3,1,'118','available'),(189,3,1,'119','available'),(190,3,1,'120','available'),(191,3,1,'121','available'),(192,3,1,'122','available'),(193,3,1,'123','available'),(194,3,1,'124','available'),(195,3,1,'125','available'),(196,3,1,'126','available'),(197,3,1,'127','available'),(198,3,1,'128','available'),(199,3,1,'129','available'),(200,3,1,'130','available'),(201,3,1,'131','available'),(202,3,1,'132','available'),(203,3,1,'133','available'),(204,3,2,'201','available'),(205,3,2,'202','available'),(206,3,2,'203','available'),(207,3,2,'204','available'),(208,3,2,'205','available'),(209,3,2,'206','available'),(210,3,2,'207','available'),(211,3,2,'208','available'),(212,3,2,'209','available'),(213,3,2,'210','available'),(214,3,2,'211','available'),(215,3,2,'212','available'),(216,3,2,'213','available'),(217,3,2,'214','available'),(218,3,2,'215','available'),(219,3,2,'216','available'),(220,3,2,'217','available'),(221,3,2,'218','available'),(222,3,2,'219','available'),(223,3,2,'220','available'),(224,3,2,'221','available'),(225,3,2,'222','available'),(226,3,2,'223','available'),(227,3,2,'224','available'),(228,3,2,'225','available'),(229,3,2,'226','available'),(230,3,2,'227','available'),(231,3,2,'228','available'),(232,3,2,'229','available'),(233,3,2,'230','available'),(234,3,2,'231','available'),(235,3,2,'232','available'),(236,3,2,'233','available'),(237,3,2,'234','available'),(238,3,2,'235','available'),(239,3,2,'236','available'),(240,3,2,'237','available'),(241,3,2,'238','available'),(242,3,2,'239','available'),(243,3,2,'240','available'),(244,3,2,'241','available'),(245,3,2,'242','available'),(246,3,2,'243','available'),(247,3,2,'244','available'),(248,3,2,'245','available'),(249,3,2,'246','available'),(250,3,2,'247','available'),(251,3,2,'248','available'),(252,3,2,'249','available'),(253,3,2,'250','available'),(254,3,2,'251','available'),(255,3,2,'252','available'),(256,3,2,'253','available'),(257,3,2,'254','available'),(258,3,2,'255','available'),(259,3,3,'301','available'),(260,3,3,'302','available'),(261,3,3,'303','available'),(262,3,3,'304','available'),(263,3,3,'305','available'),(264,3,3,'306','available'),(265,3,3,'307','available'),(266,3,3,'308','available'),(267,3,3,'309','available'),(268,3,3,'310','available'),(269,3,3,'311','available'),(270,3,3,'312','available'),(271,3,3,'313','available'),(272,3,3,'314','available'),(273,3,3,'315','available'),(274,3,3,'316','available'),(275,3,3,'317','available'),(276,3,3,'318','available'),(277,3,3,'319','available'),(278,3,3,'320','available'),(279,3,3,'321','available'),(280,3,3,'322','available'),(281,4,1,'101','available'),(282,4,1,'102','available'),(283,4,1,'103','available'),(284,4,1,'104','available'),(285,4,1,'105','available'),(286,4,1,'106','available'),(287,4,1,'107','available'),(288,4,1,'108','available'),(289,4,1,'109','available'),(290,4,1,'110','available'),(291,4,1,'111','available'),(292,4,1,'112','available'),(293,4,1,'113','available'),(294,4,1,'114','available'),(295,4,1,'115','available'),(296,4,1,'116','available'),(297,4,1,'117','available'),(298,4,1,'118','available'),(299,4,1,'119','available'),(300,4,1,'120','available'),(301,4,1,'121','available'),(302,4,1,'122','available'),(303,4,1,'123','available'),(304,4,1,'124','available'),(305,4,1,'125','available'),(306,4,1,'126','available'),(307,4,1,'127','available'),(308,4,1,'128','available'),(309,4,1,'129','available'),(310,4,1,'130','available'),(311,4,2,'201','available'),(312,4,2,'202','available'),(313,4,2,'203','available'),(314,4,2,'204','available'),(315,4,2,'205','available'),(316,4,2,'206','available'),(317,4,2,'207','available'),(318,4,2,'208','available'),(319,4,2,'209','available'),(320,4,2,'210','available'),(321,4,2,'211','available'),(322,4,2,'212','available'),(323,4,2,'213','available'),(324,4,2,'214','available'),(325,4,2,'215','available'),(326,4,2,'216','available'),(327,4,2,'217','available'),(328,4,2,'218','available'),(329,4,2,'219','available'),(330,4,2,'220','available'),(331,4,2,'221','available'),(332,4,2,'222','available'),(333,4,2,'223','available'),(334,4,2,'224','available'),(335,4,2,'225','available'),(336,4,2,'226','available'),(337,4,2,'227','available'),(338,4,2,'228','available'),(339,4,2,'229','available'),(340,4,2,'230','available'),(341,4,2,'231','available'),(342,4,2,'232','available'),(343,4,2,'233','available'),(344,4,2,'234','available'),(345,4,2,'235','available'),(346,4,2,'236','available'),(347,4,2,'237','available'),(348,4,2,'238','available'),(349,4,2,'239','available'),(350,4,2,'240','available'),(351,4,2,'241','available'),(352,4,2,'242','available'),(353,4,2,'243','available'),(354,4,2,'244','available'),(355,4,2,'245','available'),(356,4,2,'246','available'),(357,4,2,'247','available'),(358,4,2,'248','available'),(359,4,2,'249','available'),(360,4,2,'250','available'),(361,4,3,'301','available'),(362,4,3,'302','available'),(363,4,3,'303','available'),(364,4,3,'304','available'),(365,4,3,'305','available'),(366,4,3,'306','available'),(367,4,3,'307','available'),(368,4,3,'308','available'),(369,4,3,'309','available'),(370,4,3,'310','available'),(371,4,3,'311','available'),(372,4,3,'312','available'),(373,4,3,'313','available'),(374,4,3,'314','available'),(375,4,3,'315','available'),(376,4,3,'316','available'),(377,4,3,'317','available'),(378,4,3,'318','available'),(379,4,3,'319','available'),(380,4,3,'320','available'),(381,5,1,'101','available'),(382,5,1,'102','available'),(383,5,1,'103','available'),(384,5,1,'104','available'),(385,5,1,'105','available'),(386,5,1,'106','available'),(387,5,1,'107','available'),(388,5,1,'108','available'),(389,5,1,'109','available'),(390,5,1,'110','available'),(391,5,1,'111','available'),(392,5,1,'112','available'),(393,5,1,'113','available'),(394,5,1,'114','available'),(395,5,1,'115','available'),(396,5,1,'116','available'),(397,5,1,'117','available'),(398,5,1,'118','available'),(399,5,1,'119','available'),(400,5,1,'120','available'),(401,5,1,'121','available'),(402,5,1,'122','available'),(403,5,1,'123','available'),(404,5,1,'124','available'),(405,5,1,'125','available'),(406,5,1,'126','available'),(407,5,1,'127','available'),(408,5,2,'201','available'),(409,5,2,'202','available'),(410,5,2,'203','available'),(411,5,2,'204','available'),(412,5,2,'205','available'),(413,5,2,'206','available'),(414,5,2,'207','available'),(415,5,2,'208','available'),(416,5,2,'209','available'),(417,5,2,'210','available'),(418,5,2,'211','available'),(419,5,2,'212','available'),(420,5,2,'213','available'),(421,5,2,'214','available'),(422,5,2,'215','available'),(423,5,2,'216','available'),(424,5,2,'217','available'),(425,5,2,'218','available'),(426,5,2,'219','available'),(427,5,2,'220','available'),(428,5,2,'221','available'),(429,5,2,'222','available'),(430,5,2,'223','available'),(431,5,2,'224','available'),(432,5,2,'225','available'),(433,5,2,'226','available'),(434,5,2,'227','available'),(435,5,2,'228','available'),(436,5,2,'229','available'),(437,5,2,'230','available'),(438,5,2,'231','available'),(439,5,2,'232','available'),(440,5,2,'233','available'),(441,5,2,'234','available'),(442,5,2,'235','available'),(443,5,2,'236','available'),(444,5,2,'237','available'),(445,5,2,'238','available'),(446,5,2,'239','available'),(447,5,2,'240','available'),(448,5,2,'241','available'),(449,5,2,'242','available'),(450,5,2,'243','available'),(451,5,2,'244','available'),(452,5,2,'245','available'),(453,5,3,'301','available'),(454,5,3,'302','available'),(455,5,3,'303','available'),(456,5,3,'304','available'),(457,5,3,'305','available'),(458,5,3,'306','available'),(459,5,3,'307','available'),(460,5,3,'308','available'),(461,5,3,'309','available'),(462,5,3,'310','available'),(463,5,3,'311','available'),(464,5,3,'312','available'),(465,5,3,'313','available'),(466,5,3,'314','available'),(467,5,3,'315','available'),(468,5,3,'316','available'),(469,5,3,'317','available'),(470,5,3,'318','available'),(471,6,1,'101','available'),(472,6,1,'102','available'),(473,6,1,'103','available'),(474,6,1,'104','available'),(475,6,1,'105','available'),(476,6,1,'106','available'),(477,6,1,'107','available'),(478,6,1,'108','available'),(479,6,1,'109','available'),(480,6,1,'110','available'),(481,6,1,'111','available'),(482,6,1,'112','available'),(483,6,1,'113','available'),(484,6,1,'114','available'),(485,6,1,'115','available'),(486,6,1,'116','available'),(487,6,1,'117','available'),(488,6,1,'118','available'),(489,6,1,'119','available'),(490,6,1,'120','available'),(491,6,1,'121','available'),(492,6,1,'122','available'),(493,6,1,'123','available'),(494,6,1,'124','available'),(495,6,1,'125','available'),(496,6,1,'126','available'),(497,6,1,'127','available'),(498,6,1,'128','available'),(499,6,1,'129','available'),(500,6,1,'130','available'),(501,6,1,'131','available'),(502,6,1,'132','available'),(503,6,1,'133','available'),(504,6,1,'134','available'),(505,6,1,'135','available'),(506,6,1,'136','available'),(507,6,2,'201','available'),(508,6,2,'202','available'),(509,6,2,'203','available'),(510,6,2,'204','available'),(511,6,2,'205','available'),(512,6,2,'206','available'),(513,6,2,'207','available'),(514,6,2,'208','available'),(515,6,2,'209','available'),(516,6,2,'210','available'),(517,6,2,'211','available'),(518,6,2,'212','available'),(519,6,2,'213','available'),(520,6,2,'214','available'),(521,6,2,'215','available'),(522,6,2,'216','available'),(523,6,2,'217','available'),(524,6,2,'218','available'),(525,6,2,'219','available'),(526,6,2,'220','available'),(527,6,2,'221','available'),(528,6,2,'222','available'),(529,6,2,'223','available'),(530,6,2,'224','available'),(531,6,2,'225','available'),(532,6,2,'226','available'),(533,6,2,'227','available'),(534,6,2,'228','available'),(535,6,2,'229','available'),(536,6,2,'230','available'),(537,6,2,'231','available'),(538,6,2,'232','available'),(539,6,2,'233','available'),(540,6,2,'234','available'),(541,6,2,'235','available'),(542,6,2,'236','available'),(543,6,2,'237','available'),(544,6,2,'238','available'),(545,6,2,'239','available'),(546,6,2,'240','available'),(547,6,2,'241','available'),(548,6,2,'242','available'),(549,6,2,'243','available'),(550,6,2,'244','available'),(551,6,2,'245','available'),(552,6,2,'246','available'),(553,6,2,'247','available'),(554,6,2,'248','available'),(555,6,2,'249','available'),(556,6,2,'250','available'),(557,6,2,'251','available'),(558,6,2,'252','available'),(559,6,2,'253','available'),(560,6,2,'254','available'),(561,6,2,'255','available'),(562,6,2,'256','available'),(563,6,2,'257','available'),(564,6,2,'258','available'),(565,6,2,'259','available'),(566,6,2,'260','available'),(567,6,3,'301','available'),(568,6,3,'302','available'),(569,6,3,'303','available'),(570,6,3,'304','available'),(571,6,3,'305','available'),(572,6,3,'306','available'),(573,6,3,'307','available'),(574,6,3,'308','available'),(575,6,3,'309','available'),(576,6,3,'310','available'),(577,6,3,'311','available'),(578,6,3,'312','available'),(579,6,3,'313','available'),(580,6,3,'314','available'),(581,6,3,'315','available'),(582,6,3,'316','available'),(583,6,3,'317','available'),(584,6,3,'318','available'),(585,6,3,'319','available'),(586,6,3,'320','available'),(587,6,3,'321','available'),(588,6,3,'322','available'),(589,6,3,'323','available'),(590,6,3,'324','available'),(591,7,1,'101','available'),(592,7,1,'102','available'),(593,7,1,'103','available'),(594,7,1,'104','available'),(595,7,1,'105','available'),(596,7,1,'106','available'),(597,7,1,'107','available'),(598,7,1,'108','available'),(599,7,1,'109','available'),(600,7,1,'110','available'),(601,7,1,'111','available'),(602,7,1,'112','available'),(603,7,1,'113','available'),(604,7,1,'114','available'),(605,7,1,'115','available'),(606,7,1,'116','available'),(607,7,1,'117','available'),(608,7,1,'118','available'),(609,7,1,'119','available'),(610,7,1,'120','available'),(611,7,1,'121','available'),(612,7,1,'122','available'),(613,7,1,'123','available'),(614,7,1,'124','available'),(615,7,1,'125','available'),(616,7,1,'126','available'),(617,7,1,'127','available'),(618,7,1,'128','available'),(619,7,1,'129','available'),(620,7,1,'130','available'),(621,7,1,'131','available'),(622,7,1,'132','available'),(623,7,1,'133','available'),(624,7,1,'134','available'),(625,7,1,'135','available'),(626,7,1,'136','available'),(627,7,1,'137','available'),(628,7,1,'138','available'),(629,7,1,'139','available'),(630,7,1,'140','available'),(631,7,1,'141','available'),(632,7,1,'142','available'),(633,7,2,'201','available'),(634,7,2,'202','available'),(635,7,2,'203','available'),(636,7,2,'204','available'),(637,7,2,'205','available'),(638,7,2,'206','available'),(639,7,2,'207','available'),(640,7,2,'208','available'),(641,7,2,'209','available'),(642,7,2,'210','available'),(643,7,2,'211','available'),(644,7,2,'212','available'),(645,7,2,'213','available'),(646,7,2,'214','available'),(647,7,2,'215','available'),(648,7,2,'216','available'),(649,7,2,'217','available'),(650,7,2,'218','available'),(651,7,2,'219','available'),(652,7,2,'220','available'),(653,7,2,'221','available'),(654,7,2,'222','available'),(655,7,2,'223','available'),(656,7,2,'224','available'),(657,7,2,'225','available'),(658,7,2,'226','available'),(659,7,2,'227','available'),(660,7,2,'228','available'),(661,7,2,'229','available'),(662,7,2,'230','available'),(663,7,2,'231','available'),(664,7,2,'232','available'),(665,7,2,'233','available'),(666,7,2,'234','available'),(667,7,2,'235','available'),(668,7,2,'236','available'),(669,7,2,'237','available'),(670,7,2,'238','available'),(671,7,2,'239','available'),(672,7,2,'240','available'),(673,7,2,'241','available'),(674,7,2,'242','available'),(675,7,2,'243','available'),(676,7,2,'244','available'),(677,7,2,'245','available'),(678,7,2,'246','available'),(679,7,2,'247','available'),(680,7,2,'248','available'),(681,7,2,'249','available'),(682,7,2,'250','available'),(683,7,2,'251','available'),(684,7,2,'252','available'),(685,7,2,'253','available'),(686,7,2,'254','available'),(687,7,2,'255','available'),(688,7,2,'256','available'),(689,7,2,'257','available'),(690,7,2,'258','available'),(691,7,2,'259','available'),(692,7,2,'260','available'),(693,7,2,'261','available'),(694,7,2,'262','available'),(695,7,2,'263','available'),(696,7,2,'264','available'),(697,7,2,'265','available'),(698,7,2,'266','available'),(699,7,2,'267','available'),(700,7,2,'268','available'),(701,7,2,'269','available'),(702,7,2,'270','available'),(703,7,3,'301','available'),(704,7,3,'302','available'),(705,7,3,'303','available'),(706,7,3,'304','available'),(707,7,3,'305','available'),(708,7,3,'306','available'),(709,7,3,'307','available'),(710,7,3,'308','available'),(711,7,3,'309','available'),(712,7,3,'310','available'),(713,7,3,'311','available'),(714,7,3,'312','available'),(715,7,3,'313','available'),(716,7,3,'314','available'),(717,7,3,'315','available'),(718,7,3,'316','available'),(719,7,3,'317','available'),(720,7,3,'318','available'),(721,7,3,'319','available'),(722,7,3,'320','available'),(723,7,3,'321','available'),(724,7,3,'322','available'),(725,7,3,'323','available'),(726,7,3,'324','available'),(727,7,3,'325','available'),(728,7,3,'326','available'),(729,7,3,'327','available'),(730,7,3,'328','available'),(731,8,1,'101','available'),(732,8,1,'102','available'),(733,8,1,'103','available'),(734,8,1,'104','available'),(735,8,1,'105','available'),(736,8,1,'106','available'),(737,8,1,'107','available'),(738,8,1,'108','available'),(739,8,1,'109','available'),(740,8,1,'110','available'),(741,8,1,'111','available'),(742,8,1,'112','available'),(743,8,1,'113','available'),(744,8,1,'114','available'),(745,8,1,'115','available'),(746,8,1,'116','available'),(747,8,1,'117','available'),(748,8,1,'118','available'),(749,8,1,'119','available'),(750,8,1,'120','available'),(751,8,1,'121','available'),(752,8,1,'122','available'),(753,8,1,'123','available'),(754,8,1,'124','available'),(755,8,1,'125','available'),(756,8,1,'126','available'),(757,8,1,'127','available'),(758,8,1,'128','available'),(759,8,1,'129','available'),(760,8,1,'130','available'),(761,8,1,'131','available'),(762,8,1,'132','available'),(763,8,1,'133','available'),(764,8,1,'134','available'),(765,8,1,'135','available'),(766,8,1,'136','available'),(767,8,1,'137','available'),(768,8,1,'138','available'),(769,8,1,'139','available'),(770,8,1,'140','available'),(771,8,1,'141','available'),(772,8,1,'142','available'),(773,8,1,'143','available'),(774,8,1,'144','available'),(775,8,1,'145','available'),(776,8,1,'146','available'),(777,8,1,'147','available'),(778,8,1,'148','available'),(779,8,2,'201','available'),(780,8,2,'202','available'),(781,8,2,'203','available'),(782,8,2,'204','available'),(783,8,2,'205','available'),(784,8,2,'206','available'),(785,8,2,'207','available'),(786,8,2,'208','available'),(787,8,2,'209','available'),(788,8,2,'210','available'),(789,8,2,'211','available'),(790,8,2,'212','available'),(791,8,2,'213','available'),(792,8,2,'214','available'),(793,8,2,'215','available'),(794,8,2,'216','available'),(795,8,2,'217','available'),(796,8,2,'218','available'),(797,8,2,'219','available'),(798,8,2,'220','available'),(799,8,2,'221','available'),(800,8,2,'222','available'),(801,8,2,'223','available'),(802,8,2,'224','available'),(803,8,2,'225','available'),(804,8,2,'226','available'),(805,8,2,'227','available'),(806,8,2,'228','available'),(807,8,2,'229','available'),(808,8,2,'230','available'),(809,8,2,'231','available'),(810,8,2,'232','available'),(811,8,2,'233','available'),(812,8,2,'234','available'),(813,8,2,'235','available'),(814,8,2,'236','available'),(815,8,2,'237','available'),(816,8,2,'238','available'),(817,8,2,'239','available'),(818,8,2,'240','available'),(819,8,2,'241','available'),(820,8,2,'242','available'),(821,8,2,'243','available'),(822,8,2,'244','available'),(823,8,2,'245','available'),(824,8,2,'246','available'),(825,8,2,'247','available'),(826,8,2,'248','available'),(827,8,2,'249','available'),(828,8,2,'250','available'),(829,8,2,'251','available'),(830,8,2,'252','available'),(831,8,2,'253','available'),(832,8,2,'254','available'),(833,8,2,'255','available'),(834,8,2,'256','available'),(835,8,2,'257','available'),(836,8,2,'258','available'),(837,8,2,'259','available'),(838,8,2,'260','available'),(839,8,2,'261','available'),(840,8,2,'262','available'),(841,8,2,'263','available'),(842,8,2,'264','available'),(843,8,2,'265','available'),(844,8,2,'266','available'),(845,8,2,'267','available'),(846,8,2,'268','available'),(847,8,2,'269','available'),(848,8,2,'270','available'),(849,8,2,'271','available'),(850,8,2,'272','available'),(851,8,2,'273','available'),(852,8,2,'274','available'),(853,8,2,'275','available'),(854,8,2,'276','available'),(855,8,2,'277','available'),(856,8,2,'278','available'),(857,8,2,'279','available'),(858,8,2,'280','available'),(859,8,3,'301','available'),(860,8,3,'302','available'),(861,8,3,'303','available'),(862,8,3,'304','available'),(863,8,3,'305','available'),(864,8,3,'306','available'),(865,8,3,'307','available'),(866,8,3,'308','available'),(867,8,3,'309','available'),(868,8,3,'310','available'),(869,8,3,'311','available'),(870,8,3,'312','available'),(871,8,3,'313','available'),(872,8,3,'314','available'),(873,8,3,'315','available'),(874,8,3,'316','available'),(875,8,3,'317','available'),(876,8,3,'318','available'),(877,8,3,'319','available'),(878,8,3,'320','available'),(879,8,3,'321','available'),(880,8,3,'322','available'),(881,8,3,'323','available'),(882,8,3,'324','available'),(883,8,3,'325','available'),(884,8,3,'326','available'),(885,8,3,'327','available'),(886,8,3,'328','available'),(887,8,3,'329','available'),(888,8,3,'330','available'),(889,8,3,'331','available'),(890,8,3,'332','available'),(891,9,1,'101','available'),(892,9,1,'102','available'),(893,9,1,'103','available'),(894,9,1,'104','available'),(895,9,1,'105','available'),(896,9,1,'106','available'),(897,9,1,'107','available'),(898,9,1,'108','available'),(899,9,1,'109','available'),(900,9,1,'110','available'),(901,9,1,'111','available'),(902,9,1,'112','available'),(903,9,1,'113','available'),(904,9,1,'114','available'),(905,9,1,'115','available'),(906,9,1,'116','available'),(907,9,1,'117','available'),(908,9,1,'118','available'),(909,9,1,'119','available'),(910,9,1,'120','available'),(911,9,1,'121','available'),(912,9,1,'122','available'),(913,9,1,'123','available'),(914,9,1,'124','available'),(915,9,1,'125','available'),(916,9,1,'126','available'),(917,9,1,'127','available'),(918,9,1,'128','available'),(919,9,1,'129','available'),(920,9,1,'130','available'),(921,9,1,'131','available'),(922,9,1,'132','available'),(923,9,1,'133','available'),(924,9,1,'134','available'),(925,9,1,'135','available'),(926,9,1,'136','available'),(927,9,1,'137','available'),(928,9,1,'138','available'),(929,9,1,'139','available'),(930,9,1,'140','available'),(931,9,1,'141','available'),(932,9,1,'142','available'),(933,9,1,'143','available'),(934,9,1,'144','available'),(935,9,1,'145','available'),(936,9,2,'201','available'),(937,9,2,'202','available'),(938,9,2,'203','available'),(939,9,2,'204','available'),(940,9,2,'205','available'),(941,9,2,'206','available'),(942,9,2,'207','available'),(943,9,2,'208','available'),(944,9,2,'209','available'),(945,9,2,'210','available'),(946,9,2,'211','available'),(947,9,2,'212','available'),(948,9,2,'213','available'),(949,9,2,'214','available'),(950,9,2,'215','available'),(951,9,2,'216','available'),(952,9,2,'217','available'),(953,9,2,'218','available'),(954,9,2,'219','available'),(955,9,2,'220','available'),(956,9,2,'221','available'),(957,9,2,'222','available'),(958,9,2,'223','available'),(959,9,2,'224','available'),(960,9,2,'225','available'),(961,9,2,'226','available'),(962,9,2,'227','available'),(963,9,2,'228','available'),(964,9,2,'229','available'),(965,9,2,'230','available'),(966,9,2,'231','available'),(967,9,2,'232','available'),(968,9,2,'233','available'),(969,9,2,'234','available'),(970,9,2,'235','available'),(971,9,2,'236','available'),(972,9,2,'237','available'),(973,9,2,'238','available'),(974,9,2,'239','available'),(975,9,2,'240','available'),(976,9,2,'241','available'),(977,9,2,'242','available'),(978,9,2,'243','available'),(979,9,2,'244','available'),(980,9,2,'245','available'),(981,9,2,'246','available'),(982,9,2,'247','available'),(983,9,2,'248','available'),(984,9,2,'249','available'),(985,9,2,'250','available'),(986,9,2,'251','available'),(987,9,2,'252','available'),(988,9,2,'253','available'),(989,9,2,'254','available'),(990,9,2,'255','available'),(991,9,2,'256','available'),(992,9,2,'257','available'),(993,9,2,'258','available'),(994,9,2,'259','available'),(995,9,2,'260','available'),(996,9,2,'261','available'),(997,9,2,'262','available'),(998,9,2,'263','available'),(999,9,2,'264','available'),(1000,9,2,'265','available'),(1001,9,2,'266','available'),(1002,9,2,'267','available'),(1003,9,2,'268','available'),(1004,9,2,'269','available'),(1005,9,2,'270','available'),(1006,9,2,'271','available'),(1007,9,2,'272','available'),(1008,9,2,'273','available'),(1009,9,2,'274','available'),(1010,9,2,'275','available'),(1011,9,3,'301','available'),(1012,9,3,'302','available'),(1013,9,3,'303','available'),(1014,9,3,'304','available'),(1015,9,3,'305','available'),(1016,9,3,'306','available'),(1017,9,3,'307','available'),(1018,9,3,'308','available'),(1019,9,3,'309','available'),(1020,9,3,'310','available'),(1021,9,3,'311','available'),(1022,9,3,'312','available'),(1023,9,3,'313','available'),(1024,9,3,'314','available'),(1025,9,3,'315','available'),(1026,9,3,'316','available'),(1027,9,3,'317','available'),(1028,9,3,'318','available'),(1029,9,3,'319','available'),(1030,9,3,'320','available'),(1031,9,3,'321','available'),(1032,9,3,'322','available'),(1033,9,3,'323','available'),(1034,9,3,'324','available'),(1035,9,3,'325','available'),(1036,9,3,'326','available'),(1037,9,3,'327','available'),(1038,9,3,'328','available'),(1039,9,3,'329','available'),(1040,9,3,'330','available'),(1041,10,1,'101','available'),(1042,10,1,'102','available'),(1043,10,1,'103','available'),(1044,10,1,'104','available'),(1045,10,1,'105','available'),(1046,10,1,'106','available'),(1047,10,1,'107','available'),(1048,10,1,'108','available'),(1049,10,1,'109','available'),(1050,10,1,'110','available'),(1051,10,1,'111','available'),(1052,10,1,'112','available'),(1053,10,1,'113','available'),(1054,10,1,'114','available'),(1055,10,1,'115','available'),(1056,10,1,'116','available'),(1057,10,1,'117','available'),(1058,10,1,'118','available'),(1059,10,1,'119','available'),(1060,10,1,'120','available'),(1061,10,1,'121','available'),(1062,10,1,'122','available'),(1063,10,1,'123','available'),(1064,10,1,'124','available'),(1065,10,1,'125','available'),(1066,10,1,'126','available'),(1067,10,1,'127','available'),(1068,10,2,'201','available'),(1069,10,2,'202','available'),(1070,10,2,'203','available'),(1071,10,2,'204','available'),(1072,10,2,'205','available'),(1073,10,2,'206','available'),(1074,10,2,'207','available'),(1075,10,2,'208','available'),(1076,10,2,'209','available'),(1077,10,2,'210','available'),(1078,10,2,'211','available'),(1079,10,2,'212','available'),(1080,10,2,'213','available'),(1081,10,2,'214','available'),(1082,10,2,'215','available'),(1083,10,2,'216','available'),(1084,10,2,'217','available'),(1085,10,2,'218','available'),(1086,10,2,'219','available'),(1087,10,2,'220','available'),(1088,10,2,'221','available'),(1089,10,2,'222','available'),(1090,10,2,'223','available'),(1091,10,2,'224','available'),(1092,10,2,'225','available'),(1093,10,2,'226','available'),(1094,10,2,'227','available'),(1095,10,2,'228','available'),(1096,10,2,'229','available'),(1097,10,2,'230','available'),(1098,10,2,'231','available'),(1099,10,2,'232','available'),(1100,10,2,'233','available'),(1101,10,2,'234','available'),(1102,10,2,'235','available'),(1103,10,2,'236','available'),(1104,10,2,'237','available'),(1105,10,2,'238','available'),(1106,10,2,'239','available'),(1107,10,2,'240','available'),(1108,10,2,'241','available'),(1109,10,2,'242','available'),(1110,10,2,'243','available'),(1111,10,2,'244','available'),(1112,10,2,'245','available'),(1113,10,3,'301','available'),(1114,10,3,'302','available'),(1115,10,3,'303','available'),(1116,10,3,'304','available'),(1117,10,3,'305','available'),(1118,10,3,'306','available'),(1119,10,3,'307','available'),(1120,10,3,'308','available'),(1121,10,3,'309','available'),(1122,10,3,'310','available'),(1123,10,3,'311','available'),(1124,10,3,'312','available'),(1125,10,3,'313','available'),(1126,10,3,'314','available'),(1127,10,3,'315','available'),(1128,10,3,'316','available'),(1129,10,3,'317','available'),(1130,10,3,'318','available'),(1131,11,1,'101','available'),(1132,11,1,'102','available'),(1133,11,1,'103','available'),(1134,11,1,'104','available'),(1135,11,1,'105','available'),(1136,11,1,'106','available'),(1137,11,1,'107','available'),(1138,11,1,'108','available'),(1139,11,1,'109','available'),(1140,11,1,'110','available'),(1141,11,1,'111','available'),(1142,11,1,'112','available'),(1143,11,1,'113','available'),(1144,11,1,'114','available'),(1145,11,1,'115','available'),(1146,11,1,'116','available'),(1147,11,1,'117','available'),(1148,11,1,'118','available'),(1149,11,1,'119','available'),(1150,11,1,'120','available'),(1151,11,1,'121','available'),(1152,11,1,'122','available'),(1153,11,1,'123','available'),(1154,11,1,'124','available'),(1155,11,1,'125','available'),(1156,11,1,'126','available'),(1157,11,1,'127','available'),(1158,11,2,'201','available'),(1159,11,2,'202','available'),(1160,11,2,'203','available'),(1161,11,2,'204','available'),(1162,11,2,'205','available'),(1163,11,2,'206','available'),(1164,11,2,'207','available'),(1165,11,2,'208','available'),(1166,11,2,'209','available'),(1167,11,2,'210','available'),(1168,11,2,'211','available'),(1169,11,2,'212','available'),(1170,11,2,'213','available'),(1171,11,2,'214','available'),(1172,11,2,'215','available'),(1173,11,2,'216','available'),(1174,11,2,'217','available'),(1175,11,2,'218','available'),(1176,11,2,'219','available'),(1177,11,2,'220','available'),(1178,11,2,'221','available'),(1179,11,2,'222','available'),(1180,11,2,'223','available'),(1181,11,2,'224','available'),(1182,11,2,'225','available'),(1183,11,2,'226','available'),(1184,11,2,'227','available'),(1185,11,2,'228','available'),(1186,11,2,'229','available'),(1187,11,2,'230','available'),(1188,11,2,'231','available'),(1189,11,2,'232','available'),(1190,11,2,'233','available'),(1191,11,2,'234','available'),(1192,11,2,'235','available'),(1193,11,2,'236','available'),(1194,11,2,'237','available'),(1195,11,2,'238','available'),(1196,11,2,'239','available'),(1197,11,2,'240','available'),(1198,11,2,'241','available'),(1199,11,2,'242','available'),(1200,11,2,'243','available'),(1201,11,2,'244','available'),(1202,11,2,'245','available'),(1203,11,3,'301','available'),(1204,11,3,'302','available'),(1205,11,3,'303','available'),(1206,11,3,'304','available'),(1207,11,3,'305','available'),(1208,11,3,'306','available'),(1209,11,3,'307','available'),(1210,11,3,'308','available'),(1211,11,3,'309','available'),(1212,11,3,'310','available'),(1213,11,3,'311','available'),(1214,11,3,'312','available'),(1215,11,3,'313','available'),(1216,11,3,'314','available'),(1217,11,3,'315','available'),(1218,11,3,'316','available'),(1219,11,3,'317','available'),(1220,11,3,'318','available'),(1221,12,1,'101','available'),(1222,12,1,'102','available'),(1223,12,1,'103','available'),(1224,12,1,'104','available'),(1225,12,1,'105','available'),(1226,12,1,'106','available'),(1227,12,1,'107','available'),(1228,12,1,'108','available'),(1229,12,1,'109','available'),(1230,12,1,'110','available'),(1231,12,1,'111','available'),(1232,12,1,'112','available'),(1233,12,1,'113','available'),(1234,12,1,'114','available'),(1235,12,1,'115','available'),(1236,12,1,'116','available'),(1237,12,1,'117','available'),(1238,12,1,'118','available'),(1239,12,1,'119','available'),(1240,12,1,'120','available'),(1241,12,1,'121','available'),(1242,12,1,'122','available'),(1243,12,1,'123','available'),(1244,12,1,'124','available'),(1245,12,1,'125','available'),(1246,12,1,'126','available'),(1247,12,1,'127','available'),(1248,12,1,'128','available'),(1249,12,1,'129','available'),(1250,12,1,'130','available'),(1251,12,1,'131','available'),(1252,12,1,'132','available'),(1253,12,1,'133','available'),(1254,12,2,'201','available'),(1255,12,2,'202','available'),(1256,12,2,'203','available'),(1257,12,2,'204','available'),(1258,12,2,'205','available'),(1259,12,2,'206','available'),(1260,12,2,'207','available'),(1261,12,2,'208','available'),(1262,12,2,'209','available'),(1263,12,2,'210','available'),(1264,12,2,'211','available'),(1265,12,2,'212','available'),(1266,12,2,'213','available'),(1267,12,2,'214','available'),(1268,12,2,'215','available'),(1269,12,2,'216','available'),(1270,12,2,'217','available'),(1271,12,2,'218','available'),(1272,12,2,'219','available'),(1273,12,2,'220','available'),(1274,12,2,'221','available'),(1275,12,2,'222','available'),(1276,12,2,'223','available'),(1277,12,2,'224','available'),(1278,12,2,'225','available'),(1279,12,2,'226','available'),(1280,12,2,'227','available'),(1281,12,2,'228','available'),(1282,12,2,'229','available'),(1283,12,2,'230','available'),(1284,12,2,'231','available'),(1285,12,2,'232','available'),(1286,12,2,'233','available'),(1287,12,2,'234','available'),(1288,12,2,'235','available'),(1289,12,2,'236','available'),(1290,12,2,'237','available'),(1291,12,2,'238','available'),(1292,12,2,'239','available'),(1293,12,2,'240','available'),(1294,12,2,'241','available'),(1295,12,2,'242','available'),(1296,12,2,'243','available'),(1297,12,2,'244','available'),(1298,12,2,'245','available'),(1299,12,2,'246','available'),(1300,12,2,'247','available'),(1301,12,2,'248','available'),(1302,12,2,'249','available'),(1303,12,2,'250','available'),(1304,12,2,'251','available'),(1305,12,2,'252','available'),(1306,12,2,'253','available'),(1307,12,2,'254','available'),(1308,12,2,'255','available'),(1309,12,3,'301','available'),(1310,12,3,'302','available'),(1311,12,3,'303','available'),(1312,12,3,'304','available'),(1313,12,3,'305','available'),(1314,12,3,'306','available'),(1315,12,3,'307','available'),(1316,12,3,'308','available'),(1317,12,3,'309','available'),(1318,12,3,'310','available'),(1319,12,3,'311','available'),(1320,12,3,'312','available'),(1321,12,3,'313','available'),(1322,12,3,'314','available'),(1323,12,3,'315','available'),(1324,12,3,'316','available'),(1325,12,3,'317','available'),(1326,12,3,'318','available'),(1327,12,3,'319','available'),(1328,12,3,'320','available'),(1329,12,3,'321','available'),(1330,12,3,'322','available'),(1331,13,1,'101','available'),(1332,13,1,'102','available'),(1333,13,1,'103','available'),(1334,13,1,'104','available'),(1335,13,1,'105','available'),(1336,13,1,'106','available'),(1337,13,1,'107','available'),(1338,13,1,'108','available'),(1339,13,1,'109','available'),(1340,13,1,'110','available'),(1341,13,1,'111','available'),(1342,13,1,'112','available'),(1343,13,1,'113','available'),(1344,13,1,'114','available'),(1345,13,1,'115','available'),(1346,13,1,'116','available'),(1347,13,1,'117','available'),(1348,13,1,'118','available'),(1349,13,1,'119','available'),(1350,13,1,'120','available'),(1351,13,1,'121','available'),(1352,13,1,'122','available'),(1353,13,1,'123','available'),(1354,13,1,'124','available'),(1355,13,1,'125','available'),(1356,13,1,'126','available'),(1357,13,1,'127','available'),(1358,13,2,'201','available'),(1359,13,2,'202','available'),(1360,13,2,'203','available'),(1361,13,2,'204','available'),(1362,13,2,'205','available'),(1363,13,2,'206','available'),(1364,13,2,'207','available'),(1365,13,2,'208','available'),(1366,13,2,'209','available'),(1367,13,2,'210','available'),(1368,13,2,'211','available'),(1369,13,2,'212','available'),(1370,13,2,'213','available'),(1371,13,2,'214','available'),(1372,13,2,'215','available'),(1373,13,2,'216','available'),(1374,13,2,'217','available'),(1375,13,2,'218','available'),(1376,13,2,'219','available'),(1377,13,2,'220','available'),(1378,13,2,'221','available'),(1379,13,2,'222','available'),(1380,13,2,'223','available'),(1381,13,2,'224','available'),(1382,13,2,'225','available'),(1383,13,2,'226','available'),(1384,13,2,'227','available'),(1385,13,2,'228','available'),(1386,13,2,'229','available'),(1387,13,2,'230','available'),(1388,13,2,'231','available'),(1389,13,2,'232','available'),(1390,13,2,'233','available'),(1391,13,2,'234','available'),(1392,13,2,'235','available'),(1393,13,2,'236','available'),(1394,13,2,'237','available'),(1395,13,2,'238','available'),(1396,13,2,'239','available'),(1397,13,2,'240','available'),(1398,13,2,'241','available'),(1399,13,2,'242','available'),(1400,13,2,'243','available'),(1401,13,2,'244','available'),(1402,13,2,'245','available'),(1403,13,3,'301','available'),(1404,13,3,'302','available'),(1405,13,3,'303','available'),(1406,13,3,'304','available'),(1407,13,3,'305','available'),(1408,13,3,'306','available'),(1409,13,3,'307','available'),(1410,13,3,'308','available'),(1411,13,3,'309','available'),(1412,13,3,'310','available'),(1413,13,3,'311','available'),(1414,13,3,'312','available'),(1415,13,3,'313','available'),(1416,13,3,'314','available'),(1417,13,3,'315','available'),(1418,13,3,'316','available'),(1419,13,3,'317','available'),(1420,13,3,'318','available'),(1421,14,1,'101','available'),(1422,14,1,'102','available'),(1423,14,1,'103','available'),(1424,14,1,'104','available'),(1425,14,1,'105','available'),(1426,14,1,'106','available'),(1427,14,1,'107','available'),(1428,14,1,'108','available'),(1429,14,1,'109','available'),(1430,14,1,'110','available'),(1431,14,1,'111','available'),(1432,14,1,'112','available'),(1433,14,1,'113','available'),(1434,14,1,'114','available'),(1435,14,1,'115','available'),(1436,14,1,'116','available'),(1437,14,1,'117','available'),(1438,14,1,'118','available'),(1439,14,1,'119','available'),(1440,14,1,'120','available'),(1441,14,1,'121','available'),(1442,14,1,'122','available'),(1443,14,1,'123','available'),(1444,14,1,'124','available'),(1445,14,2,'201','available'),(1446,14,2,'202','available'),(1447,14,2,'203','available'),(1448,14,2,'204','available'),(1449,14,2,'205','available'),(1450,14,2,'206','available'),(1451,14,2,'207','available'),(1452,14,2,'208','available'),(1453,14,2,'209','available'),(1454,14,2,'210','available'),(1455,14,2,'211','available'),(1456,14,2,'212','available'),(1457,14,2,'213','available'),(1458,14,2,'214','available'),(1459,14,2,'215','available'),(1460,14,2,'216','available'),(1461,14,2,'217','available'),(1462,14,2,'218','available'),(1463,14,2,'219','available'),(1464,14,2,'220','available'),(1465,14,2,'221','available'),(1466,14,2,'222','available'),(1467,14,2,'223','available'),(1468,14,2,'224','available'),(1469,14,2,'225','available'),(1470,14,2,'226','available'),(1471,14,2,'227','available'),(1472,14,2,'228','available'),(1473,14,2,'229','available'),(1474,14,2,'230','available'),(1475,14,2,'231','available'),(1476,14,2,'232','available'),(1477,14,2,'233','available'),(1478,14,2,'234','available'),(1479,14,2,'235','available'),(1480,14,2,'236','available'),(1481,14,2,'237','available'),(1482,14,2,'238','available'),(1483,14,2,'239','available'),(1484,14,2,'240','available'),(1485,14,3,'301','available'),(1486,14,3,'302','available'),(1487,14,3,'303','available'),(1488,14,3,'304','available'),(1489,14,3,'305','available'),(1490,14,3,'306','available'),(1491,14,3,'307','available'),(1492,14,3,'308','available'),(1493,14,3,'309','available'),(1494,14,3,'310','available'),(1495,14,3,'311','available'),(1496,14,3,'312','available'),(1497,14,3,'313','available'),(1498,14,3,'314','available'),(1499,14,3,'315','available'),(1500,14,3,'316','available'),(1501,15,1,'101','available'),(1502,15,1,'102','available'),(1503,15,1,'103','available'),(1504,15,1,'104','available'),(1505,15,1,'105','available'),(1506,15,1,'106','available'),(1507,15,1,'107','available'),(1508,15,1,'108','available'),(1509,15,1,'109','available'),(1510,15,1,'110','available'),(1511,15,1,'111','available'),(1512,15,1,'112','available'),(1513,15,1,'113','available'),(1514,15,1,'114','available'),(1515,15,1,'115','available'),(1516,15,1,'116','available'),(1517,15,1,'117','available'),(1518,15,1,'118','available'),(1519,15,1,'119','available'),(1520,15,1,'120','available'),(1521,15,1,'121','available'),(1522,15,2,'201','available'),(1523,15,2,'202','available'),(1524,15,2,'203','available'),(1525,15,2,'204','available'),(1526,15,2,'205','available'),(1527,15,2,'206','available'),(1528,15,2,'207','available'),(1529,15,2,'208','available'),(1530,15,2,'209','available'),(1531,15,2,'210','available'),(1532,15,2,'211','available'),(1533,15,2,'212','available'),(1534,15,2,'213','available'),(1535,15,2,'214','available'),(1536,15,2,'215','available'),(1537,15,2,'216','available'),(1538,15,2,'217','available'),(1539,15,2,'218','available'),(1540,15,2,'219','available'),(1541,15,2,'220','available'),(1542,15,2,'221','available'),(1543,15,2,'222','available'),(1544,15,2,'223','available'),(1545,15,2,'224','available'),(1546,15,2,'225','available'),(1547,15,2,'226','available'),(1548,15,2,'227','available'),(1549,15,2,'228','available'),(1550,15,2,'229','available'),(1551,15,2,'230','available'),(1552,15,2,'231','available'),(1553,15,2,'232','available'),(1554,15,2,'233','available'),(1555,15,2,'234','available'),(1556,15,2,'235','available'),(1557,15,3,'301','available'),(1558,15,3,'302','available'),(1559,15,3,'303','available'),(1560,15,3,'304','available'),(1561,15,3,'305','available'),(1562,15,3,'306','available'),(1563,15,3,'307','available'),(1564,15,3,'308','available'),(1565,15,3,'309','available'),(1566,15,3,'310','available'),(1567,15,3,'311','available'),(1568,15,3,'312','available'),(1569,15,3,'313','available'),(1570,15,3,'314','available'),(1571,16,1,'101','available'),(1572,16,1,'102','available'),(1573,16,1,'103','available'),(1574,16,1,'104','available'),(1575,16,1,'105','available'),(1576,16,1,'106','available'),(1577,16,1,'107','available'),(1578,16,1,'108','available'),(1579,16,1,'109','available'),(1580,16,1,'110','available'),(1581,16,1,'111','available'),(1582,16,1,'112','available'),(1583,16,1,'113','available'),(1584,16,1,'114','available'),(1585,16,1,'115','available'),(1586,16,1,'116','available'),(1587,16,1,'117','available'),(1588,16,1,'118','available'),(1589,16,1,'119','available'),(1590,16,1,'120','available'),(1591,16,1,'121','available'),(1592,16,1,'122','available'),(1593,16,1,'123','available'),(1594,16,1,'124','available'),(1595,16,1,'125','available'),(1596,16,1,'126','available'),(1597,16,1,'127','available'),(1598,16,2,'201','available'),(1599,16,2,'202','available'),(1600,16,2,'203','available'),(1601,16,2,'204','available'),(1602,16,2,'205','available'),(1603,16,2,'206','available'),(1604,16,2,'207','available'),(1605,16,2,'208','available'),(1606,16,2,'209','available'),(1607,16,2,'210','available'),(1608,16,2,'211','available'),(1609,16,2,'212','available'),(1610,16,2,'213','available'),(1611,16,2,'214','available'),(1612,16,2,'215','available'),(1613,16,2,'216','available'),(1614,16,2,'217','available'),(1615,16,2,'218','available'),(1616,16,2,'219','available'),(1617,16,2,'220','available'),(1618,16,2,'221','available'),(1619,16,2,'222','available'),(1620,16,2,'223','available'),(1621,16,2,'224','available'),(1622,16,2,'225','available'),(1623,16,2,'226','available'),(1624,16,2,'227','available'),(1625,16,2,'228','available'),(1626,16,2,'229','available'),(1627,16,2,'230','available'),(1628,16,2,'231','available'),(1629,16,2,'232','available'),(1630,16,2,'233','available'),(1631,16,2,'234','available'),(1632,16,2,'235','available'),(1633,16,2,'236','available'),(1634,16,2,'237','available'),(1635,16,2,'238','available'),(1636,16,2,'239','available'),(1637,16,2,'240','available'),(1638,16,2,'241','available'),(1639,16,2,'242','available'),(1640,16,2,'243','available'),(1641,16,2,'244','available'),(1642,16,2,'245','available'),(1643,16,3,'301','available'),(1644,16,3,'302','available'),(1645,16,3,'303','available'),(1646,16,3,'304','available'),(1647,16,3,'305','available'),(1648,16,3,'306','available'),(1649,16,3,'307','available'),(1650,16,3,'308','available'),(1651,16,3,'309','available'),(1652,16,3,'310','available'),(1653,16,3,'311','available'),(1654,16,3,'312','available'),(1655,16,3,'313','available'),(1656,16,3,'314','available'),(1657,16,3,'315','available'),(1658,16,3,'316','available'),(1659,16,3,'317','available'),(1660,16,3,'318','available'),(1661,17,1,'101','available'),(1662,17,1,'102','available'),(1663,17,1,'103','available'),(1664,17,1,'104','available'),(1665,17,1,'105','available'),(1666,17,1,'106','available'),(1667,17,1,'107','available'),(1668,17,1,'108','available'),(1669,17,1,'109','available'),(1670,17,1,'110','available'),(1671,17,1,'111','available'),(1672,17,1,'112','available'),(1673,17,1,'113','available'),(1674,17,1,'114','available'),(1675,17,1,'115','available'),(1676,17,1,'116','available'),(1677,17,1,'117','available'),(1678,17,1,'118','available'),(1679,17,1,'119','available'),(1680,17,1,'120','available'),(1681,17,1,'121','available'),(1682,17,1,'122','available'),(1683,17,1,'123','available'),(1684,17,1,'124','available'),(1685,17,1,'125','available'),(1686,17,1,'126','available'),(1687,17,1,'127','available'),(1688,17,1,'128','available'),(1689,17,1,'129','available'),(1690,17,1,'130','available'),(1691,17,2,'201','available'),(1692,17,2,'202','available'),(1693,17,2,'203','available'),(1694,17,2,'204','available'),(1695,17,2,'205','available'),(1696,17,2,'206','available'),(1697,17,2,'207','available'),(1698,17,2,'208','available'),(1699,17,2,'209','available'),(1700,17,2,'210','available'),(1701,17,2,'211','available'),(1702,17,2,'212','available'),(1703,17,2,'213','available'),(1704,17,2,'214','available'),(1705,17,2,'215','available'),(1706,17,2,'216','available'),(1707,17,2,'217','available'),(1708,17,2,'218','available'),(1709,17,2,'219','available'),(1710,17,2,'220','available'),(1711,17,2,'221','available'),(1712,17,2,'222','available'),(1713,17,2,'223','available'),(1714,17,2,'224','available'),(1715,17,2,'225','available'),(1716,17,2,'226','available'),(1717,17,2,'227','available'),(1718,17,2,'228','available'),(1719,17,2,'229','available'),(1720,17,2,'230','available'),(1721,17,2,'231','available'),(1722,17,2,'232','available'),(1723,17,2,'233','available'),(1724,17,2,'234','available'),(1725,17,2,'235','available'),(1726,17,2,'236','available'),(1727,17,2,'237','available'),(1728,17,2,'238','available'),(1729,17,2,'239','available'),(1730,17,2,'240','available'),(1731,17,2,'241','available'),(1732,17,2,'242','available'),(1733,17,2,'243','available'),(1734,17,2,'244','available'),(1735,17,2,'245','available'),(1736,17,2,'246','available'),(1737,17,2,'247','available'),(1738,17,2,'248','available'),(1739,17,2,'249','available'),(1740,17,2,'250','available'),(1741,17,3,'301','available'),(1742,17,3,'302','available'),(1743,17,3,'303','available'),(1744,17,3,'304','available'),(1745,17,3,'305','available'),(1746,17,3,'306','available'),(1747,17,3,'307','available'),(1748,17,3,'308','available'),(1749,17,3,'309','available'),(1750,17,3,'310','available'),(1751,17,3,'311','available'),(1752,17,3,'312','available'),(1753,17,3,'313','available'),(1754,17,3,'314','available'),(1755,17,3,'315','available'),(1756,17,3,'316','available'),(1757,17,3,'317','available'),(1758,17,3,'318','available'),(1759,17,3,'319','available'),(1760,17,3,'320','available');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seasons`
--

DROP TABLE IF EXISTS `seasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seasons` (
  `season_id` int NOT NULL AUTO_INCREMENT,
  `season_name` varchar(20) NOT NULL COMMENT 'Peak or Off-Peak',
  `start_month` int NOT NULL COMMENT 'Starting month (1-12)',
  `end_month` int NOT NULL COMMENT 'Ending month (1-12)',
  PRIMARY KEY (`season_id`),
  CONSTRAINT `seasons_chk_1` CHECK (((`start_month` >= 1) and (`start_month` <= 12))),
  CONSTRAINT `seasons_chk_2` CHECK (((`end_month` >= 1) and (`end_month` <= 12)))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Season definitions: Peak (Apr-Aug, Nov-Dec), Off-Peak (Jan-Mar, Sep-Oct)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seasons`
--

LOCK TABLES `seasons` WRITE;
/*!40000 ALTER TABLE `seasons` DISABLE KEYS */;
INSERT INTO `seasons` VALUES (1,'Peak',4,8),(2,'Peak',11,12),(3,'Off-Peak',1,3),(4,'Off-Peak',9,10);
/*!40000 ALTER TABLE `seasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL COMMENT 'Bcrypt hashed password',
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `user_type` enum('standard','admin') DEFAULT 'standard',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_user_type` (`user_type`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='User accounts - customers and admins';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@worldhotels.com','$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5NU8dWX2qMgQa','Admin','User','+44 20 1234 5678','admin','2026-01-10 18:39:10'),(2,'john.smith@example.com','$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW','John','Smith','+44 7700 900001','standard','2026-01-10 18:39:10'),(3,'sarah.jones@example.com','$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW','Sarah','Jones','+44 7700 900002','standard','2026-01-10 18:39:10'),(4,'michael.brown@example.com','$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW','Michael','Brown','+44 7700 900003','standard','2026-01-10 18:39:10'),(5,'emma.wilson@example.com','$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW','Emma','Wilson','+44 7700 900004','standard','2026-01-10 18:39:10'),(6,'biplab@example.com','$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW','Biplab','Sharma','+977 9841234567','standard','2026-01-10 18:39:10');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `available_rooms_with_pricing`
--

/*!50001 DROP VIEW IF EXISTS `available_rooms_with_pricing`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `available_rooms_with_pricing` AS select `r`.`room_id` AS `room_id`,`r`.`room_number` AS `room_number`,`h`.`hotel_id` AS `hotel_id`,`h`.`city` AS `city`,`h`.`address` AS `address`,`rt`.`type_name` AS `room_type`,`rt`.`max_guests` AS `max_guests`,`p`.`price_gbp` AS `price_gbp`,`s`.`season_name` AS `season_name`,`r`.`status` AS `status` from ((((`rooms` `r` join `hotels` `h` on((`r`.`hotel_id` = `h`.`hotel_id`))) join `room_types` `rt` on((`r`.`room_type_id` = `rt`.`room_type_id`))) join `prices` `p` on(((`p`.`hotel_id` = `h`.`hotel_id`) and (`p`.`room_type_id` = `rt`.`room_type_id`)))) join `seasons` `s` on((`p`.`season_id` = `s`.`season_id`))) where (`r`.`status` = 'available') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `booking_summary`
--

/*!50001 DROP VIEW IF EXISTS `booking_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `booking_summary` AS select `b`.`booking_id` AS `booking_id`,`u`.`first_name` AS `first_name`,`u`.`last_name` AS `last_name`,`u`.`email` AS `email`,`h`.`city` AS `hotel_city`,`rt`.`type_name` AS `room_type`,`r`.`room_number` AS `room_number`,`b`.`check_in_date` AS `check_in_date`,`b`.`check_out_date` AS `check_out_date`,(to_days(`b`.`check_out_date`) - to_days(`b`.`check_in_date`)) AS `nights`,`b`.`number_of_guests` AS `number_of_guests`,`bp`.`final_price` AS `final_price`,`b`.`status` AS `status`,`b`.`booking_date` AS `booking_date` from (((((`bookings` `b` join `users` `u` on((`b`.`user_id` = `u`.`user_id`))) join `rooms` `r` on((`b`.`room_id` = `r`.`room_id`))) join `hotels` `h` on((`r`.`hotel_id` = `h`.`hotel_id`))) join `room_types` `rt` on((`r`.`room_type_id` = `rt`.`room_type_id`))) join `booking_pricing` `bp` on((`b`.`booking_id` = `bp`.`booking_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-11  0:34:44
