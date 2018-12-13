'use strict';

app.directive('lcsChart', ['$util', function($util) {
    return {
        scope: {
            values: '='
        },
        controller: function($scope) {
            $scope.iconWidth = 15;
            $scope.rows = $util.numToMatrix($scope.values.map(function(val) {
                    return val / 10;
                }));
        },
        restrict: 'E',
        templateUrl: '_chart.html'
    }
}]);

app.directive('bathroomChart', ['$util', function($util) {
    return {
        scope: {
            values: '='
        },
        controller: function($scope) {
            $scope.iconWidth = 15;
            $scope.rows = $util.numToMatrix($scope.values.map(function(val) {
                return val / 10;
            }));
        },
        restrict: 'E',
        templateUrl: '_bathroomChart.html'
    }
}]);

app.directive('lcsChart2', ['$util', function($util) {
    return {
        scope: {
            values: '='
        },
        controller: function($scope) {
            $scope.iconWidth = 12;
            $scope.rows = $util.numToMatrix($scope.values, 25, 40);
        },
        restrict: 'E',
        templateUrl: '_chart2.html'
    }
}]);
