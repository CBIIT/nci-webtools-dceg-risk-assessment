angular.module('Arc')
.component('variablesComponent', {

	controllerAs: 'section',
	controller: ['DataService', 'SectionService', function(data, section) {

		var self = this;
		self.id = 'listOfVariables';

		self.listOfVariables 		= data.getSection(self.id);
		self.addVariable			= function() { self.listOfVariables.model.push({ name: '', type: 'continuous' }) }
		self.getListOfVariables		= function() { return self.listOfVariables.model }
		self.getFileName			= function() { return section.getFileName(self.id) }
		self.downloadFile			= function() { section.downloadFile(self.id) }
		self.submitSection			= function() { section.submitSection(self.id) }
	}],

	templateUrl: 'templates/listOfVariables.html'
});
