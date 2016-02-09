angular.module('Arc')
.component('formulaComponent', {

	controllerAs: 'fc',
	controller: ['DataService', 'UtilityService', 'SectionService', function(data, utility, section) {
		var self = this;
		self.id = 'modelFormula';

		var modelFormula = data.getSection(self.id);

		self.getFormulaData		    = getFormulaData;
		self.getFormulaString		= getFormulaString;
		self.submitData				= submitData;

		self.getUploadedFileName	= function() { return section.getUploadedFileName(self.id) }
		self.getExampleFile			= function() { section.getExampleFile(self.id) }
		self.downloadFile			= function() { section.downloadFile(self.id) }
		self.getUploadedFile	    = function() { section.getUploadedFile(self.id) }

        function getFormulaData() {
			if (!modelFormula.array)
				modelFormula.array = utility.parseFormula(data.sections());
            return modelFormula.array;
        }

        function getFormulaString() {
            modelFormula.model = utility.generateFormula(data.sections());
            return modelFormula.model;
        }

		function submitData() {
			data.submitModel(self.id, modelFormula.model);

			var logOddsRatios = data.getSection('logOddsRatios');
			logOddsRatios.rowNames = utility.generateLogOddsRatios(data.sections());

			data.submitSection(self.id);
		}
	}],

	templateUrl: 'templates/modelFormula.html'
});
