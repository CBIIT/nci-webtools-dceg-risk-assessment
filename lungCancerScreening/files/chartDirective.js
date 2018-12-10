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

app.directive('lcsChart3', function() {
    return {
        restrict: 'EC',
        scope: {
            data : '=chartData'
        },
        link: function(scope, element, attrs) {
            var ctx = element[0].getContext('2d');
            var myChart = new Chart(ctx, {
                type: 'pie',
                data: scope.data,
                options: {
                    responsive: false,
                    legend: {
                        labels: {
                            fontStyle: 'bold'
                        }
                    }
                }
            });
        },
    }
});
