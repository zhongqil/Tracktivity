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
-- Table structure for table `FitBit_Contribution_Rank`
--

CREATE TABLE IF NOT EXISTS `FitBit_Contribution_Rank` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(225) NOT NULL,
  `Total_Steps` int(11) NOT NULL,
  `Team_Name` varchar(255) NOT NULL,
  `Rank` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Rank` (`Rank`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `FitBit_Contribution_Rank`
--

INSERT INTO `FitBit_Contribution_Rank` (`ID`, `Username`, `Total_Steps`, `Team_Name`, `Rank`) VALUES
(1, 'JCampton', 230000, 'Followme', 1),
(2, 'TMerrit', 210000, 'Followme', 2),
(3, 'Lee Zhongqi', 170000, 'Followme', 3),
(4, 'Liam', 140000, 'Followme', 4);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
