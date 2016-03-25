angular.module('Arc')
.factory('SectionService', ['DataService', 'ModalService', 'UtilityService', 'ValidationService',
function(data, modal, utility, validation) {

    var self = this;

    return {
        submit:             submit,
        getFileName:        getFileName,
        downloadFile:       downloadFile,
        downloadTemplate:   downloadTemplate,
    }

    function getFileName(id) {
        return data.getSection(id).filename;
    }

    function downloadTemplate(id) {
        data.downloadTemplate(id);
    }

    function downloadFile(id) {
        if (id == 'modelFormula' || id == 'listOfVariables')
            data.downloadModel(id);
        else
            data.downloadCSV(id);
    }

    function submit(id) {
        console.log('Submitting section', id);
        switch(id) {
            case 'listOfVariables':

                var variables = data.getSection('listOfVariables').model.map(function(v) {return v.name})
                validation.setExpectedColumns('riskFactorDistribution');
                validation.setExpectedColumns('riskFactorForPrediction');

                data.getSection('modelFormula').array = utility.generateFormulaTemplate(true);
                data.getSection('modelFormula').model = utility.generateFormula();
                data.getSection('snpInformation').variables = variables;
                break;

            case 'modelFormula':
                validation.setExpectedRows('logOddsRatios');
                break;

            case 'snpInformation':
                validation.setExpectedColumns('genotypesForPrediction');
                break;

            case 'riskFactorDistribution':
            case 'logOddsRatios':
            case 'diseaseIncidenceRates':
            case 'mortalityIncidenceRates':
            case 'riskFactorForPrediction':
            case 'genotypesForPrediction':
            case 'ageInterval':
                break;
        }

        validation.submit(id);
    }
}]);
