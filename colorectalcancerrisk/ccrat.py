import json
from traceback import format_exc
from flask import Flask, request, jsonify
from CcratRunFunction import AbsRisk, AvgRisk

app = Flask(__name__, static_folder='', static_url_path='')

def pprint(obj):
  """ Formats and prints a data structure """
  import pprint
  pp = pprint.PrettyPrinter(indent=4)
  pp.pprint(obj)


def calculate_bmi(height_in, weight_pds):
  """ BMI Formula is weight_kg/(height_m^2) """
  weight_kg = weight_pds * 0.453592
  height_m = height_in * 0.0254
  return weight_kg / (height_m * height_m)


def numeric_dict(dictionary):
  """ Converts a dict's numeric values to the correct type  """
  obj = {}
  for key, value in dictionary.iteritems():
    if value.replace('.', '').isdigit():
      obj[key] = float(value)
    else:
      obj[key] = str(value)
  return obj


@app.errorhandler(Exception)
def error_handler(e):
    """ Ensure errors are logged and returned as json """
    app.logger.error(format_exc())
    return jsonify(
      message=str(e),
      errorType='message',
      success=False
    ), 500


@app.route('/ping', strict_slashes=False)
def ping():
    """ Healthcheck endpoint """
    return jsonify(True)


@app.route('/calculate', methods=['POST'], strict_slashes=False)
def calculate():

  # ensure numeric parameters have the correct type
  form = numeric_dict(request.form)

  # log form
  pprint(form)

  # get gender
  gender = form['gender']

  # determine race
  race = 'Hispanic' if form.get('hispanic') == 0 else form['race']

  # get age
  age = int(form['age'])
  max_age = 90

  # determine bmi_group
  height_inches = 12 * form['height_ft'] + form['height_in']
  weight_pounds = form['weight']
  bmi = calculate_bmi(height_inches, weight_pounds)
  bmi_group = 0

  # females: (0 = bmi < 30, 1 = bmi >= 30)
  if gender == 'Female':
    if bmi >= 30:
      bmi_group = 1
  # males (0 = bmi < 25, 1 = 25 <= bmi < 30, 2 = bmi >= 30)
  elif gender == 'Male':
    if bmi >= 30:
      bmi_group = 2
    elif bmi >= 25:
      bmi_group = 1

  # determine exercise_group
  weekly_exercise_hours = form.get('vigorous_hours', 0) \
                        * form.get('vigorous_months', 0) \
                        / 12.0
  exercise_group = 0
  if weekly_exercise_hours > 4:
    exercise_group = 3
  elif weekly_exercise_hours > 2:
    exercise_group = 2
  elif weekly_exercise_hours > 0:
    exercise_group = 1

  # invert exercise_group for calculation
  exercise_group = 3 - exercise_group

  # determine crc screening_status
  # 0: colonscopy done, no polyps
  # 1: no colonoscopy
  # 2: colonoscopy done, polyps present
  # 3: unknown colonoscopy or polyp history
  #
  # UI
  # exam (0 = yes, 1 = no, 2 =  don't know)
  # polyp (0 = yes, 1 = no, 2 = don't know)
  screening_status = 3

  # screening done
  if form['exam'] == 0:
    # screening done, polyps present
    if form['polyp'] == 0:
      screening_status = 2

    # screening done, no polyps
    elif form['polyp'] == 1:
      screening_status = 0

    # screening done, unknown polyp history
    elif form['polyp'] == 2:
      screening_status = 3

  # no screening done
  elif form['exam'] == 1:
      screening_status = 1

  # unknown screening history
  elif form['exam'] == 2:
    screening_status = 3


  # determine if aspirin or nsaids have NOT been used
  # 0: yes, aspirin/nsaids (ibuprofen, etc) have been used
  # 1: no, aspirin/nsaids (ibuprofen, etc) have NOT been used
  #
  # UI
  # aspirin (0 = Yes, 1 = No, 3 = Unknown)
  # non_aspirin (0 = Yes, 1 = No, 3 = Unknown)
  no_aspirin = form['aspirin']
  no_nsaids = form['non_aspirin']

  # because aspirin is an nsaid, if we use aspirin, we must set no_nsaids to false (0)
#  if no_aspirin == 0:
#    no_nsaids = 0


  # determine if estrogen was NOT used in the past two years
  # 0: estrogen used, or still has periods, or last period was < 2 years ago
  # 1: estrogen NOT used in last 2 years
  #
  # UI
  # period (0 = Yes, 1 = No)
  # last_period (0 = within last year, 1 = 1-2 years ago, 2 = 2 or more years ago)
  # hormones (0 = Yes, 1 = No)
  no_estrogen = 1
  if gender == 'Female':
    # the following indicate estrogen usage
    no_estrogen = 0 if (
      form.get('hormones') == 0 or # used hormones
      form.get('period') == 0 or # still has periods
      form.get('last_period') in [0, 1] # period within last 2 years
    ) else 1

  # determine if under 5 servings of vegetables are consumed per week (0: false, 1: true)
  weekly_veg_servings  = 0.5 * form.get('veg_amount', 0) * form.get('veg_servings', 0)
  under_5_weekly_veg_servings = 1 if weekly_veg_servings < 5 else 0

  # determine number of relatives with crc
  # 0: 0 relatives with crc, or don't know if relatives have crc
  # 1: 1 relative with crc, or has relatives with crc, but don't know how many
  # 2: 2 or more relatives with crc
  #
  # UI
  # family_cancer (1 = yes, 0 = no/unknown)
  # family_count (1 member = 0, 2 or more = 1, unknown = 0)
  num_relatives_with_crc = form['family_cancer'] + form.get('family_count', 0)


  # determine categories for number of years smoked and number of cigarettes smoked per day
  # years_smoked
  # 0: 0 years smoking, or do not know (< 100)
  # 1: years smoking > 0 and < 15
  # 2: years smoking >= 15 and < 35
  # 3: years smoking >= 35
  #
  # cigarettes_per_day
  # 0: 0 cigarettes per day, or do not know
  # 1: cigarettes >=1 and < 11
  # 2: cigarettes >= 11 and <= 20
  # 3: cigarettes >= 21
  #
  # UI
  # cigarettes > 100 (0 = Yes, 1 = No, 2 = Unknown)
  # smoke_age (12 -> current age)
  # smoke_now (1 = Yes, 0 = No)
  # smoke_quit (smoke_age -> current age)
  # cigarettes_num (0 = 0 cigs/day, 1 = 1-10, 2 = 11-20, 3 = more than 20)
  years_smoked = 0
  cigarettes_per_day = form.get('cigarettes_num', 0)

  # if the patient is a smoker, or a former smoker
  if gender == 'Male' and form.get('cigarettes', None) == 0:
    raw_years_smoked = form.get('smoke_quit', max_age) \
                     - form.get('smoke_age')
    # determine category for years_smoked
    if raw_years_smoked >= 21:
      years_smoked = 3
    elif raw_years_smoked >= 11:
      years_smoked = 2
    elif raw_years_smoked >= 1:
      years_smoked = 1


  patient_5_year_risk = AbsRisk(
    gender,
    race,
    age,
    min(age + 5, max_age),
    screening_status,
    years_smoked,
    cigarettes_per_day,
    no_nsaids,
    no_aspirin,
    num_relatives_with_crc,
    exercise_group,
    under_5_weekly_veg_servings,
    bmi_group,
    no_estrogen
  )

  average_5_year_risk = AvgRisk(
    gender,
    race,
    age,
    min(age + 5, max_age),
    screening_status,
    years_smoked,
    cigarettes_per_day,
    no_nsaids,
    no_aspirin,
    num_relatives_with_crc,
    exercise_group,
    under_5_weekly_veg_servings,
    bmi_group,
    no_estrogen
  )

  patient_10_year_risk = AbsRisk(
    gender,
    race,
    age,
    min(age + 10, max_age),
    screening_status,
    years_smoked,
    cigarettes_per_day,
    no_nsaids,
    no_aspirin,
    num_relatives_with_crc,
    exercise_group,
    under_5_weekly_veg_servings,
    bmi_group,
    no_estrogen
  )

  average_10_year_risk = AvgRisk(
    gender,
    race,
    age,
    min(age + 10, max_age),
    screening_status,
    years_smoked,
    cigarettes_per_day,
    no_nsaids,
    no_aspirin,
    num_relatives_with_crc,
    exercise_group,
    under_5_weekly_veg_servings,
    bmi_group,
    no_estrogen
  )

  patient_lifetime_risk = AbsRisk(
    gender,
    race,
    age,
    max_age,
    screening_status,
    years_smoked,
    cigarettes_per_day,
    no_nsaids,
    no_aspirin,
    num_relatives_with_crc,
    exercise_group,
    under_5_weekly_veg_servings,
    bmi_group,
    no_estrogen
  )

  average_lifetime_risk = AvgRisk(
    gender,
    race,
    age,
    max_age,
    screening_status,
    years_smoked,
    cigarettes_per_day,
    no_nsaids,
    no_aspirin,
    num_relatives_with_crc,
    exercise_group,
    under_5_weekly_veg_servings,
    bmi_group,
    no_estrogen
  )

  output = {
    'risk': patient_5_year_risk,
    'average5YearRisk': average_5_year_risk,
    'patient10YearRisk': patient_10_year_risk,
    'average10YearRisk': average_10_year_risk,
    'patientLifetimeRisk': patient_lifetime_risk,
    'averageLifetimeRisk': average_lifetime_risk,
  }

  pprint(output)

  for key, value in output.iteritems():
    output[key] = round(value * 100, 1)

  return jsonify(
    message=json.dumps(output),
    success=True
  )



if __name__ == '__main__':
  from argparse import ArgumentParser
  parser = ArgumentParser()
  parser.add_argument("-p", dest="port", default="8134", help="Sets the Port")
  args = parser.parse_args()
  app.run(host='0.0.0.0', port=int(args.port), debug=True)