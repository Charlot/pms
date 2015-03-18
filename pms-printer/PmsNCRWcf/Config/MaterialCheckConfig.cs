using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;

namespace PmsNCRWcf.Config
{
    public class MaterialCheckConfig
    {        
        private static ConfigUtil config;
        private static string areaPrefix;       
        private static string area1;
        private static string area2;
        private static string wirePrefix;
        private static string terminalPrefix;
        private static string toolPrefix;      

        static MaterialCheckConfig()
        {
            try
            {
                config = new ConfigUtil("SCANCHECK", "Ini/material_check.ini");
                areaPrefix = config.Get("Area");
                area1 = config.Get("Area1");
                area2 = config.Get("Area2");
                wirePrefix = config.Get("Wire");
                terminalPrefix = config.Get("Terminal");
                toolPrefix = config.Get("Tool");

            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public static string AreaPrefix
        {
            get { return MaterialCheckConfig.areaPrefix; }
            set { MaterialCheckConfig.areaPrefix = value; }
        }

        public static string Area1
        {
            get { return MaterialCheckConfig.area1; }
            set { MaterialCheckConfig.area1 = value; }
        }
        public static string Area2
        {
            get { return MaterialCheckConfig.area2; }
            set { MaterialCheckConfig.area2 = value; }
        }
        public static string WirePrefix
        {
            get { return MaterialCheckConfig.wirePrefix; }
            set { MaterialCheckConfig.wirePrefix = value; }
        }
        public static string TerminalPrefix
        {
            get { return MaterialCheckConfig.terminalPrefix; }
            set { MaterialCheckConfig.terminalPrefix = value; }
        }

        public static string ToolPrefix
        {
            get { return MaterialCheckConfig.toolPrefix; }
            set { MaterialCheckConfig.toolPrefix = value; }
        }
    }
}
