create database if not exists `LearningOnline`;
use `LearningOnline`;
alter database LearningOnline character set utf8;
#--DROP TABLE IF EXISTS sequence;
CREATE TABLE IF NOT EXISTS sequence (
     name VARCHAR(50) NOT NULL,
     current_value INT NOT NULL,
     increment INT NOT NULL DEFAULT 1,
     PRIMARY KEY (name)
) ENGINE=InnoDB;


DROP FUNCTION IF EXISTS currval;
DELIMITER $
CREATE FUNCTION currval (seq_name VARCHAR(50))
     RETURNS INTEGER
     LANGUAGE SQL
     DETERMINISTIC
     CONTAINS SQL
     SQL SECURITY DEFINER
     COMMENT ''
BEGIN
     DECLARE value INTEGER;
     SET value = 0;
     SELECT current_value INTO value
          FROM sequence
          WHERE name = seq_name;
     IF value = 0 THEN
          RETURN setval(seq_name, 1);
     END IF;
     RETURN value;
END
$
DELIMITER ;

DROP FUNCTION IF EXISTS nextval;
DELIMITER $
CREATE FUNCTION nextval (seq_name VARCHAR(50))
     RETURNS INTEGER
     LANGUAGE SQL
     DETERMINISTIC
     CONTAINS SQL
     SQL SECURITY DEFINER
     COMMENT ''
BEGIN
     UPDATE sequence
          SET current_value = current_value + increment
          WHERE name = seq_name;
     RETURN currval(seq_name);
END
$
DELIMITER ;

DROP FUNCTION IF EXISTS setval;
DELIMITER $
CREATE FUNCTION setval (seq_name VARCHAR(50), value INTEGER)
     RETURNS INTEGER
     LANGUAGE SQL
     DETERMINISTIC
     CONTAINS SQL
     SQL SECURITY DEFINER
     COMMENT ''
BEGIN
     DECLARE n INTEGER;
     SELECT COUNT(*) INTO n FROM sequence WHERE name = seq_name;
     IF n = 0 THEN
         INSERT INTO sequence VALUES (seq_name, 1, 1);
         RETURN 1;
     END IF;
     UPDATE sequence
          SET current_value = value
          WHERE name = seq_name;
     RETURN currval(seq_name);
END
$
DELIMITER ;
#----------------------------------------------
        
#----------------------------------------------------
#---- 课件配置表
DROP TABLE IF EXISTS `cfgcourse`;
CREATE TABLE `cfgcourse` (
  `idx` int(11) NOT NULL,
  `subjectidx` int(4) NOT NULL,
  `status` TINYINT,
  `name` varchar(512) NOT NULL,
  `ppt` varchar(512),
  `pptpath` varchar(512),
  `res` varchar(512),
  `respath` varchar(512),
  `exercises_json` TEXT,
  `note` TEXT,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#----------------------------------------------------
#---- 课程配置表
DROP TABLE IF EXISTS `cfgsubject`;
CREATE TABLE `cfgsubject` (
  `idx` int(11) NOT NULL,
  `status` TINYINT,
  `gid` int(4) NOT NULL,
  `gid2` int(4) NOT NULL,
  `gid3` int(4) NOT NULL,
  `name` varchar(512) NOT NULL,
  `price` int(11) NOT NULL,
  `note` TEXT,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#----------------------------------------------------
#---- 客户表
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `idx` int(11) NOT NULL,
  `custid` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `name` varchar(128) NOT NULL,
  `crtTime` datetime,
  `lastEnTime` datetime,
  `status` TINYINT,
  `phone` varchar(45),
  `phone2` varchar(45),
  `email` varchar(45),
  `channel` varchar(45),
  `belongid` int(11),
  `groupid` TINYINT,
  `note` TEXT,
  PRIMARY KEY (`idx`, `custid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#----------------------------------------------------
#---- 用户表
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `idx` int(11) NOT NULL,
  `status` TINYINT,
  `custid` int(11) ,
  `name` varchar(128) NOT NULL,
  `birthday` datetime,
  `sex` TINYINT,
  `school` varchar(256),
  `belongid` int(11),
  `crtTime` datetime,
  `note` TEXT,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;