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

@app.route('/')
def index():
    # Render template
    return render_template('index.html')

# This route will return a list in JSON format
@app.route('/absoluteRiskRest/', methods=['POST'])
def absoluteRiskRest():
        return

@app.route('/absoluteRiskRest/fileUpload', methods=['GET', 'POST'])
def fileUpload():
    if request.method == 'POST':
        file = request.files['file']
        file_path = ''

        if file and allowed_file(file.filename):
            filename = time.strftime("%Y%m%d-%H%M%S") + '_' + secure_filename(file.filename)
            if (string.lower(filename.rsplit('.', 1)[1]) == 'csv'):
                file.save(os.path.join(app.config['csv_upload_folder'], filename))
                file_path = app.config['csv_upload_folder'] + '/' + filename
            else:
                file.save(os.path.join(app.config['rdata_upload_folder'], filename))
                file_path = app.config['rdata_upload_folder'] + '/' + filename

            return file_path
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
