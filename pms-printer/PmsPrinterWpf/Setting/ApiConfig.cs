using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;

namespace PmsPrinterWpf.Setting
{
    public class ApiConfig
    {
        private static ConfigUtil config;
        private static string host;
        private static string port;


        static ApiConfig()
        {
            try
            {
                config = new ConfigUtil("API", "Ini/api.ini");
                Protocal = config.Get("Protocal");
                host = config.Get("Host");
                port = config.Get("Port");
                ApiUri = config.Get("ApiUri");
                if (port == "")
                    BaseUri = Protocal + "://" + host + ApiUri;
                else
                    BaseUri = Protocal + "://" + host + ":" + port + ApiUri;
                Token = config.Get("Token");
                PrintDataAction = config.Get("PrintDataAction");
                KanbanPrintCodeAction = config.Get("KanbanPrintCodeAction");
                KanbanListAction = config.Get("KanbanListAction");
                KanbanTypeListAction = config.Get("KanbanTypeListAction");
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public static string Protocal { get; set; }
        public static string Host
        {
            get { return host; }
            set
            {
                host = value;
                BaseUri = Protocal + "://" + host + ":" + port + ApiUri;
                config.Set("Host", value);
                config.Save();
            }
        }
        public static string Port
        {
            get { return port; }
            set
            {
                port = value;
                BaseUri = Protocal + "://" + host + ":" + port + ApiUri;
                config.Set("Port", value);
                config.Save();
            }
        }

        public static string ApiUri { get; set; }
        public static string BaseUri { get; set; }
        public static string Token { get; set; }
        public static string PrintDataAction { get; set; }
        public static string KanbanPrintCodeAction { get; set; }
        public static string KanbanListAction { get; set; }
        public static string KanbanTypeListAction { get; set; }
    }
}
