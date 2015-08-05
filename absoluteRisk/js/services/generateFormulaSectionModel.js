/* Creates a GenFormula section model */
app.factory('BuildGenFormulaModel', ['CacheService', function(Cache) {
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
            var data = Cache.getData();
            this.variables = data.section_1.variableList;
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
