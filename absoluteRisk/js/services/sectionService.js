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
    'BuildSnpModel',
    'BuildDefaultModel',
    '$rootScope',
    'uiUploader',
    'CacheService',
    'DataRetrieval',
    function(vlModel, gfModel, aiModel, snpModel, defModel, $rootScope, uiUploader, Cache, dataRetrieval) {
        function Section(cfg) {
            var self = this;
            self.setUploadingStatus(true);


            self.modelMap = {
                'variable_list':    { func: vlModel, params: { fileUploadEndpoint: cfg.fileUploadEndpoint }},
                'generate_formula': { func: gfModel, params: { fileUploadEndpoint: cfg.fileUploadEndpoint }},
                'age_interval':     { func: aiModel, params: {
                                                            fileUploadEndpoint: cfg.fileUploadEndpoint,
                                                            cols: cfg.columnNames
                                                      }
                                    },
                'snp_information':  { func: snpModel, params: {
                                                            cols: cfg.columnNames,
                                                            sectionDependency: cfg.sectionDependency,
                                                            fileUploadEndpoint: cfg.fileUploadEndpoint,
                                                            saveEndpoint: cfg.saveEndpoint
                                                      }
                                    },
                'default':          { func: defModel, params: {
                                                            templateType: cfg.templateType,
                                                            cols: cfg.columnNames,
                                                            sectionDependency: cfg.sectionDependency ? cfg.sectionDependency : null,
                                                            templateEndpoint: cfg.templateEndpoint ? cfg.templateEndpoint : null,
                                                            fileUploadEndpoint: cfg.fileUploadEndpoint ? cfg.fileUploadEndpoint : null,
                                                            postUploadActions: cfg.postUploadActions ? cfg.postUploadActions : null,
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
            self.isValid = false;
            self.pathToCSV = '';
            self.pathToRData = '';

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
                                var resp = JSON.parse(response);

                                if (resp.message) {
                                    dataRetrieval.errorHandler(resp, 500);
                                } else if (resp.length > 1 || resp.path_to_file) {
                                    
                                    console.log("Full response is: ", resp);
                                    
                                    self.pathToCSV = resp.path_to_csv_file;
                                    self.pathToRData = resp.path_to_file || resp[0].path_to_file;
                                    
                                    if (self.model.parseJsonModel) {
                                        self.model.parseJsonModel(JSON.parse(response));
                                    }

                                    if (self.model.postUploadEndpoint) {
                                        self.model.postUploadActions(JSON.parse(response));
                                    }

                                    if (!self.model.postUploadEndpoint && !self.model.saveEndpoint) {
                                        self.broadcastUploadStatus(true);
                                        self.setUploadingStatus(false);
                                    }
                                } else {
                                    dataRetrieval.errorHandler(resp, 503);
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
            setSectionState: function(cfg) {
                var self = this;
                var params = cfg;
                var sectionData = params.data;
                var uploadPath = 'uploads/rdata/';
                var id = params.id ? params.id : self.id;
                var pathKey = params.pathKey ? params.pathKey : 'path_to_file';

                self.isOpen = !params.isValid;

                function successCb(d) {
                    /* Change location to endpoint to force 'file download' dialog */
                    if (!params.rdataStoreOnly) {
                        window.location = 'http://' + window.location.hostname + '/absoluteRiskRest/downloadFile?filename=' + d;
                    }

                    Cache.setSectionKey(id, pathKey, uploadPath + d);

                    /* In case any RData files need to be updated without re-initializing a section */
                    if (!params.skipBroadcast) {
                        self.broadcastSectionStatus();
                    }
                }

                /* Call data retrieval service to save Rdata file and return saved file to user */
                dataRetrieval.retrieveData({
                    url: self.dataUrl,
                    data: sectionData,
                    success: successCb
                });
            },
            createModel: function(type) {
                /* Use modelMap to create the correct section model based on section type */
                return new this.modelMap[this.type].func(this);
            },
            broadcastSectionStatus: function(runApply) {
                var self = this;

                self.isValid = true;

                $rootScope.$broadcast('sectionStateChanged', { id: this.id, state: 'complete' });

                if (this.id === 'age_interval') {
                    $rootScope.$broadcast('runCalculations');
                }

                if (runApply) {
                    $rootScope.$apply();
                }
            },
            broadcastUploadStatus: function(runApply) {
                var self = this;
                self.isValid = true;
                $rootScope.$broadcast('sectionStateChanged', { id: this.id, state: 'uploaded' });
                if (runApply) {
                    $rootScope.$apply();
                }
            },
            setUploadingStatus: function(status) {
                var self = this;
                self.uploading = status;
                
                $rootScope.$apply();
            }
        };

        return Section;
    }
]);
