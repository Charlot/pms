using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PmsNCRWcf.Enmu
{
    public enum OrderItemState
    {
        STARTED = 200,
        RESTARTED = 300,
        TERMINATED = 400,
        ABORTED = 500,
        MANUAL_ABORTED = 501,
        INTERRUPTED = 600,
        PAUSED = 700
    }
}
