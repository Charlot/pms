using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;
using System.IO;
using Brilliantech.ReportGenConnector;
using TECIT.TFORMer;
using System.Text.RegularExpressions;
using System.Collections;
using System.Management;
using System.Collections.Specialized;


namespace PmsTestConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(CheckMutiTool("WZ001,WZ002","WZ002"));
            Console.Read();
        }

        private static bool CheckMutiTool(string tools, string tool)
        {
            Console.WriteLine(string.Format(",{0},", tools));

            Console.WriteLine(string.Format(",{0},", tool));

            return string.Format(",{0},", tools).Contains(string.Format(",{0},", tool));
        }
    }
}
