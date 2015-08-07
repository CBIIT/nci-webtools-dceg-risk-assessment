/* Creates a Formula Variable object */
app.factory('BuildFormulaVariable', ['$rootScope', 'verifyTermsFilter', function($rootScope, verifyTerms) {
    function FormulaVariable(v, interactionTerms, parent) {
        var self = this;
        /* Check for passed in JSON cfg at later time */

        self.name = v.name;
        self.linear = true;
        self.parent = parent;

        /*
            List of terms that are simple object literals from Cache service
            The only purpose of the list is to allow the user to select one of or more terms
            that will be stored in interaction [] below.
        */
        self.terms = interactionTerms;
        self.interaction = [];

        /* This is needed to show/hide multi-select dropdown depending on the value */
        self.fakeTermsLength = self.terms.length;

        $rootScope.$on('linearStateChanged', function(event, v) {

            /* Using custom filter to get fakeTermsLength */
            var vTerms = verifyTerms(null, self.terms, self.parent.variables);
            self.fakeTermsLength = vTerms.length;

            /*
                Reset interaction array if no terms to choose from.
                Multi-select will not show in UI due to ng-show condition.
                When multi-select is visible again, no terms should be selected
            */
            if (!self.fakeTermsLength) {
                this.interaction = [];
            }

            /* Updates interaction array by removing any non-linear terms from it */
            angular.forEach(self.interaction, function(interaction, index) {
                if (interaction.name === v.name) {
                    self.interaction.splice(index, 1);
                }
            });
        });
    }
    FormulaVariable.prototype = {
        alertLinearState: function() {

            /*
                Reset interaction array if non-linear
                Multi-select should be empty when it is visible in UI  again
            */
            if (!this.linear) {
                this.interaction = [];
            }

            $rootScope.$broadcast('linearStateChanged', { name: this.name });
        },
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
}]);
