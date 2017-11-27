using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;

/// <summary>
/// Summary description for ErrorHandler
/// </summary>
public class ErrorHandler : IHttpModule
{
    #region IHttpModule Members

    public void Dispose()
    {

    }

    public void Init(HttpApplication context)
    {
        context.Error += new EventHandler(context_Error);
    }

    void context_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs
        //get reference to the source of the exception chain
        Exception ex = HttpContext.Current.Server.GetLastError().GetBaseException();

        CCRAT.Mobile.ErrorLogger.LogError("Global Exception Occured", ex);
        ////log the details of the exception and page state to the
        ////Windows 2000 Event Log
        //string ErrDescr =
        //  "MESSAGE: " + ex.Message +
        //  "\nSOURCE: " + ex.Source +
        //  "\nFORM: " + HttpContext.Current.Request.Form.ToString() +
        //  "\nQUERYSTRING: " + HttpContext.Current.Request.QueryString.ToString() +
        //  "\nTARGETSITE: " + ex.TargetSite +
        //  "\nSTACKTRACE: " + ex.StackTrace;

        //string physicalPath = HttpContext.Current.Server.MapPath("Errors");
        
        ////create the directory if it does not exist already
        //if (!Directory.Exists(physicalPath))
        //{
        //    Directory.CreateDirectory(physicalPath);
        //}
        //FileStream fStream = File.Create(physicalPath + "\\" + DateTime.Now.Ticks + ".txt");
        //fStream.Write(System.Text.ASCIIEncoding.ASCII.GetBytes(ErrDescr), 0, ErrDescr.Length);
        //fStream.Flush();
        //fStream.Close();
    }
    #endregion
}