angular.module('Arc')
.factory('ValidationService', ['$rootScope', '$resource', 'ModalService', function(root, resource, modal) {

    var self = this;
    self.contents = {};

    return {
        log: log,
        retrieveContents: retrieveContents,
        retrieveRowNames: retrieveRowNames,
        retrieveColumnNames: retrieveColumnNames,
        readFile: readFile,
        submit: submit
    };

    function log() {
        console.log('Validation', self.contents);
    }

    function retrieveContents(id) {
        return self.contents[id];
    }

    function retrieveRowNames(id) {
        var rowNames = self.contents[id].map(function(eachLine) { return eachLine[0]; });
        rowNames.shift();
        return rowNames;
    }

    function retrieveColumnNames(id) {
        return self.contents[id][0];
    }

    function readFile(id, file) {
        if (window.FileReader) {
            var reader = new FileReader();

            reader.onload = function(event) {
                // Only parse csv files
                if (id != 'listOfVariables' && id != 'modelFormula') {
                    self.contents[id] = event.target.result.match(/[^\r\n]+/g)
                    .map(function(line) {
                        return line.split(',').map(function(element) {
                            return element;
                        });
                    });
                }
            }

            if (file)
                reader.readAsText(file);
        }
    }

    function submit(id, sections) {
        console.log(id, sections);

        var requiresFile = id != 'listOfVariables' && id != 'modelFormula';

        sections[id].validated = true;

        if (requiresFile && !sections[id].filePath) {
            modal.errorDialog('No Input', 'Please upload a file for this section');
            sections[id].validated = false;
        }

        if (requiresFile && self.contents[id] && self.contents[id][0].join() != sections[id].columnNames.join()) {
            modal.errorDialog('Validation Error', 'Column headers do not match template');
            sections[id].validated = false;
        }

        resource('/absoluteRiskRest/validate')
            .save(JSON.stringify({ 'id': id, 'filePaths': retrieveFilePaths(sections)}), onSuccess, onError);

        function onSuccess(response) {
            console.log('Validation results', response);

            error = JSON.parse(response.error)
            if (error.length) {
                sections[id].validated = false;
                modal.errorDialog('Validation Error', error);
            }

            if (sections[id].validated)
                root.$broadcast('nextSection', id);
        }

        function onError(response) {
            console.log('Server Error', response);
            sections[id].validated = false;
        }
    }

    function retrieveFilePaths(sections) {
        var filepaths = {};
        for (key in sections)
            filepaths[key] = sections[key]['filePath'];

        return filepaths;
    }
}]);
