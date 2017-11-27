using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CCRAT.RiskCalculator
{
    public class Questions
    {
        #region private members

        private int _age;

        //q1 - height in meeters; a)1 Foot = 0.3048 Meters b)1 Inch = 0.0254 Meters
        private decimal _height;
         //q2 - weight in Kilograms; 1 Pound = 0.45359237 Kilograms
        private decimal _weight;
        //3. In the past 30 days, about how many servings per week of vegetables or leafy green salads did you eat?
        private int _q3;
        // 4. In the past 30 days, how much did you usually eat in each serving of vegetables or leafy green salads?
        private int _q4;
        // 5. During the past 10 years, did you have a colonoscopy or a sigmoidoscopy? 
        private int _q5;
        // 6. During the past 10 years did a doctor tell you that you had a colon polyp or a rectal polyp? 
        private int _q6;
        // 7. This question asks about medications that contain aspirin.  During the past 30 days, have you taken aspirin, Bufferin, Bayer, or Excedrin at least 3 times a week?  Do NOT include Tylenol.
        private int _q7;
        // 8. This question asks about some medications that do not contain aspirin.  During the past 30 days, have you taken Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen, or Nuprin at least 3 times a week?  Do NOT include Tylenol.
        private int _q8;
        // 9. In your entire lifetime, altogether, have you smoked 100 or more cigarettes?
        private int _q9;
        // 10. How old were you when you started smoking cigarettes on a regular basis, that is, at least one cigarette a day for six months or longer?
        private int _q10;
        // 11. Do you now smoke cigarettes either every day or some days?
        private int _q11;
        // 12. How old were you when you quit smoking cigarettes completely?  
        private int _q12;
        // 13. Thinking back over the years you have smoked regularly, about how many cigarettes have you usually smoked each day?
        private int _q13;

        //14. First, think about moderate activities. Over the past 12 months, in how many months, if any, did you do any kind of moderate physical activity?  If you did NOT do any, write in 0.
        private int _q14;
        //15. During those months, on average, about how many hours per week did you do moderate physical activities? 
        private int _q15;

        // 16. Now think about the vigorous physical activity you may have done in the past 12 months. 
        private int _q16;
        // 17. During those months, on average, about how many hours per week did you do vigorous physical activities? 
        private int _q17;
        // 18. Do you still have periods or menstrual cycles?
        private int _q18;
        // 19. When did you have your last period or menstrual cycle?
        private int _q19;
        // 20. During the past 2 years, have you used estrogen, progestin, Hormone Replacement Therapy or other female hormones?  
        private int _q20;

        //21. During the past 2 years, have you had both ovaries removed, either as part of a hysterectomy or as one or more separate surgeries?
        private int _q21;
     
        // 22. Think only about your biological mother and father, full brothers and sisters, and your biological sons or daughters.  At any time in their lives, did any of these relatives ever have cancer of the colon or rectum?
        private int _q22;

        // 23. How many of these relatives had cancer of the colon or rectum (cancer of the lower intestine)?
        private int _q23;

        //24. Are you male or female?
        private Genders _gender;
         //25. What is your date of birth?
        private int _q25;

        //this should be removed later
        private int _patternID;

        private const string OutOfRangeExection = "Out of range exception";

        #endregion private members

        #region public members - questions

        /// <summary>
        /// Gets or set age of a person
        /// </summary>
        public int Age
        {
            get { return _age; }
            set { _age = value; }
        }

        /// <summary>
        /// Gets or set height in meeters a)1 Foot = 0.3048 Meters b)1 Inch = 0.0254 Meters
        /// </summary>
        public decimal Height
        {
            get { return _height; }
            set { _height = value; }
        }

        /// <summary>
        /// Gets or set weight in Kilograms; 1 Pound = 0.45359237 Kilograms
        /// </summary>
        public decimal Weight
        {
            get { return _weight; }
            set { _weight = value; }
        }

        /// <summary>
        /// 3. In the past 30 days, about how many servings per week of vegetables or leafy green salads did you eat?
        /// </summary>
        public int Q3
        {
            get { return _q3; }
            set { _q3 = value; }
        }

        /// <summary>
        /// 4. In the past 30 days, how much did you usually eat in each serving of vegetables or leafy green salads?
        /// </summary>
        public int Q4
        {
            get { return _q4; }
            set { _q4 = value; }
        }

        /// <summary>
        /// 5. During the past 10 years, did you have a colonoscopy or a sigmoidoscopy? 
        /// </summary>
        public int Q5
        {
            get { return _q5; }
            set { _q5 = value; }
        }

        /// <summary>
        /// 6. During the past 10 years did a doctor tell you that you had a colon polyp or a rectal polyp? 
        /// </summary>
        public int Q6
        {
            get { return _q6; }
            set { _q6 = value; }
        }

        /// <summary>
        /// 7. This question asks about medications that contain aspirin.  During the past 30 days, have you taken aspirin, Bufferin, Bayer, or Excedrin at least 3 times a week?  Do NOT include Tylenol.
        /// </summary>
        public int Q7
        {
            get { return _q7; }
            set { _q7 = value; }
        }

        /// <summary>
        /// 8. This question asks about some medications that do not contain aspirin.  During the past 30 days, have you taken Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen, or Nuprin at least 3 times a week?  Do NOT include Tylenol.
        /// </summary>
        public int Q8
        {
            get { return _q8; }
            set { _q8 = value; }
        }

        /// <summary>
        /// 9. In your entire lifetime, altogether, have you smoked 100 or more cigarettes?
        /// </summary>
        public int Q9
        {
            get { return _q9; }
            set { _q9 = value; }
        }

        /// <summary>
        /// 10. How old were you when you started smoking cigarettes on a regular basis, that is, at least one cigarette a day for six months or longer?
        /// </summary>
        public int Q10
        {
            get { return _q10; }
            set { _q10 = value; }
        }

        /// <summary>
        /// 11. Do you now smoke cigarettes either every day or some days?
        /// </summary>
        public int Q11
        {
            get { return _q11; }
            set { _q11 = value; }
        }

        /// <summary>
        /// 12. How old were you when you quit smoking cigarettes completely?  
        /// </summary>
        public int Q12
        {
            get { return _q12; }
            set { _q12 = value; }
        }

        /// <summary>
        /// 13. Thinking back over the years you have smoked regularly, about how many cigarettes have you usually smoked each day?
        /// </summary>
        public int Q13
        {
            get { return _q13; }
            set { _q13 = value; }
        }

        /// <summary>
        /// 14. First, think about moderate activities. Over the past 12 months, in how many months, if any, did you do any kind of moderate physical activity?  If you did NOT do any, write in 0.
        /// </summary>
        public int Q14
        {
            get { return _q14; }
            set { _q14 = value; }
        }
        /// <summary>
        /// 15. During those months, on average, about how many hours per week did you do moderate physical activities? 
        /// </summary>
        public int Q15
        {
            get { return _q15; }
            set { _q15 = value; }
        }

        /// <summary>
        /// 16. Now think about the vigorous physical activity you may have done in the past 12 months.  
        /// </summary>
        public int Q16
        {
            get { return _q16; }
            set { _q16 = value; }
        }

        /// <summary>
        /// 17. During those months, on average, about how many hours per week did you do vigorous physical activities? 
        /// </summary>
        public int Q17
        {
            get { return _q17; }
            set { _q17 = value; }
        }

        /// <summary>
        /// 18. Do you still have periods or menstrual cycles?
        /// </summary>
        public int Q18
        {
            get { return _q18; }
            set { _q18 = value; }
        }

        /// <summary>
        /// 19. When did you have your last period or menstrual cycle?
        /// </summary>
        public int Q19
        {
            get { return _q19; }
            set { _q19 = value; }
        }

        /// <summary>
        /// 20. During the past 2 years, have you used estrogen, progestin, Hormone Replacement Therapy or other female hormones?  
        /// </summary>
        public int Q20
        {
            get { return _q20; }
            set { _q20 = value; }
        }

        public int Q21
        {
            get { return _q21; }
            set { _q21 = value; }
        }

        /// <summary>
        /// 22. Think only about your biological mother and father, full brothers and sisters, and your biological sons or daughters.  At any time in their lives, did any of these relatives ever have cancer of the colon or rectum?
        /// </summary>
        public int Q22
        {
            get { return _q22; }
            set { _q22 = value; }
        }

        /// <summary>
        /// 23. How many of these relatives had cancer of the colon or rectum (cancer of the lower intestine)?
        /// </summary>
        public int Q23
        {
            get { return _q23; }
            set { _q23 = value; }
        }

        /// <summary>
        /// 24. Are you male or female?
        /// </summary>
        public Genders Gender
        {
            get { return _gender; }
            set { _gender = value; }
        }

        /// <summary>
        /// 25. What is your date of birth?
        /// </summary>
        public int Q25
        {
            get { return _q25; }
            set { _q25 = value; }
        }
       
        #endregion public members - questions

        #region public members - coding

        /// <summary>
        /// q2. Returns Body Mass Index (BMI)
        /// </summary>
        public decimal BMI
        {
            get { return _weight / _height; }
        }

        /// <summary>
        /// Returns Body Mass Index Trend
        /// </summary>
        public int BmiTrnd
        {
            get
            {
                int retVal;
                decimal bmi = BMI;
                if (Genders.Female.Equals(Gender))
                {
                    if (bmi < 30m)
                        retVal = 0;
                    else if (bmi >= 30m)
                        retVal = 1;
                    else
                        throw new Exception(OutOfRangeExection);
                    return retVal;
                }
                else if (Genders.Male.Equals(Gender))
                {
                    if (bmi < 24.9m)
                        retVal = 1;
                    else if (bmi >= 24.9m && bmi < 29.9m)
                        retVal = 2;
                    else if (bmi >= 29.9m)
                        retVal = 3;
                    else
                        throw new Exception(OutOfRangeExection);
                    return retVal;
                }
                else
                {
                    throw new Exception(OutOfRangeExection);
                }
            }
        }

        /// <summary>
        /// q4. Gets in the past 30 days, how much did you usually eat in each serving of vegetables or leafy green salads?
        /// </summary>
        public int VegetableServings
        {
            get
            {
                int retVal;
                if (Q3 * Q4 / (.5 * 7) <= 5)
                    retVal = 1;
                else if (Q3 * Q4 * (7 * 5) > 5)
                    retVal = 0;
                else
                    throw new Exception(OutOfRangeExection);

                return retVal;
            }
        }

        /// <summary>
        /// q6. Gets during the past 10 years did a doctor tell you that you had a colon polyp or a rectal polyp?
        /// </summary>
        //public int ColonOrRectalPolyp
        public int Sigmod
        {
            get
            {
                int retVal;
                if (Q5 == 1 && Q6 == 2)
                    retVal = 0;
                else if (Q5 == 1 && Q6 == 3)
                    retVal = 0;
                else if (Q5 == 2)
                    retVal = 1;
                else if (Q5 == 1 && Q6 == 1)
                    retVal = 2;
                else if (Q5 == 3)
                    retVal = 3;
                else
                    throw new Exception(OutOfRangeExection);
                return retVal;
            }
        }

        /// <summary>
        /// q8.a During the past 30 days, have you taken Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen, or Nuprin at least 3 times a week?  Do NOT include Tylenol.
        /// </summary>
        public int NonSaids
        {
            get
            {
                //TODO: double check this
                int retVal;
                if(Q7 == 2 && Q8 == 2)
                    retVal = 1;
                else
                    retVal = 0;
                return retVal;
            }
        }

        /// <summary>
        /// q8.b During the past 30 days, have you taken Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen, or Nuprin at least 3 times a week?  Do NOT include Tylenol.
        /// </summary>
        public int NoIbuprofn
        {
            get
            {
                //TODO: double check this
                int retVal;
                if (Q8 == 2 )
                    retVal = 1;
                else
                    retVal = 0;
                return retVal;
            }
        }

        /// <summary>
        /// q13.a Gets how long a person has smoked
        /// </summary>
        /// <returns></returns>
        public int Duration
        {
            get
            {
                int duration = 0;
                int yearsSmoked = 0;

                if (Q9 == 2)
                    duration = 0;
                else if (Q13 == 1)
                    duration = 0;
                else if (Q10 == 1)
                    duration = 0;
                else if (Q11 == 1)
                    yearsSmoked = Age - Q10;
                else if (Q11 == 2)
                    yearsSmoked = Q12 - Q10;
                else
                    throw new Exception(OutOfRangeExection);

                if (yearsSmoked == 0)
                    duration = 0;
                else if (yearsSmoked > 0 && yearsSmoked < 15)
                    duration = 1;
                else if (yearsSmoked >= 15 && yearsSmoked < 35)
                    duration = 2;
                else if (yearsSmoked >= 35)
                    duration = 3;

                return duration;
            }
        }

        /// <summary>
        /// q13.b Gets number of cigaretts a person has smoked
        /// </summary>
        /// <returns></returns>
        public int Cigaretts
        {
            get
            {
                int cigaretts = 0;

                if (Q9 == 2)
                    cigaretts = 0;
                else if (Q10 == 1)
                    cigaretts = 0;
                else if (Q13 == 0)
                    cigaretts = 0;
                else if (Q13 == 0)
                    cigaretts = 0;
                else if (Q13 > 0 && Q13 < 11)
                    cigaretts = 1;
                else if (Q13 >= 11 && Q13 <= 20)
                    cigaretts = 2;
                else if (Q13 > 20)
                    cigaretts = 3;
                else
                    throw new Exception(OutOfRangeExection);
                return cigaretts;
            }
        }

        //public float VigorousPhysicalActivities
        /// <summary>
        /// q17. Gets Average Hours Of Exercise per month
        /// </summary>
        /// <param name="vigorousActivities">16. Now think about the vigorous physical activity you may have done in the past 12 months.</param>
        /// <param name="vigorousHours">17. During those months, on average, about how many hours per week did you do vigorous physical activities?</param>
        /// <returns></returns>
        public static int HoursOfExercise(int vigorousActivities, float vigorousHours)
        {
            //get
            //{
                int retVal;
                float hoursPerWeek;

                /*
                if (vigorousHours == 0)
                    hoursPerWeek = 0;
                else if (vigorousHours <= 1)
                    hoursPerWeek = 0.5f;
                else if (vigorousHours >= 1 && vigorousHours <= 2)
                    hoursPerWeek = 1.5f;
                else if (vigorousHours > 2 && vigorousHours < 3)
                    hoursPerWeek = 2.5f;
                else if (vigorousHours >= 3 && vigorousHours <= 4)
                    hoursPerWeek = 3.5f;
                else if (vigorousHours > 4)
                    hoursPerWeek = 5;
                else
                    throw new Exception(OutOfRangeExection);
                */

                hoursPerWeek = (vigorousActivities / 12) * vigorousHours;

                if (hoursPerWeek > 4)
                    retVal = 0;
                else if (hoursPerWeek > 2 && hoursPerWeek <=4)
                    retVal = 1;
                else if (hoursPerWeek > 0 && hoursPerWeek <= 2)
                    retVal = 2;
                else if (hoursPerWeek <= 0)
                    retVal = 0;
                else
                    throw new Exception(OutOfRangeExection);

                return retVal;
            //}
        }

        /// <summary>
        /// q20. Gets during the past 2 years, have you used estrogen, progestin, Hormone Replacement Therapy or other female hormones?
        /// </summary>
        public int NoEstrogen
        {
            get
            {
                int retVal;
                if (Q18 == 2 && Q19 == 3 && Q20 == 2)
                    retVal = 1;
                else if (Q18 == 1 || (Q18 == 2 && Q19 == 1 || Q19 == 2) || (Q18 == 2 && Q20 ==1))
                    retVal = 0;
                else
                    throw new Exception(OutOfRangeExection);
                return retVal;
            }
        }

        /// <summary>
        /// 23. How many of these relatives had cancer of the colon or rectum (cancer of the lower intestine)?
        /// </summary>
        public int NumberOfRelatives(int hasRelativeHadCC, int numRelativesHavingCC)
        {
            int retVal;
            if (hasRelativeHadCC == 2 || hasRelativeHadCC == 3)
                retVal = 0;
            else if (hasRelativeHadCC == 1 && numRelativesHavingCC == 1)
                retVal = 1;
            else if (hasRelativeHadCC == 1 && numRelativesHavingCC == 3)
                retVal = 1;
            else if (hasRelativeHadCC == 1 && numRelativesHavingCC == 2)
                retVal = 2;
            else
                throw new Exception(OutOfRangeExection);
            return retVal;
        }

        /// <summary>
        /// Gets covariate pattern mapping id
        /// </summary>
        public int PatternID
        {
            get 
            {
                int patternID;
                
                if (Genders.Male.Equals(Gender))
                {
                    patternID = (NumberOfRelatives(Q22, Q23) + 1)
                        + 3 * (Cigaretts)
                        + 4 * 3 * (NoIbuprofn)
                        + 2 * 4 * 3 * (NonSaids)
                        + 2 * 2 * 4 * 3 * (Sigmod)
                        + 4 * 2 * 2 * 4 * 3 * BmiTrnd
                        + 3 * 4 * 2 * 2 * 4 * 3 * (VegetableServings)
                        + 2 * 3 * 4 * 2 * 2 * 4 * 3 * (Duration) //CigYr
                        + 4 * 2 * 3 * 4 * 2 * 2 * 4 * 3 * HoursOfExercise(Q16, Q17);
                        ;

                }
                else if (Genders.Female.Equals(Gender))
                {
                    patternID = (NumberOfRelatives(Q22, Q23) + 1)
                        + 3 * (NonSaids)
                        + 2 * 2 * 4 * 3 * (Sigmod)
                        + 4 * 2 * 3 * BmiTrnd
                        + 2 * 4 * 2 * 3 * (VegetableServings)
                        + 2 * 2 * 4 * 2 * 3 * (NoEstrogen)
                        + 2 * 2 * 2 * 4 * 2 * 3 * HoursOfExercise(Q16, Q17);
                    
                }
                else
                {
                    throw new Exception(OutOfRangeExection);
                }
                return patternID; 
            }
            //set { _patternID = value; }
        }

        #endregion public members - coding
    }
}
