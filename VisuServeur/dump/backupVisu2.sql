-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Mer 22 Septembre 2010 à 21:45
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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Contenu de la table `activities`
--

INSERT INTO `activities` VALUES(8, 3, 'ererererere', 1, 2);
INSERT INTO `activities` VALUES(7, 3, 'ereererereerer', 3, 4);
INSERT INTO `activities` VALUES(3, 2, 'Activity  3 , session 2', 35, 10);
INSERT INTO `activities` VALUES(4, 2, 'Activity 4', 35, 12);
INSERT INTO `activities` VALUES(9, 4, 'gfdx', NULL, NULL);
INSERT INTO `activities` VALUES(10, 4, 'qsfezrq', NULL, NULL);
INSERT INTO `activities` VALUES(11, 7, 'Entre les murs', 10, 0);
INSERT INTO `activities` VALUES(12, 7, 'Bienvenue chez les Ch?tis', 10, 1);
INSERT INTO `activities` VALUES(13, 7, 'Le printemps du cin?ma', 10, 2);
INSERT INTO `activities` VALUES(14, 7, 'Cartes d''identit?', 10, 3);
INSERT INTO `activities` VALUES(15, 6, 'Immigration choisie', 10, 0);
INSERT INTO `activities` VALUES(16, 6, '24 heures sans nous', 10, 1);
INSERT INTO `activities` VALUES(17, 6, 'Immigration clandestine', 10, 2);
INSERT INTO `activities` VALUES(18, 6, 'Aide aux r?fugi?s / ? Welcome ', 10, 3);

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
  PRIMARY KEY (`id_element`,`id_activity`),
  KEY `IDX_activities_elements1` (`id_activity`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=207 ;

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
INSERT INTO `activities_elements` VALUES(20, 11, 'Connais-tu ce film ? Entre les murs / The Class ? ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(21, 11, 'D''apr?s toi, comment est cette classe ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(22, 11, 'Est-ce que cela peut se rapprocher d''une certaine r?alit? am?ricaine ? Crois-tu qu''un film sur les probl?mes des jeunes ? l''?cole peut fonctionner aux USA ?; Est-ce que ?a vous int?resserait ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(23, 11, 'Est-ce que les films am?ricains sont proches de la r?alit? ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(24, 11, 'On voit souvent dans les films pour adolescents des clich?s comme les geeks, les intellos, les groupes populaires, etc. Est-ce le cas, dans la r?alit? ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(25, 11, 'Que pensez-vous du film Elephant (film qui raconte la tuerie du lyc?e de Columbine en 1999)', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(26, 11, 'adolescent', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(32, 11, 'groupes populaires', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(31, 11, 'bandes', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(33, 11, 'geek = accros aux jeux-vid?os', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(34, 11, 'intello', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(35, 11, 'clich?', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(36, 11, 'fiction', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(37, 11, 'image', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(38, 11, 'h?t?rog?n?it?', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(39, 11, 'classe mouvement?e', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(40, 11, 'violence scolaire', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(41, 11, 'Entre les murs', 'http://www.youtube.com/watch?v=sxEM40SIzws', 'document', NULL);
INSERT INTO `activities_elements` VALUES(42, 11, 'Entre les murs est une  fiction sur la mission impossible des enseignants ? l??cole, jou?e par de vrais ?l?ves, de vrais profs et de vrais parents d??l?ves. Il est adapt? du livre de Fran?ois Begaudeau qui met en exergue sa propre exp?rience de professeur et joue ici son propre r?le, face ? une trentaine d?adolescents issus des quartiers d?favoris?s. Le r?alisateur Laurent Cantet a obtenu en mai 2008 la Palme d''Or du 61e Festival de Cannes.\rQ.1. Vous posez d?abord la premi?re question, ensuite vous leur montrez cet extrait en donnant des explications si n?cessaire.\rQ.2. Evoque la tension qui r?gne dans la classe puis faire le rapprochement avec des films am?ricains comme Teen Movie ; Mean Girls ;  Freaky Friday ; American Pie ; 10 Things I Hate About you ; Precious, Save the Last Dance, Esprits Rebelles\rLien : El?phant : http://www.youtube.com/watch?v=k7W_0fjUqcM', 'http://www.youtube.com/watch?v=k7W_0fjUqcM', 'memo', NULL);
INSERT INTO `activities_elements` VALUES(43, 12, 'Connaissez-vous ce film ? ; (Si oui, pouvez-vous m''en raconter l''histoire ?)', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(44, 12, 'Qui sont les personnages ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(45, 12, 'Comment se passe la rencontre entre les deux personnages ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(46, 12, 'Y-a-t-il un probl?me entre les deux personnages ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(47, 12, 'Will Smith produirait actuellement un remake de ce film aux USA intitul? Welcome to the Sticks.', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(48, 12, 'Pensez-vous que ce remake pourrait avoir du succ?s aux USA ? Pourquoi ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(49, 12, 'Imaginez ce remake', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(55, 12, 'Quel choc culturel ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(50, 12, 'Qui seraient les acteurs ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(51, 12, 'Quels personnages joueraient-ils ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(54, 12, 'Quel choc culturel ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(52, 12, 'Imaginez la rencontre entre les deux personnages que vous venez d?inventer. Par exemple, une personne est l?homme d?affaires/la femme d?affaires et l?autre personne est la/le Texan(e). Vous vous rencontrez et vous vous posez des questions, notamment ? Comment vous vous appelez ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(53, 12, 'Que venez-vous faire dans le Texas ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(56, 12, 'Pourquoi vous restez au Texas ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(57, 12, 'ch?ti(s)', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(58, 12, 'parler ch?ti', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(59, 12, 'choc des cultures', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(60, 12, 'r?gion', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(61, 12, 'le Sud', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(62, 12, 'le Nord', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(63, 12, '?tre mut? = changer de lieu de travail', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(64, 12, 'le 59 = d?partement du Nord', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(65, 12, 'le 13 = d?partement des  Bouches-du-Rh?ne', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(66, 12, 'GPS', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(67, 12, 'directeur', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(68, 12, 'carrette = voiture', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(69, 12, 'accident', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(70, 12, 'plaque', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(71, 12, 'quo = quoi', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(72, 12, 'La Poste = US  Postal Service', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(73, 12, 'Bienvenue chez les Ch?tis', 'http://www.youtube.com/watch?v=qDxOSV9Qahw&feature=related', 'document', NULL);
INSERT INTO `activities_elements` VALUES(74, 13, 'Regardez la premi?re vid?o (2010)', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(75, 13, 'Qu''annonce ce document?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(76, 13, 'Quels sont les acteurs/actrices/films que tu reconnais?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(77, 13, 'Un tel ?v?nement a-t-il d?j? eu lieu aux Etats-Unis?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(78, 13, 'Regarde la deuxi?me vid?o (2009). Quels sont les genres de films que tu reconnais? Quelles diff?rences, quelles similitudes peux-tu relever entre les deux bandes annonces?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(79, 13, 'Regarde la troisi?me, et la derni?re, bande annonce 2008). Sous quelle forme est repr?sent? l''?v?nement? Peux-tu raconter ? nouveau l''histoire?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(80, 13, 'Pourquoi, ? ton avis, ce genre d''?v?nement a-t-il lieu?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(81, 13, 'Pendant trois jours, les places seront partout au tarif unique de 3,50 euros, mais en dehors de ces jours, une place co?te environ 9 euros. Ce prix te semble-t-il abordable ?', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(82, 13, 'Fais la comparaison avec  le prix d?un ticket cin?ma aux USA.', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(83, 12, 'Il s''agit du second film r?alis? par Dany Boon.\nIl s''agit du second plus gros succ?s commercial de tous les temps en France (environ 20 millions d''entr?es pour une population d''environ 65 millions)\nQ1 : Il s''agit d''une question pour s''assurer si la personne conna?t ou non le film, rien de plus. Si la personne conna?t le film, la Q2 n''est pas essentielle.\nQ2 : Choisissez la bande-annonce ou l''affiche. Cet extrait permet d''introduire bri?vement l''histoire et l''id?e essentielle du film que l''on d?veloppera dans la Q3 (le choc culturel et linguistique d''un directeur de La Poste, venant du Sud, mut? dans le Nord o? les habitant parlent ch''ti.)\nQ3 : Le remake raconterait l''histoire d''un homme d''affaires new-yorkais (jou? par le comique am?ricain, Steve Carell) qui atterrit dans le Texas. Choc culturel entre le Nord-est (New-York) et le Sud-ouest (le Texas). \n*Voici quelques films (am?ricains ou non) qui parlent de choc des cultures : Avatar (Population imaginaire / USA), Borat (Kazakhstan / USA) ; Amerikka (Palestine / USA), Sweet Home Alabama (Manhattan / Alabama), etc.\nQ4 : l''objectif grammatical du cours est de faire poser des questions par les apprenants. La cr?ation d''un dialogue o? les personnages, qu''ils viennent juste de cr?er (Cf. Q3), se rencontrent, les poussera ? se poser des questions. Par exemple, des questions portant sur les raisons de son d?part de sa ville d''origine, sa famille, etc.\nOn peut donner comme contrainte de cr?er un dialogue en ins?rant 5 questions ? poser par chaque personnage.', '', 'memo', NULL);
INSERT INTO `activities_elements` VALUES(84, 13, 'acteur/actrice', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(85, 13, 'bande-annonce', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(86, 13, 'Leonardo Di Caprio', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(87, 13, 'com?die musicale', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(88, 13, 'dessin-anim?', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(89, 13, 'film d''animation', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(90, 13, 'film historique', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(91, 13, 'Kung fu panda', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(92, 13, 'la panth?re rose', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(93, 13, 'Western', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(94, 13, 'Bienvenue chez les chtis', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(95, 13, 'Batman', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(96, 13, 'James Bond', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(97, 13, 'extraits de films', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(98, 13, 'fabriquer une histoire', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(99, 13, 'Jouer des r?les', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(100, 13, 'satire', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(101, 13, 'humour', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(102, 13, 'Le printemps du cin?ma 2010, du 21 au 23 mars 2010, onzi?me ?dition. Le principe : pendant trois jours et dans toutes les salles de cin?ma, les places seront au tarif unique de 3,50 euros. \rChoisissez l?une des vid?os propos?es.', '', 'memo', NULL);
INSERT INTO `activities_elements` VALUES(103, 13, 'Le printemps du cin?ma 2009', 'http://www.youtube.com/watch?v=cy-9-fn9yL8', 'document', NULL);
INSERT INTO `activities_elements` VALUES(104, 13, 'Le printemps du cin?ma 2008', 'http://www.youtube.com/watch?v=SIXcXLBBSgM', 'document', NULL);
INSERT INTO `activities_elements` VALUES(105, 13, 'Le printemps du cin?ma 2010', 'http://www.youtube.com/watch?v=tc4L5bzRE5A', 'document', NULL);
INSERT INTO `activities_elements` VALUES(106, 14, 'Voici un tableau avec les go?ts et occupations de six personnes', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(114, 14, 'Chacune d''entre vous va ?tre l''une de ces personnes', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(113, 14, 'Vous avez d?cid? d?aller au cin?ma ensemble', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(112, 14, 'mettez vous d''accord sur un film', '', 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(111, 14, 'cin?ma d''auteur', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(115, 14, 'films de filles', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(116, 14, 'films ? l''eau de rose', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(117, 14, 'films d''?poque', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(118, 14, 'mordu= passionn?', '', 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(119, 14, 'Donner des exemples aux ?tudiantes pour clarifier la situation de d?part. Par exemple X fera les personnages de la colonne de gauche et Y ceux de la colonne de droite. Encourager la discussion et l''argumentation entre les ?tudiantes. Dans cette activit?, le tuteur n''intervient que pour relancer la conversation, aider avec du vocabulaire et/ou des structures qui peuvent faire d?faut aux ?tudiantes.\nPersonnages 1 et 2 :\n1) Laura, 26 ans danseuse ? l''Op?ra Elle adore la musique classique et le cin?ma d''auteur. Passionn?e d''art contemporain, elle d?teste la violence\n2) Jean, 28 ans, boxeur professionnel. \nIl n''aime pas les films ? l''eau de rose, son loisir pr?f?r? est la chasse. Il aime beaucoup les films d''horreur ;\nPersonnages 3 et 4 :\n3) Guillaume, 35 ans fleuriste ? son compte. Il aime lire, les longues balades dans la nature et est mordu de biologie. Il aime les documentaires et la science fiction\n4) Anne, 24 ans, professeur de sport au lyc?e. Elle aime les activit?s en plein air. Ne va pas souvent au cin? et d?teste les films de fictions ;\n\nPersonnages 5 et 6 :\n5) Lucie, 23 ans. Laborantine (travaille dans un laboratoire). Elle aime les jeux vid?o et son film pr?f?r? est Star Wars. Elle passe ses weekends chez elle ? lire, jouer et regarder des films\n6) Hubert-Antoine, 27 ans ?tudiant en histoire des civilisations. Il adore les films de cowboys, les films d''?poque. Son film pr?f?r? est Autant en emporte le vent m?me s''il dit ? ses amis que c''est Lawrence d''Arabie.', '', 'memo', NULL);
INSERT INTO `activities_elements` VALUES(121, 15, 'Avez-vous d?j? entendu parler de l?immigration choisie ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(122, 15, 'Observez ce dessin', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(123, 15, 'Pensez-vous qu?il illustre bien le concept d?immigration choisie ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(124, 15, 'Pourquoi les sportifs auraient-ils plus de chance que d?autres d??tre naturalis?s?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(125, 15, 'La situation est-elle la m?me aux Etats-Unis?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(126, 15, 'Qu''en pensez-vous?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(127, 15, 'Imaginez le dialogue que pourraient avoir deux candidats ? l''immigration : un sportif de haut niveau et un docteur en chirurgie. Expliquez, chacun de votre c?t?, pourquoi vous voulez venir en France.', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(128, 15, 'Opposez vos arguments, chacun voulant obtenir la naturalisation pour pouvoir vivre et travailler en France.', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(129, 15, 'dipl?mes', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(130, 15, 'football', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(131, 15, 'sportifs', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(132, 15, '? cerveaux ', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(133, 15, 'immigration choisie', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(134, 15, 'naturalisation', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(135, 15, 'nationalit?', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(136, 15, 'papiers', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(137, 15, 'sans-papiers', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(138, 15, '? A l''exclusion des sportifs et artistes, un candidat sans exp?rience professionnelle dont le niveau de dipl?me serait inf?rieur au niveau licence (Bac + 3) n''est pas ?ligible ? Juillet 2006, Nicolas Sarkozy, alors ministre de l''Int?rieur.\nLe sport ? haut niveau est un r?el acc?l?rateur pour les sportifs qui souhaitent changer de nationalit?. Cependant, il y a une condition d?terminante : faire partie de l''?lite et ainsi remplir la condition suivante : celle de pouvoir contribuer au rayonnement culturel et sportif de la France. C''est le cas de Vencelas Dabaya qui est champion d''halt?rophilie et qui a ?t? naturalis? juste 2 ans avant les mondiaux 2006. \n\nPour les questions : Sugg?rer ces quelques expressions aux ?tudiants pour qu''ils utilisent le subjonctif (ou l''indicatif) dans ler dialogue: ? Il faut \nque...Je ne suis pas s?r(e) que...Il vaut mieux que... Je pense que... ?\n\n\nPour le dialogue : chaque ?tudiant endosse un r?le: l''?tudiant A est le sportif de haut niveau et l''?tudiant B est le ? cerveau ?. Chacun doit apporter ses arguments : pourquoi la naturalisation de l''un serait plus l?gitime que celle de l''autre.\nSinon : l''?tudiant A prend le r?le d''un candidat ? l''immigration mexicain, l''?tudiant B celui d''un basketteur chinois.', NULL, 'memo', NULL);
INSERT INTO `activities_elements` VALUES(139, 15, 'Dessin humoristique', 'http://www.yawatani.com/images/stories/Immigration.jpg', 'document', NULL);
INSERT INTO `activities_elements` VALUES(140, 16, 'Observez cette affiche ou cette vid?o ', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(141, 16, 'Qu''annoncent elles?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(142, 16, 'A votre avis, en quoi cet ?v?nement consiste-t-il', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(143, 16, ' Savez-vous si une telle journ?e a d?j? ?t? organis?e aux Etats-Unis?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(144, 16, 'Qu''en pensez-vous? Trouvez-vous cela efficace?; Pourquoi ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(145, 16, 'Sinon, que pourrait-on selon vous imaginer pour donner une certaine reconnaissance aux immigr?s fran?ais? Am?ricains?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(146, 16, 'Comprenez-vous la r?action des immigr?s?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(147, 16, 'rassemblement', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(148, 16, 'associations', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(149, 16, 'fonction publique', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(150, 16, 'citoyennet?', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(151, 16, 'non-activit?', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(152, 16, 'reconnaissance', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(153, 16, 'immigr?s de la seconde g?n?ration', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(154, 16, 'boycotter', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(155, 16, 'stigmatiser', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(156, 16, 'd?rapages', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(157, 16, 'marquer de n?gatif', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(158, 16, 'changement incontr?l?', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(159, 16, '? 24 HEURES SANS NOUS ?\nLe 1er mars 2010 a eu lieu en France la ? Journ?e sans immigr?s ? : appel ? une journ?e de non-activit? ?conomique dans les entreprises, dans les associations, dans la fonction publique, dans les ?coles et les lyc?es? pour la reconnaissance de la valeur sociale, citoyenne et ?conomique de tous les immigr?s qui constituent la nation fran?aise.\nCe jour-l?, les immigr?s sont appel?s ? ne pas participer ? la vie ?conomique du pays. \nUne action similaire, ??A day without an immigrant??, a eu lieu, le 1er mai 2006, aux ?tats-Unis sous l''administration Bush, apr?s l''annonce d''un projet de loi pr?voyant que ?toute personne r?sidant ill?galement aux ?tats-Unis sera consid?r?e comme criminelle, ainsi que toute personne h?bergeant ou employant un immigr? clandestin?.', NULL, 'memo', NULL);
INSERT INTO `activities_elements` VALUES(160, 16, 'Affiche journ?e sans immigr?s', 'http://www.assfam.org/IMG/jpg/logoHD_LJSI_24hrSN_copie.jpg', 'document', NULL);
INSERT INTO `activities_elements` VALUES(161, 16, 'Vid?o journ?e sans immigr?s', 'http://www.youtube.com/watch?v=YDI07N21ask', 'document', NULL);
INSERT INTO `activities_elements` VALUES(162, 17, 'Observez cette photo.', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(163, 17, 'Qui sont ces gens?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(164, 17, 'D''apr?s vous, d''o? viennent-ils? O? vont-ils?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(165, 17, 'Qu''attendent-ils du pays de destination?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(166, 17, 'Qu''est-ce qui pousse ces migrants ? s''exiler?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(167, 17, 'Imaginez que vous ?tes ? leur place : seriez-vous pr?ts ? tenter cette aventure?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(168, 17, 'Les Etats-Unis connaissent-ils de tels flux de migration clandestine?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(169, 17, 'La migration est-elle aussi p?rilleuse pour les personnes qui essaient d''entrer ill?galement sur le territoire am?ricain?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(170, 17, 'Quel regard portes-tu sur les immigr?s clandestins ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(171, 17, 'Voil? une chanson qui illustre le sujet et la photo, vous pourrez l''?couter apr?s le cours.', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(172, 17, 'clandestin/clandestinit?', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(181, 17, 's''exiler', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(182, 17, 'Extrait de paroles de la chanson ? Tu verras en France ? de Stanislas (2010) :\n Ils leur ont dit, ils y ont cru \nQu''c''est ? Paris, qu''ils sont bien venus \nPrix du voyage, pr?teur sur gage \nPrix du voyage, pr?teur sur gage\n\nSix ? l''arri?re, quatre ? l''avant \nLe manque d''air, l''air en vivant \nA la fronti?re, ils prennent dix ans \nA la fronti?re, ils prennent dix ans\n\nLien Deezer pour ?couter la chanson : ? copier?coller dans le chat http://www.deezer.com/fr/music/home#music/result/all/tu%20verras%20en%20france\net c''est la premi?re chanson.', NULL, 'memo', NULL);
INSERT INTO `activities_elements` VALUES(183, 17, 'Photo d''immigr?s clandestins', 'http://www.attariq.org/local/cache-vignettes/L440xH330/lampedusa-d545a.jpg', 'document', NULL);
INSERT INTO `activities_elements` VALUES(174, 17, 'risque', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(179, 17, 'oser', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(176, 17, 'aventure', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(180, 17, 'migrant/migration', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(184, 18, 'Regardez une minute de la vid?o suivante; Qu''avez-vous compris?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(185, 18, 'La bande-annonce vous donne-t-elle envie d''aller voir le film?; Pourquoi?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(186, 18, 'Comprenez-vous que l?Etat arr?te les gens qui aident les clandestins?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(187, 18, 'Seriez-vous pr?t ? h?berger quelqu?un chez vous ?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(188, 18, 'D?apr?s vous, comment cette situation arrive?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(189, 18, 'Quelle serait votre position?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(190, 18, 'Seriez-vous pr?t ? ?tre dans l''ill?galit? pour aider un inconnu? Quelqu''un de votre entourage?', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(191, 18, 'Comparez avec la situation ? la fronti?re mexicano-am?ricaine. Avez-vous, dans votre famille ou votre entourage, une histoire li?e ? l?immigration ?; Racontez-nous.', NULL, 'consigne', NULL);
INSERT INTO `activities_elements` VALUES(192, 18, 'clandestin', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(193, 18, 'passeurs', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(194, 18, 'mis?re ?conomique/sociale', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(195, 18, 'solidarit?', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(196, 18, 'la Manche', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(197, 18, 'h?berger', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(198, 18, 'd?noncer', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(199, 18, 'ill?gal', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(200, 18, 'ma?tre nageur', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(201, 18, 'risquer', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(202, 18, 'traverser', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(203, 18, 'r?fugi?', NULL, 'keyword', NULL);
INSERT INTO `activities_elements` VALUES(206, 18, 'Bande-annonce du film ? Welcome ', 'http://www.youtube.com/watch?v=NoRqzMGBU4U', 'document', NULL);
INSERT INTO `activities_elements` VALUES(205, 18, 'Film (drame) fran?ais r?alis? par Philippe Lioret. Date de sortie cin?ma : 11 mars 2009. Avec Vincent Lindon, Firat Ayverdi, Audrey Dana.\nSynopsis : Pour impressionner et reconqu?rir sa femme, Simon, ma?tre nageur ? la piscine de Calais, prend le risque d''aider en secret un jeune r?fugi? kurde qui veut traverser la Manche ? la nage pour rejoindre l''Angleterre o? se trouve sa petite amie.\nOn peut faire le lien avec ? Frozen River ? ?', NULL, 'memo', NULL);

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

--
-- Contenu de la table `modules`
--

INSERT INTO `modules` VALUES('home', 'Accueil', 'modules/HomeModule.swf', 'accueil.ccs', 4);
INSERT INTO `modules` VALUES('user', 'Utilisateurs', 'modules/UserModule.swf', 'utilisateur.ccs', 2);
INSERT INTO `modules` VALUES('session', 'S', 'modules/SessionModule.swf', 'session.ccs', 3);
INSERT INTO `modules` VALUES('tutorat', 'Salon synchrone', 'modules/TutoratModule.swf', 'tutorat.ccs', 4);
INSERT INTO `modules` VALUES('retrospection', 'Salon de r', 'modules/RetrospectionModule.swf', 'retrospection.ccs', 4);

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1799 ;

--
-- Contenu de la table `obsels`
--

INSERT INTO `obsels` VALUES(1798, '<trace-20100922163607-3>', 'Disconnected', '2010-09-22 16:47:15', '@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .\n@prefix ktbs: <http://liris.cnrs.fr/silex/2009/ktbs/> .\n@prefix : <../visu/> .\n\n. a :Disconnected;\nktbs:hasTrace <trace-20100922163607-3>;\nktbs:hasBegin 1285166835242;\nktbs:hasEnd 1285166835242;\nktbs:hasSubject "3";\n.\n');

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

--
-- Contenu de la table `profile_descriptions`
--

INSERT INTO `profile_descriptions` VALUES(503, 'tuteur', 'it user with droit .....');
INSERT INTO `profile_descriptions` VALUES(7, 'etudiant', 'user - etudiant');
INSERT INTO `profile_descriptions` VALUES(4599, 'responsable', 'user with manager status\n');
INSERT INTO `profile_descriptions` VALUES(70135, 'administrateur', 'administrator');

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

--
-- Contenu de la table `roles`
--


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
  `status_session` tinyint(1) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id_session`,`id_user`),
  UNIQUE KEY `IDX_sessions1` (`id_session`,`id_user`),
  UNIQUE KEY `IDX_sessions2` (`id_session`),
  KEY `IDX_sessions3` (`id_user`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Contenu de la table `sessions`
--

INSERT INTO `sessions` VALUES(1, 1, 'Les identit?s (nationales)', 'Les identit?s nationales theme 1', '2010-01-01 11:15:00', 0, '2010-09-22 10:10:55', 0);
INSERT INTO `sessions` VALUES(2, 1, 'Les sports', 'Le metier PC', '2010-02-02 12:23:00', 0, '2010-09-21 18:40:33', 0);
INSERT INTO `sessions` VALUES(3, 4, 'sdsdsdsds', 'NASA', '2010-03-21 13:20:00', 0, '2010-09-22 16:14:39', 0);
INSERT INTO `sessions` VALUES(4, 4, 'sdsdsdsds', 'SALUT', '2010-04-21 14:00:00', 0, '2010-09-22 16:06:52', 0);
INSERT INTO `sessions` VALUES(5, 4, 'sdsdsdsds', 'MONSTER TRACK', '2010-09-20 15:50:00', 0, '2010-09-22 15:46:51', 0);
INSERT INTO `sessions` VALUES(6, 4, 'Description de la s?ance', 'Identit? Nationale et Immigration', '2010-09-20 16:55:00', 0, '2010-09-22 15:44:45', 0);
INSERT INTO `sessions` VALUES(7, 4, 'Description de la s?ance', 'Le cin?ma', '2010-12-15 17:00:00', 0, '2010-09-22 16:36:07', 0);

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=667 ;

--
-- Contenu de la table `session_users`
--

INSERT INTO `session_users` VALUES(527, 1, 7, 0);
INSERT INTO `session_users` VALUES(634, 1, 5, 0);
INSERT INTO `session_users` VALUES(630, 1, 1, 0);
INSERT INTO `session_users` VALUES(650, 7, 7, 0);
INSERT INTO `session_users` VALUES(651, 5, 7, 0);
INSERT INTO `session_users` VALUES(644, 2, 7, 0);
INSERT INTO `session_users` VALUES(628, 2, 1, 0);
INSERT INTO `session_users` VALUES(664, 3, 5, 0);
INSERT INTO `session_users` VALUES(665, 3, 3, 0);
INSERT INTO `session_users` VALUES(603, 3, 10, 0);
INSERT INTO `session_users` VALUES(663, 4, 3, 0);
INSERT INTO `session_users` VALUES(604, 4, 10, 0);
INSERT INTO `session_users` VALUES(660, 6, 1, 0);
INSERT INTO `session_users` VALUES(596, 4, 7, 0);
INSERT INTO `session_users` VALUES(662, 5, 5, 0);
INSERT INTO `session_users` VALUES(661, 6, 5, 0);
INSERT INTO `session_users` VALUES(658, 6, 7, 0);
INSERT INTO `session_users` VALUES(636, 7, 1, 0);
INSERT INTO `session_users` VALUES(652, 5, 10, 0);
INSERT INTO `session_users` VALUES(647, 7, 5, 0);
INSERT INTO `session_users` VALUES(666, 7, 3, 0);
INSERT INTO `session_users` VALUES(566, 4, 1, 0);

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
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `IDX_users1` (`id_user`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=15 ;

--
-- Contenu de la table `users`
--

INSERT INTO `users` VALUES(9, 'Caroline(9)', 'PUSKIN', '9', 'c', 'iYBFtFjJav5g2HUCSlbDfkoyyqvGu9Jl', NULL, 'https://lh5.googleusercontent.com/_1ZVBfqNsv9Y/SxOx8-WistI/AAAAAAAABU4/vnjK5_RpN_U/s104-c/CIMG4149.JPG', '00000000000000000111');
INSERT INTO `users` VALUES(7, 'Serguei(7)', 'BERIA', '7', 's', NULL, NULL, 'https://lh4.googleusercontent.com/_Um9A48A3vEc/TCR2VKpjWYI/AAAAAAAAABY/jus3oDYwq-I/s104-c/Photo%20du%2040908606-06-%20%C3%A0%2011.21.jpg', '00010001000111110111');
INSERT INTO `users` VALUES(3, 'Mireille(3)', 'Boris', '3', 'm', NULL, NULL, 'https://lh5.googleusercontent.com/_vY7gOxMIp68/SxjkqpqqfhI/AAAAAAAAAAU/5LNPnJmhmzA/s104-c/Mireille_nice09.png', '00000000000111110111');
INSERT INTO `users` VALUES(5, 'Pierre-Antoine(5)', 'SPILBERG', '5', 'p', NULL, NULL, 'https://www.google.com/s2/photos/public/AIbEiAIAAABDCPPq7NXY69HMNiILdmNhcmRfcGhvdG8qKGViMmMzNDgzOGUzMTE2Yzc2YjcwNjJkZTY3NTI4NzhjNTE3NjI5MWIwARzPKIpRk68U1QG17Wm3slYDPcid', '00000000000000000111');
INSERT INTO `users` VALUES(10, 'Julien(10)', 'zerin', '10', 'j', NULL, NULL, 'https://lh5.googleusercontent.com/_-55IClUE5xs/SyEEtWRy7jI/AAAAAAAAAAU/wNus2BsA-2k/s104-c/Julien50Carre.jpg', '00000000000111110111');
INSERT INTO `users` VALUES(1, 'Nicolas(1)', 'odin', '1', 'n', NULL, NULL, 'https://lh5.googleusercontent.com/_sWPdVPqWc7Y/Sy5v8f7VfRI/AAAAAAAAABE/jFf1mDOa3ko/s104-c/NCinVCV.JPG', '00010001000111110111');
INSERT INTO `users` VALUES(2, 'Yannick(2)', '', '2', 'y', NULL, NULL, 'https://www.google.com/s2/photos/public/AIbEiAIAAABDCPWu6cWirJutOCILdmNhcmRfcGhvdG8qKDY1ZGY3NjQ3NmE1NzQ3YjUxMGQ0MzdjNmVlNzVmOWE2MzZkMGRkNGMwAdy7DbpsitHUcsHbxWFVEw18gOu-', '00000000000000000111');
INSERT INTO `users` VALUES(4, 'Olivier(4)', '', '4', 'o', NULL, NULL, 'https://www.google.com/s2/photos/public/AIbEiAIAAABDCIH5gcm-xq2HeiILdmNhcmRfcGhvdG8qKDg0ZTA5ZWE3MTEyODY0Y2NlNDIzMTcxNGViNzZhMTA1YjVhYWJlNTcwASX_iNj7ymDHyzNAEKDfn_3D3xtb', '00000000000000000111');
INSERT INTO `users` VALUES(6, 'Lionel(6)', '', '6', 'l', NULL, NULL, 'https://lh3.googleusercontent.com/_r4tG6k7JBcg/S0H_ok3HOSI/AAAAAAAACH8/U3Un09ysGqw/s104-c/avatar-2.jpg', '00000001000111110111');
