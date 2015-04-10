using System;
using System.Collections.Generic;
using System.Linq;
using System.Text; 
using Brilliantech.Framwork.Utils.LogUtil;
using RestSharp;
using PmsPrinterWpf.Setting;
using Brilliantech.ReportGenConnector;
using System.IO;
using System.Runtime.Serialization.Json;
using PmsPrinterWpf.IService;
using PmsPrinterWpf.Model;

namespace PmsPrinterWpf.Service
{
    public class PrintService:IPrintService
    {
        public Msg<string> Print(string code, string id, string printer_name = null, string copy = null)
        {
            Msg<string> msg = new Msg<string>();
            try {

                var req = new RestRequest(ApiConfig.PrintDataAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("code", code);
                req.AddParameter("id", id);
                Printer printer = PrinterConfig.Find(code);
                 
                var res = new APIClient().Execute(req);
                var data = parse<RecordSet>(res.Content);
                if (data != null && data.Count > 0)
                {
                    printer.Print(data, printer_name, copy);
                    msg.Result = true;
                    msg.Content = "打印成功";
                }
                else
                {
                    msg.Content = "打印失败,无打印内容";
                }
            }
            catch (Exception e) {
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }
        public T parse<T>(string jsonString)
        {
            using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(jsonString)))
            {
                return (T)new DataContractJsonSerializer(typeof(T)).ReadObject(ms);
            }
        }

        public static string stringify(object jsonObject)
        {
            using (var ms = new MemoryStream())
            {
                new DataContractJsonSerializer(jsonObject.GetType()).WriteObject(ms, jsonObject);
                return Encoding.UTF8.GetString(ms.ToArray());
            }
        }
    }
}
