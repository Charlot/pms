using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using log4net.Config;

namespace Brilliantech.Framwork.Utils.LogUtil
{
    public class LogUtil
    {
        private static readonly ILog logger =
           LogManager.GetLogger(typeof(LogUtil));

        static LogUtil()
        {
            XmlConfigurator.Configure(); 
        }

        public static ILog Logger
        {
            get { return LogUtil.logger; }
        }
    }
}
