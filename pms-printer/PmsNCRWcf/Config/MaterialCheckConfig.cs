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
        private static string areaPattern;

        private static string area1;
        private static string area2;

        private static string wirePrefix;
        private static string wirePattern;
        private static bool wireLockCheck = true;

        private static string terminalPrefix;
        private static string terminalPattern;
        private static bool terminalLockCheck = true;      

        private static string toolPrefix;
        private static string toolPattern;
        private static bool toolLockCheck = false;

        private static bool autoLoad = false;

        
        static MaterialCheckConfig()
        {
            try
            {
                config = new ConfigUtil("SCANCHECK", "Ini/material_check.ini");
                areaPrefix = config.Get("AreaPrefix");
                areaPattern = config.Get("AreaPattern");

                area1 = config.Get("Area1");
                area2 = config.Get("Area2");

                wirePrefix = config.Get("WirePrefix");
                wirePattern = config.Get("WirePattern");
                wireLockCheck = bool.Parse(config.Get("WireLockCheck"));

                terminalPrefix = config.Get("TerminalPrefix");
                terminalPattern = config.Get("TerminalPattern");
                terminalLockCheck = bool.Parse(config.Get("TerminalLockCheck"));

                toolPrefix = config.Get("ToolPrefix");
                toolPattern = config.Get("ToolPattern");
                toolLockCheck = bool.Parse(config.Get("ToolLockCheck"));

                autoLoad = bool.Parse(config.Get("AutoLoad"));
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

        public static string AreaPattern
        {
            get { return MaterialCheckConfig.areaPattern; }
            set { MaterialCheckConfig.areaPattern = value; }
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

        public static string WirePattern
        {
            get { return MaterialCheckConfig.wirePattern; }
            set { MaterialCheckConfig.wirePattern = value; }
        }

        public static string TerminalPrefix
        {
            get { return MaterialCheckConfig.terminalPrefix; }
            set { MaterialCheckConfig.terminalPrefix = value; }
        }


        public static string TerminalPattern
        {
            get { return MaterialCheckConfig.terminalPattern; }
            set { MaterialCheckConfig.terminalPattern = value; }
        }

        public static string ToolPrefix
        {
            get { return MaterialCheckConfig.toolPrefix; }
            set { MaterialCheckConfig.toolPrefix = value; }
        }

        public static string ToolPattern
        {
            get { return MaterialCheckConfig.toolPattern; }
            set { MaterialCheckConfig.toolPattern = value; }
        }

        public static bool WireLockCheck
        {
            get { return MaterialCheckConfig.wireLockCheck; }
            set { MaterialCheckConfig.wireLockCheck = value; }
        }

        public static bool TerminalLockCheck
        {
            get { return MaterialCheckConfig.terminalLockCheck; }
            set { MaterialCheckConfig.terminalLockCheck = value; }
        }
        public static bool ToolLockCheck
        {
            get { return MaterialCheckConfig.toolLockCheck; }
            set { MaterialCheckConfig.toolLockCheck = value; }
        }
        public static bool AutoLoad
        {
            get { return MaterialCheckConfig.autoLoad; }
            set { MaterialCheckConfig.autoLoad = value; }
        }


    }
}
