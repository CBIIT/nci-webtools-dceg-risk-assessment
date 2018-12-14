'use strict';

app.directive('lcsChart', ['$util', function($util) {
    return {
        restrict: 'AC',
        scope: {
            values: '='
        },
        controller: function($scope) {
            $scope.nRow = 10;
            $scope.nCol = 10;
            $scope.iconWidth = 15;
            $scope.iconHeight = 25;
            $scope.textWidth = 35;
            $scope.textHeight = 15;
            $scope.gap = {
                x: 6,
                y: 6
            };
            $scope.textColor = '#777777';
            $scope.color0 = '#aeb0b5';
            $scope.color1 = '#fdb81e';
            $scope.color2 = '#0071bc';
            $scope.color3 = '#e31c3d';

            $scope.getPosition = function(row, col, x, y, width, height, gap) {
                return {
                    x: x + col * (width + gap.x),
                    y: y + row * (height + gap.y)

                };
            };
            $scope.calculateCanvasWidth = function() {
                return $scope.textWidth + ($scope.iconWidth + $scope.gap.x) * ($scope.nCol + 1) + $scope.gap.x * 2;
            };
            $scope.calculateCanvasHeight = function() {
                return ($scope.iconHeight + $scope.gap.y) * $scope.nRow + $scope.gap.y;
            };

            $scope.drawChart = function() {
                $scope.rows = $util.numToMatrix($scope.values, $scope.nRow, $scope.nCol);
                var savedColor = $scope.ctx.fillStyle;

                for (var i = 0; i < $scope.rows.length; ++i) {
                    var row = $scope.rows[i];
                    var pos = $scope.getPosition(i, 0, $scope.gap.x + $scope.textWidth, $scope.gap.y + ($scope.iconHeight + $scope.textHeight) / 2, $scope.textWidth, $scope.iconHeight, $scope.gap);
                    $scope.ctx.fillStyle = $scope.textColor;
                    $scope.ctx.fillText(i * $scope.nCol + $scope.nCol, pos.x, pos.y);
                    for (var j = 0; j < row.length; ++j) {
                        pos = $scope.getPosition(i, j, $scope.gap.x * 2 + $scope.textWidth, $scope.gap.y, $scope.iconWidth, $scope.iconHeight, $scope.gap);
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
                        if ($scope.drawImage) {
                            $scope.ctx.drawImage($scope.img, pos.x, pos.y, $scope.iconWidth, $scope.iconHeight);
                        }
                    }
                }
                $scope.ctx.fillStyle = savedColor;
            };
        },
        link: function($scope, element, attrs) {
            if (attrs.drawImage) {
                $scope.drawImage = attrs.drawImage;
            }
            if (attrs.nRow) {
                $scope.nRow = parseInt(attrs.nRow);
            }
            if (attrs.nCol) {
                $scope.nCol = parseInt(attrs.nCol);
            }
            if (attrs.iconWidth) {
                $scope.iconWidth = parseInt(attrs.iconWidth);
            }
            if (attrs.iconHeight) {
                $scope.iconHeight = parseInt(attrs.iconHeight);
            }
            if (attrs.gapX) {
                $scope.gap.x = parseInt(attrs.gapX);
            }
            if (attrs.gapY) {
                $scope.gap.y = parseInt(attrs.gapY);
            }

            if (element[0].getContext) {
                element[0].width = $scope.calculateCanvasWidth();
                element[0].height = $scope.calculateCanvasHeight();
                $scope.ctx = element[0].getContext('2d');
                $scope.ctx.textAlign = 'right';
                $scope.ctx.font = 'bold ' + $scope.textHeight + 'px sans-serif';
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
