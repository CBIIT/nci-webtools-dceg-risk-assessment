@set PATH=C:\Program Files\TortoiseSVN\bin;%PATH%

rmdir ccrat_tmp /s /q
svn export https://ncisvn.nci.nih.gov/svn/oce_dev/Products/RiskAssessmentTools/CCRAT/branches/rats-oceother-39/CCRAT.Web/ ccrat_tmp\

robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ analytics_include.html
robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ CCRAT.master
robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ DefPop.Master
robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ NewCCRAT.master
robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ PopEmail.aspx
robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ Popup.Master
robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ printresults.aspx
robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ Result.aspx
robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ ScriptDisabled.aspx
robocopy ccrat_tmp\ E:\Content\RiskAssessmentTools\CCRAT\ tool.aspx
robocopy ccrat_tmp\images\ E:\Content\RiskAssessmentTools\CCRAT\images\ ccrat-banner.jpg
robocopy ccrat_tmp\images\ E:\Content\RiskAssessmentTools\CCRAT\images\ ccrat-logo-color.png
robocopy ccrat_tmp\images\ E:\Content\RiskAssessmentTools\CCRAT\images\ exit-icon.png
robocopy ccrat_tmp\style\ E:\Content\RiskAssessmentTools\CCRAT\style\ ccrat-style.css
robocopy ccrat_tmp\UserControls\ E:\Content\RiskAssessmentTools\CCRAT\UserControls\ QuickLinks.ascx

rmdir ccrat_tmp /s /q
