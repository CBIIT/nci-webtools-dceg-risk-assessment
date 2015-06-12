var app = angular.module("myapp",[]);

app.controller("MyController", function($scope, $http) {

  $scope.myForm = {};
  function init(){
    $scope.myForm.ageCriteria = false;
    $scope.myForm.typeCriteria = false;
    $scope.myForm.startAgeCriteria = false;
    $scope.myForm.quitCriteria = false;
    $scope.myForm.quitAgeCriteria = false;
    $scope.myForm.packsCriteria = false;
    $scope.myForm.heightCriteria = false;
    $scope.myForm.weightCriteria = false;
    $scope.myForm.units = 'us';
  }
  init();

  $scope.$watch('myForm.age', function() {
    validateAges();
  });

  $scope.myForm.changeType = function(){
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

  $scope.myForm.changePacks = function(){
    if ($scope.myForm.packs === '') {
      $scope.myForm.packsCriteria = false;
    }
    else {
      // What is this formula supposed to be?
      $scope.myForm.packsCriteria = (($scope.myForm.age - $scope.myForm.start) * $scope.myForm.packs < 30);
    }
  };

  $scope.$watch('myForm.units', function() {
    if ($scope.myForm.units === 'us') {
      $scope.myForm.heightPrimary = 'Feet';
      $scope.myForm.heightSecondary = 'Inch(es)';
      $scope.myForm.weightUnits = 'Pound(s)';
      $scope.myForm.heightWarning = 'Please ensure, that feet are greater than 0 and less than or equal to 10, and inches are greater than 0 and less than 12.';
    } else {
      $scope.myForm.heightPrimary = 'Meter(s)';
      $scope.myForm.heightSecondary = 'Centimeter(s)';
      $scope.myForm.weightUnits = 'Kilogram(s)';
      $scope.myForm.heightWarning = 'Please ensure, that meters are greater than 0 and less than or equal to 3, and centimeters are greater than 0 and less than 30.';
    }
  });

  $scope.myForm.changeHeight = function(){
    var primary = parseFloat($scope.myForm.pHeight);
    var sub = parseFloat($scope.myForm.subHeight);

    if ($scope.myForm.pHeight === '' || $scope.myForm.subHeight === '') {
      $scope.myForm.heightCriteria = false;
      return;
    }

    if ($scope.myForm.units === 'us') {
      $scope.myForm.heightCriteria = primary <= 0 || primary > 10 || sub <= 0 || sub >= 12;
    } else {
      $scope.myForm.heightCriteria = primary <= 0 || primary > 3 || sub <= 0 || sub > 30;
    }
  };

  $scope.myForm.changeWeight = function(){
    var w = parseFloat($scope.myForm.weight);

    if ($scope.myForm.weight === '') {
      $scope.myForm.weightCriteria = false;
      return;
    }

    $scope.myForm.weightCriteria = w <= 0;
  };


  $scope.myForm.resetForm = function(){
    init();
    $scope.myForm.age = '';
    $scope.myForm.type = '';
    $scope.myForm.quit = '';
    $scope.myForm.start = '';
    $scope.myForm.packs = '';
    $scope.myForm.group = '';
    $scope.myForm.gender = '';
    $scope.myForm.disease = '';
    $scope.myForm.history = '';
    $scope.myForm.pHeight = '';
    $scope.myForm.subHeight = '';
    $scope.myForm.weight = '';
    $scope.myForm.education = '';
    $scope.myForm.units = 'us';
  };

  // Validatin functions
  function validateAges() {
    var age,
        start,
        quit;

    if($scope.myForm.age !== '' && $scope.myForm.age !== undefined) {
      age = parseFloat($scope.myForm.age);
      $scope.myForm.ageCriteria = !(age >= 55 && age <= 79);
    } else {
      $scope.myForm.ageCriteria = false;
    }

    if ($scope.myForm.type === 'current') {
      if ($scope.myForm.start === '') {
        $scope.myForm.startAgeCriteria = false;
      } else {
        start = parseFloat($scope.myForm.start);
        $scope.myForm.startAgeCriteria = (start <= 0 || start > age);
      }
    } else {
      if ($scope.myForm.quit === '') {
        $scope.myForm.quitCriteria = false;
        $scope.myForm.quitAgeCriteria = false;
      } else {
        quit = parseFloat($scope.myForm.quit);
        $scope.myForm.quitCriteria = (age - quit > 15);
        $scope.myForm.quitAgeCriteria = (quit > age);
      }
    }
  }
});
