
if (document.URL.indexOf('www.cancer.gov') != -1)
    // production 
    var s_account='ncidceg-cancerepidemiologyandgenetics';
else 
    // non-production
    var s_account='ncidev';


function Analytics_CalculateRiskConversionEvent()
{

    // Send calculate risk conversion event to Omniture
    // This function works in conjunction with the 
    // s_code.js used by Cancer.gov
    s=s_gi(s_account);
    s.linkTrackVars = 'events';
    s.linkTrackEvents='event15';
    s.events='event15';
    s.tl(this,'o','RiskAssessmentCalculation');

}
