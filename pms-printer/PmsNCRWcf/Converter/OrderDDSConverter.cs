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

        public static void ConvertJsonOrderToDDS(string fileName)
        {
            JObject obj = JObject.Parse(File.ReadAllText(WPCSConfig.GetFullPath(fileName)));
         
            // JOB
            GenDDSFile(obj, "Job.dds", "[NewJob]", "job");

            // Article            
            GenDDSFile(obj, "Article.dds", "[NewArticle]", "article");

            // Terminal
            GenDDSFile(obj, "Terminal.dds", "[NewTerminal]", "terminal1","terminal2");

            //Seal
            GenDDSFile(obj, "Seal.dds", "[NewSeal]", "seal1", "seal2");
        }

        public static void GenDDSFile(JObject obj,string fileName, string title,params string[] tokenNames) {            
            JToken token=obj[tokenNames[0]];
            if (token != null)
            { 
                using (FileStream fs = new FileStream(Path.Combine(WPCSConfig.DataDir, fileName),
                    FileMode.Create, FileAccess.Write))
                {
                    using (StreamWriter sw = new StreamWriter(fs))
                    {
                        foreach (string tokenName in tokenNames)
                        {
                            token = obj[tokenName]; if (token != null)
                            {
                                List<JToken> l = token.ToList();
                                sw.WriteLine(title);
                                foreach (JToken t in l)
                                {
                                    JProperty p = (JProperty)t;
                                    sw.WriteLine(p.Name + " = " + p.Value);
                                }
                            }
                        }
                    }
                }
            }
        }
          
    }
}
