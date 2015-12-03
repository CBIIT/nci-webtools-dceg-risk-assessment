/* Creates a GenFormula section model */
app.factory('BuildGenFormulaModel', ['BuildFormulaVariable', 'CacheService', 'DataRetrieval', '$rootScope', function(FormulaVariable, Cache, dataRetrieval, $rootScope) {
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

            function successCb(d) {
                
                fileName = d['path'].split('/');
                fileName = fileName[fileName.length - 1];
                
                var url = 'http://' + window.location.hostname + '/absoluteRiskRest/downloadFile?filename=' + fileName;
                
                /* Display formula in a modal window */
                $rootScope.$broadcast('modalContent', { type: 'formula', content: {'formula': d['formula'], 'path_to_formula': url} });
            }

            /* Call data retrieval service to return created Formula */
            dataRetrieval.retrieveData({
                url: genFormulaUrl,
                data: dataJson,
                success: successCb
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

                this.section.setSectionState({
                    id: 'variable_list',
                    isValid: false,
                    data: {
                        id: 'variable_list',
                        data: filteredList,
                    },
                    rdataStoreOnly: true,
                    skipBroadcast: true
                });
            }

            this.status = status;
        },
        getJsonModel: function() {
            var variablesObj = getLinearVariables(this.variables, true);

            return {
                id: this.section.id,
                data: variablesObj.list,
                isFormula: true,
                pathToVariableListFile: Cache.getSectionKey('variable_list', 'path_to_file'),
                ui: {
                    rows: variablesObj.linearVars
                }
            };
        },
        parseJsonModel: function(model) {
            if (model) {
                var m = model;
                console.log(m);
                var filePath = m['path_to_file'];
                
                var formulaFilePath = m['path_to_file'];
                var variablesFilePath = Cache.getSectionKey('variable_list', 'path_to_file');
                
                processFormulaURL = 'http://' + window.location.hostname + '/absoluteRiskRest/processFormula';
                
                
                var dataJson = {
                    pathToFormulaFile : m['path_to_file'],
                    pathToVariableListFile : Cache.getSectionKey('variable_list', 'path_to_file')
                };
                
                var id = this.section.id;

                var formulaJSON = [];
                var linearVarsFromRDataFile = getLinearVariables(this.variables, true)['linearVars']; 
                
                function successCb(d) {
                    var formulaJSON = angular.fromJson(d);

                    console.log("testing call" + linearVarsFromRDataFile);
                    
                    var sectionData = {
                        'id': id,
                        'path_to_file': m['path_to_file'],
                        'data': angular.fromJson(formulaJSON)
                    };
                    
                    console.log(sectionData);
        
                    console.log('parsed model is: ', model);
                    Cache.setSectionData(id, sectionData);
                    Cache.setUiData(id, { rows: linearVarsFromRDataFile });
                    Cache.getUiData(id);
                }
                
                /* Call data retrieval service to return JSON formula */
                dataRetrieval.retrieveData({
                    url: processFormulaURL,
                    data: dataJson,
                    success: successCb
                });
                
                console.log(formulaJSON);
                    
                var sectionData = {
                    'id': this.section.id,
                    'path_to_file': filePath,
                    'data': formulaJSON
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
