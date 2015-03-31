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
-- Table structure for table `FitBit_Test_Data`
--

CREATE TABLE IF NOT EXISTS `FitBit_Test_Data` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `fitbit_id` int(11) NOT NULL,
  `Date` date NOT NULL,
  `Steps` int(11) NOT NULL,
  `SedentryMinutes` int(11) NOT NULL,
  `VeryActiveMinutes` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `FitBit_Test_Data`
--

INSERT INTO `FitBit_Test_Data` (`ID`, `fitbit_id`, `Date`, `Steps`, `SedentryMinutes`, `VeryActiveMinutes`) VALUES
(1, 1, '2013-11-24', 2121, 749, 500),
(2, 1, '2013-11-25', 15000, 400, 700),
(3, 1, '2013-11-26', 7500, 400, 500),
(4, 1, '2013-11-27', 10000, 360, 700),
(5, 1, '2013-11-28', 3000, 600, 300);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
