var app = angular.module("myapp");

app.controller("ResultCtrl", function($scope, $window, $sce, $http, $localStorage, $location) {
  /* These globals are used in multiple ajax calls in different functions */
  $scope.base_url = window.location.origin;
  $scope.session = $localStorage;
  $scope.raceMap = {
    0: 'a White',
    1: 'a Black or African-American',
    2: 'a Hispanic',
    3: 'an Asian or Pacific Islander',
    4: 'a'
  };
  $scope.gender = {
    0: 'male',
    1: 'female'
  };


  /* Draws a simple table with 1000 cells filled in based on units out of 1000 */
  $scope.drawGraph = function(units) {
    var cellArray = [];
    var html = '<table cellspacing="0" cellpadding="0" border="1">';

    /* create rows and columns filled in with color based on units until units is zero */
    for (var x=0; x<25; x++) {
      var row = [];
      for (var z=1; z<41; z++) {
        if (units>0) {
          row.push('<td class="f"><img src="' + $scope.base_url + '/files/cellfill.png"></td>');
        }
        else {
          row.push('<td><img src="' + $scope.base_url + '/files/cellempty.png"></td>');
        };
        units-=1;
      };
      cellArray.push(row);
    };

    /* reverse rows so colors fill in from bottom of chart */
    cellArray.reverse();
    
    /* loop through row array and create actual html to be dislpayed on page */
    for (var x = 0; x<cellArray.length; x++) {
      html+="<tr>";
      for (var z = 0; z<cellArray[x].length; z++) {
        html+=cellArray[x][z];
      };
      html+="</tr>";
    };
    html+= '</table>'; 
    return $sce.trustAsHtml(html);
  }; 

  $scope.exportPDF = function() {
    if (window.location.hostname=='localhost') {
      url = 'http://' + window.location.hostname + ':9982/exportPDF/';
    }
    else {
      url = 'http://' + window.location.hostname + '/exportPDF/';
    };
    var data = "";
    var results = $("#results").html();
    var html = "";
    html+= '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
    html+= '<html xmlns="http://www.w3.org/1999/xhtml">';
    html+= '  <head>';
    html+= '  <title>National Lung Screening Trial</title>';
    html+= '  <meta http-equiv="X-UA-Compatible" content="IE=edge" />';
    html+= '  <meta http-equiv="Content-type" content="text/html; charset=UTF-8">';
    html+= '  <link href="' + $scope.base_url + '/files/2col.css" rel="stylesheet" type="text/css" media="all">';
    html+= '  <link href="' + $scope.base_url + '/files/pdf.css" rel="stylesheet" type="text/css" media="all">';
    html+= '  </head>';
    html+= '  <body>';
    html+= results;
    html+= '</body>';
    html+= '</html>';

    $http({method: 'POST', url: url,headers: { 'Accept':'application/json, text/plain, * / *'}, data: html}).
            success(function(data) {
              console.log("SUCCESS")
            })
            .error(function(data) {
              console.log("FAIL")
            })
      console.log("redirect and to actual file and have a cron job delete files?")
    // $http.post(url, data)
    //    .success(function(data) {
    //     window.d = data;
    //     var file  = new Blob([data], {type: 'application/pdf'});
    //     var fileURL = URL.createObjectURL(file);
    //      // window.open(fileURL);        
    //    })
    //    .error(function(data) {
    //     console.log("ERROR")
    //    })
    //    .finally(function(data) {
    //     console.log("FINALLY")
    //    });
  };
});
