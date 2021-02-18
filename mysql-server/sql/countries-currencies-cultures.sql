-- MySQL dump 10.13  Distrib 8.0.12, for Linux (x86_64)
--
-- Host: localhost    Database: world
-- ------------------------------------------------------
-- Server version	8.0.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `country` (
  `iso_code` varchar(2) NOT NULL,
  `name` varchar(90) NOT NULL,
  `currency` varchar(3) NOT NULL,
  `culture` varchar(10) NOT NULL,
  `is_first_level_division_displayed` bit(1) NOT NULL DEFAULT b'1',
  `first_level_division_title` varchar(45) NOT NULL DEFAULT '',
  `is_second_level_division_displayed` bit(1) NOT NULL DEFAULT b'1',
  `second_level_division_title` varchar(45) NOT NULL DEFAULT '',
  `phone_format` varchar(45) NOT NULL DEFAULT '',
  `nin_title` varchar(45) NOT NULL DEFAULT '',
  `nin_format` varchar(45) NOT NULL DEFAULT '',
  `lat` float NOT NULL,
  `lng` float NOT NULL,
  PRIMARY KEY (`iso_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES ('AD','Andorra','EUR','ca-ES',_binary '\0','',_binary '\0','','','','',42.5,1.6),('AE','United Arab Emirates','AED','ar-AE',_binary '\0','',_binary '\0','','','','',24,54),('AF','Afghanistan','AFA','fa-IR',_binary '\0','',_binary '\0','','','','',33,65),('AG','Antigua And Barbuda','XCD','en-CB',_binary '','Parish',_binary '\0','','','NID','',17.05,-61.8),('AI','Anguilla','XCD','en-CB',_binary '','District',_binary '\0','','','NID','',18.25,-63.17),('AL','Albania','ALL','sq-AL',_binary '\0','',_binary '\0','','','','',41,20),('AM','Armenia','AMD','hy-AM',_binary '\0','',_binary '\0','','','','',40,45),('AN','Netherlands Antilles','ANG','nl',_binary '\0','',_binary '\0','','','','',12.25,-68.75),('AO','Angola','AOA','pt',_binary '\0','',_binary '\0','','','','',-12.5,18.5),('AQ','Antarctica','USD','en',_binary '\0','',_binary '\0','','','','',-90,0),('AR','Argentina','ARS','es-AR',_binary '\0','',_binary '\0','','','','',-34,-64),('AS','American Samoa','USD','en',_binary '\0','',_binary '\0','','','','',-14.33,-170),('AT','Austria','EUR','de-AT',_binary '\0','',_binary '\0','','','','',47.33,13.33),('AU','Australia','AUD','en',_binary '\0','',_binary '\0','','','','',-27,133),('AW','Aruba','AWG','nl',_binary '','Districts',_binary '\0','','','NID','',12.5,-69.97),('AX','Åland Islands','EUR','en',_binary '\0','',_binary '\0','','','','',0,0),('AZ','Azerbaijan','AZM','az-latn-AZ',_binary '\0','',_binary '\0','','','','',40.5,47.5),('BA','Bosnia And Herzegovina','BAM','sr-latn',_binary '\0','',_binary '\0','','','','',44,18),('BB','Barbados','BBD','en',_binary '','Parish',_binary '\0','','','NRN','',13.17,-59.53),('BD','Bangladesh','BDT','bn-BD',_binary '\0','',_binary '\0','','','','',24,90),('BE','Belgium','EUR','nl-BE',_binary '\0','',_binary '\0','','','','',50.83,4),('BF','Burkina Faso','XOF','fr',_binary '\0','',_binary '\0','','','','',13,-2),('BG','Bulgaria','BGN','bg-BG',_binary '\0','',_binary '\0','','','','',43,25),('BH','Bahrain','BHD','ar-BH',_binary '\0','',_binary '\0','','','','',26,50.55),('BI','Burundi','BIF','fr',_binary '\0','',_binary '\0','','','','',-3.5,30),('BJ','Benin','XOF','fr',_binary '\0','',_binary '\0','','','','',9.5,2.25),('BM','Bermuda','BMD','en',_binary '','Parish',_binary '\0','','','NID','',32.33,-64.75),('BN','Brunei Darussalam','BND','en',_binary '\0','',_binary '\0','','','','',4.5,114.67),('BO','Bolivia','BOB','es-BO',_binary '\0','',_binary '\0','','','','',-17,-65),('BR','Brazil','BRL','pt-BR',_binary '\0','',_binary '\0','','','','',-10,-55),('BS','Bahamas','BSD','en',_binary '','District',_binary '\0','','','Tax Identification Number','####',24.25,-76),('BT','Bhutan','BTN','en',_binary '\0','',_binary '\0','','','','',27.5,90.5),('BV','Bouvet Island','NOK','en',_binary '\0','',_binary '\0','','','','',-54.43,3.4),('BW','Botswana','BWP','en',_binary '\0','',_binary '\0','','','','',-22,24),('BY','Belarus','BYR','be-BY',_binary '\0','',_binary '\0','','','','',53,28),('BZ','Belize','BZD','en',_binary '','District',_binary '\0','','','NID','',17.25,-88.75),('CA','Canada','CAD','en',_binary '','Provinces',_binary '\0','','','SIN','###-###-###',60,-95),('CC','Cocos (Keeling) Islands','AUD','en',_binary '\0','',_binary '\0','','','','',-12.5,96.83),('CD','Congo, The Democratic Republic Of The','CDF','fr',_binary '\0','',_binary '\0','','','','',0,25),('CF','Central African Republic','XAF','fr',_binary '\0','',_binary '\0','','','','',7,21),('CG','Congo','XAF','fr',_binary '\0','',_binary '\0','','','','',-1,15),('CH','Switzerland','CHF','de-CH',_binary '\0','',_binary '\0','','','','',47,8),('CI','Cote D\'Ivoire','XOF','fr',_binary '\0','',_binary '\0','','','','',8,-5),('CK','Cook Islands','NZD','en',_binary '\0','',_binary '\0','','','','',-21.23,-159.77),('CL','Chile','CLP','es-CL',_binary '\0','',_binary '\0','','','','',-30,-71),('CM','Cameroon','XAF','en',_binary '\0','',_binary '\0','','','','',6,12),('CN','China','CNY','en',_binary '\0','',_binary '\0','','','','',35,105),('CO','Colombia','COP','es-CO',_binary '\0','',_binary '\0','','','','',4,-72),('CR','Costa Rica','CRC','es-CR',_binary '\0','',_binary '\0','','','','',10,-84),('CU','Cuba','CUP','en',_binary '','Provinces',_binary '\0','','','NIN','',21.5,-80),('CV','Cape Verde','CVE','en',_binary '\0','',_binary '\0','','','','',16,-24),('CX','Christmas Island','AUD','en',_binary '\0','',_binary '\0','','','','',-10.5,105.67),('CY','Cyprus','CYP','en',_binary '\0','',_binary '\0','','','','',35,33),('CZ','Czech Republic','CZK','en',_binary '\0','',_binary '\0','','','','',49.75,15.5),('DE','Germany','EUR','de-DE',_binary '\0','',_binary '\0','','','','',51,9),('DJ','Djibouti','DJF','fr',_binary '\0','',_binary '\0','','','','',11.5,43),('DK','Denmark','DKK','en',_binary '\0','',_binary '\0','','','','',56,10),('DM','Dominica','XCD','en-CB',_binary '','Parish',_binary '\0','','','NID','',15.42,-61.33),('DO','Dominican Republic','DOP','es-DO',_binary '','Province',_binary '\0','','','NIN','',19,-70.67),('DZ','Algeria','DZD','ar-DZ',_binary '\0','',_binary '\0','','','','',28,3),('EC','Ecuador','USD','es-EC',_binary '\0','',_binary '\0','','','','',-2,-77.5),('EE','Estonia','EEK','en',_binary '\0','',_binary '\0','','','','',59,26),('EG','Egypt','EGP','ar-EG',_binary '\0','',_binary '\0','','','','',27,30),('EH','Western Sahara','MAD','en',_binary '\0','',_binary '\0','','','','',24.5,-13),('ER','Eritrea','ETB','en',_binary '\0','',_binary '\0','','','','',15,39),('ES','Spain','EUR','es-ES',_binary '\0','',_binary '\0','','','','',40,-4),('ET','Ethiopia','ETB','en',_binary '\0','',_binary '\0','','','','',8,38),('FI','Finland','EUR','en',_binary '\0','',_binary '\0','','','','',64,26),('FJ','Fiji','FJD','en',_binary '\0','',_binary '\0','','','','',-18,175),('FK','Falkland Islands (Malvinas)','FKP','en',_binary '\0','',_binary '\0','','','','',-51.75,-59),('FM','Micronesia, Federated States Of','USD','en',_binary '\0','',_binary '\0','','','','',6.92,158.25),('FO','Faroe Islands','DKK','en',_binary '\0','',_binary '\0','','','','',62,-7),('FR','France','EUR','fr-FR',_binary '\0','',_binary '\0','','','','',46,2),('GA','Gabon','XAF','fr',_binary '\0','',_binary '\0','','','','',-1,11.75),('GB','United Kingdom','GBP','en-GB',_binary '','Province',_binary '','County','','NINO','###-###-####',54,-2),('GD','Grenada','XCD','en-CB',_binary '\0','',_binary '\0','','','','',12.12,-61.67),('GE','Georgia','GEL','en',_binary '\0','',_binary '\0','','','','',42,43.5),('GF','French Guiana','EUR','en',_binary '\0','',_binary '\0','','','','',4,-53),('GG','Guernsey','GGP','en',_binary '\0','',_binary '\0','','','','',49.5,-2.56),('GH','Ghana','GHC','en',_binary '\0','',_binary '\0','','','','',8,-2),('GI','Gibraltar','GIP','en',_binary '\0','',_binary '\0','','','','',36.18,-5.37),('GL','Greenland','DKK','en',_binary '\0','',_binary '\0','','','','',66.44,-46.34),('GM','Gambia','GMD','en',_binary '\0','',_binary '\0','','','','',13.47,-16.57),('GN','Guinea','GNF','fr',_binary '\0','',_binary '\0','','','','',11,-10),('GP','Guadeloupe','EUR','en',_binary '\0','',_binary '\0','','','','',16.25,-61.58),('GQ','Equatorial Guinea','XAF','fr',_binary '\0','',_binary '\0','','','','',2,10),('GR','Greece','EUR','el-GR',_binary '\0','',_binary '\0','','','','',39,22),('GS','South Georgia And The South Sandwich Islands','GBP','en',_binary '\0','',_binary '\0','','','','',-54.5,-37),('GT','Guatemala','GTQ','es-GT',_binary '\0','',_binary '\0','','','','',15.5,-90.25),('GU','Guam','USD','en',_binary '\0','',_binary '\0','','','','',13.47,144.78),('GW','Guinea-Bissau','XOF','en',_binary '\0','',_binary '\0','','','','',12,-15),('GY','Guyana','GYD','en-GY',_binary '','Region',_binary '\0','','011-(592)-###-####','','',5,-59),('HK','Hong Kong','HKD','en',_binary '\0','',_binary '\0','','','','',22.25,114.17),('HM','Heard Island And Mcdonald Islands','AUD','en',_binary '\0','',_binary '\0','','','','',-53.1,72.52),('HN','Honduras','HNL','es-HN',_binary '\0','',_binary '\0','','','','',15,-86.5),('HR','Croatia','HRK','en',_binary '\0','',_binary '\0','','','','',45.17,15.5),('HT','Haiti','HTG','fr',_binary '\0','',_binary '\0','','','','',19,-72.42),('HU','Hungary','HUF','en',_binary '\0','',_binary '\0','','','','',47,20),('ID','Indonesia','IDR','en',_binary '\0','',_binary '\0','','','','',-5,120),('IE','Ireland','EUR','en',_binary '\0','',_binary '\0','','','','',53,-8),('IL','Israel','ILS','en',_binary '\0','',_binary '\0','','','','',31.5,34.75),('IN','India','INR','en',_binary '\0','',_binary '\0','','','','',20,77),('IO','British Indian Ocean Territory','USD','en',_binary '\0','',_binary '\0','','','','',-6,71.5),('IQ','Iraq','IQD','ar-IQ',_binary '\0','',_binary '\0','','','','',33,44),('IR','Iran, Islamic Republic Of','IRR','fa-IR',_binary '\0','',_binary '\0','','','','',32,53),('IS','Iceland','ISK','en',_binary '\0','',_binary '\0','','','','',65,-18),('IT','Italy','EUR','en',_binary '\0','',_binary '\0','','','','',42.83,12.83),('JE','Jersey','JEP','en',_binary '\0','',_binary '\0','','','','',49.21,-2.13),('JM','Jamaica','JMD','en-JM',_binary '\0','County',_binary '','Parish','1-(876)-###-####?-#','TRN','###-###-###',18.15,-76.76),('JO','Jordan','JOD','ar-JO',_binary '\0','',_binary '\0','','','','',31,36),('JP','Japan','JPY','en',_binary '\0','',_binary '\0','','','','',36,138),('KE','Kenya','KES','en',_binary '\0','',_binary '\0','','','','',1,38),('KG','Kyrgyzstan','KGS','en',_binary '\0','',_binary '\0','','','','',41,75),('KH','Cambodia','KHR','km-KH',_binary '\0','',_binary '\0','','','','',13,105),('KI','Kiribati','AUD','en',_binary '\0','',_binary '\0','','','','',1.42,173),('KM','Comoros','KMF','fr',_binary '\0','',_binary '\0','','','','',-12.17,44.25),('KN','Saint Kitts And Nevis','XCD','en-CB',_binary '','Parish',_binary '\0','','','NID','',17.33,-62.75),('KP','Korea, Democratic People\'s Republic Of','KPW','ko-KR',_binary '\0','',_binary '\0','','','','',40,127),('KR','Korea, Republic Of','KRW','ko-KR',_binary '\0','',_binary '\0','','','','',37,127.5),('KW','Kuwait','KWD','ar-KW',_binary '\0','',_binary '\0','','','','',29.34,47.66),('KY','Cayman Islands','KYD','en',_binary '','District',_binary '\0','','','NID','',19.5,-80.5),('KZ','Kazakhstan','KZT','en',_binary '\0','',_binary '\0','','','','',48,68),('LA','Lao People\'s Democratic Republic','LAK','lo',_binary '\0','',_binary '\0','','','','',18,105),('LB','Lebanon','LBP','ar-LB',_binary '\0','',_binary '\0','','','','',33.83,35.83),('LC','Saint Lucia','XCD','en-CB',_binary '','District',_binary '\0','','','NID','',13.88,-61.13),('LI','Liechtenstein','CHF','de-LI',_binary '\0','',_binary '\0','','','','',47.17,9.53),('LK','Sri Lanka','LKR','en',_binary '\0','',_binary '\0','','','','',7,81),('LR','Liberia','LRD','en',_binary '\0','',_binary '\0','','','','',6.5,-9.5),('LS','Lesotho','LSL','en',_binary '\0','',_binary '\0','','','','',-29.5,28.5),('LT','Lithuania','LTL','en',_binary '\0','',_binary '\0','','','','',56,24),('LU','Luxembourg','EUR','fr-LU',_binary '\0','',_binary '\0','','','','',49.75,6.17),('LV','latvia','LVL','en',_binary '\0','',_binary '\0','','','','',57,25),('LY','Libyan Arab Jamahiriya','LYD','ar-LY',_binary '\0','',_binary '\0','','','','',25,17),('MA','Morocco','MAD','ar-MA',_binary '\0','',_binary '\0','','','','',32,-5),('MC','Monaco','EUR','fr-MC',_binary '\0','',_binary '\0','','','','',43.73,7.4),('MD','Moldova, Republic Of','MDL','ro',_binary '\0','',_binary '\0','','','','',47,29),('ME','Montenegro','EUR','en',_binary '\0','',_binary '\0','','','##-##-###-##-###-#','',42,19),('MG','Madagascar','MGA','fr',_binary '\0','',_binary '\0','','','','',-20,47),('MH','Marshall Islands','USD','en',_binary '\0','',_binary '\0','','','','',9,168),('MK','Macedonia, The Former Yugoslav Republic Of','MKD','mk',_binary '\0','',_binary '\0','','','','',41.83,22),('ML','Mali','XOF','fr',_binary '\0','',_binary '\0','','','','',17,-4),('MM','Burma','MMK','my',_binary '\0','',_binary '\0','','','','',22,98),('MN','Mongolia','MNT','en',_binary '\0','',_binary '\0','','','','',46,105),('MO','Macau','MOP','zh-MO',_binary '\0','',_binary '\0','','','','',22.17,113.55),('MP','Northern Mariana Islands','USD','en',_binary '\0','',_binary '\0','','','','',15.2,145.75),('MQ','Martinique','EUR','en',_binary '\0','',_binary '\0','','','','',14.67,-61),('MR','Mauritania','MRO','en',_binary '\0','',_binary '\0','','','','',20,-12),('MS','Montserrat','XCD','en-CB',_binary '','Parish',_binary '\0','','','TN','###-#-###',16.75,-62.2),('MT','Malta','MTL','en',_binary '\0','',_binary '\0','','','','',35.83,14.58),('MU','Mauritius','MUR','en',_binary '\0','',_binary '\0','','','','',-20.28,57.55),('MV','Maldives','MVR','dv',_binary '\0','',_binary '\0','','','','',3.25,73),('MW','Malawi','MWK','en',_binary '\0','',_binary '\0','','','','',-13.5,34),('MX','Mexico','MXN','es-MX',_binary '\0','',_binary '\0','','','','',23,-102),('MY','Malaysia','MYR','en',_binary '\0','',_binary '\0','','','','',2.5,112.5),('MZ','Mozambique','MZM','en',_binary '\0','',_binary '\0','','','','',-18.25,35),('NA','Namibia','NAD','en',_binary '\0','',_binary '\0','','','','',-22,17),('NC','New Caledonia','XPF','fr',_binary '\0','',_binary '\0','','','','',-21.5,165.5),('NE','Niger','XOF','fr',_binary '\0','',_binary '\0','','','','',16,8),('NF','Norfolk Island','AUD','en',_binary '\0','',_binary '\0','','','','',-29.03,167.95),('NG','Nigeria','NGN','en',_binary '\0','',_binary '\0','','','','',10,8),('NI','Nicaragua','NIO','es-NI',_binary '\0','',_binary '\0','','','','',13,-85),('NL','Netherlands','EUR','nl-NL',_binary '\0','',_binary '\0','','','','',52.5,5.75),('NO','Norway','NOK','en',_binary '\0','',_binary '\0','','','','',62,10),('NP','Nepal','NPR','en',_binary '\0','',_binary '\0','','','','',28,84),('NR','Nauru','AUD','en',_binary '\0','',_binary '\0','','','','',-0.53,166.92),('NU','Niue','NZD','en',_binary '\0','',_binary '\0','','','','',-19.03,-169.87),('NZ','New Zealand','NZD','en',_binary '\0','',_binary '\0','','','','',-41,174),('OM','Oman','OMR','ar-OM',_binary '\0','',_binary '\0','','','','',21,57),('PA','Panama','PAB','es-PA',_binary '\0','',_binary '\0','','','','',9,-80),('PE','Peru','PEN','es-PE',_binary '\0','',_binary '\0','','','','',-10,-76),('PF','French Polynesia','XPF','fr',_binary '\0','',_binary '\0','','','','',-15,-140),('PG','Papua New Guinea','PGK','en',_binary '\0','',_binary '\0','','','','',-6,147),('PH','Philippines','PHP','en',_binary '\0','',_binary '\0','','','','',13,122),('PK','Pakistan','PKR','en',_binary '\0','',_binary '\0','','','','',30,70),('PL','Poland','PLN','en',_binary '\0','',_binary '\0','','','','',52,20),('PM','Saint Pierre And Miquelon','EUR','fr',_binary '\0','',_binary '\0','','','','',46.83,-56.33),('PN','Pitcairn','NZD','en',_binary '\0','',_binary '\0','','','','',-24.7,-127.4),('PR','Puerto Rico','USD','es-PR',_binary '\0','',_binary '\0','','','','',18.25,-66.5),('PS','Palestine','ILS','ar',_binary '\0','',_binary '\0','','','','',32,35.25),('PT','Portugal','EUR','en',_binary '\0','',_binary '\0','','','','',39.5,-8),('PW','Palau','USD','en',_binary '\0','',_binary '\0','','','','',7.5,134.5),('PY','Paraguay','PYG','es-PY',_binary '\0','',_binary '\0','','','','',-23,-58),('QA','Qatar','QAR','ar-QA',_binary '\0','',_binary '\0','','','','',25.5,51.25),('RE','Reunion','EUR','fr',_binary '\0','',_binary '\0','','','','',-21.1,55.6),('RO','Romania','RON','en',_binary '\0','',_binary '\0','','','','',46,25),('RS','Serbia','CSD','en',_binary '\0','',_binary '\0','','','','',44,21),('RU','Russian Federation','RUB','ru-RU',_binary '\0','',_binary '\0','','','','',60,100),('RW','Rwanda','RWF','en',_binary '\0','',_binary '\0','','','','',-2,30),('SA','Saudi Arabia','SAR','ar-SA',_binary '\0','',_binary '\0','','','','',25,45),('SB','Solomon Islands','SBD','en',_binary '\0','',_binary '\0','','','','',-8,159),('SC','Seychelles','SCR','fr',_binary '\0','',_binary '\0','','','','',-4.58,55.67),('SD','Sudan','SDD','en',_binary '\0','',_binary '\0','','','','',15,30),('SE','Sweden','SEK','en',_binary '\0','',_binary '\0','','','','',62,15),('SG','Singapore','SGD','en',_binary '\0','',_binary '\0','','','','',1.37,103.8),('SH','Saint Helena','SHP','en',_binary '\0','',_binary '\0','','','','',-15.93,-5.7),('SI','Slovenia','SIT','en',_binary '\0','',_binary '\0','','','','',46,15),('SJ','Svalbard And Jan Mayen','NOK','en',_binary '\0','',_binary '\0','','','','',78,20),('SK','Slovakia','SKK','en',_binary '\0','',_binary '\0','','','','',48.67,19.5),('SL','Sierra Leone','SLL','en',_binary '\0','',_binary '\0','','','','',8.5,-11.5),('SM','San Marino','EUR','en',_binary '\0','',_binary '\0','','','','',43.77,12.42),('SN','Senegal','XOF','fr',_binary '\0','',_binary '\0','','','','',14,-14),('SO','Somalia','SOS','en',_binary '\0','',_binary '\0','','','','',10,49),('SR','Suriname','SRD','en',_binary '\0','',_binary '\0','','','','',4,-56),('ST','São Tomé and Príncipe','STD','pt',_binary '\0','',_binary '\0','','','','',1,7),('SV','El Salvador','SVC','es-SV',_binary '\0','',_binary '\0','','','','',13.83,-88.92),('SY','Syrian Arab Republic','SYP','ar-SY',_binary '\0','',_binary '\0','','','','',35,38),('SZ','Swaziland','SZL','en',_binary '\0','',_binary '\0','','','','',-26.5,31.5),('TC','Turks And Caicos Islands','USD','en',_binary '','District',_binary '\0','','','TIN','',21.75,-71.58),('TD','Chad','XAF','fr',_binary '\0','',_binary '\0','','','','',15,19),('TF','French Southern Territories','EUR','fr',_binary '\0','',_binary '\0','','','','',-43,67),('TG','Togo','XOF','fr',_binary '\0','',_binary '\0','','','','',8,1.17),('TH','Thailand','THB','en',_binary '\0','',_binary '\0','','','','',15,100),('TJ','Tajikistan','RUB','en',_binary '\0','',_binary '\0','','','','',39,71),('TK','Tokelau','NZD','en',_binary '\0','',_binary '\0','','','','',-9,-172),('TL','Timor-Leste','USD','en',_binary '\0','',_binary '\0','','','','',-8.55,125.52),('TM','Turkmenistan','TMM','en',_binary '\0','',_binary '\0','','','','',40,60),('TN','Tunisia','TND','ar-TN',_binary '\0','',_binary '\0','','','','',34,9),('TO','Tonga','TOP','en',_binary '\0','',_binary '\0','','','','',-20,-175),('TR','Turkey','TRL','en',_binary '\0','',_binary '\0','','','','',39,35),('TT','Trinidad And Tobago','TTD','en-TT',_binary '','Regional Corporation',_binary '\0','','1-(868)-###-####','NID','',10.32,-61.31),('TV','Tuvalu','TVD','en',_binary '\0','',_binary '\0','','','','',-8,178),('TW','Taiwan, Province Of China','TWD','zh-TW',_binary '\0','',_binary '\0','','','','',23.5,121),('TZ','Tanzania, United Republic Of','TZS','en',_binary '\0','',_binary '\0','','','','',-6,35),('UA','Ukraine','UAH','en',_binary '\0','',_binary '\0','','','','',49,32),('UG','Uganda','UGX','en',_binary '\0','',_binary '\0','','','','',1,32),('UM','United States Minor Outlying Islands','USD','en',_binary '\0','',_binary '\0','','','','',19.28,166.6),('US','United States','USD','en-US',_binary '','State',_binary '\0','','1-(###)-###-####','SSN','###-##-####',38,-97),('UY','Uruguay','UYU','es-UY',_binary '\0','',_binary '\0','','','','',-33,-56),('UZ','Uzbekistan','UZS','en',_binary '\0','',_binary '\0','','','','',41,64),('VA','Holy See (Vatican City State)','EUR','en',_binary '\0','',_binary '\0','','','','',41.9,12.45),('VC','Saint Vincent And The Grenadines','XCD','en-CB',_binary '','Parish',_binary '\0','','','NID','',13.25,-61.2),('VE','Venezuela','VEB','es-VE',_binary '\0','',_binary '\0','','','','',8,-66),('VG','Virgin Islands, British','GBP','en',_binary '','District',_binary '\0','','','TIN','###-####',18.5,-64.5),('VI','Virgin Islands, U.S.','USD','en',_binary '\0','',_binary '\0','','','','',18.33,-64.83),('VN','Viet Nam','VND','en',_binary '\0','',_binary '\0','','','','',16,106),('VU','Vanuatu','VUV','en',_binary '\0','',_binary '\0','','','','',-16,167),('WF','Wallis And Futuna','XPF','fr',_binary '\0','',_binary '\0','','','','',-13.3,-176.2),('WS','Samoa','WST','en',_binary '\0','',_binary '\0','','','','',-13.58,-172.33),('YE','Yemen','YER','ar-YE',_binary '\0','',_binary '\0','','','','',15,48),('YT','Mayotte','EUR','en',_binary '\0','',_binary '\0','','','','',-12.83,45.17),('ZA','South Africa','ZAR','af-ZA',_binary '','Province',_binary '\0','','','','',-29,24),('ZM','Zambia','ZMK','en',_binary '\0','',_binary '\0','','','','',-15,30),('ZW','Zimbabwe','ZWD','en',_binary '\0','',_binary '\0','','','','',-20,30);
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_first_level_division`
--

DROP TABLE IF EXISTS `country_first_level_division`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `country_first_level_division` (
  `no` bigint(20) NOT NULL AUTO_INCREMENT,
  `country` varchar(2) NOT NULL,
  `name` varchar(90) NOT NULL,
  PRIMARY KEY (`no`),
  UNIQUE KEY `uk_country_first_level_name` (`country`,`name`),
  KEY `fk_country_first_level_division_1_idx` (`country`),
  CONSTRAINT `fk_country_first_level_division_country` FOREIGN KEY (`country`) REFERENCES `country` (`iso_code`)
) ENGINE=InnoDB AUTO_INCREMENT=302 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_first_level_division`
--

LOCK TABLES `country_first_level_division` WRITE;
/*!40000 ALTER TABLE `country_first_level_division` DISABLE KEYS */;
INSERT INTO `country_first_level_division` VALUES (1,'AG','Barbuda'),(2,'AG','Redonda'),(3,'AG','St. George'),(5,'AG','St. John'),(6,'AG','St. Mary'),(7,'AG','St. Paul'),(8,'AG','St. Peter'),(4,'AG','St. Philip'),(9,'AI','Blowing Point'),(10,'AI','East End'),(12,'AI','George Hill'),(13,'AI','Island Harbour'),(14,'AI','North Hill'),(15,'AI','North Side'),(17,'AI','Sandy Ground'),(18,'AI','Sandy Hill'),(19,'AI','South Hill'),(20,'AI','Stoney Ground'),(11,'AI','The Farrington'),(16,'AI','The Quarter'),(21,'AI','The Valley'),(22,'AI','West End'),(23,'AW','Noord'),(24,'AW','Oranjestad'),(25,'AW','Paradera'),(27,'AW','San Nicolaas'),(26,'AW','Santa Cruz'),(28,'AW','Savaneta'),(29,'BB','Christ Church'),(30,'BB','St. Andrew'),(31,'BB','St. George'),(32,'BB','St. James'),(33,'BB','St. John'),(34,'BB','St. Joseph'),(35,'BB','St. Lucy'),(36,'BB','St. Michael'),(38,'BB','St. Peter'),(37,'BB','St. Philip'),(39,'BB','St. Thomas'),(40,'BM','Devonshire'),(41,'BM','Hamilton'),(42,'BM','Paget'),(43,'BM','Pembroke'),(44,'BM','Sandys'),(45,'BM','Smith\'s'),(46,'BM','Southampton'),(47,'BM','St George\'s'),(48,'BM','Warwick'),(49,'BS','Acklins'),(50,'BS','Berry Islands'),(51,'BS','Bimini'),(52,'BS','Black Point'),(55,'BS','Cat Island'),(53,'BS','Central Abaco'),(54,'BS','Central Andros'),(56,'BS','Central Eleuthera'),(57,'BS','City of Freeport'),(58,'BS','Crooked Island'),(59,'BS','East Grand Bahama'),(60,'BS','Exuma'),(61,'BS','Grand Cay'),(62,'BS','Green Turtle Cay'),(63,'BS','Harbour Island'),(64,'BS','Hope Town'),(65,'BS','Inagua'),(66,'BS','Long Island'),(67,'BS','Mangrove Cay'),(69,'BS','Mayaguana'),(68,'BS','Moore\'s Island'),(73,'BS','New Providence'),(70,'BS','North Abaco'),(71,'BS','North Andros'),(72,'BS','North Eleuthera'),(74,'BS','Ragged Island'),(75,'BS','Rum Cay'),(78,'BS','San Salvador'),(76,'BS','South Abaco'),(77,'BS','South Andros'),(79,'BS','South Eleuthera'),(80,'BS','Spanish Wells'),(81,'BS','West Grand Bahama'),(82,'BZ','Belize'),(83,'BZ','Cayo'),(84,'BZ','Corozal'),(85,'BZ','Orange Walk'),(86,'BZ','Stann Creek'),(87,'BZ','Toledo'),(88,'CA','Alberta'),(89,'CA','British Columbia'),(90,'CA','Manitoba'),(91,'CA','New Brunswick'),(92,'CA','Newfoundland and Labrador'),(93,'CA','Nova Scotia'),(94,'CA','Ontario'),(95,'CA','Prince Edward Island'),(96,'CA','Quebec'),(97,'CA','Saskatchewan'),(98,'CU','Artemisa'),(101,'CU','Camagüey'),(99,'CU','Ciego de Ávila'),(100,'CU','Cienfuegos'),(102,'CU','Granma'),(103,'CU','Guantánamo'),(105,'CU','Holguín'),(106,'CU','Isla de la Juventud'),(104,'CU','La Habana'),(107,'CU','Las Tunas'),(108,'CU','Matanzas'),(109,'CU','Mayabeque'),(110,'CU','Pinar del Río'),(112,'CU','Sancti Spíritus'),(111,'CU','Santiago de Cuba'),(113,'CU','Villa Clara'),(114,'DM','Saint Andrew'),(115,'DM','Saint David'),(116,'DM','Saint George'),(117,'DM','Saint John'),(118,'DM','Saint Joseph'),(119,'DM','Saint Luke'),(120,'DM','Saint Mark'),(121,'DM','Saint Patrick'),(122,'DM','Saint Paul'),(123,'DM','Saint Peter'),(124,'DO','Azua'),(125,'DO','Baoruco'),(126,'DO','Barahona'),(127,'DO','Dajabón'),(128,'DO','Distrito Nacional'),(129,'DO','Duarte'),(131,'DO','El Seibo'),(130,'DO','Elías Piña'),(132,'DO','Espaillat'),(134,'DO','Hato Mayor'),(133,'DO','Hermanas Mirabal'),(135,'DO','Independencia'),(136,'DO','La Altagracia'),(137,'DO','La Romana'),(138,'DO','La Vega'),(142,'DO','María Trinidad Sánchez'),(140,'DO','Monseñor Nouel'),(139,'DO','Monte Cristi'),(141,'DO','Monte Plata'),(143,'DO','Pedernales'),(145,'DO','Peravia'),(144,'DO','Puerto Plata'),(150,'DO','Samaná'),(146,'DO','San Cristóbal'),(148,'DO','San José de Ocoa'),(149,'DO','San Juan'),(153,'DO','San Pedro de Macorís'),(154,'DO','Sánchez Ramírez'),(152,'DO','Santiago'),(151,'DO','Santiago Rodríguez'),(147,'DO','Santo Domingo'),(155,'DO','Valverde'),(156,'GB','Channel Islands'),(157,'GB','England'),(158,'GB','Isle Of Man'),(159,'GB','Northern Ireland'),(160,'GB','Scotland'),(161,'GB','Wales'),(162,'GY','Barima-Waini'),(163,'GY','Cuyuni-Mazaruni'),(164,'GY','Demerara-Mahaica'),(165,'GY','East Berbice-Corentyne'),(166,'GY','Essequibo Islands-West Demerara'),(167,'GY','Mahaica-Berbice'),(169,'GY','Pomeroon-Supenaam'),(168,'GY','Potaro-Siparuni'),(170,'GY','Upper Demerara-Berbice'),(171,'GY','Upper Takutu-Upper Essequibo'),(172,'JM','Cornwall'),(173,'JM','Middlesex'),(174,'JM','Surrey'),(175,'KN','Christ Church Nichola Town'),(176,'KN','Saint Anne Sandy Point'),(177,'KN','Saint George Basseterre'),(178,'KN','Saint George Gingerland'),(181,'KN','Saint James Windward'),(179,'KN','Saint John Capesterre'),(180,'KN','Saint John Figtree'),(182,'KN','Saint Mary Cayon'),(184,'KN','Saint Paul Capisterre'),(185,'KN','Saint Paul Charlestown'),(183,'KN','Saint Peter Basseterre'),(186,'KN','Saint Thomas Lowland'),(187,'KN','Saint Thomas Middle Island'),(188,'KN','Trinity Palmetto Point'),(189,'KY','Bodden Town'),(190,'KY','Cayman Brac'),(191,'KY','East End'),(192,'KY','George Town'),(193,'KY','Little Cayman'),(194,'KY','North Side'),(195,'KY','West Bay'),(196,'LC','Anse la Raye'),(197,'LC','Babonneau'),(199,'LC','Canaries'),(200,'LC','Castries'),(198,'LC','Choiseul'),(201,'LC','Dennery'),(202,'LC','Gros Islet'),(203,'LC','Laborie'),(204,'LC','Micoud'),(205,'LC','Soufrière'),(206,'LC','Vieux Fort'),(207,'MS','St. Anthony'),(208,'MS','St. Georges'),(209,'MS','St. Peter'),(210,'TC','Grand Turk'),(211,'TC','Middle Caicos'),(212,'TC','North Caicos'),(213,'TC','Providenciales'),(215,'TC','Salt Cay'),(214,'TC','South Caicos'),(216,'TT','Arima'),(217,'TT','Chaguanas'),(218,'TT','Couva-Tabaquite-Talparo'),(219,'TT','Diego Martin'),(220,'TT','Penal-Debe'),(223,'TT','Point Fortin'),(221,'TT','Port of Spain'),(222,'TT','Princes Town'),(224,'TT','Rio Claro-Mayaro '),(227,'TT','San Fernando'),(226,'TT','San Juan-Laventille'),(228,'TT','Sangre Grande'),(225,'TT','Siparia'),(229,'TT','Tobago'),(230,'TT','Tunapuna-Piarco'),(232,'US','Alabama'),(231,'US','Alaska'),(234,'US','Arizona'),(233,'US','Arkansas'),(235,'US','California'),(236,'US','Colorado'),(237,'US','Connecticut'),(238,'US','D.C.'),(239,'US','Delaware'),(240,'US','Florida'),(241,'US','Georgia'),(242,'US','Hawaii'),(244,'US','Idaho'),(245,'US','Illinois'),(246,'US','Indiana'),(243,'US','Iowa'),(247,'US','Kansas'),(248,'US','Kentucky'),(249,'US','Louisiana'),(252,'US','Maine'),(251,'US','Maryland'),(250,'US','Massachusetts'),(253,'US','Michigan'),(254,'US','Minnesota'),(256,'US','Mississippi'),(255,'US','Missouri'),(257,'US','Montana'),(260,'US','Nebraska'),(264,'US','Nevada'),(261,'US','New Hampshire'),(262,'US','New Jersey'),(263,'US','New Mexico'),(265,'US','New York'),(258,'US','North Carolina'),(259,'US','North Dakota'),(266,'US','Ohio'),(267,'US','Oklahoma'),(268,'US','Oregon'),(269,'US','Pennsylvania'),(270,'US','Rhode Island'),(271,'US','South Carolina'),(272,'US','South Dakota'),(273,'US','Tennessee'),(274,'US','Texas'),(275,'US','Utah'),(277,'US','Vermont'),(276,'US','Virginia'),(278,'US','Washington'),(280,'US','West Virginia'),(279,'US','Wisconsin'),(281,'US','Wyoming'),(282,'VC','Charlotte'),(283,'VC','Grenadines'),(284,'VC','Saint Andrew'),(285,'VC','Saint David'),(286,'VC','Saint George'),(287,'VC','Saint Patrick'),(288,'VG','Anegada'),(289,'VG','Jost Van Dyke'),(290,'VG','Peter Island'),(291,'VG','Tortola'),(292,'VG','Virgin Gorda'),(293,'ZA','Eastern Cape'),(294,'ZA','Free State'),(295,'ZA','Gauteng'),(298,'ZA','KwaZulu-Nata'),(299,'ZA','Limpopo'),(296,'ZA','Mpumalanga'),(300,'ZA','North-West'),(297,'ZA','Northern Cape'),(301,'ZA','Western Cape');
/*!40000 ALTER TABLE `country_first_level_division` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_second_level_division`
--

DROP TABLE IF EXISTS `country_second_level_division`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `country_second_level_division` (
  `no` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier',
  `country_first_level_division` bigint(20) NOT NULL COMMENT 'Reference to first division',
  `name` varchar(90) NOT NULL COMMENT 'Name of second level division',
  PRIMARY KEY (`no`),
  UNIQUE KEY `uk_first_second_level_name` (`country_first_level_division`,`name`),
  KEY `fk_country_second_level_division_1_idx` (`country_first_level_division`),
  CONSTRAINT `fk_country_second_level_division_1` FOREIGN KEY (`country_first_level_division`) REFERENCES `country_first_level_division` (`no`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_second_level_division`
--

LOCK TABLES `country_second_level_division` WRITE;
/*!40000 ALTER TABLE `country_second_level_division` DISABLE KEYS */;
INSERT INTO `country_second_level_division` VALUES (1,156,'Alderney'),(2,156,'Guernsey'),(3,156,'Jersey'),(4,156,'Sark'),(5,157,'Bedfordshire *'),(7,157,'Berkshire'),(6,157,'Buckinghamshire'),(8,157,'Cambridgeshire'),(9,157,'Cheshire'),(10,157,'Cornwall'),(11,157,'Cumberland'),(12,157,'Derbyshire'),(13,157,'Devonshire'),(14,157,'Dorset'),(15,157,'Durham'),(17,157,'Essex'),(18,157,'Gloucestershire'),(19,157,'Hampshire'),(20,157,'Herefordshire'),(21,157,'Hertfordshire'),(22,157,'Huntingdonshire'),(23,157,'Isle Of Wight'),(24,157,'Kent'),(25,157,'Lancashire'),(26,157,'Leicestershire'),(27,157,'Lincolnshire'),(28,157,'London'),(29,157,'Middlesex'),(31,157,'Norfolk'),(33,157,'Northamptonshire'),(30,157,'Northumberland'),(34,157,'Nottinghamshire'),(35,157,'Oxfordshire'),(36,157,'Rutland'),(37,157,'Shropshire'),(39,157,'Somerset'),(42,157,'Staffordshire'),(38,157,'Suffolk'),(40,157,'Surrey'),(41,157,'Sussex'),(43,157,'Warwickshire'),(44,157,'Westmorland'),(45,157,'Wiltshire'),(46,157,'Worcestershire'),(48,157,'Yorkshire'),(16,157,'Yorkshire East Riding'),(32,157,'Yorkshire North Riding'),(47,157,'Yorkshire West Riding'),(49,159,'Antrim'),(50,159,'Ards'),(51,159,'Armagh'),(53,159,'Ballymena'),(54,159,'Ballymoney'),(55,159,'Banbridge'),(52,159,'Belfast'),(57,159,'Carrickfergus'),(60,159,'Castlereagh'),(59,159,'Coleraine'),(58,159,'Cookstown'),(56,159,'Craigavon'),(63,159,'Derry'),(62,159,'Down'),(61,159,'Dungannon'),(64,159,'Fermanagh'),(66,159,'Larne'),(65,159,'Limavady'),(67,159,'Lisburn'),(68,159,'Magherafelt'),(69,159,'Moyle'),(72,159,'Newry And Mourne District'),(71,159,'Newtownabbey'),(70,159,'North'),(73,159,'Omagh'),(74,159,'Strabane'),(75,160,'Aberdeenshire'),(76,160,'Angus (Formerly Forfarshire)'),(77,160,'Argyllshire'),(78,160,'Ayrshire'),(79,160,'Banffshire'),(80,160,'Berwickshire'),(81,160,'Borders'),(82,160,'Bute (Buteshire)'),(83,160,'Caithness'),(84,160,'Central'),(85,160,'Clackmannanshire'),(87,160,'Dumfries And Galloway'),(86,160,'Dumfriesshire'),(88,160,'Dunbartonshire'),(89,160,'East Lothian (Formerly Haddingtonshire)'),(90,160,'Fife'),(91,160,'Grampian'),(92,160,'Highland'),(93,160,'Inverness-Shire'),(94,160,'Kincardineshire'),(96,160,'Kinross-Shire'),(95,160,'Kirkcudbrightshire'),(97,160,'Lanarkshire'),(98,160,'Lothian'),(99,160,'Midlothian (Formerly Edinburghshire)'),(100,160,'Moray (Formerly Elginshire)'),(101,160,'Nairnshire'),(102,160,'Orkney'),(103,160,'Peeblesshire'),(104,160,'Perthshire'),(105,160,'Renfrewshire'),(106,160,'Ross And Cromarty'),(107,160,'Roxburghshire'),(108,160,'Selkirkshire'),(109,160,'Shetland'),(111,160,'Stirlingshire'),(110,160,'Strathclyde'),(112,160,'Sutherland'),(113,160,'Tayside'),(116,160,'West Lothian (Formerly Linlithgowshire)'),(115,160,'Western Isles'),(114,160,'Wigtownshire'),(117,161,'Anglesey'),(118,161,'Brecknockshire'),(119,161,'Caernarfonshire'),(120,161,'Cardiganshire'),(121,161,'Carmarthenshire'),(122,161,'Clwyd'),(123,161,'Denbighshire'),(124,161,'Dyfed'),(125,161,'Flintshire'),(126,161,'Glamorgan'),(127,161,'Gwent'),(128,161,'Gwynedd'),(129,161,'Merionethshire'),(130,161,'Mid Glamorgan'),(132,161,'Monmouthshire'),(131,161,'Montgomeryshire'),(133,161,'Pembrokeshire'),(134,161,'Powys'),(135,161,'Radnorshire'),(136,161,'South Glamorgan'),(137,161,'West Glamorgan'),(138,172,'Hanover'),(139,172,'St. Elizabeth'),(140,172,'St. James'),(141,172,'Trelawny'),(142,172,'Westmoreland'),(143,173,'Clarendon'),(144,173,'Manchester'),(147,173,'St. Ann'),(145,173,'St. Catherine'),(146,173,'St. Mary'),(148,174,'Kingston'),(149,174,'Portland'),(150,174,'St. Andrew'),(151,174,'St. Thomas');
/*!40000 ALTER TABLE `country_second_level_division` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'world'
--

--
-- Dumping routines for database 'world'
--
/*!50003 DROP PROCEDURE IF EXISTS `get_countries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_countries`(
	IN name NVARCHAR(50) ,
	IN pageIndex INT ,
    IN pageLength INT ,
    IN sortBy TINYINT ,
    IN sortOrder VARCHAR(4)
)
BEGIN

    SET @sql = 'SELECT 	c.iso_code isoCode, 
						c.name ,
                        c.currency ,
                        c.culture ,
                        c.phone_format phoneFormat ,
                        c.is_first_level_division_displayed isFirstLevelDivisionDisplayed ,
                        c.first_level_division_title firstLevelDivisionTitle ,
                        c.is_second_level_division_displayed isSecondLevelDivisionDisplayed ,
                        c.second_level_division_title secondLevelDivisionTitle ,
                        c.nin_title ninTitle ,
                        c.nin_format ninFormat ,
                        c.lat ,
                        c.lng
				FROM world.country c
                WHERE REGEXP_LIKE(c.name, CONCAT(\'^\', ?))';
    
    SET @sql = CONCAT(@sql, ' ORDER BY name ', UCASE(sortOrder));    
    IF pageLength >= 0 THEN
		SET @sql = CONCAT(@sql, ' LIMIT ?, ?');
	END IF;
    #
    PREPARE stmt FROM @sql;
    SET @n = name;
	SET @p = pageIndex;
	SET @l = pageLength;
    #
    IF pageLength >= 0 THEN
		EXECUTE stmt USING @n, @p, @l;
	ELSE
		EXECUTE stmt USING @n;
    END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_divisions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_divisions`(
	IN isoCode NVARCHAR(2)
)
BEGIN
	DECLARE isF BIT(1);
    DECLARE isS BIT(1);
    
    SELECT c.is_first_level_division_displayed, c.is_second_level_division_displayed
    INTO isF, isS
    FROM world.country c
    WHERE c.iso_code = isoCode;
    
    IF (isF = 1 AND isS = 0) THEN		
		SELECT	d.no ,
				d.name
		FROM world.country_first_level_division d
		WHERE d.country = isoCode
		ORDER BY d.name ASC;
    ELSEIF (isF = 1 AND isS = 1) THEN
		SELECT 	d.no ,
				d.name ,
				s.no secondLevelNo,
				s.name secondLevelName
		FROM world.country_second_level_division s
			INNER JOIN world.country_first_level_division d ON s.country_first_level_division = d.no
		WHERE d.country = isoCode
		ORDER BY d.name, s.name ASC;
	ELSEIF (isF = 0 AND isS = 1) THEN
		SELECT 	d.no ,
				d.name ,
				s.no secondLevelNo,
				s.name secondLevelName
		FROM world.country_second_level_division s
			INNER JOIN world.country_first_level_division d ON s.country_first_level_division = d.no
		WHERE d.country = isoCode
		ORDER BY s.name ASC;
    END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_second_level_divisions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_second_level_divisions`(
	IN first_level_division_no BIGINT(20)
)
BEGIN
	
    SELECT 	s.no ,
			s.name
	FROM world.country_second_level_division s
    WHERE s.country_first_level_division = first_level_division_no
    ORDER BY s.name ASC;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_second_level_divisions_by_country` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_second_level_divisions_by_country`(
	IN s_country NVARCHAR(2)
)
BEGIN
	
    SELECT 	s.no ,
			s.country_first_level_division firstLevelDivision ,
			s.name
	FROM world.country_second_level_division s
    WHERE EXISTS (SELECT '' FROM world.country_first_level_division d WHERE d.no = s.country_first_level_division AND d.country = s_country)
    ORDER BY s.name ASC;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-10-13 19:15:04
