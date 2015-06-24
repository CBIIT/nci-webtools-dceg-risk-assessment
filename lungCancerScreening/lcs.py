# We need to import the jsonify object, it will let us
# output json, and it will take care of the right string
# data conversion, the headers for the response, etc
import os
import re
import time
import json
from flask import Flask, render_template, request, jsonify
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

    fromR = (wrapper.getDataJSON(request.query_string)))
    #fromRlist = list(fromR)
    #fromRstr = ''.join(fromRlist)
    return json.dumps(fromRstr)

import argparse
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", dest="port_number", default="9982", help="Sets the Port")
    # Default port is production value; prod,stage,dev = 9982, sandbox=9983
    args = parser.parse_args()
    port_num = int(args.port_number);

    hostname = gethostname()
    app.run(host='0.0.0.0', port=port_num, debug = True)
