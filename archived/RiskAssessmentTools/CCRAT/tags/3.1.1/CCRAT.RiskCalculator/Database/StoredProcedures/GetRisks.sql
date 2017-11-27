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
* Returns	: 5, 10, 20 Year and Lifetime Abs Risks
* Params	: @age, @gender(1-male, 2-female), @patternid, @race(white=1, black=2, hispanic=3, asian=4)
* Usage		: Exec dbo.GetRisks @age=50, @gender=1, @patternID=500, @race = 1
			: Exec dbo.GetRisks @age=50, @gender=2, @patternID=500, @race = 1
* Changes	: 02/27/2009 siva: updated for other races(asian, black, and hispanic)
			: 03/13/2009 siva: updated to include average risks
**************************************************************************************************/
	@age int
	, @gender int --1 Male, 2 Female
    , @patternID int
    , @race tinyint --(White=1, Black=2, Hispanic=3, Asian=4)
AS
BEGIN
set nocount on
begin try
	if(@gender = 1)
	begin	
	
		--1.1 return absolute risks for male
		select
			  ab.Age			
			, ab.Race			
			--abs risk
			, Pattrn_ID as PatternID
			, Five_yr_Abs_Risk as FiveYrAbsRisk
			, Ten_yr_Abs_Risk as TenYrAbsRisk
			, Twenty_yr_Abs_Risk as TwentyYrAbsRisk
			, Life_Abs_Risk as LifeAbsRisk
			--avg risk
			, FiveYrAvgRisk, TenYrAvgRisk, LifeTimeAvgRisk
		from male ab
			join MaleAvgRisk av on ab.race = av.race and ab.age = av.age
		where ab.age = @age
			and ab.Pattrn_ID = @patternID
			and ab.Race = @race
		
		/*	
		--1.2 return average risks male
		select Race, Age, FiveYrAvgRisk, TenYrAvgRisk, LifeTimeAvgRisk
		from MaleAvgRisk
		where race = @race and age = @age
		*/
	end
	else if(@gender = 2)
	begin	
	
		--2.1 return absolute risks female
		select 
			  ab.Age			
			, ab.Race			
			--abs risk
			, Pattrn_ID as PatternID	
			, Five_yr_Abs_Risk as FiveYrAbsRisk
			, Ten_yr_Abs_Risk as TenYrAbsRisk
			, Twenty_yr_Abs_Risk as TwentyYrAbsRisk
			, Life_Abs_Risk as LifeAbsRisk
			--avg risk
			, FiveYrAvgRisk, TenYrAvgRisk, LifeTimeAvgRisk
		from female ab
			join FemaleAvgRisk av on ab.race = av.race and ab.age = av.age
		where ab.age = @age
			and ab.Pattrn_ID = @patternID
			and ab.Race = @race
		
		/*
		--2.2 return average risks for female
		select Race, Age, FiveYrAvgRisk, TenYrAvgRisk, LifeTimeAvgRisk
		from FemaleAvgRisk
		where race = @race and age = @age
		*/
		
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
