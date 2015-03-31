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
-- Table structure for table `FitBit_Indie_Track_Rank`
--

CREATE TABLE IF NOT EXISTS `FitBit_Indie_Track_Rank` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(255) NOT NULL,
  `Competition` varchar(255) NOT NULL,
  `Team_Name` varchar(255) NOT NULL,
  `Time_Duration` varchar(255) NOT NULL,
  `Rank` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Rank` (`Rank`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `FitBit_Indie_Track_Rank`
--

INSERT INTO `FitBit_Indie_Track_Rank` (`ID`, `Username`, `Competition`, `Team_Name`, `Time_Duration`, `Rank`) VALUES
(1, 'Lee Zhongqi', 'Tracktivity_01', 'Followme', '00:20:22', 1),
(2, 'Liam', 'Tracktivity_01', 'Followme', '00:21:23', 2),
(3, 'JCampton', 'Tracktivity_01', 'Followme', '00:26:55', 3),
(4, 'CParker', 'Tracktivity_01', 'Div', '00:28:30', 4),
(5, 'TMerrit', 'Tracktivity_01', 'Followme', '00:30:45', 5);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
