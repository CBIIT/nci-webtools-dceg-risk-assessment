var app = angular.module("myapp", []);

app.controller("MyController", function($scope, $http) {

  var numPattern = '^[0-9]+(\.[0-9]{1,9})?$';
  var numRegExp = new RegExp(numPattern, 'i');
  $scope.myForm = {};

  function init() {
    $scope.myForm.ageCriteria = false;
    $scope.myForm.ageNumericCriteria = false;
    $scope.myForm.typeCriteria = false;
    $scope.myForm.startAgeCriteria = false;
    $scope.myForm.quitCriteria = false;
    $scope.myForm.quitAgeCriteria = false;
    $scope.myForm.cigsCriteria = false;
    $scope.myForm.pHeightCriteria = false;
    $scope.myForm.subHeightCriteria = false;
    $scope.myForm.weightCriteria = false;
    $scope.myForm.units = 'us';
    $scope.myForm.numericValidationMessage = 'Please ensure the age entered above does not have any non-numeric characters.';
    $scope.myForm.isInvalid = false;
  }
  init();

  $scope.$watch('myForm.age', function() {
    validateAges();
  });

  $scope.myForm.changeType = function() {
    $scope.myForm.smokeShow = $scope.myForm.type === 'current' || $scope.myForm.type === 'former';
    $scope.myForm.typeCriteria = $scope.myForm.type === 'non';
    $scope.myForm.start = '';
    $scope.myForm.quit = '';
    $scope.myForm.startAgeCriteria = false;
    $scope.myForm.quitCriteria = false;
    $scope.myForm.quitAgeCriteria = false;
  };

  $scope.$watch('myForm.start', function() {
    validateAges();
  });

  $scope.$watch('myForm.quit', function() {
    validateAges();
  });

  $scope.myForm.changeCigs = function() {
    var age,
      start,
      quit;

    if ($scope.myForm.cigs === '') {
      $scope.myForm.cigsCriteria = false;
    } else {
      age = parseFloat($scope.myForm.age);

      if ($scope.myForm.type === 'current') {
        start = parseFloat($scope.myForm.start);
        $scope.myForm.packYears = ((age - start) * ($scope.myForm.cigs / 20));
        $scope.myForm.cigsCriteria = $scope.myForm.packYears < 30;

        console.log('pack years = ', (age - start) * ($scope.myForm.cigs / 20));
        console.log('pack years criteria = ', $scope.myForm.cigsCriteria);
      }

      /* Not possible to calculate pack years for former smokers unless we know how long they smoked */
    }
  };

  $scope.$watch('myForm.units', function() {
    if ($scope.myForm.units === 'us') {
      $scope.myForm.heightPrimary = 'Feet';
      $scope.myForm.heightSecondary = 'Inch(es)';
      $scope.myForm.weightUnits = 'Pound(s)';
      $scope.myForm.heightWarning = 'Please ensure, that feet are greater than 0 and less than or equal to 10, and inches are greater than 0 and less than 12. Please ensure that the height values above do not include any non-numeric characters.';
    } else {
      $scope.myForm.heightPrimary = 'Meter(s)';
      $scope.myForm.heightSecondary = 'Centimeter(s)';
      $scope.myForm.weightUnits = 'Kilogram(s)';
      $scope.myForm.heightWarning = 'Please ensure, that meters are greater than 0 and less than or equal to 3, and centimeters are greater than 0 and less than 30. Please ensure that the values above do not include any non-numeric characters.';
    }

    convertHeightWeight();
  });

  $scope.$watch('myForm.pHeight', function() {
    var isNumeric = numRegExp.test($scope.myForm.pHeight);
    var primary = parseFloat($scope.myForm.pHeight);

    if ($scope.myForm.pHeight === '' || $scope.myForm.pHeight === undefined) {
      $scope.myForm.pHeightCriteria = false;
      return;
    }

    if ($scope.myForm.units === 'us') {
      $scope.myForm.pHeightCriteria = primary <= 0 || primary > 10 || !isNumeric;
    } else {
      $scope.myForm.pHeightCriteria = primary <= 0 || primary > 3 || !isNumeric;
    }
  });

  $scope.$watch('myForm.subHeight', function() {
    var isNumeric = numRegExp.test($scope.myForm.subHeight);
    var sub = parseFloat($scope.myForm.subHeight);

    if ($scope.myForm.subHeight === '' || $scope.myForm.subHeight === undefined) {
      $scope.myForm.subHeightCriteria = false;
      return;
    }

    if ($scope.myForm.units === 'us') {
      $scope.myForm.subHeightCriteria = sub <= 0 || sub >= 12 || !isNumeric;
    } else {
      $scope.myForm.subHeightCriteria = sub <= 0 || sub > 30 || !isNumeric;
    }
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
  };

  $scope.myForm.submit = function() {
    var isInvalid = $scope.myForm.isInvalid;
    var bmi = 0,
        height,
        weight;

    if (!isInvalid) {
      if ($scope.myForm.units === 'us') {
        height = (parseFloat($scope.myForm.pHeight) * 12) + parseFloat($scope.myForm.subHeight);
        weight = parseFloat($scope.myForm.weight);
        bmi = (weight * 703) / Math.pow(height, 2);
      } else {
        height = (parseFloat($scope.myForm.subHeight) / 100) + parseFloat($scope.myForm.pHeight);
        weight = parseFloat($scope.myForm.weight);
        bmi = weight / Math.pow(height, 2);
      }

      $scope.myForm.bmi = Math.round(bmi * 100) / 100;
      //console.log('bmi is: ', $scope.myForm.bmi);


      console.log('pkyr_cat is: ', $scope.myForm.packYears);
    }
  };

  // Validation functions
  function validateAges() {
    var age,
      start,
      quit;

    if ($scope.myForm.age !== '' && $scope.myForm.age !== undefined) {
      age = parseFloat($scope.myForm.age);
      $scope.myForm.ageNumericCriteria = !numRegExp.test($scope.myForm.age);
      $scope.myForm.ageCriteria = (age < 55 || age > 79) && !$scope.myForm.ageNumericCriteria;
    } else {
      $scope.myForm.ageCriteria = false;
    }

    if ($scope.myForm.type === 'current') {
      if ($scope.myForm.start === '') {
        $scope.myForm.startAgeCriteria = false;
      } else {
        start = parseFloat($scope.myForm.start);
        $scope.myForm.startNumericCriteria = !numRegExp.test($scope.myForm.start);
        $scope.myForm.startAgeCriteria = (start <= 0 || start > age) && !$scope.myForm.startNumericCriteria;
      }
    }

    if ($scope.myForm.type === 'former') {
      if ($scope.myForm.quit === '') {
        $scope.myForm.quitCriteria = false;
        $scope.myForm.quitAgeCriteria = false;
      } else {
        quit = parseFloat($scope.myForm.quit);
        $scope.myForm.quitCriteria = (age - quit > 15);
        $scope.myForm.quitNumericCriteria = !numRegExp.test($scope.myForm.quit);
        $scope.myForm.quitAgeCriteria = (quit > age) && !$scope.myForm.quitNumericCriteria;
      }
    }
  }

  function convertHeightWeight() {
    var primary = parseFloat($scope.myForm.pHeight);
    var sub = parseFloat($scope.myForm.subHeight);
    var weight = parseFloat($scope.myForm.weight);

    if (primary) {
      $scope.myForm.pHeight = ($scope.myForm.units === 'us') ? primary * 3.28084 : primary / 3.28084;
      $scope.myForm.pHeight = Math.round($scope.myForm.pHeight * 100) / 100;
    }

    if (sub) {
      $scope.myForm.subHeight = ($scope.myForm.units === 'us') ? sub / 2.54 : sub * 2.54;
      $scope.myForm.subHeight = Math.round($scope.myForm.subHeight * 100) / 100;
    }

    if (weight) {
      $scope.myForm.weight = ($scope.myForm.units === 'us') ? weight * 2.20462 : weight / 2.20462;
      $scope.myForm.weight = Math.round($scope.myForm.weight * 100) / 100;
    }
  }
});
