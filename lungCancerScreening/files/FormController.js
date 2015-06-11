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
            $scope.myForm.heightPrimary;
            $scope.myForm.heightSecondary;
            $scope.myForm.weightUnits;
            $scope.myForm.units = 'us';
        }
        init();

        $scope.myForm.changeAge = function() {
            if($scope.myForm.age !== '' && $scope.myForm.age !== undefined){
              var age = parseFloat($scope.myForm.age);
              $scope.myForm.ageCriteria = !(age >= 55 && age <= 79);
              $scope.myForm.changeQuit();
            }
            else{
              $scope.myForm.ageCriteria = false;
            }
        };

        $scope.myForm.changeType = function(){
            $scope.myForm.smokeShow = $scope.myForm.type === 'current' || $scope.myForm.type === 'former';
            $scope.myForm.typeCriteria = $scope.myForm.type === 'non';
        };

        $scope.myForm.changeStart = function(){
            if ($scope.myForm.start === '') {
                $scope.myForm.startAgeCriteria = false;
            }
            else {
              var start = parseFloat($scope.myForm.start);
              $scope.myForm.startAgeCriteria = (start <= 0);
            }
        };

        $scope.myForm.changeQuit = function(){
            if ($scope.myForm.quit === '') {
                $scope.myForm.quitCriteria = false;
                $scope.myForm.quitAgeCriteria = false;
            }
            else {
              var age = parseFloat($scope.myForm.age);
              var quit = parseFloat($scope.myForm.quit);
              $scope.myForm.quitCriteria = (age - quit > 15);
              $scope.myForm.quitAgeCriteria = (quit > age);
            }
        };

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
          }
          else {
            $scope.myForm.heightPrimary = 'Meter(s)';
            $scope.myForm.heightSecondary = 'Centimer(s)';
            $scope.myForm.weightUnits = 'Kilogram(s)';
          }
        });

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
            $scope.myForm.education = '';
            $scope.myForm.units = 'us';
        };
});
