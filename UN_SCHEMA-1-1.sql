CREATE DATABASE UnitedNations;

USE [UnitedNations]
GO

CREATE TABLE REGION (
	RegionID INT IDENTITY(1,1) PRIMARY KEY,
	RegionName VARCHAR(35) NOT NULL,
	RegionDescr VARCHAR(500)
);
CREATE TABLE COUNTRY (
	CountryID INT IDENTITY(1,1) PRIMARY KEY,
	CountryName VARCHAR(100) NOT NULL,
	CountryAbbrev VARCHAR(20) NOT NULL,
	RegionID INT FOREIGN KEY REFERENCES REGION(RegionID)
);
CREATE TABLE MEASURE_TYPE (
	MeasureTypeID INT IDENTITY(1,1) PRIMARY KEY,
	MeasureTypeName VARCHAR(100) NOT NULL,
	MeasureTypeDescr VARCHAR(500)
);
CREATE TABLE MEASURE (
	MeasureID INT IDENTITY(1,1) PRIMARY KEY,
	MeasureName VARCHAR(100) NOT NULL,
	MeasureTypeID INT FOREIGN KEY REFERENCES MEASURE_TYPE(MeasureTypeID),
	MeasureDescr VARCHAR(500)
);
CREATE TABLE COUNTRY_MEASURE (
	CountryMeasureID INT IDENTITY(1,1) PRIMARY KEY,
	CountryID INT FOREIGN KEY REFERENCES COUNTRY(CountryID),
	MeasureID INT FOREIGN KEY REFERENCES MEASURE(MeasureID),
	CharValue VARCHAR(200),
	NumericValue INT,
	DataYear DATE NOT NULL
);
CREATE TABLE POSITION (
	PositionID INT IDENTITY(1,1) PRIMARY KEY,
	PositionName VARCHAR(100) NOT NULL,
	PositionDescr VARCHAR(500)
);
CREATE TABLE PERSON (
	PersonID INT IDENTITY(1,1) PRIMARY KEY,
	PersonLname VARCHAR(35) NOT NULL,
	PersonFname VARCHAR(35) NOT NULL,
	DateOfBirth DATE
);
CREATE TABLE JOB (
	JobID INT IDENTITY(1,1) PRIMARY KEY,
	CountryID INT FOREIGN KEY REFERENCES COUNTRY(CountryID),
	PositionID INT FOREIGN KEY REFERENCES POSITION(PositionID),
	PersonID INT FOREIGN KEY REFERENCES PERSON(PersonID),
	BeginDate DATE NOT NULL,
	EndDate DATE
);
CREATE TABLE ACTION_TYPE (
	ActionTypeID INT IDENTITY(1,1) PRIMARY KEY,
	ActionTypeName VARCHAR(100) NOT NULL,
	ActionTypeDescr VARCHAR(500)
);
CREATE TABLE ACTION (
	ActionID INT IDENTITY(1,1) PRIMARY KEY,
	ActionName VARCHAR(100) NOT NULL,
	ActionBeginDate DATE NOT NULL,
	ActionEndDate DATE,
	ActionTypeID INT FOREIGN KEY REFERENCES ACTION_TYPE(ActionTypeID)
);
CREATE TABLE CONDITION (
	ConditionID INT IDENTITY(1,1) PRIMARY KEY,
	ConditionName VARCHAR(50) NOT NULL,
	ConditionDescr VARCHAR(500)
);
CREATE TABLE ACTION_CONDITION (
	ActionConditionID INT IDENTITY(1,1) PRIMARY KEY,
	ActionID INT FOREIGN KEY REFERENCES ACTION(ActionID),
	ConditionID INT FOREIGN KEY REFERENCES CONDITION(ConditionID)
);
CREATE TABLE ACTION_CONDITION_COUNTRY (
	ActionConditionID INT FOREIGN KEY REFERENCES ACTION_CONDITION(ActionConditionID),
	CountryID INT FOREIGN KEY REFERENCES COUNTRY(CountryID), 
	BeginDate DATE NOT NULL,
	EndDate DATE
);

CREATE TABLE COMMENT_TYPE (
	CommentTypeID INT IDENTITY(1,1) PRIMARY KEY,
	CommentTypeName VARCHAR(50) NOT NULL,
	CommentTypeDescr VARCHAR(300)
);
CREATE TABLE COMMENT (
	CommentID INT IDENTITY(1,1) PRIMARY KEY,
	ActionConditionID INT FOREIGN KEY REFERENCES ACTION_CONDITION(ActionConditionID),
	CommentTypeID INT FOREIGN KEY REFERENCES COMMENT_TYPE(CommentTypeID),
	CommentBody VARCHAR(500) NOT NULL
);
CREATE TABLE PRODUCT_TYPE (
	ProductTypeID INT IDENTITY(1,1) PRIMARY KEY,
	ProductTypeName VARCHAR(50) NOT NULL,
	ProductTypeDescr VARCHAR(300)
);
CREATE TABLE PRODUCT (
	ProductID INT IDENTITY(1,1) PRIMARY KEY,
	ProductName VARCHAR(50) NOT NULL,
	ProductDescr VARCHAR(300),
	ProductTypeID INT FOREIGN KEY REFERENCES PRODUCT_TYPE(ProductTypeID)
);
CREATE TABLE COUNTRY_PRODUCT (
	CountryID INT FOREIGN KEY REFERENCES COUNTRY(CountryID),
	ProductID INT FOREIGN KEY REFERENCES PRODUCT(ProductID),
	PercentGDP DECIMAL(5,2) NOT NULL
);




