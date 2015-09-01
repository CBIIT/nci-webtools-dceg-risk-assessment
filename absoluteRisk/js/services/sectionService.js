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
                'variable_list':    { func: vlModel, params: { fileUploadEndpoint: cfg.fileUploadEndpoint }},
                'generate_formula': { func: gfModel, params: { fileUploadEndpoint: cfg.fileUploadEndpoint }},
                'age_interval':     { func: aiModel, params: {}},
                'default':          { func: defModel, params: {
                                                            templateType: cfg.templateType,
                                                            cols: cfg.columnNames,
                                                            sectionReference: cfg.sectionReference ? cfg.sectionReference : null,
                                                            templateEndpoint: cfg.templateEndpoint ? cfg.templateEndpoint : null,
                                                            fileUploadEndpoint: cfg.fileUploadEndpoint ? cfg.fileUploadEndpoint : null,
                                                            postUploadEndpoint: cfg.postUploadEndpoint ? cfg.postUploadEndpoint : null
                                                      }
                                    }
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
            self.model = self.createModel();
            self.isDisabled = true;
            self.isOpen = false;

            self.file = null;
            self.id = cfg.id ? cfg.id : self.type;
            self.fileId = self.id + '_file';
            self.fileUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/';
            self.dataUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/dataUpload';

            $rootScope.$on('fileAdded', function(e, data) {
                if (data.id === self.fileId) {
                    self.file = data.file;

                    /* This is for a scenario where a section uploads a CSV file and uses a section specific R script to convert to RData file */
                    if (self.model.fileUploadEndpoint) {
                        self.fileUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/' + self.model.fileUploadEndpoint;
                    }

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
                                if (self.model.parseJsonModel) {
                                    console.log(response);
                                    self.model.parseJsonModel(JSON.parse(response));
                                }

                                if (self.model.postUploadEndpoint) {
                                    self.model.postUploadActions(JSON.parse(response));
                                } else {
                                    self.broadcastSectionStatus(true);
                                }
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
                    this.model.init(this.modelMap[this.type].params);
                }
            },
            setSectionState: function(bool, data, label) {
                var self = this;
                var sectionData = JSON.stringify(data);
                var uploadPath = 'uploads/rdata/';

                this.isOpen = !bool;

                /* Ajax call to process save data as RData file and return the file as an attachment */
                $http.post(this.dataUrl, sectionData)
                   .success(function(data, status, headers, config) {
                       /* Change location to endpoint to force 'file download' dialog */
                       window.location = 'http://' + window.location.hostname + '/absoluteRiskRest/downloadFile?filename=' + data;

                       /* Save returned file path to section as section key/value pair */
                       Cache.setSectionKey(self.id, 'path_to_file', uploadPath + data);

                       self.broadcastSectionStatus();
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
                return new this.modelMap[this.type].func(this);
            },
            broadcastSectionStatus: function(runApply) {
                $rootScope.$broadcast('sectionStateChanged', { id: this.id, state: 'complete' });

                if (runApply) {
                    $rootScope.$apply();
                }
            },
            getJsonModel: function() {
                return this.model.getJsonModel();
            }
        };

        return Section;
    }
]);
