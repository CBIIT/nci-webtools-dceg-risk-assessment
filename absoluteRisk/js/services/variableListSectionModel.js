/* Creates a VariableList section model */
app.factory('BuildVariableListModel', ['BuildVariable', 'CacheService', '$rootScope', function(Variable, Cache, $rootScope) {
    function VariableListModel(parent) {
        var self = this;

        self.inputMethod = 'manual';
        self.section = parent;
        self.variableList = [];
    }
    VariableListModel.prototype = {
        init: function() {
            if (this.inputMethod === 'manual') {
                this.variableList.length = 0;

                /* Add a single variable to the list as default list state */
                this.addVariable();
            } else {
                /* Reset form to reset file input */
                var sectionForm = document.getElementById(this.section.id);
                sectionForm.reset();

                this.section.file = null;
            }
        },
        addVariable: function() {
            this.variableList.push(new Variable());
        },
        deleteVariable: function(index) {
            if (this.variableList.length > 1) {
                this.variableList.splice(index, 1);
            }
        },
        saveModel: function() {
            /* Validation will occur before Cache sets data, flesh out here */
            var modelData = this.getJsonModel();
            var sectionLabel = 'section_1';
            var isValid = Cache.setSectionData(sectionLabel, modelData);

            if (isValid) {
                this.section.setSectionState(isValid, modelData.variableList, sectionLabel);
            }
        },
        getJsonModel: function() {
            var list = [];

            angular.forEach(this.variableList, function(variable) {
                list.push(variable.getJsonModel());
            });

            return {
                variableList: list
            };
        },
        parseJsonModel: function(model) {
            if (model) {
                var m = JSON.parse(model);
                var label = 'section_1';
                var filePath = m.shift()['path_to_file'];
                var variableList = m;

                Cache.setSectionData(label, { 'path_to_file': filePath, 'variableList': variableList });
                console.log('converted data for section_1 is: ', Cache.getSectionData(label));
            }
        }
    };

    return VariableListModel;
}]);
