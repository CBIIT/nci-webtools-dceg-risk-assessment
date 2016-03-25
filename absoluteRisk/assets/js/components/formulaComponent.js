angular.module('Arc')
.component('formulaComponent', {

	controllerAs: 'section',
	controller: ['DataService', 'SectionService', 'UtilityService', function(data, section, utility) {
		var self = this;
		var id = 'modelFormula';
		var modelFormula = data.getSection(id);

		self.updateInteractions		= updateInteractions;
		self.getInteractions		= getInteractions;
		self.getFormulaData		    = getFormulaData;
		self.getFormulaString		= getFormulaString;
		self.downloadFile     		= function() { section.downloadFile(id) }
		self.getListOfVariables		= function() { return data.getSection('listOfVariables').model }
		self.getFormulaTerms		= function() { return modelFormula.array }
		self.submit					= function() { section.submit(id) }

        function getFormulaData() {
			if (!self.modelFormula.array)
				self.modelFormula.array = utility.parseFormula();
            return self.modelFormula.array;
        }

        function getFormulaString() {
            modelFormula.model = utility.generateFormula();
            return modelFormula.model;
        }

		function updateInteractions(i) {
			var toggle = modelFormula.array[i].linear;
			for (var j = 0; j < modelFormula.array.length; j ++)
				modelFormula.array[j].linear = j < i;
			modelFormula.array[i].linear = toggle;
		}

		function getInteractions(i) {
			var interactions = [];
			for (++ i; i < modelFormula.array.length; i ++)
				if (modelFormula.array[i].linear)
					interactions.push(modelFormula.array[i].name);
			return interactions;
		}
	}],

	templateUrl: 'templates/sections/modelFormula.html'
});
