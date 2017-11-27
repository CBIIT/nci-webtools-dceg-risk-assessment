using System;
using System.Collections.Generic;
using System.Text;

namespace BCRA.Web.Service.Client
{
    class Program
    {
        static void Main(string[] args)
        {
            BCRACalculator proxyBCRA = new BCRACalculator();
            string retValue = string.Empty;
            try
            {
                retValue = proxyBCRA.CalculateBreastCancerRisks(35, 0, 24, 0, 0, 0, 0, 1);
            }
            catch (System.Web.Services.Protocols.SoapException ex)
            {
                Console.WriteLine(ex.Actor);
                Console.WriteLine(ex.Code);
                Console.WriteLine(ex.Message);
            }

            Console.WriteLine(retValue);
            Console.ReadLine();
        }
    }
}
