/* Creates a GenFormula section model */
app.factory('BuildGenFormulaModel', ['BuildFormulaVariable', 'CacheService', function(FormulaVariable, Cache) {
    function GenFormulaModel(parent) {
        var self = this;

        self.status = 'edit';
        self.toggleStatus = function(status) {
            self.status = status;
        };
        self.variables = [];
        self.section = parent;
    }
    GenFormulaModel.prototype = {
        init: function() {
            var self = this;
            var dataModel = Cache.getSectionData('section_1');
            var list = dataModel.data;
            var tempList = angular.copy(list);

            self.variables = [];
            self.status = 'edit';

            angular.forEach(list, function(variable) {
                tempList.shift();

                var formulaVar = new FormulaVariable(variable, angular.copy(tempList), self);
                self.variables.push(formulaVar);
            });
        },
        generateFormula: function() {
            var genFormulaUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/generateFormula';
            var dataJson = {
                pathToVariableListFile: Cache.getSectionKey('section_1', 'path_to_file'),
                model: this.getJsonModel()
            };

            $http.post(genFormulaUrl, JSON.stringify(dataJson))
               .success(function(data, status, headers, config) {
                   console.log('formula is: ', data);
                   /* Later display formula in dialog window */
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
            var model = this.getJsonModel();
            var sectionLabel = 'section_2';
            var isValid = Cache.setSectionData(sectionLabel, model);

            if (isValid) {
                this.section.setSectionState(isValid, model, sectionLabel);
            }
        },
        getJsonModel: function() {
            var list = [];

            angular.forEach(this.variables, function(variable) {
                list.push(variable.getJsonModel());
            });

            return {
                id: this.section.id,
                data: list
            };
        }
    };

    return GenFormulaModel;
}]);
