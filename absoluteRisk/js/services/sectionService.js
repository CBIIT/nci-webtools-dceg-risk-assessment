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
    function(vlModel, gfModel, aiModel, defModel, $rootScope, uiUploader) {
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

            self.file = null;
            self.id = cfg.id ? cfg.id : self.type;
            self.fileId = self.id + '_file';
            self.fileUrl = url = 'http://' + window.location.hostname + '/absoluteRiskRest/fileUpload';

            $rootScope.$on('fileAdded', function(e, data) {
                if (data.id === self.fileId) {
                    self.file = data.file;
                    console.log(self.file);

                    uiUploader.addFiles(self.file);

/*
                    uiUploader.startUpload({
                        url: self.fileUrl,
                        concurrency: 2,
                        onProgress: function(file) {
                            // file contains a File object
                            console.log(file);
                        },
                        onCompleted: function(file, response) {
                            // file contains a File object
                            console.log(file);
                            // response contains the server response
                            console.log(response);
                        },
                        onCompletedAll: function(files) {
                            // files is an array of File objects
                            console.log(files);
                        }
                    });
*/
                }
            });
        }

        Section.prototype = {
            init: function() {
                if (this.model.init) {
                    this.model.init();
                }
            },
            setSectionState: function(bool) {
                this.isOpen = !bool;

                $rootScope.$broadcast('sectionStateChanged', { type: this.type, state: 'complete' });
            },
            resetFile: function() {
                /* Reset form to reset file input */
                var sectionForm = document.getElementById(this.id);
                sectionForm.reset();

                this.file = null;
            },
            createModel: function(type) {
                /* Use modelMap to create the correct section model based on section type */
                return new this.modelMap[type](this);
            },
            getJsonModel: function() {
                return this.model.getJsonModel();
            }
        };

        return Section;
    }
]);
