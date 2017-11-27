using CCRAT.RiskCalculator;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
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

        #region Test Cases for Male

        /// <summary>
        ///A test for CalculateRisks for 50 year old Male
        ///</summary>
        [TestMethod()]
        public void CalculateRisksTC50Male14401()
        {
            string errorMsg = "Unit Test: TC50Male14401 Failed";
            AbsoluteRisks expected = new AbsoluteRisks("Male", 50, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.000856m, 0.002333m, 0.007785m, 0.019979m, 14401, 0);
            try
            {
                string race = string.Empty;
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
                actual = Manager.CalculateRisks(race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
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
        public void CalculateRisksTC85Male17860()
        {
            string errorMsg = "Unit Test: TC85Male17860 Failed";
            AbsoluteRisks expected = new AbsoluteRisks("Male", 85, 0, 0, 0, 0, 0, 0, 1, 0, 3, 0.005591m, 00.005591m, 0.005591m, 0.005591m, 17860, 0);
            try
            {
                string race = string.Empty;
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
                actual = Manager.CalculateRisks(race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        #endregion Test Cases for Male

        #region Test Cases for Female

        /// <summary>
        ///A test for CalculateRisks for 74 year old Female
        ///</summary>
        [TestMethod()]
        public void CalculateRisks_Female74_730()
        {
            string errorMsg = "Unit Test: TC74Female730 Failed";

            //passed
            AbsoluteRisks expected = new AbsoluteRisks("Female", 74, 0, 1, 1, 1, 1, 0, 3, 0.021485m, 0.042906m, 0.061039m, 0.061039m, 730, 0);

            //failed
            //AbsoluteRisks expected = new AbsoluteRisks("Female", 74, 0, 1, 1, 1, 1, 0, 3, 0.021485m, 0.042906m, 0.061039m, 0.061039m, 731, 0);

            try
            {
                string race = string.Empty;
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
                actual = Manager.CalculateRisks(race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        /// <summary>
        ///A test for CalculateRisks for 74 year old Female
        ///</summary>
        [TestMethod()]
        public void CalculateRisks_Female50_1()
        {
            //1,50,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.000348,0.000927,0.003058,0.009413
            string errorMsg = "Unit Test: TC74Female730 Failed";

            //passed
            AbsoluteRisks expected = new AbsoluteRisks("Female", 74, 0, 1, 1, 1, 1, 0, 3, 0.021485m, 0.042906m, 0.061039m, 0.061039m, 730, 0);

            //failed
            //AbsoluteRisks expected = new AbsoluteRisks("Female", 74, 0, 1, 1, 1, 1, 0, 3, 0.021485m, 0.042906m, 0.061039m, 0.061039m, 731, 0);

            try
            {
                string race = string.Empty;
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
                actual = Manager.CalculateRisks(race, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                Assert.IsTrue(CompareRisks(expected, actual), errorMsg);
            }
            catch (Exception ex)
            {
                throw new Exception(errorMsg, ex);
            }
        }

        #endregion Test Cases for Female

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
                  && (expected.BmiTrnd == actual.BmiTrnd);

            return ret;

        }
        
        #endregion Other Common Methods
    }
}
