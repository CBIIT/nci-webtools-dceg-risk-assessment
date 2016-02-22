import math
import os
import sys

from flask import Flask, Response, request, jsonify, send_from_directory
from CcratRunFunction import AbsRisk

app = Flask(__name__, static_folder="", static_url_path="")

class ColorectalRiskAssessmentTool:
  @staticmethod
  def buildFailure(message):
    if (isinstance(message,str)):
      response = jsonify(message=message, errorType="message", success=False)
    else:
      message['success'] = False
      response = jsonify(message)
    response.mimetype = 'application/json'
    response.status_code = 400
    return response

  @staticmethod
  def buildSuccess(message):
    if (isinstance(message,str)):
      response = jsonify(message=message, success=True)
    else:
      message['success'] = True
      response = jsonify(message)
    response.mimetype = 'application/json'
    response.status_code = 200
    return response

  @app.route('/calculate', methods=['POST'])
  @app.route('/calculate/', methods=['POST'])
  def mratRisk():
    try:
      parameters = dict(request.form)
      for field in parameters:
        parameters[field] = parameters[field][0]
      print parameters
      requiredParameters = []
      errorObject = {'missing':[],'nonnumeric':[]}
      risk = 100
      return ColorectalRiskAssessmentTool.buildSuccess(str(risk))
    except Exception as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
      print("EXCEPTION------------------------------", exc_type, fname, exc_tb.tb_lineno)
      return ColorectalRiskAssessmentTool.buildFailure(str(e))

  def __init__(self):
    app.run(host='0.0.0.0', port=8200, debug=True)

if __name__ == '__main__':
  ColorectalRiskAssessmentTool()
