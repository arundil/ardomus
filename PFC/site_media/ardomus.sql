-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 09-08-2011 a las 19:17:10
-- Versión del servidor: 5.5.8
-- Versión de PHP: 5.3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `ardomus`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_actuadores`
--

CREATE TABLE IF NOT EXISTS `ardomus_actuadores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identificador` varchar(50) NOT NULL,
  `tipo_id` int(11) NOT NULL,
  `mota_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_actuadores_27e4f492` (`tipo_id`),
  KEY `ardomus_actuadores_5c1fae95` (`mota_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Volcar la base de datos para la tabla `ardomus_actuadores`
--

INSERT INTO `ardomus_actuadores` (`id`, `identificador`, `tipo_id`, `mota_id`) VALUES
(1, '1', 1, 1),
(2, '2', 2, 1),
(3, '5', 1, 2),
(4, '6', 2, 2),
(5, '7', 3, 2),
(6, '10', 4, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_arduinoactuales`
--

CREATE TABLE IF NOT EXISTS `ardomus_arduinoactuales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zona_id` int(11) NOT NULL,
  `mota_id` int(11) NOT NULL,
  `luz` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_arduinoactuales_e797092` (`zona_id`),
  KEY `ardomus_arduinoactuales_5c1fae95` (`mota_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcar la base de datos para la tabla `ardomus_arduinoactuales`
--

INSERT INTO `ardomus_arduinoactuales` (`id`, `zona_id`, `mota_id`, `luz`) VALUES
(1, 1, 1, 0),
(2, 2, 2, 0),
(3, 3, 3, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_arduinos`
--

CREATE TABLE IF NOT EXISTS `ardomus_arduinos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zona_id` int(11) NOT NULL,
  `mota_id` int(11) NOT NULL,
  `luz` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_arduinos_e797092` (`zona_id`),
  KEY `ardomus_arduinos_5c1fae95` (`mota_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Volcar la base de datos para la tabla `ardomus_arduinos`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_mediciones`
--

CREATE TABLE IF NOT EXISTS `ardomus_mediciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zona_id` int(11) NOT NULL,
  `mota_id` int(11) NOT NULL,
  `hum` varchar(50) DEFAULT NULL,
  `temp` varchar(50) DEFAULT NULL,
  `lum` varchar(50) DEFAULT NULL,
  `date` varchar(50) NOT NULL,
  `time` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_mediciones_e797092` (`zona_id`),
  KEY `ardomus_mediciones_5c1fae95` (`mota_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Volcar la base de datos para la tabla `ardomus_mediciones`
--

INSERT INTO `ardomus_mediciones` (`id`, `zona_id`, `mota_id`, `hum`, `temp`, `lum`, `date`, `time`) VALUES
(3, 1, 1, '', '21', '', 'Hoy', 'Ahora'),
(4, 1, 1, '', '22', '', 'Hoy', 'Ahora'),
(5, 2, 2, '', '30', '', '1', '2');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_motas`
--

CREATE TABLE IF NOT EXISTS `ardomus_motas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `zona_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_motas_e797092` (`zona_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcar la base de datos para la tabla `ardomus_motas`
--

INSERT INTO `ardomus_motas` (`id`, `nombre`, `zona_id`) VALUES
(1, 'Luz/Temperatura Cocina', 1),
(2, 'Luz/Sonido/Temperatura CP', 2),
(3, 'Riego Jardin', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_sensores`
--

CREATE TABLE IF NOT EXISTS `ardomus_sensores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identificador` varchar(50) NOT NULL,
  `tipo_id` int(11) NOT NULL,
  `mota_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_sensores_27e4f492` (`tipo_id`),
  KEY `ardomus_sensores_5c1fae95` (`mota_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Volcar la base de datos para la tabla `ardomus_sensores`
--

INSERT INTO `ardomus_sensores` (`id`, `identificador`, `tipo_id`, `mota_id`) VALUES
(1, '3', 3, 1),
(2, '4', 4, 1),
(3, '8', 2, 2),
(4, '9', 4, 2),
(5, '11', 4, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_tipoactuadores`
--

CREATE TABLE IF NOT EXISTS `ardomus_tipoactuadores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcar la base de datos para la tabla `ardomus_tipoactuadores`
--

INSERT INTO `ardomus_tipoactuadores` (`id`, `nombre`) VALUES
(1, 'Luz'),
(2, 'Temperatura'),
(3, 'Sonido'),
(4, 'Riego Cesped');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_tiposensores`
--

CREATE TABLE IF NOT EXISTS `ardomus_tiposensores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcar la base de datos para la tabla `ardomus_tiposensores`
--

INSERT INTO `ardomus_tiposensores` (`id`, `nombre`) VALUES
(1, 'Luz'),
(2, 'Temperatura'),
(3, 'Humedad'),
(4, 'Movimiento');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_uc`
--

CREATE TABLE IF NOT EXISTS `ardomus_uc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identificador` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `ip` char(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcar la base de datos para la tabla `ardomus_uc`
--

INSERT INTO `ardomus_uc` (`id`, `identificador`, `password`, `ip`) VALUES
(1, '1', '1', '255.255.255.255');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_userzona`
--

CREATE TABLE IF NOT EXISTS `ardomus_userzona` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `zona_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_userzona_403f60f` (`user_id`),
  KEY `ardomus_userzona_e797092` (`zona_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcar la base de datos para la tabla `ardomus_userzona`
--

INSERT INTO `ardomus_userzona` (`id`, `user_id`, `zona_id`) VALUES
(1, 2, 1),
(2, 2, 2),
(3, 2, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_zonas`
--

CREATE TABLE IF NOT EXISTS `ardomus_zonas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `uc_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_zonas_1b6aeba2` (`uc_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcar la base de datos para la tabla `ardomus_zonas`
--

INSERT INTO `ardomus_zonas` (`id`, `nombre`, `uc_id`) VALUES
(1, 'Cocina', 1),
(2, 'Cuarto Padres', 1),
(3, 'Jardín', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group`
--

CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Volcar la base de datos para la tabla `auth_group`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_425ae3c4` (`group_id`),
  KEY `auth_group_permissions_1e014c8f` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Volcar la base de datos para la tabla `auth_group_permissions`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_message`
--

CREATE TABLE IF NOT EXISTS `auth_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `auth_message_403f60f` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Volcar la base de datos para la tabla `auth_message`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_permission`
--

CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_1bb8f392` (`content_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=58 ;

--
-- Volcar la base de datos para la tabla `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can add permission', 2, 'add_permission'),
(5, 'Can change permission', 2, 'change_permission'),
(6, 'Can delete permission', 2, 'delete_permission'),
(7, 'Can add group', 3, 'add_group'),
(8, 'Can change group', 3, 'change_group'),
(9, 'Can delete group', 3, 'delete_group'),
(10, 'Can add user', 4, 'add_user'),
(11, 'Can change user', 4, 'change_user'),
(12, 'Can delete user', 4, 'delete_user'),
(13, 'Can add message', 5, 'add_message'),
(14, 'Can change message', 5, 'change_message'),
(15, 'Can delete message', 5, 'delete_message'),
(16, 'Can add content type', 6, 'add_contenttype'),
(17, 'Can change content type', 6, 'change_contenttype'),
(18, 'Can delete content type', 6, 'delete_contenttype'),
(19, 'Can add session', 7, 'add_session'),
(20, 'Can change session', 7, 'change_session'),
(21, 'Can delete session', 7, 'delete_session'),
(22, 'Can add site', 8, 'add_site'),
(23, 'Can change site', 8, 'change_site'),
(24, 'Can delete site', 8, 'delete_site'),
(25, 'Can add uc', 9, 'add_uc'),
(26, 'Can change uc', 9, 'change_uc'),
(27, 'Can delete uc', 9, 'delete_uc'),
(28, 'Can add zonas', 10, 'add_zonas'),
(29, 'Can change zonas', 10, 'change_zonas'),
(30, 'Can delete zonas', 10, 'delete_zonas'),
(31, 'Can add motas', 11, 'add_motas'),
(32, 'Can change motas', 11, 'change_motas'),
(33, 'Can delete motas', 11, 'delete_motas'),
(34, 'Can add tipo actuadores', 12, 'add_tipoactuadores'),
(35, 'Can change tipo actuadores', 12, 'change_tipoactuadores'),
(36, 'Can delete tipo actuadores', 12, 'delete_tipoactuadores'),
(37, 'Can add tipo sensores', 13, 'add_tiposensores'),
(38, 'Can change tipo sensores', 13, 'change_tiposensores'),
(39, 'Can delete tipo sensores', 13, 'delete_tiposensores'),
(40, 'Can add actuadores', 14, 'add_actuadores'),
(41, 'Can change actuadores', 14, 'change_actuadores'),
(42, 'Can delete actuadores', 14, 'delete_actuadores'),
(43, 'Can add sensores', 15, 'add_sensores'),
(44, 'Can change sensores', 15, 'change_sensores'),
(45, 'Can delete sensores', 15, 'delete_sensores'),
(46, 'Can add user zona', 16, 'add_userzona'),
(47, 'Can change user zona', 16, 'change_userzona'),
(48, 'Can delete user zona', 16, 'delete_userzona'),
(49, 'Can add mediciones', 17, 'add_mediciones'),
(50, 'Can change mediciones', 17, 'change_mediciones'),
(51, 'Can delete mediciones', 17, 'delete_mediciones'),
(52, 'Can add arduinos', 18, 'add_arduinos'),
(53, 'Can change arduinos', 18, 'change_arduinos'),
(54, 'Can delete arduinos', 18, 'delete_arduinos'),
(55, 'Can add arduino actuales', 19, 'add_arduinoactuales'),
(56, 'Can change arduino actuales', 19, 'change_arduinoactuales'),
(57, 'Can delete arduino actuales', 19, 'delete_arduinoactuales');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user`
--

CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` varchar(128) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `last_login` datetime NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcar la base de datos para la tabla `auth_user`
--

INSERT INTO `auth_user` (`id`, `username`, `first_name`, `last_name`, `email`, `password`, `is_staff`, `is_active`, `is_superuser`, `last_login`, `date_joined`) VALUES
(1, 'lordreivaj', '', '', 'asfd@sagf.com', 'sha1$19350$e739d65dd190cc91049ba5cdcabc21a58204cd4d', 1, 1, 1, '2011-08-09 18:08:22', '2011-08-09 16:34:59'),
(2, 'Padre', '', '', '', 'sha1$b9f5f$a762c24aa5b7578793ac3d67f430a8640bdd6ff4', 1, 1, 0, '2011-08-09 18:09:01', '2011-08-09 16:36:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_groups`
--

CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_403f60f` (`user_id`),
  KEY `auth_user_groups_425ae3c4` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Volcar la base de datos para la tabla `auth_user_groups`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_user_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_403f60f` (`user_id`),
  KEY `auth_user_user_permissions_1e014c8f` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Volcar la base de datos para la tabla `auth_user_user_permissions`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_admin_log`
--

CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_403f60f` (`user_id`),
  KEY `django_admin_log_1bb8f392` (`content_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcar la base de datos para la tabla `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `user_id`, `content_type_id`, `object_id`, `object_repr`, `action_flag`, `change_message`) VALUES
(1, '2011-08-09 16:40:11', 1, 17, '3', 'Cocina, Luz/Temperatura Cocina', 1, ''),
(2, '2011-08-09 16:40:32', 1, 17, '4', 'Cocina, Luz/Temperatura Cocina', 1, ''),
(3, '2011-08-09 18:08:48', 1, 17, '5', 'Cuarto Padres, Luz/Sonido/Temperatura CP', 1, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_content_type`
--

CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

--
-- Volcar la base de datos para la tabla `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `name`, `app_label`, `model`) VALUES
(1, 'log entry', 'admin', 'logentry'),
(2, 'permission', 'auth', 'permission'),
(3, 'group', 'auth', 'group'),
(4, 'user', 'auth', 'user'),
(5, 'message', 'auth', 'message'),
(6, 'content type', 'contenttypes', 'contenttype'),
(7, 'session', 'sessions', 'session'),
(8, 'site', 'sites', 'site'),
(9, 'uc', 'ardomus', 'uc'),
(10, 'zonas', 'ardomus', 'zonas'),
(11, 'motas', 'ardomus', 'motas'),
(12, 'tipo actuadores', 'ardomus', 'tipoactuadores'),
(13, 'tipo sensores', 'ardomus', 'tiposensores'),
(14, 'actuadores', 'ardomus', 'actuadores'),
(15, 'sensores', 'ardomus', 'sensores'),
(16, 'user zona', 'ardomus', 'userzona'),
(17, 'mediciones', 'ardomus', 'mediciones'),
(18, 'arduinos', 'ardomus', 'arduinos'),
(19, 'arduino actuales', 'ardomus', 'arduinoactuales');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_session`
--

CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_3da3d3d8` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcar la base de datos para la tabla `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('ec0af90633c6a3c131d8b569037753b8', 'YzY5Mjc0NDBlODRjMmJhZmM0ODliODAzNDA2YTU3NjkzMDFmZjQwZTqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQJ1Lg==\n', '2011-08-23 18:09:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_site`
--

CREATE TABLE IF NOT EXISTS `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcar la base de datos para la tabla `django_site`
--

INSERT INTO `django_site` (`id`, `domain`, `name`) VALUES
(1, 'example.com', 'example.com');

--
-- Filtros para las tablas descargadas (dump)
--

--
-- Filtros para la tabla `ardomus_actuadores`
--
ALTER TABLE `ardomus_actuadores`
  ADD CONSTRAINT `tipo_id_refs_id_3871bd31` FOREIGN KEY (`tipo_id`) REFERENCES `ardomus_tipoactuadores` (`id`),
  ADD CONSTRAINT `mota_id_refs_id_5a2c985f` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`);

--
-- Filtros para la tabla `ardomus_arduinoactuales`
--
ALTER TABLE `ardomus_arduinoactuales`
  ADD CONSTRAINT `zona_id_refs_id_64dc60b2` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`),
  ADD CONSTRAINT `mota_id_refs_id_18881647` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`);

--
-- Filtros para la tabla `ardomus_arduinos`
--
ALTER TABLE `ardomus_arduinos`
  ADD CONSTRAINT `zona_id_refs_id_23af0344` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`),
  ADD CONSTRAINT `mota_id_refs_id_7a4c62fd` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`);

--
-- Filtros para la tabla `ardomus_mediciones`
--
ALTER TABLE `ardomus_mediciones`
  ADD CONSTRAINT `zona_id_refs_id_2cf53523` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`),
  ADD CONSTRAINT `mota_id_refs_id_79b399a2` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`);

--
-- Filtros para la tabla `ardomus_motas`
--
ALTER TABLE `ardomus_motas`
  ADD CONSTRAINT `zona_id_refs_id_1669f02e` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`);

--
-- Filtros para la tabla `ardomus_sensores`
--
ALTER TABLE `ardomus_sensores`
  ADD CONSTRAINT `tipo_id_refs_id_8f1812b` FOREIGN KEY (`tipo_id`) REFERENCES `ardomus_tiposensores` (`id`),
  ADD CONSTRAINT `mota_id_refs_id_7d7510ce` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`);

--
-- Filtros para la tabla `ardomus_userzona`
--
ALTER TABLE `ardomus_userzona`
  ADD CONSTRAINT `user_id_refs_id_6695ed47` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `zona_id_refs_id_147a0c04` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`);

--
-- Filtros para la tabla `ardomus_zonas`
--
ALTER TABLE `ardomus_zonas`
  ADD CONSTRAINT `uc_id_refs_id_10b769` FOREIGN KEY (`uc_id`) REFERENCES `ardomus_uc` (`id`);

--
-- Filtros para la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `group_id_refs_id_3cea63fe` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `permission_id_refs_id_5886d21f` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Filtros para la tabla `auth_message`
--
ALTER TABLE `auth_message`
  ADD CONSTRAINT `user_id_refs_id_650f49a6` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `content_type_id_refs_id_728de91f` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Filtros para la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `user_id_refs_id_7ceef80f` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `group_id_refs_id_f116770` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Filtros para la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `user_id_refs_id_dfbab7d` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `permission_id_refs_id_67e79cb` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Filtros para la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `content_type_id_refs_id_288599e6` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `user_id_refs_id_c8665aa` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
