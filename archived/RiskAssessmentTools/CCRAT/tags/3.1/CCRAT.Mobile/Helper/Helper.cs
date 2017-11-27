/**************************************************************************************************
* Name		: Helper.cs
* Purpose	: Helper.cs
* Author	: SRamaiah
* Date		: 03/23/2006
* Changes	:
**************************************************************************************************/
using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.Xml;
namespace Common.Utils
{
    public class Helper
    {
      #region helper
			public static string GetRequestValue(string Name, string DefaultValue)
			{
				object o = System.Web.HttpContext.Current.Request[Name];
				return (o != null) ? o.ToString() : DefaultValue;
			}
			public static long GetRequestValue(string Name, long DefaultValue)
			{
				object o = System.Web.HttpContext.Current.Request[Name];
				return (o != null) ? Convert.ToInt64(o) : DefaultValue;
			}

            public static bool GetRequestValue(string Name, bool DefaultValue)
            {
                object o = System.Web.HttpContext.Current.Request[Name];
                return (o != null) ? Convert.ToBoolean(o) : DefaultValue;
            }

			public static int ReadConfigSetting(string Name, int DefaultValue)
			{
				string o = ReadConfigSetting(Name, string.Empty);
				return (o != string.Empty) ? Convert.ToInt32(o) : DefaultValue;
			}
			public static string ReadConfigSetting(string Name, string DefaultValue)
			{
				//use this for pre 2.0
				//string o = ConfigurationSettings.AppSettings[Name];
				string o = ConfigurationManager.AppSettings[Name];
				return (o != null) ? Convert.ToString(o) : DefaultValue;
			}
			public static string ReadConfigConnectionString(string Name, string DefaultValue)
			{
				//use this for pre 2.0
				//string o = ConfigurationSettings.AppSettings[Name];
				string o = ConfigurationManager.ConnectionStrings[Name].ToString();
				return (o != null) ? Convert.ToString(o) : DefaultValue;
			}
        #endregion helper

	  #region xmlhelper
			public static string GetNodeValue(XmlNode oNode, string NodeName)
			{
				try
				{
					return oNode.SelectSingleNode(NodeName).InnerText;
				}
				catch (Exception e)
				{
					throw new Exception(string.Format("Error reading Node {0} Type: {1}", NodeName, e.GetType()), e.GetBaseException());
				}
			}
	        public static string GetAttributeValue(XmlNode oNode, string AttributeName)
	        {
				try
				{
					return oNode.Attributes[AttributeName].InnerText;
				}
				catch (Exception e)
				{
					throw new Exception(string.Format("Error reading attribute: {0} Type: {1}", AttributeName, e.GetType()), e);
				}
        	}
        #endregion xmlhelper
    }
}
