using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace PmsNCRWcf.Model
{
    [DataContract]
    public class OrderItem
    {
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public string ItemNr { get; set; }
        [DataMember]
        public string OrderNr { get; set; }
        [DataMember]
        public int TotalQuantity { get; set; }
        [DataMember]
        public int BundleQuantity { get; set; }
        [DataMember]
        public int ProducedQty { get; set; }
    }
}
