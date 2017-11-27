using CCRAT.RiskCalculator;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Reflection;
/**************************************************************************************************
* Name		: CCRATUnitTests.cs
* Purpose	: Contains unit test cases for both white men and women
* Author	: SRamaiah
* Date		: 10/15/2008
* Changes	: 02/27/2009 SR: updated to include test cases for other races
**************************************************************************************************/
namespace CCRAT.Test
{

    /// <summary>
    ///This is a test class for CCRAT Risk Calculator and is intended
    ///to contain some if not all Unit Tests
    ///</summary>
    [TestClass()]
    public class CCRATUnitTests
    {
        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        // 
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion

        #region Test Cases for white men

        /// <summary>
        ///A test for CalculateRisks for 50 year old Male
        ///</summary>
        [TestMethod()]
        public void TC_Male_White_50_14401()
        {
            string errorMsg = System.Reflection.MethodBase.GetCurrentMethod() + " Failed";
            AbsoluteRisks expected = new AbsoluteRisks(Race.White, "Male", 50, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.000856m, 0.002333m, 0.007785m, 0.019979m, 14401, 0);
            try
            {
                string hispanic = "No";
                string race = "White";
                string currentAge = "50";
                string gender = "Male";
                string height = "72"; //inches
                string weight = "177"; //lbs
                string numServingsVeg = "11"; //Text="More than 10 servings per week" Value="11"
                string amountVeg = "1"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "Yes";
                string hadPolyp = "No";
                string asprin = "Yes";
                string ibuprofen = "Yes";
                string cigs100More = "No";
                string smokeStartAge = string.Empty;
                string stillSmoke = string.Empty;
                string ageQuit = string.Empty;
                string quitNumPerDay = string.Empty;
                string vigorousActivities = "0";
                string vigorousHours = string.Empty;
                string stillHavePeriods = string.Empty;
                string lastCycle = string.Empty;
                string usedEstrogen = string.Empty;
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        /// <summary>
        ///A test for CalculateRisks for 85 year old Male with smoking
        ///</summary>
        [TestMethod()]
        public void TC_Male_White_85_17860()
        {
            string errorMsg = MethodBase.GetCurrentMethod() + " Failed";
            AbsoluteRisks expected = new AbsoluteRisks(Race.White, "Male", 85, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.005591m, 00.005591m, 0.005591m, 0.005591m, 17860, 0);
            try
            {
                string hispanic = "No";
                string race = "White";
                string currentAge = "85";
                string gender = "Male";
                string height = "72"; //inches
                string weight = "177"; //lbs
                string numServingsVeg = "11"; //Text="More than 10 servings per week" Value="11"
                string amountVeg = "1"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "Yes";
                string hadPolyp = "No";
                string asprin = "Yes";
                string ibuprofen = "Yes";
                string cigs100More = "Yes";
                string smokeStartAge = "30";
                string stillSmoke = "No"; //<add key="stillSmoke" value = "Yes, No"></add>
                string ageQuit = "70";
                string quitNumPerDay = "1To10";    //{ "1To10, 11To20, GT20" }
                string vigorousActivities = "0";
                string vigorousHours = string.Empty;
                string stillHavePeriods = string.Empty;
                string lastCycle = string.Empty;
                string usedEstrogen = string.Empty;
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        #endregion Test Cases for white men

        #region Test Cases for black men

        /// <summary>
        ///A test for CalculateRisks for 50 year old Male
        ///</summary>
        [TestMethod()]
        public void TC_Male_Black_50_14401()
        {
            string errorMsg = System.Reflection.MethodBase.GetCurrentMethod() + " Failed";
            AbsoluteRisks expected = new AbsoluteRisks(Race.Black, "Male", 50, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.001234m, 0.003034m, 0.008450m, 0.017226m, 14401, 0);
            try
            {
                string hispanic = "No";
                string race = "Black";
                string currentAge = "50";
                string gender = "Male";
                string height = "72"; //inches
                string weight = "177"; //lbs
                string numServingsVeg = "11"; //Text="More than 10 servings per week" Value="11"
                string amountVeg = "1"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "Yes";
                string hadPolyp = "No";
                string asprin = "Yes";
                string ibuprofen = "Yes";
                string cigs100More = "No";
                string smokeStartAge = string.Empty;
                string stillSmoke = string.Empty;
                string ageQuit = string.Empty;
                string quitNumPerDay = string.Empty;
                string vigorousActivities = "0";
                string vigorousHours = string.Empty;
                string stillHavePeriods = string.Empty;
                string lastCycle = string.Empty;
                string usedEstrogen = string.Empty;
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        /// <summary>
        ///A test for CalculateRisks for 85 year old Male with smoking
        ///</summary>
        [TestMethod()]
        public void TC_Male_Black_85_17860()
        {
            string errorMsg = MethodBase.GetCurrentMethod() + " Failed";
            AbsoluteRisks expected = new AbsoluteRisks(Race.Black, "Male", 85, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.005100m, 0.005100m, 0.005100m, 0.005100m, 17860, 0);
            try
            {
                string hispanic = "No";
                string race = "Black";
                string currentAge = "85";
                string gender = "Male";
                string height = "72"; //inches
                string weight = "177"; //lbs
                string numServingsVeg = "11"; //Text="More than 10 servings per week" Value="11"
                string amountVeg = "1"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "Yes";
                string hadPolyp = "No";
                string asprin = "Yes";
                string ibuprofen = "Yes";
                string cigs100More = "Yes";
                string smokeStartAge = "30";
                string stillSmoke = "No"; //<add key="stillSmoke" value = "Yes, No"></add>
                string ageQuit = "70";
                string quitNumPerDay = "1To10";    //{ "1To10, 11To20, GT20" }
                string vigorousActivities = "0";
                string vigorousHours = string.Empty;
                string stillHavePeriods = string.Empty;
                string lastCycle = string.Empty;
                string usedEstrogen = string.Empty;
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        #endregion Test Cases for black men

        #region Test Cases for hispanic men

        [TestMethod()]
        public void TC_Male_Hispanic_50_14401()
        {
            string errorMsg = System.Reflection.MethodBase.GetCurrentMethod() + " Failed";
            AbsoluteRisks expected = new AbsoluteRisks(Race.Hispanic, "Male", 50, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.000703m, 0.001765m, 0.006121m, 0.016159m, 14401, 0);
            try
            {
                string hispanic = "Yes";
                string race = "Hispanic";
                string currentAge = "50";
                string gender = "Male";
                string height = "72"; //inches
                string weight = "177"; //lbs
                string numServingsVeg = "11"; //Text="More than 10 servings per week" Value="11"
                string amountVeg = "1"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "Yes";
                string hadPolyp = "No";
                string asprin = "Yes";
                string ibuprofen = "Yes";
                string cigs100More = "No";
                string smokeStartAge = string.Empty;
                string stillSmoke = string.Empty;
                string ageQuit = string.Empty;
                string quitNumPerDay = string.Empty;
                string vigorousActivities = "0";
                string vigorousHours = string.Empty;
                string stillHavePeriods = string.Empty;
                string lastCycle = string.Empty;
                string usedEstrogen = string.Empty;
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        [TestMethod()]
        public void TC_Male_Hispanic_85_17860()
        {
            string errorMsg = MethodBase.GetCurrentMethod() + " Failed";
            AbsoluteRisks expected = new AbsoluteRisks(Race.Hispanic, "Male", 85, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.003733m, 0.003733m, 0.003733m, 0.003733m, 17860, 0);
            try
            {
                string hispanic = "Yes";
                string race = "Hispanic";
                string currentAge = "85";
                string gender = "Male";
                string height = "72"; //inches
                string weight = "177"; //lbs
                string numServingsVeg = "11"; //Text="More than 10 servings per week" Value="11"
                string amountVeg = "1"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "Yes";
                string hadPolyp = "No";
                string asprin = "Yes";
                string ibuprofen = "Yes";
                string cigs100More = "Yes";
                string smokeStartAge = "30";
                string stillSmoke = "No"; //<add key="stillSmoke" value = "Yes, No"></add>
                string ageQuit = "70";
                string quitNumPerDay = "1To10";    //{ "1To10, 11To20, GT20" }
                string vigorousActivities = "0";
                string vigorousHours = string.Empty;
                string stillHavePeriods = string.Empty;
                string lastCycle = string.Empty;
                string usedEstrogen = string.Empty;
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        #endregion Test Cases for hispanic men

        #region Test Cases for Asian men

        [TestMethod()]
        public void TC_Male_Asian_50_14401()
        {
            string errorMsg = System.Reflection.MethodBase.GetCurrentMethod() + " Failed";
            AbsoluteRisks expected = new AbsoluteRisks(Race.Asian, "Male", 50, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.000852m, 0.002291m, 0.007424m, 0.023921m, 14401, 0);
            try
            {
                string hispanic = "No";
                string race = "Asian";
                string currentAge = "50";
                string gender = "Male";
                string height = "72"; //inches
                string weight = "177"; //lbs
                string numServingsVeg = "11"; //Text="More than 10 servings per week" Value="11"
                string amountVeg = "1"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "Yes";
                string hadPolyp = "No";
                string asprin = "Yes";
                string ibuprofen = "Yes";
                string cigs100More = "No";
                string smokeStartAge = string.Empty;
                string stillSmoke = string.Empty;
                string ageQuit = string.Empty;
                string quitNumPerDay = string.Empty;
                string vigorousActivities = "0";
                string vigorousHours = string.Empty;
                string stillHavePeriods = string.Empty;
                string lastCycle = string.Empty;
                string usedEstrogen = string.Empty;
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        [TestMethod()]
        public void TC_Male_Asian_85_17860()
        {
            string errorMsg = MethodBase.GetCurrentMethod() + " Failed";
            AbsoluteRisks expected = new AbsoluteRisks(Race.Asian, "Male", 85, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.005398m, 0.005398m, 0.005398m, 0.005398m, 17860, 0);
            try
            {
                string hispanic = "No";
                string race = "Asian";
                string currentAge = "85";
                string gender = "Male";
                string height = "72"; //inches
                string weight = "177"; //lbs
                string numServingsVeg = "11"; //Text="More than 10 servings per week" Value="11"
                string amountVeg = "1"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "Yes";
                string hadPolyp = "No";
                string asprin = "Yes";
                string ibuprofen = "Yes";
                string cigs100More = "Yes";
                string smokeStartAge = "30";
                string stillSmoke = "No"; //<add key="stillSmoke" value = "Yes, No"></add>
                string ageQuit = "70";
                string quitNumPerDay = "1To10";    //{ "1To10, 11To20, GT20" }
                string vigorousActivities = "0";
                string vigorousHours = string.Empty;
                string stillHavePeriods = string.Empty;
                string lastCycle = string.Empty;
                string usedEstrogen = string.Empty;
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        #endregion Test Cases for Asian men

        #region Test Cases for white women

        /// <summary>
        ///A test for CalculateRisks for 74 year old Female
        ///</summary>
        [TestMethod()]
        public void TC_Female_White_74_730()
        {
            string errorMsg = MethodBase.GetCurrentMethod() + " Failed";

            //passed
            AbsoluteRisks expected = new AbsoluteRisks(Race.White, "Female", 74, 0, 1, 1, 1, 1, 0, 3, 0.021485m, 0.042906m, 0.061039m, 0.061039m, 730, 0);

            try
            {
                string hispanic = "No";
                string race = "White";
                string currentAge = "74";
                string gender = "Female";
                string height = "74"; //inches
                string weight = "123"; //lbs
                string numServingsVeg = "0"; //Text="None" Value="0"
                string amountVeg = "NaN"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "No";
                string hadPolyp = "No";
                string asprin = "No";
                string ibuprofen = "No";
                string cigs100More = string.Empty;
                string smokeStartAge = string.Empty;
                string stillSmoke = string.Empty;
                string ageQuit = string.Empty;
                string quitNumPerDay = string.Empty;
                string vigorousActivities = "4";
                string vigorousHours = "1.5";    //Text="Between 1 and 2 hours per week" Value="1.5"
                string stillHavePeriods = "No";
                string lastCycle = "GT2";    //Text="2 years ago or more" Value="GT2"
                string usedEstrogen = "No";
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }
        #endregion Test Cases for white women

        #region Test Cases for black women

        /// <summary>
        ///A test for CalculateRisks for 74 year old Female
        ///</summary>
        [TestMethod()]
        public void TC_Female_Black_74_730()
        {
            string errorMsg = System.Reflection.MethodBase.GetCurrentMethod() + " Failed";

            //expected result
            AbsoluteRisks expected = new AbsoluteRisks(Race.Black, "Female", 74, 0, 1, 1, 1, 1, 0, 3, 0.021759m, 0.041117m, 0.055641m, 0.055641m, 730, 0);

            try
            {
                string hispanic = "No";
                string race = "Black";
                string currentAge = "74";
                string gender = "Female";
                string height = "74"; //inches
                string weight = "123"; //lbs
                string numServingsVeg = "0"; //Text="None" Value="0"
                string amountVeg = "NaN"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "No";
                string hadPolyp = "No";
                string asprin = "No";
                string ibuprofen = "No";
                string cigs100More = string.Empty;
                string smokeStartAge = string.Empty;
                string stillSmoke = string.Empty;
                string ageQuit = string.Empty;
                string quitNumPerDay = string.Empty;
                string vigorousActivities = "4";
                string vigorousHours = "1.5";    //Text="Between 1 and 2 hours per week" Value="1.5"
                string stillHavePeriods = "No";
                string lastCycle = "GT2";    //Text="2 years ago or more" Value="GT2"
                string usedEstrogen = "No";
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }


        #endregion Test Cases for black women

        #region Test Cases for Hispanic women

        [TestMethod()]
        public void TC_Female_Hispanic_74_730()
        {
            string errorMsg = System.Reflection.MethodBase.GetCurrentMethod() + " Failed";

            //expected result
            AbsoluteRisks expected = new AbsoluteRisks(Race.Hispanic, "Female", 74, 0, 1, 1, 1, 1, 0, 3, 0.013967m, 0.028298m, 0.042503m, 0.042503m, 730, 0);

            try
            {
                string hispanic = "Yes";
                string race = "Hispanic";
                string currentAge = "74";
                string gender = "Female";
                string height = "74"; //inches
                string weight = "123"; //lbs
                string numServingsVeg = "0"; //Text="None" Value="0"
                string amountVeg = "NaN"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "No";
                string hadPolyp = "No";
                string asprin = "No";
                string ibuprofen = "No";
                string cigs100More = string.Empty;
                string smokeStartAge = string.Empty;
                string stillSmoke = string.Empty;
                string ageQuit = string.Empty;
                string quitNumPerDay = string.Empty;
                string vigorousActivities = "4";
                string vigorousHours = "1.5";    //Text="Between 1 and 2 hours per week" Value="1.5"
                string stillHavePeriods = "No";
                string lastCycle = "GT2";    //Text="2 years ago or more" Value="GT2"
                string usedEstrogen = "No";
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }


        #endregion Test Cases for Hispanic women

        #region Test Cases for Asian women

        [TestMethod()]
        public void TC_Female_Asian_74_730()
        {
            string errorMsg = System.Reflection.MethodBase.GetCurrentMethod() + " Failed";

            //expected result
            AbsoluteRisks expected = new AbsoluteRisks(Race.Asian, "Female", 74, 0, 1, 1, 1, 1, 0, 3, 0.016691m, 0.037150m, 0.059767m, 0.059767m, 730, 0);

            try
            {
                string hispanic = "No";
                string race = "Asian";
                string currentAge = "74";
                string gender = "Female";
                string height = "74"; //inches
                string weight = "123"; //lbs
                string numServingsVeg = "0"; //Text="None" Value="0"
                string amountVeg = "NaN"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "No";
                string hadPolyp = "No";
                string asprin = "No";
                string ibuprofen = "No";
                string cigs100More = string.Empty;
                string smokeStartAge = string.Empty;
                string stillSmoke = string.Empty;
                string ageQuit = string.Empty;
                string quitNumPerDay = string.Empty;
                string vigorousActivities = "4";
                string vigorousHours = "1.5";    //Text="Between 1 and 2 hours per week" Value="1.5"
                string stillHavePeriods = "No";
                string lastCycle = "GT2";    //Text="2 years ago or more" Value="GT2"
                string usedEstrogen = "No";
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }


        #endregion Test Cases for Asian women


        /// <summary>
        ///A test for CalculateRisks for 50 year old Male with confidence
        ///All up and low should be higher than 0
        ///</summary>
        [TestMethod()]
        public void TC_Male_White_50_14401_WithConfidence()
        {
            string errorMsg = System.Reflection.MethodBase.GetCurrentMethod() + " Failed";
            AbsoluteRisks expected = new AbsoluteRisks(Race.White, "Male", 50, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.000856m, 0.002333m, 0.007785m, 0.019979m, 14401, 0);
            try
            {
                string hispanic = "No";
                string race = "White";
                string currentAge = "50";
                string gender = "Male";
                string height = "72"; //inches
                string weight = "177"; //lbs
                string numServingsVeg = "11"; //Text="More than 10 servings per week" Value="11"
                string amountVeg = "1"; //Text="More than 1/2 cup but less than 1 1/2 cups" Value="1"
                string colonoscopy = "Yes";
                string hadPolyp = "No";
                string asprin = "Yes";
                string ibuprofen = "Yes";
                string cigs100More = "No";
                string smokeStartAge = string.Empty;
                string stillSmoke = string.Empty;
                string ageQuit = string.Empty;
                string quitNumPerDay = string.Empty;
                string vigorousActivities = "0";
                string vigorousHours = string.Empty;
                string stillHavePeriods = string.Empty;
                string lastCycle = string.Empty;
                string usedEstrogen = string.Empty;
                string hasRelativeHadCC = "No";
                string numRelativesHavingCC = string.Empty;

                AbsoluteRisks actual;
                actual = Manager.CalculateRisks(hispanic, race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue((actual.AbsRisk05L>0 && actual.AbsRisk05U>0 && actual.AbsRisk10L >0 && actual.AbsRisk10U >0 && actual.AbsRisk20L>0 && actual.AbsRisk20U >0 && actual.AbsRiskLTU >0 && actual.AbsRskLTL >0 ), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        #region Other Common Methods

        /// <summary>
        /// Compare two risks objects
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        /// <returns>true if they are same otherwise, false</returns>
        public bool CompareRisks(AbsoluteRisks expected, AbsoluteRisks actual)
        {
            //TODO: this can be moved to AbsoluteRisks by overriding Equals virtual method.
            bool ret = false;

            ret = (expected.PatternID == actual.PatternID)
                  && (expected.CurrentAge == actual.CurrentAge)
                  && (expected.Numrel == actual.Numrel)
                  && (expected.NoNSaids == actual.NoNSaids)
                  && (expected.Sigmod == actual.Sigmod)
                  && (expected.VegLT5 == actual.VegLT5)
                  && (expected.NoStrogen == actual.NoStrogen)
                  && (expected.HrsExcrise == actual.HrsExcrise)
                  && (expected.FiveYearAbsRisk == actual.FiveYearAbsRisk)
                  && (expected.TenYearAbsRisk == actual.TenYearAbsRisk)
                  && (expected.LifetimeAbsRisk == actual.LifetimeAbsRisk)
                  && (expected.BmiTrnd == actual.BmiTrnd)
                  && (expected.Gender.Equals(actual.Gender, StringComparison.OrdinalIgnoreCase))
                  && (expected.Race.Equals(actual.Race, StringComparison.OrdinalIgnoreCase));

            return ret;

        }

        #endregion Other Common Methods
    }
}

