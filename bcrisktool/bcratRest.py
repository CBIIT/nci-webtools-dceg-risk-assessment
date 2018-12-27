import math
import os
import sys
import logging
import json

from flask import Flask, Response, request, jsonify, send_from_directory
from BcratRunFunction import RiskCalculation

app = Flask(__name__, static_folder="", static_url_path="")

print("Hello : we are running the new code + 4")

class BreastRiskAssessmentTool:
  @staticmethod
  def buildFailure(message):
    if (isinstance(message,str)):
      response = jsonify(message=message, errorType="message", success=False)
    else:
      message['success'] = False
      response = jsonify(message)
    response.mimetype = 'application/json'
    response.status_code = 400
    logging.debug("Returning from Backend --> " + str(response))
    return response

  @staticmethod
  def buildSuccess(message):
    if (isinstance(message,str)):
      response = jsonify(message=message, success=True)
    else:
      message['success'] = True
      response = jsonify(message=message, success=True)
    response.mimetype = 'application/json'
    response.status_code = 200
    logging.debug("Returning from Backend --> " + str(response))
    return response

  @app.route('/calculate', methods=['POST'], strict_slashes=False)
  def bcratRisk():
    try:
      parameters = dict(request.form)
      for field in parameters:
        parameters[field] = parameters[field][0]
      errorObject = {'missing':[],'nonnumeric':[],'message':[]}
      requiredParameters = ['age','age_period','childbirth_age','biopsy']
      if 'race' not in parameters or parameters['race'] == "":
        errorObject['missing'] += ['race']
      elif parameters['race'] == "Asian" or parameters['race'] == 'Hispanic':
        if 'sub_race' not in parameters or parameters['sub_race'] == "":
          errorObject['missing'] += ['sub_race']
        else:
          race = parameters['sub_race']
      else:
        race = parameters['race']
      for required in requiredParameters:
        if required not in parameters or parameters[required] == "":
          errorObject['missing'].append(required)
        else:
          try:
            float(parameters[required])
          except:
            errorObject['nonnumeric'].append(required)
      if 'age' not in errorObject['missing'] and 'age' not in errorObject['nonnumeric']:
        age = int(parameters['age'])
        if (age < 35 or age > 85):
          errorObject['message'] += ["This tool cannot be used to assess risk for those under the age of 35 or over the age of 85."]
      menarcheAge = 0
      if 'age_period' not in errorObject['missing'] and 'age_period' not in errorObject['nonnumeric']:
        menarcheAge = int(parameters['age_period'])
      firstLiveBirthAge = 0
      if 'childbirth_age' not in errorObject['missing'] and 'childbirth_age' not in errorObject['nonnumeric']:
        firstLiveBirthAge = int(parameters['childbirth_age'])
      numberOfBiopsies = 0
      rhyp = 1.0
      if 'biopsy' not in errorObject['missing'] and 'biopsy' not in errorObject['nonnumeric']:
        numberOfBiopsies = int(parameters['biopsy'])
        if numberOfBiopsies == 0 or numberOfBiopsies == 99:
          numberOfBiopsies = 0
        else:
          if 'biopsy_result' not in parameters:
            errorObject['missing'] += ['biopsy_result']
          elif not parameters['biopsy_result'].isnumeric():
            errorObject['nonnumeric'] += ['biopsy_result']
          else:
            numberOfBiopsies = int(parameters['biopsy_result'])
          if 'biopsy_ah' not in parameters:
            errorObject['missing'] += ['biopsy_ah']
          else:
            try:
              rhyp = float(parameters['biopsy_ah'])
            except:
              errorObject['nonnumeric'] += ['biopsy_ah']
      if len(errorObject['missing']) > 0 or len(errorObject['nonnumeric']) > 0 or len(errorObject['message']) > 0:
        return BreastRiskAssessmentTool.buildFailure(errorObject);
      firstDegRelatives = int(parameters['relatives'])
      if parameters['race'] == "Asian" and firstDegRelatives > 0:
        firstDegRelatives = 1

      risk = RiskCalculation("Absolute",race, age, min(age+5,90), menarcheAge, numberOfBiopsies, firstLiveBirthAge, firstDegRelatives, rhyp)
      risk = round(risk*100,1)

      averageFiveYearRisk = RiskCalculation("Average", race, age, min(age+5,90), 0, 0, 0, 0, 1)
      averageFiveYearRisk = round ( averageFiveYearRisk * 100, 1)

      lifetime_patient_risk = RiskCalculation("Absolute", race, age, 90, menarcheAge, numberOfBiopsies, firstLiveBirthAge, firstDegRelatives, rhyp)
      lifetime_patient_risk = round( lifetime_patient_risk * 100, 1)

      lifetime_average_risk = RiskCalculation("Average", race, age, 90, 0, 0, 0, 0, 1)
      lifetime_average_risk = round( lifetime_average_risk * 100, 1)

      patientColorPresented5Year = ""
      if ( risk > averageFiveYearRisk ):
          patientColorPresented5Year = "presented in red since hers is higher than"
      elif ( risk < averageFiveYearRisk ):
        patientColorPresented5Year = "presented in green since hers is lower than"
      else:
        patientColorPresented5Year = "presented in blue since hers is equal to"

      patientColorPresentedLifetime = ""
      if ( lifetime_patient_risk > lifetime_average_risk ):
            patientColorPresentedLifetime = "presented in red since hers is higher than"
      elif ( lifetime_patient_risk < lifetime_average_risk):
        patientColorPresentedLifetime = "presented in green since hers is lower than"
      else:
        patientColorPresentedLifetime = "presented in blue since hers is equal to"


      results={}
      results['risk']= risk
      results['averageFiveRisk'] = averageFiveYearRisk
      results['message'] = "Based on the information provided, the patient's estimated risk for developing invasive breast cancer over the next 5 years is {0:g}%, ".format(risk) + patientColorPresented5Year + " the average risk of {0:g}% (presented in blue) for women of the same age and race/ethnicity in the general U.S. population.".format(averageFiveYearRisk)
      results['lifetime_patient_risk']=lifetime_patient_risk
      results['lifetime_average_risk']=lifetime_average_risk
      results['lifetime_message'] = "Based on the information provided, the woman's estimated risk for developing invasive breast cancer over her lifetime (to age 90) is {0:g}%, ".format(lifetime_patient_risk) + patientColorPresentedLifetime + " the average risk of {0:g}% (presented in blue) for women of the same age and race/ethnicity in the general U.S. population.".format(lifetime_average_risk)
      results['patientColorPresented5Year'] = patientColorPresented5Year
      results['patientColorPresentedLifetime'] = patientColorPresentedLifetime
      json_data = json.dumps(results)
      return BreastRiskAssessmentTool.buildSuccess(json_data)
    except Exception as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
      print(e)
      print("EXCEPTION------------------------------", exc_type, fname, exc_tb.tb_lineno)
      return BreastRiskAssessmentTool.buildFailure(str(e))

  def __init__(self,port,debug):
    app.run(host='0.0.0.0', port=port, debug=True)

if __name__ == '__main__':
  import argparse
  parser = argparse.ArgumentParser()
  parser.add_argument("-p", dest="port_number", default="8120", help="Sets the Port")
  parser.add_argument("--debug", action="store_true")

  args = parser.parse_args()
  port_num = int(args.port_number);
  BreastRiskAssessmentTool(port_num, args.debug)
