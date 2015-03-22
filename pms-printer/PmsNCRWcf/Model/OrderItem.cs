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
                return OrderItem.WirteToFile(this.FileName, this.FileContent);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public static bool WirteToFile(string fileName, string fileContent)
        {
            if (FileInfoHelper.CheckDir(WPCSConfig.ServerOrderDir))
            {
                using (FileStream fs = new FileStream(Path.Combine(WPCSConfig.ServerOrderDir, fileName),
                      FileMode.Create, FileAccess.Write))
                {
                    using (StreamWriter sw = new StreamWriter(fs))
                    {
                        sw.Write(fileContent);
                    }
                }
            }
            return true;
        }
    }
}
