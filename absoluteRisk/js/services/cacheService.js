/* A general service to cache master JSON data */
app.factory('CacheService', function() {
    var self = this;
    self.data = {};

    self.getSectionData = function(section) {
        return self.data[section];
    };

    self.setSectionData = function(section, data) {
        self.data[section] = data;
        console.log(section + ' json model is: ', self.data[section]);

        return true;
    };

    self.setSectionKey = function(section, sectionKey, keyValue) {
        self.data[section][sectionKey] = keyValue;
    };

    self.getSectionKey = function(section, sectionKey) {
        return self.data[section][sectionKey];
    };

    return {
        getSectionData: self.getSectionData,
        setSectionData: self.setSectionData,
        setSectionKey: self.setSectionKey,
        getSectionKey: self.getSectionKey
    };
});
