using System;
using System.IO;
using System.Web;
using System.Text.RegularExpressions;
using System.Web.Caching;

/// <summary>
/// Summary description for ScriptHandler
/// </summary>
public class CssHandler : IHttpHandler
{

  #region IHttpHandler Members

  public bool IsReusable
  {
    get { return false; }
  }

  private const string CSS_CACHE_BODY = "Css.FileBody";

  public void ProcessRequest(HttpContext context)
  {
    try
    {
      string file = context.Request.PhysicalPath;
      if (!File.Exists(file))
        return;

      string body = string.Empty;

      if (context.Cache[CSS_CACHE_BODY + file] != null)
        body = context.Cache[CSS_CACHE_BODY + file].ToString();

			if (body == string.Empty)
      {
        StreamReader reader = new StreamReader(file);
        body = reader.ReadToEnd();
        reader.Close();

        body = StripComments(body);
        body = body.Replace("  ", String.Empty);
        body = body.Replace(Environment.NewLine + Environment.NewLine + Environment.NewLine, String.Empty);
        body = body.Replace(Environment.NewLine + Environment.NewLine, Environment.NewLine);
        body = body.Replace(Environment.NewLine, String.Empty);
        body = body.Replace("\t", string.Empty);
        body = body.Replace(" {", "{");
        body = body.Replace(" :", ":");
        body = body.Replace(": ", ":");
        body = body.Replace(", ", ",");
        body = body.Replace("; ", ";");
        body = body.Replace(";}", "}");
        body = Regex.Replace(body, @"/\*[^\*]*\*+([^/\*]*\*+)*/", "$1");
        body = Regex.Replace(body, @"(?<=[>])\s{2,}(?=[<])|(?<=[>])\s{2,}(?=&nbsp;)|(?<=&ndsp;)\s{2,}(?=[<])", String.Empty);

        CacheDependency cd = new CacheDependency(file);

        context.Cache.Insert(CSS_CACHE_BODY + file, body, cd);
      }

      context.Response.ContentType = "text/css";
      context.Response.Write(body);
    }
    catch (Exception ex)
    {
      context.Response.Write(ex.Message);
    }
  }

  private string StripComments(string body)
  {
    body = Regex.Replace(body, @"/\*.+?\*/", "", RegexOptions.Singleline);
    return body;
  }

  #endregion
}
