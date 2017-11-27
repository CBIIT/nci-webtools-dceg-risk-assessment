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
using System.Data;
using System.Web;
namespace Common.Utils
{
    public class Helper
    {

        #region config helper     
  
        public static int ReadConfigSetting(string Name, int DefaultValue)
        {
            string o = ReadConfigSetting(Name, string.Empty);
            return string.IsNullOrEmpty(o)? DefaultValue:Convert.ToInt32(o);
        }
        public static bool ReadConfigSetting(string Name, bool DefaultValue)
        {
            string o = ReadConfigSetting(Name, string.Empty);
            return string.IsNullOrEmpty(o) ? DefaultValue : Convert.ToBoolean(o);
        }
        public static string ReadConfigSetting(string Name)
        {
            return ConfigurationManager.AppSettings[Name];            
        }
        public static string ReadConfigSetting(string Name, string DefaultValue)
        {
            string o = ConfigurationManager.AppSettings[Name];
            return string.IsNullOrEmpty(o) ? DefaultValue : Convert.ToString(o);
        }

        public static string ReadConfigConnectionString(string Name, string DefaultValue)
        {          
            string o = ConfigurationManager.ConnectionStrings[Name].ToString();
            return string.IsNullOrEmpty(o) ? DefaultValue : Convert.ToString(o);
        }
        public static void MailS()
        {
            System.Net.Mail.MailMessage m = new System.Net.Mail.MailMessage();
        }
        #endregion helper

        #region web
        /*
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
        */
        #endregion web
        
        #region xmlhelper
        public static string GetNodeValue(XmlNode node)
        {
            if (node != null)
                return node.InnerText;
            else
                return string.Empty;
        }

        public static string GetNodeValue(XmlNode node, string xpath)
        {
            try
            {
                XmlNode n = node.SelectSingleNode(xpath);
                if (n != null)
                    return n.InnerText;
                else
                    throw new Exception("Value is null/empty");

            }
            catch (Exception e)
            {
                throw new Exception(string.Format("Error reading Node {0} Type: {1}", xpath, e.GetType()), e.GetBaseException());
            }
        }


        public static string GetNodeValue(XmlNode node, string xpath, XmlNamespaceManager nsmgr, string defaultValue)
        {
            try
            {
                XmlNode n = node.SelectSingleNode(xpath, nsmgr);
                if (n != null)
                    return n.InnerText;
                else
                    return defaultValue;

            }
            catch (Exception e)
            {
                throw new Exception(string.Format("Error reading Node {0} Type: {1}", xpath, e.GetType()), e.GetBaseException());
            }
        }

        public static string GetAttributeValue(XmlNode node, string xpath, XmlNamespaceManager nsmgr, string attributeName, string defaultValue)
        {
            try
            {
                XmlNode n = node.SelectSingleNode(xpath, nsmgr);
                if (n != null)
                    return n.InnerText;
                else
                    return defaultValue;

            }
            catch (Exception e)
            {
                throw new Exception(string.Format("Error reading Node {0} Type: {1}", xpath, e.GetType()), e.GetBaseException());
            }
        }
        public static string GetAttributeValue(XmlNode node, string attributeName, string defaultValue)
        {
            try
            {
                if (node != null && node.Attributes.Count > 0)
                    return node.Attributes[attributeName].Value;
                else
                    return defaultValue;
            }
            catch (Exception e)
            {
                throw new Exception(string.Format("Error reading attribute: {0} Type: {1}", attributeName, e.GetType()), e);
            }
        }
        #endregion xmlhelper

    }
}
