import itertools
import requests
import json
from lxml import html

class BreastRiskAssessmentToolTest:

  ###############maps to old values
  OLD_RACE_MAP = {
    "White":"1",
    "African American":"2",
    "American Indian or Alaskan Native":"5",
    "Unknown":"6",
    "Hispana/Latina":"3",
    "Asian American":"4",
    "US Hispanic":"99",
    "Foreign Hispanic":"99",
    "Chinese":"7",
    "Filipino":"9",
    "Hawaiian":"10",
    "Pacific Islander":"11",
    "Japanese":"8",
    "Other Asian":"12",
    "":"99"
  }
  
  OLD_AGE_PERIOD_MAP = {
    "7 to 11":"10",
    "12 to 13":"13",
    "14 or older":"14"
  }
  
  OLD_CHILDBIRTH_AGE_MAP = {
    "No Births":"0",
    "< 20":"15",
    "20-24":"22",
    "25-29":"27",
    "30 or older":"30",
    "Unknown":"99"
  }
  
  
  OLD_RELATIVES_MAP = {
    "None":"0",
    "One":"1",
    "More than one":"2",
    "Unknown":"99"
  }
  
  OLD_BIOPSY_MAP = {
    "Yes":"1",
    "No":"0",
    "Unknown":"99"
  }
  
  OLD_BIOPSY_YES_MAP = {
    "1":"1",
    "2 or More":"2",
    "Yes":"1",
    "No":"0",
    "Unknown":"99",
    "":"0"
  }
  
  ########## maps to new values
  RACE_MAP = {
    "White":"White",
    "African American":"Black",
    "American Indian or Alaskan Native":"Other",
    "Unknown":"Other",
    "Hispana/Latina":"Hispanic",
    "Asian American":"Asian",
    "US Hispanic":"US Hispanic",
    "Foreign Hispanic":"Foreign Hispanic",
    "Chinese":"Chinese",
    "Filipino":"Filipino",
    "Hawaiian":"Hawaiian",
    "Pacific Islander":"Islander",
    "Japanese":"Japanese",
    "Other Asian":"Asian",
    "":""
  }
  
  BIOPSY_MAP = {
    "Yes":"1",
    "No":"0",
    "Unknown":"99"
  }
  
  BIOPSY_YES_MAP = {
    "1":"1",
    "2 or More":"2",
    "Yes":"1.82",
    "No":".93",
    "Unknown":"1.0",
    "":""
  }
  
  AGE_PERIOD_MAP = {
    "7 to 11":"2",
    "12 to 13":"1",
    "14 or older":"0"
  }
  
  CHILDBIRTH_AGE_MAP = {
    "No Births":"98",
    "< 20":"0",
    "20-24":"1",
    "25-29":"2",
    "30 or older":"3",
    "Unknown":"0"
  }
  
  RELATIVES_MAP = {
    "None":"0",
    "One":"1",
    "More than one":"2",
    "Unknown":"0"
  }
  
  #######
  
  BCRAT_NEW_INPUTS_HISPANIC = [ 
    #race 
    ["Hispana/Latina"],
    #sub_race
    ["Foreign Hispanic","US Hispanic"]
  ]
  BCRAT_NEW_INPUTS_ASIAN = [
    #race
    ["Asian American"],
    #sub_race
    ["Chinese", "Filipino","Hawaiian","Pacific Islander","Japanese","Other Asian"]
  ]
  
  BCRAT_NEW_INPUTS_RACE = [
    #race 
    ["White","African American","American Indian or Alaskan Native","Unknown"],
    [""]
  ]
  
  BCRAT_NEW_INPUTS_BIOPSY = [
    #biopsy
    ["No","Unknown"],
    [""],
    [""]
  ]
  
  BCRAT_NEW_INPUTS_BIOPSY_YES = [
    #biopsy
    ["Yes"],
    #biopsy_result
    ["1","2 or More"],
    #biopsy_ah
    ["Yes","No","Unknown"]
  ]
  
  BCRAT_NEW_INPUTS_BASE = [
    #age
    ["35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85"],
    #age_period
    ["7 to 11","12 to 13","14 or older"],
    #childbirth_age
    ["No Births","< 20","20-24","25-29","30 or older","Unknown"],
    #relatives
    ["None","One","More than one","Unknown"]
  ]
  
  def generateResultsForNewModel(self):
    inputs = self.buildInputs();
    endpoint = 'http://127.0.0.1:8120/calculate'
    for i, input in enumerate(inputs):
      #print('Trying-->',input)
      
      data = {
        'cancerAndRadiationHistory':1,
        'geneticMakeup':1,
        'age':input[5],
        'race':self.RACE_MAP[input[0]],
        'sub_race':self.RACE_MAP[input[1]],
        'biopsy':self.BIOPSY_MAP[input[2]],
        'biopsy_result':self.BIOPSY_YES_MAP[input[3]],
        'biopsy_ah':self.BIOPSY_YES_MAP[input[4]],
        'age_period':self.AGE_PERIOD_MAP[input[6]],
        'childbirth_age':self.CHILDBIRTH_AGE_MAP[input[7]],
        'relatives':self.RELATIVES_MAP[input[8]]
      }
      
      result = requests.post(url = endpoint, data = data)
      #print(result.status_code,result.text)
      payload = result.json()
      patientRisk = json.loads(payload['message'])
 
      print (i,input,patientRisk['risk'],patientRisk['averageFiveRisk'],patientRisk['lifetime_patient_risk'],patientRisk['lifetime_average_risk'])
  
  def riskInputCombinationTest(self):
    inputs = self.buildInputs();
    endpoint = 'http://127.0.0.1:8120/calculate'
    old_endpoint = 'https://www.cancer.gov/bcrisktool/RiskAssessment.aspx'
    start = 11675
    end = 20000
    for i, input in enumerate(inputs[start:end]):
      #print('Trying-->',input)
      
      data = {
        'cancerAndRadiationHistory':1,
        'geneticMakeup':1,
        'age':input[5],
        'race':self.RACE_MAP[input[0]],
        'sub_race':self.RACE_MAP[input[1]],
        'biopsy':self.BIOPSY_MAP[input[2]],
        'biopsy_result':self.BIOPSY_YES_MAP[input[3]],
        'biopsy_ah':self.BIOPSY_YES_MAP[input[4]],
        'age_period':self.AGE_PERIOD_MAP[input[6]],
        'childbirth_age':self.CHILDBIRTH_AGE_MAP[input[7]],
        'relatives':self.RELATIVES_MAP[input[8]]
      }
      old_race_value = input[0]
      if(input[1] and input[0] != "Hispana/Latina"):
        old_race_value = input[1]
       
      old_data = {
        'history': 0,
        'genetics': 0,
        'current_age':input[5],
        'race': self.OLD_RACE_MAP[old_race_value],
        'subrace': self.OLD_RACE_MAP[input[1]],
        'ever_had_biopsy': self.OLD_BIOPSY_MAP[input[2]],
        'previous_biopsies': self.OLD_BIOPSY_YES_MAP[input[3]], 
        'biopsy_with_hyperplasia': self.OLD_BIOPSY_YES_MAP[input[4]],
        'age_at_menarche': self.OLD_AGE_PERIOD_MAP[input[6]],
        'age_at_first_live_birth': self.OLD_CHILDBIRTH_AGE_MAP[input[7]],
        'related_with_breast_cancer': self.OLD_RELATIVES_MAP[input[8]]
      }
      
      page = requests.get(url= old_endpoint, params=old_data)
     
      tree = html.fromstring(page.content)
      risk = tree.xpath('//span[@id="ctl00_cphMain_lbl5YrAbsoluteRisk"]/text()')[0].replace('%','').strip()
      avgRisk = tree.xpath('//span[@id="ctl00_cphMain_lbl5YrAveragRisk"]/text()')[0].replace('%','').strip()
      lifetimeRisk = tree.xpath('//span[@id="ctl00_cphMain_lblLifetimeAbsoluteRisk90"]/text()')[0].replace('%','').strip()
      lifetimeAvgRisk = tree.xpath('//span[@id="ctl00_cphMain_lblLifeTimeAverageRisk90"]/text()')[0].replace('%','').strip()
      
      risk = str(round(float(risk),1))
      avgRisk = str(round(float(avgRisk),1))
      lifetimeRisk = str(round(float(lifetimeRisk),1))
      lifetimeAvgRisk = str(round(float(lifetimeAvgRisk),1))

      result = requests.post(url = endpoint, data = data)
      #print(result.status_code,result.text)
      payload = result.json()
      patientRisk = json.loads(payload['message'])
      
      difference = ""
      if (risk != str(patientRisk['risk']) or avgRisk != str(patientRisk['averageFiveRisk']) or
        lifetimeRisk != str(patientRisk['lifetime_patient_risk']) or lifetimeAvgRisk != str(patientRisk['lifetime_average_risk'])):
        difference = 'DIFFERENCE'
 
      print((start+i),input,patientRisk['risk'],risk,patientRisk['averageFiveRisk'],avgRisk,patientRisk['lifetime_patient_risk'],
        lifetimeRisk,patientRisk['lifetime_average_risk'],lifetimeAvgRisk,difference)
  
  def buildInputs(self):
    #print("buildInputs() start:")
    
    #no sub-race
    noSubRaceInputs = list(self.BCRAT_NEW_INPUTS_RACE)
    noSubRaceInputs.extend(self.BCRAT_NEW_INPUTS_BIOPSY)
    noSubRaceInputs.extend(self.BCRAT_NEW_INPUTS_BASE)
    inputs = list(itertools.product(*noSubRaceInputs))
    
    noSubRaceInputsBiopsyYes = list(self.BCRAT_NEW_INPUTS_RACE)
    noSubRaceInputsBiopsyYes.extend(self.BCRAT_NEW_INPUTS_BIOPSY_YES)
    noSubRaceInputsBiopsyYes.extend(self.BCRAT_NEW_INPUTS_BASE)

    inputs.extend(list(itertools.product(*noSubRaceInputsBiopsyYes)))
    
    #sub-race hispana
    subRaceHispanaInputs = list(self.BCRAT_NEW_INPUTS_HISPANIC)
    subRaceHispanaInputs.extend(self.BCRAT_NEW_INPUTS_BIOPSY)
    subRaceHispanaInputs.extend(self.BCRAT_NEW_INPUTS_BASE)
    inputs.extend(list(itertools.product(*subRaceHispanaInputs)))
    
    subRaceHispanaInputsBiopsyYes = list(self.BCRAT_NEW_INPUTS_HISPANIC)
    subRaceHispanaInputsBiopsyYes.extend(self.BCRAT_NEW_INPUTS_BIOPSY_YES)
    subRaceHispanaInputsBiopsyYes.extend(self.BCRAT_NEW_INPUTS_BASE)

    inputs.extend(list(itertools.product(*subRaceHispanaInputsBiopsyYes)))
    
    #sub-race asian
    subRaceAsianInputs = list(self.BCRAT_NEW_INPUTS_ASIAN)
    subRaceAsianInputs.extend(self.BCRAT_NEW_INPUTS_BIOPSY)
    subRaceAsianInputs.extend(self.BCRAT_NEW_INPUTS_BASE)
    inputs.extend(list(itertools.product(*subRaceAsianInputs)))
    
    subRaceAsianInputsBiopsyYes = list(self.BCRAT_NEW_INPUTS_ASIAN)
    subRaceAsianInputsBiopsyYes.extend(self.BCRAT_NEW_INPUTS_BIOPSY_YES)
    subRaceAsianInputsBiopsyYes.extend(self.BCRAT_NEW_INPUTS_BASE)

    inputs.extend(list(itertools.product(*subRaceAsianInputsBiopsyYes)))
    
    #for i, input in enumerate(inputs):
    #  if(len(input) == 9 ): print(i,input)
    
    #print("buildInputs() stop")
    return inputs
  
  def __init__(self):
    print("BcratRestTest __init__")

if __name__ == '__main__':
  test = BreastRiskAssessmentToolTest()
  #test.generateResultsForNewModel()
  test.riskInputCombinationTest()