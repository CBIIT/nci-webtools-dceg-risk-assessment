/* Creates a GenFormula section model */
app.factory('BuildGenFormulaModel', ['BuildFormulaVariable', 'CacheService', '$http', '$rootScope', function(FormulaVariable, Cache, $http, $rootScope) {
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
            var dataModel = Cache.getSectionData('variable_list');
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
                pathToVariableListFile: Cache.getSectionKey('variable_list', 'path_to_file'),
                model: this.getJsonModel()
            };

            $http.post(genFormulaUrl, JSON.stringify(dataJson))
               .success(function(data, status, headers, config) {
                   /* Display formula in a modal */
                   $rootScope.$broadcast('modalContent', { type: 'formula', content: JSON.parse(data) });
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
            var isValid;

            /* Set column names for subsequent section, in Cache UI {} */
            Cache.setUiData(this.section.id, model.ui);

            /* Remove ui property from model before setting section data for remote use */
            delete model.ui;

            isValid = Cache.setSectionData(this.section.id, model);

            if (isValid) {
                this.section.setSectionState(isValid, model, this.section.id);
            }
        },
        getJsonModel: function() {
            var list = [];
            var columnNames = [];

            angular.forEach(this.variables, function(variable) {
                if (variable.linear) {
                    columnNames.push(variable.name);
                }

                list.push(variable.getJsonModel());
            });

            return {
                id: this.section.id,
                data: list,
                ui: {
                    columns: columnNames
                }
            };
        }
    };

    return GenFormulaModel;
}]);
