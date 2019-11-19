'use strict';

app.directive('lcsChart', ['$util', function($util) {
    return {
        restrict: 'AC',
        scope: {
            values: '='
        },
        controller: function($scope) {
            $scope.minHeight = 200;
            $scope.minWidth = 200;
            $scope.nRow = 10;
            $scope.nCol = 10;
            $scope.resolution = 100;
            $scope.nRowSmall = 13;
            $scope.nColSmall = 100;
            $scope.iconWidth = 15;
            $scope.iconHeight = 25;
            $scope.smallIconWidth = 4;
            $scope.smallIconHeight = 12;
            $scope.textWidth = 30;
            $scope.textHeight = 15;
            $scope.gap = {
                x: 6,
                y: 6
            };
            $scope.sectionGap = 8;
            $scope.textColor = '#777777';
            $scope.color0 = '#aeb0b5';
            $scope.color1 = '#fdb81e';
            $scope.color2 = '#0071bc';
            $scope.color3 = '#e31c3d';

            function getPositionY(row, y, height, gap) {
                return y + row * (height + gap.y)
            }

            function getPositionX(col, x, width, gap) {
                return x + col * (width + gap.x);
            }

            function getPosition(row, col, x, y, width, height, gap) {
                return {
                    x: getPositionX(col, x, width, gap),
                    y: getPositionY(row, y, height, gap)

                };
            }

            $scope.calculateCanvasWidth = function() {
                if ($scope.varSize) {
                    var widthSmall = ($scope.smallIconWidth + $scope.gap.x) * $scope.nColSmall + $scope.gap.x;
                    var widthLarge = ($scope.iconWidth + $scope.gap.x) * $scope.nCol + $scope.gap.x;
                    return Math.max(widthLarge, widthSmall);
                } else {
                    return $scope.textWidth + ($scope.iconWidth + $scope.gap.x) * $scope.nCol + $scope.gap.x * 2;
                }
            };

            $scope.calculateCanvasHeight = function() {
                if ($scope.varSize) {
                    var maxValue = Math.max(...$scope.values);
                    var largeRows = $scope.values.reduce((acc, curr) => { return Math.ceil(curr / $scope.nCol) + acc }, 0) ;
                    var heightLarge = ($scope.iconHeight + $scope.gap.y) * largeRows + $scope.gap.y;
                    var blanks = $scope.resolution - maxValue;
                    var smallRows = Math.ceil(blanks / $scope.nColSmall);
                    var heightSmall = ($scope.smallIconHeight + $scope.gap.y) * smallRows + $scope.gap.y;
                    return heightLarge + heightSmall + $scope.sectionGap * 1.5;
                } else {
                    return ($scope.iconHeight + $scope.gap.y) * $scope.nRow + $scope.gap.y;
                }
            };

            function drawFigure(data, pos, width, height) {
                $scope.ctx.fillStyle = $scope.color0;
                $scope.ctx.fillRect(pos.x, pos.y, width, height);
                if (data.val1 > 0) {
                    $scope.ctx.fillStyle = $scope.color1;
                    $scope.ctx.fillRect(pos.x, pos.y, width * data.val1 / 10, height);
                }
                if (data.val2 > 0) {
                    $scope.ctx.fillStyle = $scope.color2;
                    $scope.ctx.fillRect(pos.x, pos.y, width * data.val2 / 10, height);
                }
                if (data.val3 > 0) {
                    $scope.ctx.fillStyle = $scope.color3;
                    $scope.ctx.fillRect(pos.x, pos.y, width * data.val3 / 10, height);
                }
                if ($scope.drawImage) {
                    $scope.ctx.drawImage($scope.img, pos.x, pos.y, width, height);
                }
            }

            function drawRow(row, x, y, width, height) {
                for (var j = 0; j < row.length; ++j) {
                    var pos = getPosition(0, j, x, y, width, height, $scope.gap);
                    drawFigure(row[j], pos, width, height);
                }
            }

            $scope.drawChart = function() {
                $scope.rows = $util.numToMatrix($scope.values, $scope.nRow, $scope.nCol);
                var savedColor = $scope.ctx.fillStyle;

                for (var i = 0; i < $scope.rows.length; ++i) {
                    var row = $scope.rows[i];
                    var pos = getPosition(i, 0, $scope.gap.x + $scope.textWidth, $scope.gap.y + ($scope.iconHeight + $scope.textHeight) / 2, $scope.textWidth, $scope.iconHeight, $scope.gap);
                    $scope.ctx.fillStyle = $scope.textColor;
                    $scope.ctx.fillText(i * $scope.nCol + $scope.nCol, pos.x, pos.y);
                    drawRow(row, $scope.gap.x * 2 + $scope.textWidth, getPositionY(i, $scope.gap.y, $scope.iconHeight, $scope.gap), $scope.iconWidth, $scope.iconHeight, $scope.gap);
                }
                $scope.ctx.fillStyle = savedColor;
            };

            function getLayeredData(data, value) {
                return {
                    val1: data[0] >= value ? 10 : 0,
                    val2: data[1] >= value ? 10 : 0,
                    val3: data[2] >= value ? 10 : 0
                };
            }

            function drawLargeFigures(values, x, y, width, height) {
                var lowerBoundary = y;
                for (var i = 0; i < $scope.nRow; ++i) {
                    for (var j = 0; j < $scope.nCol; ++j) {
                        var cellValue = i * $scope.nCol + j + 1;
                        var pos = getPosition(i, j, x, y, width, height, $scope.gap);
                        if (Math.max(...values) >= cellValue) {
                            drawFigure(getLayeredData(values, cellValue), pos, width, height);
                            lowerBoundary = pos.y + height + $scope.gap.y;
                        } else {
                            return lowerBoundary;
                        }
                    }
                }
            }

            function drawSmallFigures(num, x, y, width, height) {
                var count = 0;
                for (var i = 0; i < $scope.nRowSmall; ++i) {
                    for (var j = 0; j < $scope.nColSmall; ++j) {
                        var pos = getPosition(i, j, x, y, width, height, $scope.gap);
                        drawFigure({val1: 0, val2: 0, val3: 0}, pos, width, height);
                        count += 1;
                        if (count >= num) {
                            return;
                        }
                    }
                }

            }

            $scope.drawVarSizeChart = function() {
                var y = drawLargeFigures([0, $scope.values[1]], $scope.gap.x, $scope.gap.y, $scope.iconWidth, $scope.iconHeight);
                y = drawLargeFigures([$scope.values[0], 0], $scope.gap.x, y + $scope.sectionGap / 2, $scope.iconWidth, $scope.iconHeight);
                drawSmallFigures($scope.resolution - Math.max(...$scope.values), $scope.gap.x, y + $scope.sectionGap, $scope.smallIconWidth, $scope.smallIconHeight);
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
            if (attrs.smallIconWidth) {
                $scope.smallIconWidth = parseInt(attrs.smallIconWidth);
            }
            if (attrs.smallIconHeight) {
                $scope.smallIconHeight = parseInt(attrs.smallIconHeight);
            }
            if (attrs.resolution) {
                $scope.resolution = parseInt(attrs.resolution);
            }
            if (attrs.gapX) {
                $scope.gap.x = parseInt(attrs.gapX);
            }
            if (attrs.gapY) {
                $scope.gap.y = parseInt(attrs.gapY);
            }
            if (attrs.varSize) {
                $scope.varSize = true;
            }

            if (element[0].getContext) {
                element[0].width = Math.max($scope.calculateCanvasWidth(), $scope.minWidth);
                element[0].height = Math.max($scope.calculateCanvasHeight(), $scope.minHeight);
                $scope.ctx = element[0].getContext('2d');
                $scope.ctx.textAlign = 'right';
                $scope.ctx.font = 'bold ' + $scope.textHeight + 'px sans-serif';
                var img = new Image();
                img.onload = function() {
                    $scope.img = img;
                    if ($scope.varSize) {
                        $scope.drawVarSizeChart();
                    } else {
                        $scope.drawChart();
                    }
                };
                img.src = 'files/images/people.png';
            } else {
                // Canvas not supported
                console.log('Canvas not supported in current browser!');
            }
        },
    }
}]);
