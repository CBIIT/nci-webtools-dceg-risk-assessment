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
    function(vlModel, gfModel, aiModel, defModel, $rootScope) {
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
        }

        Section.prototype = {
            init: function() {
                this.model.init();
            },
            setSectionState: function(bool) {
                this.isOpen = !bool;

                $rootScope.$broadcast('sectionStateChanged', { type: this.type, state: 'complete' });
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
