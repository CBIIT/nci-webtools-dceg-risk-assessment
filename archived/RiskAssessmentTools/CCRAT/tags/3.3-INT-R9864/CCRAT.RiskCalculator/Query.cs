/**************************************************************************************************
* Name		: Query.cs
* Purpose	: Query class for Colorectal Cancer Risk Assessment Tool(CCRAT)
* Author	: SRamaiah
* Date		: 10/15/2008
* Changes	: 
**************************************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using NCI.Data;
using Common.Utils;

namespace CCRAT.RiskCalculator
{
    public class Query
    {
        private static string _connectionString = string.Empty;

        static Query()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();
        }

        /// <summary>
        /// Returns datarow with five year abs risk and life time abs risk
        /// </summary>
        /// <param name="question"></param>
        /// <returns></returns>
        public static DataRow GetRisks(
            int currentAge
            , int gender
            , int patternID
            , Race race

        )
        {
            string stp = "dbo.GetRisks";
           
            DataRow dr;

            stp = Helper.ReadConfigSetting("stpGetRisks", stp);

            //HACK: recode American Indian or Alaskan Native to white
            if (race == Race.Indian)
                race = Race.White;

            SqlParameter[] sqlParams = {
                new SqlParameter("@age", SqlDbType.TinyInt)
                , new SqlParameter("@patternID", SqlDbType.SmallInt)
                , new SqlParameter("@gender", SqlDbType.SmallInt)
                , new SqlParameter("@race", SqlDbType.TinyInt)
            };

            sqlParams[0].Value = currentAge;
            sqlParams[1].Value = patternID;
            sqlParams[2].Value = gender;
            sqlParams[3].Value = (int)race;

            dr = SqlHelper.ExecuteDatarow(
                _connectionString
                , CommandType.StoredProcedure
                , stp
                , sqlParams);

            return dr;
        }
    }
}
