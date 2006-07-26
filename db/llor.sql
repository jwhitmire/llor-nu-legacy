-- MySQL dump 10.9
--
-- Host: llor.nu    Database: llor
-- ------------------------------------------------------
-- Server version	4.1.14

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE="NO_AUTO_VALUE_ON_ZERO" */;

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(50) NOT NULL auto_increment,
  `balance` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `banked` int(11) default NULL,
  `user_instance_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `deeds`
--

CREATE TABLE `deeds` (
  `id` int(50) NOT NULL auto_increment,
  `property_type_id` int(50) default NULL,
  `user_id` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `square_id` int(50) default NULL,
  `levels` int(50) default NULL,
  `health` int(50) NOT NULL default '14',
  `name` varchar(50) default NULL,
  `landed_on` int(50) NOT NULL default '0',
  `position` int(11) default NULL,
  `instance_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `property_type_id` (`property_type_id`),
  KEY `square_id` (`square_id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `event_types`
--

CREATE TABLE `event_types` (
  `id` int(50) NOT NULL auto_increment,
  `event` varchar(50) default NULL,
  `description` varchar(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(50) NOT NULL auto_increment,
  `user_id` int(50) default NULL,
  `event_type_id` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `instance_id` int(11) default NULL,
  `user_instance_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `god_messages`
--

CREATE TABLE `god_messages` (
  `id` int(11) NOT NULL auto_increment,
  `message` text,
  `instance_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `instance_users`
--

CREATE TABLE `instance_users` (
  `user_id` int(11) default NULL,
  `instance_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `instances`
--

CREATE TABLE `instances` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `user_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `description` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(50) NOT NULL auto_increment,
  `description` varchar(255) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(50) NOT NULL auto_increment,
  `user_id` int(50) NOT NULL default '0',
  `square_id` int(50) default NULL,
  `message` text,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `instance_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(50) NOT NULL auto_increment,
  `amount` int(50) NOT NULL default '0',
  `user_id` int(50) default NULL,
  `event_id` int(50) default NULL,
  `deed_id` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `deed_id` (`deed_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `property_types`
--

CREATE TABLE `property_types` (
  `id` int(50) NOT NULL auto_increment,
  `title` varchar(50) default NULL,
  `description` varchar(255) default NULL,
  `base_price` int(50) NOT NULL default '0',
  `min_level` int(50) NOT NULL default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `base_rent` int(50) default NULL,
  `max_levels` int(50) default NULL,
  `level_cost` int(50) default NULL,
  `level_modifier` int(50) default NULL,
  `position` int(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `schema_info`
--

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `id` int(50) NOT NULL auto_increment,
  `user_id` int(50) NOT NULL default '0',
  `cash` int(50) default NULL,
  `real_estate` int(50) default NULL,
  `buildings` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `instance_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sessions_session_id_index` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL auto_increment,
  `variable` varchar(100) default NULL,
  `value` text,
  `instance_id` int(11) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `square_types`
--

CREATE TABLE `square_types` (
  `id` int(50) NOT NULL auto_increment,
  `description` varchar(100) default NULL,
  `for_sale` tinyint(1) default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `squares`
--

CREATE TABLE `squares` (
  `id` int(50) NOT NULL auto_increment,
  `square_type_id` int(50) default NULL,
  `position` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `deeds_count` int(11) default '0',
  `locked_by_id` int(11) default NULL,
  `locked_at` datetime default NULL,
  `messages_count` int(11) default NULL,
  `instance_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `position` (`position`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `user_instances`
--

CREATE TABLE `user_instances` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `instance_id` int(11) default NULL,
  `square_id` int(11) default NULL,
  `active` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `user_items`
--

CREATE TABLE `user_items` (
  `id` int(50) NOT NULL auto_increment,
  `user_id` int(50) default NULL,
  `item_id` varchar(50) default NULL,
  `uses_left` int(50) default NULL,
  `active` int(2) NOT NULL default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `apply_mode` int(11) default NULL,
  `user_instance_id` int(11) default NULL,
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(50) NOT NULL auto_increment,
  `login` varchar(80) NOT NULL default '',
  `salted_password` varchar(40) NOT NULL default '',
  `email` varchar(60) NOT NULL default '',
  `name` varchar(50) default NULL,
  `square_id` int(50) NOT NULL default '1',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `test` varchar(50) default NULL,
  `turns` int(50) NOT NULL default '20',
  `firstname` varchar(40) default NULL,
  `lastname` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `verified` int(50) default '0',
  `role` varchar(40) default NULL,
  `security_token` varchar(40) default NULL,
  `token_expiry` datetime default NULL,
  `logged_in_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted` int(50) default '0',
  `delete_after` datetime default NULL,
  `instance_id` int(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `waiters`
--

CREATE TABLE `waiters` (
  `id` int(50) NOT NULL auto_increment,
  `email` varchar(200) default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- MySQL dump 10.9
--
-- Host: localhost    Database: llor
-- ------------------------------------------------------
-- Server version	4.1.11-standard

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE="NO_AUTO_VALUE_ON_ZERO" */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(50) NOT NULL auto_increment,
  `balance` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `user_id` int(50) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `deeds`
--

DROP TABLE IF EXISTS `deeds`;
CREATE TABLE `deeds` (
  `id` int(50) NOT NULL auto_increment,
  `property_type_id` int(50) default NULL,
  `user_id` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `square_id` int(50) default NULL,
  `levels` int(50) default NULL,
  `health` int(50) NOT NULL default '14',
  `name` varchar(50) default NULL,
  `landed_on` int(50) default '0',
  PRIMARY KEY  (`id`),
  KEY `property_type_id` (`property_type_id`),
  KEY `square_id` (`square_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `event_types`
--

DROP TABLE IF EXISTS `event_types`;
CREATE TABLE `event_types` (
  `id` int(50) NOT NULL auto_increment,
  `event` varchar(50) default NULL,
  `description` varchar(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `event_types`
--


/*!40000 ALTER TABLE `event_types` DISABLE KEYS */;
LOCK TABLES `event_types` WRITE;
INSERT INTO `event_types` VALUES (1,'Rent','A rent transaction',NULL,NULL),(2,'Buy Building','Building purchase',NULL,NULL),(3,'Paypal Fund Buy','Game funds purchased through Paypal',NULL,NULL),(4,'Level Sell Back','Player sold a level from a building they owned.',NULL,NULL),(5,'Level Upgrade','Player bought a level upgrade.',NULL,NULL),(6,'Daily Bread','The daily allowance from the game.',NULL,NULL),(7,'Building Maintenance','Incremental or full building maintenance.',NULL,NULL),(8,'Paid Rent','Not sure',NULL,NULL),(9,'Surprise 5000!','You found 5000!',NULL,NULL),(10,'Lotto!','Lotto!',NULL,NULL);
UNLOCK TABLES;
/*!40000 ALTER TABLE `event_types` ENABLE KEYS */;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `id` int(50) NOT NULL auto_increment,
  `user_id` int(50) default NULL,
  `event_type_id` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `events`
--

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
CREATE TABLE `items` (
  `id` int(50) NOT NULL auto_increment,
  `description` varchar(255) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `items`
--


/*!40000 ALTER TABLE `items` DISABLE KEYS */;
LOCK TABLES `items` WRITE;
INSERT INTO `items` VALUES (1,'Persuasive Duck','2005-09-19 09:03:53','2005-09-19 09:03:53');
UNLOCK TABLES;
/*!40000 ALTER TABLE `items` ENABLE KEYS */;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` int(50) NOT NULL auto_increment,
  `user_id` int(50) NOT NULL default '0',
  `square_id` int(50) default NULL,
  `message` text,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` int(50) NOT NULL auto_increment,
  `amount` int(50) NOT NULL default '0',
  `user_id` int(50) default NULL,
  `event_id` int(50) default NULL,
  `deed_id` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `property_types`
--

DROP TABLE IF EXISTS `property_types`;
CREATE TABLE `property_types` (
  `id` int(50) NOT NULL auto_increment,
  `title` varchar(50) default NULL,
  `description` varchar(255) default NULL,
  `base_price` int(50) NOT NULL default '0',
  `min_level` int(50) NOT NULL default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `base_rent` int(50) default NULL,
  `max_levels` int(50) default NULL,
  `level_cost` int(50) default NULL,
  `level_modifier` int(50) default NULL,
  `position` int(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `property_types`
--


/*!40000 ALTER TABLE `property_types` DISABLE KEYS */;
LOCK TABLES `property_types` WRITE;
INSERT INTO `property_types` VALUES (1,'Two Star Hotel','Minimal comfort, but commands the second highest hotel price.',2300,0,'2005-07-23 22:45:00','2005-07-23 22:55:22',200,20,2000,20,2),(2,'Cheap Hotel','Cheapest of the hotels. Roaches stay for free.',1200,0,'2005-07-23 22:50:00','2005-07-23 22:55:46',100,15,1000,10,1),(3,'Three Star Hotel','What most people expect out of a hotel. Coordinated pastel scenes above color coordinated beds.',3600,0,'2005-07-23 22:53:00','2005-07-23 22:55:03',300,25,3000,30,3),(4,'Super Insane Hotel','Perfection all around, this hotel commands the highest prices at the highest levels.',33000,0,NULL,NULL,900,30,36000,40,4);
UNLOCK TABLES;
/*!40000 ALTER TABLE `property_types` ENABLE KEYS */;

--
-- Table structure for table `scores`
--

DROP TABLE IF EXISTS `scores`;
CREATE TABLE `scores` (
  `id` int(50) NOT NULL auto_increment,
  `user_id` int(50) NOT NULL default '0',
  `cash` int(50) default NULL,
  `real_estate` int(50) default NULL,
  `buildings` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `scores`
--


--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `id` int(50) NOT NULL auto_increment,
  `setting` varchar(50) default NULL,
  `value` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `square_locks`
--

DROP TABLE IF EXISTS `square_locks`;
CREATE TABLE `square_locks` (
  `square_id` int(50) NOT NULL default '0',
  `user_id` int(50) default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`square_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `square_types`
--

DROP TABLE IF EXISTS `square_types`;
CREATE TABLE `square_types` (
  `id` int(50) NOT NULL auto_increment,
  `description` varchar(100) default NULL,
  `for_sale` tinyint(1) default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `square_types`
--


/*!40000 ALTER TABLE `square_types` DISABLE KEYS */;
LOCK TABLES `square_types` WRITE;
INSERT INTO `square_types` VALUES (1,'Game Owned',0,'2005-07-23 22:56:00','2005-07-23 22:56:55'),(2,'Player Owned',0,'2005-07-23 22:56:00','2005-07-23 22:57:07'),(3,'Empty, Buyable',1,'2005-07-23 22:57:00','2005-07-23 22:57:19'),(4,'Dead Space',0,'2005-07-23 22:57:00','2005-07-23 22:57:33'),(5,'Quicky',0,NULL,NULL);
UNLOCK TABLES;
/*!40000 ALTER TABLE `square_types` ENABLE KEYS */;

--
-- Table structure for table `squares`
--

DROP TABLE IF EXISTS `squares`;
CREATE TABLE `squares` (
  `id` int(50) NOT NULL auto_increment,
  `square_type_id` int(50) default NULL,
  `position` int(50) default NULL,
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `position` (`position`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `user_items`
--

DROP TABLE IF EXISTS `user_items`;
CREATE TABLE `user_items` (
  `id` int(50) NOT NULL auto_increment,
  `user_id` int(50) default NULL,
  `item_id` varchar(50) default NULL,
  `uses_left` int(50) default NULL,
  `active` int(2) NOT NULL default '0',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(50) NOT NULL auto_increment,
  `login` varchar(80) NOT NULL default '',
  `salted_password` varchar(40) NOT NULL default '',
  `email` varchar(60) NOT NULL default '',
  `name` varchar(50) default NULL,
  `square_id` int(50) NOT NULL default '1',
  `created_on` datetime default NULL,
  `updated_on` datetime default NULL,
  `test` varchar(50) default NULL,
  `turns` int(50) NOT NULL default '20',
  `firstname` varchar(40) default NULL,
  `lastname` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `verified` int(50) default '0',
  `role` varchar(40) default NULL,
  `security_token` varchar(40) default NULL,
  `token_expiry` datetime default NULL,
  `logged_in_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted` int(50) default '0',
  `delete_after` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


--
-- Table structure for table `waiters`
--

DROP TABLE IF EXISTS `waiters`;
CREATE TABLE `waiters` (
  `id` int(50) NOT NULL auto_increment,
  `email` varchar(200) default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

