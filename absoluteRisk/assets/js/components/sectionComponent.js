angular.module('Arc')
.component('sectionComponent', {

    bindings: { id: '=' },
	controllerAs: 'section',
	controller: ['SectionService', function(section) {
        var self = this;
		self.getFileName      = function() { return section.getFileName(self.id) }
        self.downloadTemplate = function() { section.downloadTemplate(self.id) }
        self.downloadFile     = function() { section.downloadFile(self.id) }
        self.submit           = function() { section.submit(self.id) }
	}],

	templateUrl: 'templates/sections/defaultSection.html'
});
