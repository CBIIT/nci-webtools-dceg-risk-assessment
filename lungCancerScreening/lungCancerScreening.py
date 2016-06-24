# We need to import the jsonify object, it will let us
# output json, and it will take care of the right string
# data conversion, the headers for the response, etc
import os
import re
import time
import json
import StringIO
from flask import Flask, render_template, request, jsonify, make_response
from rpy2.robjects.packages import SignatureTranslatedAnonymousPackage
from rpy2.robjects.vectors import IntVector, FloatVector
from socket import gethostname

with open ('LCWrapper.R') as fh:
        rcode = os.linesep.join(fh.readlines())
        wrapper = SignatureTranslatedAnonymousPackage(rcode,"wrapper")

# Initialize the Flask application
app = Flask(__name__)

@app.route('/')
def index():
    # Render template
    return render_template('index.html')

# This route will return a list in JSON format
@app.route('/lungCancerRest/', methods=['POST'])
def lungCancerRest():
        # Get the parsed contents of the form data

        data = request.json            
        age = data["age"];
        bmi = data["bmi"];
        cpd = data["cpd"];
        emp = data["emp"];
        famlungtrend = data["fam.lung.trend"];
        gender = data["gender"];
        qtyears = data["qtyears"];
        smkyears = data["smkyears"];
        race = data["race"];
        if race==4: # set other to white #
            race = 0 
        edu6 = data["edu6"];
        pkyrcat = data["pkyr.cat"];

        # Create results file and link to results file
        apache_root = "/analysistools/"

        # check if URL contains the keyword sandbox
        if 'sandbox' in request.url_root:
                apache_root = "/analysistools-sandbox/"

        apache_tmp_dir = apache_root+"public_html/apps/lungCancerScreening/tmp/"

        # Ensure apache tmp directory exists
        if not os.path.exists(apache_tmp_dir):
                os.makedirs(apache_tmp_dir)

        resultFile = 'results_' + time.strftime("%Y%m%d-%H%M%S") + '.txt'
        resultContent = 'Form Summary\n'
        resultNames = ['Risk of dying from lung cancer within 5 years in the absence of screening',
                       'Risk reduction due to lung cancer screening',
                       'The chance of lung cancer diagnosis within 5 years in the absence of screening',
                       'The chance of lung cancer diagnosis within 5 years with screening',
                       'The chance of having a false positive result after 3 screens',
                       'Chance of false-positive CT lung screen'
                      ]

        fromR = (wrapper.getJSONData(age,bmi,cpd,emp,famlungtrend,gender,qtyears,smkyears,race,edu6,pkyrcat))
        fromRstr = ''.join(fromR)
        string = json.loads(fromRstr)

        for i in data:
                resultContent = resultContent + i + ': %s\n' % data[i]

        resultContent = resultContent + '\n\nResults\n'

        for index, value in enumerate(string):
                resultContent = resultContent + '%s: '% resultNames[index] + str(value)  + '\n'

        f = open(apache_tmp_dir + '/' + resultFile, 'w')
        f.write(resultContent)
        f.close()

        linkToFile = request.url_root + 'lungCancerScreening/tmp/' + resultFile
        string.append(linkToFile)

        return json.dumps(string)

@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
    return response

import argparse
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", dest="port_number", default="9982", help="Sets the Port")
    # Default port is production value; prod,stage,dev = 9982, sandbox=9983
    args = parser.parse_args()
    port_num = int(args.port_number);

    hostname = gethostname()
    app.run(host='0.0.0.0', port=port_num, debug = True)
