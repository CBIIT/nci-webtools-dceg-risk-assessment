/* Creates a VariableList section model */
app.factory('BuildVariableListModel', ['BuildVariable', 'CacheService', function(Variable, Cache) {
    function VariableListModel() {
        var self = this;

        self.inputMethod = 'manual';
        self.variableList = [];

        /* Add more custom model functionality later */

        /* Add a single variable to the list as default list state */
        self.addVariable();
    }
    VariableListModel.prototype = {
        addVariable: function() {
            this.variableList.push(new Variable());
        },
        deleteVariable: function(index) {
            if (this.variableList.length > 1) {
                this.variableList.splice(index, 1);
            }
        },
        saveModel: function() {
            Cache.data.section_1 = this.getJsonModel();
            console.log('cache is: ', Cache.data);
        },
        getJsonModel: function() {
            var list = [];

            angular.forEach(this.variableList, function(variable) {
                list.push(variable.getJsonModel());
            });

            return {
                inputMethod: this.inputMethod,
                variableList: list
            };
        }
    };

    return VariableListModel;
}]);
