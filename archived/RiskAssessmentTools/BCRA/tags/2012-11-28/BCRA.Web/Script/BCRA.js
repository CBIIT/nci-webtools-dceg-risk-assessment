// JScript File

servlet = "RiskAssessment.aspx";
_error_msg_history = "This tool cannot calculate breast cancer risk accurately for women with a medical history of any breast cancer or of DCIS or LCIS.";
_error_msg_current_age = "This tool only calculates risk for women 35 years of age or older.";
_error_msg_hist_age = "This tool cannot calculate breast cancer risk accurately for women with a medical history of breast cancer or of DCIS or LCIS. In addition, the tool only calculates risk for women 35 years of age or older.";
function checkAge() {
  if (document.risk.current_age.selectedIndex==1)
    alert(_error_msg_current_age);
}
function checkHistory() {
  if (document.risk.history.selectedIndex==1)
    alert(_error_msg_history);
}
function checkEthnicity() {
    if (document.risk.race.selectedIndex == 2) {
        //alert("Assessments for African American women may underestimate the chance of breast cancer and are subject to greater uncertainty than those for white women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations."); 
        //dec282007 SRamaiah: this has been removed as the new model(CARE) is now in use for african american women
    }
    else if (document.risk.race.selectedIndex == 3)
    { alert("Assessments for Hispanic women are subject to greater uncertainty than those for white and African American women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations."); }
    //else if (document.risk.race.selectedIndex == 4) {    
    //{ alert("Assessments for Asian or Pacific Islander women are uncertain and are based on data for white women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations."); }    
    else if (document.risk.race.selectedIndex == 5)
    { alert("Assessments for American Indian or Alaskan Native women are uncertain and are based on data for white women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations."); }
    else if (document.risk.race.selectedIndex == 6)
    { alert("This risk assessment was based on data for white females."); }
  //reset it to white female
    //document.risk.race.selectedIndex=1;

    //Populate sub race/ehnicity
    if (document.risk.race.selectedIndex != 4) {
        document.risk.subrace.options.length = 0;
        document.risk.subrace.options[0] = new Option("n/a");
        document.risk.subrace.selectedIndex = 0;
        document.risk.subrace.options[0].value = 99;
        }
    else{
        document.risk.subrace.options[0] = new Option("(select) ");
        document.risk.subrace.options[0].value = 999;
        document.risk.subrace.options[1] = new Option("Chinese");
        document.risk.subrace.options[1].value = 7;
        document.risk.subrace.options[2] = new Option("Japanese");
        document.risk.subrace.options[2].value = 8;
        document.risk.subrace.options[3] = new Option("Filipino");
        document.risk.subrace.options[3].value = 9;
        document.risk.subrace.options[4] = new Option("Hawaiian");
        document.risk.subrace.options[4].value = 10;
        document.risk.subrace.options[5] = new Option("Other Pacific Islander");
        document.risk.subrace.options[5].value = 11;
        document.risk.subrace.options[6] = new Option("Other Asian-American");
        document.risk.subrace.options[6].value = 12;        
        document.risk.subrace.selectedIndex = 0;
        }
    }

function checkBiopsy() {
  if (document.risk.ever_had_biopsy.selectedIndex==1) { // Unknown
    document.risk.previous_biopsies.options.length = 0;
    document.risk.previous_biopsies.options[0] = new Option("n/a");
    document.risk.previous_biopsies.selectedIndex = 0;
    document.risk.previous_biopsies.options[0].value = 99;
    document.risk.biopsy_with_hyperplasia.options.length = 0;
    document.risk.biopsy_with_hyperplasia.options[0] = new Option("n/a");
    document.risk.biopsy_with_hyperplasia.selectedIndex = 0;
    document.risk.biopsy_with_hyperplasia.options[0].value = 99;
  }
  if (document.risk.ever_had_biopsy.selectedIndex==2) { // No
    document.risk.previous_biopsies.options.length = 0;
    document.risk.previous_biopsies.options[0] = new Option("n/a");
    document.risk.previous_biopsies.selectedIndex = 0;
    document.risk.previous_biopsies.options[0].value = 0;
    document.risk.biopsy_with_hyperplasia.options.length = 0;
    document.risk.biopsy_with_hyperplasia.options[0] = new Option("n/a");
    document.risk.biopsy_with_hyperplasia.selectedIndex = 0;
    document.risk.biopsy_with_hyperplasia.options[0].value = 0;
  }
  if (document.risk.ever_had_biopsy.selectedIndex==3) { // Yes
    document.risk.previous_biopsies.options[0] = new Option("(select) ");
    document.risk.previous_biopsies.options[0].value = 999;
    document.risk.previous_biopsies.options[1] = new Option("1");
    document.risk.previous_biopsies.options[1].value = 1;
    document.risk.previous_biopsies.options[2] = new Option("> 1");
    document.risk.previous_biopsies.options[2].value = 2;
    document.risk.previous_biopsies.selectedIndex = 0;
    document.risk.biopsy_with_hyperplasia.options[0] = new Option("(select) ");
    document.risk.biopsy_with_hyperplasia.options[0].value = 999;
    document.risk.biopsy_with_hyperplasia.options[1] = new Option("Unknown");
    document.risk.biopsy_with_hyperplasia.options[1].value = 99;
    document.risk.biopsy_with_hyperplasia.options[2] = new Option("No");
    document.risk.biopsy_with_hyperplasia.options[2].value = 0;
    document.risk.biopsy_with_hyperplasia.options[3] = new Option("Yes");
    document.risk.biopsy_with_hyperplasia.options[3].value = 1;
    document.risk.biopsy_with_hyperplasia.selectedIndex = 0;
//    document.reload();
  }
}
function calculate() {


  if (document.risk.history.selectedIndex==0||
      document.risk.current_age.selectedIndex==0||
      document.risk.age_at_menarche.selectedIndex==0||
      document.risk.age_at_first_live_birth.selectedIndex==0||
      document.risk.related_with_breast_cancer.selectedIndex==0||
      document.risk.ever_had_biopsy.selectedIndex==0||
      document.risk.ever_had_biopsy.selectedIndex==3&&document.risk.previous_biopsies.selectedIndex==0||
      document.risk.ever_had_biopsy.selectedIndex == 3 && document.risk.biopsy_with_hyperplasia.selectedIndex == 0 ||
      document.risk.race.selectedIndex == 4 && document.risk.subrace.selectedIndex == 0 ||      
      document.risk.race.selectedIndex==0) {
        alert("All questions must be answered before the patient's risk can be calculated.");
      return;    
  }
  else if (document.risk.current_age.selectedIndex==1 && document.risk.history.selectedIndex==1){
    alert(_error_msg_hist_age);
    return;
  }
  else if (document.risk.history.selectedIndex==1){
    alert(_error_msg_history);
    return;
  }
  else if (document.risk.current_age.selectedIndex==1){
    alert(_error_msg_current_age);
    return;  
  }
  current_age = document.risk.current_age.options[document.risk.current_age.selectedIndex].value;
  age_at_menarche = document.risk.age_at_menarche.options[document.risk.age_at_menarche.selectedIndex].value;
  age_at_first_live_birth = document.risk.age_at_first_live_birth.options[document.risk.age_at_first_live_birth.selectedIndex].value;
  ever_had_biopsy = document.risk.ever_had_biopsy.options[document.risk.ever_had_biopsy.selectedIndex].value;
  previous_biopsies = document.risk.previous_biopsies.options[document.risk.previous_biopsies.selectedIndex].value;
  biopsy_with_hyperplasia = document.risk.biopsy_with_hyperplasia.options[document.risk.biopsy_with_hyperplasia.selectedIndex].value;
  related_with_breast_cancer = document.risk.related_with_breast_cancer.options[document.risk.related_with_breast_cancer.selectedIndex].value;
  if (document.risk.race.selectedIndex == 4) {
      race = document.risk.subrace.options[document.risk.subrace.selectedIndex].value;
  }
  else {
      race = document.risk.race.options[document.risk.race.selectedIndex].value;

  }

  if (document.risk.race.selectedIndex==4)
    asian = "&asian=" + escape("It has been observed that recent immigrants from rural Asia may have a lower risk of breast cancer than calculated.");
  else
    asian = "";

  if (previous_biopsies=="")
    previous_biopsies = "99";
  if (biopsy_with_hyperplasia=="")
    biopsy_with_hyperplasia = "99";

  parameters = "current_age=" + current_age +
         "&age_at_menarche=" + age_at_menarche +
         "&age_at_first_live_birth=" + age_at_first_live_birth +
         "&ever_had_biopsy=" + ever_had_biopsy +
         "&previous_biopsies=" + previous_biopsies +
         "&biopsy_with_hyperplasia=" + biopsy_with_hyperplasia +
         "&related_with_breast_cancer=" + related_with_breast_cancer +
         "&race=" + race +
           asian;

  // Web Analytics (Omniture) - call web analytics-related function defined in 
  // in analytics_include.html and rendered in the web analytics page-load tag.  
  // If web analytics are turned off,  analytics_include.html is empty and this function is not found.
  // In the future it may be more efficient to attach this JavaScript code 
  // to the appropriate page event (click or submit) so no reference to web analytics
  // will be needed in this file.  
  if(window.Analytics_CalculateRiskConversionEvent)
    window.Analytics_CalculateRiskConversionEvent();

  document.location = servlet + "?" + parameters;
  return;

  if (document.risk.current_age.selectedIndex==0) {
    alert("You must select the age of the patient.");
    return;
  }
  if (document.risk.age_at_menarche.selectedIndex==0) {
    alert("You must select the patient's age at time of first menstrual period.");
    return;
  }
  if (document.risk.age_at_first_live_birth.selectedIndex==0) {
    alert("You must select the patient's age at first live birth of child.");
    return;
  }
  if (document.risk.related_with_breast_cancer.selectedIndex==0) {
    alert("You must select the number of relatives who have had cancer.");
    return;
  }
  if (document.risk.ever_had_biopsy.selectedIndex==0) {
    alert("You must indicate if the patient has ever had a breast biopsy.");
    return;
  }
  if (document.risk.ever_had_biopsy.selectedIndex==3&&document.risk.previous_biopsies.selectedIndex==0) {
    alert("You must indicate how many breast biopsies the patient has had.");
    return;
  }
  if (document.risk.ever_had_biopsy.selectedIndex==3&&document.risk.biopsy_with_hyperplasia.selectedIndex==0) {
    alert("You must indicate if the patient has had a biopsy with atypical hyperplasia.");
    return;
  }
  if (document.risk.race.selectedIndex==0) {
    alert("You must indicate the patient's race.");
    return;
  }
}
function disclaimer() {
  if (document.risk.race.selectedIndex==0||document.risk.race.selectedIndex==1) {
    document.risk.dText.value = "";
  }
  else if (document.risk.race.selectedIndex==2) {
    document.risk.dText.value = "The projections for African American women may slightly underestimate the likelihood of breast cancer and are subject to greater uncertainty than those for white women.";
  }
  else if (document.risk.race.selectedIndex==3) {
    document.risk.dText.value = "The projections for Hispanic women are subject to greater uncertainty than those for white women.";
  }
  else if (document.risk.race.selectedIndex==4) {
    document.risk.dText.value = "Calculations for Asian or Pacific Islander women are based on the rates for white women and are uncertain.";
  }
  else if (document.risk.race.selectedIndex==5) {
    document.risk.dText.value = "Calculations for American Indian or Alaskan Native women are based on the rates for white women and are uncertain.";
  }
  else if (document.risk.race.selectedIndex==6) {
    document.risk.dText.value = "If the patient's race is unknown, the program will use data for white females to estimate the predicted risk.";
  }
}

function popUp(URL) {
day = new Date();
id = day.getTime();
eval("page" + id + " = window.open(URL, '" + id + "', 'toolbar=0,scrollbars=0,location=0,statusbar=1,menubar=0,resizable=1,width=497,height=262,left = 391.5,top = 381');");
}
