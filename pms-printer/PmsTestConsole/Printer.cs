using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;
using System.Management;

namespace PmsTestConsole
{
    public class Printer
    {

        public static StringCollection GetPrintsWithDrivername(string strDrivername)
        {
            StringCollection scPrinters = new StringCollection();
            string strcheck = "";
            if (strDrivername != "" && strDrivername != "*")
                strcheck = " where DriverName like \'" + strDrivername + "\'";
            string searchQuery = "SELECT Name FROM Win32_Printer";// +strcheck;
            ManagementObjectSearcher searchPrinters =
             new ManagementObjectSearcher(searchQuery);
            ManagementObjectCollection printerCollection = searchPrinters.Get();

            foreach (ManagementObject printer in printerCollection)
            {
                PropertyDataCollection c = printer.Properties;
                foreach (PropertyData property in c)
                {
               string name=     property.Name;
                }
                string printname = printer.Properties["Name"].Value.ToString();
                scPrinters.Add(printname);
            } 
            searchPrinters.Dispose();
            printerCollection.Dispose();
            return scPrinters;
        }
    }
}
