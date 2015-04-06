using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PmsNCRWcf.Model;

namespace PmsNCRWcf
{
    public interface IMachineService
    {
        Msg<string> SettingIP(string machineNr, string IP);
    }
}
