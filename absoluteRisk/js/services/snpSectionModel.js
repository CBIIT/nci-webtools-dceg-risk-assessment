/* Creates a SNP Information section model */
app.factory('BuildSnpModel', ['CacheService', '$http', '$rootScope', function(Cache, $http, $rootScope) {
    function snpModel(parent) {
        var self = this;

        self.genTemplate = true;
        self.section = parent;
        self.placeHolderRows = [0, 1, 2, 3, 4];
        self.columns = [];
        self.templateCols = [];
        self.templateRows = [];
    }
    snpModel.prototype = {
        init: function(cfg) {
            var self = this;

            self.columns = cfg.cols;
            self.templateCols = self.columns;

            self.sectionDependency = cfg.sectionDependency;
            self.sectionDependencyData = angular.copy(Cache.getUiData(self.sectionDependency.id));

            self.hasFamHist = true;
            self.sectionDependencyData.rows.unshift('Family history is not in the model');
            self.famHist = self.sectionDependencyData.rows[0];

            self.fileUploadEndpoint = cfg.fileUploadEndpoint;
            self.saveEndpoint = cfg.saveEndpoint;
        },
        exportToCsv: function(e) {
            var self = this;
            var filename = self.section.id;
            var csvExportUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/exportToCsv';
        	var csvData = {
                id: self.section.id,
                content: ''
            };

            e.preventDefault();
            e.stopPropagation();

            csvData.content = self.templateCols.join(',') + '\n';

            if (self.templateRows.length) {
                angular.forEach(self.templateRows, function(row) {
                    csvData.content += row + '\n';
                });
            }

            $http.post(csvExportUrl, JSON.stringify(csvData))
               .success(function(data, status, headers, config) {
                   var fileName = data.replace(/^.*[\\\/]/, '');
                   window.location = 'http://' + window.location.hostname + '/absoluteRiskRest/downloadFile?filename=' + fileName;
               })
               .error(function(data, status, headers, config) {
                   console.log('status is: ', status);
               })
               .finally(function(data) {
                   console.log('finally, data is: ', data);
               });
        },
        saveModel: function() {
            /* Validation will occur before Cache sets data, flesh out here */
            var self = this;

            this.setModelState();
        },
        setModelState: function() {
            /* Overrides section level 'setSectionState' function */

            /* Validation will occur before Cache sets data, flesh out here */
            var self = this;
            var model = this.getJsonModel();
            var saveUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/' + self.saveEndpoint;
            var saveData = {
                csvFilePath: model.path_to_file,
                famHist: self.famHist
            };

            /* Passes in path to section CSV file, and path to referred section's RData file */
            $http.post(saveUrl, JSON.stringify(saveData))
               .success(function(data, status, headers, config) {
                   /* Remove first row name because it's actually the first column header */
                   data.rows.shift();

                   /* Store RData file path in global JSON object and open next section */
                   self.parseJsonModel(data);

                   self.section.broadcastSectionStatus();
               })
               .error(function(data, status, headers, config) {
                   console.log('status is: ', status);
               })
               .finally(function(data) {
                   console.log('finally, data is: ', data);
               });
        },
        getJsonModel: function() {
            var self = this;
            var filePath = Cache.getSectionKey(this.section.id, 'path_to_file');
            var obj = {
                'id': this.section.id,
                data: {
                    'famHist': self.famHist !== self.sectionDependencyData.rows[0] ? self.famHist : 'NA'
                }
            };

            if (filePath) {
                obj['path_to_file'] = filePath;
            }

            return obj;
        },
        parseJsonModel: function(model) {
            var m = this.getJsonModel();

            Cache.setSectionData(this.section.id, m);

            if (model) {
                var rows = model.hasOwnProperty('rows') ? model.rows : this.templateRows;
                var filePath;

                if (model.rows) {
                    var pathToFiles = JSON.parse(model.path_to_file);
                    filePath = pathToFiles[0];
                    famHistFilePath = pathToFiles[1];

                    Cache.setSectionKey(this.section.id, 'path_to_famHist_file', famHistFilePath);
                } else {
                    filePath = model.path_to_file;
                }

                /* Also store column and row template data for potential use by other sections */
                Cache.setUiData(this.section.id, {columns: this.templateCols, rows: rows });

                Cache.setSectionKey(this.section.id, 'path_to_file', filePath);
                console.log(Cache.getData());
            }
        }
    };

    return snpModel;
}]);
