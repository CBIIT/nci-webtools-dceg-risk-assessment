angular.module('Arc')
.component('sectionComponent', {

    bindings: {
        id: '=',
	},

	controllerAs: 'sc',
	controller: ['SectionService', function(section) {
        var self = this;
		self.getUploadedFileName	= function() { return section.getUploadedFileName(self.id) }
		self.getExampleFile			= function() { section.getExampleFile(self.id) }
		self.downloadFile			= function() { section.downloadFile(self.id) }
		self.getUploadedFile	    = function() { section.getUploadedFile(self.id) }
        self.viewTemplate           = function() { section.viewTemplate(self.id) }
		self.submitData				= function() { section.submitSection(self.id) }
	}],

	templateUrl: 'templates/defaultSection.html'
});
