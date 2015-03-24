using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PmsNCRWcf.Model;

namespace PmsNCRWcf
{
    public interface IPrintService
    {
          Msg<string> Print(string code, string id);
          Msg<string> PrintKB(string code, string order_item_nr);
          Msg<string> PrintBundleLabel(string code, string order_item_nr, string machine_nr, int bundle_no);
    }
}
