import math
import os
import sys

from flask import Flask, Response, request, jsonify, send_from_directory
from MratConstants import MratConstants

app = Flask(__name__, static_folder="", static_url_path="")

class MelanomaRiskAssessmentTool:
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

  @app.route('/melanomarisktool/rest/calculate', methods=['POST'])
  @app.route('/melanomarisktool/rest/calculate/', methods=['POST'])
  def mratRisk():
    try:
      parameters = dict(request.form)
      for field in parameters:
        parameters[field] = parameters[field][0]
      requiredParameters = ['race','age']
      errorObject = {'missing':[],'nonnumeric':[]}
      if parameters['state'] == '':
        errorObject['missing'] += ['state']
      elif isinstance(MratConstants.RegionIndex[parameters['state']],dict):
        if parameters['county'] == '':
          errorObject['missing'] += ['county']
        else:
          region = MratConstants.RegionIndex[parameters['state']][parameters['county']]
      else:
        region = MratConstants.RegionIndex[parameters['state']]
      if (parameters['gender'] == 'Male'):
        sex = 0
        requiredParameters += ['sunburn','complexion','big-moles','small-moles','freckling','damage']
      elif (parameters['gender'] == 'Female'):
        sex = 1
        requiredParameters += ['complexion','tan','small-moles','freckling']
      else:
        errorObject['missing'] += ['gender']
      for required in requiredParameters:
        if required not in parameters or parameters[required] == "":
          errorObject['missing'].append(required)
        elif not parameters[required].isnumeric():
          errorObject['nonnumeric'].append(required)
      if 'age' not in errorObject['missing'] and 'age' not in errorObject['nonnumeric']:
        age = int(parameters['age'])
        if (age < 20 or age > 70):
          errorObject['message'] = "This tool cannot be used to assess risk for those under the age of 20 or over the age of 70.";
          return MelanomaRiskAssessmentTool.buildFailure(errorObject)
      if len(errorObject['missing']) > 0 or len(errorObject['nonnumeric']) > 0:
        return MelanomaRiskAssessmentTool.buildFailure(errorObject);
      r = 1
      if sex == 0:
        r *= MratConstants.SUNBURN[int(parameters['sunburn'])]
        r *= MratConstants.MALE_COMPLEXION[int(parameters['complexion'])]
        r *= MratConstants.BIG_MOLES[int(parameters['big-moles'])]
        r *= MratConstants.MALE_SMALL_MOLES[int(parameters['small-moles'])]
        r *= MratConstants.MALE_FRECKLING[int(parameters['freckling'])]
        r *= MratConstants.DAMAGE[int(parameters['damage'])]
      else:
        r *= MratConstants.TAN[int(parameters['tan'])]
        r *= MratConstants.FEMALE_COMPLEXION[int(parameters['complexion'])]
        r *= MratConstants.FEMALE_SMALL_MOLES[int(parameters['small-moles'])]
        r *= MratConstants.FEMALE_FRECKLING[int(parameters['freckling'])]
      ageIndex = int((age-20)/5)
      t1 = ageIndex*5+20
      t2 = t1+5
      h11 = MratConstants.SEX[sex]*MratConstants.INCIDENCE[sex][ageIndex][region]
      h21 = MratConstants.MORTALITY[sex][ageIndex]
      risk = h11*r*(1-math.exp((age-t2)*(h11*r+h21)))/(h11*r+h21)
      if age != t1:
        h12 = MratConstants.SEX[sex]*MratConstants.INCIDENCE[sex][ageIndex+1][region]
        h22 = MratConstants.MORTALITY[sex][ageIndex+1]
        risk += h12*r*math.exp((age-t2)*(h11*r+h21))*(1-math.exp((t1-age)*(h12*r+h22)))/(h12*r+h22)
      risk = round(risk*10000)/100
      return MelanomaRiskAssessmentTool.buildSuccess(str(risk))
    except Exception as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
      print("EXCEPTION------------------------------", exc_type, fname, exc_tb.tb_lineno)
      return MelanomaRiskAssessmentTool.buildFailure(str(e))

  def __init__(self,port,debug):
    app.run(host='0.0.0.0', port=port, debug=debug)

if __name__ == '__main__':
  import argparse
  parser = argparse.ArgumentParser()
  parser.add_argument("-p", dest="port_number", default="8030", help="Sets the Port")
  parser.add_argument("--debug", action="store_true")

  args = parser.parse_args()
  port_num = int(args.port_number);
  MelanomaRiskAssessmentTool(port_num, args.debug)
