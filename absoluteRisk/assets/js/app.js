angular.module('Arc', ['ngAnimate', 'ngResource', 'ui.bootstrap', 'ui.uploader']);

angular.module('Arc')

.filter('verifyTerms', function() {
    return function(input, terms, varList) {
        var verifiedTerms = [];

        angular.forEach(varList, function(v) {
            angular.forEach(terms, function(term) {
                if (v.name === term.name && v.linear) {
                    verifiedTerms.push(v);
                }
            });
        });

        return verifiedTerms;
    };
})

.directive('uploadfile', ['DataService', 'ValidationService', function(data, validation) {
    function link($scope, elem, attributes) {
        var fileInputElem = elem[0];

        fileInputElem.addEventListener('change', function(e) {
            var id = e.target.id;
            var file = e.target.files[0];
            data.uploadFile($scope, id, file);

            if (id != 'sessionUpload')
                validation.readFile(id, file);
        });
    }

    return {
      restrict: 'AE',
      replace: 'true',
      scope: {},
      link: link
    };
}])

.controller('TabsController', [function() {
    var self = this;

    self.select = function(index) {
        this.active = new Array(4);
        this.active[index] = true;
    }

    self.select(0);
}])

.controller('SessionController', ['DataService', function(data) {
    var self = this;
    this.download = data.downloadSession;
}])

.controller('AccordionController', ['$rootScope', 'DataService', 'ValidationService', '$scope', function(root, data, validation, scope) {
    var self = this;

    var buildSteps = [
        {
            id: 'listOfVariables',
            type: 'listOfVariables',
            header: 'List the Variables',
            isOpen: true
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
            optional: true
        },
        {
            id: 'snpInformation',
            type: 'snpInformation',
            header: 'Provide SNP Information',
            optional: true
        }
    ];

    var applySteps = [
        {
            id: 'riskFactorForPrediction',
            header: 'Provide Risk Factor for Prediction',
            optional: true
        },
        {
            id: 'genotypesForPrediction',
            header: 'Provide Genotypes for Prediction',
            optional: true
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
    self.calcRunning = false;
    self.calculate = data.calculate;

    self.log = function() {
        console.log('Section Data',  data.sections());
        validation.log();
    }


    root.$on('validateBuildSection', function(event, status) {
        for (var i = 0; i < self.steps[0].sections.length; i ++) {
            var section = self.steps[0].sections[i];
            section.isOpen = false;
            section.validated = true;
        }

        scope.$apply();
    });

    root.$on('nextSection', function(event, sectionID) {
        for (var i = 0; i < self.steps.length; i ++) {
            for (var j = 0; j < self.steps[i].sections.length; j ++) {
                var section = self.steps[i].sections[j];
                var nextSection = null;

                if (section.id == sectionID) {
                    section.isOpen = false;
                    section.validated = true;

                    switch(section.id) {
                        case 'ageInterval':
                            break;
                        case 'snpInformation':
                            nextSection = self.steps[1].sections[0];
                            break;
                        default:
                            nextSection = self.steps[i].sections[j + 1];
                    }

                    if (nextSection)
                        nextSection.isOpen = true;
                }
            }
        }
    });

    root.$on('calculationRunning', function(event, isRunning) {
        self.calcRunning = isRunning;
    });

    root.$on('displayResults', function(event, results) {
        self.resultsImagePath   = results.imagePath;
        self.resultsFilePath    = results.resultsPath;
        self.resultsRefFilePath = results.resultsReferencePath;
    });


}]);
