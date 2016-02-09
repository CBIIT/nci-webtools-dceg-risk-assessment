import os
import json
import time
from os import path
from flask import Flask, request, jsonify, make_response, send_from_directory
from rpy2.robjects.packages import SignatureTranslatedAnonymousPackage
from rpy2.robjects.vectors import IntVector, FloatVector, StrVector
from werkzeug import secure_filename
from socket import gethostname

app = Flask(__name__)

app.config['upload_folder']      = 'tmp/uploads'
app.config['results_folder']     = 'tmp/results'
app.config['examples_folder']    = 'tmp/examples'
app.config['allowed_extensions'] = ['.csv', '.rdata']

with open ('rfiles/absoluteRiskCalculationWrapper.R') as fh:
    rcode = os.linesep.join(line.strip() for line in fh)
    arc = SignatureTranslatedAnonymousPackage(rcode, 'wrapper')

# This route takes a JSON object as an input, saves it to the server as an RData file, and returns the file path as JSON
@app.route('/absoluteRiskRest/dataUpload', methods=['POST'])
def dataUpload():
    if request.method == 'POST':
        model   = json.loads(request.data)
        data    = model['data']
        id      = model['id']

        try:
            folder   = app.config['upload_folder']
            filename = secure_filename(timestamp() + id)
            filepath = folder + '/' + filename

            if (id == 'ageInterval'):
                filepath += '.csv'
                age      = data['age']
                interval = data['interval']
                contents = ','.join([age, interval])
                headers  = ','.join(data['columnNames'])

                with open(filepath, 'w') as csv:
                    csv.write(headers + '\n' + contents)
            else:
                filepath += '.rdata'
                arc.convertJSONtoRData(json.dumps(data), filepath)
            return json.dumps({ 'filePath': filepath })

        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This route takes in a CSV or RData file as input, saves it to the server, and returns the file path (and rdata contents) as JSON
@app.route('/absoluteRiskRest/fileUpload', methods=['POST'])
def fileUpload():
    if request.method == 'POST':
        file = request.files['file']
        extension = path.splitext(file.filename)[1]

        try:
            if file and extension in app.config['allowed_extensions']:
                folder   = app.config['upload_folder']
                filename = secure_filename(timestamp() + file.filename)
                filepath = folder + '/' + filename

                filedata = { 'filePath': filepath }
                file.save(path.join(folder, filename))

                if extension == '.rdata':
                    filedata['data'] = arc.uploadRData(filepath)[0]

                return json.dumps(filedata)
        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This route returns a specified file, if it exists on the server
@app.route('/absoluteRiskRest/fileDownload', methods=['GET'])
def fileDownload():
    if 'filename' in request.args:
        example  = 'example' in request.args
        folder   = app.config['examples_folder'] if example else app.config['upload_folder']
        filename = request.args['filename']
        filepath = path.join(folder, filename)

        if path.isfile(filepath):
            return send_from_directory(folder, filename, as_attachment = True)
        else:
            return 'This file no longer exists'
    else:
        return 'Correct parameter not provided in GET'

# This route takes in a session file as input, regenerates the input files, and returns the file paths (and rdata contents) as JSON
@app.route('/absoluteRiskRest/sessionUpload', methods=['POST'])
def sessionUpload():
    if request.method == 'POST':
        file = request.files['file']
        extension = path.splitext(file.filename)[1]

        try:
            if file and extension in app.config['allowed_extensions']:
                folder   = app.config['upload_folder']
                filename = secure_filename(timestamp() + file.filename)
                filepath = folder + '/' + filename

                file.save(path.join(folder, filename))
                return arc.loadSession(folder + '/' + timestamp(), filepath)[0]
        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This route takes in a json object as input and returns a session filepath
@app.route('/absoluteRiskRest/sessionDownload', methods=['POST'])
def sessionDownload():
    if request.method == 'POST':
        try:
            folder   = app.config['upload_folder']
            filename = timestamp() + 'session.rdata'
            filepath = folder + '/' + filename
            arc.saveSession(filepath, request.data)

            return json.dumps({'filePath': filepath})
        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This route takes in a json object as input and returns validation results
@app.route('/absoluteRiskRest/validate', methods=['POST'])
def validate():
    if request.method == 'POST':
        try:
            results = arc.verifyFile(request.data)[0]
            return json.dumps({'error': results})

        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This route takes in a json object as input and returns calculation results
@app.route('/absoluteRiskRest/calculate', methods=['POST'])
def calculate():
    if request.method == 'POST':
        try:
            filepath = app.config['results_folder'] + '/' + timestamp()
            return arc.finalCalculation(filepath, request.data)[0]

        except Exception, e:
            raise InvalidUsage(e.args[0], status_code = 500)
    return ''

# This is a simple custom Error handling class/handler to return humanly readable error strings to the UI
class InvalidUsage(Exception):
    status_code = 400

    def __init__(self, message, status_code=None, payload=None):
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

import argparse
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", dest="port_number", default="9170", help="Sets the Port")
    # Default port is production value; prod, stage, dev=8170, sandbox=9170
    args = parser.parse_args()
    port_num = int(args.port_number);

    hostname = gethostname()
    app.run(host='0.0.0.0', port=port_num, debug = True)
