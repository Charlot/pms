using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using PmsNCRWcf.Config;
using PmsNCRWcf.Helper;

namespace PmsNCRWcf.Model
{
    public class OrderItem
    {
        public string FileName { get; set; }
        public string OrderNr { get; set; }
        public string ItemNr { get; set; }
        public string FileContent { get; set; }

        public bool WriteToFile()
        {
            try
            {
                if (FileInfoHelper.CheckDir(WPCSConfig.OrderDir))
                {
                    using (FileStream fs = new FileStream(Path.Combine(WPCSConfig.OrderDir, this.FileName),
                          FileMode.Create, FileAccess.Write))
                    {
                        using (StreamWriter sw = new StreamWriter(fs))
                        {
                            sw.Write(this.FileContent);
                        }
                    }
                }
                return true;
            }
            catch (Exception e) {
                throw e;
            }
        }
    }
}
