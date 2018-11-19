'use strict';

angular.module('myapp')
    .factory('$util', function() {
        /*
            Convert a number to a matrix, numbers in the matrix are file name suffixes of icons
        */
        var numToMatrix = function (num) {
            var m = [];
            for (var i = 0; i < 10; ++i) {
                var row = [];
                for(var j = 0; j < 10; ++j) {
                    var lowerBound = i * 10 + j;
                    var uppperBound = lowerBound + 1;
                    if(num >= uppperBound) {
                        row.push(10);
                    } else if (num < lowerBound) {
                        row.push(0);
                    } else {
                        row.push(Math.round((num - lowerBound) * 10));
                    }
                }
                m.push(row);
            }
            return m;
        };


        return {
            numToMatrix: numToMatrix
        };
    });