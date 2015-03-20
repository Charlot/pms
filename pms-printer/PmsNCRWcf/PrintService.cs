
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PmsNCRWcf.Model;
using RestSharp;
using PmsNCRWcf.Config;
using Brilliantech.ReportGenConnector;
using Brilliantech.Framwork.Utils.LogUtil;
using PmsNCRWcf.Helper;

namespace PmsNCRWcf
{
    public class PrintService : IPrintService
    {
        public  Msg<string> Print(string code, string id)
        {
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(ApiConfig.PrintDataAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("code", code);
                req.AddParameter("id", id);
                Printer printer = PrinterConfig.Find(code);

                var res = new ApiClient().Execute(req);
                var data = JSONHelper.parse<RecordSet>(res.Content);
                if (data != null && data.Count > 0)
                {
                    printer.Print(data);
                    msg.Result = true;
                    msg.Content = "打印成功";
                }
                else
                {
                    msg.Content = "打印失败,无打印内容";
                }
            }
            catch (Exception e)
            {
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }


        public Msg<string> PrintKB(string code, string orderNr)
        {
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(ApiConfig.PrintKBAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("code", code);
                req.AddParameter("order_nr", orderNr);
                Printer printer = PrinterConfig.Find(code);

                var res = new ApiClient().Execute(req);
                var data = JSONHelper.parse<RecordSet>(res.Content);
                if (data != null && data.Count > 0)
                {
                    printer.Print(data);
                    msg.Result = true;
                    msg.Content = "打印成功";
                }
                else
                {
                    msg.Content = "打印失败,无打印内容";
                }
            }
            catch (Exception e)
            {
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }

    }
}
