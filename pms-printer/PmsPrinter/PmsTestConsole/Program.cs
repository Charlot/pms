using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;
using System.IO;

namespace PmsTestConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            ConfigUtil config = new ConfigUtil("help.sdc");
           // Console.WriteLine(config.Get("Host"));
            Console.WriteLine(config.Notes());
            foreach (string node in config.Notes()) {
                Console.WriteLine(node);
                Console.WriteLine(config.Get("Host",node));
            }
            foreach (string f in Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory, "*.sdc").ToList()) {
                Console.WriteLine(f);
            }

            Console.WriteLine(DateTime.Now.ToString("HHmmsss"));
            Console.Read();
        }
    }
}
