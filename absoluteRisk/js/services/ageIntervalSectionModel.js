/* Creates an AgeInterval section model */
app.factory('BuildAgeIntervalModel', function() {
    function AgeIntervalModel() {
        var self = this;

        self.inputMethod = 'manual';
        self.ages = arrRange(120);
        self.ageIntervals = arrRange(100);
        self.age = self.ages[29];
        self.ageInterval = self.ageIntervals[2];

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
        saveModel: function() {
            console.log('saving model');
        },
        getJsonModel: function() {
            return {
                age: this.age,
                ageInterval: this.ageInterval
            };
        }
    };

    return AgeIntervalModel;
});
