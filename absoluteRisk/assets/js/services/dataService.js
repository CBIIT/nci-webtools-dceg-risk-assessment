angular.module('Arc')
.factory('DataService', ['$rootScope', '$resource', 'uiUploader', 'ModalService', 'ValidationService', 'UtilityService',
function(root, resource, uploader, modal, validation, utility) {

    var self = this;
    self.sections = {};

    /* ------ Initialize Data Model ------ */

    [   'listOfVariables',
        'modelFormula',
        'riskFactorDistribution',
        'logOddsRatios',
        'diseaseIncidenceRates',
        'mortalityIncidenceRates',
        'snpInformation',
        'riskFactorForPrediction',
        'genotypesForPrediction',
        'ageInterval'
    ].forEach(function(id) {
        self.sections[id] = {
            uploadedFileName: '',
            filePath: '',
            validated: false
        };
    });

    self.sections.listOfVariables.model = [{name: '', type: 'continuous'}];
    self.sections.modelFormula.model = 'Y ~ +';
    self.sections.modelFormula.array = [];

    self.sections.snpInformation.familyHistory  = null;
    self.sections.ageInterval.age               = null;
    self.sections.ageInterval.interval          = null;

    // initialize csv column names
    self.sections.riskFactorDistribution.columnNames    = [];

    self.sections.logOddsRatios.columnNames             = ['Variables', 'Log Odds Ratios'];
    self.sections.logOddsRatios.rowNames                = [];

    self.sections.diseaseIncidenceRates.columnNames     = ['Age (Integer)', 'Rate'];
    self.sections.mortalityIncidenceRates.columnNames   = ['Age (Integer)', 'Rate'];

    self.sections.snpInformation.columnNames            = ['snp.name', 'snp.odds.ratio', 'snp.freq'];
    self.sections.snpInformation.uploadedRowNames       = [];

    self.sections.riskFactorForPrediction.columnNames   = [];
    self.sections.genotypesForPrediction.columnNames    = [];
    self.sections.ageInterval.columnNames               = ['Age', 'Age Interval'];

    return {
        calculate:        calculate,
        sections:         sections,
        getSection:       getSection,
        uploadFile:       uploadFile,
        submitModel:      submitModel,
        downloadFile:     downloadFile,
        submitSection:    submitSection,
        downloadSession:  downloadSession
    }

    /*  ------------ Internal Functions ------------ */

    /* ------ Retrieve Sections ------ */
    function sections() {
        return self.sections;
    }

    /* ------ Retrieve a Section */
    function getSection(id) {
        return self.sections[id];
    }

    /* ------ Upload File ------ */
    function uploadFile(scope, id, file) {

        self.file = file;

        var endpoint = 'http://' + window.location.hostname + '/absoluteRiskRest';

        if (id == 'sessionUpload')
            endpoint += '/sessionUpload';
        else
            endpoint += '/fileUpload';

        uploader.addFiles([self.file]);
        uploader.startUpload({
            url: endpoint,
            concurrency: 2,
            onProgress: function(file) {},
            onCompleted: function(file, response) {
                var resp = JSON.parse(response);
                console.log("Full response is: ", resp);

                if (resp.message) {
                    console.log('500', resp.message);
                } else if (resp.filePath) {
                    var section = self.sections[id];

                    section.filePath = resp.filePath;
                    section.uploadedFileName = resp.filePath.split('/').pop();

                    if (id == 'listOfVariables' || id == 'modelFormula') {
                        if (resp.data)
                            postUploadActions(id, JSON.parse(resp.data));
                        else
                            modal.errorDialog('Error', 'Invalid file format. Please ensure that an RData file has been uploaded.');
                    }

                    scope.$apply();
                } else if (resp.filePaths && resp.model) {
                    console.log('uploaded session');

                    var filePaths = resp.filePaths;
                    var model = resp.model;

                    for (file in filePaths) {
                        self.sections[file].filePath = filePaths[file];
                        self.sections[file].uploadedFileName = filePaths[file].split('/').pop();
                        self.sections[file].validated = true;
                    };

                    self.sections.ageInterval.validated = true;

                    self.sections.listOfVariables.model = model.listOfVariables;
                    self.sections.modelFormula.model = model.formulaString;
                    self.sections.modelFormula.array = utility.parseFormula(self.sections);
                    self.sections.snpInformation.uploadedRowNames = model.snpRowNames;
                    self.sections.snpInformation.familyHistory = model.familyHistory;
                    self.sections.genotypesForPrediction.columnNames = model.snpRowNames;

                    var variableNames = self.sections.listOfVariables.model.map(function(variable) {
                        return variable.name;
                    });
        			self.sections.riskFactorDistribution.columnNames = variableNames;
        			self.sections.riskFactorForPrediction.columnNames = variableNames;
                    self.sections.logOddsRatios.rowNames = utility.generateLogOddsRatios(self.sections);

                    root.$broadcast('validateBuildSection', true);

                } else {
                    console.log('503', 'Service Not Available');
                }
            },
            onCompletedAll: function(file) {}
        });
    }

    /* ------ Convert Data Model to File  ------ */
    function submitModel(id, data) {
        resource('/absoluteRiskRest/dataUpload')
            .save({ 'id': id, 'data': data }, onSuccess, onError);

        function onSuccess(result) {
            self.sections[id]['filePath'] = result.filePath;
        }

        function onError(message) {
            modal.errorDialog('Error', 'Service Unavailable');
        }
    }

    /* ------ Download File ------ */
    function downloadFile(filename) {
        window.location = 'http://' + window.location.hostname + '/absoluteRiskRest/fileDownload?filename=' + filename.split('/').pop();
    }

    /* ------ Post Upload Actions ------ */
    function postUploadActions(id, data) {

        switch(id) {
            case 'listOfVariables':
                if (data && data instanceof Array && data.length) {
                    self.sections.listOfVariables.model = data;
                    self.sections.listOfVariables.validated = true;
                } else {
                    modal.errorDialog('Validation Error', 'Invalid file contents. Please verify the list of variables.');
                } break;
            case 'modelFormula':
                if (data && typeof data == 'string') {
                    self.sections.modelFormula.model = data;
                    self.sections.modelFormula.array = null;
                    self.sections.modelFormula.validated = true;
                } else {
                    modal.errorDialog('Validation Error', 'Invalid file contents. Please verify the model formula.');
                } break;
            case 'riskFactorDistribution':
                break;
        }
    }

    /* ------ Calculate ------ */
    function calculate() {
        var parameters = retrieveFilePaths();
        parameters.familyHistory = self.sections.snpInformation.familyHistory;
        console.log(parameters);

        root.$broadcast('calculationRunning', true);

        resource('/absoluteRiskRest/calculate')
            .save(JSON.stringify(parameters), onSuccess, onError);

        function onSuccess(response) {
            root.$broadcast('calculationRunning', false);
            root.$broadcast('displayResults', response);
        }

        function onError(response) {
            root.$broadcast('calculationRunning', false);
            modal.errorDialog('Calculation Error', response.data.message);
        }
    }

    function retrieveFilePaths() {
        var filepaths = {};
        for (key in self.sections)
            filepaths[key] = self.sections[key]['filePath'];

        return filepaths;
    }

    /* ------ Advance Section ------ */
    function submitSection(id) {
        if (!self.sections[id].validated)
            validation.submit(id, self.sections);
        else
            root.$broadcast('nextSection', id);
    }

    function downloadSession() {

        var session = retrieveFilePaths();
        session.familyHistory = self.sections.snpInformation.familyHistory;
        console.log(session);

        resource('/absoluteRiskRest/sessionDownload')
            .save(session, onSuccess, onError);

        function onSuccess(result) {
            console.log('Session file: ' + result.filePath);
            downloadFile(result.filePath);
        }

        function onError(message) {
            modal.errorDialog('Error', 'Service Unavailable');
        }
    }

}]);
