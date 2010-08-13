-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Sam 14 Août 2010 à 00:16
-- Version du serveur: 5.1.37
-- Version de PHP: 5.2.11

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Base de données: `visu2`
--

-- --------------------------------------------------------

--
-- Structure de la table `activities`
--

CREATE TABLE `activities` (
  `id_activity` int(11) NOT NULL AUTO_INCREMENT,
  `id_session` int(11) NOT NULL,
  `title` text,
  `duration` int(6) DEFAULT NULL,
  `ind` int(2) DEFAULT NULL,
  PRIMARY KEY (`id_activity`,`id_session`),
  UNIQUE KEY `IDX_activities2` (`id_activity`),
  KEY `IDX_activities1` (`id_session`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Contenu de la table `activities`
--

INSERT INTO `activities` VALUES(8, 3, 'ererererere', 1, 2);
INSERT INTO `activities` VALUES(7, 3, 'ereererereerer', 3, 4);
INSERT INTO `activities` VALUES(3, 2, 'Activity  3 , session 2', 35, 10);
INSERT INTO `activities` VALUES(4, 2, 'Activity 4', 35, 12);
INSERT INTO `activities` VALUES(9, 4, 'gfdx', NULL, NULL);
INSERT INTO `activities` VALUES(10, 4, 'qsfezrq', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `activities_elements`
--

CREATE TABLE `activities_elements` (
  `id_element` int(11) NOT NULL AUTO_INCREMENT,
  `id_activity` int(11) NOT NULL,
  `data` text,
  `url_element` varchar(255) DEFAULT NULL,
  `type_element` varchar(40) DEFAULT NULL,
  `type_mime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_element`,`id_activity`),
  KEY `IDX_activities_elements1` (`id_activity`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

--
-- Contenu de la table `activities_elements`
--

INSERT INTO `activities_elements` VALUES(15, 4, 'hello we will see oure s d \r\nactivity 4 ', 'http://djazd', 'memo', NULL);
INSERT INTO `activities_elements` VALUES(14, 4, 'memo activity 4', 'sd', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(17, 8, 'fdfdfdfd', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(16, 7, 'dfdfdffd', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(6, 3, 'con number id = 3 ', '33', 'keyword', '33');
INSERT INTO `activities_elements` VALUES(7, 3, 'con 7 activity = 3', 'sd', 'consigne', 'ds');
INSERT INTO `activities_elements` VALUES(18, 9, 'fghjfkg', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(19, 10, 'oijvbuighjkhjk', NULL, 'keyword', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `modules`
--

CREATE TABLE `modules` (
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `label` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `css` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `profileUser` smallint(2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `modules`
--

INSERT INTO `modules` VALUES('home', 'Accueil', 'modules/HomeModule.swf', 'accueil.ccs', 4);
INSERT INTO `modules` VALUES('user', 'Utilisateurs', 'modules/UserModule.swf', 'utilisateur.ccs', 2);
INSERT INTO `modules` VALUES('session', 'Séances', 'modules/SessionModule.swf', 'session.ccs', 3);
INSERT INTO `modules` VALUES('tutorat', 'Salon synchrone', 'modules/TutoratModule.swf', 'tutorat.ccs', 4);
INSERT INTO `modules` VALUES('retrospection', 'Salon de rétrospection', 'modules/RetrospectionModule.swf', 'retrospection.ccs', 4);

-- --------------------------------------------------------

--
-- Structure de la table `obsels`
--

CREATE TABLE `obsels` (
  `id_obsel` int(11) NOT NULL,
  `trace` varchar(255) DEFAULT NULL,
  `type_obsel` varchar(255) NOT NULL,
  `begin_obsel` datetime DEFAULT NULL,
  `rdf` text,
  PRIMARY KEY (`id_obsel`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `obsels`
--


-- --------------------------------------------------------

--
-- Structure de la table `profile_descriptions`
--

CREATE TABLE `profile_descriptions` (
  `profile` int(2) NOT NULL AUTO_INCREMENT,
  `short_description` varchar(255) NOT NULL,
  `long_description` text NOT NULL,
  PRIMARY KEY (`profile`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=212123 ;

--
-- Contenu de la table `profile_descriptions`
--

INSERT INTO `profile_descriptions` VALUES(101011, 'tuteur', 'it user with droit .....');
INSERT INTO `profile_descriptions` VALUES(212122, 'etudiant', 'user - etudiant');

-- --------------------------------------------------------

--
-- Structure de la table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `roles`
--


-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

CREATE TABLE `sessions` (
  `id_session` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `description` varchar(40) DEFAULT NULL,
  `theme` text,
  `date_session` datetime DEFAULT NULL,
  `isModel` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_session`,`id_user`),
  UNIQUE KEY `IDX_sessions1` (`id_session`,`id_user`),
  UNIQUE KEY `IDX_sessions2` (`id_session`),
  KEY `IDX_sessions3` (`id_user`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Contenu de la table `sessions`
--

INSERT INTO `sessions` VALUES(1, 1, 'Les identit?©s (nationales)', 'Les identit?©s nationales theme 1', '2010-09-01 11:15:00', 0);
INSERT INTO `sessions` VALUES(2, 1, 'Les sports', 'Le metier PC', '2010-09-02 12:23:00', 0);
INSERT INTO `sessions` VALUES(3, 4, 'sdsdsdsds', 'NASA', '2010-07-21 13:20:00', 0);
INSERT INTO `sessions` VALUES(4, 4, 'sdsdsdsds', 'SALUT', '2010-07-21 14:00:00', 0);
INSERT INTO `sessions` VALUES(5, 4, 'sdsdsdsds', 'MONSTER TRACK', '2010-07-21 15:50:00', 0);
INSERT INTO `sessions` VALUES(6, 4, 'sdsdsdsds', 'OSEAN', '2010-07-20 16:55:00', 0);
INSERT INTO `sessions` VALUES(7, 4, 'sdsdsdsds', 'HISTORY', '2010-07-20 17:00:00', 0);

-- --------------------------------------------------------

--
-- Structure de la table `session_users`
--

CREATE TABLE `session_users` (
  `id_session_user` int(11) NOT NULL AUTO_INCREMENT,
  `id_session` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `mask` int(20) DEFAULT NULL,
  PRIMARY KEY (`id_session_user`),
  UNIQUE KEY `IDX_users1` (`id_session_user`),
  KEY `id_session` (`id_session`,`id_user`),
  KEY `id_user` (`id_user`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=481 ;

--
-- Contenu de la table `session_users`
--

INSERT INTO `session_users` VALUES(478, 1, 7, 0);
INSERT INTO `session_users` VALUES(401, 1, 4, NULL);
INSERT INTO `session_users` VALUES(402, 1, 5, NULL);
INSERT INTO `session_users` VALUES(479, 7, 1, 0);
INSERT INTO `session_users` VALUES(472, 5, 2, 0);
INSERT INTO `session_users` VALUES(461, 2, 7, 0);
INSERT INTO `session_users` VALUES(406, 2, 5, NULL);
INSERT INTO `session_users` VALUES(407, 3, 2, NULL);
INSERT INTO `session_users` VALUES(408, 3, 7, NULL);
INSERT INTO `session_users` VALUES(474, 3, 10, 0);
INSERT INTO `session_users` VALUES(475, 3, 8, 0);
INSERT INTO `session_users` VALUES(411, 4, 2, NULL);
INSERT INTO `session_users` VALUES(456, 4, 7, 0);
INSERT INTO `session_users` VALUES(468, 4, 10, 0);
INSERT INTO `session_users` VALUES(476, 4, 6, 0);
INSERT INTO `session_users` VALUES(469, 4, 9, 0);
INSERT INTO `session_users` VALUES(465, 5, 6, 0);
INSERT INTO `session_users` VALUES(470, 5, 10, 0);
INSERT INTO `session_users` VALUES(454, 6, 7, 0);
INSERT INTO `session_users` VALUES(458, 6, 8, 0);
INSERT INTO `session_users` VALUES(480, 7, 3, 0);
INSERT INTO `session_users` VALUES(471, 5, 9, 0);
INSERT INTO `session_users` VALUES(443, 7, 2, 0);
INSERT INTO `session_users` VALUES(473, 5, 8, 0);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `activation_key` varchar(255) DEFAULT NULL,
  `recovery_key` varchar(255) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `profil` varchar(20) NOT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `IDX_users1` (`id_user`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Contenu de la table `users`
--

INSERT INTO `users` VALUES(9, 'Caroline(9)', 'PUSKIN', '9', 'ddd', 'iYBFtFjJav5g2HUCSlbDfkoyyqvGu9Jl', NULL, 'https://lh5.googleusercontent.com/_1ZVBfqNsv9Y/SxOx8-WistI/AAAAAAAABU4/vnjK5_RpN_U/s104-c/CIMG4149.JPG', '00000000000000000111');
INSERT INTO `users` VALUES(7, 'Serguei(7)', 'BERIA', '7', 'ddd', '2NKaZrSikJ6eaE65Y9NgXkBRYoJcNhfd', NULL, 'https://lh4.googleusercontent.com/_Um9A48A3vEc/TCR2VKpjWYI/AAAAAAAAABY/jus3oDYwq-I/s104-c/Photo%20du%2040908606-06-%20%C3%A0%2011.21.jpg', '00000000000111110111');
INSERT INTO `users` VALUES(3, 'Mireille(3)', 'Boris', 'borg@nomail.com', 'test', '1', '1', 'https://lh5.googleusercontent.com/_vY7gOxMIp68/SxjkqpqqfhI/AAAAAAAAAAU/5LNPnJmhmzA/s104-c/Mireille_nice09.png', '00000001000111110111');
INSERT INTO `users` VALUES(5, 'Pierre-Antoine(5)', 'SPILBERG', '5', 'ddd', NULL, NULL, 'https://www.google.com/s2/photos/public/AIbEiAIAAABDCPPq7NXY69HMNiILdmNhcmRfcGhvdG8qKGViMmMzNDgzOGUzMTE2Yzc2YjcwNjJkZTY3NTI4NzhjNTE3NjI5MWIwARzPKIpRk68U1QG17Wm3slYDPcid', '00000000000111110111');
INSERT INTO `users` VALUES(8, 'Amaury(8)', 'ONO', '8', 'ddd', '62IEJc3Gl97BVBTexSAO2GnvwZ8lfWOI', NULL, 'https://www.google.com/s2/photos/public/AIbEiAIAAABECJ6n3rTk49PBswEiC3ZjYXJkX3Bob3RvKihlMjVhYjkxYmM0ZWFkYjFiYjk0ZDlhNDAyNWFmNmJjMGEwMzg1ZDgyMAEcvuHyYQFXL0yqcEZFn7TO0ettNg', '00000000000111110111');
INSERT INTO `users` VALUES(10, 'Julien(10)', 'zerin', '10', NULL, NULL, NULL, 'https://lh5.googleusercontent.com/_-55IClUE5xs/SyEEtWRy7jI/AAAAAAAAAAU/wNus2BsA-2k/s104-c/Julien50Carre.jpg', '00000000000000000111');
INSERT INTO `users` VALUES(1, 'Nicolas(1)', 'odin', 'zoran', NULL, NULL, NULL, 'https://lh5.googleusercontent.com/_sWPdVPqWc7Y/Sy5v8f7VfRI/AAAAAAAAABE/jFf1mDOa3ko/s104-c/NCinVCV.JPG', '00010001000111110111');
INSERT INTO `users` VALUES(2, 'Yannick(2)', '', 'mail2', NULL, NULL, NULL, 'https://www.google.com/s2/photos/public/AIbEiAIAAABDCPWu6cWirJutOCILdmNhcmRfcGhvdG8qKDY1ZGY3NjQ3NmE1NzQ3YjUxMGQ0MzdjNmVlNzVmOWE2MzZkMGRkNGMwAdy7DbpsitHUcsHbxWFVEw18gOu-', '00000001000111110111');
INSERT INTO `users` VALUES(4, 'Olivier(4)', '', 'mail4', NULL, NULL, NULL, 'https://www.google.com/s2/photos/public/AIbEiAIAAABDCIH5gcm-xq2HeiILdmNhcmRfcGhvdG8qKDg0ZTA5ZWE3MTEyODY0Y2NlNDIzMTcxNGViNzZhMTA1YjVhYWJlNTcwASX_iNj7ymDHyzNAEKDfn_3D3xtb', '00000000000111110111');
INSERT INTO `users` VALUES(6, 'Lionel(6)', '', 'mail6', NULL, NULL, NULL, 'https://lh3.googleusercontent.com/_r4tG6k7JBcg/S0H_ok3HOSI/AAAAAAAACH8/U3Un09ysGqw/s104-c/avatar-2.jpg', '00000000000111110111');
