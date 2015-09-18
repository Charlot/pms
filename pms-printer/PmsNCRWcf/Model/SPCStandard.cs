using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace PmsNCRWcf.Model
{
    public class SPCStandard
    {
        [DataMember]
        public string Crimp_height { get; set; }

        [DataMember]
        public string Crimp_height_iso { get; set; }

        [DataMember]
        public string Crimp_width { get; set; }

        [DataMember]
        public string Crimp_width_iso { get; set; }

        [DataMember]
        public string Min_pullOff_value { get; set; }

        [DataMember]
        public string I_crimp_height { get; set; }

        [DataMember]
        public string I_crimp_height_iso { get; set; }

        [DataMember]
        public string I_crimp_width { get; set; }

        [DataMember]
        public string I_crimp_width_iso { get; set; }

    }
}
