using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CCRAT.RiskCalculator
{
    public enum Genders
    {
        Male = 1
        , Female = 2
    }

    public enum Answers
    {
        Yes = 1
        , No = 2
        , DoNotKnow = 3
        , NeverSmoked = 0
    }

    public enum Race
    {        
        // Dev(SR) Note:
        // warning: please do not change this 
        // we use the same numbering in the database for lookup
        // if you were to change this make sure to update database also accordingly
        // or you will get erroneous results
        Unknown = -1,
        //similar to bcra
        White = 1,
        Black = 2,
        Hispanic = 3,
        Asian = 4,
        Indian = 5,
        Hawaiian = 6,
        Other = 7
    }

    public enum Hispanic
    {
        
        No = 0
        , Yes = 1
        , DontKnow = 3
    }

}
