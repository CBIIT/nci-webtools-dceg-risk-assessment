using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
namespace NCI.BCPT.Engine.Helper
{
    public static class Helper
    {
        public static string GetConfig(string sParam)
        {
            return System.Configuration.ConfigurationSettings.AppSettings[sParam];
        }

        public static string GetConfig(string sParam, string defaultValue)
        {
            if (System.Configuration.ConfigurationSettings.AppSettings[sParam] == null)
                return defaultValue;
            else
                return System.Configuration.ConfigurationSettings.AppSettings[sParam];
        }
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
    }
}
