var app = angular.module('Arc', ['ui.bootstrap']);

app.factory('BuildSection', [
    'BuildVariableListModel',
    'BuildGenFormulaModel',
    'BuildAgeIntervalModel',
    'BuildDefaultModel',
    function(buildVl, buildGf, buildAi, buildDef) {
        function createSection(cfg) {
            function Section() {
                var self = this;

                self.modelMap = {
                    'variable_list':    buildVl.create,
                    'generate_formula': buildGf.create,
                    'age_interval':     buildAi.create,
                    'default':          buildDef.create
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
            }

            Section.prototype = {
                createModel: function(type) {
                    return this.modelMap[type]();
                },
                getJsonModel: function() {
                    return this.model.getJsonModel();
                }
            };

            return new Section();
        }

        return {
            createSection: createSection
        };
    }
]);

app.factory('BuildVariableListModel', function() {
    function create() {
        function VariableListModel() {
            var self = this;

            self.inputMethod = 'manual';

            /* Add more custom model functionality later */
        }
        VariableListModel.prototype = {
            getJsonModel: function() {
                console.log('this is variable list model');
            }
        };

        return new VariableListModel();
    }

    return {
        create: create
    };
});

app.factory('BuildGenFormulaModel', function() {
    function create() {
        function GenFormulaModel() {
            var self = this;

            self.status = 'edit';
            self.toggleStatus = function(status) {
                self.status = status;
            };

            /* Add more custom model functionality later */
        }
        GenFormulaModel.prototype = {
            getJsonModel: function() {
                console.log('this is generate formula model');
            }
        };

        return new GenFormulaModel();
    }

    return {
        create: create
    };
});

app.factory('BuildAgeIntervalModel', function() {
    function create() {
        function AgeIntervalModel() {
            var self = this;

            self.inputMethod = 'manual';

            /* Add more custom model functionality later */
        }
        AgeIntervalModel.prototype = {
            getJsonModel: function() {
                console.log('this is age interval model');
            }
        };

        return new AgeIntervalModel();
    }

    return {
        create: create
    };
});

app.factory('BuildDefaultModel', function() {
    function create() {
        function DefaultModel() {
            this.genTemplate = true;

            /* Add more custom model functionality later */
        }
        DefaultModel.prototype = {
            getJsonModel: function() {
                console.log('this is default model');
            }
        };

        return new DefaultModel();
    }

    return {
        create: create
    };
});

app.controller('ArcAccordion', ['BuildSection', function (buildSection, $scope) {
    var self = this;

    var buildConfig = [
        {
            header: 'List the Variables',
            type: 'variable_list'
        },
        {
            header: 'Give the Model Formula',
            type: 'generate_formula'
        },
        {
            header: 'Provide Risk Factor Distribution'
        },
        {
            header: 'Provide Log Odds Ratios'
        },
        {
            header: 'Provide Incidence Rates of Disease in Population'
        },
        {
            header: 'Provide Incidence Rates of Competing Mortality',
            optional: true
        },
        {
            header: 'Provide SNP Information',
            optional: true
        }
    ];

    var applyConfig = [
        {
            header: 'Starting Age and Length of Age Interval',
            type: 'age_interval'
        },
        {
            header: 'Provide Risk Factor for Prediction',
            optional: true
        },
        {
            header: 'Provide Genotypes for Prediction',
            optional: true
        }
    ];

    /* Accordion settings */
    self.oneAtATime = true;
    self.status = {
        isFirstOpen: true,
        isFirstDisabled: false
    };

    self.steps = [];
    self.buildStep = [];
    self.applyStep = [];

    for (var i = 0; i < buildConfig.length; i++) {
        self.buildStep.push(buildSection.createSection(buildConfig[i]));
    }

    for (var j = 0; j < applyConfig.length; j++) {
        self.applyStep.push(buildSection.createSection(applyConfig[j]));
    }

    self.steps.push(
        {
            title: 'Build the Model',
            sections: self.buildStep
        },
        {
            title: 'Apply the Model',
            sections: self.applyStep
        }
    );
}]);
