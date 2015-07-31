/* Creates a VariableList section model */
app.factory('BuildVariableListModel', ['BuildVariable', function(Variable) {
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
            return;
        },
        getJsonModel: function() {
            console.log('this is variable list model');
        }
    };

    return VariableListModel;
}]);
