/*
    A service to retrieve data from the backend.
    It has a retrieveData function that takes the following parameters:
        cfg: config object
            url,
            data,
            type,
            success:            callback function
            error callback:     optional callback function
            finally callback:   optional callback function
*/
app.factory('DataRetrieval', [
    '$rootScope',
    '$http',
    function($rootScope, $http) {
        var self = this;

        self.errorMap = {
            'internal_server_error': {status: 500, type: 'error', content: '', description: 'There was a problem while processing the data. Please see the message below:'},
            'service_unavailable':   {status: 503, type: 'error', content: '', description: 'There was a problem while processing the data. The application may not be running.'}
        };

        self.errorHandler = function(errorData, status) {
            if (status === 500) {
                self.errorMap['internal_server_error'].content = errorData.message;
                $rootScope.$broadcast('modalContent', self.errorMap['internal_server_error']);
            }

            if (status === 503) {
                $rootScope.$broadcast('modalContent', self.errorMap['service_unavailable']);
            }
        };

        self.retrieveData = function(cfg) {
            var endpoint = cfg.url;
            var data = JSON.stringify(cfg.data);
            var type = cfg.type ? cfg.type : 'post';
            var successCallback = cfg.success;
            var errorCallback = cfg.error ? cfg.error : self.errorHandler;
            var finallyCallback = cfg.finally ? cfg.finally : function() {};

            $http[type](endpoint, data)
               .success(function(data, status, headers, config) {
                   console.log('data is: ', data);
                   successCallback(data);
               })
               .error(function(data, status, headers, config) {
                   errorCallback(data, status);
               })
               .finally(function(data) {
                   finallyCallback();
               });
        };

        return {
            retrieveData: self.retrieveData,
            errorHandler: self.errorHandler
        };
    }
]);
