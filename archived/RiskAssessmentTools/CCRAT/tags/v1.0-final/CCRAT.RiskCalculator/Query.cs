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

        )
        {
            string sql = string.Empty;
            DataRow dr;

            string stp = "dbo.GetRisks";
            //stp = ConfigurationManager.AppSettings["stpGetMaleRisks"].ToString();

            SqlParameter[] sqlParams = {
                new SqlParameter("@age", SqlDbType.TinyInt)
                , new SqlParameter("@patternID", SqlDbType.SmallInt)
                , new SqlParameter("@gender", SqlDbType.SmallInt)
            };


            sqlParams[0].Value = currentAge;
            sqlParams[1].Value = patternID;
            sqlParams[2].Value = gender;


            dr = SqlHelper.ExecuteDatarow(
                _connectionString
                , CommandType.StoredProcedure
                , stp
                , sqlParams);

            return dr;
        }


        /// <summary>
        /// Returns datarow with five year abs risk and life time abs risk
        /// </summary>
        /// <param name="question"></param>
        /// <returns></returns>
        public static DataRow GetRisks(
            Questions question
        )
        {
            string sql = string.Empty;
            DataRow dr;

            string stp = "dbo.GetMaleRisks";
            //stp = ConfigurationManager.AppSettings["stpGetMaleRisks"].ToString();

            SqlParameter[] sqlParams = {
                new SqlParameter("@age", SqlDbType.TinyInt)
                , new SqlParameter("@patternID", SqlDbType.SmallInt)
                , new SqlParameter("@gender", SqlDbType.SmallInt)
            };


            sqlParams[0].Value = question.Age;
            sqlParams[1].Value = question.PatternID;

            dr = SqlHelper.ExecuteDatarow(
                _connectionString
                , CommandType.StoredProcedure
                , stp
                , sqlParams);

            return dr;
        }

    }
}
