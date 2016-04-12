angular.module('Arc', ['ngAnimate', 'ngResource', 'ui.bootstrap', 'ui.uploader', 'ui.select']);

angular.module('Arc')

.controller('TabsController', [function() {
    var self = this;

    self.select = function(index) {
        this.active = new Array(4);
        this.active[index] = true;
    }

    self.select(0);
}])

.controller('SessionController', ['DataService', function(data) {
    this.download = data.downloadSession;
}])

.controller('AccordionController', ['$rootScope', 'DataService', function(root, data) {
    var self = this;

    var buildSteps = [
        {
            id: 'listOfVariables',
            type: 'listOfVariables',
            header: 'List the Variables',
        },
        {
            id: 'modelFormula',
            type: 'modelFormula',
            header: 'Give the Model Formula',
        },
        {
            id: 'riskFactorDistribution',
            header: 'Provide Risk Factor Distribution',
        },
        {
            id: 'logOddsRatios',
            header: 'Provide Log Odds Ratios',
        },
        {
            id: 'diseaseIncidenceRates',
            header: 'Provide Incidence Rates of Disease in Population',
        },
        {
            id: 'mortalityIncidenceRates',
            header: 'Provide Incidence Rates of Competing Mortality',
        },
        {
            id: 'snpInformation',
            type: 'snpInformation',
            header: 'Provide SNP Information',
        }
    ];

    var applySteps = [
        {
            id: 'riskFactorForPrediction',
            header: 'Provide Risk Factor for Prediction',
        },
        {
            id: 'genotypesForPrediction',
            header: 'Provide Genotypes for Prediction',
        },
        {
            id: 'ageInterval',
            type: 'ageInterval',
            header: 'Starting Age and Length of Age Interval',
        }
    ];

    self.steps = [
        {
            id: 'build',
            sections: buildSteps
        },
        {
            id: 'apply',
            sections: applySteps
        }
    ];

    self.log = function() { console.log(data.sections()) }
    self.download = data.downloadSession;
    self.type = 'covariatesAndSNP';

    self.setType = function(type) {
        self.type = type;

        for (var i = 0; i < self.steps.length; i ++)
            for (var j = 0; j < self.steps[i].sections.length; j ++) {
                self.steps[i].sections[j].visible = true;
                self.steps[i].sections[j].optional = false;
                self.steps[i].sections[j].open = false;
            }

        switch (type) {
            case 'covariatesAndSNP':
                self.steps[0].sections[0].open = true;
                self.steps[0].sections[5].optional = true;
                self.steps[0].sections[6].optional = true;
                self.steps[1].sections[1].optional = true;
                break;
            case 'covariatesOnly':
                self.steps[0].sections[0].open = true;
                self.steps[0].sections[5].optional = true;
                self.steps[0].sections[6].visible = false;
                self.steps[1].sections[1].visible = false;
                break;
            case 'snpOnly':
                self.steps[0].sections[4].open = true;
                self.steps[0].sections[0].visible = false;
                self.steps[0].sections[1].visible = false;
                self.steps[0].sections[2].visible = false;
                self.steps[0].sections[3].visible = false;
                self.steps[0].sections[5].optional = true;
                self.steps[1].sections[0].visible = false;
                self.steps[1].sections[1].optional = true;
                break;
        }
    }

    self.refresh = function() {
        for (var i = 0; i < self.steps.length; i ++)
            for (var j = 0; j < self.steps[i].sections.length; j ++) {
                self.steps[i].sections[j].visible = false;
                self.steps[i].sections[j].validated = false;
            }

        setTimeout(function(){self.setType('covariatesAndSNP')}, 0);
    }

    self.setType('covariatesAndSNP');

    self.calculate = function() {
        console.log('running calculation');
        self.calcRunning = true;
        self.resultsImagePath = '';
        self.resultsFilePath = '';
        self.resultsRefFilePath = '';

        var sections = data.sections();
        var parameters = {};

        for (key in sections) {
            parameters[key] = {};
            var valid = true;

            switch(self.type) {
                case 'covariatesAndSNP':
                    if (sections[key].familyHistory)
                        parameters[key].familyHistory = sections[key].familyHistory;
                    break;

                case 'covariatesOnly':
                    valid = (key != 'snpInformation' && key != 'genotypesForPrediction')
                    break;

                case 'snpOnly':
                    valid = (key != 'listOfVariables' && key != 'modelFormula' && key != 'riskFactorDistribution' && key != 'logOddsRatios' && key != 'riskFactorForPrediction')
                    break;
            }

            if (valid) {
                parameters[key].validated = sections[key].validated;
                parameters[key].model = sections[key].model;
            }
        }

        data.calculate(parameters,
            function(results) {
                self.calcRunning = false;
                self.resultsImagePath = results.imagePath;
                self.resultsFilePath = results.filePath;
                self.resultsRefFilePath = results.resultsReferencePath;
            },
            function(error) {
                self.calcRunning = false;
                console.log(error);
            }
        );
    }

    self.calculationDisabled = function() {
        for (var i = 0; i < self.steps.length; i ++)
            for (var j = 0; j < self.steps[i].sections.length; j ++) {
                var section = self.steps[i].sections[j];
                if (section.visible && !section.optional && !section.validated)
                    return true;
            }

        return false;
    }

    self.reset = function() {
        data.initialize();
        self.refresh();
    }

    root.$on('nextSection', function(event, id) {
        for (var i = 0; i < self.steps.length; i ++) {
            for (var j = 0; j < self.steps[i].sections.length; j ++) {
                var section = self.steps[i].sections[j];
                var nextSection = null;

                if (section.id == id) {
                    section.validated = data.getSection(id).validated;

                    if (section.validated) {
                        section.open = false;

                        switch(section.id) {
                            case 'snpInformation':
                                nextSection = self.steps[1].sections[0];
                                if (!nextSection.visible)
                                    nextSection = self.steps[1].sections[1];
                                break;
                            case 'ageInterval':
                                break;
                            default:
                                nextSection = self.steps[i].sections[j + 1];
                        }
                    }
                    if (nextSection)
                        nextSection.open = true;
                }
            }
        }
    });

}])
