@set PATH=C:\Program Files\TortoiseSVN\bin;%PATH%

rmdir mrat_tmp /s /q
svn export https://ncisvn.nci.nih.gov/svn/oce_dev/Products/RiskAssessmentTools/MRAT/branches/rats-oceother-39/ mrat_tmp\

robocopy mrat_tmp\MRAT.Mobile\ E:\Content\RiskAssessmentTools\MRATMobile\ MRATMobile.Master
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ about-tool.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ analytics_include.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ analytics_MRAT.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ code-conditions.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ "def-UVB radiation.html"
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ def-UVA.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ "def-Ultraviolet (UV) radiation.html"
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ def-Transplantation.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ def-Sunscreen.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ "def-squamous cell carcinoma.html"
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ "def-risk factors.html"
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ "def-Immune System.html"
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ "def-basal cell carcinoma.html"
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ def-ah.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ default.aspx
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ dlink.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ documentation.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ download-pda-software.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ download-source-code.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ installation-instructions.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ melanoma-cancer-risk.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ mobile-access.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ mobile-terms-conditions.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ popup.html
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ QuickLinks.ascx
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ results_f.aspx
robocopy mrat_tmp\MRAT.Web\ E:\Content\RiskAssessmentTools\MRAT\ results_m.aspx
robocopy mrat_tmp\MRAT.Web\images\ E:\Content\RiskAssessmentTools\MRAT\images\ exit-icon.png
robocopy mrat_tmp\MRAT.Web\images\ E:\Content\RiskAssessmentTools\MRAT\images\ iphone-about.png
robocopy mrat_tmp\MRAT.Web\images\ E:\Content\RiskAssessmentTools\MRAT\images\ mrat-banner-old.jpg
robocopy mrat_tmp\MRAT.Web\images\ E:\Content\RiskAssessmentTools\MRAT\images\ mrat-banner.jpg
robocopy mrat_tmp\MRAT.Web\images\ E:\Content\RiskAssessmentTools\MRAT\images\ mrat-logo-color.png
robocopy mrat_tmp\MRAT.Web\style\ E:\Content\RiskAssessmentTools\MRAT\style\ mrat-style.css

rmdir mrat_tmp /s /q