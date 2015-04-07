using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using PmsNCRWcf.Config;
using PmsNCRWcf.Helper;

namespace PmsNCRWcf.Model
{
    public class OrderItemFile
    {
        public int Id { get; set; }
        public string ItemNr { get; set; }
        public string OrderNr { get; set; }
        public int TotalQuantity { get; set; }
        public int BundleQuatity { get; set; }
        public int ProducedQty { get; set; }
        public string FileName { get; set; }
        public string FileContent { get; set; }

        public bool WriteToFile()
        {
            try
            {
                return OrderItemFile.WirteToFile(this.FileName, this.FileContent);
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
