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

app.directive('bathroomChart', function() {
    return {
        scope: {
            rows: '=value'
        },
        controller: function($scope) {
            $scope.iconWidth = 15;
        },
        restrict: 'E',
        templateUrl: '_bathroomChart.html'
    }
});

app.directive('lcsChart2', function() {
    return {
        scope: {
            chartType : '=',
            rows: '=value'
        },
        controller: function($scope) {
            $scope.iconWidth = 12;
        },
        restrict: 'E',
        templateUrl: '_chart2.html'
    }
});

app.directive('lcsChart4', function() {
    return {
        restrict: 'CA',
        scope: {
            data : '=chartData'
        },
        link: function(scope, element, attrs) {
            var ctx = element[0].getContext('2d');
            var myChart = new Chart(ctx, {
                type: 'horizontalBar',
                data: scope.data,
                options: {
                    scales: {
                        xAxes: [{
                            ticks: {
                                beginAtZero: true,
                                maxTicksLimit: 20,
                                min: 0,
                                max: 100,
                                stepSize: 10
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                fontStyle: 'bold'
                            }
                        }]
                    },
                    legend: {
                        display: false
                    },
                    responsive: false
                }
            });
        },
    }
});
