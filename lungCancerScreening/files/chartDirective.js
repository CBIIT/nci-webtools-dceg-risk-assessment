'use strict';

app.directive('lcsChart', function() {
    return {
        scope: {
            chartType : '=',
            rows: '=value'
        },
        controller: function($scope) {
            $scope.iconWidth = 15;
        },
        restrict: 'E',
        templateUrl: '_chart.html'
    }
});

app.directive('lcsChart2', function() {
    return {
        scope: {
            chartType : '=',
            rows: '=value'
        },
        controller: function($scope) {
            $scope.iconWidth = 9;
        },
        restrict: 'E',
        templateUrl: '_chart2.html'
    }
});
