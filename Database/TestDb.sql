USE [TestDb]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 23-01-2022 01:49:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeCode] [varchar](50) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Department] [varchar](100) NOT NULL,
	[Gender] [varchar](50) NULL,
	[DOB] [date] NULL,
	[JoiningDate] [date] NULL,
	[PreviousExperince] [decimal](18, 0) NOT NULL,
	[Salary] [decimal](18, 0) NOT NULL,
	[Address] [varchar](max) NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[Employee] ([EmployeeCode], [Name], [Department], [Gender], [DOB], [JoiningDate], [PreviousExperince], [Salary], [Address]) VALUES (N'EMP001', N'bala', N'department', N'male', CAST(N'2022-01-22' AS Date), CAST(N'2022-01-22' AS Date), CAST(6 AS Decimal(18, 0)), CAST(200000 AS Decimal(18, 0)), N'jalgaon')
INSERT [dbo].[Employee] ([EmployeeCode], [Name], [Department], [Gender], [DOB], [JoiningDate], [PreviousExperince], [Salary], [Address]) VALUES (N'EMP002', N'Mahesh', N'Accounts', N'male', CAST(N'2022-01-23' AS Date), CAST(N'2022-01-23' AS Date), CAST(0 AS Decimal(18, 0)), CAST(200000 AS Decimal(18, 0)), N'Pune')
INSERT [dbo].[Employee] ([EmployeeCode], [Name], [Department], [Gender], [DOB], [JoiningDate], [PreviousExperince], [Salary], [Address]) VALUES (N'EMP003', N'Amol Jadhav', N'Technology', N'male', CAST(N'2022-01-22' AS Date), CAST(N'2022-01-23' AS Date), CAST(0 AS Decimal(18, 0)), CAST(52222 AS Decimal(18, 0)), N'Jalgaon')
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_PreviousExperince]  DEFAULT ((0)) FOR [PreviousExperince]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_Salary]  DEFAULT ((0)) FOR [Salary]
GO
/****** Object:  StoredProcedure [dbo].[SaveEmployee]    Script Date: 23-01-2022 01:49:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 23/01/2022
-- Description:	Used to save employee
-- =============================================
CREATE PROC [dbo].[SaveEmployee]
(
	@EmployeeCode										VARCHAR(50)	= NULL,
	@Name												VARCHAR(200),
	@Department											VARCHAR(100) = NULL,
	@Gender												VARCHAR(100),
	@DOB												DATE,
	@JoiningDate										DATE,
	@PreviousExperince									DECIMAL(18,2),
	@Salary												DECIMAL(18,2),
	@Address											VARCHAR(MAX)	= NULL,
	@OutputMessage										VARCHAR(MAX)		OUT
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
				IF EXISTS (SELECT 1 FROM Employee WHERE EmployeeCode = @EmployeeCode)
	BEGIN
		UPDATE
			Employee
		SET
			[Name]				= @Name,
			Department			= @Department,
			Gender				= @Gender,
			DOB					= @DOB,
			JoiningDate			= @JoiningDate,
			PreviousExperince	= @PreviousExperince,
			Salary				= @Salary,
			[Address]			= @Address
		WHERE
			EmployeeCode		= @EmployeeCode
		SET
			@OutputMessage = 'Employee data update successfully'
	END
	ELSE
	BEGIN
		INSERT INTO 
			Employee(EmployeeCode, [Name], Department, Gender, DOB, JoiningDate, PreviousExperince, Salary, [Address])
		VALUES
			(@EmployeeCode, @Name, @Department, @Gender, @DOB, @JoiningDate, @PreviousExperince, @Salary, @Address);
		SET
			@OutputMessage = 'Employee data save successfully'
	END
	END TRY
	BEGIN CATCH

		DECLARE @ErrorNumber			INT;
		DECLARE @ErrorSeverity			INT;
		DECLARE @ErrorState				INT;
		DECLARE @ErrorProcedure			NVARCHAR(126);
		DECLARE @ErrorLine				INT;
		DECLARE @ErrorMessage			NVARCHAR(MAX);
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage;

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
					@ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[ShowEmployee]    Script Date: 23-01-2022 01:49:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 23/01/2022
-- Description:	Used to show employee
-- Execution:	EXEC ShowEmployee
-- =============================================
CREATE PROC [dbo].[ShowEmployee]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		E.EmployeeCode									AS EmployeeCode,
		E.[Name]										AS [Name],
		E.Department									AS Department,
		E.Gender										AS Gender,
		E.DOB											AS DOB,
		E.JoiningDate									AS JoiningDate,
		E.PreviousExperince								AS PreviousExperince,
		E.Salary										AS Salary,
		E.[Address]										AS [Address]
	FROM
		Employee											AS E
	ORDER BY
		E.JoiningDate DESC
END












GO
