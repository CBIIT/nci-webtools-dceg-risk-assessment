angular.module('Arc')
.component('formulaComponent', {

	controllerAs: 'section',
	controller: ['DataService', 'UtilityService', 'SectionService', function(data, utility, section) {
		var self = this;
		self.id = 'modelFormula';

		self.modelFormula 			= data.getSection(self.id);
		self.getFileName			= function() { return section.getFileName(self.id) }
		self.getTemplate			= function() { section.getTemplate(self.id) }
		self.downloadFile			= function() { section.downloadFile(self.id) }
		self.submitSection			= function() { section.submitSection(self.id) }
		self.getFormulaData		    = getFormulaData;
		self.getFormulaString		= getFormulaString;

        function getFormulaData() {
			if (!self.modelFormula.array)
				self.modelFormula.array = utility.parseFormula();
            return self.modelFormula.array;
        }

        function getFormulaString() {
            self.modelFormula.model = utility.generateFormula();
            return self.modelFormula.model;
        }
	}],

	templateUrl: 'templates/modelFormula.html'
});
