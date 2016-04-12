angular.module('Arc')
.directive('uploadfile', ['$rootScope', 'DataService', 'ValidationService', 'UtilityService', 'ModalService',
function(root, data, validation, utility, modal) {
    function link($scope, element, attributes) {
        element[0].addEventListener('change', function(e) {
            var id = e.target.id;
            var file = e.target.files[0];

            function modelToArray(model) {
                return model.map(function(v) {
                    if (v.levels)
                        v.levels = v.levels.join(' ');
                    return v;
                });
            }

            if (id == 'listOfVariables') {
                data.uploadModel(id, file, function() {

                    if (data.getSection(id).model instanceof Array)
                        data.getSection(id).array = modelToArray(data.getSection(id).model);
                    else
                        modal.dialog('Validation Error', 'This file could not be parsed.')

                    setTimeout(function(){element.val(null)}, 0);
                });
            }

            else if (id == 'modelFormula') {
                data.uploadModel(id, file, function() {

                    if (typeof data.getSection(id).model == 'string')
                        data.getSection(id).array = utility.parseFormula();

                    else
                        modal.dialog('Validation Error', 'This file could not be parsed.')

                    setTimeout(function(){element.val(null)}, 0);
                });
            }

            /****** Loads a session file ******/
            else if (id == 'session') {
                if (window.FileReader) {
                    var reader = new FileReader();

                    if (file)
                        reader.readAsText(file);

                    reader.onload = function(event) {
                        var session = JSON.parse(event.target.result);

                        for (key in session) {
                            console.log(session[key]);
                            var section = data.getSection(key);

                            section.model = session[key].model;
                            section.filename = session[key].filename;
                            section.validated = session[key].validated;

                            if (session[key].array)
                                section.array = session[key].array;

                            if (session[key].familyHistory)
                                section.familyHistory = session[key].familyHistory;

                            root.$broadcast('nextSection', key);
                        }

                        var variables = data.getSection('listOfVariables').model.map(function(v) {return v.name});
                        validation.setExpectedColumns('riskFactorDistribution');
                        validation.setExpectedColumns('riskFactorForPrediction');
                        data.getSection('snpInformation').variables = variables;
                        validation.setExpectedRows('logOddsRatios');
                        validation.setExpectedColumns('genotypesForPrediction');

                        setTimeout(function(){element.val(null)}, 0);
                        root.$apply();
                    }
                }
            }

            else
                validation.readFile(id, file, function() {
                    element.val(null);
                });
        });
    }

    return {
      restrict: 'AE',
      replace: 'true',
      scope: {},
      link: link
    };
}])
