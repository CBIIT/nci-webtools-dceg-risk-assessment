var app = angular.module("myapp");

app.controller("MainCtrl", function($scope, $sce, $http, $localStorage, $location) {
	
	/* show results set to false. Disable your results tab until calculate is clicked */
	$scope.resultsDisabled = true;

	$scope.$on('$locationChangeStart', function() { 
		$scope.active = $location.path();
	});

	$scope.changeUrl = function(url) {
		$location.path(url);
	};
});
