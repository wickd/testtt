-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: Instore
-- Source Schemata: Instore
-- Created: Wed Apr 18 17:17:46 2018
-- Workbench Version: 6.3.8
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema Instore
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `Instore` ;
CREATE SCHEMA IF NOT EXISTS `Instore` ;

-- ----------------------------------------------------------------------------
-- Table Instore.AlertTypes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`AlertTypes` (
  `AlertTypeID` INT(4) NOT NULL,
  `AlertName` VARCHAR(80) NOT NULL,
  `Percent1Default` DECIMAL(10,5) NOT NULL,
  `Percent2Default` DECIMAL(10,5) NOT NULL,
  `MaxCountDefault` INT(4) NOT NULL,
  `RepeatEnabled` TINYINT(1) NOT NULL,
  `emailSubject` VARCHAR(256) NULL DEFAULT NULL,
  `emailBody` VARCHAR(1000) NULL DEFAULT NULL,
  `altEmailSubject` VARCHAR(256) NULL DEFAULT NULL,
  `altEmailBody` VARCHAR(1000) NULL DEFAULT NULL,
  `Time1Default` INT(4) NOT NULL DEFAULT '0',
  `Time2Default` INT(4) NOT NULL DEFAULT '0',
  `NotificationTypeDefault` VARCHAR(10) NULL DEFAULT NULL,
  `AltEmail2Subject` VARCHAR(256) NULL DEFAULT NULL,
  `AltEmail2Body` VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`AlertTypeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.Appliances
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Appliances` (
  `ApplianceId` INT(4) NOT NULL AUTO_INCREMENT,
  `ManufacturerId` INT(4) NOT NULL,
  `ApplianceName` CHAR(50) NOT NULL,
  `Mappable` TINYINT(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ApplianceId`),
  UNIQUE INDEX `Appliances UNIQUE (ApplianceName)` (`ApplianceName` ASC),
  INDEX `AppliancesManufacturers` (`ManufacturerId` ASC),
  CONSTRAINT `AppliancesManufacturers`
    FOREIGN KEY (`ManufacturerId`)
    REFERENCES `Instore`.`AppliancesManufacturers` (`ManufacturerId`))
ENGINE = InnoDB
AUTO_INCREMENT = 135
DEFAULT CHARACTER SET = latin1
COMMENT = 'All info about Appliances, referenced by AppliancesImages, FASTAppliances, ParameterSetsAppliance, AppliancesDescriptions';

-- ----------------------------------------------------------------------------
-- Table Instore.AppliancesManufacturers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`AppliancesManufacturers` (
  `ManufacturerId` INT(4) NOT NULL AUTO_INCREMENT,
  `ManufacturerName` CHAR(50) NOT NULL,
  PRIMARY KEY (`ManufacturerId`))
ENGINE = InnoDB
AUTO_INCREMENT = 36
DEFAULT CHARACTER SET = latin1
COMMENT = 'Info about Manufacturer for Appliance, referenced by Appliances.';

-- ----------------------------------------------------------------------------
-- Table Instore.AttributeNames
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`AttributeNames` (
  `ChainId` INT(4) NULL DEFAULT NULL,
  `AttributeNameId` INT(4) NOT NULL AUTO_INCREMENT,
  `AttributeTypeId` INT(4) NOT NULL,
  `AttributeName` VARCHAR(80) NOT NULL,
  `ParentAttributeNameId` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`AttributeNameId`),
  UNIQUE INDEX `AttributeNames UNIQUE (AttributeNameId)` (`AttributeNameId` ASC),
  INDEX `ChainsFKey` (`ChainId` ASC),
  INDEX `AttributeTypesFKey` (`AttributeTypeId` ASC),
  CONSTRAINT `AttributeTypesFKey`
    FOREIGN KEY (`AttributeTypeId`)
    REFERENCES `Instore`.`AttributeTypes` (`AttributeTypeId`),
  CONSTRAINT `ChainsFKey`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`))
ENGINE = InnoDB
AUTO_INCREMENT = 246
DEFAULT CHARACTER SET = latin1
COMMENT = 'This is a table which will have all the attribute names. In case of hierarchy, the parent attribute id will not be a null.';

-- ----------------------------------------------------------------------------
-- Table Instore.AttributeTypes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`AttributeTypes` (
  `AttributeTypeId` INT(4) NOT NULL AUTO_INCREMENT,
  `AttributeName` VARCHAR(80) NOT NULL,
  `ChainLevel` TINYINT(4) NOT NULL,
  `SiteLevel` TINYINT(4) NOT NULL,
  `MobilinkSync` TINYINT(4) NOT NULL,
  PRIMARY KEY (`AttributeTypeId`),
  UNIQUE INDEX `AttributeTypes UNIQUE (AttributeTypeId)` (`AttributeTypeId` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = latin1
COMMENT = 'This is the table which will have info about attributes types like what type of attribute it it, like Wireless Config, Grouping, Management Hierarchy, Store Info etc';

-- ----------------------------------------------------------------------------
-- Table Instore.BatchLog
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`BatchLog` (
  `BatchId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `BatchSize` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `AmtAvailable` INT(4) NOT NULL,
  `StartTime` DATETIME(6) NULL DEFAULT NULL,
  `ExpiredTime` DATETIME(6) NOT NULL,
  `SoldAmt` INT(4) NOT NULL DEFAULT '0',
  `TrashedAmt` INT(4) NOT NULL DEFAULT '0',
  `FreshSold` INT(4) NOT NULL DEFAULT '0',
  `LastPieceSold` DATETIME(6) NULL DEFAULT NULL,
  `FirstPieceSold` DATETIME(6) NULL DEFAULT NULL,
  `BatchUUId` VARCHAR(255) NOT NULL,
  `Voids` INT(4) NOT NULL DEFAULT '0',
  `SiteApplianceID` INT(4) NULL DEFAULT NULL,
  `ButtonNumber` SMALLINT(6) NULL DEFAULT NULL,
  `Adjustment` INT(4) NOT NULL DEFAULT '0',
  `CateringAmt` INT(4) NOT NULL DEFAULT '0',
  `CookInstructionSize` INT(4) NULL DEFAULT NULL,
  `PreviousBatchUUId` VARCHAR(255) NULL DEFAULT NULL,
  `CarryOver` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`BatchUUId`),
  UNIQUE INDEX `UIDX_BATCHLOG_BATCHID` (`BatchId` ASC),
  INDEX `StartTimeIndex` (`StartTime` ASC),
  INDEX `ChainsProducts_2` (`ChainId` ASC, `ProductId` ASC),
  CONSTRAINT `ChainsProducts_2`
    FOREIGN KEY (`ChainId` , `ProductId`)
    REFERENCES `Instore`.`ChainsProducts` (`ChainId` , `ProductId`))
ENGINE = InnoDB
AUTO_INCREMENT = 164793
DEFAULT CHARACTER SET = latin1
COMMENT = 'Store information for each batch on chain and site.';

-- ----------------------------------------------------------------------------
-- Table Instore.CAIID
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`CAIID` (
  `ChainId` INT(4) NOT NULL,
  `IncidentId` INT(4) NOT NULL,
  PRIMARY KEY (`ChainId`, `IncidentId`),
  CONSTRAINT `Chains_4`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.CateringOrderItems
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`CateringOrderItems` (
  `CateringOrderId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `Quantity` INT(4) NOT NULL,
  `FilledDateTime` DATETIME(6) NULL DEFAULT NULL,
  PRIMARY KEY (`CateringOrderId`, `ChainId`, `SiteId`, `ProductId`),
  INDEX `FK_CATERING_REFERENCE_SITESPRO` (`ChainId` ASC, `SiteId` ASC, `ProductId` ASC),
  CONSTRAINT `FK_CATERING_REFERENCE_CATERING`
    FOREIGN KEY (`CateringOrderId` , `ChainId` , `SiteId`)
    REFERENCES `Instore`.`CateringOrders` (`CateringOrderId` , `ChainId` , `SiteId`),
  CONSTRAINT `FK_CATERING_REFERENCE_SITESPRO`
    FOREIGN KEY (`ChainId` , `SiteId` , `ProductId`)
    REFERENCES `Instore`.`SitesProducts` (`ChainId` , `SiteId` , `ProductId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Represents an item on a catering order.  A product can only appear once on a catering order.';

-- ----------------------------------------------------------------------------
-- Table Instore.CateringOrders
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`CateringOrders` (
  `CateringOrderId` INT(4) NOT NULL AUTO_INCREMENT,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `CheckId` VARCHAR(200) NULL DEFAULT NULL,
  `PosCheckId` VARCHAR(255) NULL DEFAULT NULL,
  `Status` VARCHAR(50) NOT NULL,
  `DueDate` DATE NOT NULL,
  `ReadyDateTime` DATETIME(6) NOT NULL,
  `PrepStartDateTime` DATETIME(6) NOT NULL,
  `CompleteDateTime` DATETIME(6) NULL DEFAULT NULL,
  `CancelDateTime` DATETIME(6) NULL DEFAULT NULL,
  PRIMARY KEY (`CateringOrderId`, `ChainId`, `SiteId`),
  INDEX `FK_CATERING_REFERENCE_SITES` (`ChainId` ASC, `SiteId` ASC),
  INDEX `FK_CATERING_REFERENCE_POSCHECK` (`PosCheckId` ASC),
  CONSTRAINT `FK_CATERING_REFERENCE_POSCHECK`
    FOREIGN KEY (`PosCheckId`)
    REFERENCES `Instore`.`PosChecks` (`PosCheckId`),
  CONSTRAINT `FK_CATERING_REFERENCE_SITES`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Represents a catering order in the SCK system.';

-- ----------------------------------------------------------------------------
-- Table Mysck.ChainLevelFeatures
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainLevelFeatures` (
  `ChainId` INT(4) NOT NULL,
  `SckProductFeatureId` INT(4) NOT NULL,
  `FeatureEnabled` TINYINT(1) NULL,
  `last_modified` DATETIME NOT NULL,
  `Value` VARCHAR(30) NULL,
  PRIMARY KEY (`ChainId`, `SckProductFeatureId`),
  INDEX `ChainLevelFeatures_ml` (`last_modified` ASC),
  CONSTRAINT `FK_CHAINLEV_REFERENCE_CHAINS`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`),
  CONSTRAINT `FK_CHAINLEV_REFERENCE_SCKPRODU`
    FOREIGN KEY (`SckProductFeatureId`)
    REFERENCES `Instore`.`SckProductFeatures` (`SckProductFeatureId`));

-- ----------------------------------------------------------------------------
-- Table Instore.ChainJobFunctions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainJobFunctions` (
  `ChainJobFunctionId` VARCHAR(255) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `Name` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`ChainJobFunctionId`),
  INDEX `FK_CHAINJOB_JOB_FUNCT_CHAINS` (`ChainId` ASC),
  CONSTRAINT `FK_CHAINJOB_JOB_FUNCT_CHAINS`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Defines a job function within an organization.  Employees have job functions.';

-- ----------------------------------------------------------------------------
-- Table Instore.Chains
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Chains` (
  `ChainId` INT(4) NOT NULL AUTO_INCREMENT,
  `ChainName` VARCHAR(100) NOT NULL,
  `ChainDisplayAddress` INT(4) NULL DEFAULT NULL,
  `ChainDisplayPhoneNumber` INT(4) NULL DEFAULT NULL,
  `ChainDisplayContact` INT(4) NULL DEFAULT NULL,
  `ProductImageMediaCatalogId` INT(4) NULL DEFAULT NULL,
  `Deleted` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ChainId`),
  INDEX `FK_CHAINS_REFERENCE_MEDIACAT` (`ProductImageMediaCatalogId` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 23
DEFAULT CHARACTER SET = latin1
COMMENT = 'Entity stores those attributes which define a franchisor or entity that grants a franchise.  An example would be Puppies, Burger King, etc...';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsAppliances
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsAppliances` (
  `ChainId` INT(4) NOT NULL,
  `ApplianceId` INT(4) NOT NULL,
  `ControllerId` INT(4) NOT NULL,
  `ChainApplianceID` INT(4) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ChainId`, `ApplianceId`, `ControllerId`, `ChainApplianceID`),
  INDEX `ChainApplianceID_idx` (`ChainApplianceID` ASC),
  INDEX `FASTAppliances` (`ApplianceId` ASC, `ControllerId` ASC),
  CONSTRAINT `Chains`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`),
  CONSTRAINT `FASTAppliances`
    FOREIGN KEY (`ApplianceId` , `ControllerId`)
    REFERENCES `Instore`.`FASTAppliances` (`ApplianceId` , `ControllerId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Display ApplianceId, ControllerId on each Chain, referenced by SitesAppliances.';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsAttributes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsAttributes` (
  `ChainId` INT(4) NOT NULL,
  `AttributeNameId` INT(4) NOT NULL,
  `AttributeValue` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `AttributeNameId`),
  INDEX `AttributeNamesFKey` (`AttributeNameId` ASC),
  CONSTRAINT `AttributeNamesFKey`
    FOREIGN KEY (`AttributeNameId`)
    REFERENCES `Instore`.`AttributeNames` (`AttributeNameId`),
  CONSTRAINT `ChainsFKey_1`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Any attributes which are defined at chain level will be defined here';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsMessages
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsMessages` (
  `ChainMessageId` VARCHAR(255) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `MessageStr` VARCHAR(500) NOT NULL,
  `EffectiveDate` DATE NULL DEFAULT NULL,
  `ExpirationDate` DATE NULL DEFAULT NULL,
  `DisplayOrdinal` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainMessageId`),
  INDEX `Chains_ChainsMessages` (`ChainId` ASC),
  CONSTRAINT `Chains_ChainsMessages`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'QPM display messages at the chain level; i.e. apply to all sites in the chain.';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsParametersSets
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsParametersSets` (
  `ChainId` INT(4) NOT NULL,
  `ParameterSetId` INT(4) NOT NULL,
  PRIMARY KEY (`ChainId`, `ParameterSetId`),
  INDEX `ParametersSets` (`ParameterSetId` ASC),
  CONSTRAINT `Chains_1`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`),
  CONSTRAINT `ParametersSets`
    FOREIGN KEY (`ParameterSetId`)
    REFERENCES `Instore`.`ParametersSets` (`ParameterSetId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'ParameterSetId on each chain, referenced by ChainsParametersSetsItemsValues, SitesAppliancesParametersSets.';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsParametersSetsItemsValues
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsParametersSetsItemsValues` (
  `ChainId` INT(4) NOT NULL,
  `ParameterSetId` INT(4) NOT NULL,
  `ParameterSetItemID` INT(4) NOT NULL,
  `ParameterElementNo` INT(4) NOT NULL,
  `ChainsParameterSetItemValue` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `ParameterSetId`, `ParameterSetItemID`, `ParameterElementNo`),
  INDEX `ParametersSetsItemsValues` (`ParameterSetId` ASC, `ParameterSetItemID` ASC, `ParameterElementNo` ASC),
  CONSTRAINT `ChainsParametersSets`
    FOREIGN KEY (`ChainId` , `ParameterSetId`)
    REFERENCES `Instore`.`ChainsParametersSets` (`ChainId` , `ParameterSetId`),
  CONSTRAINT `ParametersSetsItemsValues`
    FOREIGN KEY (`ParameterSetId` , `ParameterSetItemID` , `ParameterElementNo`)
    REFERENCES `Instore`.`ParametersSetsItemsValues` (`ParameterSetId` , `ParameterSetItemID` , `ParameterElementNo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'ParameterSetsItemsValue on each chain ';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsPhoneNumbers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsPhoneNumbers` (
  `ChainPhoneNumberId` INT(4) NOT NULL AUTO_INCREMENT,
  `ChainId` INT(4) NOT NULL,
  `PhoneTypeLookupListId` INT(4) NULL DEFAULT NULL,
  `PhoneNumber` VARCHAR(30) NOT NULL,
  `PrimaryFlag` CHAR(1) NOT NULL,
  PRIMARY KEY (`ChainPhoneNumberId`),
  INDEX `ChainsPhoneNumbers_Chains` (`ChainId` ASC),
  INDEX `ChainsPhoneNumbers_LookupListItem` (`PhoneTypeLookupListId` ASC),
  CONSTRAINT `ChainsPhoneNumbers_Chains`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`),
  CONSTRAINT `ChainsPhoneNumbers_LookupListItem`
    FOREIGN KEY (`PhoneTypeLookupListId`)
    REFERENCES `Instore`.`LookupListItem` (`LookupListItemId`),
  CONSTRAINT `Chains_7`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'PhoneNumbers on each chain.';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsProducts
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsProducts` (
  `ChainId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL AUTO_INCREMENT,
  `ChainProductName` VARCHAR(150) NULL DEFAULT NULL,
  `ChainProductUnitOfMeasure` VARCHAR(50) NULL DEFAULT NULL,
  `CustomerProductId` INT(4) NULL DEFAULT NULL,
  `UnitSize` INT(4) NOT NULL DEFAULT '1',
  `ForecastUnit` VARCHAR(50) NULL DEFAULT 'Pieces',
  `BatchUnitDescription` VARCHAR(200) NULL DEFAULT NULL,
  `BatchDisplayName` VARCHAR(16) NULL DEFAULT NULL,
  `Deleted` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ProductId`, `ChainId`),
  INDEX `ProductId_idx` (`ProductId` ASC),
  CONSTRAINT `Chains_2`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`))
ENGINE = InnoDB
AUTO_INCREMENT = 297
DEFAULT CHARACTER SET = latin1
COMMENT = 'Entity store those attributes associated with a franchise product.  Examples are Big Mac, Whopper, Extra Crispy Chicken';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsProductsImages
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsProductsImages` (
  `ChainProductImageId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `MediaId` INT(4) NOT NULL,
  `IsActiveImage` INT(4) NOT NULL,
  PRIMARY KEY (`ChainProductImageId`),
  UNIQUE INDEX `UX_ChainProductImage` (`ChainId` ASC, `ProductId` ASC, `MediaId` ASC),
  INDEX `FK_CHAINSPR_REFERENCE_MEDIA` (`MediaId` ASC),
  CONSTRAINT `FK_CHAINSPR_REFERENCE_CHAINSPR`
    FOREIGN KEY (`ChainId` , `ProductId`)
    REFERENCES `Instore`.`ChainsProducts` (`ChainId` , `ProductId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associates a chain product with one or more images.';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsRecipes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsRecipes` (
  `ChainId` INT(4) NOT NULL,
  `RecipeId` INT(4) NOT NULL AUTO_INCREMENT,
  `ProductId` INT(4) NOT NULL,
  `RecipeScope` CHAR(10) NOT NULL,
  `RecipeProductCount` INT(4) NOT NULL,
  `RecipeDescription` VARCHAR(200) NOT NULL,
  `BatchQtyWholeUnits` INT(4) NULL DEFAULT NULL,
  `BatchQtyFractUnits` CHAR(3) NULL DEFAULT NULL,
  `Deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `CompatibilityGroupId` INT(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ChainId` , `RecipeId`),
  INDEX `RecipeId_idx` (`RecipeId` ASC),
  INDEX `ChainsProducts` (`ChainId` ASC, `ProductId` ASC),
  INDEX `ChainsRecipeScope` (`RecipeScope` ASC),
  CONSTRAINT `ChainsProducts`
    FOREIGN KEY (`ChainId` , `ProductId`)
    REFERENCES `Instore`.`ChainsProducts` (`ChainId` , `ProductId`),
  CONSTRAINT `Chains_3`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Recipe info on each chain, referenced by ChainsRecipeVersions, SitesRecipes.';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsRecipesParameters
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsRecipesParameters` (
  `ChainId` INT(4) NOT NULL,
  `RecipeId` INT(4) NOT NULL,
  `RecipeVersionNumber` SMALLINT(6) NOT NULL,
  `ParameterId` INT(4) NOT NULL,
  `RecipeParameterType` CHAR(10) NOT NULL,
  PRIMARY KEY (`ChainId`, `RecipeId`, `RecipeVersionNumber`, `ParameterId`),
  INDEX `Parameters` (`ParameterId` ASC),
  INDEX `RecipeParameterTypes` (`RecipeParameterType` ASC),
  CONSTRAINT `ChainsRecipesVersions`
    FOREIGN KEY (`ChainId` , `RecipeId` , `RecipeVersionNumber`)
    REFERENCES `Instore`.`ChainsRecipesVersions` (`ChainId` , `RecipeId` , `RecipeVersionNumber`),
  CONSTRAINT `Parameters`
    FOREIGN KEY (`ParameterId`)
    REFERENCES `Instore`.`Parameters` (`ParameterId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Which Parameter (id and type) on each chain for this recipe. Referenced by ChainsRecipesParametersValues, ChainsRecipesPreAlarmsValues.';

-- ----------------------------------------------------------------------------
-- Table Instore.ChainsRecipesVersions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ChainsRecipesVersions` (
  `ChainId` INT(4) NOT NULL,
  `RecipeId` INT(4) NOT NULL,
  `RecipeVersionNumber` SMALLINT(6) NOT NULL,
  `RecipeDuration` INT(4) NOT NULL,
  `RecipeEffectiveDate` DATE NOT NULL,
  `Deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `RecipeVersionDescription` VARCHAR(200) NULL DEFAULT NULL,
  `ReferenceRecipeVersionNumber` INT(4) NULL DEFAULT NULL,
  `DisplayRecipeVersionNumber` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `RecipeId`, `RecipeVersionNumber`),
  CONSTRAINT `ChainsRecipes`
    FOREIGN KEY (`ChainId` , `RecipeId`)
    REFERENCES `Instore`.`ChainsRecipes` (`ChainId` , `RecipeId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Which VersionNumber for this recipe on each chain. Referenced by ChainsRecipesParameters, ChainsRecipesStages, ChainsRecipesVersionsDescriptions, SitesAppliancesCookLogs, SitesAppliancesWCWLogs.';

-- ----------------------------------------------------------------------------
-- Table Instore.Configuration
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Configuration` (
  `TagName` CHAR(100) NOT NULL,
  `BuildDate` DATETIME(6) NOT NULL,
  `EventListenerIP` VARCHAR(1024) NULL DEFAULT NULL,
  PRIMARY KEY (`TagName`, `BuildDate`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Record tag information';

-- ----------------------------------------------------------------------------
-- Table Instore.CookInstQPMAlertData
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`CookInstQPMAlertData` (
  `id` INT(4) NOT NULL AUTO_INCREMENT,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `IntervalId` INT(4) NOT NULL,
  `EventDateTime` DATETIME(6) NOT NULL,
  `OriginalEventType` INT(4) NOT NULL,
  `SiteApplianceId` INT(4) NOT NULL,
  `ButtonNumber` INT(4) NOT NULL,
  `RecipeId` INT(4) NOT NULL,
  `RecipeVersionNumber` INT(4) NOT NULL,
  `CookProductCount` INT(4) NOT NULL,
  `CookInstrInPieces` INT(4) NOT NULL,
  `OnHandQty` INT(4) NOT NULL,
  `ProcessedFlag` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Record forecast data for analysis and determination of QPM Cook Instructions alert.';

-- ----------------------------------------------------------------------------
-- Table Instore.CookMoreLogs
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`CookMoreLogs` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `CookMoreRecordId` INT(4) NOT NULL AUTO_INCREMENT,
  `CookMoreDate` DATE NOT NULL,
  `CookMoreTime` TIME(6) NOT NULL,
  `Quantity` INT(4) NOT NULL,
  `Units` VARCHAR(50) NULL DEFAULT NULL,
  `UnitSize` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`CookMoreRecordId`, `ChainId`, `SiteId`, `ProductId`, `CookMoreDate`),
  INDEX `CookMoreRecordId_idx` (`CookMoreRecordId` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 571880
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contains a record of all cook instruction changes that occur throughout the day.  Everytime the cook more instruction changes for any product, a new record inserted here.';

-- ----------------------------------------------------------------------------
-- Table Instore.Countries
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Countries` (
  `CountryCode` CHAR(2) NOT NULL,
  `CountryName` CHAR(30) NOT NULL,
  `CountryPhonePrefix` CHAR(5) NOT NULL,
  PRIMARY KEY (`CountryCode`),
  UNIQUE INDEX `Countries UNIQUE (CountryName)` (`CountryName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Entities for Country. Referenced by PhoneNumbers.';

-- ----------------------------------------------------------------------------
-- Table Instore.DailySitesForecastAlternateDates
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`DailySitesForecastAlternateDates` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ConfigDate` DATE NOT NULL,
  `ForecastSourceDate` DATE NOT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `ConfigDate`, `ForecastSourceDate`),
  CONSTRAINT `FK_DAILYSFAD_REF_DAILYSITESFRCSTCONF`
    FOREIGN KEY (`ChainId` , `SiteId` , `ConfigDate`)
    REFERENCES `Instore`.`DailySitesForecastConfig` (`ChainId` , `SiteId` , `ConfigDate`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Represents alternate dates that are selected for the generation of a particular days forecast.';

-- ----------------------------------------------------------------------------
-- Table Instore.DailySitesForecastConfig
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`DailySitesForecastConfig` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ConfigDate` DATE NOT NULL,
  `ForecastMethod` VARCHAR(30) NOT NULL DEFAULT 'RecentSales',
  `ProjectedSales` DECIMAL(18,2) NULL DEFAULT NULL,
  `AdjustedProjectedSales` DECIMAL(18,2) NULL DEFAULT NULL,
  `UserAdjustedProjectedSales` DECIMAL(18,2) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `ConfigDate`),
  CONSTRAINT `DAILYSITEFORECASTCONFIG_REF_SITES`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'This table stores the Site level forecast configuration data.';

-- ----------------------------------------------------------------------------
-- Table Instore.EventsActions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`EventsActions` (
  `EventActionID` INT(4) NOT NULL,
  `EventActionName` CHAR(50) NOT NULL,
  `EventActionExec` CHAR(255) NOT NULL,
  PRIMARY KEY (`EventActionID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'List all ActionId with an EventAction Execution, eg: when an action happened, which log procedure will be executed. Referenced by EventsToLog.';

-- ----------------------------------------------------------------------------
-- Table Instore.EventsToLog
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`EventsToLog` (
  `ParameterID` INT(4) NOT NULL,
  `EventActionID` INT(4) NOT NULL,
  `Chamber` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ParameterID`, `EventActionID`),
  INDEX `EventsActions` (`EventActionID` ASC),
  CONSTRAINT `EventsActions`
    FOREIGN KEY (`EventActionID`)
    REFERENCES `Instore`.`EventsActions` (`EventActionID`),
  CONSTRAINT `Parameters_3`
    FOREIGN KEY (`ParameterID`)
    REFERENCES `Instore`.`Parameters` (`ParameterId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associate an Event with a Parameter, list ParameterId for each event.';

-- ----------------------------------------------------------------------------
-- Table Instore.FASTAppliances
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`FASTAppliances` (
  `ApplianceId` INT(4) NOT NULL,
  `ControllerId` INT(4) NOT NULL,
  PRIMARY KEY (`ApplianceId`, `ControllerId`),
  INDEX `FastronControllers` (`ControllerId` ASC),
  CONSTRAINT `Appliances_2`
    FOREIGN KEY (`ApplianceId`)
    REFERENCES `Instore`.`Appliances` (`ApplianceId`),
  CONSTRAINT `FastronControllers`
    FOREIGN KEY (`ControllerId`)
    REFERENCES `Instore`.`FastronControllers` (`ControllerId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associate ControllerId with an ApplianceId. Referenced by ChainsAppliances.';

-- ----------------------------------------------------------------------------
-- Table Instore.FastronControllerModels
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`FastronControllerModels` (
  `ControllerId` INT(4) NOT NULL,
  `ControllerModelNumber` VARCHAR(100) NOT NULL,
  `REMatchString` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ControllerId`, `ControllerModelNumber`),
  CONSTRAINT `FK_FastronControllerModels_REF_FastronController`
    FOREIGN KEY (`ControllerId`)
    REFERENCES `Instore`.`FastronControllers` (`ControllerId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contains all of the model numbers or partial model numbers that map to different FASTRon controllers.  The REMatchString is used to do regular expression matches on the model number read from the unit.';

-- ----------------------------------------------------------------------------
-- Table Instore.FastronControllerTypes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`FastronControllerTypes` (
  `ControllerType` CHAR(32) NOT NULL,
  PRIMARY KEY (`ControllerType`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Controller types. eg: EM 9x, IM 2000. Referenced by FastronControllers.';

-- ----------------------------------------------------------------------------
-- Table Instore.FastronControllers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`FastronControllers` (
  `ControllerId` INT(4) NOT NULL AUTO_INCREMENT,
  `ControllerType` CHAR(32) NOT NULL,
  `ControllerName` CHAR(50) NOT NULL,
  `ControllerModelNumber` LONGTEXT NOT NULL,
  `ControllerNumberOfButtons` SMALLINT(6) NOT NULL,
  `ControllerOrientation` CHAR(10) NOT NULL,
  `ControllerVoltage` SMALLINT(6) NOT NULL,
  `ControllerMaxElementsPerButton` SMALLINT(6) NOT NULL DEFAULT '0',
  `ControllerMaxStagesPerButton` SMALLINT(6) NOT NULL DEFAULT '0',
  `ControllerOffsetType` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ControllerId`),
  UNIQUE INDEX `FastronControllers UNIQUE (ControllerName)` (`ControllerName` ASC),
  INDEX `FastronControllerTypes` (`ControllerType` ASC),
  CONSTRAINT `FastronControllerTypes`
    FOREIGN KEY (`ControllerType`)
    REFERENCES `Instore`.`FastronControllerTypes` (`ControllerType`))
ENGINE = InnoDB
AUTO_INCREMENT = 106
DEFAULT CHARACTER SET = latin1
COMMENT = 'All Controller info. Referenced by FASTAppliances, FastronControllersImages, ParametersSetsController, FastronControllersDescriptions.';

-- ----------------------------------------------------------------------------
-- Table Instore.ForecastAdjustments
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ForecastAdjustments` (
  `ForecastAdjustmentId` VARCHAR(255) NOT NULL,
  `ChainId` INT(4) NULL DEFAULT NULL,
  `SiteId` INT(4) NULL DEFAULT NULL,
  `ProductId` INT(4) NULL DEFAULT NULL,
  `DayOfWeek` INT(4) NULL DEFAULT NULL,
  `IntervalId` INT(4) NULL DEFAULT NULL,
  `AdjustmentPercent` DECIMAL(10,2) NULL DEFAULT NULL,
  `AdjustmentQuantity` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ForecastAdjustmentId`),
  UNIQUE INDEX `UX_ProductDayInterval` (`ChainId` ASC, `SiteId` ASC, `ProductId` ASC, `DayOfWeek` ASC, `IntervalId` ASC),
  CONSTRAINT `FK_FORECASTADJ_REFERENCE_SITESPRODS`
    FOREIGN KEY (`ChainId` , `SiteId` , `ProductId`)
    REFERENCES `Instore`.`SitesProducts` (`ChainId` , `SiteId` , `ProductId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Represents a daily recurring adjustment to the on-hand forecast.  This is the meta data that describes the daily recussing adjustment.  The amount of the adjustment is found in ForecastData for each date/product/interval that it applies to.';

-- ----------------------------------------------------------------------------
-- Table Instore.ForecastData
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ForecastData` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `IntervalId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `EffectiveDate` DATE NOT NULL,
  `Quantity` INT(4) NOT NULL,
  `SafetyStock` INT(4) NOT NULL,
  `Override` TINYINT(4) NOT NULL,
  `LastRecUpdate` DATETIME(6) NOT NULL,
  `ProjectedPieces` INT(4) NULL DEFAULT NULL,
  `AdjustmentQtyDailyRecurring` INT(4) NOT NULL DEFAULT '0',
  `AdjustmentQtyOneTime` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `IntervalId`, `ProductId`, `EffectiveDate`),
  INDEX `ForecastData_index2` (`ChainId` ASC, `SiteId` ASC, `ProductId` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Record forecast data.';

-- ----------------------------------------------------------------------------
-- Table Instore.ForecastTemplates
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ForecastTemplates` (
  `ForecastTemplateID` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `ChainID` INT(4) NOT NULL,
  `SiteID` INT(4) NOT NULL,
  `ProductID` INT(4) NOT NULL,
  `CopyProductID` INT(4) NOT NULL,
  `Ratio` FLOAT(4,0) NOT NULL,
  `IntervalStart` DATE NULL DEFAULT NULL,
  `IntervalEnd` DATE NULL DEFAULT NULL,
  `ActiveStart` DATE NULL DEFAULT NULL,
  `ActiveEnd` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`ForecastTemplateID`),
  INDEX `SitesProducts_3` (`ChainID` ASC, `SiteID` ASC, `ProductID` ASC),
  INDEX `SitesProducts2` (`ChainID` ASC, `SiteID` ASC, `CopyProductID` ASC),
  CONSTRAINT `SitesProducts2`
    FOREIGN KEY (`ChainID` , `SiteID` , `CopyProductID`)
    REFERENCES `Instore`.`SitesProducts` (`ChainId` , `SiteId` , `ProductId`),
  CONSTRAINT `SitesProducts_3`
    FOREIGN KEY (`ChainID` , `SiteID` , `ProductID`)
    REFERENCES `Instore`.`SitesProducts` (`ChainId` , `SiteId` , `ProductId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Mysck.HACCPAlarmsSentLog
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`HACCPAlarmsSentLog` (
  `HACCPAlarmsSentLogId` INT(4) AUTO_INCREMENT NOT NULL,
  `UserId` VARCHAR(64) NOT NULL,
  `UserChainId` INT(4) NOT NULL,
  `UserSiteId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ValueTimeStamp` DATETIME NULL,
  `HACCPId` INT(4) NOT NULL,
  `SiteApplianceId` INT(4) NOT NULL,
  `AlarmSent` INT(4) NOT NULL,
  `AlarmSentTimestamp` DATETIME NOT NULL,
  `DestAddressType` VARCHAR(50) NOT NULL,
  `DestAddress` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`HACCPAlarmsSentLogId`),
  CONSTRAINT `HACCPALARMLOG_HACCPAlarmsSentLog`
    FOREIGN KEY (`ChainId` , `SiteId` , `ValueTimeStamp` , `HACCPId` , `SiteApplianceId` , `AlarmSent`)
    REFERENCES `Instore`.`SitesAppliancesHACCPAlarmLog` (`SiteId` , `ChainId` , `ValueTimeStamp` , `HACCPId` , `SiteApplianceId` , `AlarmSent`),
  CONSTRAINT `UserAlertDest_HACCPAlarmsSentLog`
    FOREIGN KEY (`UserId` , `UserChainId` , `UserSiteId`)
    REFERENCES `Instore`.`UserAlertDestinations` (`UserId` , `ChainId` , `SiteId`))
COMMENT = 'Used to log an instance of a HACCP alarm being sent to a destination.';

-- ----------------------------------------------------------------------------
-- Table Instore.HistoricalHoursOfOperations
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`HistoricalHoursOfOperations` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `TheDate` DATE NOT NULL,
  `OpenTime` TIME NULL DEFAULT NULL,
  `CloseTime` TIME NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `TheDate`),
  CONSTRAINT `FK_HISTORIC_REFERENCE_SITES`
    FOREIGN KEY (`SiteId`, `ChainId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'This table stores the specific historical date of the operation hours data at site level.';

-- ----------------------------------------------------------------------------
-- Table Instore.InterProcessMessages
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`InterProcessMessages` (
  `InterProcessMessageId` INT(4) NOT NULL AUTO_INCREMENT,
  `MessageChannelId` VARCHAR(50) NOT NULL,
  `MessageSentTimeStamp` DATETIME(6) NOT NULL,
  `MessageText` VARCHAR(5000) NOT NULL,
  PRIMARY KEY (`InterProcessMessageId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contains messages for very simple inter-process communication through a queue.  There can only be a single listener per message channel and that listener must poll and delete messages as they are processed.  The producer must only insert completed messages, never update.';

-- ----------------------------------------------------------------------------
-- Table Instore.Locale
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Locale` (
  `LocaleId` INT(4) NOT NULL AUTO_INCREMENT,
  `LocaleCode` VARCHAR(50) NOT NULL,
  `Description` VARCHAR(50) NOT NULL,
  `Enabled` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`LocaleId`))
ENGINE = InnoDB
AUTO_INCREMENT = 153
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contains all locales potentially supported by QPM.';

-- ----------------------------------------------------------------------------
-- Table Instore.SiteDeviceGlobalData
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SiteDeviceGlobalData` (
  `ChainId` INT(4) NOT NULL,
  `DeviceGlobalDataId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  PRIMARY KEY (`ChainId`, `DeviceGlobalDataId`, `SiteId`),
  INDEX `ChainDeviceGlobalData_idx` (`ChainId` ASC, `DeviceGlobalDataId` ASC),
  CONSTRAINT `FK_SITE_DEVICE_GLOBAL_DATA_REFERENCE_CHAIN_DEVICE_GLOBAL_DATA`
    FOREIGN KEY (`ChainId` , `DeviceGlobalDataId`)
    REFERENCES `Instore`.`ChainDeviceGlobalData` (`ChainId` , `DeviceGlobalDataId`));

-- ----------------------------------------------------------------------------
-- Table Instore.LookupList
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`LookupList` (
  `LookupListId` INT(4) NOT NULL AUTO_INCREMENT,
  `Description` CHAR(100) NOT NULL,
  PRIMARY KEY (`LookupListId`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.LookupListItem
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`LookupListItem` (
  `LookupListId` INT(4) NOT NULL,
  `LookupListItemId` INT(4) NOT NULL AUTO_INCREMENT,
  `Description` CHAR(100) NOT NULL,
  PRIMARY KEY (`LookupListItemId`),
  INDEX `LookupList` (`LookupListId` ASC),
  CONSTRAINT `LookupList`
    FOREIGN KEY (`LookupListId`)
    REFERENCES `Instore`.`LookupList` (`LookupListId`))
ENGINE = InnoDB
AUTO_INCREMENT = 114
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.POSOrderStatus
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`POSOrderStatus` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `POSMessageId` INT(4) NOT NULL AUTO_INCREMENT,
  `SiteApplianceId` INT(4) NOT NULL,
  `MessageRecTimeStamp` DATETIME(6) NOT NULL,
  `POSOrderTimeStamp` DATETIME(6) NULL DEFAULT NULL,
  `OrderId` VARCHAR(128) NOT NULL,
  `RegisterId` VARCHAR(128) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `Quantity` INT(4) NOT NULL,
  `QuantityUnfilled` INT(4) NOT NULL,
  `Status` INT(4) NOT NULL,
  `Priority` INT(4) NOT NULL,
  `OrderFilledTimeStamp` DATETIME(6) NULL DEFAULT NULL,
  `QuantitySoldExpired` INT(4) NOT NULL,
  `PreSold` INT(4) NOT NULL DEFAULT '0',
  `CateringOrder` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`POSMessageId`, `ChainId`, `SiteId`, `SiteApplianceId`, `MessageRecTimeStamp`),
  INDEX `POSOrderTimestampIndex` (`POSOrderTimeStamp` ASC),
  INDEX `POSMessageId_idx` (`POSMessageId` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 779609
DEFAULT CHARACTER SET = latin1
COMMENT = 'Used only for McD, it has an extra column to store timestamp for order filled';

-- ----------------------------------------------------------------------------
-- Table Instore.POSSalesData
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`POSSalesData` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `MessageRecTimeStamp` DATETIME(6) NOT NULL,
  `Quantity` INT(4) NOT NULL,
  `CateringOrder` TINYINT(1) NOT NULL DEFAULT '0',
  `BusinessDate` DATE NOT NULL,
  `last_modified` DATETIME(6) NOT NULL,
  `POSMessageId` INT(4) NULL DEFAULT NULL,
  `SiteApplianceId` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `ProductId`, `MessageRecTimeStamp`),
  CONSTRAINT `FK_POSSALESDATA_SITESPRODUCTS`
    FOREIGN KEY (`ChainId` , `SiteId` , `ProductId`)
    REFERENCES `Instore`.`SitesProducts` (`ChainId` , `SiteId` , `ProductId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'This table is an optimized sub-set of data from POSOrderStatus intended for use solely by Forecasting.  The contents are copied/summarized from POSOrderStatus (either from instore or above store via ML).';

-- ----------------------------------------------------------------------------
-- Table Instore.ParameterAttributes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParameterAttributes` (
  `ParameterAttributes` CHAR(10) NOT NULL,
  PRIMARY KEY (`ParameterAttributes`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Domain values Read, Write, Read/Write';

-- ----------------------------------------------------------------------------
-- Table Instore.ParameterEngineeringUnits
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParameterEngineeringUnits` (
  `ParameterEngineeringUnit` CHAR(10) NOT NULL,
  PRIMARY KEY (`ParameterEngineeringUnit`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Defined units for Parameters, eg: Degree, Second.  Referenced by Parameters.';

-- ----------------------------------------------------------------------------
-- Table Instore.ParameterTypes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParameterTypes` (
  `ParameterType` CHAR(20) NOT NULL,
  PRIMARY KEY (`ParameterType`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Domain values System, Appliance, Recipe Stage, Recipe Pre Alarm, Run Time\r\n\r\nOld Type Codes\r\n0	Run Time\r\n1	System\r\n2	Appliance\r\n3	Recipe Stage\r\n4	Recipe Pre Alarm';

-- ----------------------------------------------------------------------------
-- Table Instore.Parameters
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Parameters` (
  `ParameterId` INT(4) NOT NULL AUTO_INCREMENT,
  `ParameterType` CHAR(20) NOT NULL,
  `ParameterAttributes` CHAR(10) NOT NULL,
  `ParameterEngineeringUnit` CHAR(10) NULL DEFAULT NULL,
  `ParameterName` CHAR(50) NOT NULL,
  `ParameterMaxElements` SMALLINT(6) NOT NULL,
  `ParameterDataType` CHAR(16) NULL DEFAULT NULL,
  `ParameterDataSize` INT(4) NULL DEFAULT NULL,
  `ParameterBitOffset` SMALLINT(6) NULL DEFAULT NULL,
  `ParameterFactor` FLOAT(4,0) NULL DEFAULT NULL,
  PRIMARY KEY (`ParameterId`),
  INDEX `ParameterTypes` (`ParameterType` ASC),
  INDEX `ParameterAttributes` (`ParameterAttributes` ASC),
  INDEX `ParametersDataTypes` (`ParameterDataType` ASC, `ParameterDataSize` ASC),
  INDEX `ParameterEngineeringUnits` (`ParameterEngineeringUnit` ASC),
  CONSTRAINT `ParameterAttributes`
    FOREIGN KEY (`ParameterAttributes`)
    REFERENCES `Instore`.`ParameterAttributes` (`ParameterAttributes`),
  CONSTRAINT `ParameterEngineeringUnits`
    FOREIGN KEY (`ParameterEngineeringUnit`)
    REFERENCES `Instore`.`ParameterEngineeringUnits` (`ParameterEngineeringUnit`),
  CONSTRAINT `ParameterTypes`
    FOREIGN KEY (`ParameterType`)
    REFERENCES `Instore`.`ParameterTypes` (`ParameterType`),
  CONSTRAINT `ParametersDataTypes`
    FOREIGN KEY (`ParameterDataType` , `ParameterDataSize`)
    REFERENCES `Instore`.`ParametersDataTypes` (`ParameterDataType` , `ParameterDataSize`))
ENGINE = InnoDB
AUTO_INCREMENT = 513
DEFAULT CHARACTER SET = latin1
COMMENT = 'All info about each Parameter. Referenced by ChainsRecipesParameters, ParameterSetsItems, EventsToLog, SitesAppliancesCookLogsEvents, and ReportParameters.';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersDataTypes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersDataTypes` (
  `ParameterDataType` CHAR(16) NOT NULL,
  `ParameterDataSize` INT(4) NOT NULL,
  `ParameterDataTypeCode` SMALLINT(6) NOT NULL,
  PRIMARY KEY (`ParameterDataType`, `ParameterDataSize`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Defined data type for parameters, eg: Integer, Byte, Long, String. Referenced by Parameters, ParametersSetsItems.';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersSets
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersSets` (
  `ParameterSetId` INT(4) NOT NULL AUTO_INCREMENT,
  `ParameterSetName` CHAR(50) NOT NULL,
  `ParameterSetReleaseDate` DATETIME(6) NULL DEFAULT NULL,
  `ParametersSetType` CHAR(15) NOT NULL,
  PRIMARY KEY (`ParameterSetId`),
  UNIQUE INDEX `ParametersSets UNIQUE (ParameterSetName)` (`ParameterSetName` ASC),
  INDEX `ParametersSetsType` (`ParametersSetType` ASC),
  CONSTRAINT `ParametersSetsType`
    FOREIGN KEY (`ParametersSetType`)
    REFERENCES `Instore`.`ParametersSetsType` (`ParametersSetType`))
ENGINE = InnoDB
AUTO_INCREMENT = 61
DEFAULT CHARACTER SET = latin1
COMMENT = 'Info about ParameterSets, eg: Id, Name, Type. Referenced by ParametersSetsItems, ChainsParametersSets, ParametersSetsAppliance,ParametersSetsController, ParametersSetsDescriptions.';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersSetsAppliance
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersSetsAppliance` (
  `ParameterSetId` INT(4) NOT NULL,
  `ApplianceId` INT(4) NOT NULL,
  PRIMARY KEY (`ParameterSetId`, `ApplianceId`),
  INDEX `Appliances_3` (`ApplianceId` ASC),
  CONSTRAINT `Appliances_3`
    FOREIGN KEY (`ApplianceId`)
    REFERENCES `Instore`.`Appliances` (`ApplianceId`),
  CONSTRAINT `ParametersSets_1`
    FOREIGN KEY (`ParameterSetId`)
    REFERENCES `Instore`.`ParametersSets` (`ParameterSetId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associate a ParameterSet with an Appliance.';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersSetsController
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersSetsController` (
  `ParameterSetId` INT(4) NOT NULL,
  `ControllerId` INT(4) NOT NULL,
  PRIMARY KEY (`ParameterSetId`, `ControllerId`),
  INDEX `FastronControllers_3` (`ControllerId` ASC),
  CONSTRAINT `FastronControllers_3`
    FOREIGN KEY (`ControllerId`)
    REFERENCES `Instore`.`FastronControllers` (`ControllerId`),
  CONSTRAINT `ParametersSets_2`
    FOREIGN KEY (`ParameterSetId`)
    REFERENCES `Instore`.`ParametersSets` (`ParameterSetId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associate a ParameterSet with a Controller.';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersSetsDescriptions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersSetsDescriptions` (
  `ParameterSetID` INT(4) NOT NULL,
  `ParameterSetDescription` LONGTEXT NOT NULL,
  PRIMARY KEY (`ParameterSetID`),
  CONSTRAINT `ParametersSets_3`
    FOREIGN KEY (`ParameterSetID`)
    REFERENCES `Instore`.`ParametersSets` (`ParameterSetId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Description for ParameterSet. ';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersSetsItems
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersSetsItems` (
  `ParameterSetId` INT(4) NOT NULL,
  `ParameterPhysicalAddress` INT(4) NOT NULL,
  `ParameterId` INT(4) NOT NULL,
  `NumberOfElements` SMALLINT(6) NOT NULL,
  `ParameterDataType` CHAR(16) NOT NULL,
  `ParameterDataSize` INT(4) NOT NULL,
  `ParameterSetItemID` INT(4) NOT NULL AUTO_INCREMENT,
  `ParameterBitOffset` SMALLINT(6) NULL DEFAULT NULL,
  `ParameterFactor` FLOAT(4,0) NULL DEFAULT NULL,
  PRIMARY KEY (`ParameterSetItemID`, `ParameterSetId`),
  INDEX `ParameterSetItemID_idx` (`ParameterSetItemID` ASC),
  INDEX `Parameters_1` (`ParameterId` ASC),
  INDEX `ParametersDataTypes_1` (`ParameterDataType` ASC, `ParameterDataSize` ASC),
  CONSTRAINT `ParametersDataTypes_1`
    FOREIGN KEY (`ParameterDataType` , `ParameterDataSize`)
    REFERENCES `Instore`.`ParametersDataTypes` (`ParameterDataType` , `ParameterDataSize`),
  CONSTRAINT `ParametersSets_4`
    FOREIGN KEY (`ParameterSetId`)
    REFERENCES `Instore`.`ParametersSets` (`ParameterSetId`),
  CONSTRAINT `Parameters_1`
    FOREIGN KEY (`ParameterId`)
    REFERENCES `Instore`.`Parameters` (`ParameterId`))
ENGINE = InnoDB
AUTO_INCREMENT = 1051
DEFAULT CHARACTER SET = latin1
COMMENT = 'List all info about ParameterSet, referenced by ParametersSetsItemsValues, and SitesAppliancesParametersSetsVerification.';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersSetsItemsValues
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersSetsItemsValues` (
  `ParameterSetId` INT(4) NOT NULL,
  `ParameterSetItemID` INT(4) NOT NULL,
  `ParameterElementNo` INT(4) NOT NULL,
  `ParameterSetItemValue` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`ParameterSetId`, `ParameterSetItemID`, `ParameterElementNo`),
  CONSTRAINT `ParametersSetsItems`
    FOREIGN KEY (`ParameterSetId` , `ParameterSetItemID`)
    REFERENCES `Instore`.`ParametersSetsItems` (`ParameterSetId` , `ParameterSetItemID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Item Value for ParameterSet, referenced by ChainsParametersSetsItemsValues.';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersSetsOIDsMapping
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersSetsOIDsMapping` (
  `ParameterSetId` INT(4) NOT NULL,
  `ParameterOID` INT(4) NOT NULL,
  `ParameterId` INT(4) NOT NULL,
  `ParameterDataType` CHAR(16) NOT NULL,
  `ParameterDataSize` INT(4) NOT NULL,
  `Row` INT(4) NULL DEFAULT NULL,
  `Column` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ParameterSetId`, `ParameterOID`, `ParameterId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Map OID with ParameterSet and Parameter';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersSetsType
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersSetsType` (
  `ParametersSetType` CHAR(15) NOT NULL,
  PRIMARY KEY (`ParametersSetType`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Domain Values: Controller / Appliance';

-- ----------------------------------------------------------------------------
-- Table Instore.ParametersSetsValidParameterTypes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ParametersSetsValidParameterTypes` (
  `ParameterType` CHAR(20) NOT NULL,
  `ParametersSetType` CHAR(15) NOT NULL,
  PRIMARY KEY (`ParameterType`, `ParametersSetType`),
  INDEX `ParametersSetsType_1` (`ParametersSetType` ASC),
  CONSTRAINT `ParameterTypes_2`
    FOREIGN KEY (`ParameterType`)
    REFERENCES `Instore`.`ParameterTypes` (`ParameterType`),
  CONSTRAINT `ParametersSetsType_1`
    FOREIGN KEY (`ParametersSetType`)
    REFERENCES `Instore`.`ParametersSetsType` (`ParametersSetType`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associate a ParameterType with a ParameterSet type.';

-- ----------------------------------------------------------------------------
-- Table Instore.Persons
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Persons` (
  `PersonId` INT(4) NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(150) NULL DEFAULT NULL,
  `MiddleName` VARCHAR(150) NULL DEFAULT NULL,
  `LastName` VARCHAR(150) NULL DEFAULT NULL,
  `Email1` VARCHAR(100) NULL DEFAULT NULL,
  `Email2` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`PersonId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.PersonsPhoneNumbers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PersonsPhoneNumbers` (
  `PersonsPhoneNumbersId` INT(4) NOT NULL AUTO_INCREMENT,
  `PersonId` INT(4) NOT NULL,
  `TypeLookupListItemId` INT(4) NULL DEFAULT NULL,
  `PhoneNumber` VARCHAR(30) NOT NULL,
  `PrimaryFlag` CHAR(1) NOT NULL,
  PRIMARY KEY (`PersonsPhoneNumbersId`),
  INDEX `PersonsPhoneNumbers_Person` (`PersonId` ASC),
  INDEX `PersonsPhoneNumbers_LookupListItem` (`TypeLookupListItemId` ASC),
  CONSTRAINT `PersonsPhoneNumbers_LookupListItem`
    FOREIGN KEY (`TypeLookupListItemId`)
    REFERENCES `Instore`.`LookupListItem` (`LookupListItemId`),
  CONSTRAINT `PersonsPhoneNumbers_Person`
    FOREIGN KEY (`PersonId`)
    REFERENCES `Instore`.`Persons` (`PersonId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associate each Person with a PhoneNumber.';

-- ----------------------------------------------------------------------------
-- Table Instore.PosCheckItemModifiers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosCheckItemModifiers` (
  `PosCheckItemModifierId` VARCHAR(255) NOT NULL,
  `ModifierName` VARCHAR(400) NOT NULL,
  `Verb` VARCHAR(100) NULL DEFAULT NULL,
  `Quantity` INT(4) NULL DEFAULT NULL,
  `PosCheckItemId` VARCHAR(255) NOT NULL,
  `UnitCost` DECIMAL(10,2) NULL DEFAULT NULL,
  `ItemTotal` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`PosCheckItemModifierId`),
  INDEX `PosCheckItems` (`PosCheckItemId` ASC),
  CONSTRAINT `PosCheckItems`
    FOREIGN KEY (`PosCheckItemId`)
    REFERENCES `Instore`.`PosCheckItems` (`PosCheckItemId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contains all menu line item modifiers for a check line item.';

-- ----------------------------------------------------------------------------
-- Table Instore.PosCheckItems
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosCheckItems` (
  `PosCheckItemId` VARCHAR(255) NOT NULL,
  `ItemName` VARCHAR(400) NOT NULL,
  `Quantity` INT(4) NOT NULL,
  `PosCheckId` VARCHAR(255) NOT NULL,
  `ItemIsVoid` TINYINT(1) NOT NULL DEFAULT '0',
  `UnitCost` DECIMAL(10,2) NULL DEFAULT NULL,
  `ItemTotal` DECIMAL(10,2) NULL DEFAULT NULL,
  `ItemDisplayName` VARCHAR(400) NULL DEFAULT NULL,
  PRIMARY KEY (`PosCheckItemId`),
  INDEX `PosChecks` (`PosCheckId` ASC),
  CONSTRAINT `PosChecks`
    FOREIGN KEY (`PosCheckId`)
    REFERENCES `Instore`.`PosChecks` (`PosCheckId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contains all menu line items on a complete completed checks/transactions that has been sent to SCK.  PosCheckItems make contain modifiers.';

-- ----------------------------------------------------------------------------
-- Table Instore.PosChecks
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosChecks` (
  `PosCheckId` VARCHAR(255) NOT NULL,
  `CheckId` VARCHAR(200) NOT NULL,
  `RegisterId` VARCHAR(200) NOT NULL,
  `ServerId` VARCHAR(200) NULL DEFAULT NULL,
  `CheckTimestamp` DATETIME(6) NOT NULL,
  `CheckReceivedTimestamp` DATETIME NOT NULL,
  `PosSystemId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `LastModifiedTimestamp` DATETIME(6) NOT NULL,
  `LastModifiedReceivedTimestamp` DATETIME(6) NOT NULL,
  `CheckIsVoid` TINYINT(1) NOT NULL DEFAULT '0',
  `NonDepleting` TINYINT(1) NULL DEFAULT NULL,
  `SubTotal` DECIMAL(10,2) NULL DEFAULT NULL,
  `Tax` DECIMAL(10,2) NULL DEFAULT NULL,
  `Total` DECIMAL(10,2) NULL DEFAULT NULL,
  `CurrencyCode` VARCHAR(10) NOT NULL DEFAULT 'USD',
  `IsAccepted` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PosCheckId`),
  INDEX `Sites_5` (`ChainId` ASC, `SiteId` ASC),
  INDEX `PosSystems` (`PosSystemId` ASC),
  CONSTRAINT `PosSystems`
    FOREIGN KEY (`PosSystemId`)
    REFERENCES `Instore`.`PosSystems` (`PosSystemId`),
  CONSTRAINT `Sites_5`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contains all POS COMPLETED checks/transactions sent to SCK.  Checks contain check items.';

-- ----------------------------------------------------------------------------
-- Table Instore.PosChecksUnmappedItems
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosChecksUnmappedItems` (
  `UnmappedPosSystemId` INT(4) NOT NULL,
  `UnmappedCode` VARCHAR(400) NOT NULL,
  `UnmappedType` VARCHAR(100) NOT NULL,
  `UnmappedVerb` VARCHAR(100) NOT NULL DEFAULT ' ',
  `ChainId` INT(4) NOT NULL,
  `PosCheckId` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`UnmappedPosSystemId`, `UnmappedCode`(255), `UnmappedType`, `UnmappedVerb`, `ChainId`, `PosCheckId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.PosMenuItemProducts
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosMenuItemProducts` (
  `PosMenuItemProductId` INT(4) NOT NULL AUTO_INCREMENT,
  `PosMenuItemId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `Quantity` INT(4) NOT NULL,
  PRIMARY KEY (`PosMenuItemProductId`),
  UNIQUE INDEX `PosMenuItemProducts UNIQUE (PosMenuItemId,ChainId,ProductId)` (`PosMenuItemId` ASC, `ChainId` ASC, `ProductId` ASC),
  INDEX `PosMenuItemProducts_ChainsProducts` (`ChainId` ASC, `ProductId` ASC),
  CONSTRAINT `PosMenuItemProducts_ChainsProducts`
    FOREIGN KEY (`ChainId` , `ProductId`)
    REFERENCES `Instore`.`ChainsProducts` (`ChainId` , `ProductId`),
  CONSTRAINT `PosMenuItemProducts_PosMenuItems`
    FOREIGN KEY (`PosMenuItemId`)
    REFERENCES `Instore`.`PosMenuItems` (`PosMenuItemId`))
ENGINE = InnoDB
AUTO_INCREMENT = 49
DEFAULT CHARACTER SET = latin1
COMMENT = 'The constituent products and quantities that make up an item on the menu.';

-- ----------------------------------------------------------------------------
-- Table Instore.PosMenuItems
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosMenuItems` (
  `PosMenuItemId` INT(4) NOT NULL AUTO_INCREMENT,
  `PosMenuId` INT(4) NOT NULL,
  `PosIdentifier` VARCHAR(200) NOT NULL,
  `PosMenuModifierId` INT(4) NULL DEFAULT NULL,
  `MenuItemName` VARCHAR(200) NULL DEFAULT NULL,
  `CateringCode` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PosMenuItemId`),
  INDEX `PosMenuItems_PosMenus` (`PosMenuId` ASC),
  INDEX `PosMenuItems_PosMenuModifiers` (`PosMenuModifierId` ASC),
  CONSTRAINT `PosMenuItems_PosMenuModifiers`
    FOREIGN KEY (`PosMenuModifierId`)
    REFERENCES `Instore`.`PosMenuModifiers` (`PosMenuModifierId`),
  CONSTRAINT `PosMenuItems_PosMenus`
    FOREIGN KEY (`PosMenuId`)
    REFERENCES `Instore`.`PosMenus` (`PosMenuId`))
ENGINE = InnoDB
AUTO_INCREMENT = 45
DEFAULT CHARACTER SET = latin1
COMMENT = 'Captures both menu items and modifiers';

-- ----------------------------------------------------------------------------
-- Table Instore.PosMenuModifiers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosMenuModifiers` (
  `PosMenuModifierId` INT(4) NOT NULL AUTO_INCREMENT,
  `PosMenuId` INT(4) NOT NULL,
  `PosIdentifier` VARCHAR(200) NOT NULL,
  `ModifierType` VARCHAR(200) NOT NULL DEFAULT 'ABSOLUTE',
  `MenuModifierDesc` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`PosMenuModifierId`),
  UNIQUE INDEX `PosMenuModifiers UNIQUE (PosMenuId,PosIdentifier)` (`PosMenuId` ASC, `PosIdentifier` ASC),
  CONSTRAINT `PosMenuModifiers_PosMenus`
    FOREIGN KEY (`PosMenuId`)
    REFERENCES `Instore`.`PosMenus` (`PosMenuId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'The levels that can be used by a pos less/more modifier.';

-- ----------------------------------------------------------------------------
-- Table Instore.PosMenuUnmappedItems
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosMenuUnmappedItems` (
  `PosMenuId` INT(4) NOT NULL,
  `UnmappedPosSystemId` INT(4) NOT NULL,
  `UnmappedCode` VARCHAR(400) NOT NULL,
  `UnmappedType` VARCHAR(100) NOT NULL,
  `UnmappedVerb` VARCHAR(100) NOT NULL DEFAULT ' ',
  `ChainId` INT(4) NOT NULL,
  `IsMapped` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`PosMenuId`, `UnmappedPosSystemId`, `UnmappedCode`(255), `UnmappedType`, `UnmappedVerb`, `ChainId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.PosMenus
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosMenus` (
  `PosMenuId` INT(4) NOT NULL AUTO_INCREMENT,
  `ChainId` INT(4) NOT NULL,
  `PosSystemId` INT(4) NOT NULL,
  `PosMenuName` VARCHAR(400) NOT NULL,
  `VersionName` VARCHAR(200) NOT NULL,
  `CreationTimestamp` DATETIME(6) NOT NULL,
  `ModifiedTimestamp` DATETIME(6) NOT NULL,
  PRIMARY KEY (`PosMenuId`),
  UNIQUE INDEX `PosMenus UNIQUE (ChainId,PosSystemId,PosMenuName,VersionName)` (`ChainId` ASC, `PosSystemId` ASC, `PosMenuName`(255) ASC, `VersionName` ASC),
  INDEX `PosMenus_PosSystems` (`PosSystemId` ASC),
  CONSTRAINT `PosMenus_Chains`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`),
  CONSTRAINT `PosMenus_PosSystems`
    FOREIGN KEY (`PosSystemId`)
    REFERENCES `Instore`.`PosSystems` (`PosSystemId`))
ENGINE = InnoDB
AUTO_INCREMENT = 219
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contains the menu mapping data for a chain and pos system.';

-- ----------------------------------------------------------------------------
-- Table Instore.PosSubMenuItems
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosSubMenuItems` (
  `PosSubMenuItemId` INT(4) NOT NULL AUTO_INCREMENT,
  `ParentMenuItemId` INT(4) NOT NULL,
  `ChildMenuItemId` INT(4) NOT NULL,
  PRIMARY KEY (`PosSubMenuItemId`),
  UNIQUE INDEX `PosSubMenuItems UNIQUE (ParentMenuItemId,ChildMenuItemId)` (`ParentMenuItemId` ASC, `ChildMenuItemId` ASC),
  INDEX `PosSubMenuItems_MenuItems_Child` (`ChildMenuItemId` ASC),
  CONSTRAINT `PosSubMenuItems_MenuItems_Child`
    FOREIGN KEY (`ChildMenuItemId`)
    REFERENCES `Instore`.`PosMenuItems` (`PosMenuItemId`),
  CONSTRAINT `PosSubMenuItems_MenuItems_Parent`
    FOREIGN KEY (`ParentMenuItemId`)
    REFERENCES `Instore`.`PosMenuItems` (`PosMenuItemId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Identifies a parent/child relationship between two menu items.';

-- ----------------------------------------------------------------------------
-- Table Instore.PosSystems
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosSystems` (
  `PosSystemId` INT(4) NOT NULL,
  `SystemName` VARCHAR(200) NOT NULL,
  `Manufacturer` VARCHAR(200) NULL DEFAULT NULL,
  `SwName` VARCHAR(200) NULL DEFAULT NULL,
  `SwVersion` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`PosSystemId`),
  UNIQUE INDEX `UIDX_POS_SYSTEMS_NAME` (`SystemName` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'All POS Systems that SCK integrates with to recieve check transactions.';

-- ----------------------------------------------------------------------------
-- Table Instore.PosUnmappedItems
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`PosUnmappedItems` (
  `UnmappedPosSystemId` INT(4) NOT NULL,
  `UnmappedCode` VARCHAR(400) NOT NULL,
  `UnmappedType` VARCHAR(100) NOT NULL,
  `UnmappedVerb` VARCHAR(100) NOT NULL DEFAULT ' ',
  `ChainId` INT(4) NOT NULL,
  `ParentItemName` VARCHAR(400) NULL DEFAULT NULL,
  `IgnoredDeleted` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UnmappedPosSystemId`, `UnmappedCode`(255), `UnmappedType`, `UnmappedVerb`, `ChainId`),
  INDEX `POSUNMAP_CHAINS` (`ChainId` ASC),
  CONSTRAINT `POSUNMAP_CHAINS`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`),
  CONSTRAINT `POSUNMAP_POSSystems`
    FOREIGN KEY (`UnmappedPosSystemId`)
    REFERENCES `Instore`.`PosSystems` (`PosSystemId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.Privilege
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Privilege` (
  `PrivilegeId` INT(4) NOT NULL AUTO_INCREMENT,
  `PrivilegeCode` VARCHAR(100) NOT NULL,
  `PrivilegeDescription` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`PrivilegeId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.ProductBehaviors
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ProductBehaviors` (
  `ProductBehaviorID` INT(4) NOT NULL AUTO_INCREMENT,
  `ProductBehaviorCode` VARCHAR(32) NOT NULL,
  `ProductBehaviorName` VARCHAR(256) NOT NULL,
  `ProductBehaviorType` VARCHAR(64) NULL DEFAULT NULL,
  PRIMARY KEY (`ProductBehaviorID`),
  UNIQUE INDEX `ProductBehaviors UNIQUE (ProductBehaviorCode)` (`ProductBehaviorCode` ASC),
  UNIQUE INDEX `ProductBehaviors UNIQUE (ProductBehaviorName)` (`ProductBehaviorName`(255) ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.ProductTypes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ProductTypes` (
  `ProductTypeID` INT(4) NOT NULL AUTO_INCREMENT,
  `ProductTypeName` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`ProductTypeID`),
  UNIQUE INDEX `ProductTypes UNIQUE (ProductTypeName)` (`ProductTypeName`(255) ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 232
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.ProductTypesBehaviors
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`ProductTypesBehaviors` (
  `ProductTypeBehaviorID` INT(4) NOT NULL AUTO_INCREMENT,
  `ProductTypeID` INT(4) NOT NULL,
  `ProductBehaviorID` INT(4) NOT NULL,
  `ProductBehaviorValue` VARCHAR(32) NULL DEFAULT NULL,
  PRIMARY KEY (`ProductTypeBehaviorID`),
  UNIQUE INDEX `ProductTypesBehaviors UNIQUE (ProductTypeID,ProductBehaviorID)` (`ProductTypeID` ASC, `ProductBehaviorID` ASC),
  INDEX `ProductBehaviors` (`ProductBehaviorID` ASC),
  CONSTRAINT `ProductBehaviors`
    FOREIGN KEY (`ProductBehaviorID`)
    REFERENCES `Instore`.`ProductBehaviors` (`ProductBehaviorID`),
  CONSTRAINT `ProductTypes`
    FOREIGN KEY (`ProductTypeID`)
    REFERENCES `Instore`.`ProductTypes` (`ProductTypeID`))
ENGINE = InnoDB
AUTO_INCREMENT = 92
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.Reports
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Reports` (
  `ReportId` INT(4) NOT NULL AUTO_INCREMENT,
  `ReportDisplayName` VARCHAR(100) NOT NULL,
  `ReportName` VARCHAR(100) NOT NULL,
  `ReportType` CHAR(10) NOT NULL DEFAULT 'BIRT',
  `ReportCategory` CHAR(10) NOT NULL,
  PRIMARY KEY (`ReportId`),
  UNIQUE INDEX `UQ_RptDisplayName` (`ReportDisplayName` ASC),
  UNIQUE INDEX `UQ_RptNameType` (`ReportName` ASC, `ReportType` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'All info about a configured report that is available in the system.';

-- ----------------------------------------------------------------------------
-- Table Instore.Role
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Role` (
  `RoleId` INT(4) NOT NULL AUTO_INCREMENT,
  `RoleDescription` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`RoleId`),
  UNIQUE INDEX `UQ_Role` (`RoleDescription` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.RolePrivilege
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`RolePrivilege` (
  `RolePrivilegeId` INT(4) NOT NULL AUTO_INCREMENT,
  `RoleId` INT(4) NOT NULL,
  `PrivilegeId` INT(4) NOT NULL,
  PRIMARY KEY (`RolePrivilegeId`),
  UNIQUE INDEX `UQ_RolePrivilege` (`RoleId` ASC, `PrivilegeId` ASC),
  INDEX `RolePrivilege_Privilege` (`PrivilegeId` ASC),
  CONSTRAINT `RolePrivilege_Privilege`
    FOREIGN KEY (`PrivilegeId`)
    REFERENCES `Instore`.`Privilege` (`PrivilegeId`),
  CONSTRAINT `RolePrivilege_Role`
    FOREIGN KEY (`RoleId`)
    REFERENCES `Instore`.`Role` (`RoleId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.SCKNetworkApplianceStatus
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SCKNetworkApplianceStatus` (
  `SCKNetworkApplianceStatus` SMALLINT(6) NOT NULL,
  `SCKNetworkApplianceStatusDescription` CHAR(80) NULL DEFAULT NULL,
  `KSMStatusColor` INT(4) NULL DEFAULT NULL,
  `KSMBlinkEnable` INT(4) NULL DEFAULT NULL,
  `MonStatusColor` INT(4) NULL DEFAULT NULL,
  `ParameterSetID` INT(4) NOT NULL,
  `ParameterID` INT(4) NOT NULL,
  PRIMARY KEY (`SCKNetworkApplianceStatus`, `ParameterSetID`, `ParameterID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Monitor the Status for Network Appliance, each Status is combined with a ParameterID and a ParameterSetID.';

-- ----------------------------------------------------------------------------
-- Table Instore.SckNetworksConfigs
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SckNetworksConfigs` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `NetworkId` SMALLINT(6) NOT NULL,
  `ConfigId` INT(4) NOT NULL AUTO_INCREMENT,
  `NetworkDescriptorId` VARCHAR(80) NOT NULL,
  `DigiMacAddress` VARCHAR(40) NULL DEFAULT NULL,
  `NetworkEnabled` TINYINT(4) NOT NULL DEFAULT '1',
  `DigiEncryptionKey` VARCHAR(40) NULL DEFAULT NULL,
  `DigiEncryptionEnabled` TINYINT(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ConfigId`, `ChainId`, `SiteId`),
  INDEX `ConfigId_idx` (`ConfigId` ASC),
  INDEX `SitesSCKNetworks` (`ChainId` ASC, `SiteId` ASC, `NetworkId` ASC),
  CONSTRAINT `SitesSCKNetworks`
    FOREIGN KEY (`ChainId` , `SiteId` , `NetworkId`)
    REFERENCES `Instore`.`SitesSCKNetworks` (`ChainId` , `SiteId` , `SCKNetworkId`))
ENGINE = InnoDB
AUTO_INCREMENT = 399
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.SckProductFeatures
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SckProductFeatures` (
  `SckProductFeatureId` INT(4) NOT NULL,
  `Name` VARCHAR(100) NOT NULL,
  `Description` VARCHAR(250) NULL DEFAULT NULL,
  `ExternalStringId` VARCHAR(200) NULL DEFAULT NULL,
  `ChainLevelFeature` TINYINT(1) NOT NULL,
  `SiteLevelFeature` TINYINT(1) NOT NULL,
  PRIMARY KEY (`SckProductFeatureId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Represents a feature of the SCK product that may be turned on/off.';

-- ----------------------------------------------------------------------------
-- Table Instore.SiteAlertConfig
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SiteAlertConfig` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `AlertTypeID` INT(4) NOT NULL,
  `Enabled` TINYINT(1) NOT NULL DEFAULT '0',
  `SnoozeEnabled` TINYINT(1) NULL DEFAULT NULL,
  `SnoozeStart` DATETIME NULL DEFAULT NULL,
  `SnoozeEnd` DATETIME NULL DEFAULT NULL,
  `MaxCount` INT(4) NULL DEFAULT NULL,
  `RepeatEnabled` TINYINT(1) NULL DEFAULT NULL,
  `Percent1` DECIMAL(10,5) NULL DEFAULT NULL,
  `Percent2` DECIMAL(10,5) NULL DEFAULT NULL,
  `Time1` INT(4) NULL DEFAULT NULL,
  `Time2` INT(4) NULL DEFAULT NULL,
  `NotificationType` VARCHAR(20) NULL DEFAULT NULL,
  `NotificationHours` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `AlertTypeID`),
  INDEX `FK_SiteAlert_To_AlertTypes` (`AlertTypeID` ASC),
  CONSTRAINT `FK_SiteAlertConfig_TO_Sites`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`),
  CONSTRAINT `FK_SiteAlert_To_AlertTypes`
    FOREIGN KEY (`AlertTypeID`)
    REFERENCES `Instore`.`AlertTypes` (`AlertTypeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.SiteEmployeeTimeClockEvents
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SiteEmployeeTimeClockEvents` (
  `SiteEmployeTimeClockEventId` VARCHAR(255) NOT NULL,
  `SiteEmployeeId` VARCHAR(255) NOT NULL,
  `Type` VARCHAR(100) NOT NULL,
  `EventTime` DATETIME NOT NULL,
  `DeviceId` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`SiteEmployeTimeClockEventId`),
  INDEX `FK_SITEEMPL_REFERENCE_SITEEMPL` (`SiteEmployeeId` ASC),
  CONSTRAINT `FK_SITEEMPL_REFERENCE_SITEEMPL`
    FOREIGN KEY (`SiteEmployeeId`)
    REFERENCES `Instore`.`SiteEmployees` (`SiteEmployeeId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Rpresents a time clock in or time clock out event.';

-- ----------------------------------------------------------------------------
-- Table Instore.SiteEmployees
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SiteEmployees` (
  `SiteEmployeeId` VARCHAR(255) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ChainJobFunctionId` VARCHAR(255) NULL DEFAULT NULL,
  `Identifier` VARCHAR(200) NOT NULL,
  `FirstName` VARCHAR(200) NULL DEFAULT NULL,
  `LastName` VARCHAR(200) NULL DEFAULT NULL,
  `EmployeeNumber` VARCHAR(200) NULL DEFAULT NULL,
  `StartDate` DATE NULL DEFAULT NULL,
  `EndDate` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`SiteEmployeeId`),
  INDEX `FK_SITEEMPL_EMPLOYEE__SITES` (`ChainId` ASC, `SiteId` ASC),
  INDEX `FK_SITEEMPL_EMPLOYEE__CHAINJOB` (`ChainJobFunctionId` ASC),
  CONSTRAINT `FK_SITEEMPL_EMPLOYEE__CHAINJOB`
    FOREIGN KEY (`ChainJobFunctionId`)
    REFERENCES `Instore`.`ChainJobFunctions` (`ChainJobFunctionId`),
  CONSTRAINT `FK_SITEEMPL_EMPLOYEE__SITES`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Represents an employee working in the store/restaurant.';

-- ----------------------------------------------------------------------------
-- Table Instore.SiteLevelFeatures
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SiteLevelFeatures` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SckProductFeatureId` INT(4) NOT NULL,
  `FeatureEnabled` TINYINT(1) NULL DEFAULT NULL,
  `Value` VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `SckProductFeatureId`),
  INDEX `FK_SITELEVE_REFERENCE_SCKPRODU` (`SckProductFeatureId` ASC),
  CONSTRAINT `FK_SITELEVE_REFERENCE_SCKPRODU`
    FOREIGN KEY (`SckProductFeatureId`)
    REFERENCES `Instore`.`SckProductFeatures` (`SckProductFeatureId`),
  CONSTRAINT `FK_SITELEVE_REFERENCE_SITES`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.SiteProductAlerts
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SiteProductAlerts` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `AlertTypeID` INT(4) NOT NULL,
  `Enabled` TINYINT(1) NULL DEFAULT NULL,
  `SnoozeEnabled` TINYINT(1) NULL DEFAULT NULL,
  `SnoozeStart` DATETIME NULL DEFAULT NULL,
  `SnoozeEnd` DATETIME NULL DEFAULT NULL,
  `TimeAllowed` INT(4) NULL DEFAULT NULL,
  `Percent1` DECIMAL(10,5) NULL DEFAULT NULL,
  `Percent2` DECIMAL(10,5) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `ProductId`, `AlertTypeID`),
  INDEX `FK_SitePproductAlerts_TO_AlertTypes` (`AlertTypeID` ASC),
  CONSTRAINT `FK_SitePproductAlerts_TO_AlertTypes`
    FOREIGN KEY (`AlertTypeID`)
    REFERENCES `Instore`.`AlertTypes` (`AlertTypeID`),
  CONSTRAINT `FK_SiteProductAlters_TO_SitesProducts`
    FOREIGN KEY (`ChainId` , `SiteId` , `ProductId`)
    REFERENCES `Instore`.`SitesProducts` (`ChainId` , `SiteId` , `ProductId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.SiteSalesData
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SiteSalesData` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `BusinessDate` DATE NOT NULL,
  `SalesTotal` DECIMAL(18,2) NOT NULL,
  `CurrencyCode` VARCHAR(10) NOT NULL DEFAULT 'USD',
  PRIMARY KEY (`ChainId`, `SiteId`, `BusinessDate`),
  CONSTRAINT `FK_SITESALE_REFERENCE_SITES`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Daily sales summary data by site.';

-- ----------------------------------------------------------------------------
-- Table Instore.Sites
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Sites` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL AUTO_INCREMENT,
  `SiteName` VARCHAR(250) NOT NULL,
  `SiteCategoryId` INT(4) NULL DEFAULT NULL,
  `SiteNumber` VARCHAR(80) NULL DEFAULT NULL,
  `TZO` INT(4) NULL DEFAULT NULL,
  `BusinessWeekStartDay` INT(4) NOT NULL DEFAULT '1',
  `ForecastOverridesAllowedForAllFlag` TINYINT(1) NOT NULL DEFAULT '1',
  `BusinessDayStart` TIME(6) NOT NULL,
  `SundayBusinessStartTime` TIME(6) NULL DEFAULT NULL,
  `MondayBusinessStartTime` TIME(6) NULL DEFAULT NULL,
  `TuesdayBusinessStartTime` TIME(6) NULL DEFAULT NULL,
  `WednesdayBusinessStartTime` TIME(6) NULL DEFAULT NULL,
  `ThursdayBusinessStartTime` TIME(6) NULL DEFAULT NULL,
  `FridayBusinessStartTime` TIME(6) NULL DEFAULT NULL,
  `SaturdayBusinessStartTime` TIME(6) NULL DEFAULT NULL,
  `SundayBusinessEndTime` TIME(6) NULL DEFAULT NULL,
  `MondayBusinessEndTime` TIME(6) NULL DEFAULT NULL,
  `TuesdayBusinessEndTime` TIME(6) NULL DEFAULT NULL,
  `WednesdayBusinessEndTime` TIME(6) NULL DEFAULT NULL,
  `ThursdayBusinessEndTime` TIME(6) NULL DEFAULT NULL,
  `FridayBusinessEndTime` TIME(6) NULL DEFAULT NULL,
  `SaturdayBusinessEndTime` TIME(6) NULL DEFAULT NULL,
  `ForecastLookbackPeriod` TINYINT(1) NULL DEFAULT '3',
  `ForecastSource` VARCHAR(20) NOT NULL DEFAULT 'INTERNAL',
  `DeletedFlag` TINYINT(1) NOT NULL DEFAULT '0',
  `SybaseOEMKey` VARCHAR(1000) NULL DEFAULT 'company=SCK Direct Inc.;application=ASA;signature=000fa55157edb8e14d818eb4fe3db41447146f1571g2eb956d953e2b2c4cff9a01d3a0df2369d6d74da',
  `CookAlarmMediaId` INT(4) NULL DEFAULT NULL,
  `WasteAlarmMediaId` INT(4) NULL DEFAULT NULL,
  `UpdateAlarmMediaId` INT(4) NULL DEFAULT NULL,
  `BatchExpireAlarmMediaId` INT(4) NULL DEFAULT NULL,
  `SiteFlags` BIT(1) NOT NULL DEFAULT b'0',
  `AlertsEnabled` INT(4) NOT NULL DEFAULT '0',
  `LocaleId` INT(4) NULL DEFAULT NULL,
  `Description` VARCHAR(200) NULL DEFAULT NULL,
  `CurrencyCode` VARCHAR(10) NOT NULL DEFAULT 'USD',
  `Latitude` DECIMAL(12,8) NULL DEFAULT NULL,
  `Longitude` DECIMAL(12,8) NULL DEFAULT NULL,
  `ForecastGenTime` TIME(6) NOT NULL,
  `ForecastGenBusinessDay` VARCHAR(10) NOT NULL DEFAULT 'SAME_DATE',
  `BrandId` INT(4) NULL DEFAULT NULL,
  `CarryOverEnabled` INT(4) NULL DEFAULT '0',
  `LastCarryOverTime` DATETIME(6) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`),
  INDEX `SiteId_idx` (`SiteId` ASC),
  INDEX `Brands` (`BrandId` ASC),
  INDEX `Sites_TimeZone` (`TZO` ASC),
  INDEX `SitesCategories` (`ChainId` ASC, `SiteCategoryId` ASC),
  INDEX `FK_SITES_REFERENCE_LOCALE` (`LocaleId` ASC),
  INDEX `FK_SITES_REFERENCE_MEDIA_BATCH_EXP` (`BatchExpireAlarmMediaId` ASC),
  INDEX `FK_SITES_REFERENCE_MEDIA_COOK_ALRM` (`CookAlarmMediaId` ASC),
  INDEX `FK_SITES_REFERENCE_MEDIA_WASTE_ALRM` (`WasteAlarmMediaId` ASC),
  INDEX `FK_SITES_REFERENCE_MEDIA_UPDATE_ALRM` (`UpdateAlarmMediaId` ASC),
  CONSTRAINT `Chains_5`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`),
  CONSTRAINT `FK_SITES_REFERENCE_LOCALE`
    FOREIGN KEY (`LocaleId`)
    REFERENCES `Instore`.`Locale` (`LocaleId`),
  CONSTRAINT `SitesCategories`
    FOREIGN KEY (`ChainId` , `SiteCategoryId`)
    REFERENCES `Instore`.`SitesCategories` (`ChainId` , `SiteCategoryId`),
  CONSTRAINT `Sites_TimeZone`
    FOREIGN KEY (`TZO`)
    REFERENCES `Instore`.`TimeZone` (`GMTDiff`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'List all info about each Site combined with a Chain. Referened by SitesPhoneNumbers, SitesProducts, SitesRecipes, SitesSCKNetworks, and SitesAppliances.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesAppliances
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesAppliances` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ApplianceId` INT(4) NOT NULL,
  `SiteApplianceName` VARCHAR(250) NOT NULL,
  `ControllerId` INT(4) NOT NULL,
  `NumberOfChambers` SMALLINT(6) NOT NULL,
  `ApplianceSerialNumber` VARCHAR(250) NULL DEFAULT NULL,
  `ControllerSerialNumber` VARCHAR(250) NULL DEFAULT NULL,
  `SiteApplianceID` INT(4) NOT NULL AUTO_INCREMENT,
  `SiteApplianceDescription` VARCHAR(1000) NULL DEFAULT NULL,
  `ChainApplianceID` INT(4) NOT NULL,
  `Deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `SnoozeEnabled` TINYINT(1) NOT NULL DEFAULT '0',
  `SnoozeStart` DATETIME NULL DEFAULT NULL,
  `SnoozeEnd` DATETIME NULL DEFAULT NULL,
  `SpmState` SMALLINT(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ChainId`, `SiteId`, `SiteApplianceID`),
  INDEX `SiteApplianceID_idx` (`SiteApplianceID` ASC),
  INDEX `ChainsAppliances` (`ChainId` ASC, `ApplianceId` ASC, `ControllerId` ASC, `ChainApplianceID` ASC),
  CONSTRAINT `ChainsAppliances`
    FOREIGN KEY (`ChainId` , `ApplianceId` , `ControllerId` , `ChainApplianceID`)
    REFERENCES `Instore`.`ChainsAppliances` (`ChainId` , `ApplianceId` , `ControllerId` , `ChainApplianceID`),
  CONSTRAINT `Sites`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
AUTO_INCREMENT = 3326
DEFAULT CHARACTER SET = latin1
COMMENT = 'Info for Appliance on each Site, associated with which Chain, which Controller. Referened by SitesAppliancesRecipes, SitesAppliancesStatus, SitesSCKNetworkAppliances, SitesAppliancesParametersSets, SitesAppliancesDescriptions, MessagesDownload, SitesAppliancesCookLogs, SitesAppliancesWCWLogs, and SitesAppliancesProductCountLog.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesAppliancesBlackouts
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesAppliancesBlackouts` (
  `BlackoutId` INT(4) NOT NULL AUTO_INCREMENT,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SiteApplianceId` INT(4) NOT NULL,
  `AlarmTypeHACCP` TINYINT(1) NOT NULL,
  `AlarmTypeASSET` TINYINT(1) NOT NULL,
  `Day` INT(4) NOT NULL,
  `StartTime` TIME NOT NULL,
  `EndTime` TIME NOT NULL,
  `SPMUpdate` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`BlackoutId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.SitesAppliancesCookLogs
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesAppliancesCookLogs` (
  `ChainID` INT(4) NOT NULL,
  `SiteID` INT(4) NOT NULL,
  `SiteApplianceID` INT(4) NOT NULL,
  `Chamber` SMALLINT(6) NOT NULL,
  `CookStartDateTime` DATETIME(6) NOT NULL,
  `ButtonNumber` SMALLINT(6) NOT NULL,
  `RecipeID` INT(4) NOT NULL,
  `RecipeVersionNumber` SMALLINT(6) NOT NULL,
  `ProductID` INT(4) NOT NULL,
  `CookStatus` CHAR(10) NOT NULL,
  `CookEndDateTime` DATETIME(6) NULL DEFAULT NULL,
  `ProductCount` INT(4) NULL DEFAULT NULL,
  `RefCookStartTime` DATETIME(6) NULL DEFAULT NULL,
  `RefSiteApplianceId` INT(4) NULL DEFAULT NULL,
  `CookID` INT(4) NOT NULL,
  `BatchUUId` VARCHAR(255) NULL DEFAULT NULL,
  `ReasonId` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainID`, `SiteID`, `SiteApplianceID`, `Chamber`, `CookStartDateTime`, `CookID`),
  INDEX `SitesProducts` (`ChainID` ASC, `SiteID` ASC, `ProductID` ASC),
  INDEX `ChainsRecipesVersions_3` (`ChainID` ASC, `RecipeID` ASC, `RecipeVersionNumber` ASC),
  INDEX `FK_COOKLOG_REFERENCE_LOOKUPLIST` (`ReasonId` ASC),
  INDEX `FK_SitesAppliancesCookLog_BatchLog` (`BatchUUId` ASC),
  CONSTRAINT `ChainsRecipesVersions_3`
    FOREIGN KEY (`ChainID` , `RecipeID` , `RecipeVersionNumber`)
    REFERENCES `Instore`.`ChainsRecipesVersions` (`ChainId` , `RecipeId` , `RecipeVersionNumber`),
  CONSTRAINT `FK_COOKLOG_REFERENCE_LOOKUPLIST`
    FOREIGN KEY (`ReasonId`)
    REFERENCES `Instore`.`LookupListItem` (`LookupListItemId`),
  CONSTRAINT `FK_SitesAppliancesCookLog_BatchLog`
    FOREIGN KEY (`BatchUUId`)
    REFERENCES `Instore`.`BatchLog` (`BatchUUId`),
  CONSTRAINT `SitesAppliances`
    FOREIGN KEY (`ChainID` , `SiteID` , `SiteApplianceID`)
    REFERENCES `Instore`.`SitesAppliances` (`ChainId` , `SiteId` , `SiteApplianceID`),
  CONSTRAINT `SitesProducts`
    FOREIGN KEY (`ChainID` , `SiteID` , `ProductID`)
    REFERENCES `Instore`.`SitesProducts` (`ChainId` , `SiteId` , `ProductId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'All Cook info on each SiteAppliance, each log is assigned a unique CookID. An alert will be sent if CookStatus is one of Error, Aborted, Cancel, or Bad.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesAppliancesParametersSets
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesAppliancesParametersSets` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SiteApplianceID` INT(4) NOT NULL AUTO_INCREMENT,
  `ParametersSetType` CHAR(15) NOT NULL,
  `ParameterSetId` INT(4) NULL DEFAULT NULL,
  `ParameterSetDownloadDatetime` DATETIME(6) NULL DEFAULT NULL,
  `ParameterSetVerificationDatetime` DATETIME(6) NULL DEFAULT NULL,
  `ParameterSetDownloadStatus` CHAR(10) NULL DEFAULT NULL,
  `ParameterSetVerificationStatus` CHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`SiteApplianceID`, `ChainId`, `SiteId`, `ParametersSetType`),
  INDEX `SiteApplianceID_ind` (`SiteApplianceID` ASC),
  INDEX `SiteApplianceID_idx` (`SiteApplianceID` ASC),
  INDEX `ParametersSetsType_2` (`ParametersSetType` ASC),
  INDEX `ChainsParametersSets_1` (`ChainId` ASC, `ParameterSetId` ASC),
  CONSTRAINT `ChainsParametersSets_1`
    FOREIGN KEY (`ChainId` , `ParameterSetId`)
    REFERENCES `Instore`.`ChainsParametersSets` (`ChainId` , `ParameterSetId`),
  CONSTRAINT `ParametersSetsType_2`
    FOREIGN KEY (`ParametersSetType`)
    REFERENCES `Instore`.`ParametersSetsType` (`ParametersSetType`),
  CONSTRAINT `SitesAppliances_4`
    FOREIGN KEY (`ChainId` , `SiteId` , `SiteApplianceID`)
    REFERENCES `Instore`.`SitesAppliances` (`ChainId` , `SiteId` , `SiteApplianceID`))
ENGINE = InnoDB
AUTO_INCREMENT = 3326
DEFAULT CHARACTER SET = latin1
COMMENT = 'Record info when download both Appliance ParameterSets and Controller ParameterSets (ParameterSetType can divide them) to SiteAppliance, including DownloadTime, DownloadStatus, VerificationTime, VerificationStatus. When download begins, DownloadStatus is updated to \'Pending\'; After download complets and SCK engine replies, DownloadStatus is updated to \'Complete\'. When verification begins, VerificationStatus is updated to \'Pending\', after verification completes and SCK engin replied. VerificationStatus is updated to \'Good\'. Referenced by SitesAppliancesParametersSetsVerification.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesAppliancesRecipes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesAppliancesRecipes` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `RecipeId` INT(4) NOT NULL,
  `ButtonNumber` SMALLINT(6) NOT NULL,
  `SiteApplianceID` INT(4) NOT NULL,
  `RecipeDownloadDatetime` DATETIME(6) NULL DEFAULT NULL,
  `RecipeVerificationDatetime` DATETIME(6) NULL DEFAULT NULL,
  `RecipeDownloadStatus` CHAR(10) NULL DEFAULT NULL,
  `RecipeVerificationStatus` CHAR(10) NULL DEFAULT NULL,
  `Chamber` SMALLINT(6) NOT NULL,
  `ChainApplianceID` INT(4) NOT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `RecipeId`, `ButtonNumber`, `SiteApplianceID`),
  INDEX `SitesAppliances_5` (`ChainId` ASC, `SiteId` ASC, `SiteApplianceID` ASC),
  CONSTRAINT `SitesAppliances_5`
    FOREIGN KEY (`ChainId` , `SiteId` , `SiteApplianceID`)
    REFERENCES `Instore`.`SitesAppliances` (`ChainId` , `SiteId` , `SiteApplianceID`),
  CONSTRAINT `SitesRecipes`
    FOREIGN KEY (`ChainId` , `SiteId` , `RecipeId`)
    REFERENCES `Instore`.`SitesRecipes` (`ChainId` , `SiteId` , `RecipeId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Record info when download Recipes to SiteAppliance, including DownloadTime, DownloadStatus, VerificationTime, VerificationStatus. When download begins, DownloadStatus is updated to \'Pending\'; After download complets and SCK engine replies, DownloadStatus is updated to \'Complete\'. When verification begins, VerificationStatus is updated to \'Pending\', after verification completes and SCK engin replied. VerificationStatus is updated to \'Good\'. Referenced by SitesAppliancesRecipesVerification.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesAppliancesStatus
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesAppliancesStatus` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SiteApplianceID` INT(4) NOT NULL,
  `SCKNetworkAddress` INT(4) NOT NULL,
  `SCKNetworkID` INT(4) NOT NULL,
  `SCKNetworkMACAddress` CHAR(32) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `SiteApplianceID`, `SCKNetworkAddress`, `SCKNetworkID`),
  CONSTRAINT `SitesAppliances_6`
    FOREIGN KEY (`ChainId` , `SiteId` , `SiteApplianceID`)
    REFERENCES `Instore`.`SitesAppliances` (`ChainId` , `SiteId` , `SiteApplianceID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Info about Appliance on each Site, combined with SCKNetworkId, and SCKNetworkAddress.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesAttributes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesAttributes` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `AttributeNameId` INT(4) NOT NULL,
  `AttributeValue` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `AttributeNameId`),
  INDEX `AttributeNamesFKey_1` (`AttributeNameId` ASC),
  CONSTRAINT `AttributeNamesFKey_1`
    FOREIGN KEY (`AttributeNameId`)
    REFERENCES `Instore`.`AttributeNames` (`AttributeNameId`),
  CONSTRAINT `ChainsFKey_2`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`),
  CONSTRAINT `SitesFKey`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Any attributes which are defined at site level will be defined here';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesCategories
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesCategories` (
  `ChainId` INT(4) NOT NULL,
  `SiteCategoryId` INT(4) NOT NULL AUTO_INCREMENT,
  `SiteCategoryName` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`SiteCategoryId`, `ChainId`),
  INDEX `SiteCategoryId_idx` (`SiteCategoryId` ASC),
  CONSTRAINT `Chains_6`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`))
ENGINE = InnoDB
AUTO_INCREMENT = 159
DEFAULT CHARACTER SET = latin1
COMMENT = 'Category each site. Referenced by Sites.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesForecastDayOfWeekGroupings
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesForecastDayOfWeekGroupings` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SundayGroup` INT(4) NOT NULL DEFAULT '8',
  `MondayGroup` INT(4) NOT NULL DEFAULT '8',
  `TuesdayGroup` INT(4) NOT NULL DEFAULT '8',
  `WednesdayGroup` INT(4) NOT NULL DEFAULT '8',
  `ThursdayGroup` INT(4) NOT NULL DEFAULT '8',
  `FridayGroup` INT(4) NOT NULL DEFAULT '8',
  `SaturdayGroup` INT(4) NOT NULL DEFAULT '8',
  PRIMARY KEY (`ChainId`, `SiteId`),
  CONSTRAINT `FK_SITESFORECASTDAYOFWEEKGRPS_REFERENCE_SITES`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'This table is 1:1 with sites and defines how days of the week are grouped for like day forecasting purposes.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesHoursOfOperations
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesHoursOfOperations` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `StartDate` DATE NOT NULL,
  `EndDate` DATE NOT NULL,
  `ScheduleDescription` VARCHAR(256) NULL DEFAULT NULL,
  `SundayOpenTime` TIME(6) NULL DEFAULT NULL,
  `SundayCloseTime` TIME(6) NULL DEFAULT NULL,
  `MondayOpenTime` TIME(6) NULL DEFAULT NULL,
  `MondayCloseTime` TIME(6) NULL DEFAULT NULL,
  `TuesdayOpenTime` TIME(6) NULL DEFAULT NULL,
  `TuesdayCloseTime` TIME(6) NULL DEFAULT NULL,
  `WednesdayOpenTime` TIME(6) NULL DEFAULT NULL,
  `WednesdayCloseTime` TIME(6) NULL DEFAULT NULL,
  `ThursdayOpenTime` TIME(6) NULL DEFAULT NULL,
  `ThursdayCloseTime` TIME(6) NULL DEFAULT NULL,
  `FridayOpenTime` TIME(6) NULL DEFAULT NULL,
  `FridayCloseTime` TIME(6) NULL DEFAULT NULL,
  `SaturdayOpenTime` TIME(6) NULL DEFAULT NULL,
  `SaturdayCloseTime` TIME(6) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `StartDate`, `EndDate`),
  CONSTRAINT `SITESHOU_REFERENCE_SITES`
    FOREIGN KEY (`SiteId`, `ChainId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'This table stores specific (overridden) open hours of the operation for each site effective from the StartDate to the EndDate.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesMessages
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesMessages` (
  `SiteMessageId` VARCHAR(255) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `MessageStr` VARCHAR(500) NOT NULL,
  `EffectiveDate` DATE NULL DEFAULT NULL,
  `ExpirationDate` DATE NULL DEFAULT NULL,
  `DisplayOrdinal` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`SiteMessageId`),
  INDEX `Sites_SitesMessages.ixd` (`ChainId` ASC, `SiteId` ASC),
  CONSTRAINT `Sites_SitesMessages`
    FOREIGN KEY (`SiteId`, `ChainId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'QPM display messages at the site level; i.e. applies only to this site.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesPhoneNumbers
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesPhoneNumbers` (
  `SitePhoneNumberId` VARCHAR(255) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `PrimaryFlag` TINYINT(1) NOT NULL DEFAULT '0',
  `CountryCode` CHAR(2) NOT NULL,
  `PhoneNumber` VARCHAR(30) NOT NULL,
  `PhoneTypeLookupListItemId` INT(4) NULL DEFAULT NULL,
  `Extension` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`SitePhoneNumberId`),
  INDEX `SitesPhoneNumbers_Sites` (`ChainId` ASC, `SiteId` ASC),
  INDEX `SitesPhoneNumbers_Countries` (`CountryCode` ASC),
  INDEX `SitesPhoneNumbers_LookupListItem` (`PhoneTypeLookupListItemId` ASC),
  CONSTRAINT `SitesPhoneNumbers_Countries`
    FOREIGN KEY (`CountryCode`)
    REFERENCES `Instore`.`Countries` (`CountryCode`),
  CONSTRAINT `SitesPhoneNumbers_LookupListItem`
    FOREIGN KEY (`PhoneTypeLookupListItemId`)
    REFERENCES `Instore`.`LookupListItem` (`LookupListItemId`),
  CONSTRAINT `SitesPhoneNumbers_Sites`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'What PhoneNumber to each Site.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesPosMenus
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesPosMenus` (
  `SitePosMenuId` INT(4) NOT NULL AUTO_INCREMENT,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `PosMenuId` INT(4) NOT NULL,
  `EffectiveDate` DATE NULL DEFAULT NULL,
  `CreationTimestamp` DATETIME(6) NOT NULL,
  `ModifiedTimestamp` DATETIME(6) NOT NULL,
  PRIMARY KEY (`SitePosMenuId`),
  UNIQUE INDEX `SitesPosMenus UNIQUE (ChainId,SiteId,PosMenuId)` (`ChainId` ASC, `SiteId` ASC, `PosMenuId` ASC),
  INDEX `SitesPosMenus_PosMenus` (`PosMenuId` ASC),
  CONSTRAINT `SitesPosMenus_PosMenus`
    FOREIGN KEY (`PosMenuId`)
    REFERENCES `Instore`.`PosMenus` (`PosMenuId`),
  CONSTRAINT `SitesPosMenus_Sites`
    FOREIGN KEY (`SiteId`, `ChainId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
AUTO_INCREMENT = 848
DEFAULT CHARACTER SET = latin1
COMMENT = 'Identifies the POS configurations that can be used within a site.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesProducts
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesProducts` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `ProductGroup` INT(4) NULL DEFAULT NULL,
  `OrderNum` INT(4) NULL DEFAULT NULL,
  `HoldTimeSec` INT(4) NULL DEFAULT NULL,
  `PrepTimeSec` INT(4) NULL DEFAULT NULL,
  `ServeTimeSec` INT(4) NULL DEFAULT NULL,
  `DeviceType` INT(4) NULL DEFAULT NULL,
  `ButtonShortName` VARCHAR(200) NULL DEFAULT NULL,
  `ForecastOverridesAllowedFlag` TINYINT(1) NOT NULL DEFAULT '0',
  `ForecastWasteVsWait` INT(4) NULL DEFAULT '0',
  `ForecastConstraint` VARCHAR(20) NOT NULL DEFAULT 'WASTE',
  `ForecastConstraintValue` DECIMAL(18,2) NOT NULL DEFAULT '5.00',
  `MinimumOnHand` INT(4) NULL DEFAULT NULL,
  `StartDate` DATE NULL DEFAULT NULL,
  `EndDate` DATE NULL DEFAULT NULL,
  `Deleted` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ChainId`, `SiteId`, `ProductId`),
  INDEX `ChainsProducts_1` (`ChainId` ASC, `ProductId` ASC),
  CONSTRAINT `ChainsProducts_1`
    FOREIGN KEY (`ChainId` , `ProductId`)
    REFERENCES `Instore`.`ChainsProducts` (`ChainId` , `ProductId`),
  CONSTRAINT `Sites_1`
    FOREIGN KEY (`SiteId`, `ChainId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associate Product with each Site. Referenced by SitesAppliancesCookLogs, SitesAppliancesWCWLogs, and SitesAppliancesProductCountLog.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesProductsProjections
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesProductsProjections` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `ForecastDate` DATE NOT NULL,
  `ProjectedPieces` INT(4) NULL DEFAULT NULL,
  `AdjustedProjectedPieces` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `ProductId`, `ForecastDate`),
  CONSTRAINT `FK_SITESPRODPROJ_REFERENCE_SITESPRODS`
    FOREIGN KEY (`ChainId` , `SiteId` , `ProductId`)
    REFERENCES `Instore`.`SitesProducts` (`ChainId` , `SiteId` , `ProductId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.SitesProductsTimeOfDayMinOnHands
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesProductsTimeOfDayMinOnHands` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `ProductId` INT(4) NOT NULL,
  `IntervalId` INT(4) NOT NULL,
  `MinimumOnHand` INT(4) NOT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `ProductId`, `IntervalId`),
  CONSTRAINT `FK_SITESPROTODMOH_REFERENCE_SITESPRODS`
    FOREIGN KEY (`ChainId` , `SiteId` , `ProductId`)
    REFERENCES `Instore`.`SitesProducts` (`ChainId` , `SiteId` , `ProductId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Represents the specification of a minimum on-hand for a products that applies for a specific time period of the day for every day (recurring).';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesRecipes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesRecipes` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `RecipeId` INT(4) NOT NULL,
  `Deleted` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ChainId`, `SiteId`, `RecipeId`),
  INDEX `ChainsRecipes_1` (`ChainId` ASC, `RecipeId` ASC),
  CONSTRAINT `ChainsRecipes_1`
    FOREIGN KEY (`ChainId` , `RecipeId`)
    REFERENCES `Instore`.`ChainsRecipes` (`ChainId` , `RecipeId`),
  CONSTRAINT `Sites_2`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associate a Recipe to Site. Referenced by SitesAppliancesRecipes.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesSCKNetworkAppliances
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesSCKNetworkAppliances` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SCKNetworkId` SMALLINT(6) NOT NULL,
  `SCKNetworkAddress` SMALLINT(6) NOT NULL,
  `SiteApplianceID` INT(4) NOT NULL,
  `SCKNetworkApplianceStatus` SMALLINT(6) NULL DEFAULT NULL,
  `NetworkApplianceStatusTimeStamp` DATETIME NULL DEFAULT NULL,
  `ParameterID` INT(4) NOT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `SCKNetworkId`, `SCKNetworkAddress`, `SiteApplianceID`, `ParameterID`),
  INDEX `SitesAppliances_7` (`ChainId` ASC, `SiteId` ASC, `SiteApplianceID` ASC),
  CONSTRAINT `SitesAppliances_7`
    FOREIGN KEY (`ChainId` , `SiteId` , `SiteApplianceID`)
    REFERENCES `Instore`.`SitesAppliances` (`ChainId` , `SiteId` , `SiteApplianceID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'List related SCKNetwork info with SiteAppliance, each SiteAppliance has a corresponding ParameterID.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesSCKNetworkAppliancesHACCPLog
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesSCKNetworkAppliancesHACCPLog` (
  `SiteId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SCKNetworkId` SMALLINT(6) NOT NULL,
  `SCKNetworkAddress` SMALLINT(6) NOT NULL,
  `ValueTimeStamp` DATETIME(6) NOT NULL,
  `ParameterId` INT(4) NULL DEFAULT NULL,
  `Value` SMALLINT(6) NULL DEFAULT NULL,
  `HACCPId` INT(4) NOT NULL,
  `HACCPStatus` INT(4) NULL DEFAULT '0',
  `SiteApplianceId` INT(4) NOT NULL,
  PRIMARY KEY (`SiteId`, `ChainId`, `ValueTimeStamp`, `HACCPId`, `SiteApplianceId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'A temporary table recording HACCP id, status and value when Message data is not \'WriteComplete\' after SCK engine finishes processing. Values will be compared with those in SitesSCKNetworkAppliancesHACCPThreshold to decide if which alert will be sent.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesSCKNetworkAppliancesHACCPStatus
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesSCKNetworkAppliancesHACCPStatus` (
  `SiteId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SCKNetworkId` SMALLINT(6) NOT NULL,
  `SCKNetworkAddress` SMALLINT(6) NOT NULL,
  `ValueTimeStamp` DATETIME(6) NOT NULL,
  `ParameterId` INT(4) NULL DEFAULT NULL,
  `Value` SMALLINT(6) NULL DEFAULT NULL,
  `HACCPId` INT(4) NOT NULL,
  `HACCPStatus` INT(4) NULL DEFAULT NULL,
  `SiteApplianceId` INT(4) NOT NULL,
  PRIMARY KEY (`SiteId`, `ChainId`, `HACCPId`, `SiteApplianceId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Status for HACCP monitering list. SitesSCKNetworkAppHACCPLog will update HACCPStatus.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesSCKNetworkAppliancesHACCPThreshold
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesSCKNetworkAppliancesHACCPThreshold` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SCKNetworkId` SMALLINT(6) NOT NULL,
  `SCKNetworkAddress` SMALLINT(6) NOT NULL,
  `HACCPId` INT(4) NOT NULL,
  `HACCPDescription` CHAR(80) NULL DEFAULT NULL,
  `ParameterId` INT(4) NULL DEFAULT NULL,
  `ThresholdValue` SMALLINT(6) NULL DEFAULT NULL,
  `LogicalOperator` CHAR(3) NULL DEFAULT NULL,
  `HACCPStatusColor` INT(4) NULL DEFAULT NULL,
  `HACCPMessage` CHAR(255) NULL DEFAULT NULL,
  `SiteApplianceId` INT(4) NOT NULL,
  `ConvertFunction` INT(4) NULL DEFAULT NULL,
  `Deleted` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ChainId`, `SiteId`, `HACCPId`, `SiteApplianceId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'List Threshold info for HACCP for comparison.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesSCKNetworkAppliancesParameterCurrentValue
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesSCKNetworkAppliancesParameterCurrentValue` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SCKNetworkId` SMALLINT(6) NOT NULL,
  `SCKNetworkAddress` SMALLINT(6) NOT NULL,
  `ValueTimeStamp` DATETIME(6) NULL DEFAULT NULL,
  `ParameterPhysicalAddress` INT(4) NULL DEFAULT NULL,
  `ParameterId` INT(4) NOT NULL,
  `Value` INT(4) NULL DEFAULT NULL,
  `SiteApplianceId` INT(4) NOT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `ParameterId`, `SiteApplianceId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Holding Current Parameter Value for Monitoring list. It\'s updated or inserted by SitesSCKNetworkAppliancesParameterValueLog.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesSCKNetworkAppliancesParameterValueLog
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesSCKNetworkAppliancesParameterValueLog` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SCKNetworkId` SMALLINT(6) NOT NULL,
  `SCKNetworkAddress` SMALLINT(6) NOT NULL,
  `ValueTimestamp` DATETIME(6) NOT NULL,
  `ParameterPhysicalAddress` INT(4) NULL DEFAULT NULL,
  `ParameterId` INT(4) NOT NULL,
  `Value` INT(4) NULL DEFAULT NULL,
  `SiteApplianceId` INT(4) NOT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `ValueTimestamp`, `ParameterId`, `SiteApplianceId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Check if Parameter is on the monitoring list, if exists, update table SitesSckNetworkAppliancesParameterCurrentValue; if not exists, insert into SitesSCKNetworkAppliancesParameterCurrentValue.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesSCKNetworkAppliancesStatusLog
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesSCKNetworkAppliancesStatusLog` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SCKNetworkId` SMALLINT(6) NOT NULL,
  `SCKNetworkAddress` SMALLINT(6) NOT NULL,
  `NetworkApplianceStatusTimeStamp` DATETIME(6) NOT NULL,
  `NetworkApplianceStatusDescription` CHAR(80) NULL DEFAULT NULL,
  `NetworkApplianceStatus` SMALLINT(6) NULL DEFAULT NULL,
  `ParameterSetID` INT(4) NOT NULL,
  `SiteApplianceID` INT(4) NOT NULL,
  `ParameterID` INT(4) NOT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `NetworkApplianceStatusTimeStamp`, `SiteApplianceID`, `ParameterSetID`, `ParameterID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Check if Appliance on the Monitoring list, if exists, update table SitesSckNetworkAppliance; if not exists, insert into SitesSckNetworkAppliance. Only update those appliances are on the monitoring list.';

-- ----------------------------------------------------------------------------
-- Table Instore.SitesSCKNetworks
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`SitesSCKNetworks` (
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `SCKNetworkId` SMALLINT(6) NOT NULL,
  `SCKNetworkControllerStatus` CHAR(10) NULL DEFAULT NULL,
  `SCKNetworkIdPIN` VARCHAR(255) NULL DEFAULT NULL,
  `SCKNetworkName` VARCHAR(300) NULL DEFAULT NULL,
  PRIMARY KEY (`ChainId`, `SiteId`, `SCKNetworkId`),
  INDEX `SCKNetworkControllerStatus` (`SCKNetworkControllerStatus` ASC),
  CONSTRAINT `Sites_3`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'SCKNetwork info on Site and Chain, referenced by SitesSCKNetworkAppliances.';

-- ----------------------------------------------------------------------------
-- Table Instore.StatesProvinces
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`StatesProvinces` (
  `StateProvinceId` INT(4) NOT NULL AUTO_INCREMENT,
  `CountryCode` CHAR(2) NOT NULL,
  `Description` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`StateProvinceId`),
  UNIQUE INDEX `StatesProvinces UNIQUE (CountryCode,Description)` (`CountryCode` ASC, `Description` ASC),
  CONSTRAINT `StatesProvinces_Countries`
    FOREIGN KEY (`CountryCode`)
    REFERENCES `Instore`.`Countries` (`CountryCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.TimeZone
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`TimeZone` (
  `GMTDiff` INT(4) NOT NULL,
  `TimeZoneDesc` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`GMTDiff`),
  UNIQUE INDEX `TimeZone UNIQUE (TimeZoneDesc)` (`TimeZoneDesc` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.UserAlertDestinations
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`UserAlertDestinations` (
  `UserId` VARCHAR(64) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  `EmailAddress` VARCHAR(128) NULL DEFAULT NULL,
  `FaxAddress` VARCHAR(128) NULL DEFAULT NULL,
  `PagerAddress` VARCHAR(128) NULL DEFAULT NULL,
  `HACCPAlertFlag` INT(4) NOT NULL DEFAULT '0',
  `ProductAlertFlag` INT(4) NOT NULL DEFAULT '0',
  `AssetAlertFlag` INT(4) NOT NULL DEFAULT '0',
  `XMLPostURL` VARCHAR(1024) NULL DEFAULT NULL,
  PRIMARY KEY (`UserId`, `ChainId`, `SiteId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Contact with users, assign alert flag to each user.';

-- ----------------------------------------------------------------------------
-- Table Instore.UserInfo
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`UserInfo` (
  `UserInfoId` INT(4) NOT NULL AUTO_INCREMENT,
  `UserId` VARCHAR(200) NOT NULL,
  `Password` VARCHAR(64) NOT NULL,
  `PersonId` INT(4) NOT NULL,
  `ExpirationDate` DATE NULL DEFAULT NULL,
  `RoleId` INT(4) NULL DEFAULT NULL,
  `ChainId` INT(4) NULL DEFAULT NULL,
  `AccessAdminToolsFlag` TINYINT(1) NULL DEFAULT '0',
  `AccessMySckFlag` TINYINT(1) NULL DEFAULT '0',
  `AccessInStoreFlag` TINYINT(1) NULL DEFAULT '0',
  `ChangePasswordFlag` TINYINT(1) NULL DEFAULT '0',
  `PasswordChangeDate` DATE NULL DEFAULT NULL,
  `SuperUserFlag` TINYINT(1) NULL DEFAULT '0',
  `AllSiteCategoriesFlag` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`UserInfoId`),
  UNIQUE INDEX `UQ_UserInfo` (`UserId` ASC),
  INDEX `UserInfo_Role` (`RoleId` ASC),
  INDEX `UserInfo_Chain` (`ChainId` ASC),
  INDEX `UserInfo_Person` (`PersonId` ASC),
  CONSTRAINT `UserInfo_Chain`
    FOREIGN KEY (`ChainId`)
    REFERENCES `Instore`.`Chains` (`ChainId`),
  CONSTRAINT `UserInfo_Person`
    FOREIGN KEY (`PersonId`)
    REFERENCES `Instore`.`Persons` (`PersonId`),
  CONSTRAINT `UserInfo_Role`
    FOREIGN KEY (`RoleId`)
    REFERENCES `Instore`.`Role` (`RoleId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.UserInfoSite
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`UserInfoSite` (
  `UserInfoSiteId` INT(4) NOT NULL AUTO_INCREMENT,
  `UserInfoId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteId` INT(4) NOT NULL,
  PRIMARY KEY (`UserInfoSiteId`),
  UNIQUE INDEX `UQ_UserInfoSite` (`UserInfoId` ASC, `ChainId` ASC, `SiteId` ASC),
  INDEX `UserInfoSite_Site` (`ChainId` ASC, `SiteId` ASC),
  CONSTRAINT `UserInfoSite_Site`
    FOREIGN KEY (`ChainId` , `SiteId`)
    REFERENCES `Instore`.`Sites` (`ChainId` , `SiteId`),
  CONSTRAINT `UserInfoSite_UserInfo`
    FOREIGN KEY (`UserInfoId`)
    REFERENCES `Instore`.`UserInfo` (`UserInfoId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.UserInfoSiteCategory
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`UserInfoSiteCategory` (
  `UserInfoSiteCategoryId` INT(4) NOT NULL AUTO_INCREMENT,
  `UserInfoId` INT(4) NOT NULL,
  `ChainId` INT(4) NOT NULL,
  `SiteCategoryId` INT(4) NOT NULL,
  `AllSitesFlag` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`UserInfoSiteCategoryId`),
  UNIQUE INDEX `UQ_UserInfoSiteCategory` (`UserInfoId` ASC, `ChainId` ASC, `SiteCategoryId` ASC),
  INDEX `UserInfoSiteCategory_SiteCategory` (`ChainId` ASC, `SiteCategoryId` ASC),
  CONSTRAINT `UserInfoSiteCategory_SiteCategory`
    FOREIGN KEY (`ChainId` , `SiteCategoryId`)
    REFERENCES `Instore`.`SitesCategories` (`ChainId` , `SiteCategoryId`),
  CONSTRAINT `UserInfoSiteCategory_UserInfo`
    FOREIGN KEY (`UserInfoId`)
    REFERENCES `Instore`.`UserInfo` (`UserInfoId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- ----------------------------------------------------------------------------
-- Table Instore.UserReports
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`UserReports` (
  `UserReportId` INT(4) NOT NULL AUTO_INCREMENT,
  `ReportId` INT(4) NOT NULL,
  `UserId` VARCHAR(200) NOT NULL,
  `Favorite` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UserReportId`),
  UNIQUE INDEX `UQ_UserRpt` (`ReportId` ASC, `UserId` ASC),
  INDEX `UserInfo` (`UserId` ASC),
  CONSTRAINT `Reports`
    FOREIGN KEY (`ReportId`)
    REFERENCES `Instore`.`Reports` (`ReportId`),
  CONSTRAINT `UserInfo`
    FOREIGN KEY (`UserId`)
    REFERENCES `Instore`.`UserInfo` (`UserId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Associates reports with users that may run them.';

-- ----------------------------------------------------------------------------
-- Table Instore.XMLData
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`XMLData` (
  `XmlDataId` INT(4) NOT NULL AUTO_INCREMENT,
  `XmlDataType` VARCHAR(32) NULL DEFAULT NULL,
  `XmlDataDescription` VARCHAR(256) NULL DEFAULT NULL,
  `XmlDataContent` LONGTEXT NOT NULL,
  `UserName` VARCHAR(40) NULL DEFAULT NULL,
  `VersionNumber` INT(4) NOT NULL,
  `ModifiedDate` DATETIME(6) NOT NULL,
  PRIMARY KEY (`XmlDataId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'All XML data in the system can use this table';

-- ----------------------------------------------------------------------------
-- Table Instore.MediaCatalog
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`MediaCatalog` (
  `MediaCatalogId` INT(4) AUTO_INCREMENT NOT NULL,
  `Identifier` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`MediaCatalogId`))
COMMENT = 'Represents an instance of a media catalog in the database.  For example, a collection of product images for a chain may be stored in a media catalog.';

-- ----------------------------------------------------------------------------
-- Table Instore.Media
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`Media` (
  `MediaId` INT(4) AUTO_INCREMENT NOT NULL,
  `MediaCatalogId` INT(4) NOT NULL,
  `MediaData` LONGBLOB NOT NULL,
  `MimeType` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`MediaId`),
  CONSTRAINT `FK_MEDIA_REFERENCE_MEDIACAT`
    FOREIGN KEY (`MediaCatalogId`)
    REFERENCES `Instore`.`MediaCatalog` (`MediaCatalogId`))
COMMENT = 'Represents an instance of some media in a catalog.';

-- ----------------------------------------------------------------------------
-- Table Instore.MediaDescriptor
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `Instore`.`MediaDescriptor` (
  `MediaDescriptorId` INT(4) AUTO_INCREMENT NOT NULL,
  `MediaId` INT(4) NOT NULL,
  `Name` VARCHAR(400) NOT NULL,
  `Value` VARCHAR(400) NOT NULL,
  `Type` VARCHAR(20) NULL,
  PRIMARY KEY (`MediaDescriptorId`),
  CONSTRAINT `FK_MEDIADES_REFERENCE_MEDIA`
    FOREIGN KEY (`MediaId`)
    REFERENCES `Instore`.`Media` (`MediaId`))
COMMENT = 'Represents a data element that describes a media item (meta data).';

use Instore;
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_BatchLog
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_BatchLog BEFORE INSERT ON BatchLog
FOR EACH ROW
BEGIN
IF NEW.BatchUUId IS NULL THEN
    SET NEW.BatchUUId = UPPER(UUID());
END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_ChainJobFunctions
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_ChainJobFunctions BEFORE INSERT ON ChainJobFunctions
FOR EACH ROW
BEGIN
IF NEW.ChainJobFunctionId IS NULL THEN
    SET NEW.ChainJobFunctionId = UPPER(UUID());
END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_ChainsMessages
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_ChainsMessages BEFORE INSERT ON ChainsMessages
FOR EACH ROW BEGIN
	IF NEW.ChainMessageId IS NULL THEN
		SET NEW.ChainMessageId = UPPER(UUID());
	END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_ForecastAdjustments
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_ForecastAdjustments BEFORE INSERT ON ForecastAdjustments
FOR EACH ROW
BEGIN
IF NEW.ForecastAdjustmentId IS NULL THEN
    SET NEW.ForecastAdjustmentId = UPPER(UUID());
END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_PosCheckItemModifiers
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_PosCheckItemModifiers BEFORE INSERT ON PosCheckItemModifiers
FOR EACH ROW
BEGIN
IF NEW.PosCheckItemModifierId IS NULL THEN
    SET NEW.PosCheckItemModifierId = UPPER(UUID());
END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_PosCheckItems
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_PosCheckItems BEFORE INSERT ON PosCheckItems
FOR EACH ROW
BEGIN
IF NEW.PosCheckItemId IS NULL THEN
    SET NEW.PosCheckItemId = UPPER(UUID());
END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_PosChecks
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_PosChecks BEFORE INSERT ON PosChecks
FOR EACH ROW
BEGIN
IF NEW.PosCheckId IS NULL THEN
    SET NEW.PosCheckId = UPPER(UUID());
END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_PosChecksUnmappedItems
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_PosChecksUnmappedItems BEFORE INSERT ON PosChecksUnmappedItems
FOR EACH ROW
BEGIN
IF NEW.PosCheckId IS NULL THEN
    SET NEW.PosCheckId = UPPER(UUID());
END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_SiteEmployeeTimeClockEvents
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_SiteEmployeeTimeClockEvents BEFORE INSERT ON SiteEmployeeTimeClockEvents
FOR EACH ROW
BEGIN
IF NEW.SiteEmployeTimeClockEventId IS NULL THEN
    SET NEW.SiteEmployeTimeClockEventId = UPPER(UUID());
END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_SiteEmployees
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_SiteEmployees BEFORE INSERT ON SiteEmployees
FOR EACH ROW
BEGIN
IF NEW.SiteEmployeeId IS NULL THEN
    SET NEW.SiteEmployeeId = UPPER(UUID());
END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_SitesMessages
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_SitesMessages BEFORE INSERT ON SitesMessages
FOR EACH ROW BEGIN
	IF NEW.SiteMessageId IS NULL THEN
		SET NEW.SiteMessageId = UPPER(UUID());
	END IF;
END;
$$
-- ----------------------------------------------------------------------------
-- Trigger Instore.before_insert_SitesPhoneNumbers
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_SitesPhoneNumbers BEFORE INSERT ON SitesPhoneNumbers
FOR EACH ROW
BEGIN
IF NEW.SitePhoneNumberId IS NULL THEN
    SET NEW.SitePhoneNumberId = UPPER(UUID());
END IF;
END;
SET FOREIGN_KEY_CHECKS = 1;
$$

create user 'kfcfran'@localhost identified by 'colonel';
grant all on Instore.* to 'kfcfran' identified by 'colonel';
