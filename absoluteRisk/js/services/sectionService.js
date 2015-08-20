/*
    A service that creates a generic accordion section with specific section models created within it
    It takes the following parameters:
        cfg: config object
            header:     section heading, as string
            type:       section model type, as string
            optional:   boolean indicating whether section is required or optional for the user to complete
*/
app.factory('BuildSection', [
    'BuildVariableListModel',
    'BuildGenFormulaModel',
    'BuildAgeIntervalModel',
    'BuildDefaultModel',
    '$rootScope',
    'uiUploader',
    '$http',
    'CacheService',
    function(vlModel, gfModel, aiModel, defModel, $rootScope, uiUploader, $http, Cache) {
        function Section(cfg) {
            var self = this;

            self.modelMap = {
                'variable_list':    vlModel,
                'generate_formula': gfModel,
                'age_interval':     aiModel,
                'default':          defModel
            };

            self.optional = cfg.optional ? cfg.optional : false;
            self.header = function() {
                var header = cfg.header;

                if (!self.optional) {
                    header = header + ' *';
                }
                return header;
            };

            self.type = cfg.type ? cfg.type : 'default';
            self.model = self.createModel(self.type);
            self.isDisabled = true;
            self.isOpen = false;
            self.dataRetrieval = cfg.dataRetrieval ? cfg.dataRetrieval : 'remote';

            self.file = null;
            self.id = cfg.id ? cfg.id : self.type;
            self.fileId = self.id + '_file';
            self.fileUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/fileUpload';
            self.dataUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/dataUpload';

            $rootScope.$on('fileAdded', function(e, data) {
                if (data.id === self.fileId) {
                    self.file = data.file;

                    /* Guard against undefined file if user cancels out of 'upload' dialog */
                    if (self.file) {
                        uiUploader.addFiles([self.file]);
                        uiUploader.startUpload({
                            url: self.fileUrl,
                            concurrency: 2,
                            onProgress: function(file) {
                                /* file contains a File object */
                                console.log(file);
                            },
                            onCompleted: function(file, response) {
                                var convertedData = response;

                                if (self.model.parseJsonModel) {
                                    console.log(convertedData);
                                    self.model.parseJsonModel(convertedData);
                                }
                                $rootScope.$broadcast('sectionStateChanged', { type: self.type, state: 'complete' });
                                $rootScope.$apply();
                            },
                            onCompletedAll: function(file) {}
                        });
                    }
                }
            });
        }

        Section.prototype = {
            init: function() {
                if (this.model.init) {
                    this.model.init();
                }
            },
            setSectionState: function(bool, data, label) {
                var self = this;
                var sectionData = JSON.stringify(data);
                var sectionLabel = label;
                var uploadPath = 'uploads/rdata/';

                this.isOpen = !bool;

                /* Ajax call to process save data as RData file and return the file as an attachment */
                $http.post(this.dataUrl, sectionData)
                   .success(function(data, status, headers, config) {
                       /* Change location to endpoint to force 'file download' dialog */
                       window.location = 'http://' + window.location.hostname + '/absoluteRiskRest/downloadFile?filename=' + data;

                       Cache.setSectionKey(sectionLabel, 'path_to_file', uploadPath + data);
                       $rootScope.$broadcast('sectionStateChanged', { type: self.type, state: 'complete' });
                       console.log(sectionLabel + ' JSON is:', Cache.getSectionData(sectionLabel));
                   })
                   .error(function(data, status, headers, config) {
                       console.log('status is: ', status);
                   })
                   .finally(function(data) {
                       console.log('finally, data is: ', data);
                   });
            },
            createModel: function(type) {
                /* Use modelMap to create the correct section model based on section type */
                return new this.modelMap[type](this, );
            },
            getJsonModel: function() {
                return this.model.getJsonModel();
            }
        };

        return Section;
    }
]);
