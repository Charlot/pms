using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using PmsNCRWcf.Model;
using System.ServiceModel.Web; 

namespace PmsNCRWcf
{
    // 注意: 使用“重构”菜单上的“重命名”命令，可以同时更改代码和配置文件中的接口名“IService1”。
    [ServiceContract]
    public interface IReceiverService
    {
        /// <summary>
        /// 为Server推送Order数据提供接口
        /// </summary>
        /// <returns></returns>
        [WebInvoke(Method = "POST", UriTemplate = "receive_order",
            ResponseFormat = WebMessageFormat.Json,
            RequestFormat = WebMessageFormat.Json,
            BodyStyle = WebMessageBodyStyle.WrappedRequest)]
        [OperationContractAttribute(Name = "Order")]
        Msg<string> ReceiveOrder();
    }
}
