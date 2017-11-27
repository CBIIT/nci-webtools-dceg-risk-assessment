using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CCRAT.RiskCalculator
{
    public class AbsoluteRisks
    {
        #region private variables

        private decimal _fiveYearAbsRisk;
        private decimal _tenYearAbsRisk;
        private decimal _twentyYearAbsRisk;
        private decimal _lifetimeAbsRisk;
        private int _patternID;
        private bool _is5YrRiskValid;
        private bool _is10YrRiskValid;          
        private bool _is20YrRiskValid;
        private int _numDecimalPlaces = 1;
        private bool _isPatternFoundInDB;

   
        private string _gender, _currentAge, _numrel, _cigarets, _duration, _noNSaids, _noIbuprofn, _sigmod, _vegLT5, _bmiTrnd, _hrsExcrise, _noStrogen, _bmiGe30;

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
        public AbsoluteRisks(string gender, int currentAge, int numrel, int cigarets, int duration, int noNSaids, int noIbuprofn, int sigmod, int vegLT5, int bmiTrnd, int hrsExcrise, int patternID, bool isPatternFoundInDB, decimal bmi)
        {
            //answers
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
        public AbsoluteRisks(string gender, int currentAge, int numrel, int cigarets, int duration, int noNSaids, int noIbuprofn, int sigmod, int vegLT5, int bmiTrnd, int hrsExcrise, decimal fiveYearAbsRisk, decimal tenYearAbsRisk, decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID, decimal bmi)
            : this(gender, currentAge, numrel, cigarets, duration, noNSaids, noIbuprofn, sigmod, vegLT5, bmiTrnd, hrsExcrise, patternID, true, bmi)           
        {            
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
        public AbsoluteRisks(string gender, int currentAge, int numrel, int noStrogen, int noNSaids, int sigmod, int vegLT5, int bmiGe30, int hrsExcrise, int patternID, bool isPatternFoundInDB, decimal bmi)
        {
            //answers
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
        public AbsoluteRisks(string gender, int currentAge, int numrel, int noStrogen, int noNSaids, int sigmod, int vegLT5, int bmiGe30, int hrsExcrise, decimal fiveYearAbsRisk, decimal tenYearAbsRisk, decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID, decimal bmi)
            : this (gender, currentAge, numrel, noStrogen, noNSaids, sigmod, vegLT5, bmiGe30, hrsExcrise, patternID, true, bmi)
        {
            InitAbsRisks(fiveYearAbsRisk, tenYearAbsRisk, twentyYearAbsRisk, lifetimeAbsRisk, patternID);
        }

        #endregion constructors

        #region Properties

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
           
        #endregion Properties

        #region private methods

        private void InitAbsRisks(decimal fiveYearAbsRisk, decimal tenYearAbsRisk, decimal twentyYearAbsRisk, decimal lifetimeAbsRisk, int patternID)
        {
            //abs risks
            _patternID = patternID;
            _fiveYearAbsRisk = fiveYearAbsRisk;
            _lifetimeAbsRisk = lifetimeAbsRisk;
            _tenYearAbsRisk = tenYearAbsRisk;
            _twentyYearAbsRisk = twentyYearAbsRisk;
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
