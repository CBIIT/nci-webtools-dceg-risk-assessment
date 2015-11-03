/* A controller for modal/modal content */
app.controller('ModalController', function ($scope, $modalInstance, data) {
    var self = this;

    self.statusCode = data.statusCode;
    self.heading = data.heading;
    self.type = data.type;
    self.description = data.description;
    self.content = data.content;

    self.close = function() {
        $modalInstance.dismiss('cancel');
    };
});
