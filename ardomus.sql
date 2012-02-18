-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 22-08-2011 a las 11:28:20
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
(1, 'Luz techo', 1, 1),
(2, 'Aire Acond ', 2, 1),
(3, 'Persiana de la terraza', 3, 1),
(4, 'luz lampara mesa', 1, 2),
(5, 'consola aire acond 2', 2, 2),
(6, 'riego', 4, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_ahorroenergetico`
--

CREATE TABLE IF NOT EXISTS `ardomus_ahorroenergetico` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activado` int(11) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `luzh` int(11) NOT NULL,
  `luzl` int(11) NOT NULL,
  `temperaturah` int(11) NOT NULL,
  `temperatural` int(11) NOT NULL,
  `humedadh` int(11) NOT NULL,
  `humedadl` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Volcar la base de datos para la tabla `ardomus_ahorroenergetico`
--

INSERT INTO `ardomus_ahorroenergetico` (`id`, `activado`, `descripcion`, `luzh`, `luzl`, `temperaturah`, `temperatural`, `humedadh`, `humedadl`) VALUES
(1, 0, 'DEFAULT', 50, 20, 28, 24, 75, 30),
(6, 1, 'NO NAME', 50, 20, 20, 15, 75, 30);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_alarmas`
--

CREATE TABLE IF NOT EXISTS `ardomus_alarmas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `medicion_id` int(11) NOT NULL,
  `idmotivo` int(11) NOT NULL,
  `motivo` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_alarmas_6f1b7588` (`medicion_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Volcar la base de datos para la tabla `ardomus_alarmas`
--

INSERT INTO `ardomus_alarmas` (`id`, `medicion_id`, `idmotivo`, `motivo`) VALUES
(1, 631, 3, 'Incoherencia con el Sensor de Humedad. Sensor de humedad desactivado\n'),
(2, 632, 3, 'Incoherencia con el Sensor de Humedad. Sensor de humedad desactivado\n'),
(3, 633, 3, 'Incoherencia con el Sensor de Humedad. Sensor de humedad desactivado\n'),
(4, 634, 3, 'Incoherencia con el Sensor de Humedad. Sensor de humedad desactivado\n'),
(5, 635, 3, 'Incoherencia con el Sensor de Humedad. Sensor de humedad desactivado\n'),
(6, 636, 3, 'Incoherencia con el Sensor de Humedad. Sensor de humedad desactivado\n'),
(7, 637, 3, 'Incoherencia con el Sensor de Humedad. Sensor de humedad desactivado\n'),
(8, 638, 3, 'Incoherencia con el Sensor de Humedad. Sensor de humedad desactivado\n');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_arduinoactuales`
--

CREATE TABLE IF NOT EXISTS `ardomus_arduinoactuales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zona_id` int(11) NOT NULL,
  `mota_id` int(11) NOT NULL,
  `luz` int(11) NOT NULL,
  `ac` int(11) NOT NULL,
  `persianas` int(11) NOT NULL,
  `riego` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_arduinoactuales_e797092` (`zona_id`),
  KEY `ardomus_arduinoactuales_5c1fae95` (`mota_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcar la base de datos para la tabla `ardomus_arduinoactuales`
--

INSERT INTO `ardomus_arduinoactuales` (`id`, `zona_id`, `mota_id`, `luz`, `ac`, `persianas`, `riego`) VALUES
(1, 1, 1, 0, 1, 0, -1),
(2, 1, 2, 0, 0, -1, -1),
(3, 2, 3, -1, -1, -1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_arduinos`
--

CREATE TABLE IF NOT EXISTS `ardomus_arduinos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zona_id` int(11) NOT NULL,
  `mota_id` int(11) NOT NULL,
  `luz` int(11) NOT NULL,
  `ac` int(11) NOT NULL,
  `persianas` int(11) NOT NULL,
  `riego` int(11) NOT NULL,
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
  `movimiento` varchar(50) DEFAULT NULL,
  `date` varchar(50) NOT NULL,
  `time` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_mediciones_e797092` (`zona_id`),
  KEY `ardomus_mediciones_5c1fae95` (`mota_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=690 ;

--
-- Volcar la base de datos para la tabla `ardomus_mediciones`
--

INSERT INTO `ardomus_mediciones` (`id`, `zona_id`, `mota_id`, `hum`, `temp`, `lum`, `movimiento`, `date`, `time`) VALUES
(397, 1, 1, '255.255', '24.30', '92', '00', '2011-08-20', '19:49:28'),
(398, 1, 1, '255.255', '24.30', '92', '00', '2011-08-20', '19:50:09'),
(399, 1, 1, '255.255', '24.30', '93', '00', '2011-08-20', '19:50:49'),
(400, 1, 1, '255.255', '24.58', '87', '00', '2011-08-20', '19:51:30'),
(401, 1, 1, '255.255', '24.30', '92', '00', '2011-08-20', '19:52:24'),
(402, 1, 1, '255.255', '24.03', '93', '00', '2011-08-20', '19:53:17'),
(403, 1, 1, '255.255', '24.03', '96', '00', '2011-08-20', '19:54:23'),
(404, 1, 1, '255.255', '24.03', '94', '00', '2011-08-20', '19:55:04'),
(405, 1, 1, '255.255', '24.03', '92', '00', '2011-08-20', '19:55:45'),
(406, 1, 1, '255.255', '24.03', '93', '00', '2011-08-20', '19:56:26'),
(407, 1, 1, '255.255', '24.03', '88', '00', '2011-08-20', '19:57:06'),
(408, 1, 1, '255.255', '24.03', '91', '00', '2011-08-20', '19:57:47'),
(409, 1, 1, '255.255', '24.03', '87', '00', '2011-08-20', '19:58:28'),
(410, 1, 1, '255.255', '23.76', '91', '00', '2011-08-20', '20:03:07'),
(411, 1, 1, '255.255', '23.76', '90', '00', '2011-08-20', '20:03:47'),
(412, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:04:53'),
(413, 1, 1, '255.255', '23.49', '95', '00', '2011-08-20', '20:05:47'),
(414, 1, 1, '255.255', '23.76', '93', '00', '2011-08-20', '20:06:40'),
(415, 1, 1, '255.255', '24.03', '88', '00', '2011-08-20', '20:07:21'),
(416, 1, 1, '255.255', '23.76', '90', '00', '2011-08-20', '20:08:02'),
(417, 1, 1, '255.255', '23.76', '88', '00', '2011-08-20', '20:08:43'),
(418, 1, 1, '255.255', '23.76', '88', '00', '2011-08-20', '20:09:24'),
(419, 1, 1, '255.255', '24.03', '88', '00', '2011-08-20', '20:10:04'),
(420, 1, 1, '255.255', '23.76', '88', '00', '2011-08-20', '20:10:45'),
(421, 1, 1, '255.255', '23.49', '93', '00', '2011-08-20', '20:11:26'),
(422, 1, 1, '255.255', '23.76', '88', '00', '2011-08-20', '20:12:07'),
(423, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:12:48'),
(424, 1, 1, '255.255', '23.76', '88', '00', '2011-08-20', '20:13:41'),
(425, 1, 1, '255.255', '23.76', '88', '00', '2011-08-20', '20:14:22'),
(426, 1, 1, '255.255', '23.76', '91', '00', '2011-08-20', '20:15:15'),
(427, 1, 1, '255.255', '23.49', '96', '00', '2011-08-20', '20:15:56'),
(428, 1, 1, '255.255', '23.49', '94', '00', '2011-08-20', '20:16:37'),
(429, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:17:18'),
(430, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:17:59'),
(431, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:18:39'),
(432, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:19:20'),
(433, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:20:01'),
(434, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:21:07'),
(435, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:22:13'),
(436, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:22:54'),
(437, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:23:35'),
(438, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:24:16'),
(439, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:24:57'),
(440, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:25:37'),
(441, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:26:18'),
(442, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:26:59'),
(443, 1, 1, '255.255', '23.22', '95', '00', '2011-08-20', '20:27:40'),
(444, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:28:21'),
(445, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:29:01'),
(446, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:29:42'),
(447, 1, 1, '255.255', '23.22', '89', '00', '2011-08-20', '20:30:23'),
(448, 1, 1, '255.255', '23.22', '89', '00', '2011-08-20', '20:31:04'),
(449, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:31:45'),
(450, 1, 1, '255.255', '23.49', '90', '00', '2011-08-20', '20:32:25'),
(451, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:33:06'),
(452, 1, 1, '255.255', '23.22', '94', '00', '2011-08-20', '20:33:47'),
(453, 1, 1, '255.255', '23.49', '90', '00', '2011-08-20', '20:34:28'),
(454, 1, 1, '255.255', '23.22', '96', '00', '2011-08-20', '20:35:09'),
(455, 1, 1, '255.255', '23.49', '93', '00', '2011-08-20', '20:37:11'),
(456, 1, 1, '255.255', '23.49', '94', '00', '2011-08-20', '20:38:30'),
(457, 1, 1, '255.255', '23.49', '93', '00', '2011-08-20', '20:39:11'),
(458, 1, 1, '255.255', '23.22', '94', '00', '2011-08-20', '20:40:17'),
(459, 1, 1, '255.255', '28.92', '89', '00', '2011-08-20', '20:40:58'),
(460, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:41:38'),
(461, 1, 1, '255.255', '23.49', '93', '00', '2011-08-20', '20:42:19'),
(462, 1, 1, '255.255', '23.49', '93', '00', '2011-08-20', '20:43:00'),
(463, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:43:41'),
(464, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:44:22'),
(465, 1, 1, '255.255', '23.49', '94', '00', '2011-08-20', '20:45:02'),
(466, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:45:43'),
(467, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:46:24'),
(468, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:47:05'),
(469, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:47:46'),
(470, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:48:26'),
(471, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:49:07'),
(472, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:49:48'),
(473, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:50:29'),
(474, 1, 1, '255.255', '23.49', '94', '00', '2011-08-20', '20:51:10'),
(475, 1, 1, '255.255', '23.49', '94', '00', '2011-08-20', '20:51:50'),
(476, 1, 1, '255.255', '23.49', '90', '00', '2011-08-20', '20:52:31'),
(477, 1, 1, '255.255', '23.76', '89', '00', '2011-08-20', '20:53:12'),
(478, 1, 1, '255.255', '23.49', '89', '00', '2011-08-20', '20:53:53'),
(479, 1, 1, '255.255', '23.49', '90', '00', '2011-08-20', '20:54:34'),
(480, 1, 1, '255.255', '23.22', '94', '00', '2011-08-20', '20:55:14'),
(481, 1, 1, '255.255', '23.49', '90', '00', '2011-08-20', '20:55:55'),
(482, 1, 1, '255.255', '23.76', '54', '00', '2011-08-20', '20:56:36'),
(483, 1, 1, '255.255', '23.76', '55', '00', '2011-08-20', '20:57:30'),
(484, 1, 1, '255.255', '23.49', '55', '00', '2011-08-20', '20:58:10'),
(485, 1, 1, '255.255', '23.76', '55', '00', '2011-08-20', '20:58:51'),
(486, 1, 1, '255.255', '23.76', '54', '00', '2011-08-20', '20:59:32'),
(487, 1, 1, '255.255', '24.03', '55', '00', '2011-08-20', '21:00:13'),
(488, 1, 1, '255.255', '24.30', '58', '00', '2011-08-20', '21:00:54'),
(489, 1, 1, '255.255', '24.30', '55', '00', '2011-08-20', '21:01:47'),
(490, 1, 1, '255.255', '23.76', '55', '00', '2011-08-20', '21:02:28'),
(491, 1, 1, '255.255', '24.58', '55', '00', '2011-08-20', '21:03:09'),
(492, 1, 1, '255.255', '24.03', '54', '00', '2011-08-20', '21:03:49'),
(493, 1, 1, '255.255', '24.03', '54', '00', '2011-08-20', '21:04:30'),
(494, 1, 1, '255.255', '24.58', '55', '00', '2011-08-20', '21:05:11'),
(495, 1, 1, '255.255', '24.85', '53', '00', '2011-08-20', '21:05:52'),
(496, 1, 1, '255.255', '24.30', '54', '00', '2011-08-20', '21:06:33'),
(497, 1, 1, '255.255', '24.30', '54', '00', '2011-08-20', '21:07:38'),
(498, 1, 1, '255.255', '24.30', '54', '00', '2011-08-20', '21:08:19'),
(499, 1, 1, '255.255', '24.03', '55', '00', '2011-08-20', '21:09:00'),
(500, 1, 1, '255.255', '24.03', '55', '00', '2011-08-20', '21:09:41'),
(501, 1, 1, '255.255', '24.30', '55', '00', '2011-08-20', '21:10:21'),
(502, 1, 1, '255.255', '24.30', '54', '00', '2011-08-20', '21:11:02'),
(503, 1, 1, '255.255', '24.30', '53', '00', '2011-08-20', '21:11:43'),
(504, 1, 1, '255.255', '24.03', '54', '00', '2011-08-20', '21:12:24'),
(505, 1, 1, '255.255', '24.30', '54', '00', '2011-08-20', '21:13:05'),
(506, 1, 1, '255.255', '27.02', '54', '00', '2011-08-20', '21:13:45'),
(507, 1, 1, '255.255', '24.03', '55', '00', '2011-08-20', '21:14:26'),
(508, 1, 1, '255.255', '27.02', '57', '00', '2011-08-20', '21:15:40'),
(509, 1, 1, '255.255', '24.03', '57', '00', '2011-08-20', '21:16:21'),
(510, 1, 1, '255.255', '24.30', '56', '00', '2011-08-20', '21:17:02'),
(511, 1, 1, '255.255', '24.03', '58', '00', '2011-08-20', '21:17:43'),
(512, 1, 1, '255.255', '24.85', '86', '00', '2011-08-20', '21:18:24'),
(513, 1, 1, '255.255', '24.03', '58', '00', '2011-08-20', '21:19:04'),
(514, 1, 1, '255.255', '24.30', '60', '00', '2011-08-20', '21:19:45'),
(515, 1, 1, '255.255', '24.58', '54', '00', '2011-08-20', '21:25:21'),
(516, 1, 1, '255.255', '24.30', '55', '00', '2011-08-20', '21:30:28'),
(517, 1, 1, '255.255', '67.75', '31', '00', '2011-08-21', '18:40:07'),
(518, 1, 1, '255.255', '42.50', '21', '00', '2011-08-21', '18:41:23'),
(519, 1, 1, '255.255', '25.39', '61', '00', '2011-08-21', '18:42:03'),
(520, 1, 1, '255.255', '25.12', '62', '00', '2011-08-21', '18:42:43'),
(521, 1, 1, '255.255', '25.12', '59', '00', '2011-08-21', '18:43:24'),
(522, 1, 1, '255.255', '24.85', '59', '00', '2011-08-21', '18:44:05'),
(523, 1, 1, '255.255', '25.39', '81', '00', '2011-08-21', '18:45:10'),
(524, 1, 1, '255.255', '25.39', '36', '00', '2011-08-21', '18:45:51'),
(525, 1, 1, '255.255', '25.12', '63', '00', '2011-08-21', '18:46:32'),
(526, 1, 1, '255.255', '25.66', '36', '00', '2011-08-21', '18:47:13'),
(527, 1, 1, '255.255', '25.39', '36', '00', '2011-08-21', '18:47:53'),
(528, 1, 1, '255.255', '25.39', '38', '00', '2011-08-21', '18:48:43'),
(529, 1, 1, '255.255', '25.39', '38', '00', '2011-08-21', '18:49:36'),
(530, 1, 1, '255.255', '25.66', '38', '00', '2011-08-21', '18:50:42'),
(531, 1, 1, '255.255', '25.39', '38', '00', '2011-08-21', '18:51:49'),
(532, 1, 1, '255.255', '25.39', '38', '00', '2011-08-21', '18:52:29'),
(533, 1, 1, '255.255', '25.12', '38', '00', '2011-08-21', '18:53:10'),
(534, 1, 1, '255.255', '25.39', '38', '00', '2011-08-21', '18:53:51'),
(535, 1, 1, '255.255', '25.12', '38', '00', '2011-08-21', '18:54:32'),
(536, 1, 1, '255.255', '25.12', '38', '00', '2011-08-21', '18:55:13'),
(537, 1, 1, '255.255', '25.12', '38', '00', '2011-08-21', '18:55:53'),
(538, 1, 1, '255.255', '24.85', '38', '00', '2011-08-21', '18:56:34'),
(539, 1, 1, '255.255', '25.39', '38', '00', '2011-08-21', '18:57:15'),
(540, 1, 1, '255.255', '25.39', '39', '00', '2011-08-21', '19:01:54'),
(541, 1, 1, '255.255', '25.12', '38', '00', '2011-08-21', '19:02:35'),
(542, 1, 1, '255.255', '25.12', '38', '00', '2011-08-21', '19:03:16'),
(543, 1, 1, '255.255', '24.85', '38', '00', '2011-08-21', '19:03:56'),
(544, 1, 1, '255.255', '25.12', '38', '00', '2011-08-21', '19:04:37'),
(545, 1, 1, '255.255', '24.85', '38', '00', '2011-08-21', '19:05:18'),
(546, 1, 1, '255.255', '24.85', '38', '00', '2011-08-21', '19:05:59'),
(547, 1, 1, '255.255', '25.12', '38', '01', '2011-08-21', '19:07:37'),
(548, 1, 1, '255.255', '24.85', '62', '00', '2011-08-21', '19:09:44'),
(549, 1, 1, '255.255', '24.58', '61', '00', '2011-08-21', '19:10:44'),
(550, 1, 1, '255.255', '24.58', '64', '01', '2011-08-21', '19:11:22'),
(551, 1, 1, '255.255', '24.58', '63', '01', '2011-08-21', '19:12:00'),
(552, 1, 1, '255.255', '24.58', '61', '01', '2011-08-21', '19:12:38'),
(553, 1, 1, '255.255', '24.58', '61', '01', '2011-08-21', '19:13:16'),
(554, 1, 1, '255.255', '25.66', '62', '01', '2011-08-21', '19:14:17'),
(555, 1, 1, '255.255', '25.12', '62', '00', '2011-08-21', '19:14:54'),
(556, 1, 1, '255.255', '25.66', '62', '00', '2011-08-21', '19:15:45'),
(557, 1, 1, '255.255', '24.58', '62', '00', '2011-08-21', '19:16:30'),
(558, 1, 1, '255.255', '24.30', '63', '00', '2011-08-21', '19:17:08'),
(559, 1, 1, '255.255', '24.58', '64', '00', '2011-08-21', '19:17:46'),
(560, 1, 1, '255.255', '24.30', '64', '00', '2011-08-21', '19:18:24'),
(561, 1, 1, '255.255', '24.85', '63', '00', '2011-08-21', '19:19:03'),
(562, 1, 1, '255.255', '24.58', '63', '00', '2011-08-21', '19:19:45'),
(563, 1, 1, '255.255', '24.85', '70', '00', '2011-08-21', '19:20:23'),
(564, 1, 1, '255.255', '25.93', '62', '00', '2011-08-21', '19:21:02'),
(565, 1, 1, '255.255', '25.39', '61', '01', '2011-08-21', '19:21:40'),
(566, 1, 1, '255.255', '25.66', '61', '00', '2011-08-21', '19:22:32'),
(567, 1, 1, '255.255', '25.66', '61', '01', '2011-08-21', '19:23:10'),
(568, 1, 1, '255.255', '24.58', '61', '00', '2011-08-21', '19:23:48'),
(569, 1, 1, '255.255', '24.58', '60', '00', '2011-08-21', '19:24:26'),
(570, 1, 1, '255.255', '24.85', '62', '01', '2011-08-21', '19:25:04'),
(571, 1, 1, '255.255', '24.58', '66', '00', '2011-08-21', '19:25:42'),
(572, 1, 1, '255.255', '24.85', '61', '00', '2011-08-21', '19:26:21'),
(573, 1, 1, '255.255', '24.58', '63', '00', '2011-08-21', '19:27:08'),
(574, 1, 1, '255.255', '25.66', '61', '01', '2011-08-21', '19:27:50'),
(575, 1, 1, '255.255', '24.85', '60', '01', '2011-08-21', '19:28:28'),
(576, 1, 1, '255.255', '25.93', '62', '00', '2011-08-21', '19:29:06'),
(577, 1, 1, '255.255', '25.66', '62', '01', '2011-08-21', '19:29:44'),
(578, 1, 1, '255.255', '25.66', '62', '00', '2011-08-21', '19:30:22'),
(579, 1, 1, '255.255', '25.39', '63', '00', '2011-08-21', '19:31:00'),
(580, 1, 1, '255.255', '25.66', '60', '00', '2011-08-21', '19:31:38'),
(581, 1, 1, '255.255', '25.66', '62', '00', '2011-08-21', '19:32:17'),
(582, 1, 1, '255.255', '25.66', '62', '00', '2011-08-21', '19:32:55'),
(583, 1, 1, '255.255', '25.66', '62', '00', '2011-08-21', '19:33:33'),
(584, 1, 1, '255.255', '24.58', '62', '00', '2011-08-21', '19:34:17'),
(585, 1, 1, '255.255', '24.85', '61', '01', '2011-08-21', '19:34:55'),
(586, 1, 1, '255.255', '25.66', '62', '01', '2011-08-21', '19:35:33'),
(587, 1, 1, '255.255', '25.39', '63', '01', '2011-08-21', '19:36:11'),
(588, 1, 1, '255.255', '24.58', '60', '00', '2011-08-21', '19:36:50'),
(589, 1, 1, '255.255', '24.30', '62', '01', '2011-08-21', '19:37:28'),
(590, 1, 1, '255.255', '24.85', '63', '00', '2011-08-21', '19:38:06'),
(591, 1, 1, '255.255', '25.39', '63', '01', '2011-08-21', '19:38:44'),
(592, 1, 1, '255.255', '24.85', '63', '01', '2011-08-21', '19:39:22'),
(593, 1, 1, '255.255', '24.58', '62', '00', '2011-08-21', '19:40:00'),
(594, 1, 1, '255.255', '25.66', '62', '00', '2011-08-21', '19:40:38'),
(595, 1, 1, '255.255', '25.66', '61', '00', '2011-08-21', '19:41:16'),
(596, 1, 1, '255.255', '24.58', '61', '00', '2011-08-21', '19:41:55'),
(597, 1, 1, '255.255', '25.66', '62', '00', '2011-08-21', '19:42:33'),
(598, 1, 1, '255.255', '24.30', '62', '01', '2011-08-21', '19:43:11'),
(599, 1, 1, '255.255', '25.39', '62', '01', '2011-08-21', '19:43:49'),
(600, 1, 1, '255.255', '25.66', '62', '00', '2011-08-21', '19:44:27'),
(601, 1, 1, '255.255', '25.93', '65', '01', '2011-08-21', '19:45:05'),
(602, 1, 1, '255.255', '25.66', '63', '00', '2011-08-21', '19:45:43'),
(603, 1, 1, '255.255', '24.58', '63', '01', '2011-08-21', '19:46:22'),
(604, 1, 1, '255.255', '24.58', '61', '01', '2011-08-21', '19:47:00'),
(605, 1, 1, '255.255', '25.39', '63', '01', '2011-08-21', '19:47:38'),
(606, 1, 1, '255.255', '24.30', '61', '01', '2011-08-21', '19:48:16'),
(607, 1, 1, '108.108', '24.85', '61', '00', '2011-08-21', '19:49:55'),
(608, 1, 1, '108.108', '24.58', '61', '00', '2011-08-21', '19:50:36'),
(609, 1, 1, '00.00', '24.58', '64', '00', '2011-08-21', '19:51:49'),
(610, 1, 1, '00.00', '24.85', '62', '00', '2011-08-21', '19:52:30'),
(611, 1, 1, '00.00', '24.58', '62', '00', '2011-08-21', '19:53:11'),
(612, 1, 1, '254.62', '24.58', '01', '00', '2011-08-21', '19:54:35'),
(613, 1, 1, '00.00', '25.12', '62', '01', '2011-08-21', '19:55:52'),
(614, 1, 1, '00.00', '24.58', '62', '01', '2011-08-21', '19:56:30'),
(615, 1, 1, '00.00', '24.85', '60', '00', '2011-08-21', '19:57:08'),
(616, 1, 1, '00.00', '25.39', '62', '01', '2011-08-21', '19:57:46'),
(617, 1, 1, '00.00', '24.58', '61', '01', '2011-08-21', '19:58:25'),
(618, 1, 1, '00.00', '27.02', '68', '01', '2011-08-21', '19:59:03'),
(619, 1, 1, '00.00', '25.93', '63', '00', '2011-08-21', '19:59:41'),
(620, 1, 1, '00.00', '27.02', '70', '00', '2011-08-21', '20:00:19'),
(621, 1, 1, '00.00', '27.83', '76', '00', '2011-08-21', '20:00:57'),
(622, 1, 1, '00.00', '26.75', '62', '01', '2011-08-21', '20:01:35'),
(623, 1, 1, '00.00', '25.39', '63', '01', '2011-08-21', '20:02:38'),
(624, 1, 1, '00.00', '25.39', '61', '01', '2011-08-21', '20:03:43'),
(625, 1, 1, '00.00', '26.20', '62', '00', '2011-08-21', '20:04:52'),
(626, 1, 1, '00.00', '25.39', '61', '00', '2011-08-21', '20:05:36'),
(627, 1, 1, '00.00', '24.85', '62', '00', '2011-08-21', '20:06:14'),
(628, 1, 1, '00.00', '25.93', '61', '01', '2011-08-21', '20:07:23'),
(629, 1, 1, '00.00', '24.85', '61', '01', '2011-08-21', '20:09:51'),
(630, 1, 1, '00.00', '25.39', '61', '01', '2011-08-21', '20:10:29'),
(631, 1, 1, '00.00', '26.20', '60', '00', '2011-08-21', '20:12:17'),
(632, 1, 1, '00.00', '25.12', '62', '01', '2011-08-21', '20:12:55'),
(633, 1, 1, '00.00', '25.12', '62', '00', '2011-08-21', '20:13:33'),
(634, 1, 1, '00.00', '26.20', '61', '00', '2011-08-21', '20:14:11'),
(635, 1, 1, '00.00', '25.12', '63', '01', '2011-08-21', '20:14:49'),
(636, 1, 1, '00.00', '26.20', '61', '01', '2011-08-21', '20:15:27'),
(637, 1, 1, '00.00', '25.12', '62', '00', '2011-08-21', '20:16:05'),
(638, 1, 1, '00.00', '24.85', '61', '01', '2011-08-21', '20:16:43'),
(639, 1, 1, '00.00', '25.12', '61', '00', '2011-08-21', '20:17:44'),
(640, 1, 1, '00.00', '26.20', '61', '00', '2011-08-21', '20:18:26'),
(641, 1, 1, '00.00', '25.93', '61', '00', '2011-08-21', '20:19:07'),
(642, 1, 1, '00.00', '25.39', '62', '01', '2011-08-21', '20:19:48'),
(643, 1, 1, '00.00', '25.93', '61', '00', '2011-08-21', '20:20:26'),
(644, 1, 1, '00.00', '24.85', '62', '01', '2011-08-21', '20:21:05'),
(645, 1, 1, '00.00', '25.39', '61', '01', '2011-08-21', '20:21:46'),
(646, 1, 1, '00.00', '25.93', '62', '00', '2011-08-21', '20:22:27'),
(647, 1, 1, '00.00', '25.12', '61', '01', '2011-08-21', '20:23:08'),
(648, 1, 1, '00.00', '25.12', '62', '01', '2011-08-21', '20:23:50'),
(649, 1, 1, '00.00', '26.20', '61', '00', '2011-08-21', '20:24:31'),
(650, 1, 1, '00.00', '25.12', '63', '00', '2011-08-21', '20:25:12'),
(651, 1, 1, '00.00', '25.39', '63', '00', '2011-08-21', '20:25:53'),
(652, 1, 1, '00.00', '25.12', '62', '01', '2011-08-21', '20:26:35'),
(653, 1, 1, '00.00', '25.66', '69', '00', '2011-08-21', '20:27:16'),
(654, 1, 1, '00.00', '24.85', '62', '01', '2011-08-21', '20:27:54'),
(655, 1, 1, '00.00', '26.20', '61', '01', '2011-08-21', '20:28:32'),
(656, 1, 1, '00.00', '25.12', '61', '00', '2011-08-21', '20:29:10'),
(657, 1, 1, '00.00', '26.20', '61', '00', '2011-08-21', '20:29:55'),
(658, 1, 1, '00.00', '24.58', '61', '00', '2011-08-21', '20:30:36'),
(659, 1, 1, '00.00', '25.12', '62', '01', '2011-08-21', '20:31:17'),
(660, 1, 1, '00.00', '25.12', '63', '01', '2011-08-21', '20:31:55'),
(661, 1, 1, '00.00', '26.20', '63', '01', '2011-08-21', '20:32:33'),
(662, 1, 1, '00.00', '25.93', '62', '00', '2011-08-21', '20:33:12'),
(663, 1, 1, '00.00', '25.12', '61', '01', '2011-08-21', '20:33:50'),
(664, 1, 1, '00.00', '25.66', '63', '01', '2011-08-21', '20:34:28'),
(665, 1, 1, '00.00', '26.20', '62', '00', '2011-08-21', '20:35:06'),
(666, 1, 1, '00.00', '25.93', '62', '01', '2011-08-21', '20:35:44'),
(667, 1, 1, '00.00', '26.20', '63', '00', '2011-08-21', '20:36:22'),
(668, 1, 1, '00.00', '25.12', '63', '00', '2011-08-21', '20:37:31'),
(669, 1, 1, '00.00', '26.20', '62', '00', '2011-08-21', '20:38:09'),
(670, 1, 1, '00.00', '26.20', '63', '01', '2011-08-21', '20:38:53'),
(671, 1, 1, '00.00', '25.39', '63', '01', '2011-08-21', '20:39:35'),
(672, 1, 1, '00.00', '26.20', '64', '00', '2011-08-21', '20:43:05'),
(673, 1, 1, '00.00', '25.39', '63', '01', '2011-08-21', '20:43:43'),
(674, 1, 1, '00.00', '25.66', '61', '00', '2011-08-21', '20:44:21'),
(675, 1, 1, '00.00', '25.39', '62', '00', '2011-08-21', '20:45:00'),
(676, 1, 1, '00.00', '24.58', '61', '01', '2011-08-21', '20:45:38'),
(677, 1, 1, '00.00', '25.66', '61', '01', '2011-08-21', '20:46:16'),
(678, 1, 1, '00.00', '25.66', '60', '01', '2011-08-21', '20:46:54'),
(679, 1, 1, '00.00', '25.66', '60', '00', '2011-08-21', '20:47:32'),
(680, 1, 1, '00.00', '24.30', '61', '01', '2011-08-21', '20:48:10'),
(681, 1, 1, '00.00', '24.58', '62', '00', '2011-08-21', '20:48:48'),
(682, 1, 1, '00.00', '25.39', '61', '00', '2011-08-21', '20:49:26'),
(683, 1, 1, '00.00', '25.39', '61', '00', '2011-08-21', '20:50:04'),
(684, 1, 1, '00.00', '25.39', '60', '00', '2011-08-21', '20:50:43'),
(685, 1, 1, '00.00', '24.58', '61', '01', '2011-08-21', '20:51:21'),
(686, 1, 1, '00.00', '24.30', '62', '01', '2011-08-21', '20:51:59'),
(687, 1, 1, '00.00', '24.85', '63', '00', '2011-08-21', '20:52:37'),
(688, 1, 1, '00.00', '25.39', '60', '00', '2011-08-21', '20:53:15'),
(689, 1, 1, '00.00', '53.90', '32', '01', '2011-08-21', '20:53:53');

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
(1, 's1', 1),
(2, 's2', 1),
(3, 'j1', 2);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcar la base de datos para la tabla `ardomus_sensores`
--

INSERT INTO `ardomus_sensores` (`id`, `identificador`, `tipo_id`, `mota_id`) VALUES
(1, 'luz ventana', 1, 1),
(2, 'temp habitaculo', 2, 1),
(3, 'seguridad', 4, 1),
(4, 'cesped seco', 3, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_sensoresactivos`
--

CREATE TABLE IF NOT EXISTS `ardomus_sensoresactivos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zona_id` int(11) NOT NULL,
  `mota_id` int(11) NOT NULL,
  `motaActiva` int(11) NOT NULL,
  `luz` int(11) NOT NULL,
  `temperatura` int(11) NOT NULL,
  `humedad` int(11) NOT NULL,
  `movimiento` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ardomus_sensoresactivos_e797092` (`zona_id`),
  KEY `ardomus_sensoresactivos_5c1fae95` (`mota_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcar la base de datos para la tabla `ardomus_sensoresactivos`
--

INSERT INTO `ardomus_sensoresactivos` (`id`, `zona_id`, `mota_id`, `motaActiva`, `luz`, `temperatura`, `humedad`, `movimiento`) VALUES
(1, 1, 1, 1, 1, 1, 0, 1),
(2, 1, 2, 1, -1, -1, -1, -1),
(3, 2, 3, 1, -1, -1, 1, -1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_sonido`
--

CREATE TABLE IF NOT EXISTS `ardomus_sonido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `mixpod` longtext,
  PRIMARY KEY (`id`),
  KEY `ardomus_sonido_403f60f` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcar la base de datos para la tabla `ardomus_sonido`
--

INSERT INTO `ardomus_sonido` (`id`, `user_id`, `mixpod`) VALUES
(1, 2, '	<img style="visibility:hidden;width:0px;height:0px;" border=0 width=0 height=0 src="http://c.gigcount.com/wildfire/IMP/CXNID=2000002.0NXC/bT*xJmx*PTEzMTM4NDA3MzIzODImcHQ9MTMxMzg*MDczNjA4NCZwPTE4MDMxJmQ9Jmc9MSZvPTFjMzJiMTQ2MjVmOTRjYWE4M2U4/ODUzY2NkMzE*NDAz.gif" /><embed src="http://assets.myflashfetish.com/swf/mp3/mixpod.swf?myid=84871055&path=2011/08/20" quality="high" wmode="window" bgcolor="222222" flashvars="mycolor=222222&mycolor2=77ADD1&mycolor3=FFFFFF&autoplay=false&rand=0&f=4&vol=100&pat=0&grad=false" width="410" height="311" name="myflashfetish" salign="TL" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" border="0" style="visibility:visible;width:410px;height:311px;" /><br><a href="http://www.mixpod.com/playlist/84871055"><img src="http://assets.myflashfetish.com/images/btn2-tracks.gif" alt="Music" title="Get Music Tracks!" border="0"></a><a href="http://www.mixpod.com" target="_blank"><img src="http://assets.myflashfetish.com/images/btn2-create.gif" alt="Playlist" title="Create Your Free Playlist!" border=0></a><a href="http://www.mixpod.com"><img src="http://assets.myflashfetish.com/images/btn2-profile.gif" alt="View Profile" title="View all my playlists!" border="0"></a><br />Create a <a href="http://mixpod.com">playlist</a> at <a href="http://mixpod.com">MixPod.com</a>');

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
(2, 'AireAcondicionado'),
(3, 'Persianas'),
(4, 'RiegoCesped');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ardomus_tiposensores`
--

CREATE TABLE IF NOT EXISTS `ardomus_tiposensores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Volcar la base de datos para la tabla `ardomus_tiposensores`
--

INSERT INTO `ardomus_tiposensores` (`id`, `nombre`) VALUES
(1, 'Luminosidad'),
(2, 'Temperatura'),
(3, 'Humedad'),
(4, 'Movimiento'),
(5, 'CO2');

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
(1, 'Mi casa', 'mi casa', '192.168.0.4');

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
(2, 2, 1),
(3, 2, 2);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcar la base de datos para la tabla `ardomus_zonas`
--

INSERT INTO `ardomus_zonas` (`id`, `nombre`, `uc_id`) VALUES
(1, 'Salon', 1),
(2, 'Jardin', 1);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=70 ;

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
(57, 'Can delete arduino actuales', 19, 'delete_arduinoactuales'),
(58, 'Can add sensores activos', 20, 'add_sensoresactivos'),
(59, 'Can change sensores activos', 20, 'change_sensoresactivos'),
(60, 'Can delete sensores activos', 20, 'delete_sensoresactivos'),
(61, 'Can add alarmas', 21, 'add_alarmas'),
(62, 'Can change alarmas', 21, 'change_alarmas'),
(63, 'Can delete alarmas', 21, 'delete_alarmas'),
(64, 'Can add sonido', 22, 'add_sonido'),
(65, 'Can change sonido', 22, 'change_sonido'),
(66, 'Can delete sonido', 22, 'delete_sonido'),
(67, 'Can add ahorro energetico', 23, 'add_ahorroenergetico'),
(68, 'Can change ahorro energetico', 23, 'change_ahorroenergetico'),
(69, 'Can delete ahorro energetico', 23, 'delete_ahorroenergetico');

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
(1, 'marc', '', '', 'mb154@hotmail.com', 'sha1$a22b8$3795f733d14080774af96a16db0f1e897a437c79', 1, 1, 1, '2011-08-19 13:24:22', '2011-08-19 13:23:31'),
(2, 'arundil', '', '', '', 'sha1$2a349$5ff6ce9236d38b54f3004db4428c5335fbd87669', 1, 1, 0, '2011-08-20 20:16:50', '2011-08-19 13:29:12');

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Volcar la base de datos para la tabla `django_admin_log`
--


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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=24 ;

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
(19, 'arduino actuales', 'ardomus', 'arduinoactuales'),
(20, 'sensores activos', 'ardomus', 'sensoresactivos'),
(21, 'alarmas', 'ardomus', 'alarmas'),
(22, 'sonido', 'ardomus', 'sonido'),
(23, 'ahorro energetico', 'ardomus', 'ahorroenergetico');

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
('3d61eeecbf2aeaf1baf5fe2703e097e4', 'YzY5Mjc0NDBlODRjMmJhZmM0ODliODAzNDA2YTU3NjkzMDFmZjQwZTqAAn1xAShVEl9hdXRoX3Vz\nZXJfYmFja2VuZHECVSlkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZHED\nVQ1fYXV0aF91c2VyX2lkcQSKAQJ1Lg==\n', '2011-09-03 20:16:50');

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
  ADD CONSTRAINT `mota_id_refs_id_5a2c985f` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`),
  ADD CONSTRAINT `tipo_id_refs_id_3871bd31` FOREIGN KEY (`tipo_id`) REFERENCES `ardomus_tipoactuadores` (`id`);

--
-- Filtros para la tabla `ardomus_alarmas`
--
ALTER TABLE `ardomus_alarmas`
  ADD CONSTRAINT `medicion_id_refs_id_7ef5df49` FOREIGN KEY (`medicion_id`) REFERENCES `ardomus_mediciones` (`id`);

--
-- Filtros para la tabla `ardomus_arduinoactuales`
--
ALTER TABLE `ardomus_arduinoactuales`
  ADD CONSTRAINT `mota_id_refs_id_18881647` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`),
  ADD CONSTRAINT `zona_id_refs_id_64dc60b2` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`);

--
-- Filtros para la tabla `ardomus_arduinos`
--
ALTER TABLE `ardomus_arduinos`
  ADD CONSTRAINT `mota_id_refs_id_7a4c62fd` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`),
  ADD CONSTRAINT `zona_id_refs_id_23af0344` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`);

--
-- Filtros para la tabla `ardomus_mediciones`
--
ALTER TABLE `ardomus_mediciones`
  ADD CONSTRAINT `mota_id_refs_id_79b399a2` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`),
  ADD CONSTRAINT `zona_id_refs_id_2cf53523` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`);

--
-- Filtros para la tabla `ardomus_motas`
--
ALTER TABLE `ardomus_motas`
  ADD CONSTRAINT `zona_id_refs_id_1669f02e` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`);

--
-- Filtros para la tabla `ardomus_sensores`
--
ALTER TABLE `ardomus_sensores`
  ADD CONSTRAINT `mota_id_refs_id_7d7510ce` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`),
  ADD CONSTRAINT `tipo_id_refs_id_8f1812b` FOREIGN KEY (`tipo_id`) REFERENCES `ardomus_tiposensores` (`id`);

--
-- Filtros para la tabla `ardomus_sensoresactivos`
--
ALTER TABLE `ardomus_sensoresactivos`
  ADD CONSTRAINT `mota_id_refs_id_304e9bf2` FOREIGN KEY (`mota_id`) REFERENCES `ardomus_motas` (`id`),
  ADD CONSTRAINT `zona_id_refs_id_37f83307` FOREIGN KEY (`zona_id`) REFERENCES `ardomus_zonas` (`id`);

--
-- Filtros para la tabla `ardomus_sonido`
--
ALTER TABLE `ardomus_sonido`
  ADD CONSTRAINT `user_id_refs_id_1ba4dda6` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

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
  ADD CONSTRAINT `group_id_refs_id_f116770` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `user_id_refs_id_7ceef80f` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `permission_id_refs_id_67e79cb` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `user_id_refs_id_dfbab7d` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `content_type_id_refs_id_288599e6` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `user_id_refs_id_c8665aa` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
