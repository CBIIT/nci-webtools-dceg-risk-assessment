/* A general service to cache master JSON data */
app.factory('CacheService', function() {
    var self = this;
    self.data = {};

    self.getSectionData = function(section) {
        return self.data[section];
    };

    self.setSectionData = function(section, data) {
        self.data[section] = data;
        console.log(self.data);

        return true;
    };

    self.setSectionKey = function(section, sectionKey, keyValue) {
        self.data[section][sectionKey] = keyValue;
    };

    return {
        getSectionData: self.getSectionData,
        setSectionData: self.setSectionData,
        setSectionKey: self.setSectionKey
    };
});
