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

namespace CCRAT.Web.UserControls
{

    #region EventHandler and EventArgs class for the Calculation Event

    public class CalculationEventArgs : EventArgs
    {
        private CCRAT.RiskCalculator.AbsoluteRisks _risks;

        public CCRAT.RiskCalculator.AbsoluteRisks Risks
        {
            get { return _risks; }
        }

        public CalculationEventArgs(CCRAT.RiskCalculator.AbsoluteRisks risks)
        {
            _risks = risks;
        }
    }

    public delegate void CalculationEventHandler(object sender, CalculationEventArgs e);

    #endregion


    public partial class QuestionAsker2 : System.Web.UI.UserControl
    {
        private static readonly object CalculateRiskEvent = new object();

        public QuestionDisplayModes DisplayMode
        {
            get { return qgmManager.DisplayMode; }
            set
            {
                qgmManager.DisplayMode = value;
                if (value == QuestionDisplayModes.Results)
                {
                    pQuestionsRequired.Visible = false;
                    phCalculateButtons.Visible = false;
                    lnkNewCalculation.Visible = true;
                }
                else
                {
                    phCalculateButtons.Visible = true;
                    lnkNewCalculation.Visible = false;
                    pQuestionsRequired.Visible = true;
                }
            }
        }

        public event CalculationEventHandler CalculateRisk
        {
            add { Events.AddHandler(CalculateRiskEvent, value); }

            remove { Events.RemoveHandler(CalculateRiskEvent, value); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Fill in current age
                ddlCurrentAge.Items.Add(new ListItem("Select", "NAN"));
                for (int i = 50; i < 86; i++)
                {
                    ddlCurrentAge.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                ////Fill in moderate activities
                ddlModerateActivities.Items.Add(new ListItem("Select", "NAN"));
                for (int i = 0; i < 13; i++)
                {
                    ddlModerateActivities.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                ddlVigorousActivities.Items.Add(new ListItem("Select", "NAN"));
                for (int i = 0; i < 13; i++)
                {
                    ddlVigorousActivities.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
            }

            btnCalculate.OnClientClick = "return Validate('" + txtHeightFeet.ClientID + "', '" + txtHeightInches.ClientID + "', '" + txtWeight.ClientID + "')";
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.DisplayMode == QuestionDisplayModes.Questioning && qgmManager.HaveAllQuestionsBeenAnswered)
            {
                btnCalculateDisabled.Visible = false;
                btnCalculate.Visible = true;
            }
            else
            {
                btnCalculateDisabled.Visible = true;
                btnCalculate.Visible = false;
            }
        }

        protected virtual void OnCalculateRisk(CalculationEventArgs e)
        {
            CalculationEventHandler handler = (CalculationEventHandler)Events[CalculateRiskEvent];
            if (handler != null)
                handler(this, e);
        }

        //This is the callback for any selection changes.
        protected void UpdateQuestions(object sender, EventArgs e)
        {
            qgmManager.RefreshQuestions((Control)sender);
        }

        public void btnCalculate_Click(object sender, EventArgs e)
        {
            int firstError = qgmManager.ValidateAnswers();

            if (firstError != 0)
                throw new Exception("Answers not valid?");
            
            CCRAT.RiskCalculator.AbsoluteRisks risks = CCRAT.RiskCalculator.Manager.CalculateRisks(
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

            OnCalculateRisk(new CalculationEventArgs(risks));            
        }

        //These are callbacks that set the answer of a QuestionControl if it is not a DropDownList
        //or it has some special rules for checking if the question has been answered.
        #region Validate Callbacks

        protected void qcHispanicValidate(object sender, EventArgs e)
        {
            if (ddlHispanic.SelectedValue != "Yes" && ddlHispanic.SelectedValue != "NAN")
                ((QuestionControl)sender).Answer = ddlHispanic.SelectedValue;
            else
                ((QuestionControl)sender).Answer = string.Empty; //Make sure we set the answer so we can error on Yes.
        }

        protected void qcRaceValidate(object sender, EventArgs e)
        {
            if (ddlRace.SelectedValue == "White")
                ((QuestionControl)sender).Answer = ddlRace.SelectedValue;
            else
                ((QuestionControl)sender).Answer = string.Empty; //Make sure we set the answer so we can error on non-whites.
        }

        protected void qcHeightValidate(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtHeightFeet.Text) && !string.IsNullOrEmpty(txtHeightInches.Text))
            {
                try
                {
                    int feet = Int32.Parse(txtHeightFeet.Text);
                    int inches = Int32.Parse(txtHeightInches.Text);

                    int height = (feet * 12) + inches;
                    ((QuestionControl)sender).Answer = height.ToString();
                } catch {}
            }
        }

        protected void qcWeightValidate(object sender, EventArgs e)
        {
            ((QuestionControl)sender).Answer = txtWeight.Text;
        }

        #endregion

        // Redraw callbacks determine if the question group should show or not.
        // The default behavior for a question group is to show it if the 
        // CurrentQuestionGroup >= QuestionGroup.QuestionGroupNum
        //
        // QuestionGroupAnswered callbacks determine what the next question should be.
        #region Redraw and QuestionGroupAnswered Callbacks

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

            //Ok, so this should be fun.  If someone is answering male questions and they
            //change thier age, we need to change the dropdowns for thier age.
            FillSmokeStart();
            FillSmokeQuit();
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
            } else if (IsCurrentQuestionGroup(qgHadPolyp)) {
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

        protected void qgNumRelativesHavingCCRedraw(object sender, EventArgs e)
        {
            ((QuestionGroup)sender).Visible = (qcHasRelativeHadCC.Answer == "Yes");
        }



        #endregion

        private bool IsQuestionAnswered(QuestionControl qc)
        {
            return (!string.IsNullOrEmpty(qc.Answer) && qc.Answer != "NAN");
        }

        private void FillSmokeStart()
        {
            int ?currentAge = null;

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
                ddlStartSmoke.Items.Add(new ListItem("I have never smoked cigarettes regularly", "NeverSmoke"));

                for (int i = 6; i <= currentAge; i++)
                {
                    ddlStartSmoke.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                foreach (ListItem li in ddlStartSmoke.Items)
                {
                    if (li.Value == prevSelectedValue)
                    {
                        ddlStartSmoke.Text = prevSelectedValue;
                        break;
                    }
                }
            }
            else
            {
                ddlStartSmoke.Items.Clear();

                ddlStartSmoke.Items.Add(new ListItem("Select", "NAN"));
                ddlStartSmoke.Text = "NAN";
                ddlStartSmoke.Items.Add(new ListItem("I have never smoked cigarettes regularly", "NeverSmoke"));
            }
        }

        private void FillSmokeQuit()
        {
            int ?currentAge = null;

            try
            {
                currentAge = Int32.Parse(qcCurrentAge.Answer);
            }
            catch { }

            int ?startAge = null;

            try
            {
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

                foreach (ListItem li in ddlSmokeQuit.Items)
                {
                    if (li.Value == prevSelectedValue)
                    {
                        ddlSmokeQuit.Text = prevSelectedValue;
                        break;
                    }
                }                
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
            qgmManager.CurrentQuestionGroup = group.QuestionGroupNum;
        }

        private void MoveToNextQuestionGroup()
        {
            qgmManager.CurrentQuestionGroup++;
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
            return (qgmManager.CurrentQuestionGroup == qg.QuestionGroupNum);
        }



    }
}