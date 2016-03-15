angular.module('Arc')
.component('variablesComponent', {

	controllerAs: 'section',
	controller: ['DataService', 'SectionService', 'UtilityService', function(data, section, utility) {
		var self = this;
		var id = 'listOfVariables';
		var listOfVariables = data.getSection(id);

		self.addVariable	= function() { listOfVariables.array.push({ name: '', type: 'continuous' }) }
        self.removeVariable	= function(i){ listOfVariables.array.splice(i, 1) }
		self.getVariables	= function() { return listOfVariables.array }
		self.getFileName	= function() { return section.getFileName(id) }

		self.downloadFile	= function() {
			listOfVariables.model = model(listOfVariables.array);
			section.downloadFile(id);
		}

		self.submit			= function() {
			listOfVariables.model = model(listOfVariables.array);
			section.submit(id);
        }

		function array(model) {
			return model.map(function(variable) {
				var v = {name: variable.name, type: variable.type}

				if (variable.levels && variable.levels.length)
					v.levels = variable.levels.join(' ');

				if (variable.ref && variable.ref.length)
					v.ref = variable.ref;

				return v;
			});
		}

		function model(array) {
			return array.map(function(variable) {
				var v = {name: variable.name, type: variable.type}

				if (variable.levels && variable.levels.length)
					v.levels = variable.levels.split(' ');

				if (variable.ref && variable.ref.length)
					v.ref = variable.ref;

				return v;
			});
		}
	}],

	templateUrl: 'templates/sections/listOfVariables.html'
});
