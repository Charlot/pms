using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Brilliantech.Framwork.Utils.ConfigUtil;
using PmsNCRWcf.Enmu;

namespace PmsNCRWcf.Converter
{
    public class OrderSDCConverter
    {
        public static bool ParseSDCToServer(string filePath)
        {
            ConfigUtil config = new ConfigUtil(filePath);
            OrderService service = new OrderService();

            foreach (string node in config.Notes()) {
                switch (node)
                {
                    case "JobStarted":
                        service.ChangeOrderItemState(config.Get("Job",node).Split(',')[0], OrderItemState.STARTED);
                        break;
                    case "JobRestarted":
                        service.ChangeOrderItemState(config.Get("Job", node).Split(',')[0], OrderItemState.RESTARTED);
                        break;
                    case "JobPaused":
                        service.ChangeOrderItemState(config.Get("Job", node).Split(',')[0], OrderItemState.PAUSED);
                        break;
                    case "JobInterrupted":
                        service.ChangeOrderItemState(config.Get("Job", node).Split(',')[0], OrderItemState.INTERRUPTED);
                        break;
                    case "JobAborted":
                        service.ChangeOrderItemState(config.Get("Job", node).Split(',')[0], OrderItemState.ABORTED);
                        break;
                    case "JobTerminated":
                        // PrintKanban();
                        service.ChangeOrderItemState(config.Get("Job", node).Split(',')[0], OrderItemState.TERMINATED);
                        break;
                }

            }
            return false;
        }
    }
}
