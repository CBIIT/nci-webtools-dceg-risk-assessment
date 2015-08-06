/* Creates a Formula Variable object */
app.factory('BuildFormulaVariable', function() {
    function FormulaVariable(v, interactionTerms) {
        var self = this;
        /* Check for passed in JSON cfg at later time */

        self.name = v.name;
        self.linear = true;
        self.terms = interactionTerms; // List of terms that user can select
        self.interaction = [];
    }
    FormulaVariable.prototype = {
        getJsonModel: function() {
            var self = this;

            return {
                name: self.name,
                linear: self.linear,
                interaction: self.interaction
            };
        }
    };

    return FormulaVariable;
});
