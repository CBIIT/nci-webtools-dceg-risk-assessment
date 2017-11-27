SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.GetRisks') AND type in (N'P', N'PC'))
begin
	DROP PROCEDURE dbo.GetRisks
	print '--stp dbo.GetRisks has been dropped'
end
GO

CREATE PROCEDURE dbo.GetRisks 
/**************************************************************************************************
* Name		: dbo.GetRisks
* Purpose	: Gets Five Year Abs Risk and Lifetime Abs Risk
* Author	: Siva
* Date		: 10/15/2008
* Returns	: Five Year Abs Risk and Lifetime Abs Risk
* Usage		: Exec dbo.GetRisks @age=50, @gender=1, @patternID=500
			: Exec dbo.GetRisks @age=50, @gender=2, @patternID=500
* Changes	: 
**************************************************************************************************/
	@age int
	, @gender int --1 Male, 2 Female
    , @patternID int
AS
BEGIN
set nocount on
begin try
	if(@gender = 1)
	begin	
		select
			 Five_yr_Abs_Risk
			, Ten_yr_Abs_Risk
			, Twenty_yr_Abs_Risk
			, Life_Abs_Risk
			, Pattrn_ID as PatternID
		from Male
		where age = @age
			and Pattrn_ID = @patternID
	end
	else if(@gender = 2)
	begin	
		select 
			Five_yr_Abs_Risk
			, Ten_yr_Abs_Risk
			, Twenty_yr_Abs_Risk
			, Life_Abs_Risk
			, Pattrn_ID as PatternID
		from Female
		where age = @age
			and Pattrn_ID = @patternID
	end
end try
begin catch
	print error_message() 
	return error_number()
end catch
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.GetRisks') AND type in (N'P', N'PC'))
begin
	GRANT EXECUTE ON dbo.GetRisks TO RiskAssessUser_role
	print '--stp dbo.GetRisks has been created'
end
Go

