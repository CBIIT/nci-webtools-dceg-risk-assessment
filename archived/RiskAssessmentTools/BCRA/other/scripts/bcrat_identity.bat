@set PATH=C:\Program Files\TortoiseSVN\bin;%PATH%

rmdir bcrat_tmp /s /q
svn export https://ncisvn.nci.nih.gov/svn/oce_dev/Products/RiskAssessmentTools/BCRA/branches/rats-oceother-39/ bcrat_tmp\

robocopy bcrat_tmp\BCRA.Mobile\ E:\Content\RiskAssessmentTools\BCRAMobile\ MasterPage.master
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA analytics_include.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA BCRA.master
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA def-ah.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA def-biopsy.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA def-brca1.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA def-brca2.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA def-dcis-lcis.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA def-dcis.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA def-ibc.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA def-lcis.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA def-menst.html
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA PopEmail.aspx
robocopy bcrat_tmp\BCRA.Web\ E:\Content\RiskAssessmentTools\BCRA QuickLinks.ascx
robocopy bcrat_tmp\BCRA.Web\Images\ E:\Content\RiskAssessmentTools\BCRA\Images\ bcrat-banner.jpg
robocopy bcrat_tmp\BCRA.Web\Images\ E:\Content\RiskAssessmentTools\BCRA\Images\ bcrat-logo-color.png
robocopy bcrat_tmp\BCRA.Web\Images\ E:\Content\RiskAssessmentTools\BCRA\Images\ exit-icon.png
robocopy bcrat_tmp\BCRA.Web\StyleSheets\ E:\Content\RiskAssessmentTools\BCRA\StyleSheets\ bcra-style.css

rmdir bcrat_tmp /s /q
