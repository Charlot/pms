using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using PmsNCRWcf.Model;
using PmsNCRWcf.Enmu;
using System.Collections;

namespace PmsNCRWcf
{
    [ServiceContract]
    public interface IOrderService
    {
        Msg<OrderItemCheck> GetOrderItemForCheck(string machineNr);
        Msg<string> GetOrderItemForProduce(int orderItemId, bool mirror = false);
        Msg<string> ChangeOrderItemState(string orderItemNr, OrderItemState state, string userNr = null, string userGroupNr = null);
        Msg<OrderItem> ProducePiece(string orderItemNr, int producedQty);
        Msg<List<OrderItemCheck>> GetOrderPreviewList(string machineNr);
        Msg<List<OrderItemCheck>> GetOrderPassedList(string machineNr);
        Msg<string> SetOrderItemTool(string orderItemNr, string tool1Nr, string tool2Nr);
        Msg<List<OrderItemCheck>> SearchOrderItem(params string[] conditions);
    }
}
