
-- =========================================================
-- DHL DELIVERY PERFORMANCE | SQL ANALYTICS CASE STUDY
-- 01_DATABASE_SETUP.SQL
-- Author: Nagehan Bas
-- Database: SQLite 3
--
-- Source: Workintech educational datasets
-- 49 shipments | 199 shipment line items
--
-- Customer and tracking fields were cross-referenced
-- against the accompanying Google Sheets dataset.
-- Carrier values are preserved from the supplied SQL.
--
-- Run this script in a fresh SQLite database.
-- =========================================================

PRAGMA foreign_keys = ON;

-- =========================================================
-- 1. CREATE SOURCE TABLES
-- =========================================================

CREATE TABLE shipment (
    shipment_id INTEGER PRIMARY KEY,
    tracking_url TEXT,
    carrier TEXT,
    urgency TEXT,
    order_date DATE,
    dispatch_date DATE,
    arrival_date DATE,
    cancel_date DATE,
    customer_name TEXT,
    customer_surname TEXT,
    tracking_code TEXT
);

CREATE TABLE shipment_item (
    item_id INTEGER PRIMARY KEY,
    shipment_id INTEGER NOT NULL,
    product_name TEXT,
    quantity INTEGER,
    FOREIGN KEY (shipment_id)
        REFERENCES shipment(shipment_id)
);

-- =========================================================
-- 2. INSERT SHIPMENT DATA
-- =========================================================

INSERT INTO shipment (
    shipment_id,
    tracking_url,
    carrier,
    urgency,
    order_date,
    dispatch_date,
    arrival_date,
    cancel_date,
    customer_name,
    customer_surname,
    tracking_code
)
VALUES
(1001,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277744','colissimo','High','2022-04-06','2022-04-09','2022-04-09',NULL,'John','Smith','UPS2166941B'),
(1002,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277745','ups','Medium','2022-04-07','2022-04-10',NULL,'2022-04-17','Emma','Johnson','UPS4823498Y'),
(1003,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277746','colissimo','High','2022-04-08','2022-04-10','2022-04-13',NULL,'Michael','Brown','UPS2338687H'),
(1004,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277747','colissimo','Low','2022-05-25','2022-05-28','2022-05-30',NULL,'Olivia','Davis','DHL7377459I'),
(1005,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277748','colissimo','Low','2022-06-01','2022-06-05','2022-06-08',NULL,'William','Miller','DHL7120868F'),
(1006,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277749','colissimo','High','2022-05-31','2022-06-04','2022-06-06',NULL,'Sophia','Wilson','UPS6960453G'),
(1007,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277750','colissimo','Low','2022-06-03','2022-06-04','2022-06-06',NULL,'James','Moore','UPS5479144W'),
(1008,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277751','ups','Medium','2022-06-03','2022-06-04','2022-06-07',NULL,'Isabella','Taylor','UPS3871230R'),
(1009,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277752','colissimo','High','2022-06-03','2022-06-04','2022-06-07',NULL,'Benjamin','Anderson','UPS5107245F'),
(1010,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277753','colissimo','Medium','2022-06-16','2022-06-17','2022-06-19',NULL,'Mia','Thomas','UPS7366205I'),
(1011,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277754','colissimo','High','2022-06-17','2022-06-19','2022-06-19',NULL,'Lucas','Jackson','UPS4684531V'),
(1012,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277755','colissimo','High','2022-06-23','2022-06-26','2022-06-28',NULL,'Charlotte','White','UPS1938483H'),
(1013,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277756','colissimo','High','2022-06-23','2022-06-27','2022-06-29',NULL,'Henry','Harris','DHL6292423M'),
(1014,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277757','colissimo','Low','2022-06-22','2022-06-25','2022-06-27',NULL,'Amelia','Martin','DHL2110460G'),
(1015,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277758','colissimo','High','2022-06-25','2022-06-25',NULL,'2022-07-04','Alexander','Thompson','Colissimo4567281U'),
(1016,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277759','colissimo','High','2022-06-23','2022-06-25','2022-06-29',NULL,'Harper','Garcia','Colissimo7637601U'),
(1017,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277760','colissimo','High','2022-07-14','2022-07-16','2022-07-17',NULL,'Daniel','Martinez','DHL3396987I'),
(1018,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277761','colissimo','Medium','2022-07-15','2022-07-18','2022-07-19',NULL,'Evelyn','Robinson','UPS5137722X'),
(1019,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277762','colissimo','High','2022-07-16','2022-07-18','2022-07-20',NULL,'Matthew','Clark','UPS8187926S'),
(1020,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277763','colissimo','High','2022-07-22','2022-07-24',NULL,'2022-08-08','Abigail','Rodriguez','DHL7073292H'),
(1021,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277764','colissimo','Low','2022-07-22','2022-07-26','2022-07-28',NULL,'Joseph','Lewis','Colissimo9548432P'),
(1022,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277765','colissimo','High','2022-07-25','2022-07-26','2022-07-29',NULL,'Emily','Lee','UPS1790481D'),
(1023,'https://www.ups.com/WebTracking/processInputRequest?tracknum=1Z0W264A0433253204&loc=fr_FR','colissimo','High','2022-07-25','2022-07-26',NULL,NULL,'David','Walker','UPS3684052Z'),
(1024,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277762','colissimo','High','2022-08-05','2022-08-07','2022-08-09',NULL,'Ella','Hall','UPS2065818M'),
(1025,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277763','colissimo','Medium','2022-08-05','2022-08-07','2022-08-13',NULL,'Samuel','Allen','UPS8852574Q'),
(1026,'https://www.ups.com/WebTracking/processInputRequest?tracknum=1Z0W264A6836860325&loc=fr_FR','ups','High','2022-08-05','2022-08-07','2022-08-07',NULL,'Avery','Young','UPS1192619V'),
(1027,'https://www.ups.com/WebTracking/processInputRequest?tracknum=1Z0W264A6812985094&loc=fr_FR','ups','High','2022-08-05','2022-08-07','2022-08-09',NULL,'Sebastian','King','UPS2921859V'),
(1028,'https://www.ups.com/WebTracking/processInputRequest?tracknum=1Z0W264A6839429939&loc=fr_FR','ups','High','2022-08-05','2022-08-07','2022-08-09',NULL,'Scarlett','Wright','UPS5476583Y'),
(1029,'https://www.ups.com/WebTracking/processInputRequest?tracknum=1Z0W264A6807664888&loc=fr_FR','ups','Low','2022-08-05','2022-08-06','2022-08-08',NULL,'Jack','Scott','UPS6707197D'),
(1030,'https://www.ups.com/WebTracking/processInputRequest?tracknum=1Z0W264A6803768274&loc=fr_FR','ups','High','2022-08-05','2022-08-07','2022-08-08',NULL,'Grace','Green','Colissimo8294150F'),
(1031,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277762','colissimo','Medium','2022-08-06','2022-08-08','2022-08-09',NULL,'Owen','Baker','Colissimo1054447X'),
(1032,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277763','colissimo','High','2022-08-26','2022-08-28','2022-08-30',NULL,'Chloe','Adams','Colissimo9398441Y'),
(1033,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277764','colissimo','Medium','2022-08-25','2022-08-28','2022-08-29',NULL,'Gabriel','Nelson','Colissimo9517485D'),
(1034,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277765','colissimo','High','2022-08-26','2022-08-28','2022-08-30',NULL,'Victoria','Hill','DHL9517169T'),
(1035,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277766','colissimo','High','2022-08-29','2022-08-31','2022-09-02',NULL,'Carter','Ramirez','UPS3564217L'),
(1036,'https://www.ups.com/WebTracking/processInputRequest?tracknum=1Z0W264A6819701850&loc=fr_FR','colissimo','Low','2022-08-29','2022-08-31','2022-09-02',NULL,'Lily','Campbell','UPS9897858A'),
(1037,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277762','colissimo','High','2022-08-30','2022-09-01','2022-09-03',NULL,'Jayden','Mitchell','UPS6438436P'),
(1038,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277763','colissimo','High','2022-08-31','2022-09-04','2022-09-04',NULL,'Hannah','Roberts','UPS2876828L'),
(1039,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277764','colissimo','Medium','2022-09-07','2022-09-10',NULL,NULL,'Luke','Carter','Colissimo5017343B'),
(1040,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277765','colissimo','High','2022-09-09','2022-09-10',NULL,NULL,'Zoe','Phillips','UPS2321324C'),
(1041,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277766','ups','High','2022-09-09','2022-09-10',NULL,NULL,'Anthony','Evans','UPS2161193Y'),
(1042,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277767','colissimo','Medium','2022-09-09','2022-09-11',NULL,NULL,'Nora','Turner','DHL3109911E'),
(1043,'https://www.ups.com/WebTracking/processInputRequest?tracknum=1Z0W264A6808017950&loc=fr_FR','ups','High','2022-09-09','2022-09-12',NULL,NULL,'Isaac','Torres','DHL3770370I'),
(1044,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277762','colissimo','High','2022-09-09','2022-09-11',NULL,NULL,'Layla','Parker','DHL8099076G'),
(1045,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277763','colissimo','Medium','2022-09-14','2022-09-16',NULL,NULL,'Christian','Collins','DHL4374754W'),
(1046,'https://www.ups.com/WebTracking/processInputRequest?tracknum=1Z0W264A6811916375&loc=fr_FR','ups','High','2022-09-15','2022-09-16',NULL,NULL,'Aria','Edwards','UPS7693979V'),
(1047,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277762','colissimo','Medium','2022-09-15','2022-09-16',NULL,NULL,'Andrew','Stewart','DHL8350099Q'),
(1048,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277763','ups','High','2022-09-16',NULL,NULL,NULL,'Aurora','Flores','DHL3030113H'),
(1049,'https://www.colissimo.fr/entreprise/colis/login?sid=07b5b5cdb5da7611055460146bdbb679&cab=9C00474277764','colissimo','High','2022-09-19',NULL,NULL,NULL,'Joshua','Morris','Colissimo2074176K');

-- =========================================================
-- 3. INSERT SHIPMENT ITEM DATA
-- =========================================================

INSERT INTO shipment_item (item_id, shipment_id, product_name, quantity)
VALUES
(1,1049,'Short de sport femme',1),
(2,1049,'Short de sport homme',1),
(3,1049,'T-shirt Iconic Manifesto',1),
(4,1049,'T-shirt sport - Original',3),
(5,1048,'Brassière sport - Imparable',15),
(6,1048,'Legging - Inséparable',3),
(7,1048,'Short de sport femme',6),
(8,1047,'Short de sport homme',4),
(9,1047,'T-shirt Iconic Manifesto',3),
(10,1047,'T-shirt sport - Original',5),
(11,1046,'Legging - Inséparable',50),
(12,1046,'T-shirt sport - Original',20),
(13,1046,'T-shirt Iconic Manifesto',40),
(14,1046,'Brassière sport - Imparable',22),
(15,1046,'T-shirt sport - Original',52),
(16,1045,'Short de sport femme',5),
(17,1044,'Legging - Inséparable',7),
(18,1044,'T-shirt sport - Original',1),
(19,1044,'Short de sport homme',1),
(20,1044,'T-shirt Iconic Manifesto',3),
(21,1044,'T-shirt Iconic Manifesto',3),
(22,1043,'Brassière sport - Imparable',3),
(23,1043,'Legging - Inséparable',1),
(24,1043,'Short de sport femme',28),
(25,1043,'Short de sport homme',34),
(26,1043,'T-shirt Iconic Manifesto',4),
(27,1043,'T-shirt sport - Original',5),
(28,1042,'Brassière sport - Imparable',2),
(29,1042,'Legging - Inséparable',6),
(30,1042,'Short de sport femme',5),
(31,1042,'T-shirt sport - Original',4),
(32,1041,'Brassière sport - Imparable',1),
(33,1041,'Legging - Inséparable',1),
(34,1040,'Legging - Inséparable',6),
(35,1040,'Short de sport femme',1),
(36,1040,'Short de sport homme',6),
(37,1040,'T-shirt Iconic Manifesto',8),
(38,1040,'T-shirt sport - Original',3),
(39,1039,'Short de sport homme',3),
(40,1039,'T-shirt Iconic Manifesto',2),
(41,1039,'T-shirt sport - Original',4),
(42,1038,'Brassière sport - Imparable',2),
(43,1038,'T-shirt Iconic Manifesto',15),
(44,1038,'T-shirt sport - Original',3),
(45,1037,'Short de sport homme',6),
(46,1037,'T-shirt Iconic Manifesto',16),
(47,1037,'T-shirt sport - Original',2),
(48,1036,'Short de sport femme',7),
(49,1036,'Short de sport homme',8),
(50,1036,'T-shirt sport - Original',2),
(51,1036,'T-shirt sport - Original',1),
(52,1035,'T-shirt Iconic Manifesto',4),
(53,1034,'Short de sport femme',8),
(54,1034,'Short de sport homme',14),
(55,1034,'T-shirt Iconic Manifesto',1),
(56,1034,'T-shirt sport - Original',1),
(57,1033,'Brassière sport - Imparable',4),
(58,1033,'Legging - Inséparable',7),
(59,1033,'T-shirt sport - Original',2),
(60,1033,'Short de sport homme',10),
(61,1033,'T-shirt Iconic Manifesto',10),
(62,1033,'T-shirt sport - Original',5),
(63,1032,'Brassière sport - Imparable',4),
(64,1032,'Legging - Inséparable',2),
(65,1032,'Short de sport femme',1),
(66,1032,'Short de sport homme',6),
(67,1032,'T-shirt Iconic Manifesto',11),
(68,1032,'T-shirt sport - Original',4),
(69,1031,'Brassière sport - Imparable',2),
(70,1031,'Legging - Inséparable',6),
(71,1031,'Short de sport femme',8),
(72,1031,'Short de sport homme',2),
(73,1031,'T-shirt Iconic Manifesto',3),
(74,1031,'T-shirt sport - Original',5),
(75,1030,'Legging - Inséparable',5),
(76,1030,'T-shirt Iconic Manifesto',2),
(77,1030,'T-shirt Iconic Manifesto',3),
(78,1030,'T-shirt sport - Original',5),
(79,1030,'Short de sport femme',8),
(80,1029,'Brassière sport - Imparable',3),
(81,1029,'Legging - Inséparable',10),
(82,1029,'Short de sport femme',4),
(83,1029,'Short de sport homme',2),
(84,1029,'T-shirt Iconic Manifesto',35),
(85,1029,'T-shirt sport - Original',1),
(86,1028,'Brassière sport - Imparable',1),
(87,1028,'Legging - Inséparable',1),
(88,1028,'Short de sport homme',3),
(89,1028,'T-shirt sport - Original',1),
(90,1027,'Brassière sport - Imparable',1),
(91,1027,'Legging - Inséparable',1),
(92,1027,'Short de sport femme',2),
(93,1027,'T-shirt Iconic Manifesto',37),
(94,1026,'Brassière sport - Imparable',2),
(95,1026,'Legging - Inséparable',1),
(96,1026,'Short de sport femme',2),
(97,1026,'T-shirt sport - Original',37),
(98,1026,'Short de sport homme',2),
(99,1025,'Brassière sport - Imparable',2),
(100,1025,'Legging - Inséparable',2),
(101,1025,'Short de sport femme',8),
(102,1025,'Short de sport homme',1),
(103,1025,'T-shirt Iconic Manifesto',8),
(104,1025,'T-shirt sport - Original',4),
(105,1024,'Short de sport femme',12),
(106,1024,'Short de sport homme',5),
(107,1023,'Short de sport femme',3),
(108,1023,'Short de sport homme',2),
(109,1023,'T-shirt Iconic Manifesto',15),
(110,1023,'T-shirt sport - Original',14),
(111,1022,'T-shirt Iconic Manifesto',11),
(112,1022,'T-shirt sport - Original',3),
(113,1021,'Brassière sport - Imparable',1),
(114,1021,'Legging - Inséparable',2),
(115,1021,'Short de sport femme',2),
(116,1021,'Short de sport homme',1),
(117,1021,'T-shirt Iconic Manifesto',9),
(118,1021,'T-shirt sport - Original',12),
(119,1020,'Brassière sport - Imparable',13),
(120,1020,'Legging - Inséparable',1),
(121,1020,'Short de sport femme',2),
(122,1020,'Short de sport homme',1),
(123,1020,'T-shirt Iconic Manifesto',3),
(124,1020,'T-shirt sport - Original',3),
(125,1019,'Brassière sport - Imparable',9),
(126,1019,'Legging - Inséparable',8),
(127,1019,'Short de sport femme',3),
(128,1019,'Short de sport homme',24),
(129,1019,'T-shirt Iconic Manifesto',2),
(130,1019,'T-shirt sport - Original',7),
(131,1018,'T-shirt Iconic Manifesto',19),
(132,1017,'T-shirt sport - Original',3),
(133,1016,'Brassière sport - Imparable',12),
(134,1016,'Short de sport homme',1),
(135,1016,'T-shirt Iconic Manifesto',7),
(136,1016,'T-shirt sport - Original',6),
(137,1015,'Brassière sport - Imparable',2),
(138,1015,'Short de sport femme',4),
(139,1015,'Short de sport homme',3),
(140,1015,'T-shirt Iconic Manifesto',61),
(141,1015,'T-shirt sport - Original',8),
(142,1014,'Short de sport femme',3),
(143,1014,'Legging - Inséparable',2),
(144,1014,'Short de sport femme',7),
(145,1014,'Short de sport homme',1),
(146,1014,'T-shirt Iconic Manifesto',1),
(147,1014,'T-shirt sport - Original',6),
(148,1013,'Brassière sport - Imparable',3),
(149,1013,'T-shirt Iconic Manifesto',12),
(150,1013,'T-shirt sport - Original',1),
(151,1012,'Brassière sport - Imparable',4),
(152,1012,'Legging - Inséparable',2),
(153,1012,'Short de sport femme',8),
(154,1012,'Short de sport homme',1),
(155,1012,'T-shirt Iconic Manifesto',22),
(156,1012,'T-shirt sport - Original',48),
(157,1011,'Brassière sport - Imparable',1),
(158,1011,'Legging - Inséparable',4),
(159,1011,'Brassière sport - Imparable',16),
(160,1011,'Short de sport homme',6),
(161,1011,'Short de sport femme',6),
(162,1011,'T-shirt sport - Original',4),
(163,1010,'Brassière sport - Imparable',3),
(164,1010,'Short de sport femme',2),
(165,1010,'Short de sport homme',11),
(166,1010,'T-shirt Iconic Manifesto',2),
(167,1010,'T-shirt sport - Original',4),
(168,1009,'Brassière sport - Imparable',8),
(169,1009,'T-shirt sport - Original',27),
(170,1008,'Short de sport homme',1),
(171,1008,'Legging - Inséparable',1),
(172,1008,'Short de sport femme',3),
(173,1008,'T-shirt Iconic Manifesto',1),
(174,1008,'T-shirt sport - Original',4),
(175,1007,'Brassière sport - Imparable',6),
(176,1007,'Legging - Inséparable',6),
(177,1007,'Short de sport femme',6),
(178,1007,'Short de sport homme',3),
(179,1007,'T-shirt Iconic Manifesto',5),
(180,1007,'T-shirt sport - Original',22),
(181,1006,'Short de sport homme',23),
(182,1005,'T-shirt Iconic Manifesto',6),
(183,1005,'T-shirt sport - Original',3),
(184,1004,'Brassière sport - Imparable',3),
(185,1004,'Legging - Inséparable',5),
(186,1004,'Short de sport femme',1),
(187,1004,'Short de sport homme',2),
(188,1004,'T-shirt Iconic Manifesto',2),
(189,1004,'T-shirt sport - Original',5),
(190,1003,'Brassière sport - Imparable',2),
(191,1003,'Legging - Inséparable',11),
(192,1003,'Short de sport femme',4),
(193,1003,'Short de sport homme',4),
(194,1003,'T-shirt Iconic Manifesto',22),
(195,1003,'T-shirt sport - Original',152),
(196,1002,'Short de sport homme',5),
(197,1002,'T-shirt Iconic Manifesto',1),
(198,1002,'Short de sport femme',161),
(199,1001,'T-shirt sport - Original',46);

-- =========================================================
-- 4. DATA VALIDATION
-- =========================================================

SELECT 'shipment' AS table_name, COUNT(*) AS row_count
FROM shipment

UNION ALL

SELECT 'shipment_item', COUNT(*)
FROM shipment_item;

PRAGMA foreign_key_check;

-- Expected:
-- shipment      49
-- shipment_item 199
-- No foreign key violations
