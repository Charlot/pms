using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PmsPrinterWpf.IService;
using PmsPrinterWpf.Model;
using RestSharp;
using PmsPrinterWpf.Setting;
using Brilliantech.Framwork.Utils.LogUtil;
using PmsPrinterWpf.Helper;

namespace PmsPrinterWpf.Service
{
    public class KanbanService : IKanbanService
    {

        public Msg<string> GetPrintCode(string kanbanNr)
        {
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(ApiConfig.KanbanPrintCodeAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("nr", kanbanNr);  

                var res = new APIClient().Execute(req);
                var code =JSONHelper.parse<string>( res.Content);
                if (code != null && code.Length>0)
                { 
                    msg.Result = true;
                    msg.Object = code;
                }
                else
                {
                    msg.Content = "看板号："+kanbanNr+" 不存在！";
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
