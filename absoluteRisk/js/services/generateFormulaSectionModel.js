/* Creates a GenFormula section model */
app.factory('BuildGenFormulaModel', function() {
    function GenFormulaModel() {
        var self = this;

        self.status = 'edit';
        self.toggleStatus = function(status) {
            self.status = status;
        };

        /* Add more custom model functionality later */
    }
    GenFormulaModel.prototype = {
        getJsonModel: function() {
            console.log('this is generate formula model');
        }
    };

    return GenFormulaModel;
});
