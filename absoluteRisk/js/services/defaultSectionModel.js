/* Creates a Default section model */
app.factory('BuildDefaultModel', function() {
    function DefaultModel() {
        this.genTemplate = true;

        /* Add more custom model functionality later */
    }
    DefaultModel.prototype = {
        getJsonModel: function() {
            console.log('this is default model');
        }
    };

    return DefaultModel;
});
