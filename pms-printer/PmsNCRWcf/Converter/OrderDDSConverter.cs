using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json.Linq;
using System.IO;
using PmsNCRWcf.Config;

namespace PmsNCRWcf.Converter
{
    public class OrderDDSConverter
    { 
        public static bool ConvertJsonOrderToDDS(string fileName)
        {
            try
            {
                JObject obj = JObject.Parse(File.ReadAllText(WPCSConfig.GetServerOrderFullPath(fileName)));

                // JOB
                GenDDSFile(obj, "Job.dds", "job");

                // Article            
                GenDDSFile(obj, "Article.dds", "article");

                // Terminal
                GenDDSFile(obj, "Terminal.dds", "terminal1", "terminal2");

                //Seal
                GenDDSFile(obj, "Seal.dds", "seal1", "seal2");
                return true;
            }
            catch (Exception e) {
                throw e;
            }
        }

        public static void GenDDSFile(JObject obj,string fileName, params string[] tokenNames) {            
            JToken token=obj[tokenNames[0]];
            if (token != null)
            { 
                using (FileStream fs = new FileStream(Path.Combine(WPCSConfig.ServerDataDir, fileName),
                    FileMode.Create, FileAccess.Write))
                {
                    using (StreamWriter sw = new StreamWriter(fs))
                    {
                        foreach (string tokenName in tokenNames)
                        {
                            token = obj[tokenName];
                            if (token != null)
                            {
                                List<JToken> l = token.ToList();
                                foreach (JToken t in l)
                                {
                                    JProperty p = (JProperty)t;
                                    sw.WriteLine("[" + p.Name + "]");
                                    List<JToken> v = p.Value.ToList();
                                    foreach (JToken vv in v)
                                    { 
                                        JProperty pvv = (JProperty)vv;
                                        sw.WriteLine(pvv.Name + " = " + pvv.Value);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
