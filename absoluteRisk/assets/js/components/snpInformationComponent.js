angular.module('Arc')
.component('snpInformationComponent', {

	controllerAs: 'section',
	controller: ['DataService', 'SectionService', function(data, section) {

        var self = this;
		self.id = 'snpInformation';

		self.model					= data.getSection(self.id);
		self.familyHistory			= 'Family history is not in the model';
		self.getFileName			= function() { return section.getFileName(self.id) }
		self.getTemplate			= function() { section.getTemplate(self.id) }
		self.downloadFile			= function() { section.downloadFile(self.id) }
        self.submitSection			= function() { section.submitSection(self.id) }
		self.getVariableNames		= function() { return ['Family history is not in the model']
			.concat(data.getSection('listOfVariables').model.map(function(variable) {
				return variable.name;
			}));
		}
	}],

	templateUrl: 'templates/snpInformation.html'
});
