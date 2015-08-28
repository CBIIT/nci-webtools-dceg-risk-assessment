# We need to import the jsonify object, it will let us
# output json, and it will take care of the right string
# data conversion, the headers for the response, etc
import os
import re
import time
import json
import StringIO
import string
import time
from flask import Flask, render_template, request, jsonify, make_response, send_from_directory
from rpy2.robjects.packages import SignatureTranslatedAnonymousPackage
from rpy2.robjects.vectors import IntVector, FloatVector
from socket import gethostname
from werkzeug import secure_filename

UPLOAD_CSV_FOLDER = 'uploads/csv'
UPLOAD_RDATA_FOLDER = 'uploads/rdata'

ALLOWED_EXTENSIONS = set(['csv', 'rdata'])

app = Flask(__name__)
app.config['csv_upload_folder'] = UPLOAD_CSV_FOLDER
app.config['rdata_upload_folder'] = UPLOAD_RDATA_FOLDER

with open ('rfiles/absoluteRiskCalculationWrapper.R') as fh:
    rcode = os.linesep.join(line.strip() for line in fh)
    arc_wrapper = SignatureTranslatedAnonymousPackage(rcode,"wrapper")

@app.route('/')
def index():
    # Render template
    return render_template('index.html')

# This route will return a list in JSON format
@app.route('/absoluteRiskRest/', methods=['POST'])
def absoluteRiskRest():
    return

# This route takes a CSV file as an input, saves it to the server, and returns the file path
@app.route('/absoluteRiskRest/csvFileUpload', methods=['POST'])
def csvFileUpload():
    if request.method == 'POST':
        file = request.files['file']
        filepath = ''
        fileAllowed = allowed_file(file.filename)

        if file and fileAllowed:
            filename = time.strftime("%Y%m%d-%H%M%S") + '_' + secure_filename(file.filename)
            file.save(os.path.join(app.config['csv_upload_folder'], filename))
            filepath = app.config['csv_upload_folder'] + '/' + filename

            return json.dumps({ 'path_to_file': filepath })
    return ''

# This route takes a CSV file as an input, stores it as RData file, and returns the converted file path
@app.route('/absoluteRiskRest/csvFileUploadConversion', methods=['POST'])
def csvFileUploadConversion():
    if request.method == 'POST':
        file = request.files['file']
        filepath = ''
        fileAllowed = allowed_file(file.filename)

        if file and fileAllowed:
            filename = time.strftime("%Y%m%d-%H%M%S") + '_' + secure_filename(file.filename)
            file.save(os.path.join(app.config['csv_upload_folder'], filename))
            filepath = app.config['csv_upload_folder'] + '/' + filename
            convertedFilePath = app.config['rdata_upload_folder'] + '/' + filename

            storedFilePath = arc_wrapper.uploadCSV(filepath, convertedFilePath)[0]

            return json.dumps({ 'path_to_file': storedFilePath })
    return ''

# This route takes a RData file as an input, stores it, and returns  a JSON object with data and file path
@app.route('/absoluteRiskRest/rdataFileUpload', methods=['POST'])
def rdataFileUpload():
    if request.method == 'POST':
        file = request.files['file']
        filepath = ''
        fileAllowed = allowed_file(file.filename)

        if file and fileAllowed:
            filename = time.strftime("%Y%m%d-%H%M%S") + '_' + secure_filename(file.filename)
            file.save(os.path.join(app.config['rdata_upload_folder'], filename))
            filepath = app.config['rdata_upload_folder'] + '/' + filename

            json_data = arc_wrapper.uploadRData(filepath)[0]
            loadedJson = json.loads(json_data)
            loadedJson.insert(0, {'path_to_file': filepath})

            return json.dumps(loadedJson)
    return ''

# This route takes in a JSON object, converts it to an RData file, and returns the file to the user
@app.route('/absoluteRiskRest/dataUpload', methods=['POST'])
def dataUpload():
    if request.method == 'POST':
        sectionModel = json.loads(request.data)
        sectionId = sectionModel['id']
        sectionData = sectionModel['data']

        filename = time.strftime("%Y%m%d-%H%M%S") + "_" + sectionId + ".rdata"
        filepath = app.config['rdata_upload_folder'] + '/' + filename

        arc_wrapper.convertJSONtoRData(json.dumps(sectionData), filepath)

        return filename

    return ''

# This route returns a specified file if it exists on the server
@app.route('/absoluteRiskRest/downloadFile', methods=['GET'])
def downloadFile():
    if 'filename' in request.args:
        filename = request.args['filename']
        filepath = os.path.join(app.config['rdata_upload_folder'], filename)

        if (os.path.isfile(filepath)):
            return send_from_directory(app.config['rdata_upload_folder'], filename, as_attachment=True)
        else:
            return 'This file no longer exists'
    else:
        return 'Correct parameter not provided in GET'

# This route returns the formula in JSON format
@app.route('/absoluteRiskRest/generateFormula', methods=['POST'])
def generateFormula():
    if request.method == 'POST':
        jsonData = json.loads(request.data)
        formulaModel = jsonData['model']['data']
        pathToFile = jsonData['pathToVariableListFile']

        formula = arc_wrapper.create_formula(json.dumps(formulaModel), pathToFile)
        return json.dumps(formula[0])

    return ''

@app.route('/absoluteRiskRest/logOddsRatios', methods=['POST'])
def logOddsRatios():
    if request.method == 'POST':
        jsonData = json.loads(request.data)
        pathToVariableListFile = jsonData['pathToVariableListFile']
        pathToGenFormulaFile = jsonData['pathToGenFormulaFile']
        formulaData = jsonData['formulaData']['data']

        print formulaData
        jsonList = arc_wrapper.log_odds_rates(pathToVariableListFile, pathToGenFormulaFile, formulaData)
        #print jsonList

    return ''

# This route takes a csv file as an input, and converts it to a 'disease rates' specific RData file.
# It then returns  a JSON object based on the file data
@app.route('/absoluteRiskRest/csvFileUploadDiseaseRates', methods=['POST'])
def csvFileUploadDiseaseRates():
    if request.method == 'POST':
        file = request.files['file']
        filepath = ''

        if file and allowed_file(file.filename):
            filename = time.strftime("%Y%m%d-%H%M%S") + '_' + secure_filename(file.filename)

            file.save(os.path.join(app.config['csv_upload_folder'], filename))
            filepath = app.config['csv_upload_folder'] + '/' + filename
            convertedFilePath = app.config['rdata_upload_folder'] + '/' + filename
            rdata_file_path = arc_wrapper.process_disease_rates(filepath, convertedFilePath)[0]

            print rdata_file_path
            return json.dumps({'path_to_file': rdata_file_path})

    return ''

# This route takes a file as an input, creates the requested CSV or RData file, and returns  a JSON object based on the file data
@app.route('/absoluteRiskRest/mortalityRates', methods=['POST'])
def mortalityRates():
    if request.method == 'POST':
        file = request.files['file']
        filepath = ''

        if file and allowed_file(file.filename):
            filename = time.strftime("%Y%m%d-%H%M%S") + '_' + secure_filename(file.filename)

            file.save(os.path.join(app.config['csv_upload_folder'], filename))
            filepath = app.config['csv_upload_folder'] + '/' + filename
            convertedFilePath = app.config['rdata_upload_folder'] + '/' + filename
            rdata_file_path = arc_wrapper.process_competing_rates(filepath, convertedFilePath)[0]

            print rdata_file_path
            return json.dumps({'path_to_file': rdata_file_path})

    return ''

# This method checks whether file of specified type is allowed to be uploaded
def allowed_file(filename):
    return '.' in filename and \
        string.lower(filename.rsplit('.', 1)[1]) in ALLOWED_EXTENSIONS

import argparse
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", dest="port_number", default="9982", help="Sets the Port")
    # Default port is production value; prod,stage,dev = 9982, sandbox=9983
    args = parser.parse_args()
    port_num = int(args.port_number);

    hostname = gethostname()
    app.run(host='0.0.0.0', port=port_num, debug = True)
