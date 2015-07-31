/* A calculator tool with an accordion form UI */
var app = angular.module('Arc', ['ui.bootstrap']);

/* Section model services */
app.factory('BuildVariableListModel', ['BuildVariable', function(Variable) {
    function VariableListModel() {
        var self = this;

        self.inputMethod = 'manual';
        self.variableList = [];

        /* Add more custom model functionality later */

        /* Add a single variable to the list as default list state */
        self.addVariable();
    }
    VariableListModel.prototype = {
        addVariable: function() {
            this.variableList.push(new Variable());
        },
        deleteVariable: function(index) {
            if (this.variableList.length > 1) {
                this.variableList.splice(index, 1);
            }
        },
        saveModel: function() {
            return;
        },
        getJsonModel: function() {
            console.log('this is variable list model');
        }
    };

    return VariableListModel;
}]);

app.factory('BuildGenFormulaModel', function() {
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

    return GenFormulaModel;
});

app.factory('BuildAgeIntervalModel', function() {
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

    return AgeIntervalModel;
});

app.factory('BuildDefaultModel', function() {
    function DefaultModel() {
        this.genTemplate = true;

        /* Add more custom model functionality later */
    }
    DefaultModel.prototype = {
        getJsonModel: function() {
            console.log('this is default model');
        }
    };

    return DefaultModel;
});

app.factory('BuildVariable', function() {
    function Variable() {
        var self = this;
        /* Check for passed in JSON cfg at later time */

        self.name = '';
        self.type = 'continuous';
        self.levels = '';
        self.ref = '';
    }
    Variable.prototype = {
        convertLevelsToArray: function() {
            console.log('return converted levels as []');
        },
        getFirstEntryInLevels: function() {
            console.log('returned first entry in levels');
        },
        getJsonModel: function() {
            var self = this;

            return {
                name: self.name,
                type: self.type,
                levels: self.convertLevelsToArray(),
                ref: self.ref ? self.ref : self.getFirstEntryInLevels()
            };
        }
    };

    return Variable;
});

/* Primary application controller */
app.controller('ArcAccordion', ['BuildSection', function (Section, $scope) {
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

    /* Create accordion form data with appropriate configuration */
    for (var i = 0; i < buildConfig.length; i++) {
        self.buildStep.push(new Section(buildConfig[i]));
    }

    for (var j = 0; j < applyConfig.length; j++) {
        self.applyStep.push(new Section(applyConfig[j]));
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
