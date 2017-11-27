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
using System.Web;
/// <summary>
/// Summary description for Calculate
/// </summary>
public class MelanomaCalculator
{
    public MelanomaCalculator()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    private void eval(){}
	public static void doCalc(){
       int sex = 1;
       if (sex == Constants.MALE) {
   	    //Utils.processMale();
       }	
       else if (sex == Constants.FEMALE) {
           //Utils.processFemale();
       }	
       else{
          //showError("Unhandled condition: doCalc()");
       }
    }
	private void printHeader(){}
	private void displayCalculator(){}
    private void setScreen() { }
}
