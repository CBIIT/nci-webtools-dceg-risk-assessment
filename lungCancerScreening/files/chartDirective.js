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