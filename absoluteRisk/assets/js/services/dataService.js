angular.module('Arc')
.factory('DataService', ['$rootScope', '$resource', 'uiUploader', 'ModalService',
function(root, resource, uploader, modal) {

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
            filename: '',
            filepath: '',
            model: null,
            validated: false
        };
    });

    self.sections.listOfVariables.model         = [{name: '', type: 'continuous'}];
    self.sections.modelFormula.model            = 'Y ~ +';
    self.sections.modelFormula.array            = [];

    self.sections.snpInformation.familyHistory  = null;
    self.sections.ageInterval.age               = null;
    self.sections.ageInterval.interval          = null;

    // Initialize default csv column names
    self.sections.riskFactorDistribution.columnNames    = [];
    self.sections.logOddsRatios.columnNames             = ['Variables', 'Log Odds Ratios'];
    self.sections.logOddsRatios.rowNames                = [];
    self.sections.diseaseIncidenceRates.columnNames     = ['Age (Integer)', 'Rate'];
    self.sections.mortalityIncidenceRates.columnNames   = ['Age (Integer)', 'Rate'];
    self.sections.snpInformation.columnNames            = ['snp.name', 'snp.odds.ratio', 'snp.freq'];

    self.sections.riskFactorForPrediction.columnNames   = [];
    self.sections.genotypesForPrediction.columnNames    = [];
    self.sections.ageInterval.columnNames               = ['Age', 'Age Interval'];

    /*  ------------ Exposed Functions ------------ */
    return {
        sections:           sections,
        calculate:          calculate,
        getSection:         getSection,
        uploadFile:         uploadFile,
        loadSession:        loadSession,
        submitModel:        submitModel,
        downloadCSV:        downloadCSV,
        downloadFile:       downloadFile,
        downloadSession:    downloadSession,
        downloadTemplate:   downloadTemplate,
        log:                function() {console.log(self.sections)},
    }

    /* ------ Retrieve all sections ------ */
    function sections() {
        return self.sections;
    }

    /* ------ Retrieve specified section ------ */
    function getSection(id) {
        return self.sections[id];
    }

    /* ------ Submit data model ------ */
    function submitModel(id, model, callback) {
        resource('/absoluteRiskRest/dataUpload')
            .save({ 'id': id, 'data': model }, onSuccess, onError);

        function onSuccess(result) {
            self.sections[id]['filepath'] = result.filepath;
            self.sections[id]['filename'] = result.filepath.split('/').pop();
            callback(id);
        }

        function onError(message) {
            modal.errorDialog('Error', 'Invalid file contents');
        }
    }

    /* ------ Call calculation ------ */
    function calculate() {

        console.log("Calling calculation: ", self.sections);
        root.$broadcast('calculationRunning', true);

        resource('/absoluteRiskRest/calculate')
            .save({'parameters': JSON.stringify(self.sections)}, onSuccess, onError);

        function onSuccess(response) {
            console.log(response);
            root.$broadcast('calculationRunning', false);
            root.$broadcast('displayResults', response);
        }

        function onError(response) {
            root.$broadcast('calculationRunning', false);
            modal.dialog('Calculation Error', response.data.message);
        }
    }

    /* ------ Submit file to retrieve contents ------ */
    function uploadFile(scope, id, file, callback) {
        uploader.addFiles([file]);
        uploader.startUpload({
            url: 'http://' + window.location.hostname + '/absoluteRiskRest/fileUpload',
            concurrency: 2,
            onCompleted: function(file, response) {
                response = JSON.parse(response);
                console.log(response);

                var section = self.sections[id];
                section.filepath = response.filepath;
                section.filename = response.filepath.split('/').pop();
                section.model = JSON.parse(response.model);
                callback(id);
                scope.$apply();
            }
        });
    }

    /* ------ Loads a session ------ */
    function loadSession(scope, file, callback) {
        if (window.FileReader) {
            var reader = new FileReader();

            reader.onload = function(event) {
                var session = JSON.parse(event.target.result);
                callback(session);
                scope.$apply();
            }

            if (file)
                reader.readAsText(file);
        }
    }

    /* ------ Download file ------ */
    function downloadFile(filename) {
        window.location = 'http://' + window.location.hostname + '/absoluteRiskRest/fileDownload?filename=' + filename.split('/').pop();
    }

    /* ------ Downloads the current session ------ */
    function downloadSession() {
        var session = {};
        [   'listOfVariables',
            'modelFormula',
            'riskFactorDistribution',
            'logOddsRatios',
            'diseaseIncidenceRates',
            'mortalityIncidenceRates',
            'snpInformation'
        ].forEach(function(id) {
            session[id] = self.sections[id];

            if (id == 'listOfVariables')
                for (var i = 0; i < session[id].model.length; i ++)
                    delete session[id].model[i]['$$hashKey'];

            else if (id == 'modelFormula')
                for (var j = 0; j < session[id].array.length; j ++)
                    delete session[id].array[j]['$$hashKey'];

        });

        var date = new Date();
        var timestamp = [date.getFullYear(), date.getMonth() + 1, date.getDay(), date.getHours(), date.getMinutes(), date.getSeconds()].join('_');
        download(timestamp + '_session.rdata', JSON.stringify(session), 'text/plain; charset=utf-8;');
    }

    function downloadTemplate(id) {
        var section = self.sections[id];
        var template = [section.columnNames];

        if (section.rowNames)
            sections.rowNames.forEach(function (rowName) {
                var length = section.columnNames.length - 1;
                var row = [rowName].concat(new Array(length));
                template.push(row);
            });

        download(id + 'Template.csv', template, 'text/csv; charset=utf-8;');
    }

    /* ------ Downloads a csv file ------ */
    function downloadCSV(id) {
        var content = self.sections[id].model.map(function(line) {
            return line.join(',');
        }).join('\n');

        download(self.sections[id].filename, content, 'text/csv; charset=utf-8;');
    }

    /* ------ Saves a file on the client ------ */
    function download(filename, data, type) {
        var blob = new Blob([data], {type: type});

        if (window.navigator.msSaveOrOpenBlob)
            window.navigator.msSaveBlob(blob, filename);
        else {
            var element = window.document.createElement('a');
            element.href = window.URL.createObjectURL(blob);
            element.download = filename;
            document.body.appendChild(element);
            element.click();
            document.body.removeChild(element);
        }
    }
}]);
