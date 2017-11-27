using System;
using System.IO;
using System.Web;
using System.Text.RegularExpressions;
using System.Web.Caching;
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
        //Code that runs when an unhandled error occurs
        //get reference to the source of the exception chain
        Exception ex = HttpContext.Current.Server.GetLastError().GetBaseException();
        MRAT.Mobile.ErrorLogger.LogError("Global Exception Occured", ex);        
    }
    #endregion
}

