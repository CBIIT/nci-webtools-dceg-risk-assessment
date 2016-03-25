angular.module('Arc')
.component('snpInformationComponent', {

	controllerAs: 'section',
	controller: ['DataService', 'SectionService', function(data, section) {
        var self = this;
		id = 'snpInformation';

		self.model					= data.getSection(id);
		self.familyHistory			= 'Family history is not in the model';
        self.submit			        = function() { section.submit(id) }
        self.getFileName			= function() { return section.getFileName(id) }
        self.downloadFile			= function() { section.downloadFile(id) }
        self.downloadTemplate       = function() { section.downloadTemplate(id) }
		self.getVariableNames		= function() { return ['Family history is not in the model']
			.concat(data.getSection('listOfVariables').model.map(function(v) {return v.name}));
		}
	}],

	templateUrl: 'templates/sections/snpInformation.html'
});
