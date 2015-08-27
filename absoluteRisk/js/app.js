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
app.controller('ArcAccordion', ['BuildSection', 'CacheService','$rootScope', '$scope', '$sanitize', '$modal', function (Section, Cache, $rootScope, $scope, $san, $modal) {
    var self = this;
    var buildConfig = [
        {
            header: 'List the Variables',
            type: 'variable_list',
            fileUploadEndpoint: 'rdataFileUpload'
        },
        {
            header: 'Give the Model Formula',
            type: 'generate_formula',
            fileUploadEndpoint: 'rdataFileUpload'
        },
        {
            id: 'risk_factor_distribution',
            header: 'Provide Risk Factor Distribution',
            templateType: 'static',
            fileUploadEndpoint: 'rdataFileUpload',
            sectionReference: 'generate_formula'
        },
        {
            id: 'log_odds_ratios',
            header: 'Provide Log Odds Ratios',
            templateType: 'remote',
            templateEndpoint: 'logOddsRatios',
            fileUploadEndpoint: 'csvFileUpload',
            columnNames: ['Variables', 'Log Odds Ratios']
        },
        {
            id: 'disease_incidence_rates',
            header: 'Provide Incidence Rates of Disease in Population',
            templateType: 'staticDual',
            fileUploadEndpoint: 'csvFileUpload',
            postUploadEndpoint: 'diseaseRates',
            columnNames: [
                ['Age (Integer)', 'Rate'],
                ['Starting Age (Integer)', 'Ending Age (Integer)', 'Rate']
            ]
        },
        {
            id: 'mortality_incidence_rates',
            header: 'Provide Incidence Rates of Competing Mortality',
            templateType: 'staticDual',
            fileUploadEndpoint: 'csvFileUpload',
            postUploadEndpoint: 'competingRates',
            columnNames: [
                ['Age (Integer)', 'Rate'],
                ['Starting Number', 'Ending Number', 'Rate']
            ],
            optional: true
        },
        {
            id: 'snp_information',
            header: 'Provide SNP Information',
            templateType: 'static',
            fileUploadEndpoint: 'csvFileUpload',
            postUploadEndpoint: 'snpInformation',
            columnNames: ['snp.name', 'snp.odds.ratio', 'snp.freq'],
            optional: true
        }
    ];
    var applyConfig = [
        {
            id: 'risk_factor_prediction',
            header: 'Provide Risk Factor for Prediction',
            templateType: 'static',
            sectionReference: 'generate_formula',
            optional: true
        },
        {
            id: 'genotypes_prediction',
            header: 'Provide Genotypes for Prediction',
            templateType: 'static',
            sectionReference: 'snp_information',
            optional: true
        },
        {
            header: 'Starting Age and Length of Age Interval',
            type: 'age_interval'
        }
    ];
    var modalInstance;

    self.steps = [];
    self.buildStep = [];
    self.applyStep = [];
    self.ind = 0;

    self.formula = '';
    self.templateData = '';

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
            var id = args.id;
            var state = args.state;
            var section;

            if (state === 'complete') {
                /* Means section has been validated and completed */
                switch(id) {
                    case('variable_list'):
                        section = self.steps[0].sections[1];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    case('generate_formula'):
                        section = self.steps[0].sections[2];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    case('risk_factor_distribution'):
                        section = self.steps[0].sections[3];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    case('log_odds_ratios'):
                        section = self.steps[0].sections[4];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    case('disease_incidence_rates'):
                        section = self.steps[0].sections[5];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    case('mortality_incidence_rates'):
                        section = self.steps[0].sections[6];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    case('snp_information'):
                        section = self.steps[0].sections[7];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    default:
                        console.log('in switch default');
                        break;
                }
            } else {
                /* Means state === 'edit' */
            }

            section.init();
        });

        $scope.$on('modalContent', function(event, args) {
            var type = args.type;

            if (type === 'formula') {
                self.formula = args.content;

                modalInstance = $modal.open({
                    templateUrl: 'templates/displayFormula.html',
                    controller: 'ModalController as modalCtrl',
                    resolve: {
                      data: function () {
                        return {
                            type: args.type,
                            content: args.content,
                            heading: 'Formula'
                        };
                      }
                    }
                });

            } else {
                console.log('its a table template');
            }
        });
    };

    self.init();
}]);
