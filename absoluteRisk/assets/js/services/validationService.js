angular.module('Arc')
.factory('ValidationService', ['$rootScope', '$resource', 'ModalService', 'DataService', 'UtilityService',
function(root, resource, modal, data, utility) {

    var self = this;

    return {
        submit:             submit,
        readFile:           readFile,
        rowNames:           rowNames,
        columnNames:        columnNames,
        isValidated:        isValidated,
        setExpectedRows:    setExpectedRows,
        setExpectedColumns: setExpectedColumns,
    };

    function readFile(id, file, callback) {
        if (window.FileReader) {
            var reader = new FileReader();

            reader.onload = function(event) {
                section = data.getSection(id);

                section.filename = file.name;
                section.model = event.target.result.match(/[^\r\n]+/g)
                    .map(function(line){return line.split(',')});

                callback();
                root.$apply();
            }

            if (file)
                reader.readAsText(file);
        }
    }

    function submit(id) {
        var section = data.getSection(id);
        section.validated = true;

        // Verify that a file has been uploaded
        if (id != 'listOfVariables' && id != 'modelFormula' && section.model == null) {
            modal.dialog('Validatation Error', 'Please upload a file for this section');
            section.validated = false;
        }

        // Validate column names
        if (section.model != null && section.columnNames
            && section.columnNames.join() != columnNames(id).join()) {
            modal.dialog('Validation Error', 'Column headers do not match template');
            section.validated = false;
        }

        // Validate row length
        if (section.model != null && section.columnNames && rowNames(id).length < 1) {
            modal.dialog('Validation Error', 'This file is invalid.');
            section.validated = false;
        }

        // Individual validation rules
        if (section.validated) {
            switch(id) {
                case 'listOfVariables':
                    var error = {name: false, levels: false, ref: false};
                    section.model.forEach(function(variable) {
                        if (!error.name)
                            error.name = variable.name.length == 0;

                        if (!error.levels)
                            error.levels = variable.type == 'factor' && (!variable.levels || variable.levels.length == 0);

                        if (!error.ref)
                            error.ref = variable.ref && variable.levels && variable.levels.indexOf(variable.ref) == -1;
                    });

                    if (error.name)
                        modal.dialog('Validation Error', 'Each variable must have a valid name.');

                    else if (error.levels)
                        modal.dialog('ValidationError', 'Levels must be specified for factors.');

                    else if (error.ref)
                        modal.dialog('Validation Error', 'If provided, the referent level must be contained in the levels field for each variable.');

                    break;

                case 'modelFormula':
                    var variables = data.getSection('listOfVariables').model.map(function(variable) {
                        return variable.name;
                    });

                    var terms = data.getSection(id).array.map(function(term) {
                        return term.name;
                    });

                    var error = {term: false};
                    terms.forEach(function(term) {
                        if (!error.term)
                            error.term = variables.indexOf(term) == -1;
                    });

                    if (error.term)
                        modal.dialog('Validation Error', 'The model formula contains terms not provided in the list of variables.');

                    break;

                case 'riskFactorDistribution':
                    var columns = columnNames(id);
                    var rows = rowNames(id);
                    var variables = data.getSection('listOfVariables').model;

                    var error = {na: false, levels: false};
                    var errorRow = 0;

                    for (var i = 0; i < columns.length; i ++) {
                        var columnName = columns[i];
                        var levels = variables[i].levels || ['1', '0'];

                        var col = getColumn(id, i);
                        var counter = 0;

                        col.forEach(function(level) {
                            counter ++;
                            if (!error.na)
                                error.na = (level == 'NA');

                            if (!error.levels) {
                                error.levels = (levels.indexOf(level) == -1 ? columnName : false);
                                errorRow = counter;
                            }
                        });
                    }

                    if (error.na)
                        modal.dialog('Validation Error', 'The referent distribution model must not contain any NA values.');

                    if (error.levels)
                        modal.dialog('Validation Error', 'The referent distribution model categorical value (' + error.levels + ', row ' + (errorRow + 2) + ') has levels ouside those provided in the model covariates.');

                    if (rows.length < 200)
                        modal.dialog('Validation Warning', 'Samples in referent distribution model should be large.  Currently only size ' + rows.length);

                    break;

                case 'logOddsRatios':
                    if (rowNames(id).join() != data.getSection(id).rowNames.join()) {
                        section.validated = false;
                        modal.dialog('Validation Error', 'The row names must match names and order in design matrix.');
                    }
                    break;

                case 'diseaseIncidenceRates':
                case 'mortalityIncidenceRates':
                    var columns = columnNames(id);
                    var ages = getColumn(id, 0);
                    var rates = getColumn(id, columns.length - 1);

                    var error = {ages: false, rates: false}

                    ages.forEach(function(age) {
                        if (!error.ages)
                            error.ages = parseInt(age) != parseFloat(age);
                    });

                    rates.forEach(function(rate) {
                        if (!error.rates)
                            error.rates = rate < 0 || rate > 1;
                    })

                    if (error.ages)
                        modal.dialog('Validation Error', 'The first column of the provided input should be integer ages.');
                    if (error.rates)
                        modal.dialog('Validation Error', 'The rates should be probabilities between 0 and 1.');
                    break;

                case 'snpInformation':
                    var error = {parse: false}
                    for (var i = 1; i < columnNames(id).length; i ++)
                        for (var j = 1; j <= rowNames(id).length; j ++)
                            if (!parseFloat(section.model[j][i]))
                                error.parse = true;

                    if (error.parse)
                        modal.dialog('Validation Error', 'Please ensure that only numeric data has been provided.')

                    break;

                case 'riskFactorForPrediction':
                var columns = columnNames(id);
                var rows = rowNames(id);
                var variables = data.getSection('listOfVariables').model;

                var error = {na: false, levels: false};
                var errorRow = 0;

                for (var i = 0; i < columns.length; i ++) {
                    var columnName = columns[i];
                    var levels = variables[i].levels || ['1', '0'];
                    levels = levels.concat('NA');

                    var col = getColumn(id, i);
                    var counter = 0;

                    col.forEach(function(level) {
                        counter ++;
                        if (!error.levels) {
                            error.levels = (levels.indexOf(level) == -1 ? columnName : false);
                            errorRow = counter;
                        }
                    });
                }

                if (error.levels)
                    modal.dialog('Validation Error', 'The categorical value (' + error.levels + ', row ' + (errorRow + 2) + ') has levels ouside those provided in the model covariates.');

                break;

                case 'genotypesForPrediction':
                    var genotypesLength = rowNames(id).length;
                    var riskFactorsLength = rowNames('riskFactorForPrediction').length;
                    var columns = columnNames(id);

                    var error = {lengths: false, column: false};
                    error.lengths = genotypesLength != riskFactorsLength;

                    for (var i = 0; i < columns.length; i ++) {
                        var columnName = columns[i];
                        var values = ['0', '1', '2', 'NA'];

                        var column = getColumn(id, i);
                        column.forEach(function(value) {
                            if (!error.column)
                                error.column = (values.indexOf(value) == -1) ? columnName : false;
                        });
                    }

                    if (error.lengths)
                        modal.dialog('Validation Error', 'The genotypes for prediction and the covariates for prediction must have the same number of rows.');

                    if (error.column)
                        modal.dialog('Validation Error', 'Observed SNP data must be coded either 0, 1, 2, or NA. Please confirm that the data for (' + error.column + ') fulfills these requirements.');
                    break;

                case 'ageInterval':

                    break;
            }
        }

        for (key in error)
            if (error[key])
                section.validated = false;

        root.$broadcast('nextSection', id);
    }

    function setExpectedColumns(id) {

        var section = data.getSection(id);
        var variables = data.getSection('listOfVariables').model.map(function(variable) {
            return variable.name;
        });


        switch(id) {
            case 'riskFactorDistribution':
                section.columnNames = variables;
                break;

            case 'logOddsRatios':
                section.columnNames = ['Variables', 'Log Odds Ratios'];
                break;

            case 'diseaseIncidenceRates':
            case 'mortalityIncidenceRates':
                section.columnNames = ['Age (Integer), Rate'];
                break;

            case 'snpInformation':
                section.columNames = ['snp.name', 'snp.odds.ratio', 'snp.freq'];
                break;

            case 'riskFactorForPrediction':
                section.columnNames = variables;
                break;

            case 'genotypesForPrediction':
                section.columnNames = rowNames('snpInformation');
                break;

            case 'ageInterval':
                section.columnNames = ['Age', 'Age Interval'];
                break;
        }
    }

    function setExpectedRows(id) {
        var section = data.getSection(id);

        switch(id) {
            case 'logOddsRatios':
                section.rowNames = utility.generateLogOddsRatios();
                break;
            default:
                break;
        }
    }

    function rowNames(id) {
        return column(id, 0);
    }

    function columnNames(id) {
        return data.getSection(id).model[0];
    }

    function getColumn(id, index) {
        return column(id, index);
    }

    function column(id, index) {
        var column = data.getSection(id).model.map(function(col) { return col[index] });
        return column.slice(1);
    }

    function isValidated(id) {
        console.log('is validated? ', id);
        return true;
//        return data.getSection(id).validated;
    }
}]);
