/**************************************************************************************************
* Name		: Utils.cs
* Purpose	: Utils.cs
* Author	: SRamaiah
* Date		: 07/13/2006
* Changes	:
**************************************************************************************************/
using System;
using System.Data;
using System.Configuration;
using System.Collections;

/// <summary>
/// Summary description for Utils
/// </summary>
public class Utils
{
	public Utils()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public static double processMale(int region, int sex, int race, int age, int sunburn, int complexion, int large_moles, int small_moles_males, int frekcling, int solar_damage)
    {
        ArrayList phenoVals = new ArrayList();
        //phenoVals.Add(Constants.malePhenoBlisterBurn[2]);
        //phenoVals.Add(Constants.malePhenoFairComplexion[2]);
        //phenoVals.Add(Constants.malePhenoLargeMoles[1]);
        //phenoVals.Add(Constants.malePhenoSmallMoles[2]);
        //phenoVals.Add(Constants.malePhenoMildFreckling[2]);
        //phenoVals.Add(Constants.malePhenoSolarDamage[1]);
        //double risk = calculateRisk(1, 22, 1, phenoVals);

        phenoVals.Add(Constants.malePhenoBlisterBurn[sunburn]);
        phenoVals.Add(Constants.malePhenoFairComplexion[complexion]);
        phenoVals.Add(Constants.malePhenoLargeMoles[large_moles]);
        phenoVals.Add(Constants.malePhenoSmallMoles[small_moles_males]);
        phenoVals.Add(Constants.malePhenoMildFreckling[frekcling]);
        phenoVals.Add(Constants.malePhenoSolarDamage[solar_damage]);

        double risk = calculateRisk(sex, age, region, phenoVals);
        return risk;
    }
    public static double processFemale(int region, int sex, int race, int age, int complexion, int tanning, int small_moles_females, int frekcling)
    {
        ArrayList phenoVals = new ArrayList();
        phenoVals.Add(Constants.femalePhenoFairComplexion[complexion]);
        phenoVals.Add(Constants.femalePhenoLightOrNoTan[tanning]);
        phenoVals.Add(Constants.femalePhenoSmallMoles[small_moles_females]);
        phenoVals.Add(Constants.femalePhenoMildFreckling[frekcling]);
        double risk = calculateRisk(sex, age, region, phenoVals);
        return risk;
    }
    public static double calculateRisk(int sex, int age, int region, ArrayList phenoValuesRef)
    {
        //# see appendix A in the manuscript for the calculation specifications        ;
        int ageIndex = getAgeIndex(age);
        int t1 = getT1(ageIndex);
        int t2 = t1 + 5; //# adding 5 gets us the next age interval

        double r = multiplyArray(phenoValuesRef);
        //#print("r:r<br></br>");

        double h11 = (1 - getAttributableRisk(sex)) * getIncidence(sex, ageIndex, region); //#values are per 100,000
        //#print("h1:h1<br></br>");

        double h21 = getNonMelanomaMortality(sex, ageIndex);
        //#print("h2:h2<br></br>");
        double risk = 0.0;
        risk = (h11 * r / ((h11 * r) + h21) * (1 - Math.Exp((-1 * (t2 - age)) * ((h11 * r) + h21))));

        //# Since the second part of calculation is always zero when age is a multiple of 5, skip it 
        //# for multiples of 5.  Also necessary to correctly calculate for the upper age limit because the second portion
        //# of the calculation does not exist for that value.  (Refer to the manuscript for specs.)
        //TODO:!!! check this if (age / 5 != (int)(age / 5))
        if (age % 5 != 0)
        {
            double h12 = (1 - getAttributableRisk(sex)) * getIncidence(sex, ageIndex + 1, region); //#values are per 100,000
            //#print("h1:h1<br></br>");

            double h22 = getNonMelanomaMortality(sex, ageIndex + 1);
            //#print("h2:h2<br></br>");

            risk += (((h12 * r) / ((h12 * r) + h22)) *
                     Math.Exp(-1 * (t2 - age) * ((h11 * r) + h21)) *
                     (1 - Math.Exp(-1 * (age + 5 - t2) * ((h12 * r) + h22))));
        }

        risk = risk * 100; //# x 100 to get percent

        return risk;
    }
    public static double getAttributableRisk(int sex) {
        //# Returns the attributable risk value from the lookup tables (see constants.pm) corresponding to the supplied paramters.
        //# See table 2 in the manuscript for the specifications.
        double attributableRisk = Convert.ToDouble(Constants.attributableRisk[sex]);    	
        //TODO: check this
	    //if (attributableRisk == null) showError("Invalid main parameter: getAttributableRisk") ;   	   
	    return attributableRisk;
    }
	public static double getNonMelanomaMortality(int sex, int ageIndex){
        double mortality = 0.0;        	
	        if (sex == Constants.MALE){
		        mortality = Constants.male_mort[ageIndex];
	        }	
	        else if (sex == Constants.FEMALE){
		        mortality = Constants.female_mort[ageIndex];
	        }
	        else{
	           showError("Invalid main parameter: getNonMelanomaMortality");
	        }
            //TODO: CHECK THIS LATER
            //if (mortality == null) showError("Invalid age index: getNonMelanomaMortality");   
        	   
	        return mortality / 100000;//# mortality rates are per 100,000 (See table 1 in the manuscript)

    }
    public static double getIncidence(int sex, int ageIndex, int region)
    {
        double incidence = 0.0;
        //#check for special case
        //#subtract region from REGION_MAX to invert the ordinal region order so it matches the incidence tables.
        if (sex == Constants.MALE)
        {
            incidence = Constants.male_incidence[ageIndex, (Constants.REGION_MAX - region)];
        }
        else if (sex == Constants.FEMALE)
        {
            incidence = Constants.female_incidence[ageIndex, (Constants.REGION_MAX - region)];
        }
        else
        {
            showError("Invalid parameter: getIndicence");
        }
        //TODO: check this later
        //if (incidence == null) showError("Invalid age index: getIndicence");

        return incidence / 100000; //# incidence rates are per 100,000 (See table 1 in the manuscript)
    }
	public static int getAgeIndex(int age){
        return (int)((age - 20) / 5);
    }
	public static int getT1(int ageIndex){
        return ((ageIndex * 5) + 20);
    }
    public static double multiplyArray(ArrayList phenoValuesRef)
    {
        //# Returns the product of all values in the supplied array.  Missing values are ignored because
        //# they indicate that a value of 1 (one) should be used and ones were intentionally omitted from 
        //# the data arrays in constants.pm.  	
        //## Per Tom Fears on 20060417: when a risk factor is not present, the value for that factor is one. 
        //## So if no factors correspond to a value from Table 2 in the manuscript, the total result is one.
        double r = 1;
        foreach (object val in phenoValuesRef)
        {
            double retval = 0;
            if (val != null)
            {
                if (!double.TryParse(val.ToString(), out retval))
                {
                    //TODO: THROW AN EXCEPTION
                    showError("Non numeric parameter: multiplyArray");
                    throw new Exception("Non numeric parameter: multiplyArray");
                }
                r = r * retval;
            }
            else
            {
                //## do nothing
            }
        }
        return r;
    }
	public static void isNumeric(){}
	public static void _initUtil(){}
	public static void createLabel(){}
	public static void generateChoiceDDL(){}
	public static void generateIntegerRangeDDL(){}
	public static void getQueryDeblankParam(){}
	public static void getQuery(){}
	public static void loadFrecklingImages(){}
	public static void loadDamageImages(){}
	public static void printQueryVariables(){}
	public static void setupResults(){}
	public static void addRiskAndCompleteResults(){}
	public static void addDemographicsRows(){}
	public static void lookupKey(){}
    public static void showError(string sErrorMsg){
       //TODO:
       //my $sErrorMsg = shift;       
       //print "<HTML><BODY>Calculator Error<p>$sErrorMsg</p></BODY></HTML>\n";  ## have it do something that looks nicer at some point in the future
       //exit();
    }

}
