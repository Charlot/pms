using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using PmsNCRWcf.Model;

namespace PmsNCRWcf
{
    [ServiceContract]
    public interface IOrderService
    {
       Msg< OrderItemCheck> GetOrderItemForCheck(string machineNr);
    }
}
