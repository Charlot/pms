using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PmsNCRWcf.Model;

namespace PmsNCRWcf
{
    public interface IPrintService
    {
        public Msg<string> Print(string code, string id);
    }
}
