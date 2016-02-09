angular.module('Arc')
.factory('SectionService', ['DataService', 'ModalService', function(data, modal) {

    var self = this;

    return {
        getExampleFile:         getExampleFile,
        getUploadedFile:        getUploadedFile,
        getUploadedFileName:    getUploadedFileName,
        downloadFile:           downloadFile,
        viewTemplate:           viewTemplate,
        submitSection:          submitSection
    }

    function getUploadedFileName(id) {
        return data.getSection(id).uploadedFileName.substring(16);
    }

    function getExampleFile(id) {
        data.downloadFile(id + '.csv&example');
    }

    function downloadFile(id) {
        data.downloadFile(data.getSection(id).filePath);
    }

    function getUploadedFile(id) {
        var filename = data.getSection(id).uploadedFileName;
        if (filename) data.downloadFile(filename);
    }

    function viewTemplate(id) {
        var section = data.getSection(id);
        modal.csvDialog(id, section.columnNames, section.rowNames || null);
    }

    function submitSection(id) {
        data.submitSection(id);
    }



}]);
