using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace PmsNCR.Helper
{
    public class SettingReader
    {
        public static string OrderAbortPasswd {
            get { 
                return   ConfigurationManager.AppSettings["OrderAbortPasswd"];
            }
        }

    }
}
