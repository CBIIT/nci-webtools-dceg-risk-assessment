import itertools
import requests
import json
from lxml import html


class MelanomaRiskAssessmentToolTest:
    # Old Values from the origin MRAT Program
    # A collection where the key is the answers to each individual question and the value part of the query string
    MRAT_OLD_RACE = {
        "Non-Hispanic white": "1",
        "Other": "2"
    }

    MRAT_OLD_REGION_WHERE_PATIENT_LIVES = {
        "North": "0",
        "Central": "1",
        "South": "2"
    }

    MRAT_OLD_GENDER = {
        "Male": "1",
        "Female": "2"
    }

    MRAT_OLD_COMPLEXION = {
        "Light": "1",
        "Medium": "2",
        "Dark": "3"
    }

    MRAT_OLD_MALE_SUNBURN = {
        "Yes": "1",
        "No": "2"
    }

    MRAT_OLD_FEMALE_SUNBURN = {
        "Very brown and deeply tanned": "1",
        "Moderately tanned": "2",
        "Lightly tanned": "3",
        "No tan at all": "4"
    }

    MRAT_OLD_MALE_MOLES = {
        "Less than two": "1",
        "Two or More": "2"
    }

    MRAT_OLD_MALE_MOLES_2 = {
        "Less than seven": "1",
        "Seven to sixteen": "2",
        "Seventeen or more": "3"
    }

    MRAT_OLD_FEMALE_MOLES = {
        "Less than five": "1",
        "Five to eleven": "2",
        "Twelve or more": "3"
    }

    MRAT_OLD_FRECKLING = {
        "Absent": "0",
        "Mild Freckling": "1",
        "Moderate Freckling": "2",
        "Severe Freckling": "3"
    }

    MRAT_OLD_SOLAR_DAMAGE = {
        "Yes": "1",
        "No": "2"
    }

    # Old Values from the New MRAT Program
    # A collection where the key is the answers to each individual question and the value part of the query string
    MRAT_NEW_RACE = {
        "Non-Hispanic white": "0",
        "Other": "1"
    }

    MRAT_NEW_GENDER = {
        "Male": "Male",
        "Female": "Female"
    }

    MRAT_NEW_REGION_WHERE_PATIENT_LIVES = {
        "North": "north",
        "Central": "central",
        "South": "south"
    }

    MRAT_NEW_COMPLEXION = {
        "Light": "0",
        "Medium": "1",
        "Dark": "2"
    }

    MRAT_NEW_MALE_SUNBURN = {
        "Yes": "0",
        "No": "1"
    }

    MRAT_NEW_FEMALE_SUNBURN = {
        "Very brown and deeply tanned": "0",
        "Moderately tanned": "1",
        "Lightly tanned": "2",
        "No tan at all": "3"
    }

    MRAT_NEW_MALE_MOLES = {
        "Less than two": "0",  # New Title : Fewer than two
        "Two or More": "1"
    }

    MRAT_NEW_MALE_MOLES_2 = {
        "Less than seven": "0",  # New Title : Fewer than seven
        "Seven to sixteen": "1",
        "Seventeen or more": "2"
    }

    MRAT_NEW_FEMALE_MOLES = {
        "Less than five": "0",  # New Title : Fewer than five
        "Five to eleven": "1",
        "Twelve or more": "2"
    }

    MRAT_NEW_FRECKLING = {
        "Absent": "0",
        "Mild Freckling": "1",
        "Moderate Freckling": "2",
        "Severe Freckling": "3"
    }

    MRAT_NEW_SOLAR_DAMAGE = {
        "Yes": "0",
        "No": "1"
    }

    # Relationships
    # The following list will contain the inputs that will used to build each test case.  The test case will contain
    # information that will be sent to the backend server to generate a number.  The test case is not dependent on
    # either server, the iputs are the same for both servers.
    #
    MRAT_INPUTS_BASE = [
        # RACE
        ["Non-Hispanic white"],

        # Age
        ["20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37",
         "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55",
         "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70"],

        # Region where person lives
        ["North", "Central", "South"],

        # Complexion
        ["Light", "Medium", "Dark"],

        # freckling
        ["Absent", "Mild Freckling", "Moderate Freckling", "Severe Freckling"]

    ]

    MRAT_MALE = [

        # Gender
        ["Male"],

        # Male Sunburn
        ["Yes", "No"],

        # Male Moles
        ["Less than two", "Two or More"],

        # MALE_MOLES_2
        ["Less than seven", "Seven to sixteen", "Seventeen or more"],

        # Solar Damage
        ["Yes", "No"]
    ]

    MRAT_FEMALE = [

        # Gender
        ["Female"],

        # Female Sunburn
        ["Very brown and deeply tanned", "Moderately tanned", "Lightly tanned", "No tan at all"],

        # Female Moles
        ["Less than five", "Five to eleven", "Twelve or more"],

    ]

    #
    # Provide the index of the data in the test case list.
    #
    InputLocationMale = {
        "race": 0,
        "age": 1,
        "region": 2,
        "complexion": 3,
        "freckling": 4,
        "gender": 5,
        "sunburn": 6,
        "big-moles": 7,
        "small-moles": 8,
        "damage": 9
    }

    InputLocationFemale = {
        "race": 0,
        "age": 1,
        "region": 2,
        "complexion": 3,
        "freckling": 4,
        "gender": 5,
        "tan": 6,
        "small-moles": 7
    }

    #
    # Determine if the string is only a number and does not contain any other letters
    #
    def isNumeric(self, numberString):
        try:
            float(numberString)
            return True
        except(ValueError, TypeError):
            return False

    #
    # Each Test Case will be built from each two sublist
    #
    #   MRAT Male list will contain the MRAT_INPUTS_BASE list and the MRAT_MALE
    #   MRAT Female list will contain the MRAT_INPUTS_BASE list an the MRAT_FEMALE
    #
    #   The list ( MRAT_INPUT_BASE, MRAT_MALE, MRAT_FEMALE ) contain values that will be combined using permutations.
    #
    def buildInputs(self):

        # Male
        maleInputs = list(self.MRAT_INPUTS_BASE)
        maleInputs.extend(self.MRAT_MALE)

        inputsMale = list(itertools.product(*maleInputs))

        # Female
        femaleInputs = list(self.MRAT_INPUTS_BASE)
        femaleInputs.extend(self.MRAT_FEMALE)

        inputsFemale = list(itertools.product(*femaleInputs))

        return (inputsMale, inputsFemale)

    #
    # Create a Data Dictionary that contains the values for the backend where index is the name used in the backend
    # and the value is the value
    #
    # Used by the New Mrat program to create the data for request sent to the server
    #
    def buildNewMaleData(self, testCase):

        def getValue(testCase, stringIndex):
            return testCase[self.InputLocationMale[stringIndex]]

        data = {
            "race": self.MRAT_NEW_RACE[getValue(testCase, "race")],
            "age": str(getValue(testCase, "age")),
            "region": self.MRAT_NEW_REGION_WHERE_PATIENT_LIVES[getValue(testCase, "region")],
            "gender": str(getValue(testCase, "gender")),
            "complexion": self.MRAT_NEW_COMPLEXION[getValue(testCase, "complexion")],
            "sunburn": self.MRAT_NEW_MALE_SUNBURN[getValue(testCase, "sunburn")],
            "big-moles": self.MRAT_NEW_MALE_MOLES[getValue(testCase, "big-moles")],
            "small-moles": self.MRAT_NEW_MALE_MOLES_2[getValue(testCase, "small-moles")],
            "freckling": self.MRAT_NEW_FRECKLING[getValue(testCase, "freckling")],
            "damage": self.MRAT_NEW_SOLAR_DAMAGE[getValue(testCase, "damage")]
        }

        return data

    #
    # Create a Data Dictionary that contains the values for the backend where index is the name used in the backend
    # and the value is the value
    #
    # Used by the Old Mrat program to create the data for request sent to the server
    #
    def buildOldMaleData(self, testCase):

        def getValue(testCase, stringIndex):
            return testCase[self.InputLocationMale[stringIndex]]

        data = {
            "region": self.MRAT_OLD_REGION_WHERE_PATIENT_LIVES[getValue(testCase, "region")],
            "sex": self.MRAT_OLD_GENDER[getValue(testCase, "gender")],
            "race": self.MRAT_OLD_RACE[getValue(testCase, "race")],
            "age": str(getValue(testCase, "age")),
            "sunburn": self.MRAT_OLD_MALE_SUNBURN[getValue(testCase, "sunburn")],
            "complexion": self.MRAT_OLD_COMPLEXION[getValue(testCase, "complexion")],
            "tanning": "2",
            "large_moles": self.MRAT_OLD_MALE_MOLES[getValue(testCase, "big-moles")],
            "small_moles_males": self.MRAT_OLD_MALE_MOLES_2[getValue(testCase, "small-moles")],
            "small_moles_females": "3",
            "freckling": self.MRAT_OLD_FRECKLING[getValue(testCase, "freckling")],
            "solar_damage": self.MRAT_OLD_SOLAR_DAMAGE[getValue(testCase, "damage")],
        }

        return data

    #
    # Create a Data Dictionary that contains the values for the backend where index is the name used in the backend
    # and the value is the value
    #
    # Used by the New Mrat program to create the data for request sent to the server
    #
    def buildNewFemaleData(self, testCase):

        def getValue(testCase, stringIndex):
            return testCase[self.InputLocationFemale[stringIndex]]

        data = {
            "race": self.MRAT_NEW_RACE[getValue(testCase, "race")],
            "age": str(getValue(testCase, "age")),
            "region": self.MRAT_NEW_REGION_WHERE_PATIENT_LIVES[getValue(testCase, "region")],
            "gender": str(getValue(testCase, "gender")),
            "complexion": self.MRAT_NEW_COMPLEXION[getValue(testCase, "complexion")],
            "tan": self.MRAT_NEW_FEMALE_SUNBURN[getValue(testCase, "tan")],
            "small-moles": self.MRAT_NEW_FEMALE_MOLES[getValue(testCase, "small-moles")],
            "freckling": self.MRAT_NEW_FRECKLING[getValue(testCase, "freckling")],
        }

        return data

    #
    # Create a Data Dictionary that contains the values for the backend where index is the name used in the backend
    # and the value is the value
    #
    # Used by the Old Mrat program to create the data for request sent to the server
    #
    def buildOldFemaleData(self, testCase):

        def getValue(testCase, stringIndex):
            return testCase[self.InputLocationFemale[stringIndex]]

        data = {
            "race": self.MRAT_OLD_RACE[getValue(testCase, "race")],
            "age": str(getValue(testCase, "age")),
            "region": self.MRAT_OLD_REGION_WHERE_PATIENT_LIVES[getValue(testCase, "region")],
            "sex": self.MRAT_OLD_GENDER[str(getValue(testCase, "gender"))],
            "complexion": self.MRAT_OLD_COMPLEXION[getValue(testCase, "complexion")],
            "tanning": self.MRAT_OLD_FEMALE_SUNBURN[getValue(testCase, "tan")],
            "small_moles_females": self.MRAT_OLD_FEMALE_MOLES[getValue(testCase, "small-moles")],
            "freckling": self.MRAT_OLD_FRECKLING[getValue(testCase, "freckling")],
            "sunburn": "-1000",
            "large_moles": "-1000",
            "small_moles_males": "-1000",
            "solar_damage": "-1000"

        }

        return data

    #
    # Send the request to the backend for the new mrat program which uses the post method
    # Gets the output from the returned JSON file
    #
    def resultsFromNewUrlPost(self, data):
        result = requests.post(url=self.newEndPoint, data=data)
        risk = json.loads(result.json()['message'])['risk']
        return risk

    #
    # Send the request to the backend for the old mrat program which uses the get method
    # Gets the output from converting result into an HTML file and using xpath to retrieve the value from the
    # element with id = "lblResult"
    #
    def resultsFromNewUrlGet(self, endPoint, data):
        result = requests.get(url=endPoint, params=data)
        tree = html.fromstring(result.content)
        risk = tree.xpath('//span["@id=lblResult"]/text()')[0].replace('%', '').strip()
        return risk

    #
    # Prints the fours on the same line to stdout
    #    differnce : If the old value is the same as new value tells the developer if it a problem, rounding error or no input returned
    #    old value --> reseult recieved from OLD MRAT Server
    #    new value --> result  received from New MRAT Server
    #    test case --> Values sent to eiter to get a value back.
    #
    def printSingleResult(self, old, new, testCase):

        # A routine to determine if there is no difference, a rounding error or a big difference in the values compared.
        def produceDifferenceStr(oldFloat, newFloat):
            result = oldFloat - newFloat
            if (result >= .1 and result > 0):
                difference = "RoundingError "
            elif (result == 0 ):
                difference = ""
            else:
                difference = "Difference "
            return difference

        # Start of function

        difference = ""
        if (old != new):

            if (self.isNumeric(old) == False):
                old = "(" + old + ")"
                difference = "Orig MRAT Invalid Input"
            else:
                difference = produceDifferenceStr(float(old), float(new))

        print(difference + "Old : " + old + " New: " + new + " " + testCase)


    #
    # Creates all Test Cases and send them to both servers and prints out the results
    #
    def riskInputCombinationTest(self, inputsMale, inputsFemale):

        def performTest(oldData, newData, gender):
            newRisk = self.resultsFromNewUrlPost(newData)
            oldRisk = self.resultsFromNewUrlGet(self.oldEndPoint[gender], oldData )
            self.printSingleResult(str(oldRisk), str(newRisk), str(testCase))

        for testCase in inputsMale:
            performTest(self.buildOldMaleData(testCase), self.buildNewMaleData(testCase), "male")

        for testCase in inputsFemale:
            performTest(self.buildOldFemaleData(testCase), self.buildNewFemaleData(testCase), "female")


    #
    # Select a sampling of the data from the start of the list to the end of the list
    #
    def generateRandomeDistribution(self, dataArray, buckets):
        newDataArray = []
        for index in range(0, len(dataArray) - 1, len(dataArray) / buckets):
            newDataArray.append(dataArray[index])
        return newDataArray

    #
    # Constructor
    #
    def __init__(self, newEndPoint, oldEndPoint):
        self.newEndPoint = newEndPoint
        self.oldEndPoint = oldEndPoints


if __name__ == '__main__':
    newEndPoint = "http://127.0.0.1:8130/calculate"
    oldEndPoints = {"female": "https://www.cancer.gov/melanomarisktool/results_f.aspx",
                    "male": "https://www.cancer.gov/melanomarisktool/results_m.aspx"}

    test = MelanomaRiskAssessmentToolTest(newEndPoint, oldEndPoints)

    (inputsMale, inputsFemale) = test.buildInputs()

    inputsMale = test.generateRandomeDistribution(inputsMale, 249)
    inputsFemale = test.generateRandomeDistribution(inputsFemale, 249)

    # Used for developement when you don't want send to much data to the server.
    # inputsMale = inputsMale[0:2]
    # inputsFemale = inputsFemale[0:2]

    inputs = test.riskInputCombinationTest(inputsMale, inputsFemale)
