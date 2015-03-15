using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace PmsNCRWcf.Config
{
    public class WPCSConfig
    {
        private static string orderFolder;
        private static string orderDir;

        private static string dataFolder;
        private static string dataDir;
        

        static WPCSConfig()
        {
            orderFolder = "Order";
            orderDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, orderFolder);

            dataFolder = "WPCSData";
            dataDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, dataFolder);
        }

        public static string OrderFolder
        {
            get { return WPCSConfig.orderFolder; }
            set { WPCSConfig.orderFolder = value; }
        }
        public static string DataFolder
        {
            get { return WPCSConfig.dataFolder; }
            set { WPCSConfig.dataFolder = value; }
        }

        public static string OrderDir {
            get { return WPCSConfig.orderDir; }
        }

        public static string DataDir
        {
            get { return WPCSConfig.dataDir; }
        }

        public static string GetFullPath(string fileName) {
            return Path.Combine(WPCSConfig.OrderDir, fileName);
        }
    }
}
