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
            model: null,
            validated: false
        };
    });

    self.sections.listOfVariables.array         = [{name: '', type: 'continuous'}];
    self.sections.listOfVariables.model         = [];

    self.sections.modelFormula.array            = [];
    self.sections.modelFormula.model            = '';

    self.sections.snpInformation.familyHistory  = 'Family history is not in the model';
    self.sections.ageInterval.age               = 30;
    self.sections.ageInterval.interval          = 5;

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
        getSection:         getSection,
        downloadModel:      downloadModel,
        downloadSession:    downloadSession,
        downloadTemplate:   downloadTemplate,
        downloadCSV:        downloadCSV,
        uploadModel:        uploadModel,
        calculate:          calculate
    }

    function sections() {
        return self.sections;
    }

    function getSection(id) {
        return self.sections[id];
    }

    function calculate(successCb, errorCb) {
        var model = {}
        for (key in self.sections)
            if (self.sections[key].validated)
                model[key] = self.sections[key].model;

        if (self.sections.snpInformation.validated &&
            self.sections.snpInformation.familyHistory.length &&
            self.sections.snpInformation.familyHistory != 'Family history is not in the model')
            model.familyHistory = self.sections.snpInformation.familyHistory;

        resource('/absoluteRiskRest/calculate')
            .save({parameters: model}, successCb, errorCb);
    }

    /* ------ Downloads a model from the server ------ */
    function downloadModel(id) {
        resource('/absoluteRiskRest/fileDownload')
            .save({id: id, data: self.sections[id].model}, onSuccess, onError);

        function onSuccess(response) {
            window.location.href += response.filepath;
//          window.location.href =  'http://' + window.location.hostname + window.location.pathname + response.filepath;
        }

        function onError(response) {
            modal.dialog('Error', 'Server did not return a valid response.')
        }
    }

    /* ------ Uploads a model to the server ------ */
    function uploadModel(id, file, callback) {
        uploader.addFiles([file]);
        uploader.startUpload({
            url: 'http://' + window.location.hostname + '/absoluteRiskRest/fileUpload',
            concurrency: 2,
            onCompleted: function(file, response) {
                response = JSON.parse(response);
                console.log(response);

                var section = self.sections[id];
                section.filename = response.filename;
                section.model = JSON.parse(response.model);
                callback(id);
                root.$apply();
            }
        });
    }

    /* ------ Downloads the current session ------ */
    function downloadSession() {
        console.log('Downloading session');

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
        var timestamp = [date.getFullYear(), date.getMonth() + 1, date.getDay(), '_', date.getHours(), date.getMinutes(), date.getSeconds()].join('');
        download(timestamp + '_session.rdata', JSON.stringify(session), 'text/plain; charset=utf-8;');
    }

    /* ------ Downloads the CSV template for a section ------ */
    function downloadTemplate(id) {
        var section = self.sections[id];
        var template = [section.columnNames];

        if (section.rowNames)
            section.rowNames.forEach(function (rowName) {
                var length = section.columnNames.length - 1;
                var row = [rowName].concat(new Array(length));
                template.push(row);
            });

        template = template.map(function(line) {
            return line.join(',');
        }).join('\n');

        download(id + 'Template.csv', template, 'text/csv; charset=utf-8;');
    }

    /* ------ Downloads the section's model as a CSV file ------ */
    function downloadCSV(id) {
        var section = self.sections[id];
        var model = section.model.map(function(line) {
            return line.join(',');
        }).join('\n');

        download(section.filename, model, 'text/csv; charset=utf-8;');
    }

    /* ------ Saves a file on the client ------ */
    function download(filename, data, type) {
        data = data

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
