/**************************************************************************************************
* Name		: CCRAT.sql
* Purpose	: Contains DB scripts for Colorectal Cancer Risk Assessment Tool(CCRAT)
* Author	: SRamaiah
* Date		: 10/15/2008
* Changes	: 02/25/2009 SR - updated to include a new column for race
**************************************************************************************************/
	create table Female(
		Age tinyint not null 
		, Pattrn_ID smallint not null 
		, posi_0_Ind tinyint not null 
		, posi_1_Ind tinyint not null 
		, posi_2_Ind tinyint not null 
		, no_Strogn tinyint not null 
		, NumOf_Rel_ge_1 tinyint not null 
		, noNSAIDS tinyint not null 
		, vigl_0Ind tinyint not null 
		, vigl_1Ind tinyint not null 
		, vigl_2Ind tinyint not null 
		, BMI_Ge_30_Ind tinyint not null 
		, XcrisHrsTrnd tinyint not null 
		, Veg_lt5_Ind tinyint not null 
		, noNSAIDS2 tinyint not null 
		, posi_1Ind tinyint not null 
		, posi_2Ind tinyint not null 
		, posi_3Ind tinyint not null 
		, no_Strogn2 tinyint not null 
		, NumOfRel_Trnd tinyint not null 
		, BMI_Ge_30_2_Ind tinyint not null 
		, BMI_Ge_30_Eastrgn_Ind tinyint not null 
		, Five_yr_Abs_Risk numeric(7,6) null 
		, Ten_yr_Abs_Risk numeric(7,6) null 
		, Twenty_yr_Abs_Risk numeric(7,6) null 
		, Life_Abs_Risk numeric(7,6) not null
		, Race varchar(50) not null
		)
	--create Male Table
	create Table Male (
		Age tinyint not null 
		, Pattrn_ID smallint not null 
		, posi_0_Ind tinyint not null 
		, posi_1_Ind tinyint not null 
		, posi_2_Ind tinyint not null 
		, NoIbuprofn_In tinyint not null 
		, TotlRelge1_In tinyint not null 
		, HrsExcrise tinyint not null 
		, CigYr0_Ind tinyint not null 
		, CigYr2_Ind tinyint not null 
		, CigYr3_Ind tinyint not null 
		, Veglt5_Ind tinyint not null 
		, Cigarets tinyint not null 
		, bmi_trnd tinyint not null 
		, posi_1_2_Ind tinyint not null 
		, posi_2_2_Ind tinyint not null 
		, posi_3_Ind tinyint not null 
		, NoNSAIDS_Ind tinyint not null 
		, NumRel tinyint not null 
		, Five_yr_Abs_Risk numeric(7,6) null 
		, Ten_yr_Abs_Risk numeric(7,6) null 
		, Twenty_yr_Abs_Risk numeric(7,6) null 
		, Life_Abs_Risk numeric(7,6) not null 
		, Race varchar(50) not null
		)

	--indices
	create unique clustered index ux_female_pid_age_race on Female(Age, Pattrn_ID, Race)
	create unique clustered index ux_male_pid_age_race on Male(Age, Pattrn_ID, Race)
