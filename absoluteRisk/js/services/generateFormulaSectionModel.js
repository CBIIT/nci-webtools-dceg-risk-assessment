/* Creates a GenFormula section model */
app.factory('BuildGenFormulaModel', ['CacheService', function(Cache) {
    function GenFormulaModel() {
        var self = this;

        self.status = 'edit';
        self.toggleStatus = function(status) {
            self.status = status;
        };

        /* Add more custom model functionality later */
    }
    GenFormulaModel.prototype = {
        saveModel: function() {
            Cache.data.section_1 = this.getJsonModel();
            console.log('cache is: ', Cache.data);
        },
        getJsonModel: function() {
            console.log('this is generate formula model');
        }
    };

    return GenFormulaModel;
}]);
