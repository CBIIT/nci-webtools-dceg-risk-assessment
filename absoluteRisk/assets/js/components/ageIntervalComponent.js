angular.module('Arc')
.component('ageIntervalComponent', {

	controllerAs: 'section',
	controller: ['DataService', 'SectionService', function(data, section) {

        var self = this;
		self.id = 'ageInterval';

		self.inputMethod 			= 'manual';
		self.model 					= data.getSection(self.id);
		self.range					= function(i){ return i ? self.range(i-1).concat(i):[] }
		self.getFileName			= function() { return section.getFileName(self.id) }
		self.downloadFile			= function() { section.downloadFile(self.id) }
        self.downloadTemplate		= function() { section.downloadTemplate(self.id) }
		self.submit			        = function() {
			if (self.inputMethod == 'manual')
				data.getSection(self.id).model = [self.model.columnNames, [self.model.age, self.model.interval]];

			section.submit(self.id);
		}
	}],

	templateUrl: 'templates/sections/ageInterval.html'
});
