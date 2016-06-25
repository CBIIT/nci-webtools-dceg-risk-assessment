var app = angular.module("myapp");

app.controller("ResultCtrl", function($scope, $window, $sce, $http, $localStorage) {
  /* These globals are used in multiple ajax calls in different functions */
  $scope.session = $localStorage;
  $scope.raceMap = {
    0: 'a White',
    1: 'a Black or African-American',
    2: 'a Hispanic',
    3: 'an Asian or Pacific Islander',
    4: 'an Other'
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
          row.push('<td class="f"><img src="files/cellfill.png"></td>');
        }
        else {
          row.push('<td><img src="files/cellempty.png"></td>');
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

  $scope.print = function() {
        var pdf = new jsPDF('p', 'pt', 'letter');
        // source can be HTML-formatted string, or a reference
        // to an actual DOM element from which the text will be scraped.
        source = $('#content')[0];

        // we support special element handlers. Register them with jQuery-style 
        // ID selector for either ID or node name. ("#iAmID", "div", "span" etc.)
        // There is no support for any other type of selectors 
        // (class, of compound) at this time.
        specialElementHandlers = {
            // element with id of "bypass" - jQuery style selector
            '#bypassme': function (element, renderer) {
                // true = "handled elsewhere, bypass text extraction"
                return true
            }
        };
        margins = {
            top: 80,
            bottom: 60,
            left: 40,
            width: 522
        };
        // all coords and widths are in jsPDF instance's declared units
        // 'inches' in this case
        pdf.fromHTML(
        '<table border="1" style="background-color:white"><tr><td style="background-color:red;">test</td></tr></table>', // HTML string or DOM elem ref.
        margins.left, // x coord
        margins.top, { // y coord
            'width': margins.width, // max width of content on PDF
            'elementHandlers': specialElementHandlers
        },

        function (dispose) {
            // dispose: object with X, Y of the last line add to the PDF 
            //          this allow the insertion of new lines after html
            pdf.save('Test.pdf');
        }, margins);

  } 
});
