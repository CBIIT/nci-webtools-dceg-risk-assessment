/* Creates a Variable object */
app.factory('BuildVariable', function() {
    function Variable() {
        var self = this;
        /* Check for passed in JSON cfg at later time */

        self.name = '';
        self.type = 'continuous';
        self.levels = '';
        self.ref = '';
    }
    Variable.prototype = {
        convertLevelsToArray: function() {
            console.log('return converted levels as []');
        },
        getFirstEntryInLevels: function() {
            console.log('returned first entry in levels');
        },
        getJsonModel: function() {
            var self = this;

            return {
                name: self.name,
                type: self.type,
                levels: self.convertLevelsToArray(),
                ref: self.ref ? self.ref : self.getFirstEntryInLevels()
            };
        }
    };

    return Variable;
});
