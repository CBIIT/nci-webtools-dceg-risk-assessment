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
        var numToMatrix = function (num, nRow=10, nCol=10) {
            var m = [];
            for (var i = 0; i < nRow; ++i) {
                var row = [];
                for(var j = 0; j < nCol; ++j) {
                    var lowerBound = i * nCol + j;
                    var upperBound = lowerBound + 1;
                    var data = {};
                    for (var k = 0; k < num.length; ++k) {
                        data['val' + (k + 1)] = getCellValue(num[k], lowerBound, upperBound);
                    }
                    row.push(data);
                }
                m.push(row);
            }
            return m;
        };


        return {
            numToMatrix: numToMatrix
        };
    });