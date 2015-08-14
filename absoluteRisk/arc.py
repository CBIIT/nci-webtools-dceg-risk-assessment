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
from flask import Flask, render_template, request, jsonify, make_response
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

with open ('rfiles/upload_RData_file.R') as fh:
    rcode = os.linesep.join(line.strip() for line in fh)
    upload_rdata_wrapper = SignatureTranslatedAnonymousPackage(rcode,"wrapper")

with open ('rfiles/upload_CSV_file.R') as fh:
    rcode = os.linesep.join(line.strip() for line in fh)
    upload_csv_wrapper = SignatureTranslatedAnonymousPackage(rcode,"wrapper")

with open ('rfiles/create_model_formula.R') as fh:
    rcode = os.linesep.join(line.strip() for line in fh)
    model_formula_wrapper = SignatureTranslatedAnonymousPackage(rcode,"wrapper")

with open ('rfiles/convert_JSON_to_RData.R') as fh:
    rcode = os.linesep.join(line.strip() for line in fh)
    json_rdata_wrapper = SignatureTranslatedAnonymousPackage(rcode,"wrapper")

@app.route('/')
def index():
    # Render template
    return render_template('index.html')

# This route will return a list in JSON format
@app.route('/absoluteRiskRest/', methods=['POST'])
def absoluteRiskRest():
        return


@app.route('/absoluteRiskRest/fileUpload', methods=['POST'])
def fileUpload():
    if request.method == 'POST':
        file = request.files['file']
        filepath = ''

        if file and allowed_file(file.filename):
            filename = time.strftime("%Y%m%d-%H%M%S") + '_' + secure_filename(file.filename)
            if (string.lower(filename.rsplit('.', 1)[1]) == 'csv'):
                file.save(os.path.join(app.config['csv_upload_folder'], filename))
                filepath = app.config['csv_upload_folder'] + '/' + filename
            else:
                file.save(os.path.join(app.config['rdata_upload_folder'], filename))
                filepath = app.config['rdata_upload_folder'] + '/' + filename

            json_data = upload_rdata_wrapper.uploadRData(filepath)[0]
            loadedJson = json.loads(json_data)
            loadedJson.insert(0, {'path_to_file': filepath})

            return json.dumps(loadedJson)
    return ''

@app.route('/absoluteRiskRest/dataUpload', methods=['POST'])
def dataUpload():
    if request.method == 'POST':
        data = json.dumps(request.data)
        filename = time.strftime("%Y%m%d-%H%M%S") + '_list_of_variables.rdata'
        filepath = app.config['rdata_upload_folder'] + '/' + filename

        json_rdata_wrapper.convertJSONtoRData(data, filepath)

        return filepath

    return ''

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
