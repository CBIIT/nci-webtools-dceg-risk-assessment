/* A general service to cache master JSON data */
app.factory('CacheService', function() {
    var self = this;
    self.data = {};

    self.getData = function(name, data) {
        return self.data;
    };

    self.setData = function(name, data) {
        self.data[name] = data;
        console.log(self.data);

        return true;
    };
    /*
        Maybe in this service have variables associated with each section data that say something like "section complete".
        Then each section can require this service (through sectionService.js) and "watch" the aforementioned variable to
        enable itself when the previous section is complete.
    */

    return {
        getData: self.getData,
        setData: self.setData
    };
});
