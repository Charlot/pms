using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using PmsNCRWcf.Model;
using PmsNCRWcf.Helper;
using PmsNCRWcf.Config;
using System.IO;
using Brilliantech.Framwork.Utils.LogUtil;
using System.ServiceModel.Activation;
using System.ServiceModel.Channels;
using System.ServiceModel.Web;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Web;
using PmsNCRWcf.Converter;

namespace PmsNCRWcf
{

    public class ReceiverService : IReceiverService
    {  
        public Msg<string> ReceiveOrder()
        {
            Msg<string> msg = new Msg<string>();
            try
            {
                string postJson = string.Empty;
                using (var reader = OperationContext.Current.RequestContext.RequestMessage.GetReaderAtBodyContents())
                {
                    if (reader.Read())
                    {
                        postJson = new string(Encoding.UTF8.GetChars(reader.ReadContentAsBase64()));

                        LogUtil.Logger.Info("【RECEIVE】 ORDER");
                        LogUtil.Logger.Info(HttpUtility.UrlDecode(postJson.Split('=')[1]));

                        JObject o = JObject.Parse(HttpUtility.UrlDecode(postJson.Split('=')[1]));
                        Dictionary<string, object> v = o.ToObject<Dictionary<string, object>>();

                        OrderItemFile order = new OrderItemFile()
                        {
                            OrderNr = v["order_nr"].ToString(),
                            ItemNr = v["item_nr"].ToString(),
                            FileName = v["file_name"].ToString(),
                            FileContent = v["file_json_content"].ToString()
                        };

                        msg.Result = order.WriteToFile();
                    }
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