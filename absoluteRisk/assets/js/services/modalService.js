angular.module('Arc')
.factory('ModalService', ['$uibModal', function(modal) {
    var self = this;

    return {
        csvDialog: csvDialog,
        errorDialog: errorDialog,
        generateTemplate: generateTemplate,
        downloadCSV: downloadCSV
    }

    function csvDialog(id, columnNames, rowNames) {
        modal.open({
            templateUrl: 'templates/csvModal.html',
            controllerAs: 'modal',
            controller: ['$uibModalInstance', function(modalInstance) {
                var self = this;

                self.columnNames = columnNames;
                self.rowNames = rowNames;

                self.download = function() {
                    var contents = generateTemplate(columnNames, rowNames);
                    downloadCSV(contents, id + 'Template.csv');
                }

                self.close = function() {
                    modalInstance.dismiss(0);
                }
            }]
        });
    }

    function errorDialog(id, contents) {
        modal.open({
            templateUrl: 'templates/errorModal.html',
            controllerAs: 'modal',
            controller: ['$uibModalInstance', function(modalInstance) {
                var self = this;
                self.id = id;
                self.contents = contents;

                self.close = function() {
                    modalInstance.dismiss(0);
                }
            }]
        });
    }

    function generateTemplate(columnNames, rowNames) {
        var template = [];
        template.push(columnNames);

        if (rowNames)
            rowNames.forEach(function (rowName) {
                var rowLength = columnNames.length - 1;
                var row = [rowName].concat(new Array(rowLength));
                template.push(row);
            });

        // convert array to csv string
        return template.map(function(line) {
            return line.join(',')
        }).join('\n');
    }

    function downloadCSV(content, filename) {
        var link = document.createElement('a');
        var blob = new Blob([content], { 'type': 'text/csv;charset=utf-8;' });

        // Chrome/Firefox
        if (link.download !== null) {
            var url = URL.createObjectURL(blob);
            link.setAttribute('href', url);
            link.setAttribute('download', filename);
            link.style = 'visibility:hidden';
        }

        // IE 10+
        if (navigator.msSaveBlob) {
            link.addEventListener('click', function (event) {
                navigator.msSaveBlob(blob, filename);
            }, false);
        }

        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}]);
