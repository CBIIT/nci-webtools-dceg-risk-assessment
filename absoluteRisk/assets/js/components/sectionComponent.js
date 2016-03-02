angular.module('Arc')
.component('sectionComponent', {

    bindings: { id: '=' },
	controllerAs: 'section',
	controller: ['SectionService', function(section) {
        var self = this;
		self.getFileName      = function() { return section.getFileName(self.id) }
		self.getTemplate      = function() { section.getTemplate(self.id) }
		self.downloadFile     = function() { section.downloadFile(self.id) }
		self.submitSection    = function() { section.submitSection(self.id) }
	}],

	templateUrl: 'templates/defaultSection.html'
});
