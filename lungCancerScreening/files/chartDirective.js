'use strict';

app.directive('lcsChart', function() {
    return {
        scope: {
            chartType : '=',
            rows: '=value'
        },
        controller: function($scope) {
            $scope.iconWidth = $scope.$parent.chartIconWidth;
        },
        restrict: 'E',
        templateUrl: '_chart.html'
    }
});