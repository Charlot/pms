using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace PmsNCRWcf.Helper
{
    public class FileInfoHelper
    {
        public static bool CheckDir(string dir, bool create = true)
        {
            if (Directory.Exists(dir))
            {
                return true;
            }
            if (create)
            {
                Directory.CreateDirectory(dir);
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
