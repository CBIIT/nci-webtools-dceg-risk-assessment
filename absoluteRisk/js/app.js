/* A calculator tool with an accordion form UI */
var app = angular.module('Arc', ['ui.bootstrap', 'ui.select', 'ngSanitize', 'ui.uploader']);

app.filter('verifyTerms', function() {
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
});

app.directive('arcFileChange', ['$rootScope', function($rootScope) {
    function link($scope, elem, attributes) {
        var fileInputElem = elem[0];

        fileInputElem.addEventListener('change', function(e) {
            var file = e.target.files[0];
            var id = e.target.id;

            $rootScope.$broadcast('fileAdded', {id: id, file: file });
            $scope.$apply();
        });
    }

    return {
      restrict: 'AE',
      replace: 'true',
      scope: {},
      link: link
    };
}]);

/* Primary application controller */
app.controller('ArcAccordion', ['BuildSection', 'CacheService','$rootScope', '$scope', '$sanitize', function (Section, Cache, $rootScope, $scope, $san) {
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
            id: 'risk_factor_distribution',
            header: 'Provide Risk Factor Distribution'
        },
        {
            id: 'log_odds_ratios',
            header: 'Provide Log Odds Ratios'
        },
        {
            id: 'disease_incidence_rates',
            header: 'Provide Incidence Rates of Disease in Population'
        },
        {
            id: 'mortality_incidence_rates',
            header: 'Provide Incidence Rates of Competing Mortality',
            optional: true
        },
        {
            id: 'snp_information',
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
            id: 'risk_factor_prediction',
            header: 'Provide Risk Factor for Prediction',
            optional: true
        },
        {
            id: 'genotypes_prediction',
            header: 'Provide Genotypes for Prediction',
            optional: true
        }
    ];

    self.steps = [];
    self.buildStep = [];
    self.applyStep = [];
    self.ind = 0;

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

    self.trustAsHtml = function(value) {
      return $san(value);
    };

    self.init = function() {
        self.steps[0].sections[0].isDisabled = false;
        self.steps[0].sections[0].isOpen = true;

        $scope.$on('sectionStateChanged', function(event, args) {
            var type = args.type;
            var state = args.state;
            var section;

            if (state === 'complete') {
                // Means section has been validated and completed
                switch(type) {
                    case('variable_list'):
                        section = self.steps[0].sections[1];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    default:
                        console.log('close penultimate section');
                        break;
                }
            } else {
                // Means state === 'edit'
            }

            section.init();
        });

        /* Initialize first section of application */
        self.steps[0].sections[0].init();
    };

    self.init();
}]);
