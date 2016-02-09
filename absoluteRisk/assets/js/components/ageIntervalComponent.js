angular.module('Arc')
.component('ageIntervalComponent', {

	controllerAs: 'section',
	controller: ['DataService', 'UtilityService', 'ModalService', 'SectionService', function(data, utility, modal, section) {

        var self = this;
		self.id = 'ageInterval';

        self.inputMethod = 'manual';
		self.selectedInterval = 5;
		self.selectedAge = 30;

		self.range					= arrRange(120);
		self.getUploadedFileName	= function() { return section.getUploadedFileName(self.id) }
		self.getExampleFile			= function() { section.getExampleFile(self.id) }
		self.downloadFile			= function() { section.downloadFile(self.id) }
		self.getUploadedFile	    = function() { section.getUploadedFile(self.id) }
		self.viewTemplate		 	= function() { section.viewTemplate(self.id) }
		self.submitData				= function() {

			var section = data.getSection(self.id);

			if (self.inputMethod == 'manual') {
				section.age = self.selectedAge.toString();
				section.interval = self.selectedInterval.toString();
				data.submitModel(self.id, section);
			}

			setTimeout(function() { data.submitSection(self.id) }, 100);
		}

		function arrRange(i) {
            return i ? arrRange(i-1).concat(i):[];
        }
	}],

	templateUrl: 'templates/ageInterval.html'
});
