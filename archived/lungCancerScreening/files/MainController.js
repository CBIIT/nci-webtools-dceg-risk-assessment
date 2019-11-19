var app = angular.module("myapp");

app.controller("MainCtrl", function($scope, $sce, $http, $sessionStorage, $location) {
	
	/* show results set to false. Disable your results tab until calculate is clicked */
	$scope.resultsDisabled = true;

	$scope.admin_email = '';
	$scope.support_email = '';

	$http.get('configuration/').then( function(res) {
	    if (res.data) {
            if (res.data.admin_email) {
                $scope.admin_email = res.data.admin_email;
            }

            if (res.data.support_email) {
                $scope.support_email = res.data.support_email;
            }
        }
    })
    .catch( function(res) {
        console.log(res.data || 'Fetch configuration failed!');
    });

	$scope.$on('$locationChangeStart', function() { 
		$scope.active = $location.path();
	});

	$scope.changeUrl = function(url) {
		$location.path(url);
	};
});
