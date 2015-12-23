import math
import os
import sys
from flask import Flask, Response, request, jsonify, send_from_directory

app = Flask(__name__, static_folder="", static_url_path="")

class RiskAssessmentTools:
  # 1-Attribute
  MRAT_SEX = [0.144,0.106]
  MRAT_BLISTERING = [1.437,1]
  MRAT_FEMALE_COMPLEXION = [1.802,1,1]
  MRAT_MALE_COMPLEXION = [1.767,1,1]
  MRAT_TANNING = [1,1,1.926,1.926]
  MRAT_BIG_MOLES = [1,2.412]
  MRAT_FEMALE_SMALL_MOLES = [1,2.512,5.154]
  MRAT_MALE_SMALL_MOLES = [1,1.935,4.630]
  MRAT_FEMALE_FRECKLING = [2.174,3.856,3.856]
  MRAT_MALE_FRECKLING = [1,1.830,1.830]
  MRAT_SOLAR_DAMAGE = [2.803,1]
  MRAT_INCIDENCE = [
    [
      [.0000360,.0000412,.0000449],
      [.0000630,.0000719,.0000785],
      [.0000996,.0001138,.0001242],
      [.0001470,.0001679,.0001832],
      [.0002057,.0002350,.0002564],
      [.0002765,.0003158,.0003446],
      [.0003597,.0004110,.0004484],
      [.0004559,.0005208,.0005682],
      [.0005651,.0006455,.0007043],
      [.0006876,.0007855,.0008570],
      [.0008235,.0009407,.0010264]
    ], [
      [.0000812,.0000884,.0000935],
      [.0001145,.0001247,.0001318],
      [.0001491,.0001623,.0001716],
      [.0001835,.0001998,.0002112],
      [.0002166,.0002358,.0002493],
      [.0002475,.0002694,.0002848],
      [.0002755,.0003000,.0003171],
      [.0003004,.0003270,.0003457],
      [.0003217,.0003502,.0003703],
      [.0003395,.0003696,.0003908],
      [.0003538,.0003851,.0004072]
    ]
  ]
  MRAT_MORTALITY = [
    [.0012286, .0012725, .0016132, .0020935, .0028355, .0040472, .0060814, .0097982, .0160096, .0249023, .0382402],
    [.0004313, .0004940, .0006613, .0009686, .0014286, .0022175, .0035932, .0058877, .0095541, .0147873, .0231632]
  ]

  @staticmethod
  def buildFailure(message):
    response = jsonify(message=message, success=False)
    response.mimetype = 'application/json'
    response.status_code = 400
    return response

  @staticmethod
  def buildSuccess(message):
    response = jsonify(message=message, success=True)
    response.mimetype = 'application/json'
    response.status_code = 200
    return response

  @app.route('/calculate', methods=['POST'])
  @app.route('/calculate/', methods=['POST'])
  def mratRisk():
    try:
      parameters = dict(request.form)
      for field in parameters:
        parameters[field] = parameters[field][0]
      requiredParameters = ['region','race','age']
      missingParameters = []
      nonnumericParameters = []
      if (parameters['gender'] == 'Male'):
        sex = 0
        requiredParameters += ['blistered','complexion','big-moles','small-moles','freckling','solar-damage']
      elif (parameters['gender'] == 'Female'):
        sex = 1
        requiredParameters += ['complexion','tan-level','small-moles','freckling']
      else:
        missingParameters += ['gender']
      for required in requiredParameters:
        if required not in parameters or parameters[required] == "Select":
          missingParameters.add(required)
        elif !isnumeric(parameters[required]):
          nonnumericParameters.add(required)
      if len(missingParameters) > 0:
        return RiskAssessmentTools.buildFailure(str(missingParameters))
      if len(nonnumericParameters) > 0:
        return RiskAssessmentTools.buildFailure(str(nonnumericParameters))
      age = int(parameters['age'])
      if (!isnumeric(age)):
        return RiskAssessmentTools.buildFailure("You have sent a non-numeric value for your age. That shouldn't be possible.")
      if (age < 20 || age > 70):
        return RiskAssessmentTools.buildFailure("This tool cannot be used to assess risk for those under the age of 20 or over the age of 70.")
      region = int(parameters['region'])
      if (!isnumeric(region)):
        return RiskAssessmentTools.buildFailure("You have sent a non-numeric value for your region. That shouldn't be possible.")
      r = 1
      if sex == 0:
        r *= RiskAssessmentTools.MRAT_BLISTERING[int(parameters['blistered'])]
        r *= RiskAssessmentTools.MRAT_MALE_COMPLEXION[int(parameters['complexion'])]
        r *= RiskAssessmentTools.MRAT_BIG_MOLES[int(parameters['big-moles'])]
        r *= RiskAssessmentTools.MRAT_MALE_SMALL_MOLES[int(parameters['small-moles'])]
        r *= RiskAssessmentTools.MRAT_MALE_FRECKLING[int(parameters['freckling'])]
        r *= RiskAssessmentTools.MRAT_SOLAR_DAMAGE[int(parameters['solar-damage'])]
      else:
        r *= RiskAssessmentTools.MRAT_TANNING[int(parameters['tan-level'])]
        r *= RiskAssessmentTools.MRAT_FEMALE_COMPLEXION[int(parameters['complexion'])]
        r *= RiskAssessmentTools.MRAT_FEMALE_SMALL_MOLES[int(parameters['small-moles'])]
        r *= RiskAssessmentTools.MRAT_FEMALE_FRECKLING[int(parameters['freckling'])]
      ageIndex = int((age-20)/5)
      t1 = ageIndex*5+20
      t2 = t1+5
      h11 = RiskAssessmentTools.MRAT_SEX[sex]*RiskAssessmentTools.MRAT_INCIDENCE[sex][ageIndex][region]
      h21 = RiskAssessmentTools.MRAT_MORTALITY[sex][ageIndex]
      risk = h11*r*(1-math.exp((age-t2)*(h11*r+h21)))/(h11*r+h21)
      if age != t1:
        h12 = RiskAssessmentTools.MRAT_SEX[sex]*RiskAssessmentTools.MRAT_INCIDENCE[sex][ageIndex+1][region]
        h22 = RiskAssessmentTools.MRAT_MORTALITY[sex][ageIndex+1]
        risk += h12*r*math.exp((age-t2)*(h11*r+h21))*(1-math.exp((t1-age)*(h12*r+h22)))/(h12*r+h22)
      risk = round(risk*10000)/100
      return RiskAssessmentTools.buildSuccess(str(risk))
    except Exception as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
      print("EXCEPTION------------------------------", exc_type, fname, exc_tb.tb_lineno)
      return RiskAssessmentTools.buildFailure(str(e))

  def __init__(self):
    app.run(host='0.0.0.0', port=8200, debug=True)

if __name__ == '__main__':
  RiskAssessmentTools()
