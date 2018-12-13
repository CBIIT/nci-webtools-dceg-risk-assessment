'use strict';

app.directive('lcsChart', ['$util', function($util) {
    return {
        restrict: 'E',
        scope: {
            values: '='
        },
        templateUrl: '_chart.html',
        controller: function($scope) {
            $scope.iconWidth = 15;
            $scope.rows = $util.numToMatrix($scope.values.map(function(val) {
                    return val / 10;
                }));
        }
    }
}]);

app.directive('bathroomChart', ['$util', function($util) {
    return {
        restrict: 'E',
        scope: {
            values: '='
        },
        templateUrl: '_bathroomChart.html',
        controller: function($scope) {
            $scope.iconWidth = 15;
            $scope.rows = $util.numToMatrix($scope.values.map(function(val) {
                return val / 10;
            }));
        }
    }
}]);


app.directive('lcsChart2', ['$util', function($util) {
    return {
        restrict: 'AC',
        scope: {
            values: '='
        },
        templateUrl: '_chart2.html',
        controller: function($scope) {
            $scope.nRow = 25;
            $scope.nCol = 40;
            $scope.iconWidth = 12;
            $scope.iconHeight = 30;
            $scope.gap = {
                x: 2,
                y: 2
            };
            $scope.color0 = '#aeb0b5';
            $scope.color1 = '#fdb81e';
            $scope.color2 = '#0071bc';
            $scope.color3 = '#e31c3d';
            $scope.rows = $util.numToMatrix($scope.values, $scope.nRow, $scope.nCol);

            $scope.getPosition = function(row, col, x, y, width, height, gap) {
                return {
                    x: x + col * (width + gap.x),
                    y: y + row * (height + gap.y)

                };
            };
            $scope.calculateCanvasWidth = function() {
                return ($scope.iconWidth + $scope.gap.x) * $scope.nCol + $scope.gap.x;
            };
            $scope.calculateCanvasHeight = function() {
                return ($scope.iconHeight + $scope.gap.y) * $scope.nRow + $scope.gap.y;
            };

            $scope.drawChart = function() {
                var savedColor = $scope.ctx.fillStyle;

                for (var i = 0; i < $scope.rows.length; ++i) {
                    var row = $scope.rows[i];
                    for (var j = 0; j < row.length; ++j) {
                        var pos = $scope.getPosition(i, j, $scope.gap.x, $scope.gap.y, $scope.iconWidth, $scope.iconHeight, $scope.gap);
                        $scope.ctx.fillStyle = $scope.color0;
                        $scope.ctx.fillRect(pos.x, pos.y, $scope.iconWidth, $scope.iconHeight);
                        if (row[j].val1 > 0) {
                            $scope.ctx.fillStyle = $scope.color1;
                            $scope.ctx.fillRect(pos.x, pos.y, $scope.iconWidth * row[j].val1 / 10, $scope.iconHeight);
                        }
                        if (row[j].val2 > 0) {
                            $scope.ctx.fillStyle = $scope.color2;
                            $scope.ctx.fillRect(pos.x, pos.y, $scope.iconWidth * row[j].val2 / 10, $scope.iconHeight);
                        }
                        if (row[j].val3 > 0) {
                            $scope.ctx.fillStyle = $scope.color3;
                            $scope.ctx.fillRect(pos.x, pos.y, $scope.iconWidth * row[j].val3 / 10, $scope.iconHeight);
                        }
                        $scope.ctx.drawImage($scope.img, pos.x, pos.y, $scope.iconWidth, $scope.iconHeight);
                    }
                }
                $scope.ctx.fillStyle = savedColor;
            };
        },
        link: function($scope, element, attrs) {
            if (element[0].getContext) {
                element[0].width = $scope.calculateCanvasWidth();
                element[0].height = $scope.calculateCanvasHeight();
                $scope.ctx = element[0].getContext('2d');
                var img = new Image();
                img.onload = function() {
                    $scope.img = img;
                    $scope.drawChart();
                };
                img.src = 'files/images/people.png';
            } else {
                // Canvas not supported
                console.log('Canvas not supported in current browser!');
            }
        },
    }
}]);
