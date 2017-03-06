
--ACCEPTS NAME/DESCRIPTION OF REGION TO BE INSERTED INTO REGION;
--I.E. EXEC INS_REGION 'North Africa', 'arid place';
CREATE PROC INS_REGION
@Name VARCHAR(35),
@Descr VARCHAR(500)
AS
BEGIN
INSERT INTO REGION (RegionName, RegionDescr) VALUES (@Name, @Descr);
END

--ACCEPTS NAME/DESCRIPTION OF REGION TO BE UPDATED INTO REGION;
--I.E. EXEC SET_REGION 'North America', 'Area to north of america';
CREATE PROC SET_REGION
@Name VARCHAR(35),
@Descr VARCHAR(500)
AS
BEGIN
UPDATE REGION SET RegionDescr = @Descr WHERE RegionName = @Name;
END

--ACCEPTS NAME/DESCRIPTION OF REGION TO BE UPDATED TO TABLE REGION;
--I.E. EXEC DEL_REGION 'North America';
CREATE PROC DEL_REGION
@Name VARCHAR(35)
AS
BEGIN
DELETE FROM REGION WHERE RegionName = @Name;
END

--ACCEPTS NAME OF COUNTRY/REGION, & COUNTRY'S ABBREV. TO BE INSERTED INTO COUNTRY;
--I.E. EXEC INS_COUNTRY 'United States', 'US', 'North America';
CREATE PROC INS_COUNTRY
@Name VARCHAR(100),
@Abbrev VARCHAR(20),
@RegionName VARCHAR(35)
AS
DECLARE @RegionID INT; 
BEGIN 
SET @RegionID = (SELECT TOP 1 RegionID FROM REGION WHERE RegionName = @RegionName);
IF @RegionID IS NOT NULL 
INSERT INTO COUNTRY (CountryName, CountryAbbrev, RegionID) VALUES (@Name, @Abbrev, @RegionID);
ELSE 
RAISERROR('Region does not exist', 1, 1) WITH NOWAIT;
END

--DELETES COUNTRY BASED ON NAME SUPPLIED;
--I.E. EXEC DEL_COUNTRY 'United States';
CREATE PROC DEL_COUNTRY
@Name VARCHAR(100)
AS
BEGIN
DELETE FROM COUNTRY WHERE CountryName = @Name;
END

--INSERTS NEW MEASURE TYPE USING SUPPLIED NAME/DESCRIPTION;
--I.E. EXEC INS_MEASURE_TYPE 'Trade', 'Dealing with trade';
CREATE PROC INS_MEASURE_TYPE
@Name VARCHAR(100),
@Descr VARCHAR(500)
AS 
BEGIN
INSERT INTO MEASURE_TYPE (MeasureTypeName, MeasureTypeDescr) VALUES (@Name, @Descr);
END

--UPDATES MEASURE TYPE DESCRIPTION BASED ON SUPPLIED NAME/DESCRIPTION;
--I.E. EXEC SET_MEASURE_TYPE_DESCR 'Climate Change', 'The atmospheric conditions government imposes';
CREATE PROC SET_MEASURE_TYPE_DESCR
@Name VARCHAR(100),
@Descr VARCHAR(500)
AS
BEGIN
UPDATE MEASURE_TYPE SET MeasureTypeDescr = @Descr WHERE MeasureTypeName = @Name;
END

--DELETES MEASURE TYPE USING NAME OF MEASURE TYPE;
--I.E. EXEC DEL_MEASURE_TYPE 'Climate Change';
CREATE PROC DEL_MEASURE_TYPE
@Name VARCHAR(100)
AS 
BEGIN
DELETE FROM MEASURE_TYPE WHERE MeasureTypeName = @Name;
END

--INSERTS NEW FORM OF MEASURE USING MEASURE NAME,TYPE, & DESCRIPTION;
--I.E. EXEC INS_MEASURE 'Energy Usage', 'Climate Change', 'Total energy used by x';
CREATE PROC INS_MEASURE 
@Name VARCHAR(100),
@MeasureType VARCHAR(100),
@MeasureDescr VARCHAR(500)
AS 
DECLARE @ID INT;
BEGIN
SET @ID = (SELECT TOP 1 MeasureTypeID FROM MEASURE_TYPE WHERE MeasureTypeName = @MeasureType);
IF @ID IS NOT NULL
INSERT INTO MEASURE (MeasureName, MeasureTypeID, MeasureDescr) VALUES (@Name, @ID, @MeasureDescr);
ELSE 
RAISERROR('Measure Type does not exist.', 1, 1) WITH NOWAIT;
END


CREATE PROC SET_MEASURE 
@Name VARCHAR(100),
@Descr VARCHAR(500)
AS
DECLARE @ID INT;
BEGIN
SET @ID = (SELECT TOP 1 MeasureID FROM MEASURE WHERE MeasureName = @Name);
IF @ID IS NULL
RAISERROR('Measure does not exists', 1, 1);
ELSE 
UPDATE MEASURE SET MeasureDescr = @Descr WHERE MeasureID = @ID;
END 

--DELETES FORM OF MEASURE USING MEASURE NAME;
--I.E. EXEC DEL_MEASURE 'Energy Usage';
CREATE PROC DEL_MEASURE
@Name VARCHAR(100)
AS
DECLARE @ID INT;
BEGIN
SET @ID = (SELECT TOP 1 MeasureID FROM MEASURE WHERE MeasureName = @Name);
IF @ID IS NULL
RAISERROR('Measure does not exist', 1, 1);
ELSE
DELETE FROM MEASURE WHERE MeasureID = @ID;
END 


--INSERTS COUNTRY MEASUREMENT FOR STRING VALUES;
--ACCEPTS COUNTRY & MEASURE NAME, CHAR VALUE, AND YEAR OF DATA;
--I.E. EXEC INS_CM_CHAR 'United States', 'Energy Usage', 'Not good', '03-04-2015';
CREATE PROC INS_CM_CHAR
@CountryName VARCHAR(100),
@MeasureName VARCHAR(100),
@CharVal VARCHAR(200),
@DataYear DATE
AS 
BEGIN
DECLARE @CountryID INT;
DECLARE @MeasureID INT;
END
SET @CountryID = (SELECT CountryID FROM COUNTRY WHERE CountryName = @CountryName);
IF @CountryID IS NULL
RAISERROR('Country does not exist.', 1, 1) WITH NOWAIT;
SET @MeasureID = (SELECT MeasureID FROM MEASURE WHERE MeasureName = @MeasureName);
IF @MeasureID IS NULL
RAISERROR('Measure does not exist.', 1, 1) WITH NOWAIT;
IF @CountryID IS NULL OR @MeasureID IS NULL
RAISERROR('Item could not be inserted.', 1, 1) WITH NOWAIT;
ELSE 
BEGIN
BEGIN TRAN T1
INSERT INTO COUNTRY_MEASURE (CountryID, MeasureID, CharValue, DataYear) 
VALUES (@CountryID, @MeasureID, @CharVal, @DataYear);
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
END

--INSERTS COUNTRY MEASUREMENT FOR INT VALUES;
--ACCEPTS COUNTRY & MEASURE NAME, INT VALUE, AND YEAR OF DATA;
--I.E. EXEC INS_CM_NUM 'United States', 'Energy Usage', 10, '03-03-2015';
CREATE PROC INS_CM_NUM
@CountryName VARCHAR(100),
@MeasureName VARCHAR(100),
@Val INT,
@DataYear DATE
AS 
BEGIN
DECLARE @CountryID INT;
DECLARE @MeasureID INT;
END
BEGIN TRAN T1
SET @CountryID = (SELECT CountryID FROM COUNTRY WHERE CountryName = @CountryName);
IF @CountryID IS NULL
RAISERROR('Country does not exist.', 1, 1) WITH NOWAIT;
SET @MeasureID = (SELECT MeasureID FROM MEASURE WHERE MeasureName = @MeasureName);
IF @MeasureID IS NULL
RAISERROR('Measure does not exist.', 1, 1) WITH NOWAIT;
IF @CountryID IS NULL OR @MeasureID IS NULL
RAISERROR('Item could not be inserted.', 1, 1) WITH NOWAIT;
ELSE 
BEGIN
INSERT INTO COUNTRY_MESAURE (CountryID, MeasureID, NumericValue, DataYear) 
VALUES (@CountryID, @MeasureID, @Val, @DataYear);
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
END

--DELETES COUNTRY MEASUREMENT USING COUNTRY/MEASURE NAME, & DATE;
--I.E. EXEC DEL_CM 'United States', 'Energy Usage', '03-03-2015';
CREATE PROC DEL_CM 
@CountryName VARCHAR(100),
@MeasureName VARCHAR(100),
@Year DATE
AS
DECLARE @CMID INT;
DECLARE @CountryID INT;
DECLARE @MeasureID INT;
BEGIN
SET @CountryID = (SELECT TOP 1 CountryID FROM COUNTRY WHERE CountryName = @CountryName);
IF @CountryID IS NULL
RAISERROR('Country does not exist.', 1, 1) WITH NOWAIT;
SET @MeasureID = (SELECT TOP 1 MeasureID FROM MEASURE WHERE MeasureName = @MeasureName);
IF @MeasureID IS NULL 
RAISERROR('Measure does not exist', 1, 1) WITH NOWAIT;
SET @CMID = (SELECT TOP 1 CountryMeasureID FROM COUNTRY_MEASURE WHERE CountryID = @CountryID 
AND MeasureID = @MeasureID AND DataYear = @Year);
DELETE FROM COUNTRY_MEASURE WHERE CountryMeasureID = @CMID;
END

--INSERTS NEW POSITION USING POSITION NAME/DESCRIPTION;
--I.E. EXEC INS_POSITION 'President', 'Leader of Democratic body';
CREATE PROC INS_POSITION
@Name VARCHAR(100),
@Descr VARCHAR(500)
AS 
BEGIN
DECLARE @ID INT = (SELECT PositionID FROM POSITION WHERE PositionName = @Name);
IF @ID IS NOT NULL
RAISERROR('Position Already Exists', 1, 1);
ELSE
INSERT INTO POSITION (PositionName, PositionDescr) VALUES (@Name, @Descr);
END 

--DELETES POSITION USING NAME OF POSITION;
--I.E. EXEC DEL_POSITION 'President';
CREATE PROC DEL_POSITION 
@Name VARCHAR(100)
AS 
BEGIN
DELETE FROM POSITION WHERE PositionName = @Name;
END

--UPDATES POSITION WITH NEW DESCRIPTION;
--I.E. EXEC SET_POSITION 'President', 'Leader of democratic body';
CREATE PROC SET_POSITION
@Name VARCHAR(100),
@Descr VARCHAR(500)
AS 
BEGIN
UPDATE POSITION SET PositionDescr = @Descr WHERE PositionName = @Name;
END 

--INSERTS NEW PERSON USING FIRSTNAME, LASTNAME, AND DATE OF BIRTH;
--I.E. EXEC INS_PERSON 'Donald', 'Rumsfield', '02/04/1933';
CREATE PROC INS_PERSON 
@Fname VARCHAR(35),
@Lname VARCHAR(35),
@DOB DATE
AS
BEGIN TRAN T1
DECLARE @ID INT = (SELECT TOP 1 PersonID FROM PERSON WHERE PersonLname = @Lname AND PersonFname = @Fname AND DateOfBirth = @DOB);
IF @ID IS NOT NULL
RAISERROR('Person Already Exists.',1,1);
ELSE
INSERT INTO PERSON (PersonLname, PersonFname, DateOfBirth) VALUES (@Lname, @Fname, @DOB);
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1

--DELETES PERSON USING FIRSTNAME, LASTNAME, AND DATE OF BIRTH;
--I.E. EXEC DEL_PERSON 'Barack', 'Obama', '03-03-1958';
CREATE PROC DEL_PERSON
@Fname VARCHAR(35),
@Lname VARCHAR(35),
@DOB DATE
AS
DECLARE @PID INT;
BEGIN TRAN T1
SET @PID = (SELECT TOP 1 PersonID FROM PERSON WHERE PersonLname = @Lname AND PersonFname = @Fname
AND DateOfBirth = @DOB);
IF @PID IS NULL
RAISERROR('Person does not exist', 1, 1);
ELSE
DELETE FROM PERSON
WHERE PersonID = @PID;
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE 
COMMIT TRAN T1

--INSERTS NEW JOB FOR A PERSON USING PERSON'S FIRST/LAST NAME,
--NAME OF COUNTRY, POSITION NAME, AND BEGIN DATE;
--I.E. EXEC INS_JOB 'Barack', 'Obama', 'United States', 'President', '01/04/08';
CREATE PROC INS_JOB 
@PersonFname VARCHAR(35),
@PersonLname VARCHAR(35),
@CountryName VARCHAR(100),
@PositionName VARCHAR(100),
@BeginDate DATE
AS
DECLARE @CountryID INT;
DECLARE @PositionID INT;
DECLARE @PersonID INT;
BEGIN
SET @CountryID = (SELECT TOP 1 CountryID FROM COUNTRY WHERE CountryName = @CountryName);
IF @CountryID IS NULL
RAISERROR('Country does not exist.', 1, 1);
SET @PositionID = (SELECT TOP 1 PositionID FROM POSITION WHERE PositionName = @PositionName);
IF @PositionID IS NULL
RAISERROR('Position does not exist.', 1, 1);
SET @PersonID = (SELECT TOP 1 PersonID FROM PERSON WHERE PersonLname = @PersonLname AND PersonFname = @PersonFname);
IF @PersonID IS NULL
RAISERROR('Person does not exist.', 1, 1);
END
IF @PositionID IS NULL OR @CountryID IS NULL OR @PersonID IS NULL
RAISERROR('Supplied value unable to be inserted', 1, 1);
ELSE
BEGIN
BEGIN TRAN T1
INSERT INTO JOB (CountryID, PositionID, PersonID, BeginDate) 
VALUES (@CountryID, @PositionID, @PersonID, @BeginDate);
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE 
COMMIT TRAN T1
END

--test this
CREATE PROC DEL_JOB 
@PersonFname VARCHAR(35),
@PersonLname VARCHAR(35),
@CountryName VARCHAR(100),
@PositionName VARCHAR(100)
@BeginDate DATE 
AS 
DECLARE @PersonID INT;
DECLARE @CountryID INT;
DECLARE @PositionID INT;
BEGIN
SET @PersonID = (SELECT TOP 1 PersonID FROM PERSON WHERE PersonLname = @PersonLname AND PersonFname = @PersonFname);
SET @CountryID = (SELECT TOP 1 CountryID FROM COUNTRY WHERE CountryName = @CountryName);
SET @PositionID = (SELECT TOP 1 PositionID FROM POSITION WHERE PositionName = @PositionName);
IF @PersonID IS NULL OR @CountryID IS NULL OR @PositionID IS NULL
RAISERROR('Item could not be deleted', 1, 1);
ELSE 
DELETE FROM JOB WHERE PersonID = @PersonID AND CountryID = @CountryID AND PositionID = @PositionID;
END

--INSERTS NEW ACTION TYPE USING NAME/DESCR OF NEW ACTION TYPE;
--I.E. EXEC INS_ACTION_TYPE 'Embargo', 'Stop buying from x';
CREATE PROC INS_ACTION_TYPE
@Name VARCHAR(100),
@Descr VARCHAR(500)
AS
BEGIN
DECLARE @ID INT = (SELECT TOP 1 ActionTypeID FROM ACTION_TYPE WHERE ActionTypeName = @Name);
IF @ID IS NOT NULL
RAISERROR('Action Type already exists', 1, 1);
ELSE
INSERT INTO ACTION_TYPE (ActionTypeName, ActionTypeDescr) VALUES (@Name, @Descr);
END

CREATE PROC DEL_ACTION_TYPE
@Name VARCHAR(100)
AS
BEGIN


CREATE PROC SET_ACTION_TYPE

--INSERTS NEW ACTION USING NAME OF ACTION, BEGIN DATE OF ACTION,
--AND TYPE OF ACTION;
--I.E. EXEC INS_ACTION 'Embargo on x', '03/09/14', 'Embargo';
CREATE PROC INS_ACTION 
@ActionName VARCHAR(100),
@ActionBeginDate DATE,
@ActionTypeName VARCHAR(100)
AS
DECLARE @ActionTypeID INT;
BEGIN 
SET @ActionTypeID = (SELECT TOP 1 ActionTypeID FROM ACTION_TYPE WHERE ActionTypeName = @ActionTypeName);
IF @ActionTypeID IS NULL
RAISERROR('Action Type does not exist.', 1, 1);
DECLARE @ActionID INT = (SELECT TOP 1 ActionID FROM ACTION WHERE ActionName = @ActionName AND ActionBeginDate = @ActionBeginDate);
IF @ActionID IS NOT NULL
RAISERROR('Action already exists.', 1, 1);
END
IF @ActionTypeID IS NULL OR @ActionID IS NOT NULL
RAISERROR('Action cannot be inserted.', 1, 1);
ELSE 
BEGIN
BEGIN TRAN T1
INSERT INTO ACTION (ActionName, ActionBeginDate, ActionTypeID) VALUES (@ActionName, @ActionBeginDate, @ActionTypeID);
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
END

CREATE PROC DEL_ACTION

CREATE PROC SET_ACTION


--INSERTS NEW CONDITION AND CONNECTS CONDITION TO THE RELEVANT
--ACTION AND COUNTRY USING: NAME OF CONDITION, DESCRIPTION OF CONDITION,
--NAME OF COUNTRY, NAME OF ACTION, AND BEGIN DATE OF CONDITION;
--FOLLOWING TABLES ARE UPDATED: CONDITION, ACTION_CONDITION, ACTION_CONDITION_COUNTRY;
--I.E. EXEC INS_CONDITION 'Weaponless', 'No weapons in x', 'Zimbabwe', 'Weaponless Zimbabwe','03/04/15';
CREATE PROC INS_CONDITION
@Name VARCHAR(50),
@ConditionDescr VARCHAR(500),
@CountryName VARCHAR(100),
@ActionName VARCHAR(100),
@BeginDate DATE
AS
DECLARE @ConditionID INT;
DECLARE @ActionID INT;
DECLARE @CountryID INT;
DECLARE @ActionConditionID INT;

SET @ActionID = (SELECT TOP 1 ActionID FROM ACTION WHERE ActionName = @ActionName);
IF @ActionID IS NULL
RAISERROR('Action does not exist.', 1, 1);
SET @CountryID = (SELECT TOP 1 CountryID FROM COUNTRY WHERE CountryName = @CountryName);
IF @CountryID IS NULL
RAISERROR('Country does not exist.', 1, 1);
IF @CountryID IS NULL OR @ActionID IS NULL
RAISERROR('Condition could not be inserted.', 1, 1);
ELSE 
BEGIN
BEGIN TRAN T1
INSERT INTO CONDITION (ConditionName, ConditionDescr) VALUES (@Name, @ConditionDescr);
SET @ConditionID = (SELECT scope_identity());
INSERT INTO ACTION_CONDITION (ActionID, ConditionID) VALUES (@ActionID, @ConditionID);
SET @ActionConditionID = (SELECT scope_identity());
INSERT INTO ACTION_CONDITION_COUNTRY (ActionConditionID, CountryID, BeginDate) VALUES (@ActionConditionID, @CountryID, @BeginDate);
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
END

CREATE PROC DEL_CONDITION

CREATE PROC SET_CONDITION

--INSERTS NEW COMMENT TYPE USING NAME/DESCRIPTION OF COMMENT TYPE;
--I.E. EXEC INS_COMMENT_TYPE 'Official Statement', 'Official word of Government';
CREATE PROC INS_COMMENT_TYPE
@Name VARCHAR(50),
@Descr VARCHAR(300)
AS
BEGIN
DECLARE @ID INT = (SELECT TOP 1 CommentTypeID FROM COMMENT_TYPE WHERE CommentTypeName = @Name);
IF @ID IS NOT NULL
RAISERROR('Comment Type already exists.', 1, 1);
ELSE
INSERT INTO COMMENT_TYPE (CommentTypeName, CommentTypeDescr) VALUES (@Name, @Descr);
END

CREATE PROC SET_COMMENT_TYPE

CREATE PROC DEL_COMMENT_TYPE

--INSERTS NEW COMMENT USING BODY OF COMMENT, RELEVANT ACTION NAME, AND RELATIVE CONDITION NAME;
--I.E. EXEC INS_COMMENT 'George thinks bad', 'Official Statement', 'Embargo on x', 'No products from x';
CREATE PROC INS_COMMENT
@CommentBody VARCHAR(500),
@CommentType VARCHAR(50),
@ActionName VARCHAR(100),
@ConditionName VARCHAR(100)
AS
DECLARE @ActionConditionID INT;
DECLARE @ActionID INT;
DECLARE @ConditionID INT;
DECLARE @CommentTypeID INT;
BEGIN 
SET @CommentTypeID = (SELECT TOP 1 CommentTypeID FROM COMMENT_TYPE WHERE CommentTypeName = @CommentType);
IF @CommentTypeID IS NULL
RAISERROR('Comment Type does not exist.', 1, 1);
SET @ActionID = (SELECT TOP 1 ActionID FROM ACTION WHERE ActionName = @ActionName);
IF @ActionID IS NULL
RAISERROR('Action does not exist.', 1, 1);
SET @ConditionID = (SELECT TOP 1 ConditionID FROM CONDITION WHERE ConditionName = @ConditionName);
IF @ConditionID IS NULL
RAISERROR('Condition does not exist.', 1, 1);
SET @ActionConditionID = (SELECT TOP 1 ActionConditionID FROM ACTION_CONDITION 
	WHERE ActionID = @ActionID AND ConditionID = @ConditionID);
END
IF @ActionConditionID IS NULL
RAISERROR('Comment does not relate to supplied action and condition. Item could not be inserted.', 1, 1);
ELSE
BEGIN
BEGIN TRAN T1 
INSERT INTO COMMENT (ActionConditionID, CommentTypeID, CommentBody) VALUES (@ActionConditionID, @CommentTypeID, @CommentBody);
IF @@ERROR <> 0 
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
END

CREATE PROC DEL_COMMENT

CREATE PROC SET_COMMENT 

--INSERTS NEW PRODUCT TYPE USING NAME/DESCRIPTION OF PRODUCT TYPE;
--I.E: EXEC INS_PRODUCT_TYPE 'Export', 'service shipped out of country';
CREATE PROC INS_PRODUCT_TYPE
@Name VARCHAR(50),
@Descr VARCHAR(300)
AS
BEGIN
DECLARE @ID INT = (SELECT ProductTypeID FROM PRODUCT_TYPE WHERE ProductTypeName = @Name);
IF @ID IS NOT NULL
RAISERROR('Product type already exists.', 1, 1);
ELSE
INSERT INTO PRODUCT_TYPE (ProductTypeName, ProductTypeDescr) VALUES (@Name, @Descr);
END

CREATE PROC DEL_PRODUCT_TYPE

CREATE PROC SET_PRODUCT_TYPE


--INSERTS NEW PRODUCT USING NAME/DESCRIPTION OF PRODUCT,
--RELEVANT COUNTRY NAME, AND PERCENT GDP;
--UPDATES TABLES PRODUCT & COUNTRY_PRODUCT;
--I.E. EXEC INS_COUNTRY_PRODUCT 'Timber','Export', 'United States', '10.5';
CREATE PROC INS_COUNTRY_PRODUCT 
@ProductName VARCHAR(50),
@ProductType VARCHAR(50),
@CountryName VARCHAR(100),
@PercentGDP DECIMAL(5,2)
AS
DECLARE @ProductTypeID INT;
DECLARE @CountryID INT;
DECLARE @ProductID INT;
SET @CountryID = (SELECT TOP 1 CountryID FROM COUNTRY WHERE CountryName = @CountryName);
IF @CountryID IS NULL
RAISERROR('Country value does not exists.', 1, 1);
SET @ProductTypeID = (SELECT TOP 1 ProductTypeID FROM PRODUCT_TYPE WHERE ProductTypeName = @ProductType);
IF @ProductTypeID IS NULL
BEGIN
DECLARE @MSG VARCHAR(50) = @ProductType + ' does not exist';
RAISERROR(@MSG, 1, 1);
END 
SET @ProductID = (SELECT TOP 1 ProductID FROM PRODUCT WHERE ProductName = @ProductName AND ProductTypeID = @ProductTypeID);
IF @ProductID IS NULL
RAISERROR('Product does not exist.', 1, 1);
IF @ProductID IS NULL OR @CountryID IS NULL
RAISERROR('Item could not be inserted', 1, 1);
ELSE
BEGIN 
BEGIN TRAN T1
INSERT INTO COUNTRY_PRODUCT (CountryID, ProductID, PercentGDP) VALUES (@CountryID, @ProductID, @PercentGDP);
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE 
COMMIT TRAN T1
END

--DELETES MEASUREMENT OF PRODUCT FROM SPECIFIC COUNTRY;
--ACCEPTS COUNTRY NAME, PRODUCT TYPE, AND PRODUCT NAME;
--RETURNS ERROR IF PROVIDED VALUES DO NOT EXIST;
--I.E. EXEC DEL_COUNTRY_PRODUCT 'United States', 'Timber', 'Export';
CREATE PROC DEL_COUNTRY_PRODUCT
@CountryName VARCHAR(100),
@ProductName VARCHAR(50),
@ProductType VARCHAR(50)
AS
DECLARE @ID INT;
DECLARE @TypeID INT;
DECLARE @CountryID INT;
DECLARE @ProductID INT;
BEGIN
SET @CountryID = (SELECT TOP 1 CountryID FROM COUNTRY WHERE CountryName = @CountryName);
IF @CountryID IS NULL
BEGIN
DECLARE @MSG VARCHAR(50) = @CountryName + ' does not exist';
RAISERROR(@MSG, 1, 1);
END
SET @TypeID = (SELECT TOP 1 ProductTypeID FROM PRODUCT_TYPE WHERE ProductTypeName = @ProductType);
IF @TypeID IS NULL
BEGIN
DECLARE @MSG1 VARCHAR(50) = @ProductType + ' does not exist';
RAISERROR(@MSG1, 1, 1);
END
SET @ProductID = (SELECT TOP 1 ProductID FROM PRODUCT WHERE ProductName = @ProductName AND ProductTypeID = @TypeID);
SET @ID = (SELECT TOP 1 CountryProductID FROM COUNTRY_PRODUCT WHERE ProductID = @ProductID AND CountryID = @CountryID);
IF @ID IS NULL
BEGIN
DECLARE @MSG3 VARCHAR(100) = @CountryName + ' does not have ' + @ProductName +  ' as a(n) ' + @ProductType + '. Item could not be inserted.';
RAISERROR(@MSG3, 1, 1);
END
ELSE
BEGIN TRAN T1
DELETE FROM COUNTRY_PRODUCT WHERE CountryProductID = @ID;
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE 
COMMIT TRAN T1; 
END

--INSERTS NEW PRODUCT USING PRODUCT NAME/DESCR/TYPE
--I.E. EXEC INS_PRODUCT 'Timber', 'Relating to wood products', 'Import'
CREATE PROC INS_PRODUCT
@Name VARCHAR(50),
@Descr VARCHAR(300),
@ProductType VARCHAR(50)
AS
DECLARE @ProductTypeID INT;
DECLARE @CountryID INT;
BEGIN
SET @ProductTypeID = (SELECT TOP 1 ProductTypeID FROM PRODUCT_TYPE WHERE ProductTypeName = @ProductType);
IF @ProductTypeID IS NULL
RAISERROR('Product type does not exist.', 1, 1);
DECLARE @ID INT = (SELECT TOP 1 ProductID FROM PRODUCT WHERE ProductName = @Name AND ProductTypeID = @ProductTypeID);
IF @ID IS NOT NULL
RAISERROR('Product already exists', 1, 1);
IF @ProductTypeID IS NULL OR @ID IS NOT NULL
RAISERROR('Item could not be inserted', 1, 1);
ELSE 
BEGIN TRAN T1
INSERT INTO PRODUCT (ProductName, ProductDescr, ProductTypeID) VALUES (@Name, @Descr, @ProductTypeID);
IF @@ERROR <> 0 
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
END 


--SETS DESCRIPTION OF A PRODUCT;
--ACCEPTS NAME OF PRODUCT TO BE CHANGED, TYPE OF PRODUCT, AND NEW DESCR;
--RETURNS ERROR IF PROVIDED VALUES DO NOT EXIST;
--I.E. EXEC SET_PRODUCT_DESCR 'Timber', 'Export', 'Both artificial and natural timber';
CREATE PROC SET_PRODUCT_DESCR
@ProductName VARCHAR(50),
@ProductType VARCHAR(50),
@ProductDescr VARCHAR(300)
AS
DECLARE @ProductTypeID INT;
DECLARE @ProductID INT;
BEGIN
SET @ProductTypeID = (SELECT TOP 1 ProductTypeID FROM PRODUCT_TYPE WHERE ProductTypeName = @ProductType);
IF @ProductTypeID IS NULL
BEGIN
DECLARE @MSG VARCHAR(50) = @ProductType + ' does not exist';
RAISERROR(@MSG, 1, 1);
END
SET @ProductID = (SELECT TOP 1 ProductID FROM PRODUCT WHERE ProductName = @ProductName AND ProductTypeID = @ProductTypeID);
IF @ProductID IS NULL
BEGIN
DECLARE @MSG1 VARCHAR(100) = @ProductName + ' as a(n) ' + @ProductType + ' does not exist, and could not be updated';
RAISERROR(@MSG1, 1, 1);
END
ELSE 
BEGIN TRAN T1
UPDATE PRODUCT SET ProductDescr = @ProductDescr WHERE ProductID = @ProductID;
IF @@ERROR <> 0 
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
END IT TRAN T1
END 
 

--ADDS RANDOM TRANSACTIONAL DATA TO ACTION/CONDITION TABLES;
--INSERTS NEW RANDOM TRANSACTIONS BASED ON DATA ALREADY IN DATABASE;
--INSERTS NUMBER OF TRANSACTIONS THAT IS INPUTTED BY USER;
--I.E. EXEC INS_TRANSACTIONS 100000;
CREATE PROC INS_TRANSACTIONS
@Total INT
AS
DECLARE @INC INT = 0;
WHILE @INC < @Total
BEGIN
DECLARE @CountryMAX INT = (SELECT MAX(CountryID) FROM COUNTRY);
DECLARE @CountryMIN INT = (SELECT MIN(CountryID) FROM COUNTRY);
DECLARE @CountryID INT = (RAND() * (@CountryMAX - @CountryMIN) + @CountryMIN);

DECLARE @ActionMAX INT = (SELECT MAX(ActionID) FROM ACTION);
DECLARE @ActionMIN INT = (SELECT MIN(ActionID) FROM ACTION);
DECLARE @ActionID INT = (RAND() * (@ActionMAX - @ActionMIN) + @ActionMIN);
DECLARE @ActionName VARCHAR(100) = (SELECT ActionName FROM ACTION WHERE ActionID = @ActionID);

DECLARE @ActionTypeMAX INT = (SELECT MAX(ConditionID) FROM CONDITION);
DECLARE @ActionTypeMIN INT = (SELECT MIN(ConditionID) FROM CONDITION);
DECLARE @ActionTypeID INT = ((RAND() * (@ActionTypeMAX - @ActionTypeMIN)) + @ActionTypeMIN);
DECLARE @ActionTypeName VARCHAR(100) = (SELECT ActionTypeName from ACTION_TYPE WHERE ActionTypeID = @ActionTypeID);

DECLARE @ConditionMAX INT = (SELECT MAX(ConditionID) FROM CONDITION);
DECLARE @ConditionMIN INT = (SELECT MIN(ConditionID) FROM CONDITION);
DECLARE @ConditionID INT = ((RAND() * (@ConditionMAX - @ConditionMIN)) + @ConditionMIN);
DECLARE @ConditionName VARCHAR(100) = (SELECT ConditionName FROM CONDITION WHERE ConditionID = @ConditionID);
DECLARE @ConditionDescr VARCHAR(500) = (SELECT ConditionDescr FROM CONDITION WHERE ConditionID = @ConditionID);

DECLARE @BeginDate DATE = GETDATE();
BEGIN TRAN T1
IF @ActionName IS NOT NULL AND @ActionTypeName IS NOT NULL AND @ConditionName IS NOT NULL 
BEGIN
INSERT INTO ACTION (ActionName, ActionBeginDate, ActionTypeID) VALUES (@ActionName, @BeginDate, @ActionTypeID);
INSERT INTO CONDITION (ConditionName, ConditionDescr) VALUES (@ConditionName, @ConditionDescr);
INSERT INTO ACTION_CONDITION (ActionID, ConditionID) VALUES (@ActionID, @ConditionID);
DECLARE @ActionConditionID INT = (SELECT scope_identity());
INSERT INTO ACTION_CONDITION_COUNTRY (ActionConditionID, CountryID, BeginDate) VALUES (@ActionConditionID, @CountryID, @BeginDate);
IF @@ERROR <> 0
ROLLBACK TRAN T1
ELSE
COMMIT TRAN T1
SET @INC = @INC + 1;
END
END;

/*
POSSIBLE PROC TO ADD:
CREATE PROC DEL_PRODUCT

CREATE PROC SET_COUNTRY_PRODUCT

CREATE PROC DEL_PRODUCT_TYPE

CREATE PROC SET_PRODUCT_TYPE

CREATE PROC DEL_COMMENT

CREATE PROC SET_COMMENT 

CREATE PROC SET_COMMENT_TYPE

CREATE PROC DEL_COMMENT_TYPE

CREATE PROC DEL_CONDITION

CREATE PROC SET_CONDITION

CREATE PROC DEL_ACTION

CREATE PROC SET_ACTION

CREATE PROC DEL_ACTION_TYPE

CREATE PROC SET_ACTION_TYPE
*/