/* Creates a Formula Variable object */
app.factory('BuildFormulaVariable', ['$rootScope', function($rootScope) {
    function FormulaVariable(v, interactionTerms) {
        var self = this;
        /* Check for passed in JSON cfg at later time */

        self.name = v.name;
        self.linear = true;
        self.terms = interactionTerms; // List of terms that user can select
        self.interaction = [];  // terms selected by user in the UI multi-select

        $rootScope.$on('linearStateChanged', function(event, v) {
            angular.forEach(self.interaction, function(interaction, index) {
                if (interaction.name === v.name) {
                    // Remove interaction from array
                    self.interaction.splice(index, 1);
                }
            });
        });
    }
    FormulaVariable.prototype = {
        alertLinearState: function() {
            console.log('linear state is: ', this.linear);

            $rootScope.$broadcast('linearStateChanged', { name: this.name, linear: false });
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
