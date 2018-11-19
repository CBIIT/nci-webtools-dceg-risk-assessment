'use strict';

app.directive('lcsChart', function() {
    return {
        scope: {
            chartType : '=',
            rows: '=value'
        },
        restrict: 'E',
        templateUrl: '_chart.html'
    }
});