using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PmsNCRWcf.Model
{
    public class OrderItem
    {
        public int Id { get; set; }
        public string ItemNr { get; set; }
        public string OrderNr { get; set; }
        public int TotalQuantity { get; set; }
        public int BundleQuantity { get; set; }
        public int ProducedQty { get; set; }
    }
}
