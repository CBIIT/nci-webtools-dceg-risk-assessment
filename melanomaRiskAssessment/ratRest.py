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
      [3.6,4.12,4.49],
      [6.3,7.19,7.85],
      [9.96,11.38,12.42],
      [14.7,16.79,18.32],
      [20.57,23.50,25.64],
      [27.65,31.58,34.46],
      [35.97,41.10,44.84],
      [45.59,52.08,56.82],
      [56.51,64.55,70.43],
      [68.76,78.55,85.70],
      [82.35,94.07,102.64]
    ], [
      [8.12,8.84,9.35],
      [11.45,12.47,13.18],
      [14.91,16.23,17.16],
      [18.35,19.98,21.12],
      [21.66,23.58,24.93],
      [24.75,26.94,28.48],
      [27.55,30.00,31.71],
      [30.04,32.70,34.57],
      [32.17,35.02,37.03],
      [33.95,36.96,39.08],
      [35.38,38.51,40.72]
    ]
  ]
  MRAT_MORTALITY = [
    [122.86, 127.25, 161.32, 209.35, 283.55, 404.72, 608.14, 979.82, 1600.96, 2490.23, 3824.02],
    [43.13, 49.40, 66.13, 96.86, 142.86, 221.75, 359.32, 588.77, 955.41, 1478.73, 2316.32]
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
      if len(missingParameters) > 0:
        return RiskAssessmentTools.buildFailure(str(missingParameters))
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
      age = int(parameters['age'])
      region = int(parameters['region'])
      ageIndex = int((age-20)/5)
      t1 = ageIndex*5+20
      t2 = t1+5
      h11 = RiskAssessmentTools.MRAT_SEX[sex]*RiskAssessmentTools.MRAT_INCIDENCE[sex][ageIndex][region]
      h21 = RiskAssessmentTools.MRAT_MORTALITY[sex][ageIndex]
      risk = h11*r*(1-math.exp((age-t2)*(h11*r+h21)))/(h11*r+h21)
      print risk
      if age != t1:
        h12 = RiskAssessmentTools.MRAT_SEX[sex]*RiskAssessmentTools.MRAT_INCIDENCE[sex][ageIndex+1][region]
        h22 = RiskAssessmentTools.MRAT_MORTALITY[sex][ageIndex+1]
        risk += h12*r*math.exp((age-t2)*(h11*r+h21))*(1-math.exp((t1-age)*(h12*r+h22)))/(h12*r+h22)
        print h12*r*math.exp((age-t2)*(h11*r+h21))*(1-math.exp((t1-age)*(h12*r+h22)))/(h12*r+h22)
      risk *= 100
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
