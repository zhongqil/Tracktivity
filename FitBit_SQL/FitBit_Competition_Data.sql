-- phpMyAdmin SQL Dump
-- version 4.0.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 19, 2013 at 09:35 PM
-- Server version: 5.5.20
-- PHP Version: 5.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `zhongqil`
--

-- --------------------------------------------------------

--
-- Table structure for table `FitBit_Competition_Data`
--

CREATE TABLE IF NOT EXISTS `FitBit_Competition_Data` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Competition_Name` varchar(255) NOT NULL,
  `Destination_Lati` double NOT NULL,
  `Destination_Long` double NOT NULL,
  `Destination_Title` varchar(255) NOT NULL,
  `Destination_Snippet` varchar(255) NOT NULL,
  `DateTime_Start` datetime NOT NULL,
  `DateTime_End` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `FitBit_Competition_Data`
--

INSERT INTO `FitBit_Competition_Data` (`ID`, `Competition_Name`, `Destination_Lati`, `Destination_Long`, `Destination_Title`, `Destination_Snippet`, `DateTime_Start`, `DateTime_End`) VALUES
(1, 'Tracktivity_01', -41.437724, 147.138283, 'Brisbane St.', 'Launceston', '2013-12-17 03:00:00', '2013-12-17 16:00:00'),
(2, 'Tracktivity_02', -33.868, 151.2086, 'Rowe St.', 'Sydney', '2013-12-18 09:00:00', '2013-12-18 20:00:00'),
(3, 'Tracktivity_03', -37.809869, 144.964825, 'La Trobe St.', 'Melbourne', '2013-12-19 09:00:00', '2013-12-19 20:00:00');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
