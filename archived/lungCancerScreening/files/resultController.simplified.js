var app = angular.module("myapp");

app.controller("ResultCtrl", function($scope, $window, $sce, $http, $sessionStorage, $location) {
  /* These globals are used in multiple ajax calls in different functions */
  $scope.session = $sessionStorage;
  $scope.base_url = window.location.origin + window.location.pathname

  $scope.gender = {
    0: 'Male',
    1: 'Female'
  };

  // parse pack years to readable number //
  $scope.parsePackYears = function() {
    return parseFloat($scope.session.myForm.packYears).toFixed(2);
  };

  // calculate eligibility of person based on certain criteria //
  $scope.calculateEligibility = function() {
    var quit = parseInt($scope.session.myForm.quit);
    if (quit) {
      if ($scope.session.params.age<55||$scope.session.params.age>80||$scope.session.myForm.packYears<30||$scope.session.params.age-quit>15) {
        return false;
      };
    }
    else {
      if ($scope.session.params.age<55||$scope.session.params.age>80||$scope.session.myForm.packYears<30) {
        return false;
      };
    };
    return true;
  };

  // create statement for ineligible person //
  $scope.createEligibilityStatement = function() {
    statement = 'You are age ' + $scope.session.params.age;
    if ($scope.session.myForm.type=='current') {
      statement+= ' and have smoked ' + $scope.parsePackYears() + ' pack-years.';
    }
    else {
      statement+= ', have smoked ' + $scope.parsePackYears() + ' pack-years';
      if (parseInt($scope.session.params.age)-parseInt($scope.session.myForm.quit)>15) {
        statement+= ' and have quit for more than 15 years.';
      }
      else {
        statement+= ' and have quit for no longer than 15 years.';
      };
    };
    return statement;
  };

  // gets value of 1 if value of result is 0 also gets the word less if that value is 0 //
  $scope.getResult = function(num, type) {
    if (type) {
      if ($scope.session.myForm[num]==0) {
        return 1;
      }
      else {
        return $scope.session.myForm[num]
      };
    }
    else {
      if ($scope.session.myForm[num]==0) {
        return " (or less)"
      };
    };
  };

  // gets the word people vs person if result is 1 //
  $scope.getPeopleOrPerson = function(val) {
    if (val==1) {
      return "person";
    };
    return "people";
  };

  /* Draws a simple table with 1000 cells filled in based on units out of 1000 */
  $scope.drawGraph = function(units) {
    var cellArray = [];
    var html = '<table class="grid_table" cellspacing="0" cellpadding="0" border="1">';

    /* create rows and columns filled in with color based on units until units is zero */
    for (var x=0; x<25; x++) {
      var row = [];
      for (var z=1; z<41; z++) {
        if (units>0) {
          row.push('<th style="background-color: #317593;border: 1px solid #777; width:10px !important; min-width:10px;height:10px !important; min-height:10px"></th>');
        }
        else {
          row.push('<th style="border: 1px solid #777; width:10px !important; min-width:10px;height:10px !important; min-height:10px"></th>');
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

    $scope.export = true;
    $scope.chart_row1 = true;
    $scope.chart_row2 = true;
    $scope.chart_row3 = true;
    $scope.loading = true;
    $scope.$apply();
            
    url = 'exportPDF/';
    var data = "";
    var html = createPrintablePage();

    $http({
        method: 'POST',
        url: url,
        data: html,
        headers: { 'Accept':'application/json, text/plain, * / *'}
      }).success(function(data) {
          // var byteCharacters = atob(data);
          // var byteNumbers = new Array(byteCharacters.length);
          // for (var i = 0; i < byteCharacters.length; i++) {
          //     byteNumbers[i] = byteCharacters.charCodeAt(i);
          // };
          // var byteArray = new Uint8Array(byteNumbers);
          // var blob = new Blob([byteArray], {type: 'application/pdf'});
          // fileURL = URL.createObjectURL(blob)
          // window.location.replace(fileURL)
          window.location.replace(url+"?dir="+data) /* Use this if decided to go with static files on server */
      }).error(function(data) {

      }).finally(function(data) {
        $scope.loading = false;
      });
  };

  $scope.print = function() {
    print(createPrintablePage())
  };

  function createPrintablePage() {
    var html = "";
    var source  = $("#results .ng-hide").remove();
    var results = $("#results").html();
    results = results.replace(new RegExp('<br>', 'g'), '<br />');
    results = results.replace(new RegExp('(<img("[^"]*"|[^\/">])*)>', 'g'), '$1/>');

    html+= '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
    html+= '<html xmlns="http://www.w3.org/1999/xhtml">';
    html+= '  <head>';
    html+= '  <title>Lung Cancer Risk Assessment</title>';
    html+= '  </head>';
    html+= '  <body>';
    html+= results;
    html+= '</body>';
    html+= '</html>';
    return html;
  };
});
