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

        /// <summary>
        /// 
        /// </summary>
        /// <param name="type"></param>
        /// <param name="page">page start from 1</param>
        /// <returns></returns>
        public Msg<List<Kanban>> List(int type, int page)
        {
            Msg<List<Kanban>> msg = new Msg<List<Kanban>>();
            try
            {
                var req = new RestRequest(ApiConfig.KanbanListAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("type", type);
                req.AddParameter("page", page);

                var res = new APIClient().Execute(req);
                var kanbans = JSONHelper.parse<List<Kanban>>(res.Content);
                if (kanbans != null && kanbans.Count > 0)
                {
                    msg.Result = true;
                    msg.Object = kanbans;
                }
                else
                {
                    msg.Content = "无看板";
                }
            }
            catch (Exception e)
            {
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }

        public Msg<List<SelectOption>> TypeList()
        {
            Msg<List<SelectOption>> msg = new Msg<List<SelectOption>>();
            try
            {
                var req = new RestRequest(ApiConfig.KanbanTypeListAction, Method.GET);
                req.RequestFormat = DataFormat.Json; 

                var res = new APIClient().Execute(req);
                var types = JSONHelper.parse<List<SelectOption>>(res.Content);
                if (types != null && types.Count > 0)
                {
                    msg.Result = true;
                    msg.Object = types;
                }
                else
                {
                    msg.Content = "无看板类型";
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
