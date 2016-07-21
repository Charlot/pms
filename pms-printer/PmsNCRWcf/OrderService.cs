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
using System.Collections;

namespace PmsNCRWcf
{
    public class OrderService : IOrderService
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
                    msg.Content = "No Order";
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

        /// <summary>
        /// get item for produce
        /// </summary>
        /// <param name="orderItemId"></param>
        /// <returns></returns>
        public Msg<string> GetOrderItemForProduce(int orderItemId, string machine_type = null, bool mirror = false)
        {
            Msg<string> msg = new Msg<string>();
            var req = new RestRequest(ApiConfig.OrderItemForProduceAction, Method.GET);
            req.RequestFormat = DataFormat.Json;
            req.AddParameter("order_item_id", orderItemId);
            if (mirror)
            {
                req.AddParameter("mirror", mirror);
            }

            if (machine_type != null)
            {
                req.AddParameter("machine_type", machine_type);
            }

            var res = new ApiClient().Execute(req);
            var data = res.Content;
            if (data != null)
            {
                msg.Result = true;
                msg.Object = data;
            }
            else
            {
                msg.Content = "No Order";
            }
            return msg;
        }

        /// <summary>
        /// change order item state
        /// </summary>
        /// <param name="orderItemNr"></param>
        /// <param name="state"></param>
        /// <returns></returns>
        public Msg<string> ChangeOrderItemState(string orderItemNr, OrderItemState state, string userNr = null, string userGroupNr = null)
        {

            Msg<string> msg = new Msg<string>();
            var req = new RestRequest(ApiConfig.OrderItemUpdateStateAction, Method.PUT);
            req.RequestFormat = DataFormat.Json;
            req.AddParameter("order_item_nr", orderItemNr);
            req.AddParameter("state", (int)state);
            req.AddParameter("user_nr", userNr);
            req.AddParameter("user_group_nr", userGroupNr);
            var res = new ApiClient().Execute(req);
            var data = res.Content;
            if (data != null)
            {
                msg.Result = true;
                msg.Object = data;
            }
            else
            {
                msg.Content = "No Order";
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

        public Msg<List<OrderItemCheck>> GetOrderPassedList(string machineNr)
        {
            Msg<List<OrderItemCheck>> msg = new Msg<List<OrderItemCheck>>();
            try
            {
                var req = new RestRequest(ApiConfig.OrderListPassedAction, Method.GET);
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

        public Msg<string> SetOrderItemTool(string orderItemNr, string tool1Nr, string tool2Nr)
        {
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(ApiConfig.OrderToolSettingAction, Method.POST);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("order_item_nr", orderItemNr);
                req.AddParameter("tool1_nr", tool1Nr);
                req.AddParameter("tool2_nr", tool2Nr);
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


        public Msg<List<OrderItemCheck>> SearchOrderItem(params string[] conditions)
        {
            Msg<List<OrderItemCheck>> msg = new Msg<List<OrderItemCheck>>();
            try
            {
                var req = new RestRequest(ApiConfig.OrderItemSearchAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("wire_nr", conditions[0]);
                var res = new ApiClient().Execute(req);
                var data = JSONHelper.parse<List<OrderItemCheck>>(res.Content);
                if (data != null)
                {
                    msg.Result = true;
                    msg.Object = data;
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

        public Msg<Dictionary<string, SPCStandard>> OrderItemGetConfigAction(params string[] SpcStandard)
        {

            Msg<Dictionary<string, SPCStandard>> msg = new Msg<Dictionary<string, SPCStandard>>();
            try
            {
                var req = new RestRequest(ApiConfig.OrderItemGetConfigAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("production_order_item_id", SpcStandard[0]);
                var res = new ApiClient().Execute(req);
                msg = JSONHelper.parse<Msg<Dictionary<string, SPCStandard>>>(res.Content);
                if (msg.Result)
                {
                    if (msg.Object == null)
                    {
                        msg.Result = false;
                        msg.Content = "API ERROR";
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

        public Msg<string> StoreMeasuredData(params string[] MeasuredData)
        {
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(ApiConfig.StoreMeasuredData, Method.POST);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("production_order_id", MeasuredData[0]);
                req.AddParameter("part_id", MeasuredData[1]);
                req.AddParameter("crimp_height_1", MeasuredData[2]);
                req.AddParameter("crimp_height_2", MeasuredData[3]);
                req.AddParameter("crimp_height_3", MeasuredData[4]);
                req.AddParameter("crimp_height_4", MeasuredData[5]);
                req.AddParameter("crimp_height_5", MeasuredData[6]);
                req.AddParameter("crimp_width", MeasuredData[7]);
                req.AddParameter("i_crimp_heigth", MeasuredData[8]);
                req.AddParameter("i_crimp_width", MeasuredData[9]);
                req.AddParameter("pulloff_value", MeasuredData[10]);
                req.AddParameter("note", MeasuredData[11]);
                req.AddParameter("machine_id", MeasuredData[12]);

                var res = new ApiClient().Execute(req);
                msg = JSONHelper.parse<Msg<string>>(res.Content);
                if (msg.Result)
                {
                    if (msg.Object == null)
                    {
                        msg.Result = false;
                        msg.Content = "API ERROR";
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

        public Msg<string> StoreScrapData(ScrapData ScrapData)
        {
            Msg<string> msg = new Msg<string>();
            try
            {
                var req = new RestRequest(ApiConfig.StoreScrapData, Method.POST);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("scraps", JSONHelper.stringify(ScrapData));

                var res = new ApiClient().Execute(req);
                msg = JSONHelper.parse<Msg<string>>(res.Content);

                //if (msg.Result)
                //{
                //    if (msg.Object == null)
                //    {
                //        msg.Result = false;
                //        msg.Content = "API ERROR";
                //    }
                //}
            }
            catch (Exception e)
            {
                msg.Result = false;
                msg.Content = e.Message;
                LogUtil.Logger.Error(e.Message);
            }
            return msg;
        }


        public Msg<OrderItemCheck> GetOrderItemByNr(string nr)
        {

            Msg<OrderItemCheck> msg = new Msg<OrderItemCheck>();
            try
            {
                var req = new RestRequest(ApiConfig.GetOrderItemByNrAction, Method.GET);
                req.RequestFormat = DataFormat.Json;
                req.AddParameter("nr", nr);
                var res = new ApiClient().Execute(req);
                var data = JSONHelper.parse<OrderItemCheck>(res.Content);
                if (data != null)
                {
                    msg.Result = true;
                    msg.Object = data;
                }
                else
                {
                    msg.Content = "No Order";
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
