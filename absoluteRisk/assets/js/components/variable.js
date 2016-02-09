angular.module('Arc')
.component('variable', {

	bindings: {
		data: '=',
        index: '=',
	},

	controller: ['DataService', function(dataService) {

		var model = dataService.getSection('listOfVariables').model;
		var self = this;

		// if this term contains levels, set the text
		// field to contain a space-delineated string
		if (self.data.levels)
			self.levels = self.data.levels.join(' ');

		// Splits the levels string into an array
        // If the array is empty then delete both
        // the levels and the reference level
		self.setLevels = function() {
			var levels = self.levels.split(/\s+/);

            if (levels[0])
                self.data.levels = levels;

            else {
                delete self.data.levels;
                delete self.data.ref;
            }
		}

		// clears levels and reference level
		self.clearLevels = function() {
			delete self.data.levels;
			delete self.data.ref;
			delete self.levels;
		}

        // removes this variable from the list of variables
		self.remove = function() {
            model.splice(self.index, 1);
		}
	}],

	templateUrl: 'templates/variable.html',
});
