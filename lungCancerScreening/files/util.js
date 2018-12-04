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

        /*

        Combine matrix 1 and matrix 2 into matrix 1,
        Make sure figures won't overlap each other

         */
        var combineMatrices = function(m1, m2, nRow=25, nCol=40) {
            if (m1.length !== nRow || m2.length !== nRow ||
                m1[0].length !== nCol || m2[0].length !== nCol) {
                console.log("Wrong matrix dimensions!");
                return undefined;
            }

            for (var k = 0; k < nRow; ++k) {
                if (m1[k][0].val1 === 0) {
                    break;
                }
            }
            for (var i = 0; i < nRow; ++i) {
                if (i + k >= nRow) {
                    break;
                }
                if (m2[i][0] === 0) {
                    break;
                }
                for(var j = 0; j < nCol; ++j) {
                    m1[i + k][j].val2 = m2[i][j].val2
                }
            }
        };


        return {
            combineMatrices: combineMatrices,
            numToMatrix: numToMatrix
        };
    });