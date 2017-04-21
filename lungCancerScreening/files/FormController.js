var app = angular.module("myapp");

app.controller("FormCtrl", function($scope, $sce, $http, $localStorage, $location) {
  /* These globals are used in multiple ajax calls in different functions */
  var GLOBAL_DATA;
  /* RegEx for numerical field validation */
  var numPattern = '^[0-9]+(\.[0-9]{1,9})?$';
  var numRegExp = new RegExp(numPattern, 'i');
  $scope.myForm = {};

  function init() {
    $scope.myForm.ageCriteria = false;
    $scope.myForm.bmiCriteria = false;
    $scope.myForm.ageNumericCriteria = false;
    $scope.myForm.typeCriteria = false;
    $scope.myForm.startAgeCriteria = false;
    $scope.myForm.startNumericCriteria = false;
    $scope.myForm.quitCriteria = false;
    $scope.myForm.quitNumericCriteria = false;
    $scope.myForm.quitAgeCriteria = false;
    $scope.myForm.cigsCriteria = false;
    $scope.myForm.cigsNumericCriteria = false;
    $scope.myForm.pHeightCriteria = false;
    $scope.myForm.subHeightCriteria = false;
    $scope.myForm.weightCriteria = false;
    $scope.myForm.units = 'us';
    $scope.myForm.numericValidationMessage = 'Please ensure the age entered above does not have any non-numeric characters.';
    $scope.myForm.bmiNumericValidationMessage = 'Please ensure the BMI entered above does not have any non-numeric characters.';
    $scope.myForm.isInvalid = false;
    $scope.myForm.summary = '';
    $scope.myForm.result0 = 0;
    $scope.myForm.result1 = 0;
    $scope.myForm.result2 = 0;
    $scope.myForm.result3 = 0;
    $scope.myForm.result4 = 0;
    $scope.myForm.result5 = 0;
    $scope.myForm.cbResult2 = false;
    $scope.myForm.cbResult3 = false;
    $scope.myForm.cbResult4 = false;
    $scope.myForm.cbResult5 = false;
    $scope.myForm.loading = false;
    $scope.myForm.error = false;
    $scope.myForm.resultsFileLink = '#';
    $scope.myForm.unstableRisk = false;
    $scope.myForm.eligibility = true;
    $scope.myForm.cigsPerDayAriaLabel = 'Number of cigarettes smoked per day'
  }
  init();


  /* $watchCollection allows watching of multiple properties and changing form state (valid/invalid) based on properties' values */
  /* scope.$watchCollection('[myForm.ageCriteria, myForm.ageNumericCriteria, myForm.startAgeCriteria, myForm.startNumericCriteria, myForm.quitCriteria, myForm.quitAgeCriteria, myForm.quitNumericCriteria, myForm.cigsCriteria, myForm.cigsNumericCriteria, myForm.pHeightCriteria, myForm.subHeightCriteria, myForm.weightCriteria, lcsForm.$invalid]', function(newValues) { */
  $scope.$watchCollection('[myForm.bmiCriteria, myForm.bmiNumericCriteria, myForm.ageCriteria, myForm.typeCriteria, myForm.ageNumericCriteria, myForm.startAgeCriteria, myForm.startNumericCriteria, myForm.quitAgeCriteria, myForm.quitNumericCriteria, myForm.cigsNumericCriteria, myForm.pHeightCriteria, myForm.subHeightCriteria, myForm.weightCriteria, lcsForm.$invalid]', function(newValues) {

    var flag = false;

    for (var i = 0; i <= newValues.length; i++) {
      if (newValues[i])
         flag = true;
    }

    $scope.myForm.isInvalid = flag;
  });

  // add dropdown value to myForm data object //
  $scope.$watch('myForm.disease',function() {
    $scope.myForm.diseaseDesc = $("#disease option:selected").text();
  });

  $scope.$watch('myForm.history',function() {
    $scope.myForm.historyDesc = $("#history option:selected").text();
  });

  $scope.$watch('myForm.education',function() {
    $scope.myForm.educationDesc = $("#education option:selected").text();
  });

  $scope.$watch('myForm.type',function() {
    $scope.myForm.typeDesc = $("#smoker_type option:selected").text();
  });

  $scope.$watch('myForm.group',function() {
    $scope.myForm.groupDesc = $("#race_group option:selected").text();
  });

  $scope.$watch('myForm.age', function() {
    validateAges();
  });

   $scope.$watch('myForm.bmi', function() {
    validateBMI();
  });

  $scope.$watchCollection('[myForm.quitCriteria, myForm.cigsCriteria, myForm.ageCriteria, myForm.bmiCriteria]', function(newValues) {
      $scope.myForm.eligibility = !newValues[0] && !newValues[1] && !newValues[2];

      console.log('eligibility is: ', $scope.myForm.eligibility);
  });

  $scope.$watch('myForm.age', function() {
    validateAges();
  });

  $scope.myForm.changeType = function() {
    $scope.myForm.smokeShow = $scope.myForm.type === 'current' || $scope.myForm.type === 'former';
    $scope.myForm.typeCriteria = $scope.myForm.type === 'non';
    $scope.myForm.start = '';
    $scope.myForm.quit = '';
    $scope.myForm.cigs = '';
    $scope.myForm.bmiSelection = '';
    $scope.myForm.startAgeCriteria = false;
    $scope.myForm.startNumericCriteria = false;
    $scope.myForm.quitCriteria = false;
    $scope.myForm.quitAgeCriteria = false;
    $scope.myForm.quitNumericCriteria = false;
    $scope.myForm.cigsCriteria = false;
    $scope.myForm.cigsNumericCriteria = false;
    
    if($scope.myForm.type === 'current') {
      console.log('selected current')
      $scope.myForm.cigsPerDayAriaLabel = 'On a typical day, how many cigarettes do you smoke?'

      $('#cigs').attr('aria-label', 'On a typical day, how many cigarettes do you smoke?');
    }
    if($scope.myForm.type === 'former') {
      console.log('selected former')
      $scope.myForm.cigsPerDayAriaLabel = 'On a typical day, how many cigarettes did you smoke before you quit for good?'
      $('#cigs').attr('aria-label', 'On a typical day, how many cigarettes did you smoke before you quit for good?');
    }

  };

  $scope.$watch('myForm.start', function() {
    validateAges();
  });

  $scope.$watch('myForm.quit', function() {
    validateAges();
  });

  $scope.$watchCollection('[myForm.age, myForm.cigs, myForm.start, myForm.quit]', function(newValues) {
    $scope.myForm.cigsNumericCriteria = !numRegExp.test($scope.myForm.cigs ? $scope.myForm.cigs : '0');

    var age,
      start,
      quit,
      cigs;

    if (!$scope.myForm.cigsNumericCriteria) {
      age = parseFloat($scope.myForm.age);
      cigs = parseFloat($scope.myForm.cigs);

      if ($scope.myForm.type === 'current' || $scope.myForm.type === 'former') {
        start = parseFloat($scope.myForm.start);

        /* Change formula for packYears based on value of 'type' */
        if ($scope.myForm.type === 'current') {
          $scope.myForm.packYears = ((age - start) * (cigs / 20));
        }

        /* Change formula for packYears based on value of 'type' */
        if ($scope.myForm.type === 'former') {
          quit = parseFloat($scope.myForm.quit);
          $scope.myForm.packYears = ((quit - start) * (cigs / 20));
        }

        $scope.myForm.cigsCriteria = $scope.myForm.packYears < 30;

      }
    } else {
      $scope.myForm.cigsCriteria = false;
    }
  });

  /* Toggle relevant properties based on US or Metric units */
  $scope.$watch('myForm.units', function() {
    if ($scope.myForm.units === 'us') {
      $scope.myForm.heightPrimary = 'Feet';
      $scope.myForm.heightSecondary = 'Inch(es)';
      $scope.myForm.weightUnits = 'Pound(s)';
      $scope.myForm.heightWarning = 'Please ensure, that feet are greater than 0 and less than or equal to 10, and inches are greater than or equal to 0 and less than 12. Please ensure that the height values above do not include any non-numeric characters.';
    } else {
      $scope.myForm.heightPrimary = 'Meter(s)';
      $scope.myForm.heightSecondary = 'Centimeter(s)';
      $scope.myForm.weightUnits = 'Kilogram(s)';
      $scope.myForm.heightWarning = 'Please ensure, that centimeters are greater than 30.48. Please ensure that the value above does not include any non-numeric characters.';
    }

    convertHeightWeight();
  });

  /* Switch height range validation based on US or Metric units (for meters/feet) */
  $scope.$watch('myForm.pHeight', function() {
    var isNumeric = numRegExp.test($scope.myForm.pHeight);
    var primary = parseFloat($scope.myForm.pHeight);

    if (($scope.myForm.pHeight === '' || $scope.myForm.pHeight === undefined || !$scope.myForm.pHeight) && !$scope.myForm.subHeight) {
      $scope.myForm.pHeightCriteria = false;
      return;
    }
    else {
      if ($scope.myForm.units === 'us') {
        $scope.myForm.pHeightCriteria = primary <= 0 || primary > 10 || !isNumeric;
      } else {
        $scope.myForm.pHeightCriteria = false;
      }
    }


  });

  /* Switch height range validation based on US or Metric units (for cm/inches) */
  $scope.$watch('myForm.subHeight', function() {
    var isNumeric = numRegExp.test($scope.myForm.subHeight);
    var sub = parseFloat($scope.myForm.subHeight);

    if ($scope.myForm.subHeight === '' || $scope.myForm.subHeight === undefined || !$scope.myForm.subHeight) {
      $scope.myForm.subHeightCriteria = false;
      return;
    }
    else if ($scope.myForm.subHeight < 30.48 && $scope.myForm.units != 'us') {
      $scope.myForm.subHeightCriteria = true;
    }
    else {
      if ($scope.myForm.units === 'us') {
        $scope.myForm.subHeightCriteria = sub < 0 || sub >= 12 || !isNumeric;
      } else {
        $scope.myForm.subHeightCriteria = sub < 0 || !isNumeric;
      }
    }
  });

  /* Calculate BMI to show warning if bmi is outside range 15-50 */
  $scope.$watchGroup(['myForm.weight','myForm.subHeight','myForm.pHeight'],function() {
    bmi = calculateBMI();
    $scope.myForm.bmiCriteria = (bmi>50||bmi<15)
  });

  $scope.$watch('myForm.weight', function() {
    var w = parseFloat($scope.myForm.weight);

    if ($scope.myForm.weight === '' || $scope.myForm.weight === undefined) {
      $scope.myForm.weightCriteria = false;
      return;
    }

    $scope.myForm.weightCriteria = w <= 0 || !numRegExp.test($scope.myForm.weight);
  });

  $scope.myForm.resetForm = function() {
    init();
    $scope.myForm.age = '';
    $scope.myForm.type = '';
    $scope.myForm.quit = '';
    $scope.myForm.start = '';
    $scope.myForm.bmiSelection = '';
    $scope.myForm.cigs = '';
    $scope.myForm.group = '';
    $scope.myForm.gender = '';
    $scope.myForm.disease = '';
    $scope.myForm.history = '';
    $scope.myForm.pHeight = '';
    $scope.myForm.subHeight = '';
    $scope.myForm.weight = '';
    $scope.myForm.education = '';
    $scope.myForm.units = 'us';
    $scope.myForm.smokeShow = false;
    $scope.myForm.bmi = 0;
    $scope.myForm.pkyr_cat = 0;
    $scope.myForm.isInvalid = true;
    $scope.myForm.summary = '';
    $scope.myForm.result0 = 0;
    $scope.myForm.result1 = 0;
    $scope.myForm.result2 = 0;
    $scope.myForm.result3 = 0;
    $scope.myForm.result4 = 0;
    $scope.myForm.result5 = 0;
    $scope.myForm.cbResult2 = false;
    $scope.myForm.cbResult3 = false;
    $scope.myForm.cbResult4 = false;
    $scope.myForm.cbResult5 = false;
    $scope.myForm.resultsFileLink= '#';
    $scope.myForm.unstableRisk = false;
    $scope.myForm.eligibility = true;
    $scope.myForm.packYears = NaN;
    $scope.myForm.bmiCriteria = false;
  };

  /* Create BMI summary that displays in results section of UI */
  $scope.myForm.createSummary = function(bmi) {
    var keyMap = {
      gender: {
        '0': 'male',
        '1': 'female'
      },
      race: {
        '0': 'White',
        '1': 'Black or African-American',
        '2': 'Hispanic',
        '3': 'Asian or Pacific Islander',
        '4': 'Other'
      }
    };

    return keyMap.race[$scope.myForm.group] + ' ' + keyMap.gender[$scope.myForm.gender] + ' of ' + $scope.myForm.age + ' years of age with BMI = ' + bmi;
  };

  $scope.myForm.setResultValues = function(data) {
    for (var i = 0; i < data.length; i++) {
      /* Round to 2 decimal places and assign results to UI properties */
      /* $scope.myForm['result' + i] = Math.round(data[i] * 100) / 100; */
      $scope.myForm['result' + i] = Math.round(data[i]);

      /* GLOBAL_RESULTS['result' + i] = $scope.myForm['result' + i]; */
    }

    if ($scope.myForm.result0 > $scope.myForm.result2) {
        $scope.myForm.result2 = $scope.myForm.result0;
        $scope.myForm.unstableRisk = true;
    }
  };

  $scope.myForm.submit = function() {
    /* add port for localhost testing purposes */
    if (window.location.hostname=='localhost') {
      url = 'http://' + window.location.hostname + ':9982/lungCancerRest/';
    }
    else {
      url = 'https://' + window.location.hostname + '/lungCancerScreening/lungCancerRest/';
    };
    var bmi = 0,
        h,
        w,
        data,
        params,
        paramsArray = [],
        qtyears,
        url

    /* Reset summary property to disable results/download results button */
    $scope.myForm.summary = '';

    /* Reset error property to remove error message from UI */
    $scope.myForm.error = false;

    /* Reset results file link prior to calculation */
    $scope.myForm.resultsFileLink = '#';

    if ($scope.myForm.units === 'us') {
      h = (parseFloat($scope.myForm.pHeight) * 12) + parseFloat($scope.myForm.subHeight ? $scope.myForm.subHeight : '0');
      w = parseFloat($scope.myForm.weight);
      bmi = (w * 703) / Math.pow(h, 2);
    } else {
      h = (parseFloat($scope.myForm.subHeight) / 100) + parseFloat($scope.myForm.pHeight);
      w = parseFloat($scope.myForm.weight);
      bmi = w / Math.pow(h, 2);
    }

    qtyears = $scope.myForm.quit ? Math.round($scope.myForm.age - parseFloat($scope.myForm.quit)) : 0;

    params = {
      'age': Math.round($scope.myForm.age),
      'bmi': Math.round(bmi * 100) / 100,  /* Measure to two decimal places */
      'cpd': parseFloat($scope.myForm.cigs),
      'emp': parseInt($scope.myForm.disease, 10),
      'fam.lung.trend': parseInt($scope.myForm.history, 10),
      'gender': parseInt($scope.myForm.gender, 10),
      'qtyears': qtyears,
      'smkyears': 0,
      'race': parseInt($scope.myForm.group, 10),
      'edu6': parseInt($scope.myForm.education),
      'pkyr.cat': $scope.myForm.packYears
    };

    if ($scope.myForm.type === 'current')
      params.smkyears = parseFloat($scope.myForm.age) - parseFloat($scope.myForm.start);

    if ($scope.myForm.type === 'former')
      params.smkyears = parseFloat($scope.myForm.quit) - parseFloat($scope.myForm.start);

    GLOBAL_DATA = JSON.stringify(params);

    $scope.myForm.loading = true;
    $scope.myForm.isInvalid = true;

    /* Ajax call to process results */
    $http.post(url, GLOBAL_DATA)
       .success(function(data, status, headers, config) {
         if (data.length) {
            $scope.myForm.resultsFileLink = data.pop();
            $scope.myForm.setResultValues(data);
            $scope.myForm.summary = $scope.myForm.createSummary(params.bmi);
            console.log(data,params)
         }
       })
       .error(function(data, status, headers, config) {
         console.log('status is: ', status);
         $scope.myForm.error = true;
       })
       .finally(function(data) {
         $scope.myForm.isInvalid = false;
         $scope.myForm.loading = false;
         $localStorage.params = params;
         $localStorage.myForm = $scope.myForm;
         $scope.$parent.resultsDisabled = false;
         $location.path('/results')
    	 });
  };

  $scope.myForm.printPage = function() {
    window.print();
  };

  /* Utility functions */
  /* Age validation */
  function validateAges() {
    var age,
        start,
        quit;

    $scope.myForm.ageNumericCriteria = !numRegExp.test($scope.myForm.age ? $scope.myForm.age : '0');
    $scope.myForm.startNumericCriteria = !numRegExp.test($scope.myForm.start ? $scope.myForm.start : '0');
    $scope.myForm.quitNumericCriteria = !numRegExp.test($scope.myForm.quit ? $scope.myForm.quit : '0');

    if (!$scope.myForm.ageNumericCriteria) {
      age = parseFloat($scope.myForm.age);
      $scope.myForm.ageCriteria = (age < 50 || age > 80);
    } else {
      $scope.myForm.ageCriteria = false;
    }

    if ($scope.myForm.type === 'current' || $scope.myForm.type === 'former') {
      if (!$scope.myForm.startNumericCriteria) {
        start = parseFloat($scope.myForm.start);
        $scope.myForm.startAgeCriteria = (start <= 0 || start > age);

        if ($scope.myForm.type === 'former') {
          if (!$scope.myForm.quitNumericCriteria) {
            quit = parseFloat($scope.myForm.quit);
            $scope.myForm.quitCriteria = (age - quit > 15);
            $scope.myForm.quitAgeCriteria = (quit > age || quit <= start);
          } else {
            $scope.myForm.quitAgeCriteria = false;
          }
        }
      } else {
        $scope.myForm.startAgeCriteria = false;
      }
    }
  }

  function validateBMI() {
    var bmi;
    $scope.myForm.bmiNumericCriteria = !numRegExp.test($scope.myForm.bmi ? $scope.myForm.bmi : '0');

     if (!$scope.myForm.bmiNumericCriteria) {
      bmi = parseFloat($scope.myForm.bmi);
      $scope.myForm.bmiCriteria = (bmi < 15 || age > 50);
    } else {
      $scope.myForm.bmiCriteria = false;
    }

  }

  /* Calculates weight in US or Metric units when toggling 'unit' dropdown in UI */
  function convertHeightWeight() {
    var primary = parseFloat($scope.myForm.pHeight);
    var sub = parseFloat($scope.myForm.subHeight);
    var weight = parseFloat($scope.myForm.weight);

    if ($scope.myForm.units == 'us') { // convert metric to imperial //
      var subInches = sub / 2.54; // convert cm to inches
      primary = 0;
      while (subInches>=12) { // calculate feet based on total inches //
        primary+=1;
        subInches-=12;
      };
      $scope.myForm.subHeight = (subInches === 0) ? NaN : Math.round(subInches * 100) / 100; // set inches for secondary input field //
      $scope.myForm.pHeight = (primary === 0) ? NaN : primary; // set feet for primary input field //
    }
    else { // convert imperial to metric //
      $scope.myForm.pHeightCriteria = false; // set primary height criteria to false, no longer needed for metric //
      sub = (!sub) ? 0 : sub;
      primary = (!primary) ? 0 : primary;
      var cm = (primary*12+sub)* 2.54;
      $scope.myForm.subHeight = (cm === 0) ? NaN : Math.round(cm * 100) / 100; // set secondary units (cm) //
      $scope.myForm.pHeight = 0; // set primary metric units, not needed but bypasses errors //
    };

    if (weight) {
      $scope.myForm.weight = ($scope.myForm.units === 'us') ? weight * 2.20462 : weight / 2.20462;
      $scope.myForm.weight = Math.round($scope.myForm.weight * 100) / 100;
    }
  }

  /* Draws a simple table with 1000 cells filled in based on units out of 1000 */
  $scope.drawGraph = function(units) {
    var cellArray = [];
    var html = '<table cellspacing="0" cellpadding="0" border="1">';

    /* create rows and columns filled in with color based on units until units is zero */
    for (var x=0; x<25; x++) {
      var row = [];
      for (var z=1; z<41; z++) {
        if (units>0) {
          row.push('<td class="filled"><img src="files/cellfill.png" title="filled cell" alt="filled cell"></td>');
        }
        else {
          row.push('<td></td>');
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

  $scope.openCopdDialog = function() {
    $("#copd_dialog").dialog({
      modal: true
    }
    );
  };

  function calculateBMI() {
    if ($scope.myForm.units === 'us') {
      h = (parseFloat($scope.myForm.pHeight) * 12) + parseFloat($scope.myForm.subHeight ? $scope.myForm.subHeight : '0');
      w = parseFloat($scope.myForm.weight);
      bmi = (w * 703) / Math.pow(h, 2);
    } else {
      h = (parseFloat($scope.myForm.subHeight) / 100) + parseFloat($scope.myForm.pHeight);
      w = parseFloat($scope.myForm.weight);
      bmi = w / Math.pow(h, 2);
    };
    return bmi
  };
});

$("#smoker_type").change(function() {
  alert("test")
});
