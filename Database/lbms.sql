-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 28, 2025 at 04:10 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lbms`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `username` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`username`, `password`) VALUES
('rohit_phalke', 'rohit123'),
('sanket_zagade', 'Sanket1800'),
('sanskruti_bhosale', 'Sanskruti1800');

-- --------------------------------------------------------

--
-- Table structure for table `book_details`
--

CREATE TABLE `book_details` (
  `b_id` int(11) NOT NULL,
  `book_name` varchar(50) NOT NULL,
  `b_category` varchar(50) NOT NULL,
  `b_author` varchar(50) NOT NULL,
  `b_publisher` varchar(50) NOT NULL,
  `b_pages` int(20) NOT NULL,
  `b_qty` int(20) NOT NULL,
  `b_edition` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `book_details`
--

INSERT INTO `book_details` (`b_id`, `book_name`, `b_category`, `b_author`, `b_publisher`, `b_pages`, `b_qty`, `b_edition`) VALUES
(4001, 'Computer Organization and Embedded Systems', 'Educational', 'Carl Hamacher', 'SPPU', 120, 19, 2024),
(4002, 'Data Structures and Algorithms in Java', 'Educational', 'Robert Lafore', 'SPPU', 254, 8, 2023),
(4004, 'Information Technology Project Management', 'Educational', 'Kathy Schwalbe', 'SPPU', 254, 24, 2023),
(4005, 'Optimization Technology', 'Educational', 'Robert Lafore', 'SPPU', 350, 26, 2024),
(4006, 'Research Mthodology', 'Educational', 'C.S.V. Murthy', 'SPPU', 260, 4, 2021),
(4007, 'Software Engineering and Project Management', 'Educational', 'Fred R. David', 'SPPU', 158, 7, 2020),
(4008, 'Java Programming', 'Educational', 'Herbert Schildt', 'SPPU', 254, 27, 2023);

-- --------------------------------------------------------

--
-- Table structure for table `issue_details`
--

CREATE TABLE `issue_details` (
  `s_name` varchar(50) NOT NULL,
  `s_rollno` int(10) NOT NULL,
  `s_class` varchar(10) NOT NULL,
  `book_name` varchar(50) NOT NULL,
  `b_id` int(10) NOT NULL,
  `issue_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `issue_details`
--

INSERT INTO `issue_details` (`s_name`, `s_rollno`, `s_class`, `book_name`, `b_id`, `issue_date`) VALUES
('Sanket Zagade', 1001, 'MCA', 'Data Structures and Algorithms in Java', 4002, '2025-03-15'),
('Abhishek Sasane', 1007, 'MCA', 'Software Engineering and Project Management', 4007, '2025-03-16');

-- --------------------------------------------------------

--
-- Table structure for table `return_details`
--

CREATE TABLE `return_details` (
  `s_id` int(11) NOT NULL,
  `s_name` varchar(30) NOT NULL,
  `card_no` int(11) NOT NULL,
  `b_id` int(11) NOT NULL,
  `b_name` varchar(100) NOT NULL,
  `issue_date` date NOT NULL,
  `return_date` date NOT NULL,
  `charges` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `return_details`
--

INSERT INTO `return_details` (`s_id`, `s_name`, `card_no`, `b_id`, `b_name`, `issue_date`, `return_date`, `charges`) VALUES
(101, 'Sanket Zagade', 101, 101, 'ADBMS', '2025-03-02', '2025-03-15', 30),
(101, 'Sanket Zagade', 101, 101, 'ADBMS', '2025-03-02', '2025-03-15', 30),
(102, 'Abhi Zagade', 102, 101, 'ADBMS', '2025-03-14', '2025-03-15', 0),
(2001, 'Suraj Jarad', 2001, 4001, 'Computer Organization and Embedded Systems', '2025-03-17', '2025-03-17', 0),
(1001, 'Sanket Zagade', 1001, 4002, 'Data Structures and Algorithms in Java', '2025-03-16', '2025-03-17', 0),
(1006, 'Rohit Pansare', 1006, 4008, 'Java Programming', '2025-03-17', '2025-03-17', 0),
(1001, 'Sanket Zagade', 1001, 4001, 'Computer Organization and Embedded Systems', '2025-03-16', '2025-03-17', 0),
(1001, 'Sanket Zagade', 1001, 4001, 'Computer Organization and Embedded Systems', '2000-03-12', '2025-03-12', 45620),
(1015, 'Alfiya Pathan', 1015, 4001, 'Computer Organization and Embedded Systems', '2025-03-20', '2025-03-29', 10),
(1009, 'Vaishanavi Ban', 1009, 4002, 'Data Structures and Algorithms in Java', '2025-03-14', '2025-03-27', 30);

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `s_name` varchar(50) NOT NULL,
  `s_class` varchar(50) NOT NULL,
  `s_rollno` int(30) NOT NULL,
  `s_gender` varchar(10) NOT NULL,
  `s_phno` varchar(10) NOT NULL,
  `s_email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`s_name`, `s_class`, `s_rollno`, `s_gender`, `s_phno`, `s_email`) VALUES
('Sanket Zagade', 'MCA', 1001, 'Male', '9766260920', 'sanketzagade0018@gmail.com'),
('Rohit Phalke', 'MCA', 1002, 'Male', '9638527410', 'rohit12@gmail.com'),
('Rohan Wadane', 'MCA', 1003, 'Male', '8529637410', 'rohan22@gmail.com'),
('Prasad Ghadage', 'MCA', 1004, 'Male', '7418529630', 'prasad@gmail.com'),
('Rohit Pansare', 'MCA', 1006, 'Male', '9874563210', 'rohit1442@gmail.com'),
('Abhishek Sasane', 'MCA', 1007, 'Male', '9873216540', 'abhishek32@gmail.com'),
('Sanskruti Bhosale', 'MCA', 1008, 'Female', '8624838747', 'sans2003@gmail.com'),
('Vaishanavi Ban', 'MCA', 1009, 'Female', '7485963210', 'vaishanavi@gmail.com'),
('Fatema Baramatiwala', 'MCA', 1010, 'Female', '9652413870', 'fatema33@gmail.com'),
('Alfiya Pathan', 'MCA', 1015, 'Female', '8529637410', 'alfiya123@gmail.com'),
('Suraj Jarad', 'MBA', 2001, 'Male', '8529637410', 'suraj213@gmail.com'),
('Tejas Rasal', 'MBA', 2002, 'Male', '8520741963', 'tejas2@gmail.com'),
('Kshitija Raut', 'MBA', 2003, 'Female', '9873214560', 'Kshitija1234@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `book_details`
--
ALTER TABLE `book_details`
  ADD PRIMARY KEY (`b_id`);

--
-- Indexes for table `issue_details`
--
ALTER TABLE `issue_details`
  ADD PRIMARY KEY (`s_rollno`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`s_rollno`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
