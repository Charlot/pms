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

namespace PmsTestConsole
{
    class Program
    {

       static  Hashtable colorHash = new Hashtable();
        static void Main(string[] args)
        {
            colorHash.Add("R","Red");
            colorHash.Add("Y", "Yellow");
            colorHash.Add("Br", "Brown");
            colorHash.Add("W", "White");
            colorHash.Add("Gr", "Grey");
            colorHash.Add("Or", "Orange");
            colorHash.Add("B", "Black");
            //string pattern = "^SIDE";
            //Regex r = new Regex(pattern, RegexOptions.IgnoreCase);
            //Regex rr = new Regex("\\w+", RegexOptions.IgnoreCase);
            //Match m = rr.Match("SIDE8");

            //Regex rrr = new Regex("^P", RegexOptions.IgnoreCase);
            //Match mm = rr.Match("PP00");

            //Console.WriteLine(mm.Groups[1].Value);
            //Console.WriteLine(r.Match("SIDE8").Success);
            List<string> cs = Converts("YBr");
            Console.WriteLine("--------------------YBr");
            foreach (string c in cs) {
                Console.WriteLine(c);
            }
            Console.WriteLine("--------------------Y");
            cs = Converts("Y");

            foreach (string c in cs)
            {
                Console.WriteLine(c);
            }

            cs = Converts("BY");
            Console.WriteLine("--------------------BY");
            foreach (string c in cs)
            {
                Console.WriteLine(c);
            }

            cs = Converts("BrY");
            Console.WriteLine("--------------------BrY");
            foreach (string c in cs)
            {
                Console.WriteLine(c);
            }
            cs = Converts("BrBrBrR");
            Console.WriteLine("--------------------BrBrBrR");
            foreach (string c in cs)
            {
                Console.WriteLine(c);
            }
            Console.Read();
            
           // string printer = Console.ReadLine();

           // Console.WriteLine(printer);
           // ConfigUtil config = new ConfigUtil("help.sdc");
           //// Console.WriteLine(config.Get("Host"));
           // Console.WriteLine(config.Notes());
           // foreach (string node in config.Notes()) {
           //     Console.WriteLine(node);
           //     Console.WriteLine(config.Get("Host",node));
           // }
           // foreach (string f in Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.sdc").ToList()) {
           //     Console.WriteLine(f);
           // }
            
           // Console.WriteLine(DateTime.Now.ToString("HHmmsss"));

         //   Console.WriteLine("J_0001,9".Split(',')[0].TrimStart("J_".ToCharArray()));
            //try
            //{
            //    RecordSet rs = new RecordSet();
            //    RecordData rd = new RecordData();
            //    rd.Add("A", "AAA");
            //    rs.Add(rd);
            //    if (printer.Length == 0) {
            //        printer = "Zebra ZM400 (203 dpi) - ZPL";
            //    }
            //    IReportGen gen = new TecITGener();
            //    ReportGenConfig config = new ReportGenConfig()
            //    {
            //         //Printer = "Microsoft XPS Document Writer",
            //        //Printer = "Zebra ZM400 (203 dpi) - ZPL (副本 3)",
            //        Printer=printer,
            //        NumberOfCopies = 1,
            //        PrinterType = (PrinterType)0,
            //        Template = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Template\\t1.tff")
            //    };

            //    gen.Print(rs, config);
            //}
            //catch (Exception e)
            //{
            //    Console.WriteLine(e.Message);
            //    Console.Read();
            //}
        }

        public static List<string> Converts(string colors)
        {
            colors = colors + "#";
            List<string> colorList = new List<string>();
            if (!string.IsNullOrEmpty(colors))
            {
                int startIndex = 0;
                for (int i = 0; i < colors.Length; i++)
                {
                    string color = string.Empty;
                     
                        if (i == colors.Length - 1)
                        {
                           colorList.Add(Convert(colors.Substring(startIndex, i - startIndex)));
                        }
                        else
                        {
                            color = Convert(colors.Substring(startIndex, i - startIndex + 1));
                            if (color == null)
                            {
                                colorList.Add(Convert(colors.Substring(startIndex, i - startIndex)));
                                startIndex = i;
                                i -= 1;
                            }
                        } 
                }
            }
            if (colorList.Count == 0)
            {
                colorList = null;
            }
            return colorList;
        }

        public static string Convert(string color)
        {
            try
            {
                if (colorHash[color] != null)
                {
                    return colorHash[color].ToString();
                }
            }
            catch (Exception e)
            {
                return null;
            }
            return null;
        }
    }
}
