import math
import os
import sys

from flask import Flask, Response, request, jsonify, send_from_directory
from CcratRunFunction import AbsRisk

app = Flask(__name__, static_folder="", static_url_path="")

class ColorectalRiskAssessmentTool:
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

  @app.route('/colorectalcancerrisk/rest/calculate', methods=['POST'])
  @app.route('/colorectalcancerrisk/rest/calculate/', methods=['POST'])
  def ccratRisk():
    try:
      parameters = dict(request.form)
      for field in parameters:
        parameters[field] = parameters[field][0]
      errorObject = {'missing':[],'nonnumeric':[],'message':[]}
      requiredParameters = ['age','height_feet','height_inches','weight','veg_servings','exam','aspirin','non_aspirin','vigorous_months','family_cancer']
      if ('race' not in parameters):
        errorObject['missing'] += ['race']
      else:
        race = parameters['race']
      yearsSmoking = 0
      cigarettesPerDay = 0
      hormoneUsage = 0
      if (parameters['gender'] == 'Male'):
        sex = 0
        requiredParameters += ['cigarettes']
      elif (parameters['gender'] == 'Female'):
        sex = 1
        requiredParameters += ['period']
      else:
        errorObject['missing'] += ['gender']
      if (parameters['exam'] == '0'):
        requiredParameters += ['polyp']
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
        if (age < 50 or age > 89):
          errorObject['message'] += ["This tool cannot be used to assess risk for those under the age of 50 or over the age of 89."]
      if sex == 0:
        if 'cigarettes' not in errorObject['missing'] and parameters['cigarettes'] == '0':
          if 'smoke_age' not in parameters or parameters['smoke_age'] == '':
            errorObject['missing'] += ['smoke_age']
          elif not parameters['smoke_age'].isnumeric():
            errorObject['nonnumeric'] += ['smoke_age']
          elif parameters['smoke_age'] != '0':
            smoke_age = int(parameters['smoke_age'])
            if smoke_age > age:
              errorObject['message'] += ["You are not old enough to have started smoke at age "+str(smoke_age)]
            else:
              if 'cigarettes_num' not in parameters or parameters['cigarettes_num'] == '':
                errorObject['missing'] += ['cigarettes_num']
              elif not parameters['cigarettes_num'].isnumeric():
                errorObject['nonnumeric'] += ['cigarettes_num']
              else:
                cigarettesPerDay = int(parameters['cigarettes_num'])
              if 'smoke_now' not in parameters or parameters['smoke_now'] == '':
                errorObject['missing'] += ['smoke_now']
              elif parameters['smoke_now'] == '1':
                yearsSmoking = age - smoke_age
              elif parameters['smoke_now'] == '0':
                if 'smoke_quit' not in parameters or parameters['smoke_quit'] == '':
                  errorObject['missing'] += ['smoke_quit']
                elif not parameters['smoke_quit'].isnumeric():
                  errorObject['nonnumeric'] += ['smoke_quit']
                else:
                  quit_age = int(parameters['smoke_quit'])
                  if quit_age < smoke_age:
                    errorObject['message'] += ["You can't have quit smoking before you started"]
                  else:
                    yearsSmoking = quit_age - smoke_age
              else:
                errorObject['missing'] += ['smoke_now']
      else:
        hormoneUsage = 0
        if 'period' not in errorObject['missing'] and 'period' not in errorObject['nonnumeric'] and parameters['period'] == '1':
          if 'last_period' not in parameters or parameters['last_period'] == "":
            errorObject['missing'] += ['last_period']
          elif not parameters['last_period'].isnumeric():
            errorObject['nonnumeric'] += ['last_period']
          elif parameters['last_period'] == "2":
            if 'hormones' not in parameters or parameters['hormones'] == "":
              errorObject['missing'] += ['hormones']
            elif not parameters['hormones'].isnumeric():
              errorObject['nonnumeric'] += ['hormones']
            else:
              hormoneUsage = int(parameters['hormones'])
      family_cancer = int(parameters['family_cancer'])
      if (family_cancer > 0):
        if 'family_count' not in parameters or parameters['family_count'] == '':
          errorObject['missing'] += ['family_count']
        elif not parameters['family_count'].isnumeric():
          errorObject['nonnumeric'] += ['family_count']
        else:
          family_cancer += int(parameters['family_count'])
      hoursPerWeek = int(parameters['vigorous_months'])
      if hoursPerWeek > 0:
        if 'vigorous_hours' not in parameters or parameters['vigorous_hours'] == '':
          errorObject['missing'] += ['vigorous_hours']
        else:
          try:
            hoursPerWeek = hoursPerWeek/12 * float(parameters['vigorous_hours'])
          except:
            errorObject['nonnumeric'] += ['vigorous_hours']
      servingsPerDay = 0
      if 'veg_servings' not in errorObject['missing'] and 'veg_servings' not in errorObject['nonnumeric'] and parameters['veg_servings'] != '0':
        servingsPerDay = float(parameters['veg_servings'])
        if 'veg_amount' not in parameters or parameters['veg_amount'] == "":
          errorObject['missing'] += ['veg_amount']
        else:
          try:
            servingsPerDay *= float(parameters['veg_amount'])/3.5 #Half Cup servings per day
          except:
            errorObject['nonnumeric'] += ['veg_amount']
      if len(errorObject['missing']) > 0 or len(errorObject['nonnumeric']) > 0 or len(errorObject['message']) > 0:
        return ColorectalRiskAssessmentTool.buildFailure(errorObject);
      screening = int(parameters['exam'])
      if screening == 0:
        screening += int(parameters['polyp'])
      if yearsSmoking == 0:
        yearsSmoking = 0
      elif yearsSmoking < 15:
        yearsSmoking = 1
      elif yearsSmoking < 35:
        yearsSmoking = 2
      else:
        yearsSmoking = 3
      exercise = 3
      if hoursPerWeek > 4:
        exercise = 0
      elif hoursPerWeek > 2:
        exercise = 1
      elif hoursPerWeek > 0:
        exercise = 2
      else:
        exercise = 3
      veggies = 1
      if servingsPerDay > 5:
        veggies = 0
      height = (int(parameters['height_feet'])*12+int(parameters['height_inches']))*.0254
      weight = int(parameters['weight'])*0.453592
      bmi = weight/height/height
      if sex == 0:
        if bmi < 24.9:
          bmi = 0
        elif bmi < 29.9:
          bmi = 1
        else:
          bmi = 2
      else:
        if bmi < 30:
          bmi = 0
        else:
          bmi = 1
      aspirin = int(parameters['aspirin'])
      nonAspirin = int(parameters['non_aspirin'])
      nsaidRegimine = min(aspirin,nonAspirin)
      aspirinOnly = nonAspirin
      risk = AbsRisk("Male" if sex == 0 else "Female",race,age,min(age+5,90),screening,yearsSmoking,cigarettesPerDay,nsaidRegimine,aspirinOnly,family_cancer,exercise,veggies,bmi,hormoneUsage)
      risk = round(risk*100,1)
      return ColorectalRiskAssessmentTool.buildSuccess(str(risk))
    except Exception as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
      print("EXCEPTION------------------------------", exc_type, fname, exc_tb.tb_lineno)
      return ColorectalRiskAssessmentTool.buildFailure(str(e))

  def __init__(self,port,debug):
    app.run(host='0.0.0.0', port=port, debug=debug)

if __name__ == '__main__':
  import argparse
  parser = argparse.ArgumentParser()
  parser.add_argument("-p", dest="port_number", default="8070", help="Sets the Port")
  parser.add_argument("--debug", action="store_true")

  args = parser.parse_args()
  port_num = int(args.port_number);
  ColorectalRiskAssessmentTool(port_num, args.debug)
