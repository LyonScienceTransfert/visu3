-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Jeudi 08 Sept 2011 à 15:58
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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `activities` (
  `id_activity` int(11) NOT NULL auto_increment,
  `id_session` int(11) NOT NULL,
  `title` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `duration` int(6) default NULL,
  `ind` int(2) default NULL,
  PRIMARY KEY  (`id_activity`,`id_session`),
  UNIQUE KEY `IDX_activities2` (`id_activity`),
  KEY `IDX_activities1` (`id_session`)
) ENGINE=MyISAM AUTO_INCREMENT=1334 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

-- --------------------------------------------------------
INSERT INTO `activities` VALUES(1, 1, '1. Les bourgeois-bohème', 15, 0);
INSERT INTO `activities` VALUES(2, 1, '2. Les nappies : la jeunesse dorée des beaux quartiers du sud-ouest parisien', 10, 1);
INSERT INTO `activities` VALUES(3, 1, '3. De la cité aux beaux quartiers de Paris', 10, 2);
INSERT INTO `activities` VALUES(4, 1, '4. Le style bling-bling', 10, 3);
--
-- Structure de la table `activities_elements`
--

DROP TABLE IF EXISTS `activities_elements`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `activities_elements` (
  `id_element` int(11) NOT NULL auto_increment,
  `id_activity` int(11) NOT NULL,
  `data` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `url_element` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `type_element` varchar(40) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `type_mime` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `order_activity_element` int(2) NOT NULL default '-1',
  PRIMARY KEY  (`id_element`,`id_activity`),
  KEY `IDX_activities_elements1` (`id_activity`)
) ENGINE=MyISAM AUTO_INCREMENT=20223 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

-- --------------------------------------------------------
INSERT INTO `activities_elements` VALUES(1, 1, 'Cette catégorie sociale (les bourgeois-bohème/bobos) existe en France. Est-ce le cas aux Etats-Unis ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(2, 1, 'A quoi associez-vous cette catégorie aux US ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(3, 1, 'D’autres catégories de personnes existent-elles dans votre université, par exemple ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(4, 1, 'Garder en tête que les questions sont là pour expliquer l’expression « bobo » et la devise entre guillemets ; Re-contextualiser le document (bande-dessinée de notre époque/actuelle, édition Fluide Glacial ? plutôt critique vis-à-vis de la société, cynique ; il s’agit d’une bande-dessinée se moquant gentiment de l’attitude des bourgeois-bohêmes dans la société.', '', 'memo', NULL, -1);
INSERT INTO `activities_elements` VALUES(5, 1, 'debout/assis', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(6, 1, 'champagne', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(7, 1, 'laisse', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(8, 1, 'chien', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(9, 1, 'bobos', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(10, 1, 'bourgeois-bohême', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(11, 1, 'sac', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(12, 1, 'sachet', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(13, 1, 'bandage', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(14, 1, 'lunettes', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(15, 1, 'à la mode', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(16, 1, 'Sans Domicile Fixe (S.D.F.)', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(17, 1, 'bouteille de vin', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(18, 1, 'chien', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(19, 1, 'faire la manche', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(20, 1, 'tente', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(21, 1, 'poussette', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(22, 1, '(fumer) un cigare', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(23, 1, 'snob', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(24, 1, 'matérialiste', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(25, 1, 'les marques', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(26, 1, 'nature et découverte', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(27, 1, 'bio', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(28, 1, 'ethnique', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(29, 1, 'Couverture de la bande dessinée "Bienvenue à Boboland"', 'http://www.krinein.com/img_oc/big/9060.jpg', 'image', NULL, -1);
INSERT INTO `activities_elements` VALUES(30, 2, 'couverture livre', 'http://www.decitre.fr/gi/69/3277450158569FS.gif', 'image', NULL, -1);
INSERT INTO `activities_elements` VALUES(31, 2, 'affiche du film', 'http://www.critikeurs.fr/wp-content/uploads/2009/09/hell.jpg', 'image', NULL, -1);
INSERT INTO `activities_elements` VALUES(32, 2, 'Selon vous, qui est cette fille ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(33, 2, 'Comment s’appelle-t-elle ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(34, 2, 'Quel âge a-t-elle ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(35, 2, 'Que fait-elle dans la vie ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(36, 2, 'Que vous inspire-t-elle ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(37, 2, 'Selon vous, pourquoi ce livre s’appelle Hell ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(38, 2, 'Etes-vous choqué par ces images ? Ces livre/film pourraient-ils sortir aux USA ? Pourquoi ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(39, 2, 'Ce type de fille existe-t-il aux USA ? En connaissez-vous autour de vous ? Dans les médias?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(40, 2, 'Imaginez sa vie 5 ans après? Comment pourrait-elle sortir de cet enfer? Si vous aviez une amie qui souffrait de cet enfer, que feriez-vous pour elle?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(41, 2, 'Contextualisation : - la première de couverture d’un roman de Lolita Pille qui avait 19 ans à l’époque et l’affiche de son adaption au cinéma en 2006. Le titre évoque à la fois le prénom du personnage principal, Ella et l’enfer qu’elle vit quotidiennement (argent, opulence, déchéance, alcool, etc.) ; Penser à faire utiliser le futur et le conditionnel autant que possible ; Q3 : Poser « Etes-vous choqué par ces image ? ». Attendre leur réaction et mentionner alors que le film et le livre ont fait polémique en France lors de leurs sorties et leur demander pourquoi. ; Q4 : (journaux, télévision, cinéma : Lindsay Lohan, Paris Hilton, Gossip Girls, Beverly Hills, etc.) ; Vous pouvez la comparer à la catégorie des bobos, pour faire débat.', '', 'memo', NULL, -1);
INSERT INTO `activities_elements` VALUES(42, 2, 'faire un doigt d’honneur', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(43, 2, 'collier/sautoir de perles', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(44, 2, 'robe noire', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(45, 2, 'couverture', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(46, 2, 'nonchalante', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(47, 2, 'déchanchement/faire un déhanché', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(48, 3, 'Sami, le jeune garçon en premier plan n’a pas l’air content d’aller vivre avec cette nouvelle famille, pourquoi, selon vous ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(49, 3, 'Pourquoi le père de famille, Stanislas, s’énerve pendant le repas ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(50, 3, 'Quelles sont les réactions des autres membres de la famille ? Pourquoi ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(51, 3, 'Pensez-vous que la réaction de Stanislas soit excessive ? Pourquoi ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(52, 3, 'Si vous deviez être un membre de cette famille, qui seriez-vous? Pourquoi?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(53, 3, 'Avez-vous déjà vécu ce genre de choc culturel ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(54, 3, 'Contextualisation : Il s’agit d’un film qui est sorti cet été 2009 et qui a eu un gros succès en France. L’histoire : suite à la mort de son père, Sami, un jeune garçon de la cité, est confié à sa tante qui s’est mariée avec un patron d’entreprise, Stanislas. Ils habitent Neuilly, un quartier chic de Paris. ; Cité = banlieue où habitent une majorité de personnes défavorisées ; Nous avons choisi l’affiche car elle montre l’opposition entre les deux mondes (banlieue/quartier chic) et l’extrait 4 car il montre un décalage entre les habitudes de Sami et celles de Stanislas. En effet, Stanislas s’énerve un peu trop, simplement parce que Sami utilise mal ses couverts ; Q1 : Il s’agit de parler des éléments qui opposent Sami (tenue sportive, air renfrogné, solitaire vs. Tenues plus classes et colorés, airs enjoués, ensemble, grande maison) et d’en venir à l’opposition de leur milieu respectif. Un peu de la même manière que la tâche 2 (Hell) mais avec une démarche différente, l’apprenant se dirige vers un point de réflexion (représentations stéréotypées de classes sociales et leur confrontation) en s’appropriant/imaginant l’histoire ; Q2 : Elle permet de poser le contexte ; Q3-Q4 : Une réaction qui permet de voir le stéréotype d’une réaction bourgeoise à table et son versant. L’apprenant peut répondre par rapport aux mimiques des personnages ou par rapport à ce qu’ils disent ; Q5 : Elle permet d’ouvrir vers une discussion plus concrète sur la société US.', '', 'memo', NULL, -1);
INSERT INTO `activities_elements` VALUES(55, 3, 'survet’/survêtement', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(56, 3, 'baskets/tennis', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(57, 3, 'chaussette retroussée', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(58, 3, 'sac à bandoulière', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(59, 3, 'sweat', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(60, 3, 'gris', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(61, 3, 'chien', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(62, 3, 'pancarte/panneau d’indication', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(63, 3, 'costume', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(64, 3, 'jupe', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(65, 3, 'robe', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(66, 3, 'demeure', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(67, 3, 'cour', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(68, 3, 'arbres', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(69, 3, 'vieille famille française', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(70, 3, 'plier', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(71, 3, 'salade', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(72, 3, 'couteau', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(73, 3, 'fourchette', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(74, 3, 'old-school', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(75, 3, 'psychorigide', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(76, 3, 'psy', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(77, 3, 'taper', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(78, 3, 'couverts en argent', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(79, 3, 'ta mère', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(80, 3, 'insulte', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(81, 3, 'Neuilly', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(82, 3, 'l’un des quartiers les plus chics de Paris', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(83, 3, 'affiche du film', 'http://blog.lefigaro.fr/bd/Neuilly_sa_mere.jpg', 'image', NULL, -1);
INSERT INTO `activities_elements` VALUES(84, 3, 'extrait 4 du film', 'http://www.youtube.com/watch?v=85vGQwen4vk', 'video', NULL, -1);
INSERT INTO `activities_elements` VALUES(85, 4, 'En regardant cette image, comment imaginez-vous la soirée organisée ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(86, 4, 'Aimeriez-vous y aller ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(87, 4, 'Pourquoi ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(88, 4, 'Qui l’organise, selon vous ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(89, 4, 'L’affiche est-elle choquante?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(90, 4, 'Pourquoi/pas?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(91, 4, 'Connaissez-vous la personne en photo ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(92, 4, 'Quel lien feriez-vous entre les deux photos ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(93, 4, 'Y-a-t-il un équivalent aux USA ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(94, 4, 'Pensez-vous que votre président est bling-bling ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(95, 4, 'Connaissez-vous des célébrités bling-bling ?', '', 'consigne', NULL, -1);
INSERT INTO `activities_elements` VALUES(96, 4, 'Donnez à voir une première photo qui montre le style bling-bling et discutez-en. (La première image est un montage pour une soirée d’étudiants d’Ecole Supérieure des Sciences et Technologies de l’Ingénieur de Nancy ; la seconde est apparemment la couverture d’un livre sur le hip-hop) ; Ensuite, montrez une photo du président associée à ce terme puis discutez-en.', '', 'memo', NULL, -1);
INSERT INTO `activities_elements` VALUES(97, 4, 'bouteille de vodka', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(98, 4, 'alcool', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(99, 4, 'verre à cocktail', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(100, 4, 'couronne', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(101, 4, 'statue', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(102, 4, 'premier/second plan', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(103, 4, 'voiture', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(104, 4, 'doré(é)', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(105, 4, 'dorure', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(106, 4, 'or', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(107, 4, 'brillant', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(108, 4, 'entrée (P.A.F. : participation aux frais)', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(109, 4, 'frou-frou', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(110, 4, 'plumes', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(111, 4, 'blanc', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(112, 4, 'jus d’orange', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(113, 4, 'soirée/fête étudiante', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(114, 4, 'étage', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(115, 4, 'style', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(116, 4, 'publicité', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(117, 4, 'tape à l’œil', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(118, 4, '« se la péter »', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(119, 4, 'chaine argentée', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(120, 4, 'argent', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(121, 4, 'étincelle', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(122, 4, 'flash', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(123, 4, 'fond', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(124, 4, 'lettrage/lettres', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(125, 4, 'ballerine', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(126, 4, 'danseur/danseuse', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(127, 4, 'rose', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(128, 4, 'bleu', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(129, 4, 'pyramide', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(130, 4, 'public', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(131, 4, 'prestation', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(132, 4, 'spectacle de danse', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(133, 4, 'sauter', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(134, 4, 'à la Une', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(135, 4, 'le Gros Titre', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(136, 4, 'champ', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(137, 4, 'être au téléphone', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(138, 4, 'lunettes de soleil', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(139, 4, 'costard', '', 'keyword', NULL, -1);
INSERT INTO `activities_elements` VALUES(140, 4, 'affiche fête étudiante', 'http://www.nancybynight.com/imggrde/2008-12-04-AfficheEtag.JPG', 'image', NULL, -1);
INSERT INTO `activities_elements` VALUES(141, 4, '0 	la Une de Libération', 'http://3.bp.blogspot.com/_BSF-pi181OQ/R2mWlNR_EoI/AAAAAAAABLo/zw5PkoRbHhA/s400/bling+bling.jpg', 'image', NULL, -1);

--
-- Structure de la table `modules`
--

DROP TABLE IF EXISTS `modules`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `modules` (
  `name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `label` varchar(255) collate utf8_unicode_ci NOT NULL,
  `url` varchar(255) collate utf8_unicode_ci NOT NULL,
  `css` varchar(255) collate utf8_unicode_ci NOT NULL,
  `profileUser` smallint(2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;


INSERT INTO `modules` VALUES('home', 'Accueil', 'modules/HomeModule.swf', 'accueil.ccs', 4);
INSERT INTO `modules` VALUES('user', 'Utilisateurs', 'modules/UserModule.swf', 'utilisateur.ccs', 2);
INSERT INTO `modules` VALUES('session', 'Séances', 'modules/SessionModule.swf', 'session.ccs', 3);
INSERT INTO `modules` VALUES('tutorat', 'Salon synchrone', 'modules/TutoratModule.swf', 'tutorat.ccs', 4);
INSERT INTO `modules` VALUES('retrospection', 'Salon de rétrospection', 'modules/RetrospectionModule.swf', 'retrospection.ccs', 4);
INSERT INTO `modules` VALUES('bilan', 'Bilans', 'modules/BilanModule.swf', 'bilan.ccs', 4);
INSERT INTO `modules` VALUES('profil', 'Profil', 'modules/ProfilModule.swf', 'profil.ccs', 4);

-- --------------------------------------------------------

--
-- Structure de la table `obsels`
--

DROP TABLE IF EXISTS `obsels`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `obsels` (
  `id_obsel` int(11) NOT NULL auto_increment,
  `trace` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `type_obsel` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `begin_obsel` datetime default NULL,
  `rdf` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  PRIMARY KEY  (`id_obsel`)
) ENGINE=MyISAM AUTO_INCREMENT=96822 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

-- --------------------------------------------------------

--
-- Structure de la table `profile_descriptions`
--

DROP TABLE IF EXISTS `profile_descriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `profile_descriptions` (
  `profile` int(2) NOT NULL auto_increment,
  `short_description` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci  NOT NULL,
  `long_description` text CHARACTER SET utf8 COLLATE utf8_unicode_ci  NOT NULL,
  PRIMARY KEY  (`profile`)
) ENGINE=MyISAM AUTO_INCREMENT=1048577 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;


INSERT INTO `profile_descriptions` VALUES(503, 'tuteur', 'it user with droit .....');
INSERT INTO `profile_descriptions` VALUES(7, 'etudiant', 'user - etudiant');
INSERT INTO `profile_descriptions` VALUES(4599, 'responsable', 'user with manager status\n');
INSERT INTO `profile_descriptions` VALUES(70135, 'administrateur', 'administrator');
-- --------------------------------------------------------

--
-- Structure de la table `retro_document`
--

DROP TABLE IF EXISTS `retro_document`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `retro_document` (
  `id_retro_document` int(10) unsigned zerofill NOT NULL auto_increment,
  `id_owner` int(10) unsigned zerofill NOT NULL,
  `id_session` int(10) unsigned zerofill NOT NULL,
  `creation_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `last_modification_date` timestamp NOT NULL default '0000-00-00 00:00:00',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `xml` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  PRIMARY KEY  (`id_retro_document`),
  KEY `by_owner` (`id_owner`),
  KEY `by_owner_and_by_session` (`id_owner`,`id_session`)
) ENGINE=MyISAM AUTO_INCREMENT=163 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='The documents created in the retrospection room that contain';
SET character_set_client = @saved_cs_client;
-- --------------------------------------------------------

--
-- Structure de la table `retro_document_access`
--

DROP TABLE IF EXISTS `retro_document_access`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `retro_document_access` (
  `id_retro_document` int(10) unsigned zerofill NOT NULL,
  `id_user` int(10) unsigned zerofill NOT NULL COMMENT 'The id of the user who has a read access to the retrospection document',
  PRIMARY KEY  (`id_retro_document`,`id_user`),
  KEY `by_document` (`id_user`),
  KEY `by_user` (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='The users that have a read access on a retrospection documen';
SET character_set_client = @saved_cs_client;
-- --------------------------------------------------------

--
-- Structure de la table `roles`
--

DROP TABLE IF EXISTS `roles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sessions` (
  `id_session` int(11) NOT NULL auto_increment,
  `id_user` int(11) NOT NULL,
  `description` varchar(40) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `theme` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `date_session` datetime default '2000-01-01 00:00:00',
  `isModel` tinyint(1) default NULL,
  `start_recording` datetime NOT NULL default '2000-01-01 00:00:00',
  `status_session` tinyint(1) NOT NULL default '0',
  `id_currentActivity` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id_session`,`id_user`),
  UNIQUE KEY `IDX_sessions1` (`id_session`,`id_user`),
  UNIQUE KEY `IDX_sessions2` (`id_session`),
  KEY `IDX_sessions3` (`id_user`)
) ENGINE=MyISAM AUTO_INCREMENT=389 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;
-- --------------------------------------------------------
INSERT INTO `sessions` VALUES(1, 1, 'Les stéréotypes de la bourgeoisie', 'Les stéréotypes de la bourgeoisie', '2011-01-11 16:55:39', 1, '2010-12-29 12:59:06', 1, 0);
--
-- Structure de la table `session_users`
--

DROP TABLE IF EXISTS `session_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `session_users` (
  `id_session_user` int(11) NOT NULL auto_increment,
  `id_session` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `mask` int(20) default NULL,
  PRIMARY KEY  (`id_session_user`),
  UNIQUE KEY `IDX_users1` (`id_session_user`),
  KEY `id_session` (`id_session`,`id_user`),
  KEY `id_user` (`id_user`)
) ENGINE=MyISAM AUTO_INCREMENT=1402 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id_user` int(11) NOT NULL auto_increment,
  `firstname` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `lastname` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `mail` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `activation_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci default NULL,
  `profil` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `message` varchar(3000) CHARACTER SET utf8 COLLATE utf8_unicode_ci default 'Hello...',
  PRIMARY KEY  (`id_user`),
  UNIQUE KEY `IDX_users1` (`id_user`)
) ENGINE=MyISAM AUTO_INCREMENT=122 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Password for admin = azerty';
SET character_set_client = @saved_cs_client;

INSERT INTO `users` VALUES(1, 'Admin', 'ADMIN', 'admin', 'azerty', NULL, '/images/unknown.png', '00010001000111110111','Hello, ___' );

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


