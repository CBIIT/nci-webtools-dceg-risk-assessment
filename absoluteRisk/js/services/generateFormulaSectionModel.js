/* Creates a GenFormula section model */
app.factory('BuildGenFormulaModel', ['BuildFormulaVariable', 'CacheService', function(FormulaVariable, Cache) {
    function GenFormulaModel() {
        var self = this;

        self.status = 'edit';
        self.toggleStatus = function(status) {
            self.status = status;
        };
        self.variables = [];
    }
    GenFormulaModel.prototype = {
        init: function() {
            var self = this;
            var data = Cache.getData();
            var list = data.section_1.variableList;
            var tempList = angular.copy(list);

            self.variables = [];

            angular.forEach(list, function(variable) {
                tempList.shift();

                var formulaVar = new FormulaVariable(variable, angular.copy(tempList));
                self.variables.push(formulaVar);
            });
        },
        saveModel: function() {
            Cache.data.section_2 = this.getJsonModel();
            console.log('cache is: ', Cache.data);
        },
        getJsonModel: function() {
            console.log('this is generate formula model');
        }
    };

    return GenFormulaModel;
}]);
