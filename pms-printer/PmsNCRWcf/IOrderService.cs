using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using PmsNCRWcf.Model;
using PmsNCRWcf.Enmu;

namespace PmsNCRWcf
{
    [ServiceContract]
    public interface IOrderService
    {
       Msg< OrderItemCheck> GetOrderItemForCheck(string machineNr);
       Msg<string> GetOrderItemForProduce(int orderItemId);
       Msg<string> ChangeOrderItemState(string orderItemNr, OrderItemState state);
       Msg<OrderItem> ProducePiece(string orderItemNr, int producedQty);
       Msg<List<OrderItemCheck>> GetOrderPreviewList(string machineNr);
    }
}
