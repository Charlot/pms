using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PmsNCRWcf.Model;
using Brilliantech.Framwork.Utils.LogUtil;
using System.ServiceModel.Web;
using PmsNCRWcf.Config;
using RestSharp;
using PmsNCRWcf.Helper;
using PmsNCRWcf.Enmu;

namespace PmsNCRWcf
{
    public class OrderService:IOrderService
    { 
        /// <summary>
        /// get item for check
        /// </summary>
        /// <param name="machineNr"></param>
        /// <returns></returns>
        public Msg<OrderItemCheck> GetOrderItemForCheck(string machineNr)
        {
            Msg<OrderItemCheck> msg = new Msg<OrderItemCheck>();
            try
            {
                var req = new RestRequest(ApiConfig.OrderFirstForCheckAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("machine_nr", machineNr);
                var res = new ApiClient().Execute(req);
                var data = JSONHelper.parse<OrderItemCheck>(res.Content);
                if (data != null)
                { 
                    msg.Result = true;
                    msg.Object = data;
                }
                else
                {
                    msg.Content = "不存在需要生产的订单，请联系相关人员";
                }
            }
            catch (Exception e) {
                msg.Result = false;
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }

        /// <summary>
        /// get item for produce
        /// </summary>
        /// <param name="orderItemId"></param>
        /// <returns></returns>
        public Msg<string> GetOrderItemForProduce(int orderItemId)
        {
            Msg<string> msg = new Msg<string>();
            var req = new RestRequest(ApiConfig.OrderItemForProduceAction, Method.GET);
            req.RequestFormat = DataFormat.Json;
            req.AddParameter("order_item_id", orderItemId);
            var res = new ApiClient().Execute(req);
            var data = res.Content;
            if (data != null)
            {
                msg.Result = true;
                msg.Object = data;
            }
            else
            {
                msg.Content = "不存在需要生产的订单，请联系相关人员";
            }
            return msg;
        }

        /// <summary>
        /// change order item state
        /// </summary>
        /// <param name="orderItemNr"></param>
        /// <param name="state"></param>
        /// <returns></returns>
        public Msg<string> ChangeOrderItemState(string orderItemNr, OrderItemState state)
        {

            Msg<string> msg = new Msg<string>();
            var req = new RestRequest(ApiConfig.OrderItemUpdateStateAction, Method.PUT);
            req.RequestFormat = DataFormat.Json;
            req.AddParameter("order_item_nr", orderItemNr);
            req.AddParameter("state", (int)state);
            var res = new ApiClient().Execute(req);
            var data = res.Content;
            if (data != null)
            {
                msg.Result = true;
                msg.Object = data;
            }
            else
            {
                msg.Content = "不存在需要生产的订单，请联系相关人员";
            }
            return msg;
        }

        /// <summary>
        /// produce piece in order item
        /// </summary>
        /// <param name="orderItemNr"></param>
        /// <param name="producedQty"></param>
        /// <returns></returns>
        public Msg<OrderItem> ProducePiece(string orderItemNr, int producedQty)
        {
            Msg<OrderItem> msg = new Msg<OrderItem>();
            try
            {
                var req = new RestRequest(ApiConfig.ProducePieceAction, Method.POST);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("order_item_nr", orderItemNr);
                req.AddParameter("produced_qty", producedQty);
                var res = new ApiClient().Execute(req);
                var c = res.Content;

                var data = JSONHelper.parse<OrderItem>(res.Content);
                if (data != null)
                {
                    msg.Result = true;
                    msg.Object = data;
                }
                else
                {
                    msg.Content = "API 返回错误，请联系相关人员";
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


        public Msg<List<OrderItemCheck>> GetOrderPreviewList(string machineNr)
        {
            Msg<List<OrderItemCheck>> msg = new Msg<List<OrderItemCheck>>();
            try
            {
                var req = new RestRequest(ApiConfig.OrderListPreviewAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("machine_nr", machineNr);
                var res = new ApiClient().Execute(req);
                var data = JSONHelper.parse<List<OrderItemCheck>>(res.Content);
                if (data != null)
                {
                    msg.Result = true;
                    msg.Object = data;
                }
                else
                {
                    msg.Content = "API 返回数据错误，请联系相关人员";
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
        private bool setHead()
        {
            WebOperationContext.Current.OutgoingResponse.Headers.Add("Access-Control-Allow-Origin", "*");
            if (WebOperationContext.Current.IncomingRequest.Method == "OPTIONS")
            {
                WebOperationContext.Current.OutgoingResponse.Headers
                    .Add("Access-Control-Allow-Methods", "POST, OPTIONS, GET");
                WebOperationContext.Current.OutgoingResponse.Headers
                    .Add("Access-Control-Allow-Headers",
                         "Content-Type, Accept, Authorization, x-requested-with");
                return false;
            }
            return true;
        }


    }
}
