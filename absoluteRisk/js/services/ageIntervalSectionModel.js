/* Creates an AgeInterval section model */
app.factory('BuildAgeIntervalModel', ['CacheService', '$http', function(Cache, $http) {
    function AgeIntervalModel(parent) {
        var self = this;

        self.section = parent;
        self.genTemplate = true;
        self.inputMethod = 'manual';
        self.ages = arrRange(120);
        self.ageIntervals = arrRange(100);
        self.age = self.ages[29];
        self.ageInterval = self.ageIntervals[2];
        self.placeHolderRows = [0, 1, 2, 3, 5];
        self.templateRows = [];

        function arrRange(i){
            return i ? arrRange(i-1).concat(i):[];
        }
    }
    AgeIntervalModel.prototype = {
        init: function(cfg) {
            var self = this;

            self.fileUploadEndpoint = cfg.fileUploadEndpoint;
            self.templateCols = cfg.cols;
        },
        exportToCsv: function(e) {
            var self = this;
            var filename = self.section.id;
            var csvExportUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/exportToCsv';
        	var csvData = {
                id: self.section.id,
                content: ''
            };

            e.preventDefault();
            e.stopPropagation();

            csvData.content = self.templateCols.join(',') + '\n';

            if (self.templateRows.length) {
                angular.forEach(self.templateRows, function(row) {
                    csvData.content += row + '\n';

                });
            }

            $http.post(csvExportUrl, JSON.stringify(csvData))
               .success(function(data, status, headers, config) {
                   var fileName = data.replace(/^.*[\\\/]/, '');
                   window.location = 'http://' + window.location.hostname + '/absoluteRiskRest/downloadFile?filename=' + fileName;
               })
               .error(function(data, status, headers, config) {
                   console.log('status is: ', status);
               })
               .finally(function(data) {
                   console.log('finally, data is: ', data);
               });
        },
        saveModel: function() {
            var model = this.getJsonModel();
            var isValid = Cache.setSectionData(this.section.id, model);

            if (isValid) {
                this.section.setSectionState({
                    isValid: isValid,
                    data: model,
                    rdataStoreOnly: true
                });
            }
        },
        getJsonModel: function() {
            return {
                id: this.section.id,
                data: {
                    age: this.age,
                    ageInterval: this.ageInterval
                }
            };
        }
    };

    return AgeIntervalModel;
}]);
