<%@ WebHandler Language="C#" Class="css" %>
using System;
using System.Web;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.Caching;

public class css : IHttpHandler
{

  public void ProcessRequest(HttpContext context)
  {
    string file = context.Server.MapPath(context.Request.QueryString["path"]);
    ReduceCSS(file, context);
    SetHeaders(file, context);
  }

  /// <summary>
  /// Removes all unwanted text from the CSS file,
  /// including comments and whitespace.
  /// </summary>
  private void ReduceCSS(string file, HttpContext context)
  {
    FileInfo fi = new FileInfo(file);
    if (!fi.Extension.Equals(".css", StringComparison.OrdinalIgnoreCase))
    {
      throw new System.Security.SecurityException("No access");
    }
    
      string body = fi.OpenText().ReadToEnd();

      body = body.Replace("  ", String.Empty);
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

      context.Response.Write(body);
  }

  /// <summary>
  /// This will make the browser and server keep the output
  /// in its cache and thereby improve performance.
  /// </summary>
  private void SetHeaders(string file, HttpContext context)
  {
    context.Response.ContentType = "text/css";   
    // Server-side caching 
    context.Response.AddFileDependency(file);
    context.Response.Cache.VaryByParams["path"] = true;
    // Client-side caching
    context.Response.Cache.SetETagFromFileDependencies();
    context.Response.Cache.SetLastModifiedFromFileDependencies();
  }

  public bool IsReusable
  {
    get
    {
      return false;
    }
  }

}