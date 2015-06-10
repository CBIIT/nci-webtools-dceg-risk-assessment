// definitions used for display
var definitionObj = {
<<<<<<< HEAD
    prob_m: {
=======
    mPlus: {
>>>>>>> 0a4aadb7a519de702431db92b6ad267cd86a90c4
        term: "Marker Positivity (M+)",
        definition: "Positive test result for biomarker"
    },
    m_neg: {
        term: "Marker Negativity (M-)",
        definition: "Negative test result for biomarker test"
    },
<<<<<<< HEAD
    prob_d: {
        term: "Disease Positive (D+)",
        definition: "Has disease"
    },
    d_neg: {
        term: "Disease Negative (D-)",
=======
    dPlus: {
        term: "Positive Probability of Disease (Disease Positive)",
        definition: "Has disease"
    },
    dMinus: {
        term: "Negative Probability of Disease (Disease Negative)",
>>>>>>> 0a4aadb7a519de702431db92b6ad267cd86a90c4
        definition: "Does not have disease"
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
    max_mrs: {
        term: "Maximum possible MRS for a disease with this prevalence",
        definition: "Maximum possible MRS for a disease with this prevalence"
    },
    q_spec: {
        term: "Quality of the specificity",
        definition: "Increase in specificity versus a random test, fixing test positivity"
    },
    q_sens: {
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
    ppv: {
        term: "Positive Predictive Value (PPV)",
        definition: "Probability of disease, given a positive test result from biomarker.  Unlike sensitivity " +
        "and specificity, PPV's reflect disease prevalence and is useful for risk stratification."
    },
    npv: {
        term: "Negative Predictive Value (NPV)",
        definition: "Definition for NPV"
    }
};