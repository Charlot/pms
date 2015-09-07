using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using Brilliantech.Framwork.Utils.ConfigUtil;

namespace PmsNCRWcf.Config
{
    public class ColorConfig
    {
        private static ConfigUtil colorConfig;
        public static Hashtable Colors = new Hashtable();
        static ColorConfig()
        {
            try
            {
                colorConfig = new ConfigUtil("COLOR", "Ini/colors.ini");
                foreach (string s in colorConfig.GetAllNodeKey())
                {
                    Colors.Add(s, colorConfig.Get(s));
                };
            }
            catch (Exception e) { }
        }
    }
}
