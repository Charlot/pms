using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace PmsNCRWcf.Model
{
    [DataContract]
    public class ScrapData
    {
        [DataMember]
        public string order_nr { get; set; }
        [DataMember]
        public string kanban_nr { get; set; }
        [DataMember]
        public string machine_nr { get; set; }
        [DataMember]
        public string user_nr { get; set; }
        [DataMember]
        public string scrap_time { get; set; }
        [DataMember]
        public List<ScrapDataPart> parts { get; set; }
    }

    [DataContract]
    public class ScrapDataPart
    {
        [DataMember]
        public string nr { get; set; }
        [DataMember]
        public string qty { get; set; }
    }
}
