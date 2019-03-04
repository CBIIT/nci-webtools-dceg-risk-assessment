import json
from pprint import pformat
from traceback import format_exc
from flask import Flask, request, jsonify
from CcratRunFunction import AbsRisk, AvgRisk

app = Flask(__name__, static_folder='', static_url_path='')

def numeric_dict(dictionary):
  """ Creates a copy of a dict where numeric strings are converted to floats """
  obj = {}
  for key, value in dictionary.iteritems():
    if value.replace('.', '').isdigit():
      value = float(value)
    obj[key] = value
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
  # Note: since validation is done beforehand, we should not do any validation here

  # Ensure numeric parameters have the correct type
  form = numeric_dict(request.form)

  # Log form values
  app.logger.info('Form Parameters: \n' + pformat(form))

  # Get gender
  gender = form.get('gender')

  # Determine race
  race = form.get('race')
  if form.get('hispanic') == 0:
    race = 'Hispanic'

  # Get age
  age = int(form.get('age'))
  max_age = 90

  # Determine bmi_trend
  #
  # Form Values:
  # height_ft (feet)
  # height_in (inches)
  # weight (pounds)
  height_inches = 12 * form.get('height_ft', 0) + form.get('height_in', 0)
  height_m = height_inches * 0.0254
  weight_kg = form.get('weight', 0) * 0.453592
  bmi = weight_kg / (height_m * height_m)
  bmi_trend = 0

  # Female bmi_trend
  # (0) bmi < 30
  # (1) bmi >= 30
  if gender == 'Female':
    if bmi >= 30:
      bmi_trend = 1

  # Male bmi_trend
  # (0) bmi < 25
  # (1) 25 <= bmi < 30
  # (2) bmi >= 30
  elif gender == 'Male':
    if bmi >= 30:
      bmi_trend = 2
    elif bmi >= 25:
      bmi_trend = 1

  # Determine vigorous_exercise trend
  # Note: vigorous_exercise should be inverted by subtracting it from 3
  # (0) 0 hours of vigorous exercise per week
  # (1) 0 < hours <= 2
  # (2) 2 < hours <= 4
  # (3) hours > 4
  #
  # Form Values:
  # vigorous_hours (hours of vigorous exercise per week)
  # vigorous_months (months of vigorous exercise in last year)
  weekly_exercise_hours = form.get('vigorous_hours', 0) \
                        * form.get('vigorous_months', 0) \
                        / 12.0
  vigorous_exercise = 0
  if weekly_exercise_hours > 4:
    vigorous_exercise = 3
  elif weekly_exercise_hours > 2:
    vigorous_exercise = 2
  elif weekly_exercise_hours > 0:
    vigorous_exercise = 1

  # Invert vigorous_exercise for calculation
  vigorous_exercise = 3 - vigorous_exercise

  # Determine sigmoid_polyps value
  # (0) colonscopy done, no polyps
  # (1) no colonoscopy
  # (2) colonoscopy done, polyps present
  # (3) unknown colonoscopy or polyp history
  #
  #
  # Form Values:
  # exam (did the patient have a colonoscopy/sigmoidoscopy in the past decade?)
  # (0) yes
  # (1) no
  # (2) don't know
  #
  # polyp (did the patient have a colon/rectal polyp in the past decade?)
  # (0) yes
  # (1) no
  # (2) don't know
  sigmoid_polyps = 3
  exam = form.get('exam')
  polyp = form.get('polyp')

  # colonoscopy/sigmoidoscopy done
  if exam == 0:
    # screening done, polyps present
    if polyp == 0:
      sigmoid_polyps = 2

    # screening done, no polyps
    elif polyp == 1:
      sigmoid_polyps = 0

    # screening done, unknown polyp history
    elif polyp == 2:
      sigmoid_polyps = 3

  # no colonoscopy/sigmoidoscopy
  elif exam == 1:
      sigmoid_polyps = 1

  # unknown history
  elif exam == 2:
    sigmoid_polyps = 3

  # Determine if no_ibuprofen or no_nsaids have been used
  # no_ibuprofen (does the patient take nsaids that do not contain aspirin?)
  # (0) regular user of non-aspirin nsaids
  # (1) not regular user non-aspirin nsaids
  #
  # no_nsaids (does the patient take any nsaids?)
  # (0) regular user of nsaids such as ibuprofen or aspirin
  # (1) not regular user of nsaids
  #
  # Form Values:
  # aspirin (does the patient take nsaids containing aspirin?)
  # (0) yes
  # (1) no
  # (3) don't know
  #
  # non_aspirin (does the patient take nsaids containing NO aspirin?)
  # (0) yes
  # (1) no
  # (3) don't know
  no_aspirin = form['aspirin']        # 0 = Takes aspirin, 1 = No aspirin
  no_ibuprofen = form['non_aspirin']  # 0 = Takes ibuprofen, 1 = No ibuprofen
  no_nsaids = 0                       # 0 = Takes NSAIDS

  # if unknown, assume patient is a regular user
  if no_ibuprofen == 3:
    no_ibuprofen = 0

  if no_aspirin == 3:
    no_aspirin = 0

  # if no_aspirin and no_ibuprofen are used, then no_nsaids are used
  if no_aspirin == 1 and no_ibuprofen == 1:
    no_nsaids = 1

  # Determine if no_estrogen was used in the past two years
  # no_estrogen
  # (0) estrogen used, or still has periods, or last period was < 2 years ago
  # (1) NO estrogen used in last 2 years
  #
  # Form Values:
  # period (does the patient still have periods?)
  # (0) yes
  # (1) no
  #
  # last_period (when did the patient have her last period?)
  # (0) within last year
  # (1) 1 to 2 years ago (less than two years)
  # (2) 2 or more years ago
  #
  # hormones (has the patient used estrogen/hormones in the past two years?)
  # (0) yes
  # (1) no
  no_estrogen = 1  # estrogen has not been used

  # Determine if patient has had periods recently or uses hormones
  if gender == 'Female' and (
      form.get('hormones') == 0 or # uses hormones
      form.get('period') == 0 or # still has periods
      form.get('last_period') in [0, 1] # period within last 2 years
  ):# estrogen has been used
    no_estrogen = 0

  # Determine if less than 5 (lt5) servings of vegetables are consumed per week
  # weekly_veg_servings_lt5
  # (0) 5 or more servings per week
  # (1) Less than 5 servings per week
  #
  # Form Values:
  # veg_servings (how many servings of vegetables does the patient have each week?)
  # veg_amount (how much does the patient eat in each serving of vegetables, in cups?)
  #
  # Note: 0.5 cups is 1 serving
  weekly_veg_servings  = 0.5 * form.get('veg_amount', 0) * form.get('veg_servings', 0)
  weekly_veg_servings_lt5 = 1 if weekly_veg_servings < 5 else 0


  # Determine number of immediate relatives with colorectal cancer (crc)
  # family_history_crc
  # (0) 0 relatives with crc, or don't know if relatives have crc
  # (1) 1 relative with crc, or has relatives with crc, but don't know how many
  # (2) 2 or more relatives with crc
  #
  # Form Values:
  # family_cancer (has the patient had immediate relatives with crc?)
  # (1) yes
  # (0) no/unknown
  #
  # family_count (how many relatives had crc?)
  # (0) 1 member/unknown
  # (1) 2 or more = 1
  family_history_crc = form.get('family_cancer') \
                     + form.get('family_count', 0)


  # Determine categories for number of years smoked and number of cigarettes smoked per day
  # Note: only applies to males
  # cigarette_years
  # (0) 0 years smoking, do not know, or less than 100 lifetime cigarettes
  # (1) 0 < years < 15
  # (2) 15 <= years < 35
  # (3) years >= 35
  #
  # cigarettes_per_day
  # (0) 0 cigarettes per day, or do not know
  # (1) cigarettes >=1 and < 11
  # (2) cigarettes >= 11 and <= 20
  # (3) cigarettes >= 21
  #
  # Form Values:
  # cigarettes (did the patient smoke more than 100 cigarettes in their life?)
  # (0) yes
  # (1) no
  # (2) unknown (same as 1)
  #
  # smoke_age (what age did the patient start smoking?)
  #
  # smoke_now (does the patient currently smoke?)
  # (0) no
  # (1) yes
  #
  # smoke_quit (what age did the patient stop smoking?)
  #
  # cigarettes_num (how many cigarettes did the patient smoke per day?)
  # (0) 0 cigs/day
  # (1) 1-10 cigs
  # (2) 11-20 cigs
  # (3) more than 20 cigs
  cigarette_years = 0
  cigarettes_per_day = form.get('cigarettes_num', 0)

  # if the patient is a smoker, or a former smoker
  if gender == 'Male' and form.get('cigarettes', None) == 0:
    raw_years_smoked = form.get('smoke_quit', max_age) \
                     - form.get('smoke_age')
    # determine category for years_smoked
    if raw_years_smoked > 20:
      cigarette_years = 3
    elif raw_years_smoked > 10:
      cigarette_years = 2
    elif raw_years_smoked > 0:
      cigarette_years = 1


  patient_5_year_risk = AbsRisk(
    gender,
    race,
    age,
    min(age + 5, max_age),
    sigmoid_polyps,
    cigarette_years,
    cigarettes_per_day,
    no_nsaids,
    no_ibuprofen,
    family_history_crc,
    vigorous_exercise,
    weekly_veg_servings_lt5,
    bmi_trend,
    no_estrogen
  )

  average_5_year_risk = AvgRisk(
    gender,
    race,
    age,
    min(age + 5, max_age),
    sigmoid_polyps,
    cigarette_years,
    cigarettes_per_day,
    no_nsaids,
    no_ibuprofen,
    family_history_crc,
    vigorous_exercise,
    weekly_veg_servings_lt5,
    bmi_trend,
    no_estrogen
  )

  patient_lifetime_risk = AbsRisk(
    gender,
    race,
    age,
    max_age,
    sigmoid_polyps,
    cigarette_years,
    cigarettes_per_day,
    no_nsaids,
    no_ibuprofen,
    family_history_crc,
    vigorous_exercise,
    weekly_veg_servings_lt5,
    bmi_trend,
    no_estrogen
  )

  average_lifetime_risk = AvgRisk(
    gender,
    race,
    age,
    max_age,
    sigmoid_polyps,
    cigarette_years,
    cigarettes_per_day,
    no_nsaids,
    no_ibuprofen,
    family_history_crc,
    vigorous_exercise,
    weekly_veg_servings_lt5,
    bmi_trend,
    no_estrogen
  )

  output = {
    'risk': patient_5_year_risk,
    'average5YearRisk': average_5_year_risk,
    'patientLifetimeRisk': patient_lifetime_risk,
    'averageLifetimeRisk': average_lifetime_risk,
  }

  # print parameters supplied
  app.logger.info('Calculation Parameters: \n' + pformat({
    'gender': gender,
    'race': race,
    'age': age,
    'max_age': max_age,
    'sigmoid_polyps': sigmoid_polyps,
    'cigarette_years': cigarette_years,
    'cigarettes_per_day': cigarettes_per_day,
    'no_nsaids': no_nsaids,
    'no_ibuprofen': no_ibuprofen,
    'family_history_crc': family_history_crc,
    'vigorous_exercise': vigorous_exercise,
    'weekly_veg_servings_lt5': weekly_veg_servings_lt5,
    'bmi_trend': bmi_trend,
    'no_estrogen': no_estrogen
  }))

  # print calculated rates
  app.logger.info('Calculated Rates: \n' + pformat(output))

  # convert rates to percentages and round to the nearest 10th
  for key, value in output.iteritems():
    output[key] = round(value * 100, 1)

  return jsonify(
    message=json.dumps(output),
    success=True
  )


# used during local development
# ensure rat-commons is in the current directory
# start with: python ccrat.py
# http://localhost:8134/index.html
if __name__ == '__main__':
  app.run(host='0.0.0.0', port=8134, debug=True)