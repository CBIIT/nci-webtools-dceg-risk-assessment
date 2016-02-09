angular.module('Arc')
.component('snpInformationComponent', {

	controllerAs: 'snp',
	controller: ['DataService', 'UtilityService', 'ValidationService', 'ModalService', 'SectionService', function(data, utility, validation, modal, section) {

        var self = this;
		self.id = 'snpInformation';

		self.familyHistory			= 'Family history is not in the model';
		self.getVariableNames		= getVariableNames;
		self.submitData				= submitData;

		self.getUploadedFileName	= function() { return section.getUploadedFileName(self.id) }
		self.getExampleFile			= function() { section.getExampleFile(self.id) }
		self.downloadFile			= function() { section.downloadFile(self.id) }
		self.getUploadedFile	    = function() { section.getUploadedFile(self.id) }
        self.viewTemplate           = function() { section.viewTemplate(self.id) }

		function getVariableNames() {
			var listOfVariables = data.getSection('listOfVariables');
			var variableNames = listOfVariables.model.map(function(variable) {
				return variable.name;
			});

			return ['Family history is not in the model'].concat(variableNames);
		}

		function submitData() {
			var snpInformation = data.getSection('snpInformation');
			snpInformation.familyHistory = self.familyHistory;
			snpInformation.uploadedRowNames = validation.retrieveRowNames(self.id);

			genotypesForPrediction = data.getSection('genotypesForPrediction');
			genotypesForPrediction.columnNames = snpInformation.uploadedRowNames;

			data.submitSection(self.id);
		}
	}],

	templateUrl: 'templates/snpInformation.html'
});
