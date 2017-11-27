using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Net.Mail;
using NCI.Utilities;
namespace MRAT
{
public partial class PopEmail : System.Web.UI.Page
{

    string strSendtoEmail = "Send this link to (e-mail address)&nbsp;&nbsp;";
    string strFromEmail = "Your e-mail address&nbsp;&nbsp;";
    string strName = "Your name&nbsp;&nbsp;";
    string strSend = "Send";
    string strConfirm = "";

    /// <summary>
    /// Event method sets frame content version and parameters
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void Page_Load(object sender, System.EventArgs e)
    {
        bool blnIsSpanish = false;

        //So yea, this is in case someone gets the bright idea
        //to make the spanish Melanoma  site.  The code already existed,
        //so it took more time to remove it than leave it here.
        //Obviously that bln needs to be changed
        if (blnIsSpanish)
        {
            strSendtoEmail = "Compartir este enlace con&nbsp;&nbsp;<br>(dirección de correo electrónico)&nbsp;&nbsp;<br>(Send to this e-mail)&nbsp;&nbsp;";
            strFromEmail = "Su dirección de correo electrónico&nbsp;&nbsp;<br>(Your e-mail)&nbsp;&nbsp;";
            strName = "Su nombre&nbsp;&nbsp;<br>(Your name)&nbsp;&nbsp;";
            strSend = "Enviar/Send";
            blnIsSpanish = true;
        }

        //Setup labels
        lblToEmail.Text = strSendtoEmail;
        lblFromEmail.Text = strFromEmail;
        lblFromName.Text = strName;
        btnSubmit.Text = strSend;

        if (!this.IsPostBack)
        {
            //assign passed in variables to controls
            Document.Value = HttpUtility.UrlEncodeUnicode(Strings.IfNull(Strings.Clean(Request.Params["title"]), "").Replace("__tm;", "&#153;"));
            Title.Text = HttpUtility.UrlDecode(Document.Value);
            Url.Value = Strings.IfNull(Strings.Clean(Request.QueryString["docurl"]), "").Replace("__amp;", "&");
            if (Url.Value.StartsWith("/"))
            {
                Url.Value = Request.Url.GetLeftPart(System.UriPartial.Authority) + Url.Value;
            }
            //this is to replace the port which is causing issues in QA
            Url.Value = Url.Value.Replace(":" + Request.Url.Port , "");
            Url.Value = Url.Value.Replace(Server.UrlEncode(":") + Request.Url.Port , "");
        }
        else
        {            
            //Validate required controls
            if (!BCRA.EmailSyntaxValidator.Valid(txtTo.Text, true))
            {
                txtTo.Text = "";
            }

            if (!BCRA.EmailSyntaxValidator.Valid(txtFrom.Text, true))
            {
                txtFrom.Text = "";
            }

            Page.Validate();


            //Send Email Required Controls Are Valid
            if (IsValid)
            {
                //Create document hyperlink
                //HtmlAnchor docLink = new HtmlAnchor(Url.Value, HttpUtility.UrlDecode(Strings.IfNull(Strings.Clean(Document.Value), Url.Value)));


                //Create mail
                MailMessage mailMsg = new MailMessage();
                mailMsg.To.Add(new MailAddress(txtTo.Text));
                mailMsg.From = new MailAddress(txtFrom.Text);
                mailMsg.Subject = "Information from the National Cancer Institute Web Site";
                mailMsg.IsBodyHtml = true;
                mailMsg.Body = "<html><head></head><body>The following link from the National Cancer Institute's (NCI's) Web site has been sent to you by " + Strings.IfNull(Strings.Clean(txtFromName.Text), "a colleague") + ":<P>" + HttpUtility.UrlDecode(Document.Value) + "<BR><a href=\"" + Url.Value + "\">" + Url.Value + "</a><p>NCI's Web site, <a href=\"http://www.cancer.gov\">www.cancer.gov</a>, contains comprehensive information about cancer causes and prevention, screening and diagnosis, treatment and survivorship; clinical trials; statistics; funding, training and employment opportunities; and the institute and its programs. You can also get cancer information online through the LiveHelp instant messaging service at <a href=\"https://cissecure.nci.nih.gov/livehelp/welcome.asp\">https://cissecure.nci.nih.gov/livehelp/welcome.asp</a>.  If you live in the United States, you may call the NCI's Cancer Information Service toll-free at 1-800-4-CANCER (1-800-422-6237) for cancer information in English and Spanish.  For deaf and hard of hearing callers, the TTY number is 1-800-332-8615.</body></html>";
                if (blnIsSpanish)
                {
                    mailMsg.Subject = "Información del portal de Internet del Instituto Nacional del Cáncer";
                    mailMsg.Body = "<html><head></head><body>El siguiente enlace al portal de Internet del Instituto Nacional del Cáncer (NCI, por sus siglas en inglés) le ha sido enviado por " + Strings.IfNull(Strings.Clean(txtFromName.Text), "un colega") + ":<P>" + HttpUtility.UrlDecode(Document.Value) + "<BR><a href=\"" + Url.Value + "\">" + Url.Value + "</a><p>El portal del Instituto Nacional del Cáncer en la Web, <a href=\"http://www.cancer.gov\">www.cancer.gov</a>, contiene información completa sobre las causas y prevención, exámenes selectivos de detección y diagnóstico, tratamiento y supervivencia al cáncer, así como sobre estudios clínicos, estadísticas, financiamiento, capacitación y oportunidad de empleo, y sobre el Instituto y sus programas.  Usted puede también obtener información en línea por medio del servicio de mensajería instantánea <i>LiveHelp</i> en <a href=\"https://cissecure.nci.nih.gov/livehelp/welcome.asp\">https://cissecure.nci.nih.gov/livehelp/welcome.asp</a>. Si usted vive en los Estados Unidos, usted puede llamar gratis al Servicio de Información sobre el Cáncer del Instituto Nacional del Cáncer al 1-800-4-CANCER (1-800-422-6237) para información del cáncer en inglés y en español. Para personas sordas o con problemas de audición, el número para TTY es el 1-800-332-8615.</body></html>";
                }
                //Send mail
                SmtpClient client = new SmtpClient();
                client.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis;
                try
                {
                    client.Send(mailMsg);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine(ex.Message);
                    //TODO: check
                }

                strConfirm = "<br><br>The link has been sent.<br>Thank you for using the NCI's Web site.";
                if (blnIsSpanish)
                {
                    strConfirm = "<br><br>El enlace ha sido enviado.<br>Gracias por visitar el portal de Internet del NCI.<br><br>(The link has been sent.<br>Thank you for using the NCI's Web site.)";
                }

                //Set the confirmation email
                emailForm.Visible = false;
                lblConfirm.Visible = true;
                lblConfirm.Text = strConfirm;
            }
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {

    }
}
//public class EmailSyntaxValidator
//{
//    public EmailSyntaxValidator(string email, bool TLDrequired) { ;}

//    public string Account { get ; }
//    public string Address { get; }
//    public string Domain { get; }
//    public bool IsValid { get; }

//    public static bool Valid(string email, bool TLDrequired);
//}
}