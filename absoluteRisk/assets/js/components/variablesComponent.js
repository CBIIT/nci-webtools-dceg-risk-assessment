angular.module('Arc')
.component('variablesComponent', {

	controllerAs: 'vc',
	controller: ['DataService', 'UtilityService', 'SectionService', function(data, utility, section) {

		var self = this;
		self.id = 'listOfVariables';
		var listOfVariables = data.getSection(self.id);

		self.addVariable			= function() { listOfVariables.model.push( { name: '', type: 'continuous' } ) }
		self.getListOfVariables		= function() { return listOfVariables.model }
		self.getUploadedFileName	= function() { return section.getUploadedFileName(self.id) }
		self.getExampleFile			= function() { section.getExampleFile(self.id) }
		self.downloadFile			= function() { section.downloadFile(self.id) }
		self.getUploadedFile	    = function() { section.getUploadedFile(self.id) }
		self.submitData				= function() {

			data.submitModel(self.id, listOfVariables.model);

			var modelFormula = data.getSection('modelFormula');
			var riskFactorDistribution = data.getSection('riskFactorDistribution');
			var riskFactorForPrediction = data.getSection('riskFactorForPrediction');
			var variableNames = listOfVariables.model.map(function(variable) {
				return variable.name;
	        });

			modelFormula.array = utility.generateFormulaTemplate(data.sections());
			modelFormula.model = utility.generateFormula(data.sections());
			riskFactorDistribution.columnNames = variableNames;
			riskFactorForPrediction.columnNames = variableNames;

			data.submitSection(self.id);
		}
	}],

	templateUrl: 'templates/listOfVariables.html'
});
