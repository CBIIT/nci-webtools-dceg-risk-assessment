using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using CCRAT.Mobile;
using CCRAT.RiskCalculator;
using Common.Utils;

namespace CCRAT.Mobile.UserControls
{

    /// <summary>
    /// QuestionAsker class
    /// </summary>
    public partial class QuestionAsker : System.Web.UI.UserControl 
    {      
        #region private members

        private static readonly object CalculateRiskEvent = new object();

        private bool IsQuestionAnswered(QuestionControl qc)
        {
            return (!string.IsNullOrEmpty(qc.Answer) && qc.Answer.ToUpper() != "NAN");
        }

        private void FillSmokeStart()
        {
            int? currentAge = null;

            try
            {
                currentAge = Int32.Parse(qcCurrentAge.Answer);
            }
            catch { }

            if (currentAge != null)
            {
                string prevSelectedValue = ddlStartSmoke.SelectedValue;

                ddlStartSmoke.Items.Clear();

                ddlStartSmoke.Items.Add(new ListItem("Select", "NAN"));
                ddlStartSmoke.Text = "NAN";
                //ddlStartSmoke.Items.Add(new ListItem("I have never smoked cigarettes regularly", "NeverSmoke"));
                ddlStartSmoke.Items.Add(new ListItem("Never", "NeverSmoke"));

                for (int i = 6; i <= currentAge; i++)
                {
                    ddlStartSmoke.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                ddlStartSmoke.SelectedIndex = ddlStartSmoke.Items.IndexOf(ddlStartSmoke.Items.FindByValue(prevSelectedValue));
            }
            else
            {
                ddlStartSmoke.Items.Clear();

                ddlStartSmoke.Items.Add(new ListItem("Select", "NAN"));
                ddlStartSmoke.Text = "NAN";
                //ddlStartSmoke.Items.Add(new ListItem("I have never smoked cigarettes regularly", "NeverSmoke"));
                ddlStartSmoke.Items.Add(new ListItem("Never", "NeverSmoke"));
            }
        }

        private void FillSmokeQuit()
        {
            int? currentAge = null;

            try
            {
                currentAge = Int32.Parse(qcCurrentAge.Answer);
            }
            catch { }

            int? startAge = null;

            try
            {
                if (!string.IsNullOrEmpty(qcStartSmoke.Answer))
                    startAge = Int32.Parse(qcStartSmoke.Answer);
            }
            catch { }

            if (currentAge != null && startAge != null)
            {

                string prevSelectedValue = ddlSmokeQuit.SelectedValue;

                ddlSmokeQuit.Items.Clear();

                ddlSmokeQuit.Items.Add(new ListItem("Select", "NAN"));
                ddlSmokeQuit.Text = "NAN";

                for (int i = startAge.Value; i <= currentAge; i++)
                {
                    ddlSmokeQuit.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
                
                //retain previously selected value
                ddlSmokeQuit.SelectedIndex = ddlSmokeQuit.Items.IndexOf(ddlSmokeQuit.Items.FindByValue(prevSelectedValue));
               
            }
            else
            {
                ddlSmokeQuit.Items.Clear();
                ddlSmokeQuit.Items.Add(new ListItem("Select", "NAN"));
                ddlSmokeQuit.Text = "NAN";
            }
        }

        private void MoveToQuestionGroup(QuestionGroup group)
        {
            qgm.CurrentQuestionGroup = group.QuestionGroupNum;
        }

        private void MoveToNextQuestionGroup()
        {
            qgm.CurrentQuestionGroup++;
        }

        private void SkipToFirstGenderSection()
        {
            if (qcGender.Answer == "Male")
                MoveToQuestionGroup(qg100MoreCigs);
            else if (qcGender.Answer == "Female")
                MoveToQuestionGroup(qgStillHavePeriods);
        }

        private bool IsCurrentQuestionGroup(QuestionGroup qg)
        {
            return (qgm.CurrentQuestionGroup == qg.QuestionGroupNum);
        }

        private void SetPercentageComplete()
        {
            if(IsCurrentQuestionGroup(qgHispanic))
            //if (IsCurrentQuestionGroup(qgRace))
                pc.InnerHtml = "0% Complete";
            else if(this.DisplayMode ==  QuestionDisplayModes.Results)
                pc.InnerHtml = "100% Complete";
            else
                pc.InnerHtml = string.Format("{0:f0}% Complete", ((double)qgm.CurrentQuestionGroup / (double)(qgm.QuestionGroups.Count + 1)) * 100.0);
        }

        #endregion private members

        #region protected members
        protected void Page_Load(object sender, EventArgs e)
        {
            phExplanation.Visible = false;
            phResultEx.Visible = false;
            res.Visible = false;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if(this.DisplayMode == QuestionDisplayModes.QuestionExplanation)
            {
                if (qgm.CurrentQuestionGroupControl != null && qgm.CurrentQuestionGroupControl.Questions.Length > 0)
                {
                    pExplnation.InnerHtml = qgm.CurrentQuestionGroupControl.Questions[0].ExplanationText;
                }
            }
            else if (this.DisplayMode == QuestionDisplayModes.Questioning)
            {
                SetPercentageComplete();
                if (qgm.CurrentQuestionGroupControl.Questions.Length == 0)
                {
                    this.DisplayMode = QuestionDisplayModes.SectionHeader;
                    divQex.Visible = false;
                }
            }
        }

        /// <summary>
        /// This is the callback for any selection changes.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void UpdateQuestions(object sender, EventArgs e)
        {
            qgm.RefreshQuestions((Control)sender);
        }

        /// <summary>
        /// This is the callback for the back buttons from the explanation pages
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RedrawCurrentQuestion(object sender, EventArgs e)
        {
            qgm.RedrawQuestions();
        }

        /// <summary>
        /// Draws next question group
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void DrawNextQuestion(object sender, EventArgs e)
        {
            qgm.CurrentQuestionGroup++;
            qgm.RedrawQuestions();
        }

        protected void RedrawResults(object sender, EventArgs e)
        {
            this.DisplayMode = QuestionDisplayModes.Results;
            CalculateRisks();
            
        }

        #region Validate Callbacks
        
        //These are callbacks that set the answer of a QuestionControl if it is not a DropDownList
        //or it has some special rules for checking if the question has been answered.

        protected void qcHispanicValidate(object sender, EventArgs e)
        {     
            /*if (rdoNonHispanic.Checked == true)
                ((QuestionControl)sender).Answer = "No";
            else
            {
                ((QuestionControl)sender).Answer = string.Empty; //Make sure we set the answer so we can error on Yes.
                Response.Redirect("default.aspx");
            }*/
        }

        protected void qcRaceValidate(object sender, EventArgs e)
        {
            if (ddlRace.SelectedValue == "White")
                ((QuestionControl)sender).Answer = ddlRace.SelectedValue;
            else
            {
                ((QuestionControl)sender).Answer = string.Empty; //Make sure we set the answer so we can error on non-whites.
                Response.Redirect("default.aspx");
            }
        }

        protected void qcHeightValidate(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlHF.Text) && !string.IsNullOrEmpty(ddlHI.Text))
            {
                try
                {
                    int feet = Int32.Parse(ddlHF.Text);
                    int inches = Int32.Parse(ddlHI.Text);

                    int height = (feet * 12) + inches;
                    ((QuestionControl)sender).Answer = height.ToString();
                }
                catch { }
            }
        }

        protected void qcWeightValidate(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(txtWeight.Text))
                {
                    double weight = Convert.ToDouble(txtWeight.Text);
                    if (weight < 1000)
                        ((QuestionControl)sender).Answer = weight.ToString();
                    else
                        ((QuestionControl)sender).Answer = string.Empty;
                }
                else
                    ((QuestionControl)sender).Answer = string.Empty;
            }
            catch 
            {
                //System.Diagnostics.Debug.Assert(false, "Exception inside qcWeightValidate");
            }
        }

        #endregion
        
        #region Redraw and QuestionGroupAnswered Callbacks

        // Redraw callbacks determine if the question group should show or not.
        // The default behavior for a question group is to show it if the 
        // CurrentQuestionGroup >= QuestionGroup.QuestionGroupNum
        //
        // QuestionGroupAnswered callbacks determine what the next question should be.

        protected void qgHispanicAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgHispanic))
            {
                if (qcHispanic.Answer == "Yes" || !IsQuestionAnswered(qcHispanic))
                    MoveToQuestionGroup(qgCurrentAge);
                else
                    MoveToQuestionGroup(qgRace);
            }
            else if (IsCurrentQuestionGroup(qgRace))
            {
                if (qcHispanic.Answer != "Yes" || !IsQuestionAnswered(qcHispanic))
                    MoveToQuestionGroup(qgCurrentAge);
            }
        }

        protected void qgRaceRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcHispanic.Answer != "Yes" && IsQuestionAnswered(qcHispanic));
        }

        protected void qgGenderAnswered(object sender, EventArgs e)
        {
            //If male --> female, and currently asking male questions,
            //move to first female question.
            if (IsCurrentQuestionGroup(qg100MoreCigs)
                || IsCurrentQuestionGroup(qgStartSmoke)
                || IsCurrentQuestionGroup(qgStillSmoke)
                || IsCurrentQuestionGroup(qgSmokeQuit)
                || IsCurrentQuestionGroup(qgCigNumPerDay))
            {
                if (qcGender.Answer == "Female")
                    MoveToQuestionGroup(qgStillHavePeriods);
            }
            else if (IsCurrentQuestionGroup(qgGender))
            {
                MoveToNextQuestionGroup();
            }
        }

        protected void qgCurrentAgeAnswered(object sender, EventArgs e)
        {

            if (IsCurrentQuestionGroup(qgCurrentAge))
                MoveToNextQuestionGroup();

            FillSmokeStart();
            FillSmokeQuit();
        }

        protected void qgHeightAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgHeight))
                MoveToNextQuestionGroup();
        }

        protected void qgWeightAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgWeight))
                MoveToNextQuestionGroup();
        }

        protected void qgNumServingsVegAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgNumServingsVeg))
            {
                if (qcNumServingsVeg.Answer == "0" || !IsQuestionAnswered(qcNumServingsVeg))
                    MoveToQuestionGroup(qgColonoscopy);
                else
                    MoveToQuestionGroup(qgAmountVeg);
            }
            else if (IsCurrentQuestionGroup(qgAmountVeg))
            {
                if (qcNumServingsVeg.Answer == "0" || !IsQuestionAnswered(qcNumServingsVeg))
                    MoveToQuestionGroup(qgColonoscopy);
            }
        }

        protected void qgAmountVegRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcNumServingsVeg.Answer != "0" && IsQuestionAnswered(qcNumServingsVeg));
        }

        protected void qgColonoscopyAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgColonoscopy))
            {
                if (qcColonoscopy.Answer == "Yes")
                    MoveToQuestionGroup(qgHadPolyp);
                else
                    MoveToQuestionGroup(qgAsprin);
            }
            else if (IsCurrentQuestionGroup(qgHadPolyp))
            {
                if (qcColonoscopy.Answer != "Yes")
                    MoveToQuestionGroup(qgAsprin);
            }
        }

        protected void qgHadPolypRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcColonoscopy.Answer == "Yes");
        }

        protected void qgModerateActivitiesAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgModerateActivities))
            {
                if (qcModerateActivities.Answer != "0" && IsQuestionAnswered(qcModerateActivities))
                    MoveToQuestionGroup(qgModerateHours);
                else
                    MoveToQuestionGroup(qgVigorousActivities);
            }
            else if (IsCurrentQuestionGroup(qgModerateHours))
            {
                if (qcModerateActivities.Answer == "0" || !IsQuestionAnswered(qcModerateActivities))
                    MoveToQuestionGroup(qgVigorousActivities);
            }
        }

        protected void qcModerateHoursRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcModerateActivities.Answer != "0" && IsQuestionAnswered(qcModerateActivities));
        }

        protected void qgVigorousActivitiesAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgVigorousActivities))
            {
                if (qcVigorousActivities.Answer != "0" && IsQuestionAnswered(qcVigorousActivities))
                    MoveToQuestionGroup(qgVigorousHours);
                else
                    SkipToFirstGenderSection();
            }
            else if (IsCurrentQuestionGroup(qgVigorousHours))
            {
                if (qcVigorousActivities.Answer == "0" || !IsQuestionAnswered(qcVigorousActivities))
                    SkipToFirstGenderSection();
            }
        }

        protected void qcVigorousHoursRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcVigorousActivities.Answer != "0" && IsQuestionAnswered(qcVigorousActivities));
        }

        protected void qgVigorousHoursAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgVigorousHours))
                SkipToFirstGenderSection();
        }

        protected void qc100MoreCigsRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcGender.Answer == "Male");
        }

        protected void qg100MoreCigsAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qg100MoreCigs))
            {
                if (qc100MoreCigs.Answer == "Yes")
                    MoveToQuestionGroup(qgStartSmoke);
                else
                    MoveToQuestionGroup(qgHasRelativeHadCC);
            }
            else if (IsCurrentQuestionGroup(qgStartSmoke) || IsCurrentQuestionGroup(qgStillSmoke) || IsCurrentQuestionGroup(qgSmokeQuit) || IsCurrentQuestionGroup(qgCigNumPerDay))
            {
                if (qc100MoreCigs.Answer != "Yes")
                    MoveToQuestionGroup(qgHasRelativeHadCC);
            }
        }

        protected void qgStartSmokeRedraw(object sender, EventArgs e)
        {
            //Doublecheck that the age ranges are set correctly?????????
            ((QuestionGroup)sender).Visible = (qcGender.Answer == "Male" && qc100MoreCigs.Answer == "Yes");
        }

        protected void qgStartSmokeAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgStartSmoke))
            {
                if (IsQuestionAnswered(qcStartSmoke) && qcStartSmoke.Answer != "NeverSmoke")
                    MoveToQuestionGroup(qgStillSmoke);
                else
                    MoveToQuestionGroup(qgHasRelativeHadCC);
            }
            else if (IsCurrentQuestionGroup(qgStillSmoke) || IsCurrentQuestionGroup(qgSmokeQuit) || IsCurrentQuestionGroup(qgCigNumPerDay))
            {
                if (!IsQuestionAnswered(qcStartSmoke) || qcStartSmoke.Answer == "NeverSmoke")
                    MoveToQuestionGroup(qgHasRelativeHadCC);
            }

            FillSmokeQuit();
        }

        protected void qgStillSmokeRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcGender.Answer == "Male" //Male
                && qc100MoreCigs.Answer == "Yes" //Smoked more than 100
                && IsQuestionAnswered(qcStartSmoke) //Smoked Regularly
                && qcStartSmoke.Answer != "NeverSmoke" //Smoked Regularly
                );
        }

        protected void qgStillSmokeAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgStillSmoke))
            {
                if (qcStillSmoke.Answer == "No")
                    MoveToQuestionGroup(qgSmokeQuit);
                else
                    MoveToQuestionGroup(qgCigNumPerDay);
            }
            else if (IsCurrentQuestionGroup(qgSmokeQuit))
            {
                if (qcStillSmoke.Answer != "No")
                    MoveToQuestionGroup(qgCigNumPerDay);
            }

        }

        protected void qgSmokeQuitRedraw(object sender, EventArgs e)
        {
            //Check age drop down ???
            ((QuestionGroup)sender).Visible = (qcGender.Answer == "Male" //Male
                && qc100MoreCigs.Answer == "Yes" //Smoked more than 100
                && IsQuestionAnswered(qcStartSmoke) //Smoked Regularly
                && qcStartSmoke.Answer != "NeverSmoke" //Smoked Regularly
                && qcStillSmoke.Answer == "No" //No longer smokes
                );
        }

        protected void qgCigNumPerDayRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcGender.Answer == "Male" //Male
                && qc100MoreCigs.Answer == "Yes" //Smoked more than 100
                && IsQuestionAnswered(qcStartSmoke) //Smoked Regularly
                && qcStartSmoke.Answer != "NeverSmoke" //Smoked Regularly                
                );
        }

        protected void qgCigNumPerDayAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgCigNumPerDay))
                MoveToQuestionGroup(qgHasRelativeHadCC);
        }

        protected void qgStillHavePeriodsRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcGender.Answer == "Female");
        }

        protected void qgStillHavePeriodsAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgStillHavePeriods))
            {
                if (qcStillHavePeriods.Answer == "No")
                    MoveToQuestionGroup(qgLastCycle);
                else
                    MoveToQuestionGroup(qgHasRelativeHadCC);
            }
            else if (IsCurrentQuestionGroup(qgLastCycle) || IsCurrentQuestionGroup(qgUsedEstrogen))
            {
                if (qcStillHavePeriods.Answer != "No")
                    MoveToQuestionGroup(qgHasRelativeHadCC);
            }
        }

        protected void qgLastCycleRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcGender.Answer == "Female"
                && qcStillHavePeriods.Answer == "No"
                );
        }

        protected void qgLastCycleAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgLastCycle))
            {
                if (qcLastCycle.Answer == "GT2")
                    MoveToQuestionGroup(qgUsedEstrogen);
                else
                    MoveToQuestionGroup(qgHasRelativeHadCC);
            }
            else if (IsCurrentQuestionGroup(qgUsedEstrogen))
            {
                if (qcLastCycle.Answer != "GT2")
                    MoveToQuestionGroup(qgHasRelativeHadCC);
            }
        }

        protected void qgUsedEstrogenRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcGender.Answer == "Female"
                && qcStillHavePeriods.Answer == "No"
                && qcLastCycle.Answer == "GT2"
                );
        }

        protected void qgHasRelativeHadCCAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgHasRelativeHadCC))
            {
                if (qcHasRelativeHadCC.Answer == "Yes")
                    MoveToQuestionGroup(qgNumRelativesHavingCC);
                //Else end?
            }
            else if (IsCurrentQuestionGroup(qgNumRelativesHavingCC))
            {
                //End?
            }
        }

        protected void qgNumRelativesHavingCCAnswered(object sender, EventArgs e)
        {
            if (IsCurrentQuestionGroup(qgNumRelativesHavingCC))
            {                            
            }
        }

        protected void qgNumRelativesHavingCCRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcHasRelativeHadCC.Answer == "Yes");
        }

        #endregion

        #endregion protected members

        #region public members

        public QuestionDisplayModes DisplayMode
        {
            get { return qgm.DisplayMode; }
            set
            {
                phHome.Visible = false;
                qgm.DisplayMode = value;
                switch (value)
                {
                    case QuestionDisplayModes.Results:
                        phCalc.Visible = false;
                        lnkNewCalculation.Visible = true;
                        phExplanation.Visible = false;
                        divQex.Visible = false;
                        res.Visible = true;
                        phResults.Visible = true;
                        phResultEx.Visible = false;
                        pc.Visible = true;
                        SetPercentageComplete();
                        phHome.Visible = true;
                        break;
                    case QuestionDisplayModes.ResultExplanation:
                        qs.Visible = false;
                        phCalc.Visible = false;
                        lnkNewCalculation.Visible = false;
                        phExplanation.Visible = false;
                        pc.Visible = false;
                        divQex.Visible = false;
                        res.Visible = true;
                        phResults.Visible = false;
                        phResultEx.Visible = true;
                        break;
                    case QuestionDisplayModes.QuestionExplanation:
                        divQex.Visible = true;
                        phCalc.Visible = false;
                        lnkNewCalculation.Visible = false;
                        btnEx.Visible = false;
                        pc.Visible = false;
                        phExplanation.Visible = true;
                        break;
                    default:
                        qs.Visible = true;
                        phCalc.Visible = true;
                        lnkNewCalculation.Visible = false;
                        btnEx.Visible = true;
                        pc.Visible = true;
                        SetPercentageComplete();
                        divQex.Visible = true;
                        phHome.Visible = true;
                        break;
                }                
            }
        }

        public void btnNext_Click(object sender, EventArgs e)
        {
            if (this.DisplayMode == QuestionDisplayModes.Questioning && qgm.HaveAllQuestionsBeenAnswered && qgm.CurrentQuestionGroup != 1 && qgm.CurrentQuestionGroupControl.IsLastQuestionGroup())
            {
                this.DisplayMode = QuestionDisplayModes.Results;
                CalculateRisks();
            }
            else
            {
                SetPercentageComplete();
                pc.Visible = true;

                if( qgm.CurrentQuestionGroupControl.IsAnswered == false
                    && qgm.HasCurrentQuestionGroupChanged == false
                    )
                    ma.Visible = true;
                else
                    ma.Visible = false;
            }
        }

        public void ExplanationLink_Click(object sender, EventArgs e)
        {
            this.DisplayMode = QuestionDisplayModes.QuestionExplanation;
        }

        public void CalculateRisks()
        {
            int firstError = qgm.ValidateAnswers();

            if (firstError != 0)
                throw new Exception("Answers not valid?");

            AbsoluteRisks risks = GetAbsoluteRisks();                     

            ViewState["AbsRisk5Yr"] = risks.FiveYearAbsRiskPercent;
            ViewState["AbsRisk10Yr"] = risks.TenYearAbsRiskPercent;
            ViewState["AbsRiskLTime"] = risks.LifetimeAbsRiskPercent;


            UpdateResults(risks);
            
        }

        private AbsoluteRisks GetAbsoluteRisks()
        {
            return Manager.CalculateRisks(                
                qcHispanic.Answer,
                qcRace.Answer,
                qcCurrentAge.Answer,
                qcGender.Answer,
                qcHeight.Answer,
                qcWeight.Answer,
                qcNumServingsVeg.Answer,
                qcAmountVeg.Answer,
                qcColonoscopy.Answer,
                qcHadPolyp.Answer,
                qcAsprin.Answer,
                qcIbuprofen.Answer,
                qc100MoreCigs.Answer,
                qcStartSmoke.Answer,
                qcStillSmoke.Answer,
                qcSmokeQuit.Answer,
                qcCigNumPerDay.Answer,
                qcVigorousActivities.Answer,
                qcVigorousHours.Answer,
                qcStillHavePeriods.Answer,
                qcLastCycle.Answer,
                qcUsedEstrogen.Answer,
                qcHasRelativeHadCC.Answer,
                qcNumRelativesHavingCC.Answer
                );
        }

        #endregion public members

        #region results
        private const string _cannotCmpute = "Risks could not be computed for this combination of risk factors";
        public void UpdateResults(CCRAT.RiskCalculator.AbsoluteRisks value)
        {
            if (value.Is5YrRiskValid)
            {
                ph5.Visible = true;
                s5.InnerHtml = value.FiveYearAbsRiskPercent.ToString() + "%";
            }

            if (value.Is10YrRiskValid)
            {
                ph10.Visible = true;
                s10.InnerHtml = value.TenYearAbsRiskPercent.ToString() + "%";
            }

            if (value.IsPatternFoundInDB)
            {
                phLT.Visible = true;
                sLT.InnerHtml = value.LifetimeAbsRiskPercent.ToString() + "%";
            }
            else
            {
                phErrorMsg.Visible = true;
                errorMsg.InnerHtml = string.Format(@"Pattern {0} {1}"
                    , value.PatternID.ToString()
                    , _cannotCmpute);
            }

            s52.InnerHtml = value.FiveYearAvgRiskPercent.ToString() + "%";
            s102.InnerHtml = value.TenYearAvgRiskPercent.ToString() + "%";
            sLT2.InnerHtml = value.LifeTimeAvgRiskPercent.ToString() + "%";

            r1.InnerHtml = value.Race;
            r2.InnerHtml = value.Race;
            r4.InnerHtml = value.Race;
            r5.InnerHtml = value.Race;

            age.InnerHtml = value.CurrentAge;
            age2.InnerHtml = value.CurrentAge;
            age3.InnerHtml = value.CurrentAge;
            age4.InnerHtml = value.CurrentAge;
            age5.InnerHtml = value.CurrentAge;
            age7.InnerHtml = value.CurrentAge;

            g1.InnerHtml = (value.Gender.Equals("Male", StringComparison.OrdinalIgnoreCase)) ? "Man" : "Woman";
            g2.InnerHtml = g1.InnerHtml;
            g3.InnerHtml = g1.InnerHtml;
            g4.InnerHtml = g1.InnerHtml;
            g5.InnerHtml = g1.InnerHtml;
            g6.InnerHtml = g1.InnerHtml;


            #region variables for testing purpose
            if (Common.Utils.Helper.ReadConfigSetting("PrintVariables", false))
            {
                divCalVars.Visible = true;
                if (value.Gender == "Male")
                {
                    litTestVars.Text = String.Format(
                        @"
                            NumRel: {0}&nbsp;&nbsp;&nbsp;&nbsp;Cigarets: {1}<br/>
                            NoIbuprofn: {2}&nbsp;&nbsp;&nbsp;&nbsp;NoNSAIDS: {3}<br/>
                            BMI: {4}&nbsp;&nbsp;&nbsp;&nbsp;bmi_trnd: {5}<br/>
                            Sigmod: {6}&nbsp;&nbsp;&nbsp;&nbsp;Veglt5: {7}<br/>
                            CigYr: {8}&nbsp;&nbsp;&nbsp;&nbsp;HrsExcrise: {9}<br/>

                        ", value.Numrel, value.Cigarets, value.NoIbuprofn, value.NoNSaids
                         , Math.Round(value.Bmi, 2, MidpointRounding.AwayFromZero), value.BmiTrnd
                         , value.Sigmod, value.VegLT5, value.Duration, value.HrsExcrise);
                }
                else
                {
                    litTestVars.Text = String.Format(
                        @"
                            NRelTrnd: {0}&nbsp;&nbsp;&nbsp;&nbsp;NoNsaids: {1}<br/>
                            BMI: {2}&nbsp;&nbsp;&nbsp;&nbsp;BMIge30: {3}<br/>
                            sigmod: {4}&nbsp;&nbsp;&nbsp;&nbsp;Veglt5: {5}<br/>
                            NoStrogen: {6}&nbsp;&nbsp;&nbsp;&nbsp;XrcisHrsTrnd: {7}<br/>

                        ", value.Numrel, value.NoNSaids
                         , Math.Round(value.Bmi, 2, MidpointRounding.AwayFromZero), value.BmiGe30
                         , value.Sigmod, value.VegLT5, value.NoStrogen, value.HrsExcrise);
                }


                if (value.IsPatternFoundInDB)
                {
                    litTestVars.Text += string.Format(
                            @"
                            Pattern: {0}<br/>
                            FiveYrAbsRisk   : {1}%({2})<br/>
                            TenYrAbsRisk    : {3}%({4})<br/>
                            TwentyYrAbsRisk : {5}%({6})<br/>
                            LifeTimeAbsRisk : {7}%({8})<br/>
                            FiveYrAvgRisk   : {9}%({10})<br/>
                            TenYrAvgRisk    : {11}%({12})<br/>
                            LifeTimeAvgRisk : {13}%({14})<br/>
                            "
                            , value.PatternID.ToString()
                            , value.FiveYearAbsRiskPercent, value.FiveYearAbsRisk
                            , value.TenYearAbsRiskPercent, value.TenYearAbsRisk
                            , value.TwentyYearAbsRiskPercent, value.TwentyYearAbsRisk
                            , value.LifetimeAbsRiskPercent, value.LifetimeAbsRisk
                            , value.FiveYearAvgRiskPercent, value.FiveYearAvgRisk
                            , value.TenYearAvgRiskPercent, value.TenYearAvgRisk
                            , value.LifeTimeAvgRiskPercent, value.LifetimeAvgRisk
                            );
                }
                else
                {
                    litTestVars.Text += string.Format(
                        @"<span style='color:red'>Pattern: {0} {1}</span>"
                        , value.PatternID.ToString(), _cannotCmpute
                    );
                }
            }
            #endregion variables for testing purpose

        }
        public void exRes_Click(Object sender, CommandEventArgs e)
        {

            this.DisplayMode = QuestionDisplayModes.ResultExplanation;

            switch (e.CommandName.ToLower())
            {
                case "ex5":
                    pExp.InnerHtml = string.Format("Based on the information provided, the estimated chance for developing colorectal cancer over the next {0} years is {1}%.", 5, ViewState["AbsRisk5Yr"].ToString());
                    break;
                case "ex10":
                    pExp.InnerHtml = string.Format("Based on the information provided, the estimated chance for developing colorectal cancer over the next {0} years is {1}%.", 10, ViewState["AbsRisk10Yr"]);
                    break;
                case "exl":
                    pExp.InnerHtml = string.Format("Based on the information provided, the estimated chance for developing colorectal cancer over the lifetime (to age {0}) is {1}%.", 90, ViewState["AbsRiskLTime"]);
                    break;
                case "exr":
                    pExp.InnerHtml = exResults.InnerHtml;
                    break;                        
                default:
                    throw new Exception("Command name not recognized");
            }
        }
        #endregion results
    }   
}
