/* Creates a Default section model */
app.factory('BuildDefaultModel', ['CacheService', '$http', '$rootScope', function(Cache, $http, $rootScope) {
    function DefaultModel(parent) {
        var self = this;

        self.genTemplate = true;
        self.isDisabled = true;
        self.section = parent;
        self.columns = [];
        self.placeHolderRows = [0, 1, 2, 3, 4];
    }
    DefaultModel.prototype = {
        init: function() {
            var self = this;
            var varListData = Cache.getSectionData('section_1');
            var genFormulaData = Cache.getSectionData('section_2');

            if (self.section.dataRetrieval === 'static') {
                /* Static data generation for template */
                self.columns = genFormulaData.data;
            } else {
                /* Remote data generation for template */
            }
        },
        getJsonModel: function() {
            console.log('this is default model');
        }
    };

    return DefaultModel;
}]);
