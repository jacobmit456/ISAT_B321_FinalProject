/*
	Programmer: Christoph Hagenauer
	Class: ISAT B321
	Purpose: Create tables for Final Project
*/

DROP TABLE IF EXISTS AcademicTerms;
DROP TABLE IF EXISTS EventAttendees;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS RecievableLineItems;
DROP TABLE IF EXISTS Recievables;
DROP TABLE IF EXISTS ExpenditureLineItems;
DROP TABLE IF EXISTS Expenditures;
DROP TABLE IF EXISTS Locations;
DROP TABLE IF EXISTS Officers;
DROP TABLE IF EXISTS MembershipRecords
DROP TABLE IF EXISTS AccountingAccounts;
DROP TABLE IF EXISTS People;
GO
DROP VIEW IF EXISTS vw_AcademicYears;
DROP function IF EXISTS fn_LookUpTerm;
DROP function IF EXISTS fn_LookUpYear;
GO
DROP PROCEDURE IF EXISTS sp_CreateMembershipRecords;
DROP PROCEDURE IF EXISTS sp_PopulateOfficers;
DROP PROCEDURE IF EXISTS sp_Donations;
DROP PROCEDURE IF EXISTS sp_OfficersForEvents;
DROP PROCEDURE IF EXISTS sp_OfficersForExpenditures;
DROP PROCEDURE IF EXISTS sp_EventAttendees;
DROP PROCEDURE IF EXISTS sp_Sales;
GO

CREATE TABLE [People] (
  [PeopleID] INT IDENTITY,
  [LName] VARCHAR(50),
  [FName] VARCHAR(50),
  [Email] VARCHAR(50),
  [ACMID] CHAR(7),
  [Classification] VARCHAR(50),
  [StudentVIPID] VARCHAR(50),
  [PaymentDate] DATE,
  [Organization] VARCHAR(50),
  PRIMARY KEY ([PeopleID])
);

CREATE TABLE [Officers] (
  [OfficerID] INT IDENTITY,
  [PeopleID] INT,
  [Position] VARCHAR(50),
  [StartDate] DATE,
  [EndDate] DATE,
  PRIMARY KEY ([OfficerID]),
  CONSTRAINT [FK_Officers.PeopleID]
    FOREIGN KEY ([PeopleID])
      REFERENCES [People]([PeopleID])
);

CREATE TABLE [Locations] (
  [LocationID] INT IDENTITY,
  [Name] VARCHAR(50),
  [Description] VARCHAR(500),
  [Building] VARCHAR(50),
  [Room] VARCHAR(50),
  [Address1] VARCHAR(50),
  [Address2] VARCHAR(50),
  [City] VARCHAR(50),
  [State] VARCHAR(50),
  [ZipCode] CHAR(10),
  PRIMARY KEY ([LocationID])
);

CREATE TABLE [Events] (
  [EventID] INT IDENTITY,
  [OfficerID] INT,
  [EventName] VARCHAR(50),
  [Description] VARCHAR(500),
  [EventStartTime] DATETIME,
  [EventEndTime] DATETIME,
  [LocationID] INT,
  PRIMARY KEY ([EventID]),
  CONSTRAINT [FK_Events.OfficerID]
    FOREIGN KEY ([OfficerID])
      REFERENCES [Officers]([OfficerID]),
  CONSTRAINT [FK_Events.LocationID]
    FOREIGN KEY ([LocationID])
      REFERENCES [Locations]([LocationID])
);

CREATE TABLE [AccountingAccounts] (
  [AccountingID] INT IDENTITY,
  [AccountDescription] VARCHAR(150),
  [RoutingNumber] CHAR(9),
  [AccountNumber] CHAR(12),
  PRIMARY KEY ([AccountingID])
);

CREATE TABLE [Expenditures] (
  [ExpenditureID] INT IDENTITY,
  [AccountingID] INT,
  [ExpenditureDate] DATE,
  [OfficerID] INT,
  [Description] VARCHAR(50),
  [RecordLocator] VARCHAR(50),
  PRIMARY KEY ([ExpenditureID]),
  CONSTRAINT [FK_Expenditures.OfficerID]
    FOREIGN KEY ([OfficerID])
      REFERENCES [Officers]([OfficerID]),
  CONSTRAINT [FK_Expenditures.AccountingID]
    FOREIGN KEY ([AccountingID])
      REFERENCES [AccountingAccounts]([AccountingID])
);

CREATE TABLE [ExpenditureLineItems] (
  [ExpenditureLineItemID] INT IDENTITY,
  [ExpenditureID] INT,
  [LineItemDescription] VARCHAR(150),
  [UnitQuantity] INT,
  [QuantityPerUnit] INT,
  [UnitPrice] MONEY,
  [LineItemCategory] VARCHAR(20),
  [LocationID] INT,
  PRIMARY KEY ([ExpenditureLineItemID]),
  CONSTRAINT [FK_ExpenditureLineItems.LocationID]
    FOREIGN KEY ([LocationID])
      REFERENCES [Locations]([LocationID]),
  CONSTRAINT [FK_ExpenditureLineItems.ExpenditureID]
    FOREIGN KEY ([ExpenditureID])
      REFERENCES [Expenditures]([ExpenditureID])
);

CREATE TABLE [EventAttendees] (
  [EventAttendeeID] INT IDENTITY,
  [EventID] INT,
  [PeopleID] INT,
  PRIMARY KEY ([EventAttendeeID]),
  CONSTRAINT [FK_EventAttendees.PeopleID]
    FOREIGN KEY ([PeopleID])
      REFERENCES [People]([PeopleID]),
  CONSTRAINT [FK_EventAttendees.EventID]
    FOREIGN KEY ([EventID])
      REFERENCES [Events]([EventID])
);

CREATE TABLE [Recievables] (
  [RecievableID] INT IDENTITY,
  [PeopleID] INT,
  [AccountID] INT,
  [Description] VARCHAR(150),
  [PaidDate] DATE,
  [RecordLocator] VARCHAR(150),
  PRIMARY KEY ([RecievableID]),
  CONSTRAINT [FK_Recievables.PeopleID]
    FOREIGN KEY ([PeopleID])
      REFERENCES [People]([PeopleID]),
  CONSTRAINT [FK_Recievables.AccountID]
    FOREIGN KEY ([AccountID])
      REFERENCES [AccountingAccounts]([AccountingID])
);

CREATE TABLE [RecievableLineItems] (
  [RevievableLineItemID] INT IDENTITY,
  [RecievableID] INT,
  [Item] VARCHAR(150),
  [UnitType] INT,
  [UnitCost] MONEY,
  [UnitQuantity] INT,
  [ExpenditureLineItemID] INT
  PRIMARY KEY ([RevievableLineItemID]),
  CONSTRAINT [FK_RecievableLineItems.RecievableID]
    FOREIGN KEY ([RecievableID])
      REFERENCES [Recievables]([RecievableID])
);

CREATE TABLE [AcademicTerms] (
  [AcademicTermID] INT IDENTITY,
  [AcademicTerm] VARCHAR(50),
  [TermStartDate] DATE,
  [TermEndDate] DATE,
  PRIMARY KEY ([AcademicTermID])
);

CREATE TABLE [MembershipRecords] (
  [MRecordID] INT IDENTITY,
  [PeopleID] INT,
  [StartDate] DATE,
  [EndDate] DATE,
  PRIMARY KEY ([MRecordID]),
  CONSTRAINT [FK_MembershipRecords.PeopleID]
    FOREIGN KEY ([PeopleID])
      REFERENCES [People]([PeopleID])
);
GO

/**************************** VIEW Academic Years ****************************/
CREATE VIEW vw_AcademicYears AS
SELECT at.AcademicTermID AS AcademicYearID, SUBSTRING(at.AcademicTerm, LEN(at.AcademicTerm) - 1, 2) + '-' + SUBSTRING(at2.AcademicTerm, LEN(at2.AcademicTerm) - 1, 2) AS AcademicYear, at.TermStartDate, at2.TermEndDate
	FROM AcademicTerms at
	INNER JOIN AcademicTerms at2 ON at.AcademicTermID = at2.AcademicTermID-2
	WHERE at.AcademicTerm like 'F%';
GO
-- SELECT * FROM vw_AcademicYears

/**************************** function to look up academic term based ON the date ****************************/
CREATE FUNCTION fn_LookUpTerm  
(@date DATE)
RETURNS INT
BEGIN
	RETURN
	(
		SELECT AcademicTermID
		FROM AcademicTerms 
		WHERE @date >= TermStartDate and @date <= TermEndDate 
	);
END
GO

/**************************** function to look up academic year based ON the date ****************************/

GO
CREATE FUNCTION fn_LookUpYear  
(@date DATE)
RETURNS INT
BEGIN
	RETURN
	(
		SELECT AcademicYearID
		FROM vw_AcademicYears 
		WHERE @date >= TermStartDate and @date <= TermEndDate 
	);
END
GO

/*********************** Trigger to make Membership Record ON update PaymentDate ***********************/
CREATE TRIGGER [dbo].[tr_people_for_update]
    ON [dbo].[People]
    AFTER UPDATE
AS
BEGIN   
    INSERT INTO [dbo].[MembershipRecords] (PeopleID, StartDate, EndDate)
    SELECT inserted.PeopleID
         , inserted.PaymentDate
         , DATEADD(yyyy, 1, inserted.PaymentDate) AS EndDate
    FROM inserted
	WHERE 
		inserted.PaymentDate IS NOT NULL;
END
GO

/*********************** SP for Membership Records ***********************/
CREATE PROCEDURE sp_CreateMembershipRecords AS
BEGIN
	DROP TABLE IF EXISTS #Classifications;
	CREATE TABLE [#Classifications] (
	  [ClassificationID] INT,
	  [Description] VARCHAR(50),
	  PRIMARY KEY ([ClassificationID])
	);
	INSERT INTO #Classifications VALUES(1, 'Freshman');
	INSERT INTO #Classifications VALUES(2, 'Sophermore');
	INSERT INTO #Classifications VALUES(3, 'Junior');
	INSERT INTO #Classifications VALUES(4, 'Senior');
	INSERT INTO #Classifications VALUES(5, 'Graduate');
	INSERT INTO #Classifications VALUES(6, 'Alumni');

	DECLARE @term_id INT, @member_id INT, @count INT = 0, @classification_id INT, @start_date DATE, @end_date DATE, @paid_date DATE, @max_membership_date DATE;

	SELECT @member_id = MIN(PeopleID) FROM People WHERE PaymentDate IS NOT NULL;

	WHILE @member_id IS NOT NULL
	BEGIN
		-- get the classification of the person
		SELECT @classification_id = (ClassificationID-1) FROM #Classifications 
			INNER JOIN People ON Classification = Description 
			WHERE PeopleID = @member_id;
		-- year they could have first been in ACM
		SET @term_id = 16 - 3 * @classification_id;
		-- PRINT('Member ID : ' + CAST(@member_id AS VARCHAR(10)))
		-- PRINT(@member_id)
		-- PRINT(@classification_id)
		WHILE @term_id <= 16 
		BEGIN
			IF RAND() > 0.5
			BEGIN
				-- get the start and END date of the current year
				SELECT @start_date = TermStartDate, @end_date = TermEndDate FROM vw_AcademicYears 
					WHERE AcademicYearID = @term_id;
				-- if the enddate is after the current date, set it to the current date
				IF @end_date > GETDATE() SET @end_date = GETDATE()
				-- get a new random date between start and END date --> this is the date they paid there membership
				SELECT @paid_date = DATEADD(DAY, RAND()*DATEDIFF(DAY, @start_date, @end_date) ,@start_date);
				SELECT @max_membership_date = MAX(EndDate) FROM MembershipRecords GROUP BY PeopleID HAVING PeopleID = @member_id;;
				IF @paid_date < @max_membership_date SET @paid_date = DATEADD(DAY, 1, @max_membership_date);
				-- PRINT @paid_date
				-- update the payment date in the people table
				-- print('UPDATE People SET PaymentDate = ' + cast(@paid_date as varchar(50)) + ' WHERE PeopleID = ' + cast(@member_id as varchar(50)))
				UPDATE People SET PaymentDate = @paid_date WHERE PeopleID = @member_id;
				SET @max_membership_date = NULL;
			END
			-- increase the term id by a year
			SET @term_id += 3;
		END
		SELECT @member_id = MIN(PeopleID) FROM People WHERE PaymentDate IS NOT NULL AND PeopleID > @member_id;
	END
END
GO
/**************************** SP to populate Officers ****************************/
CREATE PROCEDURE sp_PopulateOfficers AS
BEGIN
	DECLARE @term_id INT, @people_id INT, @start_date DATE, @end_date DATE;
	SELECT @term_id = MIN(AcademicYearID) FROM vw_AcademicYears;
	DROP table if exists #CurrentMembers;
	while @term_id IS NOT NULL
	BEGIN
		SELECT @start_date = TermStartDate, @end_date = TermEndDate FROM vw_AcademicYears WHERE AcademicYearID = @term_id;
		-- PRINT @term_id
		-- get all Members for current year
		SELECT PeopleID into #CurrentMembers FROM MembershipRecords WHERE @term_id = dbo.fn_LookUpYear(StartDate) or @term_id = dbo.fn_LookUpYear(EndDate);
		-- insert all the positions
		SELECT TOP 1 @people_id = PeopleID FROM #CurrentMembers ORDER BY NEWID();
		INSERT INTO OFFICERS (PeopleID, Position, StartDate, EndDate) VALUES(@people_id, 'President', @start_date, @end_date);
		DELETE FROM #CurrentMembers WHERE PeopleID = @people_id;
		SELECT TOP 1 @people_id = PeopleID FROM #CurrentMembers ORDER BY NEWID();
		INSERT INTO OFFICERS (PeopleID, Position, StartDate, EndDate) VALUES(@people_id, 'Vice President', @start_date, @end_date);
		DELETE FROM #CurrentMembers WHERE PeopleID = @people_id;
		SELECT TOP 1 @people_id = PeopleID FROM #CurrentMembers ORDER BY NEWID();
		INSERT INTO OFFICERS (PeopleID, Position, StartDate, EndDate) VALUES(@people_id, 'Secretary', @start_date, @end_date);
		DELETE FROM #CurrentMembers WHERE PeopleID = @people_id;
		SELECT TOP 1 @people_id = PeopleID FROM #CurrentMembers ORDER BY NEWID();
		INSERT INTO OFFICERS (PeopleID, Position, StartDate, EndDate) VALUES(@people_id, 'Treasurer', @start_date, @end_date);
		DELETE FROM #CurrentMembers WHERE PeopleID = @people_id;
		SELECT TOP 1 @people_id = PeopleID FROM #CurrentMembers ORDER BY NEWID();
		INSERT INTO OFFICERS (PeopleID, Position, StartDate, EndDate) VALUES(@people_id, 'Membership Chair', @start_date, @end_date);
		DELETE FROM #CurrentMembers WHERE PeopleID = @people_id;
		SELECT TOP 1 @people_id = PeopleID FROM #CurrentMembers ORDER BY NEWID();
		INSERT INTO OFFICERS (PeopleID, Position, StartDate, EndDate) VALUES(@people_id, 'Event Coordinator', @start_date, @end_date);
		DELETE FROM #CurrentMembers WHERE PeopleID = @people_id;
		SELECT TOP 1 @people_id = PeopleID FROM #CurrentMembers ORDER BY NEWID();
		INSERT INTO OFFICERS (PeopleID, Position, StartDate, EndDate) VALUES(@people_id, 'Webmaster', @start_date, @end_date);
		DELETE FROM #CurrentMembers WHERE PeopleID = @people_id;
		SELECT TOP 1 @people_id = PeopleID FROM #CurrentMembers ORDER BY NEWID();
		INSERT INTO OFFICERS (PeopleID, Position, StartDate, EndDate) VALUES(@people_id, 'Webmaster', @start_date, @end_date);
		DROP TABLE IF EXISTS #CurrentMembers;
		INSERT INTO OFFICERS (PeopleID, Position, StartDate, EndDate) VALUES(302, 'Faculty Advisor', @start_date, @end_date);
		SELECT  @term_id = MIN(AcademicYearID) FROM vw_AcademicYears WHERE AcademicYearID > @term_id;
	END
END
GO

/**************************** SP to get Donations ****************************/
CREATE PROCEDURE sp_Donations AS
BEGIN
	DECLARE @person_id INT, @term_id INT, @count INT = 0, @start_date DATE, @end_date DATE, @DonationDate DATE, @Classification varchar(50), @donation_amount money;
	DECLARE @recordLocator INT = 15384632, @recievable_id INT;
	SELECT @term_id = MIN(AcademicYearID) FROM vw_AcademicYears;
	DROP TABLE IF EXISTS #Classifications;
	CREATE TABLE [#Classifications] (
	  [ClassificationID] INT,
	  [Description] VARCHAR(50),
	  PRIMARY KEY ([ClassificationID])
	);
	INSERT INTO #Classifications VALUES(1, 'Freshman');
	INSERT INTO #Classifications VALUES(2, 'Sophermore');
	INSERT INTO #Classifications VALUES(3, 'Junior');
	INSERT INTO #Classifications VALUES(4, 'Senior');
	INSERT INTO #Classifications VALUES(5, 'Graduate');

	WHILE @term_id IS NOT NULL
	BEGIN
		WHILE @count < 10
		BEGIN
			SELECT TOP 1 @person_id = PeopleID FROM People WHERE Classification not in (SELECT Description FROM #Classifications) order by NEWID();
			SELECT @start_date = TermStartDate, @end_date = TermEndDate FROM vw_AcademicYears WHERE AcademicYearID = @term_id;
			SELECT @DonationDate = DATEADD(DAY, RAND()*DATEDIFF(DAY, @start_date, @end_date) ,@start_date);
			SELECT @Classification = Classification FROM People WHERE @person_id = PeopleID;
			IF @Classification like 'Representative'
			BEGIN
				SELECT @donation_amount = RAND()*(400-100)+100;
				-- PRINT @donation_amount
			END
			ELSE
			BEGIN 
				SELECT @donation_amount = RAND()*(200-10)+10;
				-- PRINT @donation_amount
			END
			INSERT INTO Recievables (PeopleID, AccountID, Description, PaidDate, RecordLocator) 
				VALUES(@person_id, 2, 'A generous donation', @DonationDate, @recordLocator);
			SELECT @recievable_id = MAX(RecievableID) FROM Recievables;
			INSERT INTO RecievableLineItems(RecievableID, Item, UnitType, UnitCost, UnitQuantity) 
				VALUES(@recievable_id, 'Donation', 1, @donation_amount, 1);
			-- update count 
			SET @count = @count + 1;
			SET @recordLocator += 1;
		END
		-- Beginning of the year donation by Dr. Canada
		SELECT @donation_amount = RAND()*(300-250)+250
		SELECT @donationDate = DATEADD(DAY, RAND()*(15),@start_date)
		INSERT INTO Recievables (PeopleID, AccountID, Description, PaidDate, RecordLocator) 
				VALUES(303, 2, 'Dr. Canada loves US', @DonationDate, @recordLocator);
			SELECT @recievable_id = MAX(RecievableID) FROM Recievables
			INSERT INTO RecievableLineItems(RecievableID, Item, UnitType, UnitCost, UnitQuantity) 
				VALUES(@recievable_id, 'Donation', 1, @donation_amount, 1);
		SET @recordLocator += 1;
		-- Beginning of the year donation by Student Life
		SELECT @donation_amount = RAND()*(1000-850)+850;
		SELECT @donationDate = DATEADD(DAY, RAND()*(15),@start_date);
		INSERT INTO Recievables (PeopleID, AccountID, Description, PaidDate, RecordLocator) 
				VALUES(301, 4, 'I guess Student Life cares for us', @DonationDate, @recordLocator);
			SELECT @recievable_id = MAX(RecievableID) FROM Recievables;
			INSERT INTO RecievableLineItems(RecievableID, Item, UnitType, UnitCost, UnitQuantity) 
				VALUES(@recievable_id, 'Donation', 1, @donation_amount, 1);
		SET @recordLocator += 1;
		-- reset count
		SET @count = 0;
		SELECT @term_id = MIN(AcademicYearID) FROM vw_AcademicYears WHERE AcademicYearID > @term_id and TermStartDate < GETDATE();
	END
END
GO 
/**************************** SP to have Officers for Events ****************************/
CREATE PROCEDURE sp_OfficersForEvents AS
BEGIN
	DECLARE @term_id INT, @start_date DATE, @end_date DATE, @officer_id INT, @event_id INT;

	SELECT @term_id = MIN(AcademicYearID) FROM vw_AcademicYears;
	DROP TABLE IF EXISTS #OfficersForYear;
	WHILE @term_id IS NOT NULL
	BEGIN
		--PRINT @term_id;
		SELECT @start_date = TermStartDate, @end_date = TermEndDate FROM vw_AcademicYears WHERE AcademicYearID = @term_id;
		SELECT OfficerID INTO #OfficersForYear FROM Officers WHERE @start_date = StartDate;
		SELECT @event_id = MIN(EventID) FROM EVENTS WHERE EventStartTime > @start_date AND EventEndTime < @end_date;
		WHILE @event_id IS NOT NULL
		BEGIN
			SELECT TOP 1 @officer_id = OfficerID FROM #OfficersForYear ORDER BY NEWID();
			-- PRINT @event_id
			UPDATE Events SET OfficerID = @officer_id WHERE @event_id = EventID;
			SELECT @event_id = MIN(EventID) FROM EVENTS WHERE EventStartTime > @start_date AND EventEndTime < @end_date AND EventID > @event_id;
		END
		--PRINT @event_id;
		DROP TABLE IF EXISTS #OfficersForYear;
		SELECT @term_id = MIN(AcademicYearID) FROM vw_AcademicYears WHERE AcademicYearID > @term_id;
	END
END
GO
/**************************** SP to have Officers for Expenditures ****************************/
CREATE PROCEDURE sp_OfficersForExpenditures AS
BEGIN
	DECLARE @term_id INT, @start_date DATE, @end_date DATE, @officer_id INT, @expenditure_id INT;
	SELECT @term_id = MIN(AcademicYearID) FROM vw_AcademicYears;
	DROP TABLE IF EXISTS #OfficersForYear;
	WHILE @term_id IS NOT NULL
	BEGIN
		-- PRINT @term_id;
		SELECT @start_date = TermStartDate, @end_date = TermEndDate FROM vw_AcademicYears WHERE AcademicYearID = @term_id;
		SELECT OfficerID INTO #OfficersForYear FROM Officers WHERE @start_date = StartDate;
		SELECT @expenditure_id = MIN(ExpenditureID) FROM Expenditures WHERE ExpenditureDate >= @start_date AND ExpenditureDate <= @end_date;
		WHILE @expenditure_id IS NOT NULL
		BEGIN
			SELECT TOP 1 @officer_id = OfficerID FROM #OfficersForYear ORDER BY NEWID();
			-- PRINT @expenditure_id
			UPDATE Expenditures SET OfficerID = @officer_id WHERE @expenditure_id = ExpenditureID;
			SELECT @expenditure_id = MIN(ExpenditureID) FROM Expenditures 
				WHERE ExpenditureDate >= @start_date AND ExpenditureDate <= @end_date AND ExpenditureID > @expenditure_id;
		END
		-- PRINT @expenditure_id;
		DROP TABLE IF EXISTS #OfficersForYear;
		SELECT @term_id = MIN(AcademicYearID) FROM vw_AcademicYears WHERE AcademicYearID > @term_id;
	END
END
GO
/**************************** SP to have people go to Evenets ****************************/
CREATE PROCEDURE sp_EventAttendees AS
BEGIN
	DECLARE @term_id INT, @people_id INT, @start_date DATE, @end_date DATE, @count_at_event INT, @member_id INT, @event_id INT;
	
	SELECT @term_id = MIN(AcademicYearID) FROM vw_AcademicYears; 
	DROP TABLE IF EXISTS #CurrentMembers;
	DROP TABLE IF EXISTS #People;
	while @term_id IS NOT NULL
	BEGIN
		SELECT @start_date = TermStartDate, @end_date = TermEndDate FROM vw_AcademicYears WHERE AcademicYearID = @term_id;
		SELECT @event_id = MIN(EventID) FROM Events WHERE EventStartTime > @start_date;
		-- PRINT @term_id;
		-- get all Members for current year
		WHILE @event_id IS NOT NULL
		BEGIN
			SELECT PeopleID INTO #People FROM People WHERE ACMID IS NULL;
			SELECT PeopleID INTO #CurrentMembers FROM MembershipRecords WHERE @term_id = dbo.fn_LookUpYear(StartDate) or @term_id = dbo.fn_LookUpYear(EndDate);
			SET @count_at_event = CEILING(RAND()*(20-2)+2);
			-- PRINT @event_ID;
			WHILE @count_at_event > 0
			BEGIN
				SELECT TOP 1 @member_id = PeopleID FROM #CurrentMembers ORDER BY NEWID();
				IF RAND() > 0.8 SELECT TOP 1 @people_id = PeopleID FROM #People ORDER BY NEWID();
				IF @member_id IS NOT NULL INSERT INTO EventAttendees (EventID, PeopleID) VALUES (@event_id, @member_id);
				IF @people_id IS NOT NULL INSERT INTO EventAttendees (EventID, PeopleID) VALUES (@event_id, @people_id);
				DELETE FROM #CurrentMembers WHERE PeopleID = @member_id;
				DELETE FROM #People WHERE PeopleID = @people_id;
				SET @member_id = NULL;
				SET @people_id = NULL;
				SET @count_at_event -= 1;
			END
			DROP TABLE IF EXISTS #People;
			DROP TABLE IF EXISTS #CurrentMembers;
			SELECT @event_id = MIN(EventID) FROM Events WHERE EventID > @event_id AND EventEndTime < @end_date AND EventStartTime < GETDATE();
		END
		-- insert all the positions
		SELECT @term_id = MIN(AcademicYearID) FROM vw_AcademicYears WHERE AcademicYearID > @term_id;
	END
END
GO
CREATE PROCEDURE sp_Sales AS
BEGIN
	DECLARE @expenditure_line_item_id INT, @amount_aval INT, @person_id INT, @quantity_bought INT, @start_date DATE;
	DECLARE @end_date DATE, @sale_date DATE, @recordLocator INT = 89523632, @recievable_id INT;

	DROP TABLE IF EXISTS #Classifications
		CREATE TABLE [#Classifications] (
		  [ClassificationID] INT,
		  [Description] VARCHAR(50),
		  PRIMARY KEY ([ClassificationID])
		);
		INSERT INTO #Classifications VALUES(1, 'Freshman');
		INSERT INTO #Classifications VALUES(2, 'Sophermore');
		INSERT INTO #Classifications VALUES(3, 'Junior');
		INSERT INTO #Classifications VALUES(4, 'Senior');
		INSERT INTO #Classifications VALUES(5, 'Graduate');
		SELECT @expenditure_line_item_id = MIN(ExpenditureLineItemID) FROM ExpenditureLineItems el 
			WHERE LineItemDescription like 'T-Shirt%';
		WHILE @expenditure_line_item_id is not null
		BEGIN
			-- PRINT @expenditure_line_item_id;
			SELECT @start_date = TermStartDate, @end_date = TermEndDate FROM vw_AcademicYears 
				INNER JOIN Expenditures ON AcademicYearID = dbo.fn_LookUpYear(ExpenditureDate)
				INNER JOIN ExpenditureLineItems ON Expenditures.ExpenditureID = ExpenditureLineItems.ExpenditureID
				WHERE ExpenditureLineItemID = @expenditure_line_item_id;
			SELECT @amount_aval = (UnitQuantity * QuantityPerUnit) FROM ExpenditureLineItems
				WHERE LineItemDescription like 'T-Shirt%' AND ExpenditureLineItemID = @expenditure_line_item_id;
			WHILE @amount_aval > 0
			BEGIN
				SELECT top 1 @person_id = PeopleID FROM People WHERE Classification not in (SELECT Description FROM #Classifications) ORDER BY NEWID();
				SET @quantity_bought = FLOOR(rand()*(6-1)+1);
				IF @amount_aval - @quantity_bought >= 0
				BEGIN
					SET @sale_date = DATEADD(DAY, RAND()*Datediff(Day, @start_date, @end_date) ,@start_date);
					INSERT INTO Recievables (PeopleID, AccountID, Description, PaidDate, RecordLocator)
						VALUES(@person_id, 2, 'Sale', @sale_date, @recordLocator);
					SELECT @recievable_id = MAX(RecievableID) FROM Recievables;
					INSERT INTO RecievableLineItems (RecievableID, Item, UnitType, UnitCost, UnitQuantity)
						VALUES(@recievable_id, 'T-Shirt with best Design', 1, 5, @quantity_bought);
					SET @amount_aval -= @quantity_bought;
					SET @recordLocator += 1;
				END
			END
		-- PRINT @amount_aval;
		SELECT @expenditure_line_item_id = MIN(el.ExpenditureLineItemID) FROM ExpenditureLineItems el
			WHERE LineItemDescription like 'T-Shirt%' AND el.ExpenditureLineItemID > @expenditure_line_item_id;
	END
END 
GO
/*********************** INSERT INTO AcademicTerms ***********************/
SET IDENTITY_INSERT AcademicTerms ON;
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(1,'Fall 2018',CAST(N'2018-08-14' AS DATE),CAST(N'2018-12-11' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(2,'Spring 2019',CAST(N'2019-01-06' AS DATE),CAST(N'2019-05-02' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(3,'Summer 2019',CAST(N'2019-05-04' AS DATE),CAST(N'2019-08-14' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(4,'Fall 2019',CAST(N'2019-08-16' AS DATE),CAST(N'2019-12-13' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(5,'Spring 2020',CAST(N'2020-01-10' AS DATE),CAST(N'2020-05-04' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(6,'Summer 2020',CAST(N'2020-05-04' AS DATE),CAST(N'2020-08-14' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(7,'Fall 2020',CAST(N'2020-08-15' AS DATE),CAST(N'2020-12-12' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(8,'Spring 2021',CAST(N'2021-01-08' AS DATE),CAST(N'2021-05-03' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(9,'Summer 2021',CAST(N'2021-05-04' AS DATE),CAST(N'2021-08-14' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(10,'Fall 2021',CAST(N'2021-08-21' AS DATE),CAST(N'2021-12-19' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(11,'Spring 2022',CAST(N'2022-01-07' AS DATE),CAST(N'2022-05-01' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(12,'Summer 2022',CAST(N'2022-05-04' AS DATE),CAST(N'2022-08-14' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(13,'Fall 2022',CAST(N'2022-08-21' AS DATE),CAST(N'2022-12-19' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(14,'Spring 2023',CAST(N'2023-01-07' AS DATE),CAST(N'2023-05-01' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(15,'Summer 2023',CAST(N'2023-05-04' AS DATE),CAST(N'2023-08-14' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(16,'Fall 2023',CAST(N'2023-08-21' AS DATE),CAST(N'2023-12-19' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(17,'Spring 2024',CAST(N'2024-01-07' AS DATE),CAST(N'2024-05-01' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(18,'Summer 2024',CAST(N'2024-05-04' AS DATE),CAST(N'2024-08-14' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(19,'Fall 2024',CAST(N'2024-08-21' AS DATE),CAST(N'2024-12-19' AS DATE));
INSERT INTO AcademicTerms(AcademicTermID, AcademicTerm, TermStartDate, TermEndDate) VALUES(20,'Spring 2025',CAST(N'2025-01-07' AS DATE),CAST(N'2025-05-01' AS DATE));
SET IDENTITY_INSERT AcademicTerms OFF;
GO
/*********************** INSERT INTO AcademicTerms ***********************/
SET IDENTITY_INSERT AccountingAccounts ON;
INSERT INTO AccountingAccounts(AccountingID, AccountDescription, RoutingNumber, AccountNumber) VALUES(1, 'OUR Expenditures - Money we spend', 'ABCDEF123', 'ABCDEF123456');
INSERT INTO AccountingAccounts(AccountingID, AccountDescription, RoutingNumber, AccountNumber) VALUES(4, 'StudentLife Incoming - Money we have to spend by the END of year', 'GHIJKL789', 'GHIJKL789101');
INSERT INTO AccountingAccounts(AccountingID, AccountDescription, RoutingNumber, AccountNumber) VALUES(3, 'StudentLife OutGOing - Money we cannot lose anymore', 'MNOPQR213', 'MNOPQR213141');
INSERT INTO AccountingAccounts(AccountingID, AccountDescription, RoutingNumber, AccountNumber) VALUES(2, 'OUR INCOME- Money we get to keep', 'STUVWX516', 'STUVWX516171');
SET IDENTITY_INSERT AccountingAccounts OFF;
GO
/*********************** INSERT INTO Locations ***********************/
SET IDENTITY_INSERT Locations ON;
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(1, 'Library 241', 'The Library computer lab at USCB Bluffton campus', 'Library', '241', '1 University Blvd', 'NULL', 'Bluffton', 'SC', '29909');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(2, 'Hargray 162', 'The Hargray building computer lab at USCB Bluffton campus', 'Hargray', '162', '1 University Blvd', 'NULL', 'Bluffton', 'SC', '29909');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(3, 'Scitech 231', 'The Scitech building computer lab at USCB Bluffton campus', 'Scitech', '231', '1 University Blvd', 'NULL', 'Bluffton', 'SC', '29909');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(4, 'Library 267', 'A large, tiered classroom in the USCB Bluffton Campus Library', 'Library', '267', '1 University Blvd', 'NULL', 'Bluffton', 'SC', '29909');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(5, 'Makerspace', 'The Makerspace ON the USCB Bluffton campus', 'Library', 'NULL', '1 University Blvd', 'NULL', 'Bluffton', 'SC', '29909');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(6, 'CC 105', 'A large, open event room ON the USCB Bluffton campus', 'Campus Center', '105', '1 University Blvd', 'NULL', 'Bluffton', 'SC', '29909');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(7, 'CC 106', 'A large, segmented event room ON the USCB Bluffton campus', 'Campus Center', '106', '1 University Blvd', 'NULL', 'Bluffton', 'SC', '29909');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(8, 'CC Firepit', 'An open outdoor area with a firepit next to Campus Center ON the USCB Bluffton campus', 'NULL', 'NULL', '1 University Blvd', 'NULL', 'Bluffton', 'SC', '29909');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(9, 'CFA Auditorium', 'USCB Center for the Arts Auditorium ON the Beaufort campus', 'Center for the Arts', 'NULL', '801 Carteret Street', 'NULL', 'Beaufort', 'SC', '29902');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(10, 'USC Columbia', 'The location of the USC STEM Fair in USC Columbia', 'Carolina Coliseum', 'NULL', '701 Assembly Street', 'NULL', 'Columbia', 'SC', '29201');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(11, 'Boeing Campus', 'The closest Boeing Facility they allow us to tour', 'NULL', 'NULL', '5400 Airframe Dr ', 'NULL', 'North Charleston', 'SC', '29418');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(12, 'Gulfstream Campus', 'The closest Gulfstream Facility they allow us to tour', 'NULL', 'NULL', '500 Gulfstream Rd', 'NULL', 'Savannah', 'GA', '31408');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(13, 'Your Closet', 'Hiding', 'NULL', 'NULL', 'Your Address', 'NULL', 'Where You Reside', 'SC', '12345');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(14, 'The Evil Shop', 'At the evil shop doing evil things, you wouldn''t get it', 'NULL', 'NULL', 'Eeeevil Street', 'NULL', 'The Most Evil Place', 'SC', '99999');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(15, 'Other', 'A place that is either not ON the list or not a place at all, choose your own adventure!', 'NULL', 'NULL', 'Not Sure', 'NULL', 'You Tell Me', 'SC', '10101');
INSERT INTO Locations(LocationID, Name, Description, Building, Room, Address1, Address2, City, State, ZipCode) VALUES(16, 'Ritz Carlton', 'A fancy place to store our Shourish', 'NULL', 'NULL', '50 Central Park S', 'NULL', 'New York', 'NY', '10019');
SET IDENTITY_INSERT Locations OFF;
GO
/*********************** INSERT INTO Events ***********************/
SET IDENTITY_INSERT Events ON;
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(67,NULL,'END of the Year Party ','A party hosted ON the last Friday of the semester celebrating the academic year, our members, and all our supporters at ACM','2024-04-19 11:00AM','2024-04-19 2:00PM',8);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(66,NULL,'GulfStream RecruitMent ','A recruitment event hosted at USCB for members to learn more about Gulfstream as a company and what opportunities exist there', NULL,NULL,12);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(65,NULL,'Chess TournaMent ','A chess tournament hosted in partnership with USCB Athletics','2024-03-15 3:00PM','2024-03-15 5:00PM',9);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(64,NULL,'SandShark Game Jam','A game jam hosted over spring break for students to make teams or compete individually and make games within competeition guidelines','2024-03-02 12:00AM ','2024-03-09 6:00PM ',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(63,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2024-02-15 10:00AM','2024-02-15 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(62,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2024-02-07 4:00 PM','2024-02-07 6:00 PM',3);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(61,NULL,'T-Shirt Design Contest ','A submission based contest to submit member-designed loGOs for that academic year''s ACM USCB shirts','2024-02-05 12:00AM','2024-02-09 11:59PM',13);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(60,NULL,'3D PRINTing WorkShop','An event WHERE we 3-D PRINT stuff at the MakerSpace','2023-10-18 5:00PM','2023-10-18 8:00PM',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(59,NULL,'USCB ACM Game Night','An event WHERE various game themes are played such as some game nights being VR themed, board game themed, or video game themed','2023-10-13 5:00PM','2023-10-13 8:00PM',6);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(58,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2023-09-27 12:00PM','2023-09-27 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(57,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2023-09-15 5:00PM','2023-09-15 6:00PM',2);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(56,NULL,'ACM Discovery Party','A party to introduce Computer Science, Information Science, and Math students to their faculty and other students in the major with games, food, and other activities','2023-09-06 6:00PM','2023-09-06 6:00PM',1);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(55,NULL,'END of the Year Party ','A party hosted ON the last Friday of the semester celebrating the academic year, our members, and all our supporters at ACM','2023-04-19 11:00AM','2023-04-19 2:00PM',8);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(54,NULL,'GulfStream RecruitMent ','A recruitment event hosted at USCB for members to learn more about Gulfstream as a company and what opportunities exist there','2023-03-14 1:00 PM','2023-03-14 3:00 PM',12);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(53,NULL,'SandShark Game Jam','A game jam hosted over spring break for students to make teams or compete individually and make games within competeition guidelines','2023-03-02 12:00AM ','2023-03-09 6:00PM ',6);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(52,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2023-02-15 10:00AM','2023-02-15 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(51,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2023-02-10 4:00PM','2023-02-10 6:00PM',3);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(50,NULL,'T-Shirt Design Contest ','A submission based contest to submit member-designed loGOs for that academic year''s ACM USCB shirts','2023-02-05 12:00AM','2023-02-09 11:59PM',13);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(49,NULL,'3D PRINTing WorkShop','An event WHERE we 3-D PRINT stuff at the MakerSpace','2022-10-18 5:00PM','2022-10-18 8:00PM',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(48,NULL,'USCB ACM Game Night','An event WHERE various game themes are played such as some game nights being VR themed, board game themed, or video game themed','2022-10-13 5:00PM','2022-10-13 8:00PM',6);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(47,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2022-09-27 12:00PM','2022-09-27 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(46,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2022-09-15 5:00PM','2022-09-15 6:00PM',2);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(45,NULL,'ACM Discovery Party','A party to introduce Computer Science, Information Science, and Math students to their faculty and other students in the major with games, food, and other activities','2022-09-06 6:00PM','2022-09-06 6:00PM',1);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(44,NULL,'END of the Year Party ','A party hosted ON the last Friday of the semester celebrating the academic year, our members, and all our supporters at ACM','2022-04-19 11:00AM','2022-04-19 2:00PM',6);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(43,NULL,'GulfStream RecruitMent ','A recruitment event hosted at USCB for members to learn more about Gulfstream as a company and what opportunities exist there','2022-03-14 1:00 PM','2022-03-14 3:00 PM',12);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(42,NULL,'SandShark Game Jam','A game jam hosted over spring break for students to make teams or compete individually and make games within competeition guidelines','2022-03-02 12:00AM ','2022-03-09 6:00PM ',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(41,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2022-02-15 10:00AM','2022-02-15 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(40,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2022-02-07 4:00 PM','2022-02-07 6:00 PM',3);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(39,NULL,'T-Shirt Design Contest ','A submission based contest to submit member-designed loGOs for that academic year''s ACM USCB shirts','2022-02-05 12:00AM','2022-02-09 11:59PM',13);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(38,NULL,'3D PRINTing WorkShop','An event WHERE we 3-D PRINT stuff at the MakerSpace','2021-10-18 5:00PM','2021-10-18 8:00PM',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(37,NULL,'USCB ACM Game Night','An event WHERE various game themes are played such as some game nights being VR themed, board game themed, or video game themed','2021-10-13 5:00PM','2021-10-13 8:00PM',6);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(36,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2021-09-27 12:00PM','2021-09-27 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(35,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2021-09-15 5:00PM','2021-09-15 6:00PM',2);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(34,NULL,'ACM Discovery Party','A party to introduce Computer Science, Information Science, and Math students to their faculty and other students in the major with games, food, and other activities','2021-09-06 6:00PM','2021-09-06 6:00PM',1);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(33,NULL,'END of the Year Party ','A party hosted ON the last Friday of the semester celebrating the academic year, our members, and all our supporters at ACM','2021-04-19 11:00AM','2021-04-19 2:00PM',8);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(32,NULL,'GulfStream RecruitMent ','A recruitment event hosted at USCB for members to learn more about Gulfstream as a company and what opportunities exist there','2021-03-14 1:00 PM','2021-03-14 3:00 PM',12);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(31,NULL,'SandShark Game Jam','A game jam hosted over spring break for students to make teams or compete individually and make games within competeition guidelines','2021-03-02 12:00AM ','2021-03-09 6:00PM ',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(30,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2021-02-15 10:00AM','2021-02-15 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(29,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2021-02-07 4:00 PM','2021-02-07 6:00 PM',3);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(28,NULL,'T-Shirt Design Contest ','A submission based contest to submit member-designed loGOs for that academic year''s ACM USCB shirts','2021-02-05 12:00AM','2021-02-09 11:59PM',13);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(27,NULL,'3D PRINTing WorkShop','An event WHERE we 3-D PRINT stuff at the MakerSpace','2020-10-18 5:00PM','2020-10-18 8:00PM',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(26,NULL,'USCB ACM Game Night','An event WHERE various game themes are played such as some game nights being VR themed, board game themed, or video game themed','2020-10-13 5:00PM','2020-10-13 8:00PM',6);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(25,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2020-09-27 12:00PM','2020-09-27 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(24,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2020-09-15 5:00PM','2020-09-15 6:00PM',2);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(23,NULL,'ACM Discovery Party','A party to introduce Computer Science, Information Science, and Math students to their faculty and other students in the major with games, food, and other activities','2020-09-06 6:00PM','2020-09-06 6:00PM',1);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(22,NULL,'END of the Year Party ','A party hosted ON the last Friday of the semester celebrating the academic year, our members, and all our supporters at ACM','2020-04-19 11:00AM','2020-04-19 2:00PM',8);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(21,NULL,'GulfStream RecruitMent ','A recruitment event hosted at USCB for members to learn more about Gulfstream as a company and what opportunities exist there','2020-03-14 1:00 PM','2020-03-14 3:00 PM',12);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(20,NULL,'SandShark Game Jam','A game jam hosted over spring break for students to make teams or compete individually and make games within competeition guidelines','2020-03-02 12:00AM ','2020-03-09 6:00PM ',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(19,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2020-02-15 10:00AM','2020-02-15 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(18,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2020-02-07 4:00 PM','2020-02-07 6:00 PM',3);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(17,NULL,'T-Shirt Design Contest ','A submission based contest to submit member-designed loGOs for that academic year''s ACM USCB shirts','2020-02-05 12:00AM','2020-02-09 11:59PM',13);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(16,NULL,'3D PRINTing WorkShop','An event WHERE we 3-D PRINT stuff at the MakerSpace','2019-10-18 5:00PM','2019-10-18 8:00PM',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(15,NULL,'USCB ACM Game Night','An event WHERE various game themes are played such as some game nights being VR themed, board game themed, or video game themed','2019-10-13 5:00PM','2019-10-13 8:00PM',6);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(14,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2019-09-27 12:00PM','2019-09-27 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(13,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2019-09-15 5:00PM','2019-09-15 6:00PM',2);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(12,NULL,'ACM Discovery Party','A party to introduce Computer Science, Information Science, and Math students to their faculty and other students in the major with games, food, and other activities','2019-09-06 6:00PM','2019-09-06 6:00PM',1);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(11,NULL,'END of the Year Party ','A party hosted ON the last Friday of the semester celebrating the academic year, our members, and all our supporters at ACM','2019-04-19 11:00AM','2019-04-19 2:00PM',8);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(10,NULL,'GulfStream RecruitMent ','A recruitment event hosted at USCB for members to learn more about Gulfstream as a company and what opportunities exist there','2019-03-14 1:00 PM','2019-03-14 3:00 PM',12);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(9,NULL,'SandShark Game Jam','A game jam hosted over spring break for students to make teams or compete individually and make games within competeition guidelines','2019-03-02 12:00AM ','2019-03-09 6:00PM ',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(8,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2019-02-15 10:00AM','2019-02-15 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(7,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2019-02-07 4:00 PM','2019-02-07 6:00 PM',3);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(6,NULL,'T-Shirt Design Contest ','A submission based contest to submit member-designed loGOs for that academic year''s ACM USCB shirts','2019-02-05 12:00AM','2019-02-09 11:59PM',13);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(5,NULL,'3D PRINTing WorkShop','An event WHERE we 3-D PRINT stuff at the MakerSpace','2018-10-18 5:00PM','2018-10-18 8:00PM',5);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(4,NULL,'USCB ACM Game Night','An event WHERE various game themes are played such as some game nights being VR themed, board game themed, or video game themed','2018-10-13 5:00PM','2018-10-13 8:00PM',6);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(3,NULL,'STEM Career Fair','Either a van or carpools arranged to take ACM members to the USC STEM Career fair at USC in Columbia','2018-09-27 12:00PM','2018-09-27 4:00PM',10);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(2,NULL,'Resume Workshop','A workshop to help our members learn how to structure a resume, get peer review, and factuly and staff review ON their resumes','2018-09-15 5:00PM','2018-09-15 6:00PM',2);
INSERT INTO Events(EventID, OfficerID, EventName, Description, EventStartTime, EventEndTime, LocationID) VALUES(1,NULL,'ACM Discovery Party','A party to introduce Computer Science, Information Science, and Math students to their faculty and other students in the major with games, food, and other activities','2018-09-06 6:00PM','2018-09-06 6:00PM',1);
SET IDENTITY_INSERT Events OFF;
GO
/*********************** INSERT INTO People ***********************/
SET IDENTITY_INSERT People ON;
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(1, 'Adam', 'Ashingden', 'aashingdent@aboutads.info', '1326150', 'Alumni', 'I57777582', '2018-09-02', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(2, 'Antons', 'Ceney', 'aceney2v@aol.com', '6842699', 'Alumni', 'S33491847', '2018-09-20', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(3, 'Augie', 'Woodeson', 'awoodeson35@hud.GOv', '0233112', 'Alumni', 'X62697026', '2018-09-20', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(4, 'Mirella', 'Collyns', 'mcollyns48@newyorker.com', '4192272', 'Alumni', 'E30735009', '2018-10-01', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(5, 'Denys', 'Yewdale', 'dyewdale4s@istockphoto.com', '8098053', 'Alumni', 'K04141570', '2018-10-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(6, 'Fallon', 'Shaddock', 'fshaddock1i@sakura.ne.jp', '0698537', 'Alumni', 'U22652408', '2018-10-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(7, 'Georgiana', 'Newton', 'gnewton5a@amazon.co.uk', '7350815', 'Alumni', 'P47221509', '2018-10-22', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(8, 'Ysabel', 'Passo', 'ypasso3t@diiGO.com', '2971715', 'Alumni', 'E42970963', '2018-10-25', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(9, 'Winonah', 'Channing', 'wchanning6h@mozilla.com', '0515202', 'Alumni', 'E14901483', '2018-10-29', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(10, 'Phylis', 'Fillery', 'pfillery2y@newsvine.com', '3547643', 'Alumni', 'C69153673', '2018-11-03', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(11, 'Verna', 'Aviss', 'vaviss72@zimbio.com', '8262431', 'Alumni', 'K70215986', '2018-11-05', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(12, 'Giorgio', 'Helversen', 'ghelversen75@people.com.cn', '0306977', 'Alumni', 'G78428142', '2018-11-10', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(13, 'GOthart', 'Maunsell', 'gmaunsell7s@chicaGOtribune.com', '4995450', 'Alumni', 'O69271503', '2018-11-22', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(14, 'Cherianne', 'Dreinan', 'cdreinan29@gizmodo.com', '7343277', 'Alumni', 'L86740752', '2018-11-24', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(15, 'Greta', 'Aylwin', 'gaylwinj@yellowbook.com', '0611802', 'Alumni', 'H29048996', '2018-11-28', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(16, 'Tessi', 'Perse', 'tperse4p@phoca.cz', '5076544', 'Alumni', 'S60309399', '2018-12-07', 'Boeing');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(17, 'Cole', 'Bulger', 'cbulger2t@nyu.edu', '9861388', 'Alumni', 'K42104823', '2018-12-16', 'Blue Cross');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(18, 'Norrie', 'Arnaudet', 'narnaudet2u@thetimes.co.uk', '0846148', 'Alumni', 'P32824145', '2018-12-30', 'Blue Cross');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(19, 'Mella', 'Bocken', 'mbocken6y@odnoklassniki.ru', '3545484', 'Alumni', 'N29711845', '2019-01-01', 'Blue Cross');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(20, 'Garvin', 'Circuit', 'gcircuiti@linkedin.com', '7336698', 'Alumni', 'F34064435', '2019-01-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(21, 'Bartie', 'Screwton', 'bscrewton5q@vkontakte.ru', '0452480', 'Alumni', 'U44713600', '2019-01-05', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(22, 'Saudra', 'Gibbetts', 'sgibbetts4h@GOogle.ru', '7857850', 'Alumni', 'U46722500', '2019-01-13', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(23, 'Rory', 'Leivesley', 'rleivesley3h@sitemeter.com', '1471969', 'Alumni', 'A57664670', '2019-01-25', 'Blue Cross');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(24, 'Gabriel', 'Romagnosi', 'gromagnosi17@reference.com', '4178276', 'Alumni', 'H22421088', '2019-01-26', 'Blue Cross');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(25, 'Rozina', 'Gwilliams', 'rgwilliams37@ebay.co.uk', '1116519', 'Alumni', 'D26544194', '2019-02-03', 'Blue Cross');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(26, 'Kassey', 'Dawnay', 'kdawnaya@github.com', '0094630', 'Alumni', 'Q53381280', '2019-02-11', 'Blue Cross');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(27, 'Kean', 'Perse', 'kperse3i@indiatimes.com', '6325092', 'Alumni', 'H25348011', '2019-02-27', 'Blue Cross');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(28, 'Denna', 'Kiebes', 'dkiebes44@yahoo.com', '0051250', 'Alumni', 'W72565048', '2019-03-07', 'Salesforce');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(29, 'Steward', 'Guilloux', 'sguilloux6b@eventbrite.com', '1419517', 'Alumni', 'X55774242', '2019-03-19', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(30, 'Amos', 'Dimberline', 'adimberline5z@sciencedirect.com', '7644748', 'Alumni', 'O46201539', '2019-03-20', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(31, 'Winna', 'McShane', 'wmcshane30@ocn.ne.jp', '2611220', 'Alumni', 'M04778974', '2019-03-21', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(32, 'Bevvy', 'Cunah', 'bcunah49@nifty.com', '2138104', 'Alumni', 'Q06836441', '2019-04-08', 'Salesforce');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(33, 'Christyna', 'Monkton', 'cmonktonr@squidoo.com', '4000748', 'Alumni', 'Y35392952', '2019-04-16', 'Salesforce');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(34, 'Kristoforo', 'Hellmore', 'khellmore3k@toplist.cz', '6395201', 'Alumni', 'H80891103', '2019-04-18', 'Salesforce');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(35, 'Tatiana', 'Pirozzi', 'tpirozzi20@engadget.com', '1840365', 'Alumni', 'V86835504', '2019-04-20', 'Salesforce');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(36, 'Ulberto', 'Woffinden', 'uwoffinden43@wiley.com', '2489580', 'Alumni', 'D07773799', '2019-04-25', 'Salesforce');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(37, 'Gabey', 'Antczak', 'gantczak7c@sina.com.cn', '2667739', 'Alumni', 'Z81602271', '2019-04-29', 'Salesforce');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(38, 'Keeley', 'Conahy', 'kconahy2d@tinypic.com', '3686256', 'Alumni', 'Y52025639', '2019-05-02', 'GOogle');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(39, 'Skye', 'Grunnell', 'sgrunnell41@va.GOv', '9314625', 'Alumni', 'Q39331967', '2019-05-07', 'GOogle');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(40, 'Emmery', 'Depport', 'edepport4x@usa.GOv', '3229837', 'Alumni', 'V67110360', '2019-05-07', 'GOogle');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(41, 'Ransom', 'Tipens', 'rtipens6r@GOogle.com.au', '4415609', 'Alumni', 'M09084835', '2019-05-21', 'GOogle');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(42, 'Adamo', 'Pyne', 'apyne4w@foxnews.com', '2801794', 'Alumni', 'V60976388', '2019-05-30', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(43, 'Elisabet', 'La Vigne', 'elavigne5p@freewebs.com', '2903597', 'Alumni', 'R28828313', '2019-06-09', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(44, 'Reinwald', 'Dreamer', 'rdreamer2c@yahoo.com', '7097070', 'Alumni', 'F04143301', '2019-06-16', 'GOogle');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(45, 'Welsh', 'Connolly', 'wconnolly3f@carGOcollective.com', '2925502', 'Alumni', 'H34376417', '2019-06-19', 'GOogle');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(46, 'Jany', 'Commucci', 'jcommucci6q@redcross.org', '6864777', 'Alumni', 'M72844373', '2019-06-25', 'GOogle');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(47, 'Melodie', 'Pickthorne', 'mpickthorne3b@engadget.com', '4367104', 'Alumni', 'A10789697', '2019-06-29', 'GOogle');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(48, 'Dania', 'Vonderdell', 'dvonderdell59@daGOndesign.com', '3288222', 'Alumni', 'Q73444060', '2019-07-08', 'Facebook');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(49, 'Kira', 'Dyster', 'kdyster5n@wikimedia.org', '6024380', 'Alumni', 'F39796783', '2019-07-11', 'Facebook');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(50, 'Whitney', 'Fidge', 'wfidge2b@webmd.com', '4305359', 'Alumni', 'Q94873830', '2019-07-18', 'Facebook');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(51, 'Karola', 'Valentim', 'kvalentim57@eepurl.com', '0328575', 'Alumni', 'S40319347', '2019-07-21', 'Facebook');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(52, 'Marcelle', 'Stolberger', 'mstolberger1j@php.net', '3032910', 'Alumni', 'X10410127', '2019-07-23', 'Facebook');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(53, 'Alverta', 'Trewhela', 'atrewhela1m@myspace.com', '8388173', 'Alumni', 'Y10776388', '2019-07-24', 'Facebook');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(54, 'Reiko', 'Beenham', 'rbeenham1f@sina.com.cn', '7086814', 'Alumni', 'B86422554', '2019-07-31', 'Amazon');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(55, 'Marshal', 'Cardow', 'mcardow4@amazonaws.com', '2399388', 'Alumni', 'R00256473', '2019-08-18', 'Amazon');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(56, 'Josefa', 'Geertsen', 'jgeertsen14@odnoklassniki.ru', '3882784', 'Alumni', 'K56451263', '2019-08-25', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(57, 'Kalli', 'Bollam', 'kbollam7i@storify.com', '4147026', 'Alumni', 'D15274011', '2019-08-28', 'Apple');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(58, 'Leoine', 'Boosey', 'lboosey8@ebay.com', '9649058', 'Alumni', 'N41346482', '2019-09-06', 'Apple');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(59, 'Velvet', 'Alenshev', 'valenshev26@oaic.GOv.au', '8805870', 'Alumni', 'P58239663', '2019-09-19', 'Apple');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(60, 'Kenneth', 'Burditt', 'kburditt79@walmart.com', '3857705', 'Graduate', 'R61482618', '2019-10-01', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(61, 'Trula', 'Henricsson', 'thenricsson3a@webnode.com', '5528942', 'Graduate', 'X68079930', '2019-10-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(62, 'Lazare', 'Thurlow', 'lthurlow86@istockphoto.com', '5949303', 'Graduate', 'Z36167094', '2019-10-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(63, 'Emmalee', 'Webb-Bowen', 'ewebbbowen4c@skype.com', '0766636', 'Graduate', 'G77019661', '2019-10-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(64, 'Basil', 'Limerick', 'blimerick45@bluehost.com', '9322276', 'Graduate', 'I87379265', '2019-10-19', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(65, 'Wilton', 'Tweedle', 'wtweedle5s@ibm.com', '8132526', 'Graduate', 'E88000689', '2019-10-21', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(66, 'Sarine', 'Kleinhaus', 'skleinhaus5u@qq.com', '5092584', 'Graduate', 'P92244515', '2019-11-01', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(67, 'Jarred', 'Nevet', 'jnevet1z@pinterest.com', '2402884', 'Graduate', 'T14305059', '2019-11-08', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(68, 'Cassondra', 'Della', 'cdella25@so-net.ne.jp', '0826403', 'Graduate', 'K83161631', '2019-11-08', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(69, 'Constantine', 'Egarr', 'cegarr1g@jiathis.com', '5998018', 'Graduate', 'B22860830', '2019-11-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(70, 'Rowland', 'MacPake', 'rmacpake50@ovh.net', '6640835', 'Graduate', 'R81161252', '2019-11-13', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(71, 'Ashby', 'Tindley', 'atindley2k@comsenz.com', '8657985', 'Graduate', 'C35355570', '2019-12-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(72, 'Katrina', 'Elvin', 'kelvin6g@netscape.com', '4703361', 'Graduate', 'L79686687', '2019-12-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(73, 'Tabb', 'Tureville', 'ttureville6n@cnbc.com', '3789219', 'Graduate', 'K08867975', '2019-12-21', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(74, 'Domini', 'Sheridan', 'dsheridan1v@wordpress.org', '4091846', 'Graduate', 'R63646900', '2019-12-23', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(75, 'Darius', 'Houdmont', 'dhoudmont6d@e-recht24.de', '0769610', 'Graduate', 'M10934207', '2019-12-31', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(76, 'Benedikta', 'Ghione', 'bghione4b@youtube.com', '7364822', 'Senior', 'A97253735', '2020-01-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(77, 'Gwenora', 'Franciskiewicz', 'gfranciskiewicz76@hc360.com', '7773292', 'Senior', 'E64724417', '2020-01-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(78, 'Agneta', 'Muirhead', 'amuirheadw@cbsnews.com', '0472092', 'Senior', 'G32866917', '2020-01-14', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(79, 'Fanny', 'Firpo', 'ffirpo6m@accuweather.com', '9214138', 'Senior', 'X32628221', '2020-01-14', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(80, 'Erminia', 'Barkas', 'ebarkas88@fastcompany.com', '5808954', 'Senior', 'K52008634', '2020-01-17', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(81, 'Aubine', 'Harfleet', 'aharfleet60@bandcamp.com', '4119662', 'Senior', 'Q25820861', '2020-01-20', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(82, 'Ky', 'Puddan', 'kpuddan83@hubpages.com', '5302855', 'Senior', 'B50727369', '2020-01-22', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(83, 'Rriocard', 'Proudman', 'rproudman5l@sun.com', '7971021', 'Senior', 'A05377594', '2020-02-07', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(84, 'Bondy', 'Corfield', 'bcorfield3u@privacy.GOv.au', '9053804', 'Senior', 'I47961172', '2020-03-04', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(85, 'Cathi', 'Woolatt', 'cwoolatt2w@GOogle.nl', '3400930', 'Senior', 'M39012230', '2020-03-05', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(86, 'Tristan', 'Trembley', 'ttrembley4y@elpais.com', '2060269', 'Senior', 'G39020926', '2020-03-07', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(87, 'Jamal', 'Yantsurev', 'jyantsurev3r@prnewswire.com', '6579989', 'Senior', 'W13109384', '2020-03-29', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(88, 'Mordecai', 'Rayburn', 'mrayburn1d@mozilla.com', '7569341', 'Senior', 'M86834969', '2020-04-01', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(89, 'Janessa', 'Glencross', 'jglencross4e@nbcnews.com', '3392335', 'Senior', 'X26850370', '2020-04-08', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(90, 'Gradey', 'Ingerfield', 'gingerfield3c@rakuten.co.jp', '6247122', 'Senior', 'A15330175', '2020-04-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(91, 'Caresse', 'Sanson', 'csanson4m@forbes.com', '1078399', 'Senior', 'Z21145475', '2020-04-23', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(92, 'Benny', 'Benz', 'bbenz1l@alexa.com', '9019084', 'Senior', 'J63546991', '2020-04-23', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(93, 'Britt', 'Wiffler', 'bwiffler2q@youtu.be', '1256835', 'Senior', 'F61377257', '2020-04-29', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(94, 'Candy', 'Fuzzens', 'cfuzzens1@yahoo.com', '5689032', 'Senior', 'S65653818', '2020-05-07', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(95, 'Kathryne', 'Rushby', 'krushby11@blinklist.com', '5567986', 'Senior', 'S27890771', '2020-05-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(96, 'Trescha', 'Comins', 'tcomins33@fotki.com', '5871151', 'Senior', 'T29967825', '2020-05-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(97, 'Launce', 'Jammet', 'ljammet3m@toplist.cz', '6049562', 'Senior', 'V16892937', '2020-05-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(98, 'Jim', 'Ellerker', 'jellerker7x@purevolume.com', '8616679', 'Senior', 'I64470463', '2020-05-19', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(99, 'Lee', 'MacCaughen', 'lmaccaughen36@GOodreads.com', '0355654', 'Senior', 'S84165138', '2020-05-26', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(100, 'Ruthanne', 'Bolsteridge', 'rbolsteridge7n@usgs.GOv', '4066960', 'Senior', 'P33725108', '2020-06-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(101, 'Alexis', 'Faithfull', 'afaithfull1k@unc.edu', '0393518', 'Senior', 'O84877129', '2020-06-16', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(102, 'Roman', 'Tooby', 'rtooby2x@fotki.com', '1360630', 'Senior', 'F05686515', '2020-06-21', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(103, 'Estele', 'M''Chirrie', 'emchirrie7k@examiner.com', '0848209', 'Senior', 'V64715141', '2020-06-22', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(104, 'Jedediah', 'Holstein', 'jholstein24@homestead.com', '6754019', 'Senior', 'J25618923', '2020-06-24', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(105, 'Sig', 'Smurfitt', 'ssmurfitt7@ning.com', '5172040', 'Senior', 'X72860165', '2020-06-29', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(106, 'Katinka', 'Gercken', 'kgercken6@microsoft.com', '9368649', 'Senior', 'U62744504', '2020-06-30', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(107, 'Stearn', 'Jankin', 'sjankin19@dell.com', '0456244', 'Senior', 'Q00691112', '2020-07-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(108, 'Broderick', 'Coburn', 'bcoburn78@wisc.edu', '1984255', 'Senior', 'U89725104', '2020-07-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(109, 'Marieann', 'Klausewitz', 'mklausewitz2a@GOogle.co.uk', '8725225', 'Senior', 'C85025962', '2020-07-25', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(110, 'Buddy', 'Lobbe', 'blobbe2s@tinyurl.com', '5423107', 'Senior', 'Z59970660', '2020-07-31', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(111, 'Ainslie', 'Sambrok', 'asambrok7p@archive.org', '7807874', 'Senior', 'Q52427790', '2020-08-01', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(112, 'Leia', 'Christie', 'lchristie3g@bbc.co.uk', '1348010', 'Senior', 'E27767670', '2020-08-13', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(113, 'Isadora', 'Bysh', 'ibysh82@nydailynews.com', '7757963', 'Senior', 'S10193488', '2020-08-24', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(114, 'Noami', 'McKeller', 'nmckeller3e@tuttocitta.it', '1956896', 'Senior', 'F34024747', '2020-08-31', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(115, 'Siobhan', 'Buzek', 'sbuzek5i@whitehouse.GOv', '7751323', 'Senior', 'O04037576', '2020-09-01', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(116, 'Kerry', 'Dresse', 'kdressel@washington.edu', '7860040', 'Senior', 'C49121655', '2020-09-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(117, 'Faber', 'Reeves', 'freeves6a@uol.com.br', '2277538', 'Senior', 'H91675395', '2020-09-07', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(118, 'Ivett', 'Guiett', 'iguiett80@feedburner.com', '9725478', 'Senior', 'A27172716', '2020-09-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(119, 'Nollie', 'MacRedmond', 'nmacredmond15@ft.com', '3339936', 'Senior', 'Q57566358', '2020-09-23', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(120, 'Jodi', 'Espinosa', 'jespinosa4n@macromedia.com', '8908381', 'Senior', 'P27048294', '2020-10-24', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(121, 'Gian', 'De Vaux', 'gdevaux6f@GOo.ne.jp', '3170328', 'Senior', 'P40273200', '2020-10-27', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(122, 'Hurlee', 'Hamshar', 'hhamshar53@chronoengine.com', '8668371', 'Senior', 'Z74370195', '2020-10-28', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(123, 'Nariko', 'Khosa', 'nkhosa5k@mac.com', '2948176', 'Senior', 'B13080174', '2020-11-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(124, 'Dun', 'Stolle', 'dstollee@bizjournals.com', '2198485', 'Senior', 'F51341087', '2020-11-25', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(125, 'Rafael', 'Soans', 'rsoans3@cpanel.net', '4839044', 'Senior', 'U89624918', '2020-12-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(126, 'Shellysheldon', 'Gillford', 'sgillford4k@adobe.com', '4051134', 'Senior', 'V54176136', '2020-12-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(127, 'Christoforo', 'Somes', 'csomesf@4shared.com', '9741485', 'Senior', 'M83710109', '2020-12-17', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(128, 'Brittney', 'McGrorty', 'bmcgrorty8a@chron.com', '8658058', 'Senior', 'R69848747', '2020-12-30', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(129, 'Sven', 'Delgardillo', 'sdelgardillo7t@free.fr', '1696940', 'Junior', 'Q54411267', '2021-01-04', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(130, 'Blondy', 'Comford', 'bcomford74@ucla.edu', '3163595', 'Junior', 'G47210517', '2021-01-07', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(131, 'Benton', 'Rennard', 'brennard70@hatena.ne.jp', '5067264', 'Junior', 'M21384328', '2021-01-17', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(132, 'Bank', 'Japp', 'bjapp68@icq.com', '0639226', 'Junior', 'R60024752', '2021-02-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(133, 'Jacklin', 'Ensor', 'jensor4q@dion.ne.jp', '7244749', 'Junior', 'K66274155', '2021-02-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(134, 'Donavon', 'Hedaux', 'dhedauxd@yellowpages.com', '9717529', 'Junior', 'N20862081', '2021-02-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(135, 'Walliw', 'Barwack', 'wbarwackm@last.fm', '5096063', 'Junior', 'C01253374', '2021-03-19', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(136, 'Veronike', 'Gabe', 'vgabev@zdnet.com', '9281660', 'Junior', 'K90578652', '2021-03-23', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(137, 'Oran', 'Iddins', 'oiddinsh@geocities.com', '4787047', 'Junior', 'R53825514', '2021-04-01', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(138, 'Ginevra', 'Varga', 'gvarga18@state.GOv', '2720392', 'Junior', 'A36685796', '2021-04-23', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(139, 'Vassily', 'Adams', 'vadams7u@weather.com', '7358578', 'Junior', 'J56929033', '2021-04-28', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(140, 'Paige', 'Symones', 'psymones3y@forbes.com', '1145175', 'Junior', 'T62662003', '2021-04-28', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(141, 'Toby', 'Sturridge', 'tsturridge3q@toplist.cz', '3398005', 'Junior', 'V82821032', '2021-04-30', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(142, 'Dwain', 'Labrom', 'dlabromo@ning.com', '2677935', 'Junior', 'Z79381334', '2021-05-01', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(143, 'Sib', 'Ever', 'sever1q@hexun.com', '8178558', 'Junior', 'N43274940', '2021-06-04', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(144, 'Marleah', 'Inkin', 'minkin51@GOdaddy.com', '7729122', 'Junior', 'W57817990', '2021-06-09', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(145, 'Charil', 'Tapping', 'ctapping7w@theguardian.com', '1214545', 'Junior', 'D92767617', '2021-06-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(146, 'Ermengarde', 'Buswell', 'ebuswell6o@comcast.net', '9577097', 'Junior', 'A58562680', '2021-06-20', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(147, 'Tatiana', 'Bewsy', 'tbewsy6e@ted.com', '0272589', 'Junior', 'M92350470', '2021-07-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(148, 'Giacobo', 'Mansbridge', 'gmansbridge6v@nasa.GOv', '2605527', 'Junior', 'E14951085', '2021-08-15', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(149, 'Ines', 'Cambridge', 'icambridge23@examiner.com', '6179708', 'Junior', 'S02394381', '2021-08-17', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(150, 'Ursuline', 'Martins', 'umartins10@vistaPRINT.com', '3285546', 'Junior', 'A21416788', '2021-08-27', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(151, 'Marie', 'Fullwood', 'mfullwood12@microsoft.com', '6483211', 'Junior', 'P74649319', '2021-09-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(152, 'Keriann', 'Lavens', 'klavens6c@blogs.com', '9929795', 'Junior', 'S06980174', '2021-09-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(153, 'Broderic', 'Fominov', 'bfominov77@weibo.com', '8049327', 'Junior', 'D55972576', '2021-09-27', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(154, 'Tyne', 'Lennarde', 'tlennarde7r@vimeo.com', '1304892', 'Junior', 'D55782586', '2021-09-27', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(155, 'Jenilee', 'Vaar', 'jvaar42@paginegialle.it', '3716651', 'Junior', 'X67464077', '2021-10-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(156, 'Mignon', 'Chapier', 'mchapier3x@mapquest.com', '4329850', 'Junior', 'Q63273197', '2021-10-11', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(157, 'Angelique', 'Swepstone', 'aswepstone2@nytimes.com', '3646062', 'Junior', 'B79505600', '2021-10-22', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(158, 'Ainslie', 'Maciejewski', 'amaciejewski6s@altervista.org', '7222785', 'Junior', 'O45870286', '2021-11-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(159, 'Lefty', 'Helin', 'lhelin5o@jigsy.com', '5107658', 'Junior', 'O17284459', '2021-11-15', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(160, 'Harriett', 'Rabbitt', 'hrabbitt4d@stumbleupon.com', '2788729', 'Junior', 'F70846863', '2021-11-26', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(161, 'Mark', 'Greated', 'mgreated62@sourceforge.net', '3093640', 'Junior', 'Y17841659', '2021-11-30', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(162, 'Marty', 'Cullen', 'mcullen7e@forbes.com', '2477561', 'Junior', 'K64411732', '2021-12-04', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(163, 'Leisha', 'Cammocke', 'lcammocke2h@cam.ac.uk', '6095696', 'Junior', 'S00555684', '2021-12-22', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(164, 'Peta', 'Bockings', 'pbockings7y@mayoclinic.com', '2094420', 'Junior', 'B55581794', '2021-12-31', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(165, 'Jaymie', 'Gariff', 'jgariff5x@domainmarket.com', '6365158', 'Sophermore', 'J74491579', '2022-01-11', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(166, 'Shelia', 'Prozescky', 'sprozescky5y@youtube.com', '1486375', 'Sophermore', 'Y38994764', '2022-01-23', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(167, 'Jeth', 'Carloni', 'jcarloni1p@tmall.com', '9565763', 'Sophermore', 'P73275490', '2022-02-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(168, 'Ronalda', 'GOulborne', 'rGOulborne2o@answers.com', '1226292', 'Sophermore', 'B81172612', '2022-03-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(169, 'Wiatt', 'Frostick', 'wfrostick3w@mozilla.org', '8599136', 'Sophermore', 'P46912460', '2022-03-05', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(170, 'Manya', 'Stubley', 'mstubley2m@feedburner.com', '3618627', 'Sophermore', 'F14673991', '2022-03-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(171, 'Cornie', 'MacAndreis', 'cmacandreis66@squarespace.com', '8194093', 'Sophermore', 'P65327557', '2022-03-13', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(172, 'Kristi', 'Tomczak', 'ktomczak5t@mozilla.com', '5795300', 'Sophermore', 'S74045399', '2022-03-31', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(173, 'Madeline', 'Elsay', 'melsay7j@unesco.org', '1123295', 'Sophermore', 'Q38062711', '2022-04-06', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(174, 'Ashly', 'Spavon', 'aspavon7m@edublogs.org', '7277372', 'Sophermore', 'K04301090', '2022-04-11', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(175, 'Waverly', 'Le Moucheux', 'wlemoucheux47@mtv.com', '0243549', 'Sophermore', 'F03934858', '2022-04-23', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(176, 'Rochette', 'Lichtfoth', 'rlichtfoth89@mac.com', '7124565', 'Sophermore', 'G80092937', '2022-04-24', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(177, 'Kamila', 'Jovis', 'kjovis6x@dell.com', '6310975', 'Sophermore', 'F47543914', '2022-05-04', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(178, 'Idaline', 'Dormer', 'idormers@nbcnews.com', '8190099', 'Sophermore', 'B28202201', '2022-06-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(179, 'Marji', 'Mathissen', 'mmathissen9@seattletimes.com', '4855865', 'Sophermore', 'R17505693', '2022-06-13', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(180, 'Kevan', 'Clemmett', 'kclemmett7a@furl.net', '0584706', 'Sophermore', 'H40746909', '2022-06-13', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(181, 'Albrecht', 'Doddemeade', 'adoddemeade2p@ovh.net', '8684427', 'Sophermore', 'S18217709', '2022-07-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(182, 'Vittorio', 'Angrave', 'vangrave3p@epa.GOv', '8103476', 'Sophermore', 'C31492474', '2022-07-07', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(183, 'Dewitt', 'Trethewey', 'dtrethewey1n@blog.com', '5797640', 'Sophermore', 'C17985540', '2022-07-08', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(184, 'Briana', 'Kimmerling', 'bkimmerling6j@scientificamerican.com', '9024985', 'Sophermore', 'Y69840307', '2022-07-14', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(185, 'Sheba', 'Pletts', 'spletts34@nydailynews.com', '9235665', 'Sophermore', 'N60149710', '2022-07-22', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(186, 'Rriocard', 'Artharg', 'rartharg40@com.com', '3259850', 'Sophermore', 'W63905550', '2022-07-30', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(187, 'Conny', 'Filimore', 'cfilimore2r@nifty.com', '3705095', 'Sophermore', 'U00137382', '2022-08-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(188, 'Lorenza', 'Rau', 'lrau1o@ihg.com', '7972971', 'Sophermore', 'E41207335', '2022-08-19', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(189, 'Francklin', 'Yeld', 'fyeld3o@shop-pro.jp', '6285043', 'Sophermore', 'S91578798', '2022-09-06', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(190, 'Griffie', 'Pead', 'gpead7l@artisteer.com', '9076426', 'Sophermore', 'I25747359', '2022-10-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(191, 'Cicely', 'Casine', 'ccasinex@reuters.com', '7538730', 'Freshman', 'P43401181', '2022-10-17', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(192, 'My', 'Figura', 'mfigura39@businessweek.com', '3649119', 'Freshman', 'D58275848', '2022-10-19', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(193, 'Leonora', 'Duddin', 'lduddin4j@intel.com', '4792861', 'Freshman', 'A23513669', '2022-10-20', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(194, 'Bel', 'Grazier', 'bgrazier46@discuz.net', '0378353', 'Sophermore', 'P17983866', '2022-10-24', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(195, 'Addie', 'Brave', 'abrave6i@chicaGOtribune.com', '5235857', 'Sophermore', 'Q53522283', '2022-11-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(196, 'Ambrosio', 'Lamprecht', 'alamprecht13@archive.org', '0266745', 'Sophermore', 'V45723380', '2022-11-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(197, 'MariGOld', 'de Leon', 'mdeleon5e@craigslist.org', '3395658', 'Sophermore', 'S95108233', '2022-11-21', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(198, 'Halie', 'Parsonson', 'hparsonson5r@mashable.com', '3240981', 'Sophermore', 'K57486075', '2022-11-24', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(199, 'Rosemaria', 'Pavelka', 'rpavelka67@simplemachines.org', '4615050', 'Sophermore', 'K75382275', '2022-11-28', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(200, 'James', 'Burghill', 'jburghill6w@nature.com', '0720525', 'Sophermore', 'T66750776', '2022-11-30', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(201, 'Shurlocke', 'Crosetto', 'scrosetto7g@bloglovin.com', '2895719', 'Sophermore', 'Q56982556', '2022-12-04', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(202, 'Alex', 'Burnside', 'aburnside3v@wikispaces.com', '5628628', 'Sophermore', 'V89211854', '2022-12-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(203, 'Shawn', 'Carlyle', 'scarlyle6u@delicious.com', '8581450', 'Sophermore', 'H28930327', '2022-12-15', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(204, 'Giovanna', 'Gillian', 'ggillian7h@sfgate.com', '7710175', 'Sophermore', 'Z82027522', '2022-12-15', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(205, 'Ertha', 'Hearne', 'ehearne84@nationalgeographic.com', '8636587', 'Freshman', 'H02867465', '2023-01-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(206, 'Davine', 'Kewish', 'dkewish4v@prlog.org', '4760638', 'Freshman', 'K65144108', '2023-01-04', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(207, 'Cairistiona', 'Gallo', 'cgallo85@youtube.com', '6152579', 'Freshman', 'X23326499', '2023-01-06', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(208, 'Averyl', 'Breckenridge', 'abreckenridgeb@hp.com', '1422881', 'Freshman', 'M94879242', '2023-01-08', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(209, 'Jillane', 'Gatecliff', 'jgatecliff0@latimes.com', '6452616', 'Freshman', 'O83047875', '2023-01-11', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(210, 'Shepherd', 'Linforth', 'slinforth3d@cafepress.com', '9765361', 'Freshman', 'W21793874', '2023-01-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(211, 'Loria', 'Bielfeldt', 'lbielfeldt5d@issuu.com', '0036716', 'Freshman', 'T99521369', '2023-01-24', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(212, 'Jeniece', 'Mulleary', 'jmullearyz@prlog.org', '6738597', 'Freshman', 'R86597081', '2023-01-27', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(213, 'Caroljean', 'Churchward', 'cchurchward6k@prnewswire.com', '2487857', 'Freshman', 'N40022821', '2023-01-28', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(214, 'Alfie', 'Binne', 'abinne2i@de.vu', '6090753', 'Freshman', 'J14773973', '2023-02-03', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(215, 'Annadiana', 'Heephy', 'aheephy5v@ftc.GOv', '5411163', 'Freshman', 'I37067433', '2023-02-04', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(216, 'Collete', 'Totaro', 'ctotaro61@storify.com', '2608013', 'Freshman', 'F61588318', '2023-02-17', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(217, 'Renie', 'Tettersell', 'rtettersell5@newyorker.com', '4938056', 'Freshman', 'Y38143681', '2023-02-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(218, 'Kliment', 'Rittmeier', 'krittmeier3s@boston.com', '4129741', 'Freshman', 'I99598637', '2023-02-23', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(219, 'Marcelle', 'Praten', 'mpraten2e@jalbum.net', '7056156', 'Freshman', 'N40852438', '2023-03-08', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(220, 'Roselia', 'Esmead', 'resmead71@noaa.GOv', '3046320', 'Freshman', 'P54762834', '2023-03-13', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(221, 'Dulcea', 'Helstrip', 'dhelstrip2z@vkontakte.ru', '9209782', 'Freshman', 'Q90318313', '2023-03-19', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(222, 'Jackqueline', 'Farrow', 'jfarrow2f@qq.com', '3271817', 'Freshman', 'L56727096', '2023-04-08', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(223, 'Arabella', 'Bedberry', 'abedberry5b@ezinearticles.com', '1894670', 'Freshman', 'V76841063', '2023-04-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(224, 'Leonerd', 'Jerche', 'ljerche6z@senate.GOv', '1908710', 'Freshman', 'K41808919', '2023-04-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(225, 'Gery', 'Gerlack', 'ggerlack5f@amazonaws.com', '0284422', 'Freshman', 'D48963844', '2023-04-28', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(226, 'Wells', 'Dalling', 'wdalling1t@cornell.edu', '8476821', 'Freshman', 'E81446539', '2023-05-01', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(227, 'Pearla', 'Batters', 'pbatters2l@cyberchimps.com', '1279630', 'Freshman', 'O49691983', '2023-05-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(228, 'Ruby', 'Tilte', 'rtilte6t@delicious.com', '6204541', 'Freshman', 'T61329555', '2023-05-18', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(229, 'Ulrick', 'Torri', 'utorri54@infoseek.co.jp', '0255630', 'Freshman', 'B29268259', '2023-05-20', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(230, 'Anica', 'Gatfield', 'agatfield1w@GOo.ne.jp', '4222696', 'Freshman', 'U52989242', '2023-05-20', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(231, 'Cally', 'Caslane', 'ccaslane1c@sourceforge.net', '6162718', 'Freshman', 'Y51831485', '2023-05-25', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(232, 'Loni', 'O'' Sullivan', 'losullivany@paypal.com', '7117982', 'Freshman', 'C44104818', '2023-05-26', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(233, 'Tamarah', 'Southerill', 'tsoutherill4z@upenn.edu', '3139170', 'Freshman', 'P27195374', '2023-05-29', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(234, 'Elisabet', 'Kelso', 'ekelso58@ted.com', '5414021', 'Freshman', 'Z68427439', '2023-06-15', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(235, 'Cherianne', 'Marusik', 'cmarusik3z@paginegialle.it', '3248348', 'Freshman', 'D95637145', '2023-06-25', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(236, 'Lem', 'Bierton', 'lbierton5h@bizjournals.com', '2748760', 'Freshman', 'T56756007', '2023-06-25', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(237, 'Dedie', 'Wakley', 'dwakley5m@live.com', '6972623', 'Sophermore', 'T43904649', '2023-07-15', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(238, 'Raimundo', 'Boscher', 'rboscher1s@GOogle.co.jp', '7234462', 'Sophermore', 'Q44320418', '2023-07-31', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(239, 'Adi', 'Kovalski', 'akovalski69@reuters.com', '2322547', 'Sophermore', 'Y81293557', '2023-08-05', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(240, 'Ewart', 'McCoid', 'emccoid2n@yahoo.co.jp', '4446990', 'Sophermore', 'I71580796', '2023-08-08', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(241, 'GOdard', 'Matthessen', 'gmatthessen1b@rambler.ru', '8459915', 'Sophermore', 'Q65303243', '2023-08-13', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(242, 'Neville', 'BaGOt', 'nbaGOt81@aol.com', '1894857', 'Sophermore', 'R98453743', '2023-08-15', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(243, 'Matteo', 'Blankett', 'mblankettk@livejournal.com', '2104417', 'Junior', 'F70031047', '2023-09-22', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(244, 'Skipton', 'McGannon', 'smcgannon73@cam.ac.uk', '8869758', 'Junior', 'S26580349', '2023-09-25', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(245, 'Rowena', 'Lanston', 'rlanston7b@altervista.org', '5767890', 'Junior', 'N79799501', '2023-10-06', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(246, 'Gun', 'Jackalin', 'gjackalin22@geocities.com', '0811645', 'Junior', 'L27226115', '2023-10-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(247, 'Vanda', 'Mollene', 'vmollene7d@friendfeed.com', '7934567', 'Junior', 'L51350340', '2023-10-17', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(248, 'Adeline', 'Harries', 'aharries63@tiny.cc', '6873641', 'Junior', 'H03740693', '2023-10-22', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(249, 'Maxie', 'Hugh', 'mhugh52@etsy.com', '0805979', 'Junior', 'L13602421', '2023-10-25', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(250, 'Dacia', 'Bruckman', 'dbruckman1e@slashdot.org', '6217801', 'Junior', 'D79157368', '2023-10-28', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(251, 'Fifi', 'Bovingdon', 'fbovingdon8b@alexa.com', '6596374', 'Junior', 'K51249711', '2023-10-29', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(252, 'Tani', 'Kubacki', 'tkubacki6l@independent.co.uk', '0515534', 'Junior', 'U95529833', '2023-10-30', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(253, 'Breena', 'Reddan', 'breddan2j@mit.edu', '4486984', 'Junior', 'N49337095', '2023-11-14', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(254, 'Wanda', 'Lade', 'wlade5w@princeton.edu', '8676063', 'Senior', 'T20793129', '2023-11-19', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(255, 'Bat', 'Harte', 'bhartep@github.io', '3723027', 'Senior', 'N84943349', '2023-11-20', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(256, 'Jocko', 'Duddin', 'jduddin7o@lulu.com', '4870153', 'Senior', 'P43996002', '2023-11-25', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(257, 'Craig', 'Jakobssen', 'cjakobssen4r@answers.com', '1277128', 'Senior', 'T04376755', '2023-12-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(258, 'Cory', 'Cadd', 'ccadd65@privacy.GOv.au', '7576737', 'Senior', 'M57187776', '2023-12-14', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(259, 'Gerik', 'Dukelow', 'gdukelow4a@GOogle.com.br', '6527694', 'Senior', 'L03982277', '2023-12-20', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(260, 'Taddeo', 'Bodiam', 'tbodiam4o@GOogle.es', '2349858', 'Senior', 'K32746585', '2024-01-04', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(261, 'Dani', 'Fillis', 'dfillis32@aol.com', '2385032', 'Senior', 'A24294681', '2024-01-15', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(262, 'Lorie', 'Otham', 'lotham27@aboutads.info', '1432047', 'Senior', 'D73996585', '2024-01-26', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(263, 'Taddeusz', 'Julien', 'tjulienq@indieGOGO.com', '6047448', 'Senior', 'A83898511', '2024-02-01', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(264, 'Rolando', 'Giuron', 'rgiuron1r@free.fr', '1129277', 'Senior', 'F16427183', '2024-02-02', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(265, 'Filip', 'Border', 'fborder2g@apache.org', '6951018', 'Senior', 'A08435977', '2024-02-07', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(266, 'Mendel', 'Friel', 'mfriel1y@bing.com', '0051448', 'Senior', 'W67334705', '2024-02-10', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(267, 'Mateo', 'Rowdell', 'mrowdell38@addtoany.com', '1703406', 'Senior', 'M64304288', '2024-03-07', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(268, 'Donielle', 'ONULL''Neary', 'doneary4i@networksolutions.com', '6164456', 'Senior', 'R57181949', '2024-03-12', NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(269, 'Nerti', 'Tace', 'ntace5g@homestead.com', NULL, 'External', NULL, NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(270, 'Jermaine', 'Bemwell', 'jbemwell7q@youku.com', NULL, 'External', NULL, NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(271, 'Filip', 'Dumini', 'fdumini1h@oracle.com', NULL, 'External', NULL, NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(272, 'Stillman', 'Poppleston', 'spoppleston1u@wordpress.org', NULL, 'Representative', NULL, NULL, 'GOogle');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(273, 'Matthias', 'Gershom', 'mgershom28@addtoany.com', NULL, 'Representative', NULL, NULL, 'Amazon');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(274, 'Dov', 'Basire', 'dbasire3j@furl.net', NULL, 'Representative', NULL, NULL, 'Blue Corss');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(275, 'Irvine', 'Scamal', 'iscamal4t@parallels.com', NULL, 'Representative', NULL, NULL, 'Beaufort Digital Cooridor');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(276, 'Burr', 'Benbow', 'bbenbow6p@booking.com', NULL, 'Representative', NULL, NULL, 'Apple');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(277, 'Zsa zsa', 'Frayling', 'zfrayling7v@unblog.fr', NULL, 'Student', 'G46124518', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(278, 'Warden', 'Eaden', 'weaden87@reuters.com', NULL, 'Student', 'L86554734', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(279, 'Stafford', 'Iacomini', 'siacominin@hugedomains.com', NULL, 'Student', 'N86769380', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(280, 'Blakeley', 'Neeves', 'bneevesu@nature.com', NULL, 'Student', 'O85610411', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(281, 'Shawn', 'Midlar', 'smidlar1x@springer.com', NULL, 'Student', 'Y99740331', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(282, 'Chloette', 'Gwillyam', 'cgwillyam21@people.com.cn', NULL, 'Student', 'J60737683', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(283, 'Caroline', 'Tocqueville', 'ctocqueville31@disqus.com', NULL, 'Student', 'H68682899', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(284, 'Dot', 'Bamfield', 'dbamfield3l@simplemachines.org', NULL, 'Student', 'S19808780', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(285, 'Nomi', 'Furtado', 'nfurtado3n@yahoo.co.jp', NULL, 'Student', 'P00084609', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(286, 'Leda', 'Kinworthy', 'lkinworthy4l@time.com', NULL, 'Student', 'G62194193', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(287, 'Garry', 'Reddle', 'greddle56@narod.ru', NULL, 'Student', 'P72502141', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(288, 'Adler', 'Vannikov', 'avannikov5c@wufoo.com', NULL, 'Student', 'E32701355', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(289, 'GOrdon', 'Larcombe', 'glarcombe5j@reference.com', NULL, 'Student', 'K21947913', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(290, 'Maddalena', 'Elsby', 'melsby7f@vistaPRINT.com', NULL, 'Student', 'A71020705', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(291, 'Walden', 'Badby', 'wbadby7z@parallels.com', NULL, 'Student', 'Z24508493', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(292, 'Guntar', 'Tunna', 'gtunnac@usgs.GOv', NULL, 'Student', 'A68066855', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(293, 'Allyce', 'Buret', 'aburet4u@usda.GOv', NULL, 'Student', 'D19262959', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(294, 'Rubetta', 'Impett', 'rimpett55@csmonitor.com', NULL, 'Student', 'U53178909', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(295, 'Ange', 'Ickovic', 'aickovic64@usgs.GOv', NULL, 'Student', 'R84944721', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(296, 'Everett', 'Ordemann', 'eordemanng@woothemes.com', NULL, 'Student', 'F61180993', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(297, 'Tricia', 'Poulter', 'tpoulter16@storify.com', NULL, 'Student', 'R93789110', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(298, 'Barris', 'Robelet', 'brobelet1a@wsj.com', NULL, 'Student', 'K34150040', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(299, 'Ossie', 'Crunkhorn', 'ocrunkhorn4f@hugedomains.com', NULL, 'Student', 'A60354662', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(300, 'Pryce', 'Clavey', 'pclavey4g@cnbc.com', NULL, 'Student', 'A59874235', NULL, NULL);
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(301, 'Sam', 'Haering', 'haerings@uscb.edu', NULL, 'Coordinator', 'S59874235', NULL, 'Student-Life');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(302, 'Ronald', 'Erdei', 'erdeir@uscb.edu', NULL, 'Faculty', 'S59875835', NULL, 'USCB Computer Science');
INSERT INTO People(PeopleID, LName, FName, Email, ACMID, Classification, StudentVIPID, PaymentDate, Organization) VALUES(303, 'Brian', 'Canada', 'canadab@uscb.edu', NULL, 'Faculty', 'S54575835', NULL, 'USCB Computer Science');
SET IDENTITY_INSERT People OFF;
GO
/*********************** Insert into Expenditures ***********************/
SET IDENTITY_INSERT Expenditures ON;
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(1, NULL, 2, '2018-08-29', NULL, 21670);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(2, NULL, 2, '2018-10-06', NULL, 21689);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(3, NULL, 2, '2018-10-08', NULL, 21690);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(4, NULL, 2, '2018-11-09', NULL, 21706);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(5, NULL, 2, '2019-01-23', NULL, 21744);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(6, NULL, 2, '2019-01-31', NULL, 21748);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(7, NULL, 2, '2019-02-26', NULL, 21761);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(8, NULL, 2, '2019-02-28', NULL, 21762);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(9, NULL, 2, '2019-04-07', NULL, 21781);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(10, NULL, 2, '2019-08-30', NULL, 21853);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(11, NULL, 2, '2019-10-07', NULL, 21872);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(12, NULL, 2, '2019-10-09', NULL, 21873);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(13, NULL, 2, '2019-11-10', NULL, 21889);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(14, NULL, 2, '2020-01-24', NULL, 21927);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(15, NULL, 2, '2020-02-01', NULL, 21931);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(16, NULL, 2, '2020-02-28', NULL, 21944);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(17, NULL, 2, '2020-03-01', NULL, 21945);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(18, NULL, 2, '2020-04-08', NULL, 21964);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(19, NULL, 2, '2020-08-30', NULL, 22036);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(20, NULL, 2, '2020-10-08', NULL, 22056);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(21, NULL, 2, '2020-10-10', NULL, 22057);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(22, NULL, 2, '2020-11-11', NULL, 22073);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(23, NULL, 2, '2021-01-25', NULL, 22110);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(24, NULL, 2, '2021-02-02', NULL, 22114);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(25, NULL, 2, '2021-02-28', NULL, 22127);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(26, NULL, 2, '2021-03-02', NULL, 22128);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(27, NULL, 2, '2021-04-09', NULL, 22147);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(28, NULL, 2, '2021-08-30', NULL, 22219);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(29, NULL, 2, '2021-10-09', NULL, 22239);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(30, NULL, 2, '2021-10-11', NULL, 22240);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(31, NULL, 2, '2021-11-12', NULL, 22256);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(32, NULL, 2, '2022-01-26', NULL, 22293);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(33, NULL, 2, '2022-02-03', NULL, 22297);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(34, NULL, 2, '2022-03-01', NULL, 22310);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(35, NULL, 2, '2022-03-03', NULL, 22311);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(36, NULL, 2, '2022-04-10', NULL, 22330);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(37, NULL, 2, '2022-08-30', NULL, 22401);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(38, NULL, 2, '2022-10-09', NULL, 22421);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(39, NULL, 2, '2022-10-11', NULL, 22422);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(40, NULL, 2, '2022-11-12', NULL, 22438);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(41, NULL, 2, '2023-01-27', NULL, 22476);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(42, NULL, 2, '2023-02-04', NULL, 22480);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(43, NULL, 2, '2023-03-02', NULL, 22493);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(44, NULL, 2, '2023-03-04', NULL, 22494);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(45, NULL, 2, '2023-04-11', NULL, 22513);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(46, NULL, 2, '2023-08-27', NULL, 22582);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(47, NULL, 2, '2023-09-17', NULL, 22593);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(48, NULL, 2, '2023-10-03', NULL, 22601);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(49, NULL, 2, '2023-10-08', NULL, 22603);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(50, NULL, 2, '2024-01-28', NULL, 22659);
INSERT INTO Expenditures(ExpenditureID, OfficerID, AccountingID, ExpenditureDate, Description, RecordLocator) VALUES(51, NULL, 2, '2024-02-05', NULL, 22663);
SET IDENTITY_INSERT Expenditures OFF;
GO
/*********************** Insert into ExpenditureLineItems ***********************/
SET IDENTITY_INSERT ExpenditureLineItems ON;
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(1,1,'Snack',4, 10, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(2,1,'Soda',25, 5, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(3,1,'Pizza',4, 1, 50, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(4,2,'Lunch for Members',10, 1, 150, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(5,2,'Gas Money',1, 1, 60, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(6,3,'Soda',15, 6, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(7,3,'Snack',8, 8, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(8,3,'PS4 Bundle',1, 1, 250, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(9,3,'Boardgame pack',1, 1, 30, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(10,4,'Snack',8, 9, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(11,4,'Soda',15, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(12,4,'Materials for Printers',5, 20, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(13,5,'T-Shirt with best Design',50, 10, 1000, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(14,6,'Lunch for Members',13, 1, 150, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(15,6,'Gas Money',1, 1, 60, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(16,7,'Soda',60, 8, 70, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(17,7,'Snack',70, 5, 100, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(18,8,'Lunch for Members',12, 1, 150, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(19,8,'Gas Money',1, 1, 60, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(20,9,'Souces',6, 2, 15, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(21,9,'Bread',5, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(22,9,'Soda',30, 3, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(23,9,'Buns',10, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(24,9,'Hotdogs',20, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(25,9,'Beef',40, 4, 50, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(26,10,'Snack',4, 10, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(27,10,'Soda',25, 5, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(28,10,'Pizza',4, 1, 51, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(29,11,'Lunch for Members',10, 1, 153, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(30,11,'Gas Money',1, 1, 61, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(31,12,'Soda',15, 6, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(32,12,'Snack',8, 8, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(33,12,'PS4 Games',2, 1, 255, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(34,12,'Extra Controler ',1, 1, 30, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(35,13,'Snack',8, 9, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(36,13,'Soda',15, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(37,13,'Materials for Printers',5, 20, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(38,14,'T-Shirt with best Design',5, 10, 1020, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(39,15,'Lunch for Members',13, 1, 153, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(40,15,'Gas Money',1, 1, 61, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(41,16,'Soda',30, 8, 71, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(42,16,'Snack',20, 5, 102, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(43,17,'Lunch for Members',12, 1, 153, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(44,17,'Gas Money',1, 1, 61, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(45,18,'Souces',6, 2, 15, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(46,18,'Bread',5, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(47,18,'Soda',15, 3, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(48,18,'Buns',10, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(49,18,'Hotdogs',10, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(50,18,'Beef',20, 4, 51, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(51,19,'Snack',4, 10, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(52,19,'Soda',25, 5, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(53,19,'Pizza',4, 1, 52, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(54,20,'Lunch for Members',10, 1, 156, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(55,20,'Gas Money',1, 1, 62, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(56,21,'Soda',15, 6, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(57,21,'Snack',8, 8, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(58,21,'Nitendo Switch Bundle',1, 1, 260, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(59,21,'Extra Controlers',1, 1, 30, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(60,22,'Snack',8, 9, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(61,22,'Soda',15, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(62,22,'Materials for Printers',5, 20, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(63,23,'T-Shirt with best Design',50, 10, 1040, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(64,24,'Lunch for Members',13, 1, 156, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(65,24,'Gas Money',1, 1, 62, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(66,25,'Soda',60, 8, 72, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(67,25,'Snack',70, 5, 104, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(68,26,'Lunch for Members',12, 1, 156, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(69,26,'Gas Money',1, 1, 62, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(70,27,'Souces',6, 2, 15, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(71,27,'Bread',5, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(72,27,'Soda',30, 3, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(73,27,'Buns',10, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(74,27,'Hotdogs',20, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(75,27,'Beef',40, 4, 52, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(76,28,'Snack',4, 10, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(77,28,'Soda',25, 5, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(78,28,'Pizza',4, 1, 53, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(79,29,'Lunch for Members',10, 1, 159, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(80,29,'Gas Money',1, 1, 63, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(81,30,'Soda',15, 6, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(82,30,'Snack',8, 8, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(83,30,'Nitendo Switch Game',2, 1, 265, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(84,30,'PS4 Game ',1, 1, 30, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(85,31,'Snack',8, 9, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(86,31,'Soda',15, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(87,31,'Materials for Printers',5, 20, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(88,32,'T-Shirt with best Design',50, 10, 1060, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(89,33,'Lunch for Members',13, 1, 159, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(90,33,'Gas Money',1, 1, 63, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(91,34,'Soda',60, 8, 73, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(92,34,'Snack',70, 5, 106, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(93,35,'Lunch for Members',12, 1, 159, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(94,35,'Gas Money',1, 1, 63, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(95,36,'Souces',6, 2, 15, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(96,36,'Bread',5, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(97,36,'Soda',30, 3, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(98,36,'Buns',10, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(99,36,'Hotdogs',20, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(100,36,'Beef',40, 4, 53, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(101,37,'Snack',4, 10, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(102,37,'Soda',25, 5, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(103,37,'Pizza',4, 1, 54, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(104,38,'Lunch for Members',10, 1, 162, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(105,38,'Gas Money',1, 1, 64, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(106,39,'Soda',15, 6, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(107,39,'Snack',8, 8, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(108,39,'PS4 Bundle',1, 1, 270, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(109,39,'Nitendo Game',1, 1, 30, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(110,40,'Snack',8, 9, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(111,40,'Soda',15, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(112,40,'Materials for Printers',5, 20, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(113,41,'T-Shirt with best Design',50, 10, 1081, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(114,42,'Lunch for Members',13, 1, 162, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(115,42,'Gas Money',1, 1, 64, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(116,43,'Soda',60, 8, 74, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(117,43,'Snack',70, 5, 108, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(118,44,'Lunch for Members',12, 1, 162, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(119,44,'Gas Money',1, 1, 64, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(120,45,'Souces',6, 2, 15, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(121,45,'Bread',5, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(122,45,'Soda',30, 3, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(123,45,'Buns',10, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(124,45,'Hotdogs',20, 2, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(125,45,'Beef',40, 4, 54, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(126,46,'Snack',4, 10, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(127,46,'Soda',25, 5, 30, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(128,46,'Pizza',4, 1, 55, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(129,47,'Lunch for Members',10, 1, 165, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(130,47,'Gas Money',1, 1, 65, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(131,48,'Soda',15, 6, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(132,48,'Snack',8, 8, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(133,48,'PS5 Bundle',1, 1, 275, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(134,48,'Boardgame pack',1, 1, 30, 'Retainable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(135,49,'Snack',8, 9, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(136,49,'Soda',15, 4, 20, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(137,49,'Materials for Printers',5, 20, 40, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(138,50,'T-Shirt with best Design',50, 10, 1102, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(139,51,'Lunch for Members',13, 1, 165, 'Consumable', 2);
INSERT INTO ExpenditureLineItems(ExpenditureLineItemID, ExpenditureID, LineItemDescription, UnitQuantity, QuantityPerUnit, UnitPrice, LineItemCategory, LocationID) VALUES(140,51,'Gas Money',1, 1, 65, 'Consumable', 2);
SET IDENTITY_INSERT ExpenditureLineItems OFF;
GO

/*********************** Execute Stored Procedures ***********************/
EXEC sp_CreateMembershipRecords;
GO
EXEC sp_PopulateOfficers;
GO
EXEC sp_Donations;
GO
EXEC sp_OfficersForEvents;
GO
EXEC sp_OfficersForExpenditures;
GO
EXEC sp_EventAttendees;
GO
EXEC sp_Sales;
GO
/*
SELECT * FROM vw_AcademicYears;

SELECT * FROM AcademicTerms;

SELECT * FROM AccountingAccounts;

SELECT * FROM Locations;

SELECT * FROM Recievables r INNER JOIN RecievableLineItems rl ON r.RecievableID = rl.RecievableID;

SELECT * FROM People p INNER JOIN MembershipRecords m ON p.PeopleID = m.PeopleID;

SELECT * FROM Officers o INNER JOIN People p ON o.PeopleID = p.PeopleID;

SELECT * FROM Events e INNER JOIN EventAttendees ea ON e.EventID = ea.EventID;

SELECT * FROM EventAttendees;

SELECT * FROM EventItems;

SELECT * FROM Expenditures e INNER JOIN ExpenditureLineItems el ON e.ExpenditureID = el.ExpenditureID;

*/

GO
/*********************** Implement required stored procedures ***********************/
/*********************** Trigger to make Membership Record ON insert into People ***********************/
CREATE TRIGGER [dbo].[tr_people_for_insert]
	ON [dbo].[People]
	FOR INSERT
AS
BEGIN	
	INSERT INTO [dbo].[MembershipRecords] (PeopleID, StartDate, EndDate)
	SELECT inserted.PeopleID
		 , inserted.PaymentDate
		 , DATEADD(yyyy, 1, inserted.PaymentDate) AS EndDate
	FROM inserted
	WHERE inserted.PaymentDate IS NOT NULL;
END
GO
/*********************** Drop all of the procedures again ***********************/
DROP PROCEDURE IF EXISTS sp_CreateMembershipRecords;
DROP PROCEDURE IF EXISTS sp_PopulateOfficers;
DROP PROCEDURE IF EXISTS sp_Donations;
DROP PROCEDURE IF EXISTS sp_OfficersForEvents;
DROP PROCEDURE IF EXISTS sp_OfficersForExpenditures;
DROP PROCEDURE IF EXISTS sp_EventAttendees;
GO