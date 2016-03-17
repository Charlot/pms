using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;

namespace PmsNCRWcf.Config
{
    public class SPCConfig
    {
        private static ConfigUtil config; 

        static SPCConfig()
        {
            try
            { 
                config = new ConfigUtil("SPC", "Ini/spc.ini");
                Com = config.Get("COM");
                RuleValueRegex = config.Get("RuleValueRegex");
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public static string Com { get; set; }
        public static string RuleValueRegex { get; set; }
    }
}