/* A general service to cache master JSON data */
app.factory('CacheService', function() {
    var self = this;
    self.remoteData = {};
    self.uiData = {};

    self.getData = function() {
        return self.remoteData;
    };

    self.getSectionData = function(section) {
        console.log(section + ' remote data is: ', self.remoteData[section]);
        return self.remoteData[section];
    };

    self.setSectionData = function(section, data) {
        self.remoteData[section] = data;

        return true;
    };

    self.getSectionKey = function(section, sectionKey) {
        console.log(section + ' remote data after key is: ', self.remoteData[section]);

        if (self.remoteData.hasOwnProperty(section) && self.remoteData[section].hasOwnProperty(sectionKey)) {
            return self.remoteData[section][sectionKey];
        }
    };

    self.setSectionKey = function(section, sectionKey, keyValue) {
        self.remoteData[section][sectionKey] = keyValue;
    };

    self.getUiData = function(section) {
        console.log(section + ' UI data is: ', self.uiData[section]);
        return self.uiData[section];
    };

    self.setUiData = function(section, data) {
        self.uiData[section] = data;
    };

    self.createFilePathsObject = function() {
        var globalData = self.getData();
        var filePathsObj = {};

        for (var sectionKey in globalData) {
            filePathsObj[sectionKey] = {
                'path_to_file': globalData[sectionKey]['path_to_file']
            };

            if (sectionKey === 'snp_information') {
                filePathsObj[sectionKey]['path_to_famHist_file'] = globalData[sectionKey]['path_to_famHist_file'];
            }
        }

        return filePathsObj;
    };

    return {
        getData: self.getData,
        getSectionData: self.getSectionData,
        setSectionData: self.setSectionData,
        getSectionKey: self.getSectionKey,
        setSectionKey: self.setSectionKey,
        getUiData: self.getUiData,
        setUiData: self.setUiData,
        createFilePathsObject: self.createFilePathsObject
    };
});
