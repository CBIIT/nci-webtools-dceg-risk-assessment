angular.module('Arc')
.factory('UtilityService', ['DataService', function(data) {

    return {
        parseFormula:               parseFormula,
        generateFormula:            generateFormula,
        generateFormulaTemplate:    generateFormulaTemplate,
        generateLogOddsRatios:      generateLogOddsRatios,
    }

    /**
        Returns an array of formula terms representing the formula model
    */
    function parseFormula() {

        var listOfVariables = data.getSection('listOfVariables');
        var formulaString = data.getSection('modelFormula').model;
        console.log(listOfVariables, formulaString);

        if (!formulaString || typeof formulaString != 'string') return;

        /* ------ Initialize Variables ------ */

        // splits the formula into terms
        var terms = formulaString.split(/\s*[~]\s*/)[1].split(/\s*[+]\s*/);

        // retrieves only variable names
        var variables = listOfVariables.model.map(function(variable) {
            return variable.name;
        });

        // an array of formula terms representing the formula model
        var formula = [];

        // an array of strings representing linear terms
        var linearTerms = [];

        // an array of strings representing interaction terms
        var interactionTerms = {};


        /* ------ Build Model ------ */

        // attempt to split each term to determine if it's linear
        terms.forEach(function(term) {
            var splitTerm = term.split(/\s*[*]\s*/);

            // if this term is linear, add it to the array of linear terms
            if (splitTerm.length == 1) {
                linearTerms.push(removeFactor(term));
            }

            // else, this is an interaction term - add it to the array of interaction terms
            else {
                var name = removeFactor(splitTerm[0]);
                var interaction = removeFactor(splitTerm[1]);

                // if there was not a previously existing interaction term, create a new array
                if (interactionTerms[name] == null) {
                    interactionTerms[name] = [];
                }

                interactionTerms[name].push(interaction);
            };
        });

        // create the formula model
        // using the list of variable names as keys to look up the properties for each term
        variables.forEach(function(term) {
            formula.push({
                'name': term,
                'linear': linearTerms.indexOf(term) != -1,
                'interaction': interactionTerms[term] || null
            });
        });

        return formula;
    };

    /**
    	Converts model data to a formula string
    */
    function generateFormula() {

        var listOfVariables = data.getSection('listOfVariables').model;
        var formulaModel = data.getSection('modelFormula').array;

        if (!formulaModel || !listOfVariables instanceof Array) return;

        // ------ Initialize Variables ------ //

        // an array of strings representing linear terms
        var terms = [];

        // an array of strings representing interaction terms
        var interactionTerms = [];

        // retrieves only variable names
        var variables = listOfVariables.map(function(variable) {
            return variable.name;
        });


        /* ------ Initialize Internal Functions ------ */

        var factor = function(term) {
            return addFactor(term, listOfVariables);
        }

        var isLinear = function(term) {
            for (var i = 0; i < formulaModel.length; i ++)
                if (term == formulaModel[i].name && formulaModel[i].linear)
                    return true;

            return false;
        }

        // ------ Build Model ------ //

        formulaModel.forEach(function(term) {
            // if this term is linear add it to the array of linear terms
            if (term['linear']) {
                terms.push(factor(term.name));

                // look for any interaction terms
                var interactions = term['interaction'];

                if (interactions != null) {

                    // convert single values to arrays with one value and update the reference
                    if (!Array.isArray(interactions)) {
                        term['interaction'] = [interactions];
                        interactions = term['interaction'];
                    }

                    // for each value in the array, if the interaction is within the list of variables
                    // add it to the array of interactions
                    interactions.forEach(function(interaction) {
                        if (variables.indexOf(interaction) != -1 && isLinear(interaction)) {
                            interactionTerms.push(factor(term['name']) + "*" + factor(interaction))
                        }
                    });
                }
            }
        });

        // concatenate the linear terms and interactions
        return "Y ~ " + terms.concat(interactionTerms).join(" + ");
    };

    /**
    	Generates a default formula model template from a list of variables
    	Parameter:	The default linear state for all terms
    	Returns:	An array of formula terms representing the formula model
    */
    function generateFormulaTemplate(linear) {
        if (data.getSection('listOfVariables').model instanceof Array)
            return data.getSection('listOfVariables').model.map(function(variable) {
                return {
                    name: variable.name,
                    linear: linear,
                    interaction: null
                }
            });
    }

    /**
    	Generates log odds ratios
    	Returns an array of strings containing the log odds ratios
    */

    function generateLogOddsRatios() {
        var listOfVariables = data.getSection('listOfVariables').model;
        var formulaModel = data.getSection('modelFormula').array;

        /* ------ Initialize Internal Functions ------ */

        var factor = function(term) {
            return addFactor(term, listOfVariables);
        }

        // generates the levels for each term
        var generateLevels = function(term, variables) {

            // if this term is a factor
            if (variables[term]['type'] == 'factor') {

                // if no reference level is provided, the first value in the array of levels is used instead

                if (variables[term]['ref'] == null) {
                    variables[term]['ref'] = variables[term]['levels'][0];
                }

                var ref = variables[term]['ref'];

                // remove the reference term from the levels
                var index = variables[term]['levels'].indexOf(ref);

                var variableLevels = variables[term]['levels'].slice(0);
                variableLevels.splice(index, 1);

                // create the array of levels for a term
                var levels = [];
                variableLevels.forEach(function(level) {
                    levels.push(factor(term) + level);
                });

                return levels;
            } else return [term];
        }

        /* ------ Initialize Variables ------ */

        // an object representing the list of variables
        // as mapped to variable names
        var variables = {};
        listOfVariables.forEach(function(variable) {

            variables[variable.name] = {
                type: variable.type,
                levels: variable.levels,
                ref: variable.ref
            };
        });

        // array of formula term names
        var terms = [];

        // the array of interactions - each entry
        // is an object where the key is the term name
        // and the value is the array of interaction terms
        var interactions = [];
        formulaModel.forEach(function(term) {

            // if (term.linear)
            terms.push(term.name);

            if (term.interaction != null) {

                interaction = {};
                interaction[term.name] = term.interaction;
                interactions.push(interaction);
            }
        });

        /* ------ Build Model ------ */

        // an array of strings containing the log odds ratios
        var logOdds = [];

        // add linear terms
        terms.forEach(function(term) {
            logOdds = logOdds.concat(generateLevels(term, variables));
        });

        // add interaction terms
        interactions.forEach(function(interaction) {

            // get the term's name
            var term = Object.keys(interaction)[0];

            // get the levels for this term
            var termLevels = generateLevels(term, variables);

            // for each of this term's interactions
            interaction[term].forEach(function(interactionTerm) {

                // find the interaction levels
                var interactionLevels = generateLevels(interactionTerm, variables)

                // append each term level and interaction level to the log odds array
                interactionLevels.forEach(function(interactionLevel) {
                    termLevels.forEach(function(termLevel) {
                        logOdds.push(termLevel + ":" + interactionLevel);
                    });
                });
            });
        });

        return logOdds;
    }

    /* ------ Initialize Helper Functions ------ */

    // removes the as.factor() string from a term
    function removeFactor(term) {

        // attempt to find matched parenthesis
        var factor = term.match(/\(([^)]+)\)/);

        // if found, return contents
        if (factor)
            return factor[1];

        return term;
    }

    // adds the as.factor() string to a term if it's a factor
    function addFactor(term, listOfVariables) {

        listOfVariables.forEach(function (variable) {
            if (term == variable.name && 'factor' == variable.type)
                term = 'as.factor(' + term + ')';
        });

        return term;
    }

}]);
