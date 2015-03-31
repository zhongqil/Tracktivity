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
-- Table structure for table `FitBit_Team_Rank`
--

CREATE TABLE IF NOT EXISTS `FitBit_Team_Rank` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Team_Name` varchar(255) NOT NULL,
  `Team_Total_Steps` int(11) NOT NULL,
  `Team_Rank` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Team_Rank` (`Team_Rank`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `FitBit_Team_Rank`
--

INSERT INTO `FitBit_Team_Rank` (`ID`, `Team_Name`, `Team_Total_Steps`, `Team_Rank`) VALUES
(1, 'Followme', 750000, 1),
(2, 'Div', 650000, 2),
(3, 'FakeTeam', 600000, 3),
(4, 'ateam', 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
