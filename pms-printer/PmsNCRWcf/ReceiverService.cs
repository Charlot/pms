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

namespace PmsNCRWcf
{
    // 注意: 使用“重构”菜单上的“重命名”命令，可以同时更改代码和配置文件中的类名“Service1”。
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ReceiverService : IReceiverService
    {
        public Msg<string> WriteOrder(string file_name, string order_nr, string item_nr, string file_json_content)
        {
            Msg<string> msg = new Msg<string>();
            try
            {

                LogUtil.Logger.Info(file_name);
                LogUtil.Logger.Info(file_json_content);

                if (FileInfoHelper.CheckDir(WPCSConfig.OrderDir))
                {
                    using (FileStream fs = new FileStream(Path.Combine(WPCSConfig.OrderDir, file_name + ".json"), FileMode.Create, FileAccess.Write))
                    {
                        using (StreamWriter sw = new StreamWriter(fs))
                        {
                            msg.Result = true;
                            sw.Write(file_json_content);
                        }
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
