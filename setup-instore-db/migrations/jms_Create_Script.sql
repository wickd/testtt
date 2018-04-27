-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: jms
-- Source Schemata: jms
-- Created: Tue Apr 24 14:50:24 2018
-- Workbench Version: 6.3.8
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema jms
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `jms` ;
CREATE SCHEMA IF NOT EXISTS `jms` ;

-- ----------------------------------------------------------------------------
-- Table jms.system_data
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jms`.`system_data` (
  `id` BIGINT NOT NULL,
  `version` VARCHAR(20) NOT NULL,
  `creationDate` DATETIME NOT NULL,
  UNIQUE INDEX `system_data_pk` (`id` ASC));

-- ----------------------------------------------------------------------------
-- Table jms.seeds
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jms`.`seeds` (
  `name` VARCHAR(20) NOT NULL,
  `seed` BIGINT NOT NULL,
  UNIQUE INDEX `seeds_pk` (`name` ASC));

-- ----------------------------------------------------------------------------
-- Table jms.destinations
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jms`.`destinations` (
  `name` VARCHAR(255) NOT NULL,
  `isQueue` INT(4) NOT NULL,
  `destinationId` BIGINT NOT NULL,
  UNIQUE INDEX `destinations_pk` (`name` ASC));

-- ----------------------------------------------------------------------------
-- Table jms.messages
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jms`.`messages` (
  `messageId` VARCHAR(64) NOT NULL,
  `destinationId` BIGINT NOT NULL,
  `priority` INT(4) NULL,
  `createTime` BIGINT NOT NULL,
  `expiryTime` BIGINT NULL,
  `processed` INT(4) NULL,
  `messageBlob` LONGBLOB NOT NULL,
  INDEX `messages_pk` (`messageId` ASC));

-- ----------------------------------------------------------------------------
-- Table jms.message_handles
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jms`.`message_handles` (
  `messageId` VARCHAR(64) NOT NULL,
  `destinationId` BIGINT NOT NULL,
  `consumerId` BIGINT NOT NULL,
  `priority` INT(4) NULL,
  `acceptedTime` BIGINT NOT NULL,
  `sequenceNumber` BIGINT NULL,
  `expiryTime` BIGINT NULL,
  `delivered` INT(4) NULL,
  INDEX `message_handles_pk` (`messageId` ASC));

-- ----------------------------------------------------------------------------
-- Table jms.consumers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jms`.`consumers` (
  `name` VARCHAR(255) NOT NULL,
  `destinationId` BIGINT NOT NULL,
  `consumerId` BIGINT NOT NULL,
  `created` BIGINT NOT NULL,
  UNIQUE INDEX `consumers_pk` (`name` ASC, `destinationId` ASC));

-- ----------------------------------------------------------------------------
-- Table jms.users
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jms`.`users` (
  `username` VARCHAR(50) NOT NULL,
  `password` VARCHAR(50) NOT NULL,
  UNIQUE INDEX `users_pk` (`username` ASC));
SET FOREIGN_KEY_CHECKS = 1;
