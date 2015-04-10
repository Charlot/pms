using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PmsNCRWcf.Model;
using Brilliantech.Framwork.Utils.LogUtil;
using PmsNCRWcf.Config;
using RestSharp;
using PmsNCRWcf.Helper;

namespace PmsNCRWcf
{
    public class MachineService : IMachineService
    {
        public Msg<string> SettingIP(string machineNr, string IP)
        {
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(ApiConfig.MachineIPSettingAction, Method.POST);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("machine_nr", machineNr);
                req.AddParameter("ip", IP);
                var res = new ApiClient().Execute(req);
                var data = JSONHelper.parse<Msg<string>>(res.Content);
                if (data != null)
                {
                    msg = data;
                }
                else
                {
                    msg.Content = "API ERROR";
                }
            }
            catch (Exception e)
            {
                msg.Result = false;
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }
    }
}
