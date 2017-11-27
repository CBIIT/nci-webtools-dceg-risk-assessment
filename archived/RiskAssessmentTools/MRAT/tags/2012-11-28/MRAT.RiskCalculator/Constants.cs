/**************************************************************************************************
* Name		: Constants.cs
* Purpose	: Constants.cs
* Author	: SRamaiah
* Date		: 07/13/2006
* Changes	:
**************************************************************************************************/
using System;
using System.Data;
using System.Configuration;
using System.Collections;
/// <summary>
/// Summary description for Constants
/// </summary>
public static class Constants
{
    //// male phenotype values
    public static Hashtable malePhenoBlisterBurn = new Hashtable();
    public static Hashtable malePhenoFairComplexion = new Hashtable();
    public static Hashtable malePhenoLargeMoles = new Hashtable();
    public static Hashtable malePhenoSmallMoles = new Hashtable();
    public static Hashtable malePhenoMildFreckling = new Hashtable();
    public static Hashtable malePhenoSolarDamage = new Hashtable();

    //// female phenotype values (including changes to model as specified in email from Tom on 10Feb2006
    public static Hashtable femalePhenoFairComplexion = new Hashtable();
    public static Hashtable femalePhenoLightOrNoTan = new Hashtable();
    public static Hashtable femalePhenoSmallMoles = new Hashtable();
    public static Hashtable femalePhenoMildFreckling = new Hashtable();

    //// phenotypes
    public static Hashtable blisterBurn = new Hashtable();
    public static Hashtable fairComplexion = new Hashtable();
    public static Hashtable largeMoles = new Hashtable();
    public static Hashtable smallMolesMales = new Hashtable();
    public static Hashtable smallMolesFemales = new Hashtable();
    public static Hashtable freckling = new Hashtable();
    public static Hashtable solarDamage = new Hashtable();
    public static Hashtable lightOrNoTan = new Hashtable();
    public static Hashtable region = new Hashtable();
    public static Hashtable sex = new Hashtable();
    public static Hashtable race = new Hashtable();

    ////attributable risk
    public static Hashtable attributableRisk = new Hashtable();

    static Constants()
    {
        Initialize();
    }
    static void Initialize()
    {
        //// male phenotype values
        malePhenoBlisterBurn.Add(1, 1.437);
        malePhenoFairComplexion.Add(1, 1.767);
        malePhenoLargeMoles.Add(2, 2.412);
        malePhenoSmallMoles.Add(2, 1.935);
        malePhenoSmallMoles.Add(3, 4.630);
        malePhenoMildFreckling.Add(2, 1.830);
        malePhenoMildFreckling.Add(3, 1.830);
        malePhenoSolarDamage.Add(1, 2.803);

        //// female phenotype values (including changes to model as specified in email from Tom on 10Feb2006
        femalePhenoFairComplexion.Add(1, 1.802);
        femalePhenoLightOrNoTan.Add(3, 1.926);
        femalePhenoLightOrNoTan.Add(4, 1.926);
        femalePhenoSmallMoles.Add(2, 2.512);
        femalePhenoSmallMoles.Add(3, 5.154);
        femalePhenoMildFreckling.Add(1, 2.174);
        femalePhenoMildFreckling.Add(2, 3.856);
        femalePhenoMildFreckling.Add(3, 3.856);

        //// phenotypes
        blisterBurn.Add(1, "Yes");
        blisterBurn.Add(2, "No");

        fairComplexion.Add(1, "Light");
        fairComplexion.Add(2, "Medium");
        fairComplexion.Add(3, "Dark");

        largeMoles.Add(1, "Less than two");
        largeMoles.Add(2, "Two or more");

        smallMolesMales.Add(1, "Less than seven");
        smallMolesMales.Add(2, "Seven to sixteen");
        smallMolesMales.Add(3, "Seventeen or more");

        smallMolesFemales.Add(1, "Less than five");
        smallMolesFemales.Add(2, "Five to eleven");
        smallMolesFemales.Add(3, "Twelve or more");

        freckling.Add(0, "Absent");
        freckling.Add(1, "Mild");
        freckling.Add(2, "Moderate");
        freckling.Add(3, "Severe");

        solarDamage.Add(1, "Yes");
        solarDamage.Add(2, "No");

        lightOrNoTan.Add(1, "Very brown and deeply tanned");
        lightOrNoTan.Add(2, "Moderately tanned");
        lightOrNoTan.Add(3, "Lightly tanned");
        lightOrNoTan.Add(4, "No tan at all");

        region.Add(0, "North");
        region.Add(1, "Central");
        region.Add(2, "South");

        sex.Add(MALE, "Male");
        sex.Add(FEMALE, "Female");

        race.Add(1, "Non-Hispanic White");

        ////attributable risk
        attributableRisk.Add(MALE, 0.856);
        attributableRisk.Add(FEMALE, 0.894);
    }
    public const string NOTSELECTED = "-1000";  // Intentional out-of-range array index

    public const string groupId = "grp_"; //used to identify the div that contains each variable group
    public const int REGION_MAX = 2;

    #region constants shared with JavaScript
    /*
      If you EVER change any of these, be absolutely certain that you ensure
      that the corresponding change is made in the calculator.js source file
      that is located in the project folder under the htdocs folder.
    */
    // sex value constants
    public const int MALE = 1;
    public const int FEMALE = 2;

    //parameter ids
    public const string regionParamId = "region";
    public const string sexParamId = "sex";
    public const string raceParamId = "race";
    public const string ageParamId = "age";
    public const string blisterParamId = "sunburn";
    public const string complexionParamId = "complexion";
    public const string tanParamId = "tanning";
    public const string lgMoleParamId = "large_moles";
    public const string smMoleMaleParamId = "small_moles_males";
    public const string smMoleFemaleParamId = "small_moles_females";
    public const string frecklingParamId = "freckling";
    public const string solarParamId = "solar_damage";
    public const string LBL_REGION = "region_label";
    #endregion "constants shared with JavaScript"

    #region Matrices
    public static double[,] female_incidence ={
        { 9.35,  8.84,  8.12},
        {13.18, 12.47, 11.45},
        {17.16, 16.23, 14.91},
        {21.12, 19.98, 18.35},
        {24.93, 23.58, 21.66},
        {28.48, 26.94, 24.75},
        {31.71, 30.00, 27.55},
        {34.57, 32.70, 30.04},
        {37.03, 35.02, 32.17},
        {39.08, 36.96, 33.95},
        {40.72, 38.51, 35.38}
    };

    public static double[,] male_incidence = {
       { 4.49,   4.12,  3.6},
       { 7.85,   7.19,  6.3},
       {12.42,  11.38,  9.96},
       {18.32,  16.79, 14.7},
       {25.64,  23.50, 20.57},
       {34.46,  31.58, 27.65},
       {44.84,  41.10, 35.97},
       {56.82,  52.08, 45.59},
       {70.43,  64.55, 56.51},
       {85.70,  78.55, 68.76},
       {102.64, 94.07, 82.35}
    };

    public static double[] female_mort = 
    { 
          43.13
        , 49.40
        , 66.13
        , 96.86
        , 142.86
        , 221.75
        , 359.32
        , 588.77
        , 955.41
        , 1478.73
        , 2316.32
    };
    public static double[] male_mort = 
    { 
          122.86
        , 127.25
        , 161.32
        , 209.35
        , 283.55
        , 404.72
        , 608.14
        , 979.82
        , 1600.96
        , 2490.23
        , 3824.02 
    };


    //// age constants (If these are changed, make sure to also change the age range in the text in the main template.)
    public const int ageMin = 20;
    public const int ageMax = 70;
    #endregion Matrices

}
