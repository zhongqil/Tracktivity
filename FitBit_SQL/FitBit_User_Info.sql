-- phpMyAdmin SQL Dump
-- version 4.0.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 19, 2013 at 09:36 PM
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
-- Table structure for table `FitBit_User_Info`
--

CREATE TABLE IF NOT EXISTS `FitBit_User_Info` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(255) NOT NULL,
  `FB_Id` varchar(255) NOT NULL,
  `Team_Name` varchar(255) NOT NULL,
  `Role` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `FB_Id` (`FB_Id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `FitBit_User_Info`
--

INSERT INTO `FitBit_User_Info` (`ID`, `Username`, `FB_Id`, `Team_Name`, `Role`) VALUES
(15, 'Lee Zhongqi', '100003602689815', 'Followme', 'Member');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
