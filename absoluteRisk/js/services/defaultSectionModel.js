/* Creates a Default section model */
app.factory('BuildDefaultModel', ['CacheService', '$http', '$rootScope', function(Cache, $http, $rootScope) {
    function DefaultModel(parent) {
        var self = this;

        self.genTemplate = true;
        self.section = parent;
        self.placeHolderRows = [0, 1, 2, 3, 4];
        self.columns = [];
        self.templateCols = [];
        self.templateRows = [];
    }
    DefaultModel.prototype = {
        init: function(cfg) {
            var self = this;
            var endpoint = cfg.templateEndpoint;

            self.columns = cfg.cols;

            if (cfg.sectionDependency) {
                self.sectionDependency = cfg.sectionDependency;
                self.sectionDependencyData = angular.copy(Cache.getUiData(self.sectionDependency.id));

                if (self.sectionDependency.mapping === 'list') {
                    self.hasFamHist = true;
                    self.sectionDependencyData.rows.unshift('Family history is not in the model');
                    self.famHist = self.sectionDependencyData.rows[0];
                }

                if (self.sectionDependency.mapping === 'rowToColumn') {
                    self.columns = self.sectionDependencyData.rows;
                }
            }

            self.templateCols = self.columns;

            self.postUploadActions = cfg.postUploadActions;
            self.templateType = cfg.templateType;
            self.fileUploadEndpoint = cfg.fileUploadEndpoint;
            self.postUploadEndpoint = cfg.postUploadEndpoint;

            if (self.templateType === 'staticDual') {
                /* Default to 2-column template vs. 3-column template */
                self.templateCols = self.columns[0];
                self.numOfCols = '2';
            }

            if (self.templateType === 'remote') {
                /* Remote data generation for template rows */
                self.getRemoteData(endpoint);
            }
        },
        selectTemplateColumns: function(val) {
            if (val === '2') {
                this.templateCols = this.columns[0];
            } else {
                this.templateCols = this.columns[1];
            }
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
        getRemoteData: function(url) {
            var self = this;
            var remoteUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/' + url;
            var remoteData = {
                pathToVariableListFile: Cache.getSectionKey('variable_list', 'path_to_file'),
                pathToGenFormulaFile: Cache.getSectionKey('generate_formula', 'path_to_file'),
                formulaData: Cache.getSectionData('generate_formula')
            };

            $http.post(remoteUrl, JSON.stringify(remoteData))
               .success(function(data, status, headers, config) {
                   self.templateRows = data;
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
            var obj = {
                'id': this.section.id,
                'path_to_file': ''
            };

            if (self.hasOwnProperty('hasFamHist')) {
                obj['famHist'] = self.famHist !== self.sectionDependencyData.rows[0] ? self.famHist : 'NA';
            }

            return obj;
        },
        parseJsonModel: function(model) {
            var m = this.getJsonModel();

            /* For 'default' sections, only need to create {} with section id and possible csv/rdata file paths */
            Cache.setSectionData(this.section.id, m);

            if (model) {
                var filePath = model.path_to_file;
                var rows = model.hasOwnProperty('rows') ? model.rows : this.templateRows;

                /* Also store column and row template data for potential use by other sections */
                Cache.setUiData(this.section.id, {columns: this.templateCols, rows: rows });

                Cache.setSectionKey(this.section.id, 'path_to_file', filePath);
            }
        }
    };

    return DefaultModel;
}]);
