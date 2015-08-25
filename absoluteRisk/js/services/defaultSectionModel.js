/* Creates a Default section model */
app.factory('BuildDefaultModel', ['CacheService', '$http', '$rootScope', function(Cache, $http, $rootScope) {
    function DefaultModel(parent) {
        var self = this;

        self.genTemplate = true;
        self.isDisabled = true;
        self.section = parent;
        self.placeHolderRows = [0, 1, 2, 3, 4];
    }
    DefaultModel.prototype = {
        init: function(cfg) {
            var self = this;
            var templateType = cfg.templateType;
            var endpoint = cfg.endpoint;
            var referredSectionData;

            if (cfg.sectionReference) {
                referredSectionData = Cache.getUiData(cfg.sectionReference);
            }

            self.templateCols = cfg.cols ? cfg.cols : referredSectionData.columns;
            self.templateRows = [];

            if (templateType === 'staticDual') {
                /* Static data generation for template */
                /* 2 types of templates can be displayed, see what user selects */
            }

            if (templateType === 'remote') {
                /* Remote data generation for template rows */
                self.getRemoteData(endpoint);
            }
        },
        exportToCsv: function(e) {
            var self = this;
            var filename = self.section.id;
        	var csvContent;

            e.preventDefault();
            e.stopPropagation();

            csvContent = 'data:text/csv;charset=utf-8,' + self.templateCols.join(',');

    		encodedUri = encodeURI(csvContent);
    		window.open(encodedUri, '_self');
        },
        getRemoteData: function(url) {
            var remoteUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/' + url;
            var remoteData = {
                pathToVariableListFile: Cache.getSectionKey('variable_list', 'path_to_file'),
                pathToGenFormulaFile: Cache.getSectionKey('generate_formula', 'path_to_file')
            };

            console.log('remote data is: ', remoteData);

            $http.post(genFormulaUrl, JSON.stringify(remoteData))
               .success(function(data, status, headers, config) {
                   console.log('returned row names are: ', data);
               })
               .error(function(data, status, headers, config) {
                   console.log('status is: ', status);
               })
               .finally(function(data) {
                   console.log('finally, data is: ', data);
               });
        },
        getJsonModel: function() {
            /* For 'default' sections, only need to create {} with section id and RData file path */
            Cache.setSectionData(this.section.id, {'path_to_file': ''} );

            /* Also store column and row template data for potential use by other sections */
            Cache.setUiData(this.section.id, {columns: this.templateCols, rows: this.templateRows });
        },
        parseJsonModel: function(model) {
            this.getJsonModel();

            if (model) {
                var m = JSON.parse(model);
                var filePath = m.path_to_file;

                Cache.setSectionKey(this.section.id, 'path_to_file', filePath);
            }
        }
    };

    return DefaultModel;
}]);
