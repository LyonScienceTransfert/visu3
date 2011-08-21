-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Dim 21 Août 2011 à 13:15
-- Version du serveur: 5.1.37
-- Version de PHP: 5.2.11

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
--
-- Base de données: `visu`
--

-- --------------------------------------------------------

--
-- Structure de la table `activities`
--

DROP TABLE IF EXISTS `activities`;
CREATE TABLE IF NOT EXISTS `activities` (
  `id_activity` int(11) NOT NULL AUTO_INCREMENT,
  `id_session` int(11) NOT NULL,
  `title` text,
  `duration` int(6) DEFAULT NULL,
  `ind` int(2) DEFAULT NULL,
  PRIMARY KEY (`id_activity`,`id_session`),
  UNIQUE KEY `IDX_activities2` (`id_activity`),
  KEY `IDX_activities1` (`id_session`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1184 ;

-- --------------------------------------------------------

--
-- Structure de la table `activities_elements`
--

DROP TABLE IF EXISTS `activities_elements`;
CREATE TABLE IF NOT EXISTS `activities_elements` (
  `id_element` int(11) NOT NULL AUTO_INCREMENT,
  `id_activity` int(11) NOT NULL,
  `data` text,
  `url_element` varchar(255) DEFAULT NULL,
  `type_element` varchar(40) DEFAULT NULL,
  `type_mime` varchar(255) DEFAULT NULL,
  `order_activity_element` int(2) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id_element`,`id_activity`),
  KEY `IDX_activities_elements1` (`id_activity`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19679 ;

-- --------------------------------------------------------

--
-- Structure de la table `modules`
--

DROP TABLE IF EXISTS `modules`;
CREATE TABLE IF NOT EXISTS `modules` (
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `label` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `css` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `profileUser` smallint(2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


INSERT INTO `modules` VALUES('home', 'Accueil', 'modules/HomeModule.swf', 'accueil.ccs', 4);
INSERT INTO `modules` VALUES('user', 'Utilisateurs', 'modules/UserModule.swf', 'utilisateur.ccs', 2);
INSERT INTO `modules` VALUES('session', 'Séances', 'modules/SessionModule.swf', 'session.ccs', 3);
INSERT INTO `modules` VALUES('tutorat', 'Salon synchrone', 'modules/TutoratModule.swf', 'tutorat.ccs', 4);
INSERT INTO `modules` VALUES('retrospection', 'Salon de rétrospection', 'modules/RetrospectionModule.swf', 'retrospection.ccs', 4);
INSERT INTO `modules` VALUES('bilan', 'Bilans', 'modules/BilanModule.swf', 'bilan.ccs', 4);

-- --------------------------------------------------------

--
-- Structure de la table `obsels`
--

DROP TABLE IF EXISTS `obsels`;
CREATE TABLE IF NOT EXISTS `obsels` (
  `id_obsel` int(11) NOT NULL AUTO_INCREMENT,
  `trace` varchar(255) DEFAULT NULL,
  `type_obsel` varchar(255) NOT NULL,
  `begin_obsel` datetime DEFAULT NULL,
  `rdf` text,
  PRIMARY KEY (`id_obsel`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=43468 ;

-- --------------------------------------------------------

--
-- Structure de la table `profile_descriptions`
--

DROP TABLE IF EXISTS `profile_descriptions`;
CREATE TABLE IF NOT EXISTS `profile_descriptions` (
  `profile` int(2) NOT NULL AUTO_INCREMENT,
  `short_description` varchar(255) NOT NULL,
  `long_description` text NOT NULL,
  PRIMARY KEY (`profile`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1048577 ;


INSERT INTO `profile_descriptions` VALUES(503, 'tuteur', 'it user with droit .....');
INSERT INTO `profile_descriptions` VALUES(7, 'etudiant', 'user - etudiant');
INSERT INTO `profile_descriptions` VALUES(4599, 'responsable', 'user with manager status\n');
INSERT INTO `profile_descriptions` VALUES(70135, 'administrateur', 'administrator');
-- --------------------------------------------------------

--
-- Structure de la table `retro_document`
--

DROP TABLE IF EXISTS `retro_document`;
CREATE TABLE IF NOT EXISTS `retro_document` (
  `id_retro_document` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `id_owner` int(10) unsigned zerofill NOT NULL,
  `id_session` int(10) unsigned zerofill NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_modification_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `xml` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id_retro_document`),
  KEY `by_owner` (`id_owner`),
  KEY `by_owner_and_by_session` (`id_owner`,`id_session`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='The documents created in the retrospection room that contain' AUTO_INCREMENT=131 ;

-- --------------------------------------------------------

--
-- Structure de la table `retro_document_access`
--

DROP TABLE IF EXISTS `retro_document_access`;
CREATE TABLE IF NOT EXISTS `retro_document_access` (
  `id_retro_document` int(10) unsigned zerofill NOT NULL,
  `id_user` int(10) unsigned zerofill NOT NULL COMMENT 'The id of the user who has a read access to the retrospection document',
  PRIMARY KEY (`id_retro_document`,`id_user`),
  KEY `by_document` (`id_user`),
  KEY `by_user` (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='The users that have a read access on a retrospection documen';

-- --------------------------------------------------------

--
-- Structure de la table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE IF NOT EXISTS `sessions` (
  `id_session` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `description` varchar(40) DEFAULT NULL,
  `theme` text,
  `date_session` datetime DEFAULT '2000-01-01 00:00:00',
  `isModel` tinyint(1) DEFAULT NULL,
  `start_recording` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `status_session` tinyint(1) NOT NULL DEFAULT '0',
  `id_currentActivity` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_session`,`id_user`),
  UNIQUE KEY `IDX_sessions1` (`id_session`,`id_user`),
  UNIQUE KEY `IDX_sessions2` (`id_session`),
  KEY `IDX_sessions3` (`id_user`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=349 ;

-- --------------------------------------------------------

--
-- Structure de la table `session_users`
--

DROP TABLE IF EXISTS `session_users`;
CREATE TABLE IF NOT EXISTS `session_users` (
  `id_session_user` int(11) NOT NULL AUTO_INCREMENT,
  `id_session` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `mask` int(20) DEFAULT NULL,
  PRIMARY KEY (`id_session_user`),
  UNIQUE KEY `IDX_users1` (`id_session_user`),
  KEY `id_session` (`id_session`,`id_user`),
  KEY `id_user` (`id_user`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1306 ;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `activation_key` varchar(255) DEFAULT NULL,
  `recovery_key` varchar(255) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `profil` varchar(20) NOT NULL,
  `message` varchar(3000) DEFAULT 'Hello...',
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `IDX_users1` (`id_user`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=101 ;

INSERT INTO `users` VALUES(1, 'Admin', 'ADMIN', 'admin', 'admin', NULL, NULL, 'https://wave.google.com/wave/static/images/unknown.jpg', '00010001000111110111','Hello, ___' );

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


