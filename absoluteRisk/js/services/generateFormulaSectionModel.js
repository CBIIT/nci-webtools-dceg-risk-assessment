/* Creates a GenFormula section model */
app.factory('BuildGenFormulaModel', ['BuildFormulaVariable', 'CacheService', '$http', '$rootScope', function(FormulaVariable, Cache, $http, $rootScope) {
    function GenFormulaModel(parent) {
        var self = this;

        self.inputMethod = 'manual';
        self.status = 'edit';
        self.variables = [];
        self.section = parent;
    }
    GenFormulaModel.prototype = {
        init: function(cfg) {
            var self = this;
            var dataModel = Cache.getSectionData('variable_list');
            var list = dataModel.data;
            var tempList = angular.copy(list);

            if (self.inputMethod === 'manual') {
                self.variables = [];
                self.status = 'edit';
                self.fileUploadEndpoint = cfg.fileUploadEndpoint;

                angular.forEach(list, function(variable) {
                    tempList.shift();

                    var formulaVar = new FormulaVariable(variable, angular.copy(tempList), self);
                    self.variables.push(formulaVar);
                });
            } else {
                /* Reset form to reset file input */
                var sectionForm = document.getElementById(self.section.id);
                sectionForm.reset();

                self.section.file = null;
            }
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

            /* Store row names for use in subsequent section, in Cache UI {} */
            Cache.setUiData(this.section.id, model.ui);

            /* Remove ui property from model before setting section data for remote use */
            delete model.ui;

            isValid = Cache.setSectionData(this.section.id, model);

            if (isValid) {
                this.section.setSectionState({
                    isValid: isValid,
                    data: model
                });
            }
        },
        toggleStatus: function(status) {
            var filteredList = [];
            var linearVars = getLinearVariables(this.variables).linearVars;
            var variableList = Cache.getSectionKey('variable_list', 'data');

            if (status === 'confirmed') {
                angular.forEach(variableList, function(variable) {
                    angular.forEach(linearVars, function(v) {
                        if (variable.name === v) {
                            filteredList.push(variable);
                        }
                    });
                });

                if (filteredList.length < variableList.length) {

                    console.log('filtered list is: ', filteredList);
                    this.section.setSectionState({
                        id: 'variable_list',
                        isValid: isValid,
                        data: {
                            id: 'variable_list',
                            data: filteredList,
                        },
                        rdataStoreOnly: true,
                        skipBroadcast: true
                    });
                }
            }

            this.status = status;
        },
        getJsonModel: function() {
            var variablesObj = getLinearVariables(this.variables, true);

            return {
                id: this.section.id,
                data: variablesObj.list,
                ui: {
                    rows: variablesObj.linearVars
                }
            };
        },
        parseJsonModel: function(model) {
            if (model) {
                var m = model;
                var filePath = m.shift()['path_to_file'];
                var linearVarsFromRDataFile = getLinearVariables(m).linearVars;
                var sectionData = {
                    'id': this.section.id,
                    'path_to_file': filePath,
                    'data': m
                };

                console.log('parsed model is: ', model);
                Cache.setSectionData(this.section.id, sectionData);
                Cache.setUiData(this.section.id, { rows: linearVarsFromRDataFile });
                Cache.getUiData(this.section.id);
            }
        }
    };

    /* Helper Functions */
    function getLinearVariables(model, isJsonMethod) {
        var self = this;
        var list = [];
        var linearVars = [];
        var allVars = model;

        angular.forEach(allVars, function(variable) {
            if (variable.linear) {
                linearVars.push(variable.name);
            }

            if (isJsonMethod) {
                list.push(variable.getJsonModel());
            }
        });

        return {
            list: list,
            linearVars: linearVars
        };
    }

    return GenFormulaModel;
}]);
