/* Creates an AgeInterval section model */
app.factory('BuildAgeIntervalModel', function() {
    function AgeIntervalModel() {
        var self = this;

        self.inputMethod = 'manual';
        self.isDisabled = true;

        /* Add more custom model functionality later */
    }
    AgeIntervalModel.prototype = {
        getJsonModel: function() {
            console.log('this is age interval model');
        }
    };

    return AgeIntervalModel;
});
