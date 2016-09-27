using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;

namespace PmsNCRWcf.Config
{
    public class CheckBoxConfig
    {
        private static ConfigUtil config;
        private static bool tool1Check = true;
        private static bool tool2Check = true;
        private static bool instoreCheck = true;


        static CheckBoxConfig()
        {
            try
            {
                config = new ConfigUtil("CHECKBOXES", "Ini/check_boxes.ini");

                tool1Check = bool.Parse(config.Get("Tool1Check"));
                tool2Check = bool.Parse(config.Get("Tool2Check"));
                instoreCheck = bool.Parse(config.Get("InstoreCheck"));
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public static bool Tool1Check
        {
            get { return CheckBoxConfig.tool1Check; }
            set { CheckBoxConfig.tool1Check = value; }
        }

        public static bool Tool2Check
        {
            get { return CheckBoxConfig.tool2Check; }
            set { CheckBoxConfig.tool2Check = value; }
        }

        public static bool InstoreCheck
        {
            get { return CheckBoxConfig.instoreCheck; }
            set { CheckBoxConfig.instoreCheck = value; }
        }
    }
}
