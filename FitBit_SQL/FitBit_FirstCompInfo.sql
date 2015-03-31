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
-- Table structure for table `FitBit_FirstCompInfo`
--

CREATE TABLE IF NOT EXISTS `FitBit_FirstCompInfo` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Competition_Name` varchar(255) NOT NULL,
  `Joined_Team` varchar(255) NOT NULL,
  `Time_Duration` time NOT NULL,
  `Rank` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Rank` (`Rank`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `FitBit_FirstCompInfo`
--

INSERT INTO `FitBit_FirstCompInfo` (`ID`, `Competition_Name`, `Joined_Team`, `Time_Duration`, `Rank`) VALUES
(1, 'Tracktivity_01', 'Followme', '00:30:45', 1),
(2, 'Tracktivity_01', 'Div', '00:45:32', 2),
(3, 'Tracktivity_01', 'FakeTeam', '00:51:22', 3);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
