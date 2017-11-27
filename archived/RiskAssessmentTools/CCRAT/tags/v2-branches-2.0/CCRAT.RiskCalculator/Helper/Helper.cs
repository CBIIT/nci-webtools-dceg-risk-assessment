/**************************************************************************************************
* name		: Helper.cs
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
        public static int ReadConfigSetting(string name, int defaultValue)
        {
            string o = ReadConfigSetting(name, string.Empty);
            return (String.IsNullOrEmpty(o)) ? defaultValue: Convert.ToInt32(o);
        }
        public static string ReadConfigSetting(string name, string defaultValue)
        {
            string o = ConfigurationManager.AppSettings[name];
            return (String.IsNullOrEmpty(o)) ? defaultValue: Convert.ToString(o);
        }
        public static string ReadConfigConnectionString(string name, string defaultValue)
        {
            string o = ConfigurationManager.ConnectionStrings[name].ToString();
            return (String.IsNullOrEmpty(o)) ? defaultValue : Convert.ToString(o);
        }
        public static bool ReadConfigSetting(string name, bool defaultValue)
        {
            string o = ConfigurationManager.AppSettings[name];
            return (String.IsNullOrEmpty(o)) ? defaultValue: Convert.ToBoolean(o);
        }
        #endregion helper

        #region web
        public static string GetRequestValue(string name, string defaultValue)
        {
            object o = System.Web.HttpContext.Current.Request[name];
            return (o != null) ? o.ToString() : defaultValue;
        }
        public static long GetRequestValue(string name, long defaultValue)
        {
            object o = System.Web.HttpContext.Current.Request[name];
            return (o != null) ? Convert.ToInt64(o) : defaultValue;
        }
        public static bool GetRequestValue(string name, bool defaultValue)
        {
            object o = System.Web.HttpContext.Current.Request[name];
            return (o != null) ? Convert.ToBoolean(o) : defaultValue;
        }
        #endregion web

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
