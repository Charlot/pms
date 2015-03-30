using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PmsPrinterWpf.Model;

namespace PmsPrinterWpf.IService
{
    public interface IKanbanService
    {
        Msg<string> GetPrintCode(string kanbanNr);
    }
}
