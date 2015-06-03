// definitions used for display
var definitionObj = {
    mPlus: {
        term: "Marker Positivity (M+)",
        definition: "Definition for M plus"
    },
    mMinus: {
        term: "Marker Negativity (M-)",
        definition: "Definition for M minus"
    },
    dPlus: {
        term: "Positive Probability of Disease (Disease Positive)",
        definition: "Definition for Disease Positive"
    },
    dMinus: {
        term: "Negative Probability of Disease (Disease Negative)",
        definition: "Definition for Disease Negative"
    },
    danger: {
        term: "Danger",
        definition: "Increase in disease risk from testing positive"
    },
    reassurance: {
        term: "Reassurance",
        definition: "Reduction in disease risk from testing negative"
    },
    pbs: {
        term: "Population Burden Stratification",
        definition: "Extra disease detection in positive group than negative group"
    },
    nnr: {
        term: "Number Needed to Recruit",
        definition: "To detect 1 more disease case in positive group than negative group"
    },
    maxMRS: {
        term: "Maximum possible MRS for a disease with this prevalence",
        definition: "Maximum possible MRS for a disease with this prevalence"
    },
    qSpec: {
        term: "Quality of the specificity",
        definition: "Increase in specificity versus a random test, fixing test positivity"
    },
    qSens: {
        term: "Quality of the sensitivity",
        definition: "Increase in sensitivity versus a random test, fixing test positivity"
    },
    spec: {
        term: "Specificity",
        definition: "Specificity is the proportion whose biomarker test is negative (below the threshold) among" +
        " those without disease."
    },
    sens: {
        term: "Sensitivity",
        definition: "Sensitivity is the proportion whose biomarker test is positive (above the threshold) among " +
        "those who are positive for disease."
    },
    ppv : {
        term : "Positive Predictive Value (PPV)",
        definition : "Probability of disease, given a positive test result from biomarker.  Unlike sensitivity " +
        "and specificity, PPV's reflect disease prevalence and is useful for risk stratification."
    },
    npv : {
        term : "Negative Predictive Value (NPV)",
        definition : "Definition for NPV"
    }
};