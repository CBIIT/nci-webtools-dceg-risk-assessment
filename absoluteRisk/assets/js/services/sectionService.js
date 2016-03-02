angular.module('Arc')
.factory('SectionService', ['DataService', 'ModalService', 'UtilityService', 'ValidationService',
function(data, modal, utility, validation) {

    var self = this;

    return {
        getTemplate:    getTemplate,
        getFileName:    getFileName,
        downloadFile:   downloadFile,
        submitSection:  submitSection
    }

    function getFileName(id) {
        return data.getSection(id).filename;
    }

    function getTemplate(id) {
        data.downloadTemplate(id);
    }

    function downloadFile(id) {
        if (id == 'modelFormula' || id == 'listOfVariables') {
            data.submitModel(id, data.getSection(id).model, function(id) {
                data.downloadFile(data.getSection(id).filename);
            });
        }
        else
            data.downloadCSV(id);
    }

    function submitSection(id) {
        if (id == 'modelFormula' || id == 'listOfVariables') {
            var model = data.getSection(id).model;
            data.submitModel(id, model, submit);
        }

        else
            submit(id);
    }

    function submit(id) {

        console.log('Submitting section', id);
        switch(id) {
            case 'listOfVariables':
                var variables = data.getSection('listOfVariables').model.map(function(variable) {
                    return variable.name;
                });

                validation.setExpectedColumns('riskFactorDistribution');
                validation.setExpectedColumns('riskFactorForPrediction');

                data.getSection('modelFormula').array = utility.generateFormulaTemplate();
                data.getSection('modelFormula').model = utility.generateFormula();
                data.getSection('snpInformation').variables = variables;
                break;

            case 'modelFormula':
                validation.setExpectedRows('logOddsRatios');
                break;

            case 'riskFactorDistribution':
            case 'logOddsRatios':
            case 'diseaseIncidenceRates':
            case 'mortalityIncidenceRates':
                break;

            case 'snpInformation':
                validation.setExpectedColumns('genotypesForPrediction');
                break;

            case 'riskFactorForPrediction':
                break;

            case 'genotypesForPrediction':
                break;

            case 'ageInterval':
                break;
        }

        validation.submit(id);
    }
}]);
