import math
import os
import sys
import json
import logging

from flask import Flask, Response, request, jsonify, send_from_directory
from CcratRunFunction import AbsRisk
from CcratRunFunction import AvgRisk

app = Flask(__name__, static_folder='', static_url_path='')

class ColorectalRiskAssessmentTool:
  @staticmethod
  def buildFailure(message):
    if (isinstance(message, str)):
      response = jsonify(message=message, errorType="message", success=False)
    else:
      message['success'] = False
      response = jsonify(message)
    response.mimetype = 'application/json'
    response.status_code = 400
    return response

  @staticmethod
  def buildSuccess(message):
    if (isinstance(message, str)):
      response = jsonify(message=message, success=True)
    else:
      message['success'] = True
      response = jsonify(message)
    response.mimetype = 'application/json'
    response.status_code = 200
    return response

  @staticmethod
  def mapMedicationUnknown(answer):
    return 0 if answer == 3 else answer

  # Calculate the Aspirin Only and nsaids values
  # For any input the value 0 = "Yes" and value 1 == "No"
  @staticmethod
  def generateAspirinOnlyAndNsaids(aspirin, non_aspirin):
    values = {}
    if ( aspirin == 1 and non_aspirin == 1 ):
      values['aspirinOnly'] = 1
      values['nsaidRegime'] = 1
    else:
      values['aspirinOnly'] = 0
      values['nsaidRegime'] = 0

    return values

  @app.route('/calculate', methods=['POST'] )
  def ccratRisk():
    try:
      parameters = dict(request.form)
      for field in parameters:
        parameters[field] = parameters[field][0]
      errorObject = {'missing':[],'nonnumeric':[],'message':[]}
      requiredParameters = ['age', 'height_ft', 'height_in', 'weight', 'veg_servings', 'exam', 'aspirin', 'non_aspirin', 'vigorous_months', 'family_cancer']

      # The valid values of race are White, African Amierican or Asian
      # Whether you are hispanic or not is determined by another variable.
      if ( ('race' not in parameters) and ('hispanic' not in parameters) ):
        errorObject['missing'] += ['race or hispanic']
      elif ( 'race' in parameters ):
        race = parameters['race']
      else:
        race = 'Hispanic'

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
      if ( int(parameters['exam']) == 0 ):
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
        if (age < 45 or age > 89):
          errorObject['message'] += ["This tool cannot be used to assess risk for those under the age of 45 or over the age of 89."]
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


          if ( cigarettesPerDay == 0 ):
            yearsSmoking = 0

          if ( yearsSmoking == 0 ):
            cigarettesPerDay = 0


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
            hoursPerWeek = float(hoursPerWeek)/12 * float(parameters['vigorous_hours'])
          except:
            errorObject['nonnumeric'] += ['vigorous_hours']



      servingsPerDay = 0
      if 'veg_servings' not in errorObject['missing'] and 'veg_servings' not in errorObject['nonnumeric'] and parameters['veg_servings'] != '0' :
        servingsPerDay = float(parameters['veg_servings'])
        if 'veg_amount' not in parameters or parameters['veg_amount'] == "":
          errorObject['missing'] += ['veg_amount']
        else:
          try:
            servingsPerDay *= float(parameters['veg_amount'])/3.5 #Half Cup servings per day
          except:
            errorObject['nonnumeric'] += ['veg_amount']

      # Calculate the nsaidRegime and Aspirin variables
      aspirin = -1
      try:
        aspirin     = ColorectalRiskAssessmentTool.mapMedicationUnknown(int(parameters['aspirin']))
      except:
        errorObject['nonnumeric'].append("aspirin")

      nonAspirin = -1
      try:
        nonAspirin  = ColorectalRiskAssessmentTool.mapMedicationUnknown(int(parameters['non_aspirin']))
      except:
        errorObject['nonnumeric'].append("non_aspirin")

      returnValues = ColorectalRiskAssessmentTool.generateAspirinOnlyAndNsaids(aspirin, nonAspirin)

      nsaidRegime = returnValues['nsaidRegime']
      aspirinOnly = returnValues['aspirinOnly']

      # End Calculation if there are any errors
      if len(errorObject['missing']) > 0 or len(errorObject['nonnumeric']) > 0 or len(errorObject['message']) > 0:
        return ColorectalRiskAssessmentTool.buildFailure(errorObject);

      # For this section 0 = "Yes", 1 = "No" and 2 or greater = "Unknown"
      screening = int(parameters['exam'])
      polyp = int(parameters['polyp']) if ('polyp' in parameters ) else "-1"
      if ( screening == 0 and polyp == 1 ):
        screening = 0
      elif ( screening == 0 and polyp == 2):
        screening = 0
      elif ( screening == 1 ):
        screening = 1
      elif ( screening == 0 and polyp == 0 ):
        screening = 2
      elif ( screening == 2):
        screening = 3

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
      if servingsPerDay >= 5:
        veggies = 0


      height = (int(parameters['height_ft'])*12+int(parameters['height_in']))*.0254
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

      gender = "Male" if sex == 0 else "Female"

      print("&&&&&&&&&&&&&&&&&&&&&& Parameters &&&&&&&&&&&&&&&&&&&&&&&&&")
      print(("The race                 = "   + str(race)))
      print(("The age                  = "   + str(age)))
      print(("Gender                   = "   + str(gender)))
      print(("Feet                     = "   + str(parameters['height_ft'])))
      print(("Inches                   = "   + str(parameters['height_in'])))
      print(("Weight                   = "   + str(parameters['weight'])))
      print(("RAW BMI = " + str(bmi)))
      print(("bmi                      = "   + str(bmi)))
      print ("--- Exercise ")
      print(("Exercise : Vigorous Months = " + str(parameters['vigorous_months']) + ""))
      if 'vigorous_hours' not in parameters or parameters['vigorous_hours'] == '':
        print("Exercise : Vigorous Hours = Not Used")
      else:
        print(("Exercise: VigorousHours = " + str(parameters['vigorous_hours'])))
      print(("Exercise : Hourse Per Week = " + str(hoursPerWeek)))
      print("--- End Exercise")
      print("--- Vegatable Intake ")
      print(("Servings Per Day : Veg Servings = " + str(parameters['veg_servings'])))
      if 'veg_amount' not in parameters or parameters['veg_amount'] == "":
        print("Servings Per Day : Veg Servings is not used")
      else:
        print(("Servings Per Day : Veg Servings = " + str(parameters['veg_amount'])))
      print(("Servings Per Day : " + str(servingsPerDay)))
      print("--- End Vegatable Intake")
      print(("veggies  (ok verified)   = "   + str(veggies)))
      print(("exercise                 = "   + str(exercise)))
      print(("Values for screening = " + str(screening) + "," + "polyp  = " + str(polyp)))
      print(("The screening            = "   + str(screening)))
      print(("Original Values of Aspirin, nonAspirin = " + str(aspirin) + "," + str(nonAspirin)))
      print(("Asprin                   = "   + str(aspirinOnly)))
      print(("nsaidRegime              = "   + str(nsaidRegime)))
      print(("family_cancer            = "   + str(family_cancer)))
      print(("Male Years Smoking       = "   + str(yearsSmoking)))
      print(("Male Cigs per Day        = "   + str(cigarettesPerDay)))
      print(("Female hormoneUsage      = "   + str(hormoneUsage)))



      #************************************************************************************************************
      #* 5 Year Patient and Average Risk                                                                          *
      #************************************************************************************************************
      patient5YearRisk = AbsRisk(gender,
        race,
        age,
        min(age+5, 90),
        screening,
        yearsSmoking,
        cigarettesPerDay,
        nsaidRegime,
        aspirinOnly,
        family_cancer,
        exercise,
        veggies,
        bmi,
        hormoneUsage)
      patient5YearRisk = round(patient5YearRisk*100, 1)

      average5YearRisk = AvgRisk(gender,
        race,
        age,
        min(age+5, 90),
        screening,
        yearsSmoking,
        cigarettesPerDay,
        nsaidRegime,
        aspirinOnly,
        family_cancer,
        exercise,
        veggies,
        bmi,
        hormoneUsage)

      average5YearRisk = round(average5YearRisk*100, 1)

      #************************************************************************************************************
      #* Lifetime Patient and Average Risk                                                                        *
      #************************************************************************************************************
      patientLifetimeRisk = AbsRisk(gender,
        race,
        age,
        90,
        screening,
        yearsSmoking,
        cigarettesPerDay,
        nsaidRegime,
        aspirinOnly,
        family_cancer,
        exercise,
        veggies,
        bmi,
        hormoneUsage)
      patientLifetimeRisk = round(patientLifetimeRisk*100, 1)

      averageLifetimeRisk = AvgRisk(gender,
        race,
        age,
        90,
        screening,
        yearsSmoking,
        cigarettesPerDay,
        nsaidRegime,
        aspirinOnly,
        family_cancer,
        exercise,
        veggies,
        bmi,
        hormoneUsage)

      averageLifetimekRisk = round(averageLifetimeRisk*100, 1)

      #************************************************************************************************
      #* Combine all the values into one struture to be sent to another tier                          *
      #************************************************************************************************
      results = {}
      results['risk']                 = patient5YearRisk
      results['average5YearRisk']     = average5YearRisk
      results['patientLifetimeRisk']  = patientLifetimeRisk
      results['averageLifetimeRisk']  = averageLifetimekRisk

      json_data = json.dumps(results)
      print(("The JSON Data is " + json_data))
      return ColorectalRiskAssessmentTool.buildSuccess(json_data)
    except Exception as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
      print(("EXCEPTION------------------------------", exc_type, fname, exc_tb.tb_lineno))
      print("Exception------------------------------")
      print((str(e)))
      return ColorectalRiskAssessmentTool.buildFailure(str(e))

  def __init__(self, port, debug):
    app.run(host='0.0.0.0', port=port, debug=True)

if __name__ == '__main__':
  import argparse
  parser = argparse.ArgumentParser()
  parser.add_argument("-p", dest="port_number", default="8134", help="Sets the Port")
  parser.add_argument("--debug", action="store_true")

  args = parser.parse_args()
  port_num = int(args.port_number);
  ColorectalRiskAssessmentTool(port_num, args.debug)
