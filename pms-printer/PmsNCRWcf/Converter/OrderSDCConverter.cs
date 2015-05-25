using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;
using PmsNCRWcf.Enmu;
using PmsNCRWcf.Model;
using Brilliantech.Framwork.Utils.LogUtil;

namespace PmsNCRWcf.Converter
{
    public class OrderSDCConverter
    {
        public static bool ParseSDCToServer(string filePath, string machineNr = null,string userNr=null,string userGroupNr=null)
        {
            ConfigUtil config = new ConfigUtil(filePath);
            OrderService service = new OrderService();

            foreach (string node in config.Notes())
            {
                switch (node)
                {
                    case "JobStarted":
                        string jobNr = GetJobNr(config.Get("Job", node));
                        new PrintService().PrintKB("P002", jobNr,machineNr);
                        return service.ChangeOrderItemState(jobNr, OrderItemState.STARTED,userNr,userGroupNr).Result;
                    case "JobRestarted":
                        string jobNr1 = GetJobNr(config.Get("Job", node));
                        int piece3 = int.Parse(config.Get("TotalGoodPieces", node));
                        if (piece3 == 0)
                        {
                            new PrintService().PrintKB("P002", jobNr1, machineNr);
                        }
                        return service.ChangeOrderItemState(jobNr1, OrderItemState.RESTARTED, userNr, userGroupNr).Result;
                    case "JobPaused":
                        return service.ChangeOrderItemState(GetJobNr(config.Get("Job", node)), OrderItemState.PAUSED, userNr, userGroupNr).Result;
                    case "JobInterrupted":
                        return service.ChangeOrderItemState(GetJobNr(config.Get("Job", node)), OrderItemState.INTERRUPTED, userNr, userGroupNr).Result;
                    case "JobAborted":
                        return service.ChangeOrderItemState(GetJobNr(config.Get("Job", node)), OrderItemState.ABORTED, userNr, userGroupNr).Result;
                    //case "JobTerminated":
                    //    // PrintKanban();
                    //    string orderNr = GetJobNr(config.Get("Job", node));
                    //      new PrintService().PrintKB("P002", orderNr);
                    //    return service.ChangeOrderItemState(orderNr, OrderItemState.TERMINATED).Result;               

                    case "ProductionInterrupted":
                        string pOrderNr = GetJobNr(config.Get("Job", node));
                        int piece = int.Parse(config.Get("TotalGoodPieces", node));
                        Msg<OrderItem> msg = service.ProducePiece(pOrderNr, piece);
                        if (msg.Result)
                        {
                            OrderItem item = msg.Object;
                            if (piece % item.BundleQuantity == 0 && piece > 0)
                            {
                                new PrintService().PrintBundleLabel("P003", pOrderNr, machineNr, piece / item.BundleQuantity);
                            }
                            return true;
                        }
                        break;
                    case "ProductionTerminated":
                        string pOrderNr2 = GetJobNr(config.Get("Job", node));                       
                        int piece2 = int.Parse(config.Get("TotalGoodPieces", node));
                        Msg<OrderItem> msg2 = service.ProducePiece(pOrderNr2, piece2);
                        if (msg2.Result)
                        {
                            OrderItem item = msg2.Object;
                            if (piece2 > 0)
                            {
                                if (piece2 % item.BundleQuantity == 0)
                                {
                                    new PrintService().PrintBundleLabel("P003", pOrderNr2, machineNr, piece2 / item.BundleQuantity);
                                }
                                else {
                                    if (piece2 >= item.TotalQuantity) {
                                        new PrintService().PrintBundleLabel("P003", pOrderNr2, machineNr, piece2 / item.BundleQuantity+1);
                                    }
                                }
                            }                             
                        }                    
                       return  service.ChangeOrderItemState(pOrderNr2, OrderItemState.TERMINATED, userNr, userGroupNr).Result; 
                         
                    default:
                        break;
                }
            }
            return false;
        }

        private static string GetJobNr(string jobNr)
        {
            return jobNr.Split(',')[0].TrimStart("J_".ToCharArray());
        }
    }
}
