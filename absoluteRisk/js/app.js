/* A calculator tool with an accordion form UI */
var app = angular.module('Arc', ['ui.bootstrap', 'ui.select', 'ngSanitize', 'ui.uploader', 'ngAnimate']);

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
app.controller('ArcAccordion', ['BuildSection', 'CacheService','$rootScope', '$scope', '$sanitize', '$modal', '$http', function (Section, Cache, $rootScope, $scope, $san, $modal, $http) {
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
            fileUploadEndpoint: 'csvFileUploadConversion',
            sectionDependency: {
                id: 'generate_formula',
                mapping: 'rowToColumn'
            }
        },
        {
            id: 'log_odds_ratios',
            header: 'Provide Log Odds Ratios',
            templateType: 'remote',
            templateEndpoint: 'logOddsRatios',
            fileUploadEndpoint: 'csvFileUploadConversion',
            columnNames: ['Variables', 'Log Odds Ratios']
        },
        {
            id: 'disease_incidence_rates',
            header: 'Provide Incidence Rates of Disease in Population',
            templateType: 'staticDual',
            fileUploadEndpoint: 'csvFileUploadDiseaseRates',
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
            postUploadEndpoint: 'mortalityRates',
            postUploadActions: function(pathObj) {
                var self = this;

                var postUploadUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/' + self.postUploadEndpoint;
                var postUploadData = {
                    csvFilePath: pathObj['path_to_file'],
                    rdataFilePath: Cache.getSectionKey(self.sectionDependency.id, 'path_to_file')
                };

                /* Passes in path to section CSV file, and path to referred section's RData file */
                $http.post(postUploadUrl, JSON.stringify(postUploadData))
                   .success(function(data, status, headers, config) {
                       /* Store RData file path in global JSON object and open next section */
                       self.parseJsonModel(data);
                       self.section.broadcastSectionStatus();
                   })
                   .error(function(data, status, headers, config) {
                       console.log('status is: ', status);
                   })
                   .finally(function(data) {
                       console.log('finally, data is: ', data);
                   });
            },
            sectionDependency:  {
                id: 'disease_incidence_rates',
                mapping: 'rdataFilePath'
            },
            columnNames: [
                ['Age (Integer)', 'Rate'],
                ['Starting Number', 'Ending Number', 'Rate']
            ],
            optional: true
        },
        {
            id: 'snp_information',
            header: 'Provide SNP Information',
            type: 'snp_information',
            fileUploadEndpoint: 'csvFileUpload',
            postUploadEndpoint: 'snpInformation',
            postUploadActions: function(pathObj) {
                var self = this;

                var postUploadUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/' + self.postUploadEndpoint;
                var postUploadData = {
                    csvFilePath: pathObj['path_to_file'],
                    famHist: self.famHist
                };

                /* Passes in path to section CSV file, and path to referred section's RData file */
                $http.post(postUploadUrl, JSON.stringify(postUploadData))
                   .success(function(data, status, headers, config) {
                       /* Remove first row name because it's actually the first column header */
                       data.rows.shift();

                       /* Store RData file path in global JSON object and open next section */
                       self.parseJsonModel(data);
                   })
                   .error(function(data, status, headers, config) {
                       console.log('status is: ', status);
                   })
                   .finally(function(data) {
                       console.log('finally, data is: ', data);
                   });
            },
            sectionDependency:  {
                id: 'generate_formula',
            },
            columnNames: ['snp.name', 'snp.odds.ratio', 'snp.freq'],
            optional: true
        }
    ];
    var applyConfig = [
        {
            id: 'risk_factor_prediction',
            header: 'Provide Risk Factor for Prediction',
            templateType: 'static',
            sectionDependency:  {
                id: 'generate_formula',
                mapping: 'rowToColumn'
            },
            fileUploadEndpoint: 'csvFileUploadConversion',
            optional: true
        },
        {
            id: 'genotypes_prediction',
            header: 'Provide Genotypes for Prediction',
            templateType: 'static',
            sectionDependency:  {
                id: 'snp_information',
                mapping: 'rowToColumn'
            },
            fileUploadEndpoint: 'csvFileUploadConversion',
            optional: true
        },
        {
            header: 'Starting Age and Length of Age Interval',
            type: 'age_interval',
            columnNames: ['Age', 'Age Interval'],
            fileUploadEndpoint: 'csvFileUploadConversion',
        }
    ];
    var modalInstance;

    self.steps = [];
    self.buildStep = [];
    self.applyStep = [];
    self.ind = 0;

    self.formula = '';

    /* Results Data */
    self.resultsImage = '';
    self.resultsFilePath = 'http://' + window.location.hostname + '/absoluteRiskRest/';
    self.resultsRefFilePath = 'http://' + window.location.hostname + '/absoluteRiskRest/';

    /* Dummy Result Boolean For Demo Only */
    self.showData = false;

    /* Create accordion form data with appropriate configuration */
    for (var i = 0; i < buildConfig.length; i++) {
        self.buildStep.push(new Section(buildConfig[i]));
    }

    for (var j = 0; j < applyConfig.length; j++) {
        self.applyStep.push(new Section(applyConfig[j]));
    }

    self.steps.push(
        {
            id: 'build',
            title: 'Build the Model',
            sections: self.buildStep
        },
        {
            id: 'apply',
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
        self.steps[0].sections[0].init();

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
                        /* Close last section of first accordion */
                        self.steps[0].sections[6].isOpen = false;

                        section = self.steps[1].sections[0];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    case('risk_factor_prediction'):
                        section = self.steps[1].sections[1];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    case('genotypes_prediction'):
                        section = self.steps[1].sections[2];
                        section.isDisabled = false;
                        section.isOpen = true;
                        break;
                    case('age_interval'):
                        console.log('final section completed');
                        break;
                    default:
                        console.log('in switch default');
                        break;
                }
            } else {
                /* Means state === 'edit' */
            }

            if (section) {
                section.init();
            } else {
                console.log('data must be complete since no more sections left');
            }

            Cache.getData();
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

    self.calculateData = function() {
        var accordionData = Cache.createFilePathsObject();
        var calculateDataUrl = 'http://' + window.location.hostname + '/absoluteRiskRest/calculate';

        console.log('accordion data is: ', accordionData);

        self.showData = true;

/*
        $http.post(calculateDataUrl, JSON.stringify(accordionData))
           .success(function(data, status, headers, config) {
               console.log('calculated data is:', data);
           })
           .error(function(data, status, headers, config) {
               console.log('status is: ', status);
           })
           .finally(function(data) {
               console.log('finally, data is: ', data);
           });
*/
    };

    self.init();
}]);
