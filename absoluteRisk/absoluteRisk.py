# We need to import the jsonify object, it will let us
# output json, and it will take care of the right string
# data conversion, the headers for the response, etc
import os
import re
import time
import json
import StringIO
import string
import csv
from flask import Flask, render_template, request, jsonify, make_response, send_from_directory
from rpy2.robjects.packages import SignatureTranslatedAnonymousPackage
from rpy2.robjects.vectors import IntVector, FloatVector
from socket import gethostname
from werkzeug import secure_filename
import tempfile

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

# Root endpoint
@app.route('/absoluteRiskRest/', methods=['POST'])
def absoluteRiskRest():
    return

# This route takes a CSV file as an input, saves it to the server, and returns the CSV file path as JSON
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

# This route takes a CSV file as an input, stores it as RData file, and returns the RData file path as JSON
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

# This route takes a RData file as an input, stores it, and returns a JSON object with data and file path
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

# This route takes in a JSON object, converts it to an RData file, and returns the filename to the user as JSON
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

# This route takes in a JSON object, converts it to a CSV file, and returns the file to the user
@app.route('/absoluteRiskRest/exportToCsv', methods=['POST'])
def exportToCsv():
    if request.method == 'POST':
        csvModel = json.loads(request.data)
        csvFileId = csvModel['id']
        csvContent = csvModel['content']

        filename = time.strftime("%Y%m%d-%H%M%S") + "_" + csvFileId + ".csv"
        filepath = app.config['csv_upload_folder'] + '/' + filename

        with open(filepath,"wb") as fo:
                fo.write(csvContent)

        return filepath

    return ''

# This route returns a specified file, if it exists on the server
@app.route('/absoluteRiskRest/downloadFile', methods=['GET'])
def downloadFile():
    if 'filename' in request.args:
        filename = request.args['filename']
        fileFolder = app.config['rdata_upload_folder']

        if string.lower(filename.rsplit('.', 1)[1]) == 'csv':
            fileFolder = app.config['csv_upload_folder']

        filepath = os.path.join(fileFolder, filename)

        if (os.path.isfile(filepath)):
            return send_from_directory(fileFolder, filename, as_attachment=True)
        else:
            return 'This file no longer exists'
    else:
        return 'Correct parameter not provided in GET'

# This route returns the generated formula string as JSON
@app.route('/absoluteRiskRest/generateFormula', methods=['POST'])
def generateFormula():
    if request.method == 'POST':
        jsonData = json.loads(request.data)
        formulaModel = jsonData['model']['data']
        pathToFile = jsonData['pathToVariableListFile']

        formula = arc_wrapper.create_formula(json.dumps(formulaModel), pathToFile)
        return json.dumps(formula[0])

    return ''

# This route takes in 3 params for R calculations, and returns log_odds_rates based calculations as JSON
@app.route('/absoluteRiskRest/logOddsRatios', methods=['POST'])
def logOddsRatios():
    if request.method == 'POST':
        jsonData = json.loads(request.data)
        pathToVariableListFile = jsonData['pathToVariableListFile']
        pathToGenFormulaFile = jsonData['pathToGenFormulaFile']
        formulaData = jsonData['formulaData']['data']

        formula = arc_wrapper.create_formula(json.dumps(formulaData), pathToVariableListFile)
        jsonList = arc_wrapper.log_odds_rates(pathToVariableListFile, json.dumps(formula[0]))

        return jsonList[0]
    return ''

# This route takes a csv file as an input, and converts it to a 'disease rates' specific RData file.
# It then returns the RData file path as JSON
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

# This route takes 2 params for R calculations, and returns the RData file path as JSON
@app.route('/absoluteRiskRest/mortalityRates', methods=['POST'])
def mortalityRates():
    if request.method == 'POST':
        jsonData = json.loads(request.data)
        pathToMortalityRatesCSVFile = jsonData['csvFilePath']
        pathToDiseaseRatesRDataFile = jsonData['rdataFilePath']
        filename = os.path.basename(pathToMortalityRatesCSVFile)

        convertedFilePath = app.config['rdata_upload_folder'] + '/' + filename
        rdata_file_path = arc_wrapper.process_competing_rates(pathToMortalityRatesCSVFile, pathToDiseaseRatesRDataFile, convertedFilePath)[0]

        print rdata_file_path
        return json.dumps({'path_to_file': rdata_file_path})

    return ''

# This route takes 2 params for R calculations, and returns the RData file path as JSON
@app.route('/absoluteRiskRest/snpInformation', methods=['POST'])
def snpInformation():
    if request.method == 'POST':
        jsonData = json.loads(request.data)
        pathToSnpCSVFile = jsonData['csvFilePath']
        famHistVarName = jsonData['famHist']
        filename = os.path.basename(pathToSnpCSVFile)

        convertedFilePath = app.config['rdata_upload_folder'] + '/' + filename
        rdata_file_path = arc_wrapper.process_SNP_info(pathToSnpCSVFile, famHistVarName, convertedFilePath)[0]
        snpColNames = []

        with open(pathToSnpCSVFile) as f:
            reader = csv.reader(f, dialect=csv.excel_tab, delimiter="\t")
            for i in reader:
                colName = i[0].split(',')[0]
                snpColNames.append(colName)

        return json.dumps({'path_to_file': rdata_file_path, 'rows': snpColNames })

    return ''

# This route takes 2 params for R calculations, and returns the RData file path as JSON
@app.route('/absoluteRiskRest/calculate', methods=['POST'])
def calculate():
    if request.method == 'POST':
        jsonData = json.loads(request.data)

        ref_dataset_RData = jsonData['risk_factor_distribution']['path_to_file']
        log_odds_RData = jsonData['log_odds_ratios']['path_to_file']
        list_of_variables_RData = jsonData['variable_list']['path_to_file']
        snp_info_RData = jsonData['snp_information']['path_to_file']
        fam_hist_RData = jsonData['snp_information']['path_to_famHist_file']
        age_RData = jsonData['age_interval']['path_to_file']
        cov_new_RData = jsonData['risk_factor_prediction']['path_to_file']
        genotype_new_RData = jsonData['genotypes_prediction']['path_to_file']
        disease_rates_RData = jsonData['disease_incidence_rates']['path_to_file']
        competing_rates_RData = jsonData['mortality_incidence_rates']['path_to_file']

        #model_predictor_formula = jsonData['generate_formula']['formulaData']
        model_predictor_RData = jsonData['generate_formula']['path_to_file']
        #model_predictor_RData = arc_wrapper.create_formula(json.dumps(formulaData), list_of_variables_RData)

        results = arc_wrapper.process_age_code_helper(ref_dataset_RData, model_predictor_RData, log_odds_RData, list_of_variables_RData, snp_info_RData, fam_hist_RData, age_RData, cov_new_RData, genotype_new_RData, disease_rates_RData, competing_rates_RData)

        print results

        return results[0]

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
