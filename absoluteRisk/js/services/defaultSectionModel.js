/* Creates a Default section model */
app.factory('BuildDefaultModel', ['CacheService', '$http', '$rootScope', function(Cache, $http, $rootScope) {
    function DefaultModel(parent, cfg) {
        var self = this;

        self.genTemplate = true;
        self.isDisabled = true;
        self.section = parent;
        self.templateType = cfg.templateType;
        self.sectionRef = cfg.sectionReference;
        self.placeHolderRows = [0, 1, 2, 3, 4];
    }
    DefaultModel.prototype = {
        init: function() {
            var self = this;
            var varListData = Cache.getSectionData('section_1');
            var genFormulaData = Cache.getSectionData('section_2');

            self.templateCols = cfg.cols ? cfg.cols : [];
            self.templateRows = [];

            if (!self.templateCols.length) {
                /* Static data generation for template */
                angular.forEach(genFormulaData.data, function(variable) {
                    if (variable.linear) {
                        self.templateCols.push(variable.name);
                    }
                });
            } else {
                /* Remote data generation for template */
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
