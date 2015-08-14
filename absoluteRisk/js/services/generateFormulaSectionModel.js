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
            var data = Cache.getData();
            var list = data.section_1.variableList;
            var tempList = angular.copy(list);

            self.variables = [];
            self.status = 'edit';

            angular.forEach(list, function(variable) {
                tempList.shift();

                var formulaVar = new FormulaVariable(variable, angular.copy(tempList), self);
                self.variables.push(formulaVar);
            });
        },
        saveModel: function() {
            /* Validation will occur before Cache sets data, flesh out here */
            var modelData = this.getJsonModel();
            var isValid = Cache.setData('section_2', modelData);

            if (isValid) {
                this.section.setSectionState(isValid, modelData.variableList);
            }
        },
        getJsonModel: function() {
            console.log('this is generate formula model');
        }
    };

    return GenFormulaModel;
}]);
