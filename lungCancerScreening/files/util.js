'use strict';

angular.module('myapp')
    .factory('$util', function() {
        var getCellValue = function(num, lowerBound, upperBound) {
            if(num >= upperBound) {
                return 10;
            } else if (num < lowerBound) {
                return 0;
            } else {
                return Math.round((num - lowerBound) * 10);
            }
        };
        /*
            Convert a number to a matrix, numbers in the matrix are file name suffixes of icons
        */
        var numToMatrix = function (num1, num2=0, num3=0) {
            var m = [];
            for (var i = 0; i < 10; ++i) {
                var row = [];
                for(var j = 0; j < 10; ++j) {
                    var lowerBound = i * 10 + j;
                    var upperBound = lowerBound + 1;
                    row.push({
                        val1: getCellValue(num1, lowerBound, upperBound),
                        val2: getCellValue(num2, lowerBound, upperBound),
                        val3: getCellValue(num3, lowerBound, upperBound)
                    });
                }
                m.push(row);
            }
            return m;
        };


        return {
            numToMatrix: numToMatrix
        };
    });