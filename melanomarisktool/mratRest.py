import math
import os
import sys

from flask import Flask, Response, request, jsonify
from MratConstants import MratConstants

app = Flask(__name__, static_folder="", static_url_path="")

class MelanomaRiskAssessmentTool:
    @staticmethod
    def buildFailure(message):
        if isinstance(message, str):
            response = jsonify(message=message, errorType="message", success=False)
        else:
            message['success'] = False
            response = jsonify(message)
        response.mimetype = 'application/json'
        response.status_code = 400
        return response

    @staticmethod
    def buildSuccess(message):
        if (isinstance(message, str)):
            response = jsonify(message=message, success=True)
        else:
            message['success'] = True
            response = jsonify(message)
        response.mimetype = 'application/json'
        response.status_code = 200
        return response

    @staticmethod
    def validateInput(parameters):
        try:
            for field in parameters:
                parameters[field] = parameters[field][0]
            requiredParameters = ['race', 'age']
            errorObject = {'missing':[], 'nonnumeric': []}

            region = None
            if parameters['region'] == '':
                errorObject['missing'] += ['region']
            elif isinstance(MratConstants.RegionIndex[parameters['region']], dict):
                if parameters['county'] == '':
                    errorObject['missing'] += ['county']
                else:
                    region = MratConstants.RegionIndex[parameters['region']][parameters['county']]
            else:
                region = MratConstants.RegionIndex[parameters['region']]

            if parameters['gender'] == 'Male':
                sex = 0
                requiredParameters += ['sunburn', 'complexion', 'big-moles', 'small-moles', 'freckling', 'damage']
            elif (parameters['gender'] == 'Female'):
                sex = 1
                requiredParameters += ['complexion', 'tan', 'small-moles', 'freckling']
            else:
                errorObject['missing'] += ['gender']
            for required in requiredParameters:
                if required not in parameters or parameters[required] == "":
                    errorObject['missing'].append(required)
                elif not parameters[required].isnumeric():
                    errorObject['nonnumeric'].append(required)
            if 'age' not in errorObject['missing'] and 'age' not in errorObject['nonnumeric']:
                age = int(parameters['age'] )
                if (age < 20 or age > 70):
                    errorObject['message'] = "This tool cannot be used to assess risk for those under the age of 20 or over the age of 70."

            if len(errorObject['missing'] ) > 0 :
                message = "Values are missing for " + ", ".join(errorObject['missing'] )
                if len(errorObject['nonnumeric'] ) > 0:
                    message += " \n and the following was found to be a non-numeric value"
                raise KeyError(message)

            return age, sex, region  
        except Exception as e:
            exc_type, exc_obj, exc_tb = sys.exc_info()
            fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
            print("EXCEPTION------------------------------", e, exc_type, fname, exc_tb.tb_lineno)
            return e 

    @staticmethod
    def getAbsoluteRisk(parameters, age, sex, region):
        try:
            sex = None
            if parameters['gender'] == 'Male':
                sex = 0
            elif (parameters['gender'] == 'Female'):
                sex = 1

            r = 1
            if sex == 0:
                r *= MratConstants.SUNBURN[int(parameters['sunburn'] )]
                r *= MratConstants.MALE_COMPLEXION[int(parameters['complexion'] )]
                r *= MratConstants.BIG_MOLES[int(parameters['big-moles'] )]
                r *= MratConstants.MALE_SMALL_MOLES[int(parameters['small-moles'] )]
                r *= MratConstants.MALE_FRECKLING[int(parameters['freckling'] )]
                r *= MratConstants.DAMAGE[int(parameters['damage'] )]
            else:
                r *= MratConstants.TAN[int(parameters['tan'] )]
                r *= MratConstants.FEMALE_COMPLEXION[int(parameters['complexion'] )]
                r *= MratConstants.FEMALE_SMALL_MOLES[int(parameters['small-moles'] )]
                r *= MratConstants.FEMALE_FRECKLING[int(parameters['freckling'] )]
            ageIndex = int((age-20)/5)
            t1 = ageIndex*5+20
            t2 = t1+5
            h11 = MratConstants.SEX[sex]*MratConstants.INCIDENCE[sex][ageIndex][region]
            h21 = MratConstants.MORTALITY[sex][ageIndex]
            risk = h11*r*(1-math.exp((age-t2)*(h11*r+h21)))/(h11*r+h21)
            if age != t1:
                h12 = MratConstants.SEX[sex]*MratConstants.INCIDENCE[sex][ageIndex+1][region]
                h22 = MratConstants.MORTALITY[sex][ageIndex+1]
                risk += h12*r*math.exp((age-t2)*(h11*r+h21))*(1-math.exp((t1-age)*(h12*r+h22)))/(h12*r+h22)
            risk = round(risk*10000)/100
            ratio = round((risk * 0.01) * 1000)
            regionKey = ""
            for key, value in MratConstants.RegionIndex.items():
                if value is region:
                    regionKey = key
                if value is not 1:
                    regionKey = regionKey + "ern"
            result = "The Five-Year Absolute Risk of Melanoma is {0}%. For every 1,000 {1}s living in the {2} region with these characteristics, on average about {3} will develop melanoma in the next 5 years.".format(
                risk, str(parameters['gender'] ).lower(), regionKey, int(ratio) )

            print "\n{0}".format(result)
            return result
        except Exception as e:
            exc_type, exc_obj, exc_tb = sys.exc_info()
            fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
            print("EXCEPTION------------------------------", e, exc_type, fname, exc_tb.tb_lineno)
            return e

    @app.route('/rest/calculate', methods=['POST'] )
    @app.route('/rest/calculate/', methods=['POST'] )
    def mratRisk():
        try:
            parameters = dict(request.form)
            age, sex, region = MelanomaRiskAssessmentTool.validateInput(parameters)
            message = MelanomaRiskAssessmentTool.getAbsoluteRisk(parameters, age, sex, region)

            return MelanomaRiskAssessmentTool.buildSuccess(message)
        except Exception as e:
            exc_type, exc_obj, exc_tb = sys.exc_info()
            fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
            print("EXCEPTION------------------------------", exc_type, fname, exc_tb.tb_lineno)
            return MelanomaRiskAssessmentTool.buildFailure(str(e))
        except KeyError as e:
            exc_type, exc_obj, exc_tb = sys.exc_info()
            fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
            print("EXCEPTION------------------------------", exc_type, fname, exc_tb.tb_lineno)
            return MelanomaRiskAssessmentTool.buildFailure(e)

    def __init__(self, port, debug):
        app.run(host='0.0.0.0', port=port, debug=debug)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", dest="port_number", default="8030", help="Sets the Port")
    parser.add_argument("--debug", action="store_true")

    args = parser.parse_args()
    port_num = int(args.port_number)
    MelanomaRiskAssessmentTool(port_num, args.debug)
