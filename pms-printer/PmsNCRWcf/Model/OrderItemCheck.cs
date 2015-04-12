using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace PmsNCRWcf.Model
{
    [DataContract]
    public class OrderItemCheck
    {
        [DataMember]
        public int No { get; set; }
        [DataMember]
        public int Id { get; set; }
        [DataMember]
        public string ItemNr { get; set; }
        [DataMember]
        public string OrderNr { get; set; }
        [DataMember]
        public string KanbanNr { get; set; }
        [DataMember]
        public int KanbanQuantity { get; set; }
        [DataMember]
        public string KanbanBundle { get; set; }
        [DataMember]
        public string KanbanWireNr { get; set; }
        [DataMember]
        public string WireNr { get; set; }
        [DataMember]
        public string WireCusNr { get; set; }
        [DataMember]
        public string WireLength { get; set; }
        [DataMember]
        public string Terminal1Nr { get; set; }
        [DataMember]
        public string Terminal1CusNr { get; set; }
        [DataMember]
        public string Terminal1StripLength { get; set; }
        [DataMember]
        public string Tool1Nr { get; set; }
        [DataMember]
        public string Terminal2Nr { get; set; }
        [DataMember]
        public string Terminal2CusNr { get; set; }
        [DataMember]
        public string Terminal2StripLength { get; set; }
        [DataMember]
        public string Tool2Nr { get; set; }
        [DataMember]
        public string Seal1Nr { get; set; }
        [DataMember]
        public string Seal2Nr { get; set; }
        [DataMember]
        public string FileName { get; set; }
    }
}
