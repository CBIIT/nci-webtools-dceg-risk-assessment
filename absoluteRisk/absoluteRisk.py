import os
import csv
import json
import time
from rpy2 import robjects
from flask import Flask, request, jsonify, make_response, send_from_directory
from werkzeug import secure_filename
from socket import gethostname

app = Flask(__name__)
arc = robjects.r

app.config['upload_folder']      = 'tmp/uploads'
app.config['results_folder']     = 'tmp/results'
app.config['examples_folder']    = 'tmp/examples'
app.config['allowed_extensions'] = ['.csv', '.rdata']
arc['source']('rfiles/absoluteRiskCalculationWrapper.R')

# This route takes in a RData file as input, saves it to the server, and returns the filename and contents
@app.route('/fileUpload', methods=['POST'])
def fileUpload():
    if request.method == 'POST':
        file = request.files['file']
        extension = os.path.splitext(file.filename)[1]

        try:
            if file and extension in app.config['allowed_extensions']:
                folder   = app.config['upload_folder']
                filename = secure_filename(timestamp() + file.filename)
                filepath = folder + '/' + filename
                file.save(filepath)

                return json.dumps({
                    'filename': filename,
                    'model': arc['uploadRData'](filepath)[0]
                })
        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This route takes in a json object as input, saves it to the server as an RData file, and returns the filepath to the client
@app.route('/fileDownload', methods=['POST'])
def fileDownload():
    if request.method == 'POST':
        model = json.loads(request.data)
        data = model['data']
        id = model['id']

        print id
        print data

        try:
            folder   = app.config['upload_folder']
            filename = secure_filename(timestamp() + id + '.rdata')
            filepath = folder + '/' + filename
            arc.convertJSONtoRData(json.dumps(data), filepath)

            if os.path.isfile(filepath):
                return json.dumps({'filepath': filepath})

        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This route takes in a json object as input and returns validation results
@app.route('/validate', methods=['POST'])
def validate():
    if request.method == 'POST':
        try:
            results = arc['verifyFile'](request.data)[0]
            return json.dumps({'error': results})

        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This route takes in a json object as input and returns calculation results
@app.route('/calculate', methods=['POST'])
def calculate():
    if request.method == 'POST':
        try:
            filepath = app.config['results_folder'] + '/' + timestamp()
            parameters = json.loads(request.stream.read())['parameters']

            for key in parameters:
                if not key in ['familyHistory', 'listOfVariables', 'modelFormula'] and parameters[key] is not None:
                    parameters[key] = generateCSV(key, parameters[key])

            return arc['finalCalculation'](filepath, json.dumps(parameters))[0]

        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This is a simple custom Error handling class/handler to return humanly readable error strings to the UI
class InvalidUsage(Exception):
    status_code = 400

    def __init__(self, message, status_code = None, payload = None):
        Exception.__init__(self)
        self.message = message
        if status_code is not None:
            self.status_code = status_code
        self.payload = payload

    def to_dict(self):
        rv = dict(self.payload or ())
        rv['message'] = self.message
        return rv

@app.errorhandler(InvalidUsage)
def handle_invalid_usage(error):
    response = jsonify(error.to_dict())
    response.status_code = error.status_code
    return response

def timestamp():
    return time.strftime('%Y%m%d_%H%M%S_')

def createDirectory(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

def generateCSV(key, data):
    filepath = app.config['upload_folder'] + '/' + timestamp() + key + '.csv'
    with open(filepath, 'w') as f:
        csv.writer(f, lineterminator = '\n').writerows(data)
    return filepath

import argparse
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", dest = "port_number", default = "9170", help = "Sets the Port")
    parser.add_argument("-d", dest = "debug_option", default = "True", help = "Enables or disables debugging")
    parser.add_argument("-e", dest = "evalex_option", default = "False", help = "Enables or disables the python console")
    # Default port is production value; prod, stage, dev=8170, sandbox=9170
    args = parser.parse_args()
    port_num = int(args.port_number);
    debug_option = args.debug_option == 'True'
    evalex_option = args.evalex_option == 'True'

    createDirectory(app.config['upload_folder'])
    createDirectory(app.config['results_folder'])

    hostname = gethostname()
    app.run(host='0.0.0.0', port = port_num, debug = debug_option, use_evalex = evalex_option)
