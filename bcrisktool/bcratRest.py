import math
import os
import sys
import logging
import json

from flask import Flask, Response, request, jsonify, send_from_directory
from BcratRunFunction import RiskCalculation, AbsoluteRisk, AverageRisk

#app = Flask(__name__, static_url_path="/")
#app = Flask(__name__, static_url_path="")
app = Flask(__name__)
logging.basicConfig(level=logging.DEBUG)

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
    return response

  @staticmethod
  def buildSuccess(message):
    if (isinstance(message,str)):
      response = jsonify(message=message, success=True)
    else:
      message['success'] = True
      response = jsonify(message)
    response.mimetype = 'application/json'
    response.status_code = 200
    return response

  @staticmethod
  def isInt(value):
    try:
      int(value)
      return True
    except:
      return False

  @staticmethod
  def isFloat(value):
    try:
      float(value)
      return True
    except:
      return False

  @staticmethod
  def round(risk):
      return round(risk*100)

  @staticmethod
  def isExistAndNumber(key,parameters,errors):
    result = False
    if ( key not in parameters):
      errors['missing'] += [key]
    elif ( BreastRiskAssessmentTool.isInt(parameters[key]) == False ):
      errors['numeric'] += [key]
    else:
      result = True
    return result

  @staticmethod
  def isExistAndFloat(key,parameters,errors):
    result = False
    if ( key not in parameters):
      errors['missing'] += [key]
    elif ( BreastRiskAssessmentTool.isFloat(parameters[key]) == False ):
      errors['numeric'] += [key]
    else:
      result = True
    return result

  @staticmethod
  def validateDemographics(parameters,errors):

    # Validation of age.  It required, must be numeric an between 35 and 85
    if (BreastRiskAssessmentTool.isExistAndNumber("age", parameters,errors) == True):
      age = int(parameters['age'])
      logging.debug("AGe = " + str(age))
      if (age < 35 or age > 85):
         errors['message'] += ["This tool cannot be used to assess risk for those under the age of 35 or over the age of 85."]

    # Validation of race  It is reuqired and if Asian then it requires a subrace insted of the race
    if ( "race" not in parameters):
        errors['missing'] += ['race']
    else:
        race = parameters['race']

    if ( race.startswith('Asian')):
        if ( 'sub_race' not in parameters):
            errors['missing']  = ['sub_race']
            errors['Messages'] += ["If Asian American is the race then a sub_race must be defined"]
        else:
            race = parameters['sub_race']

    return age, race

  @staticmethod
  def validateHistory(parameters, errors):

    # Bioppsy is required and must be a number
    if (BreastRiskAssessmentTool.isExistAndNumber("biopsy", parameters,errors) == True):
      numberOfBiopsy = int(parameters['biopsy'])

    if ( numberOfBiopsy == 0 or numberOfBiopsy == 99 ):
      oneBiopsyWithAtypcialHyperplasia = .93
    else:
      # breastBiopsies must exist and be a number.  Note the number of Biopsy has the following values 0 (none), 1 (1), 2 ( more than 1), 99 (unknown)
      # I believe this is combine with value above to generate one value.
      if ( BreastRiskAssessmentTool.isExistAndNumber("howManyBreastBiopsies",parameters,errors) == True):
        numberOfBiopsy = int(parameters['howManyBreastBiopsies'])

      if ( BreastRiskAssessmentTool.isExistAndFloat("hadAH", parameters, errors) == True ):
        oneBiopsyWithAtypcialHyperplasia = float(parameters['hadAH'])

    # Age of first mentrual period is required and numeric
    if ( BreastRiskAssessmentTool.isExistAndNumber("age_first_period", parameters,errors) == True):
        ageFirstPeriod = int(parameters['age_first_period'])

    # Age of first live birth
    if ( BreastRiskAssessmentTool.isExistAndNumber("childbirth_age", parameters, errors)  == True):
        womansAgeOfFirstLiveBirth = int(parameters['childbirth_age'])

    # Number of reliate with breast cancer is required and must be a #
    if ( BreastRiskAssessmentTool.isExistAndNumber("relatives", parameters, errors) == True):
        relativeCount = int(parameters["relatives"])

    return numberOfBiopsy, oneBiopsyWithAtypcialHyperplasia, ageFirstPeriod, womansAgeOfFirstLiveBirth, relativeCount

  @staticmethod
  def bcRatRisk(age,race,numberOfBiopsy, ageFirstPeriod, childBirthAge, oneBiopsyWithAtypcialHyperplasia, relativeCount, errors):

    try:

        if len(errors['missing']) > 0 or len(errors['nonnumeric']) > 0 or len(errors['message']) > 0:
            return BreastRiskAssessmentTool.buildFailure(json.dumps(errors))
        else:
            fiveYearRisk            = BreastRiskAssessmentTool.round(AbsoluteRisk(   race, age,    min(age+5,90),     ageFirstPeriod, numberOfBiopsy, childBirthAge, relativeCount, oneBiopsyWithAtypcialHyperplasia ))
            logging.debug("Calculated 5-year risk for the current patient with value " + str(fiveYearRisk))
            averageFiveYearRisk     = BreastRiskAssessmentTool.round(AverageRisk(    race, age,    min(age+5,90),     ageFirstPeriod, numberOfBiopsy, childBirthAge, relativeCount, oneBiopsyWithAtypcialHyperplasia))
            logging.debug("Calculated average 5-year Risk for everyone with value " + str(averageFiveYearRisk))
            lifetimeRisk            = BreastRiskAssessmentTool.round(AbsoluteRisk(   race, 35,     90,                 ageFirstPeriod, numberOfBiopsy, childBirthAge, relativeCount, oneBiopsyWithAtypcialHyperplasia))
            logging.debug("Calculated the lifetime risk for the current patient with value " + str(lifetimeRisk))
            averageLifeTimeRisk     = BreastRiskAssessmentTool.round(AverageRisk(    race, 35,     90,                ageFirstPeriod, numberOfBiopsy, childBirthAge, relativeCount, oneBiopsyWithAtypcialHyperplasia))
            logging.debug("Calculated the lifetime risk for everyone with value " + str(averageLifeTimeRisk))

            results={}
            results['risk']=fiveYearRisk
            results['averageFiveRisk'] = averageFiveYearRisk
            results['message'] = "Based on the information provided, the woman's estimated risk for developing invasive breast cancer over the next 5 years is {0:g}% compared to a risk of {1:g}% for a woman of the same age and race/ethicity from the general U.S. population.".format(fiveYearRisk,averageFiveYearRisk)
            results['lifetime_patient_risk']=lifetimeRisk
            results['lifetime_average_risk']=averageLifeTimeRisk
            results['lifetime_message'] = "Based on the information provided, the woman's estimated risk for developing invasive breast cancer over her lifetime (to age 90) is {0:g}% compared to a risk of {1:g}% for a woman of the same age and race/ethnicity from the general U.S. population.".format(lifetimeRisk,averageLifeTimeRisk)

            json_data=json.dumps(results)
    except Exception as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
      logging.debug("EXCEPTION------------------------------" + str(exc_type) + " "  + str(fname) + " " + str(exc_tb.tb_lineno))
      return BreastRiskAssessmentTool.buildFailure(str(e))

    return BreastRiskAssessmentTool.buildSuccess(json_data)

  @app.route('/calculate', methods=['POST'], strict_slashes=False )
  def calculate():
    try:
      parameters = request.form.to_dict()
      logging.debug("***** Performing Calculation using the Calculate URL");
      logging.debug("Parameters from Get Request = " +str(parameters))
      errors = {'missing':[],'nonnumeric':[],'message':[]}

      age, race = BreastRiskAssessmentTool.validateDemographics(parameters, errors)
      logging.debug( "Demographics: age = " + str(age) + " race = " + race)

      numberOfBiopsy, oneBiopsyWithAtypcialHyperplasia, ageFirstPeriod, womansAgeOfFirstLiveBirth, relativeCount = BreastRiskAssessmentTool.validateHistory(parameters, errors)
      logging.debug( "History: biopsy = " + str(numberOfBiopsy)  + " oneBiopsyWithAtypcialHyperplasia = " + str(oneBiopsyWithAtypcialHyperplasia))
      logging.debug( "History: Age First Period = " + str(ageFirstPeriod) + " Age of First Birth = " + str(womansAgeOfFirstLiveBirth) + " relativeCount = " + str(relativeCount))

      response =  BreastRiskAssessmentTool.bcRatRisk(age,race, numberOfBiopsy, ageFirstPeriod, womansAgeOfFirstLiveBirth, oneBiopsyWithAtypcialHyperplasia,  relativeCount, errors)
      logging.debug("The response is " + str(response) )

      return response;
    except Exception as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
      logging.debug("EXCEPTION------------------------------" + str(exc_type) + " "  + str(fname) + " " + str(exc_tb.tb_lineno))
      logging.debug(e)
      return BreastRiskAssessmentTool.buildFailure(str(e))
    except KeyError as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
      logging.debug("EXCEPTION------------------------------" + str(exc_type) + " "  + str(fname) + " " + str(exc_tb.tb_lineno))
      return BreastRiskAssessmentTool.buildFailure(str(e))

  if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()

    # Default port is 9200
    parser.add_argument('-p', '--port', type = int, dest = 'port', default = 9200, help = 'Sets the Port')
    parser.add_argument('-d', '--debug', action = 'store_true', help = 'Enables debugging')
    args = parser.parse_args()
    if (args.debug):
        @app.route('/common/<path:path>')
        def common_folder(path):
            return send_from_directory("C:\\common\\",path)

        @app.route('/<path:path>')
        def static_files(path):
            if (path.endswith('/')):
                path += 'index.html'
            return send_from_directory(os.getcwd(),path)
    #end remove
    app.run(host = '0.0.0.0', port = args.port, debug = args.debug, use_evalex = False)
