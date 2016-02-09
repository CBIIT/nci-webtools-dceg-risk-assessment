angular.module('Arc')
.component('term', {

	bindings: {
		data: '='
	},

	controller: function() {

		var self = this;

		// if this term contains interactions, set the text
		// field to display a space-delineated string
		if (self.data.interaction != null) {

			if (Array.isArray(self.data.interaction))
				self.interaction = self.data.interaction.join(" ");

			else
				self.interaction = self.data.interaction;
		}

		// Splits the interactions string into an array
		this.setInteractionTerms = function() {
			var terms = self.interaction.split(/\s+/);

			if (terms.length > 1)
				self.data.interaction = terms;

			else
				self.data.interaction = terms[0];
		}
	},

	templateUrl: 'templates/formulaTerm.html'
});
