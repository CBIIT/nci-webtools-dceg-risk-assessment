var app = angular.module('Arc', ['ui.bootstrap']);

app.factory('BuildSection', function() {
    function createSection(cfg) {
        function Section() {
            var self = this;

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
                switch(type) {
                    case('variable_list'):
                        return new VariableListModel();
                    case('generate_formula'):
                        return new GenFormulaModel();
                    case('age_interval'):
                        return new AgeIntervalModel();
                    default:
                        return new DefaultModel();
                }
            },
            getJsonModel: function() {
                return this.model.getJsonModel();
            }
        };

        /***** Section Model Types *****/
        /* Maybe these should be individual services */

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

        function DefaultModel() {
            this.genTemplate = true;

            /* Add more custom model functionality later */
        }
        DefaultModel.prototype = {
            getJsonModel: function() {
                console.log('this is default model');
            }
        };

        return new Section();
    }

    return {
        createSection: createSection
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
