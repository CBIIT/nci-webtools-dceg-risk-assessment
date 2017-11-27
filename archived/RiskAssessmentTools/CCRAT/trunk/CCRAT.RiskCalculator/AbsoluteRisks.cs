/**************************************************************************************************
* Name		: AbsoluteRisks.cs
* Purpose	: Has both Absolute and Average Risks values
* Author	: SRamaiah
* Date		: 10/16/2008
* Changes	: 03/13/2009 SR: Updated to include average risks
**************************************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CCRAT.RiskCalculator;
namespace CCRAT.RiskCalculator
{
    public class AbsoluteRisks
    {
        #region private variables

        //variables for absolute risks
        private decimal _fiveYearAbsRisk;
        private decimal _tenYearAbsRisk;
        private decimal _twentyYearAbsRisk;
        private decimal _lifetimeAbsRisk;

        //variables for average risks
        private decimal _fiveYearAvgRisk;
        private decimal _tenYearAvgRisk ;
        private decimal _lifetimeAvgRisk;

        //variables for  risks confidence
        private decimal _absRisk05L;
        private decimal _absRisk05U;
        private decimal _absRisk10L;
        private decimal _absRisk10U;
        private decimal _absRisk20L;
        private decimal _absRisk20U;
        private decimal _absRiskLTL;
        private decimal _absRiskLTU;

        private int _patternID;

        private bool _is5YrRiskValid;
        private bool _is10YrRiskValid;          
        private bool _is20YrRiskValid;

        private int _numDecimalPlaces = 1;
        private bool _isPatternFoundInDB;
   
        private string _gender, _currentAge, _numrel, _cigarets, _duration, _noNSaids, _noIbuprofn, _sigmod, _vegLT5, _bmiTrnd, _hrsExcrise, _noStrogen, _bmiGe30;
        private Race _race;
        private decimal _bmi;
              
        #endregion private variables

        #region constructors

        /// <summary>
        /// AbsoluteRisks constructor for male without abs risks
        /// </summary>
        /// <param name="gender"></param>
        /// <param name="currentAge"></param>
        /// <param name="numrel"></param>
        /// <param name="cigarets"></param>
        /// <param name="duration"></param>
        /// <param name="noNSaids"></param>
        /// <param name="noIbuprofn"></param>
        /// <param name="sigmod"></param>
        /// <param name="vegLT5"></param>
        /// <param name="bmiTrnd"></param>
        /// <param name="hrsExcrise"></param>
        /// <param name="fiveYearAbsRisk"></param>
        /// <param name="tenYearAbsRisk"></param>
        /// <param name="twentyYearAbsRisk"></param>
        /// <param name="lifetimeAbsRisk"></param>
        /// <param name="patternID"></param>
        public AbsoluteRisks(Race race, string gender, int currentAge, int numrel, int cigarets, int duration, int noNSaids, int noIbuprofn, int sigmod, int vegLT5, int bmiTrnd, int hrsExcrise, int patternID, bool isPatternFoundInDB, decimal bmi)
        {
            //answers
            _race = race;
            _gender = gender.ToString();
            _currentAge = currentAge.ToString();
            _duration = duration.ToString();
            _numrel = numrel.ToString();
            _cigarets = cigarets.ToString();
            _noNSaids = noNSaids.ToString();
            _noIbuprofn = noIbuprofn.ToString();
            _sigmod = sigmod.ToString();
            _vegLT5 = vegLT5.ToString();
            _bmiTrnd = bmiTrnd.ToString();
            _hrsExcrise = hrsExcrise.ToString();
            _patternID = patternID;
            _isPatternFoundInDB = isPatternFoundInDB;
            _bmi = bmi;
            CheckAbsRisks();

        }

        /// <summary>
        /// AbsoluteRisks constructor for male with abs risks
        /// </summary>
        /// <param name="gender"></param>
        /// <param name="currentAge"></param>
        /// <param name="numrel"></param>
        /// <param name="cigarets"></param>
        /// <param name="duration"></param>
        /// <param name="noNSaids"></param>
        /// <param name="noIbuprofn"></param>
        /// <param name="sigmod"></param>
        /// <param name="vegLT5"></param>
        /// <param name="bmiTrnd"></param>
        /// <param name="hrsExcrise"></param>
        /// <param name="fiveYearAbsRisk"></param>
        /// <param name="tenYearAbsRisk"></param>
        /// <param name="twentyYearAbsRisk"></param>
        /// <param name="lifetimeAbsRisk"></param>
        /// <param name="patternID"></param>
        /// <param name="fiveYearAbsRisk"></param>
        /// <param name="tenYearAbsRisk"></param>
        /// <param name="twentyYearAbsRisk"></param>
        /// <param name="lifetimeAbsRisk"></param>
        /// <param name="patternID"></param>
        public AbsoluteRisks(Race race, string gender, int currentAge, int numrel, int cigarets, int duration, int noNSaids, int noIbuprofn, int sigmod, int vegLT5, int bmiTrnd, int hrsExcrise, decimal fiveYearAbsRisk, decimal tenYearAbsRisk, decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID, decimal bmi)
            : this(race, gender, currentAge, numrel, cigarets, duration, noNSaids, noIbuprofn, sigmod, vegLT5, bmiTrnd, hrsExcrise, patternID, true, bmi)           
        {            
           InitAbsRisks(fiveYearAbsRisk, tenYearAbsRisk, twentyYearAbsRisk, lifetimeAbsRisk, patternID);
        }

        /// <summary>
        /// Constructor with both Absolute and Average Risks for Male
        /// </summary>
        /// <param name="race"></param>
        /// <param name="gender"></param>
        /// <param name="currentAge"></param>
        /// <param name="numrel"></param>
        /// <param name="cigarets"></param>
        /// <param name="duration"></param>
        /// <param name="noNSaids"></param>
        /// <param name="noIbuprofn"></param>
        /// <param name="sigmod"></param>
        /// <param name="vegLT5"></param>
        /// <param name="bmiTrnd"></param>
        /// <param name="hrsExcrise"></param>
        /// <param name="fiveYearAbsRisk"></param>
        /// <param name="tenYearAbsRisk"></param>
        /// <param name="twentyYearAbsRisk"></param>
        /// <param name="lifetimeAbsRisk"></param>
        /// <param name="patternID"></param>
        /// <param name="bmi"></param>
        /// <param name="fiveYearAvgRisk"></param>
        /// <param name="tenYearAvgRisk"></param>
        /// <param name="lifetimeAvgRisk"></param>
        public AbsoluteRisks(Race race, string gender, int currentAge, int numrel, int cigarets, int duration, int noNSaids, int noIbuprofn, int sigmod, int vegLT5, int bmiTrnd, int hrsExcrise, decimal fiveYearAbsRisk, decimal tenYearAbsRisk, decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID, decimal bmi
            , decimal fiveYearAvgRisk, decimal tenYearAvgRisk, decimal lifetimeAvgRisk
        )
            : this(race, gender, currentAge, numrel, cigarets, duration, noNSaids, noIbuprofn, sigmod, vegLT5, bmiTrnd, hrsExcrise, fiveYearAbsRisk, tenYearAbsRisk, twentyYearAbsRisk, lifetimeAbsRisk, patternID, bmi)
        {
            InitAvgRisks(fiveYearAvgRisk, tenYearAvgRisk, lifetimeAvgRisk);
        }

        /// <summary>
        /// New CCRAT Risk with Confidence
        /// </summary>
        /// <param name="race"></param>
        /// <param name="gender"></param>
        /// <param name="currentAge"></param>
        /// <param name="numrel"></param>
        /// <param name="cigarets"></param>
        /// <param name="duration"></param>
        /// <param name="noNSaids"></param>
        /// <param name="noIbuprofn"></param>
        /// <param name="sigmod"></param>
        /// <param name="vegLT5"></param>
        /// <param name="bmiTrnd"></param>
        /// <param name="hrsExcrise"></param>
        /// <param name="fiveYearAbsRisk"></param>
        /// <param name="absRsk_05_L"></param>
        /// <param name="absRsk_05_U"></param>
        /// <param name="tenYearAbsRisk"></param>
        /// <param name="twentyYearAbsRisk"></param>
        /// <param name="lifetimeAbsRisk"></param>
        /// <param name="patternID"></param>
        /// <param name="bmi"></param>
        public AbsoluteRisks(Race race, string gender, int currentAge, int numrel, int cigarets, int duration, int noNSaids, int noIbuprofn, int sigmod, int vegLT5, int bmiTrnd, int hrsExcrise, decimal fiveYearAbsRisk, decimal tenYearAbsRisk,  decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID, decimal bmi
             , decimal fiveYearAvgRisk, decimal tenYearAvgRisk, decimal lifetimeAvgRisk,
            decimal absRsk_05_L, decimal absRsk_05_U,decimal absRsk_10_L, decimal absRsk_10_U, decimal absRsk_20_L, decimal absRsk_20_U, decimal absRsk_LT_L, decimal absRsk_LT_U)
            : this(race, gender, currentAge, numrel, cigarets, duration, noNSaids, noIbuprofn, sigmod, vegLT5, bmiTrnd, hrsExcrise, patternID, true, bmi)
        {
            InitAbsRisks(fiveYearAvgRisk, tenYearAvgRisk, lifetimeAvgRisk, absRsk_05_L, absRsk_05_U, absRsk_10_L, absRsk_10_U, absRsk_20_L, absRsk_20_U, absRsk_LT_L, absRsk_LT_U);
            InitAbsRisks(fiveYearAbsRisk, tenYearAbsRisk, twentyYearAbsRisk, lifetimeAbsRisk, patternID);

        }

        /// <summary>
        /// AbsoluteRisks constructor for female without abs risks
        /// </summary>
        /// <param name="gender"></param>
        /// <param name="currentAge"></param>
        /// <param name="numrel"></param>
        /// <param name="cigarets"></param>
        /// <param name="duration"></param>
        /// <param name="noNSaids"></param>
        /// <param name="noIbuprofn"></param>
        /// <param name="sigmod"></param>
        /// <param name="vegLT5"></param>
        /// <param name="bmiTrnd"></param>
        /// <param name="hrsExcrise"></param>
        public AbsoluteRisks(Race race, string gender, int currentAge, int numrel, int noStrogen, int noNSaids, int sigmod, int vegLT5, int bmiGe30, int hrsExcrise, int patternID, bool isPatternFoundInDB, decimal bmi)
        {
            //answers
            _race = race;
            _gender = gender;
            _currentAge = currentAge.ToString();
            _numrel = numrel.ToString();
            _noStrogen = noStrogen.ToString();
            _noNSaids = noNSaids.ToString();
            _sigmod = sigmod.ToString();
            _vegLT5 = vegLT5.ToString();
            _bmiGe30 = bmiGe30.ToString();
            _hrsExcrise = hrsExcrise.ToString();
            _patternID = patternID;
            _isPatternFoundInDB = isPatternFoundInDB;
            _bmi = bmi;
            CheckAbsRisks();
        }

        /// <summary>
        /// AbsoluteRisks constructor for female with abs risks
        /// </summary>
        /// <param name="gender"></param>
        /// <param name="currentAge"></param>
        /// <param name="numrel"></param>
        /// <param name="noStrogen"></param>
        /// <param name="noNSaids"></param>
        /// <param name="sigmod"></param>
        /// <param name="vegLT5"></param>
        /// <param name="bmiGe30"></param>
        /// <param name="hrsExcrise"></param>
        /// <param name="fiveYearAbsRisk"></param>
        /// <param name="tenYearAbsRisk"></param>
        /// <param name="twentyYearAbsRisk"></param>
        /// <param name="lifetimeAbsRisk"></param>
        /// <param name="patternID"></param>
        public AbsoluteRisks(Race race, string gender, int currentAge, int numrel, int noStrogen, int noNSaids, int sigmod, int vegLT5, int bmiGe30, int hrsExcrise, decimal fiveYearAbsRisk, decimal tenYearAbsRisk, decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID, decimal bmi)
            : this (race, gender, currentAge, numrel, noStrogen, noNSaids, sigmod, vegLT5, bmiGe30, hrsExcrise, patternID, true, bmi)
        {
            InitAbsRisks(fiveYearAbsRisk, tenYearAbsRisk, twentyYearAbsRisk, lifetimeAbsRisk, patternID);
        }

        /// <summary>
        /// Constructor with both Absolute and Average Risks for Female
        /// </summary>
        /// <param name="race"></param>
        /// <param name="gender"></param>
        /// <param name="currentAge"></param>
        /// <param name="numrel"></param>
        /// <param name="noStrogen"></param>
        /// <param name="noNSaids"></param>
        /// <param name="sigmod"></param>
        /// <param name="vegLT5"></param>
        /// <param name="bmiGe30"></param>
        /// <param name="hrsExcrise"></param>
        /// <param name="fiveYearAbsRisk"></param>
        /// <param name="tenYearAbsRisk"></param>
        /// <param name="twentyYearAbsRisk"></param>
        /// <param name="lifetimeAbsRisk"></param>
        /// <param name="patternID"></param>
        /// <param name="bmi"></param>
        /// <param name="fiveYearAvgRisk"></param>
        /// <param name="tenYearAvgRisk"></param>
        /// <param name="lifetimeAvgRisk"></param>
        public AbsoluteRisks(Race race, string gender, int currentAge, int numrel, int noStrogen, int noNSaids, int sigmod, int vegLT5, int bmiGe30, int hrsExcrise, decimal fiveYearAbsRisk, decimal tenYearAbsRisk, decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID, decimal bmi
            , decimal fiveYearAvgRisk, decimal tenYearAvgRisk, decimal lifetimeAvgRisk
        )
            : this(race,gender, currentAge, numrel, noStrogen, noNSaids, sigmod, vegLT5, bmiGe30, hrsExcrise, fiveYearAbsRisk, tenYearAbsRisk, twentyYearAbsRisk, lifetimeAbsRisk, patternID, bmi)
        {
            InitAvgRisks(fiveYearAvgRisk, tenYearAvgRisk, lifetimeAvgRisk);
        }

        public AbsoluteRisks(Race race, string gender, int currentAge, int numrel, int noStrogen, int noNSaids, int sigmod, int vegLT5, int bmiGe30, int hrsExcrise, decimal fiveYearAbsRisk, decimal tenYearAbsRisk, decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID, decimal bmi
            , decimal fiveYearAvgRisk, decimal tenYearAvgRisk, decimal lifetimeAvgRisk, 
            decimal absRsk_05_L, decimal absRsk_05_U,decimal absRsk_10_L, decimal absRsk_10_U, decimal absRsk_20_L, decimal absRsk_20_U, decimal absRsk_LT_L, decimal absRsk_LT_U
        )
            : this(race, gender, currentAge, numrel, noStrogen, noNSaids, sigmod, vegLT5, bmiGe30, hrsExcrise, fiveYearAbsRisk, tenYearAbsRisk, twentyYearAbsRisk, lifetimeAbsRisk, patternID, bmi)
        {
            InitAbsRisks(fiveYearAvgRisk, tenYearAvgRisk, lifetimeAvgRisk, absRsk_05_L, absRsk_05_U, absRsk_10_L, absRsk_10_U, absRsk_20_L, absRsk_20_U, absRsk_LT_L, absRsk_LT_U);
        }

        #endregion constructors

        #region Properties

        public decimal AbsRisk05L
        {
            get { return _absRisk05L; }
            set { _absRisk05L = value; }
        }

        public decimal AbsRisk05U
        {
            get { return _absRisk05U; }
            set { _absRisk05U = value; }
        }

        public decimal AbsRisk10L
        {
            get { return _absRisk10L; }
            set { _absRisk10L = value; }
        }
        public decimal AbsRisk10U
        {
            get { return _absRisk10U; }
            set { _absRisk10U = value; }
        }

        public decimal AbsRisk20L
        {
            get { return _absRisk20L; }
            set { _absRisk20L = value; }
        }

        public decimal AbsRisk20U
        {
            get { return _absRisk20U; }
            set { _absRisk20U = value; }
        }
        public decimal AbsRskLTL
        {
            get { return _absRiskLTL; }
            set { _absRiskLTL = value; }
        }

        public decimal AbsRiskLTU
        {
            get { return _absRiskLTU; }
            set { _absRiskLTU = value; }
        }

        


        public decimal FiveYearAbsRisk
        {
            get { return _fiveYearAbsRisk; }
            set { _fiveYearAbsRisk = value; }
        }

        public decimal FiveYearAbsRiskPercent
        {
            get { return Math.Round(_fiveYearAbsRisk * 100, _numDecimalPlaces, MidpointRounding.AwayFromZero); }
        }

        public decimal LifetimeAbsRisk
        {
            get { return _lifetimeAbsRisk; }
            set { _lifetimeAbsRisk = value; }
        }

        public decimal LifetimeAbsRiskPercent
        {
            get { return Math.Round(_lifetimeAbsRisk * 100, _numDecimalPlaces, MidpointRounding.AwayFromZero); }
        }

        public decimal TenYearAbsRisk
        {
            get { return _tenYearAbsRisk; }
            set { _tenYearAbsRisk = value; }
        }

        public decimal TenYearAbsRiskPercent
        {
            get { return Math.Round(_tenYearAbsRisk * 100, _numDecimalPlaces, MidpointRounding.AwayFromZero); }
        }

        public decimal TwentyYearAbsRisk
        {
            get { return _twentyYearAbsRisk; }
            set { _twentyYearAbsRisk = value; }
        }

        public decimal TwentyYearAbsRiskPercent
        {
            get { return Math.Round(_twentyYearAbsRisk * 100, _numDecimalPlaces, MidpointRounding.AwayFromZero); }
        }

        public int PatternID
        {
            get { return _patternID; }
            set { _patternID = value; }
        }
        
        public bool Is5YrRiskValid
        {
            get { return _is5YrRiskValid; }
            set { _is5YrRiskValid = value; }
        }

        public bool Is10YrRiskValid
        {
            get { return _is10YrRiskValid; }
            set { _is10YrRiskValid = value; }
        }

        public bool Is20YrRiskValid
        {
            get { return _is20YrRiskValid; }
            set { _is20YrRiskValid = value; }
        }

        public string Gender
        {
            get { return _gender; }
            set { _gender = value; }
        }

        public string Race
        {
            get
            {
                string ret = string.Empty;
                switch(_race)
                {
                    case CCRAT.RiskCalculator.Race.White:
                        ret = "White";
                        break;
                    case CCRAT.RiskCalculator.Race.Black:
                        ret = "Black or African-American";
                        break;
                    case CCRAT.RiskCalculator.Race.Indian:
                        ret = "American Indian or Alaska Native";
                        break;            
                    case CCRAT.RiskCalculator.Race.Hispanic:
                        ret = "Hispanic";
                        break;
                    case CCRAT.RiskCalculator.Race.Asian:
                        ret = "Asian or Pacific Islander";
                        break;
                    default:
                        ret = _race.ToString();
                        break;
                }
                return ret;
            }
        }

        public string CurrentAge
        {
            get { return _currentAge; }
            set { _currentAge = value; }
        }

        public string Numrel
        {
            get { return _numrel; }
            set { _numrel = value; }
        }

        public string Cigarets
        {
            get { return _cigarets; }
            set { _cigarets = value; }
        }

        public string Duration
        {
            get { return _duration; }
            set { _duration = value; }
        }

        public string NoNSaids
        {
            get { return _noNSaids; }
            set { _noNSaids = value; }
        }

        public string NoIbuprofn
        {
            get { return _noIbuprofn; }
            set { _noIbuprofn = value; }
        }

        public string Sigmod
        {
            get { return _sigmod; }
            set { _sigmod = value; }
        }

        public string VegLT5
        {
            get { return _vegLT5; }
            set { _vegLT5 = value; }
        }

        public string BmiTrnd
        {
            get { return _bmiTrnd; }
            set { _bmiTrnd = value; }
        }

        public string HrsExcrise
        {
            get { return _hrsExcrise; }
            set { _hrsExcrise = value; }
        }

        public string NoStrogen
        {
            get { return _noStrogen; }
            set { _noStrogen = value; }
        }

        public string BmiGe30
        {
            get { return _bmiGe30; }
            set { _bmiGe30 = value; }
        }

        #region AverageRisks

        public decimal FiveYearAvgRisk
        {
            get { return _fiveYearAvgRisk; }
            set { _fiveYearAvgRisk = value; }
        }

        public decimal LifetimeAvgRisk
        {
            get { return _lifetimeAvgRisk; }
            set { _lifetimeAvgRisk = value; }
        }

        public decimal TenYearAvgRisk
        {
            get { return _tenYearAvgRisk; }
            set { _tenYearAvgRisk = value; }
        }

      
        public decimal FiveYearAvgRiskPercent
        {
            get { return Math.Round(_fiveYearAvgRisk * 100, _numDecimalPlaces, MidpointRounding.AwayFromZero); }
        }


        public decimal TenYearAvgRiskPercent
        {
            get { return Math.Round(_tenYearAvgRisk * 100, _numDecimalPlaces, MidpointRounding.AwayFromZero); }
        }


        public decimal LifeTimeAvgRiskPercent
        {
            get { return Math.Round(_lifetimeAvgRisk * 100, _numDecimalPlaces, MidpointRounding.AwayFromZero); }
        }

        #endregion AverageRisks

        #endregion Properties

        #region private methods

        private void InitAbsRisks(decimal fiveYearAvgRisk, decimal tenYearAvgRisk, decimal lifetimeAvgRisk, decimal absRsk_05_L, decimal absRsk_05_U, decimal absRsk_10_L, decimal absRsk_10_U, decimal absRsk_20_L, decimal absRsk_20_U, decimal absRsk_LT_L, decimal absRsk_LT_U)
        {
            //abs risks
            _fiveYearAvgRisk = fiveYearAvgRisk;
            _tenYearAvgRisk = tenYearAvgRisk;
            _lifetimeAvgRisk = lifetimeAvgRisk;

            _absRisk05L = absRsk_05_L;
            _absRisk05U = absRsk_05_U;

            _absRisk10L = absRsk_10_L;
            _absRisk10U = absRsk_10_U;

            _absRisk20L = absRsk_20_L;
            _absRisk20U = absRsk_20_U;

            _absRiskLTL = absRsk_LT_L;
            _absRiskLTU = absRsk_LT_U;

        }

        private void InitAbsRisks(decimal fiveYearAbsRisk, decimal tenYearAbsRisk, decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID)
        {
            //abs risks
            _patternID = patternID;
            _fiveYearAbsRisk = fiveYearAbsRisk;
            _lifetimeAbsRisk = lifetimeAbsRisk;
            _tenYearAbsRisk = tenYearAbsRisk;
            _twentyYearAbsRisk = twentyYearAbsRisk;
        }

        private void InitAvgRisks(decimal fiveYearAvgRisk, decimal tenYearAvgRisk, decimal lifetimeAvgRisk)
        {
            //avg risks
            _fiveYearAvgRisk = fiveYearAvgRisk;
            _tenYearAvgRisk = tenYearAvgRisk;
            _lifetimeAvgRisk = lifetimeAvgRisk;
        }
        /// <summary>
        /// check abs risks
        /// </summary>
        private void CheckAbsRisks()
        {
            //re-initialize
            _is20YrRiskValid = false;
            _is10YrRiskValid = false;
            _is5YrRiskValid = false;

            int currentAge = int.Parse(_currentAge);

            if (_isPatternFoundInDB)
            {
                //reset the flags based on the age
                if (currentAge <= 70)
                {
                    _is5YrRiskValid = true;
                    _is10YrRiskValid = true;
                    _is20YrRiskValid = true;
                }
                else if (currentAge <= 80)
                {
                    _is5YrRiskValid = true;
                    _is10YrRiskValid = true;
                }
                else if (currentAge <= 85)
                {
                    _is5YrRiskValid = true;
                }
                else
                    throw new Exception("Out of range for current age:" + currentAge.ToString());
            }
        }

        /// <summary>
        /// Gets/sets the number of decimal places when calculating the percent values. Default value is 1.
        /// </summary>
        public int NumDecimalPlaces
        {
            get { return _numDecimalPlaces; }
            set { _numDecimalPlaces = value; }
        }


        /// <summary>
        /// Gets/sets if the patternid is found in the database or not
        /// </summary>
        public bool IsPatternFoundInDB
        {
            get { return _isPatternFoundInDB; }
            set { _isPatternFoundInDB = value; }
        }

        //Gets/sets Body mass index
        public decimal Bmi
        {
            get { return _bmi; }
            set { _bmi = value; }
        }

        #endregion private methods
    }
}
