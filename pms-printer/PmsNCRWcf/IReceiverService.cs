using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using PmsNCRWcf.Model;
using System.ServiceModel.Web;
using System.ServiceModel.Activation;

namespace PmsNCRWcf
{
    // 注意: 使用“重构”菜单上的“重命名”命令，可以同时更改代码和配置文件中的接口名“IService1”。
    [ServiceContract] 
    public interface IReceiverService
    {
        //[WebInvoke(Method = "POST",
        //    UriTemplate = "write_order/{file_name}/{order_nr}/{item_nr}/{file_json_content}",
        //    ResponseFormat = WebMessageFormat.Json,
        //    RequestFormat = WebMessageFormat.Json,
        //    BodyStyle = WebMessageBodyStyle.WrappedRequest)]
       //[WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest)]
       [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.WrappedRequest)]
        //[OperationContractAttribute(Name = "Order")]
        Msg<string> WriteOrder(string file_name, string order_nr, string item_nr, string file_json_content);
    }
}
