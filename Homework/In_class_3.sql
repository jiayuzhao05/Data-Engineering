-- 💥 1. 删除并重建数据库
DROP DATABASE IF EXISTS space_travel;
CREATE DATABASE space_travel
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

-- 🚀 2. 使用该数据库
USE space_travel;

-- 🌌 3. Solar Systems 表
CREATE TABLE IF NOT EXISTS `Solar_Systems` (
  `Solar_ID` SMALLINT     NOT NULL AUTO_INCREMENT,
  `System_Name` VARCHAR (45) NOT NULL,
  PRIMARY KEY (`Solar_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 🪐 4. Planets 表
CREATE TABLE IF NOT EXISTS `Planets` (
  `Planet_ID`   SMALLINT NOT NULL AUTO_INCREMENT,
  `Planet_Type` VARCHAR (45) NOT NULL,
  `Solar_ID`    SMALLINT NOT NULL,
  PRIMARY KEY (`Planet_ID`),
  INDEX `idx_planets_solar` (`Solar_ID`),
  CONSTRAINT `fk_planets_solar`
    FOREIGN KEY (`Solar_ID`)
    REFERENCES `Solar_Systems` (`Solar_ID`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 🚗 5. Vehicles 表
CREATE TABLE IF NOT EXISTS `Vehicles` (
  `Vehicle_ID`   SMALLINT NOT NULL AUTO_INCREMENT,
  `Vehicle_type` VARCHAR (45) NOT NULL,
  PRIMARY KEY (`Vehicle_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 👨‍🚀 6. Passenger 表
CREATE TABLE IF NOT EXISTS `Passenger` (
  `Passenger_ID` SMALLINT NOT NULL AUTO_INCREMENT,
  `Astronauts`   VARCHAR(45),
  `Tourists`     VARCHAR(45),
  `Cargo`        VARCHAR(45),
  PRIMARY KEY (`Passenger_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 📋 7. Manifest 表
CREATE TABLE IF NOT EXISTS `Manifest` (
  `Manifest_ID`  SMALLINT NOT NULL AUTO_INCREMENT,
  `Passenger_ID` SMALLINT NOT NULL,
  PRIMARY KEY (`Manifest_ID`),
  INDEX `idx_manifest_passenger` (`Passenger_ID`),
  CONSTRAINT `fk_manifest_passenger`
    FOREIGN KEY (`Passenger_ID`)
    REFERENCES `Passenger` (`Passenger_ID`)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 🚀 8. Trip
CREATE TABLE IF NOT EXISTS `Trip` (
  `Trip_ID`     SMALLINT NOT NULL AUTO_INCREMENT,
  `Trip_Type`   VARCHAR (45) NOT NULL,
  `Vehicle_ID`  SMALLINT NOT NULL,
  `Manifest_ID` SMALLINT NOT NULL,
  `Solar_ID`    SMALLINT NOT NULL,
  PRIMARY KEY (`Trip_ID`),
  INDEX `idx_trip_vehicle` (`Vehicle_ID`),
  INDEX `idx_trip_manifest` (`Manifest_ID`),
  INDEX `idx_trip_solar` (`Solar_ID`),
  CONSTRAINT `fk_trip_vehicle`
    FOREIGN KEY (`Vehicle_ID`)
    REFERENCES `Vehicles` (`Vehicle_ID`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_trip_manifest`
    FOREIGN KEY (`Manifest_ID`)
    REFERENCES `Manifest` (`Manifest_ID`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_trip_solar`
    FOREIGN KEY (`Solar_ID`)
    REFERENCES `Solar_Systems` (`Solar_ID`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 🏠 9. Bases 表
CREATE TABLE IF NOT EXISTS `Bases` (
  `Base_ID`   INT NOT NULL AUTO_INCREMENT,
  `Planet_ID` SMALLINT NOT NULL,
  `Capacity`  SMALLINT NOT NULL,
  `Price`     SMALLINT NOT NULL,
  PRIMARY KEY (`Base_ID`),
  INDEX `idx_bases_planet` (`Planet_ID`),
  CONSTRAINT `fk_bases_planet`
    FOREIGN KEY (`Planet_ID`)
    REFERENCES `Planets` (`Planet_ID`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;