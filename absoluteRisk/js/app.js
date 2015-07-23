var app = angular.module('Arc', ['ui.bootstrap']);

app.controller('ArcAccordion', function ($scope) {
    var self = this;

    self.steps = [
        {
            title: 'Build the Model',
            sections: [
                {
                    header: 'List the Variables',
                    required: true
                },
                {
                    header: 'Give the Model Formula',
                    required: true
                },
                {
                    header: 'Provide Risk Factor Distribution',
                    required: true
                },
                {
                    header: 'Provide Log Odds Ratios',
                    required: true
                },
                {
                    header: 'Provide Incidence Rates of Disease in Population',
                    required: true
                },
                {
                    header: 'Provide Incidence Rates of Competing Mortality'
                },
                {
                    header: 'Provide SNP Information'
                }
            ]
        },
        {
            title: 'Apply the Model',
            sections: [
                {
                    header: 'Starting Age and Length of Age Interval',
                    required: true
                },
                {
                    header: 'Provide Risk Factor for Prediction',
                    required: true
                },
                {
                    header: 'Provide Genotypes for Prediction'
                }
            ]
        }
    ];

    self.oneAtATime = true;
    self.status = {
        isFirstOpen: true,
        isFirstDisabled: false
    };

    /* Prototype Only Properties */
    self.prototypeShow = false;
    self.prototypeToggle = function(toggle) {
        self.prototypeShow = toggle;
    };

    self.prototypeFileSection = 'export';
    self.prototypeAgeSection = 'manual';
});
