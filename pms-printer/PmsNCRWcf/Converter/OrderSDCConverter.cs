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
        public static bool ParseSDCToServer(string filePath, string machineNr = null)
        {
            ConfigUtil config = new ConfigUtil(filePath);
            OrderService service = new OrderService();

            foreach (string node in config.Notes())
            {
                switch (node)
                {
                    case "JobStarted":
                        return service.ChangeOrderItemState(GetJobNr(config.Get("Job", node)), OrderItemState.STARTED).Result;
                    case "JobRestarted":
                        return service.ChangeOrderItemState(GetJobNr(config.Get("Job", node)), OrderItemState.RESTARTED).Result;
                    case "JobPaused":
                        return service.ChangeOrderItemState(GetJobNr(config.Get("Job", node)), OrderItemState.PAUSED).Result;
                    case "JobInterrupted":
                        return service.ChangeOrderItemState(GetJobNr(config.Get("Job", node)), OrderItemState.INTERRUPTED).Result;
                    case "JobAborted":
                        return service.ChangeOrderItemState(GetJobNr(config.Get("Job", node)), OrderItemState.ABORTED).Result;
                    case "JobTerminated":
                        // PrintKanban();
                        string orderNr = GetJobNr(config.Get("Job", node));
                        new PrintService().PrintKB("P002", orderNr);
                        return service.ChangeOrderItemState(orderNr, OrderItemState.TERMINATED).Result;
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
                        break;
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
