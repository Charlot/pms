using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using Brilliantech.ReportGenConnector;
using TECIT.TFORMer;
using PmsNCRWcf.Helper;
 
namespace PmsNCRWcf.Model
{
    public class Printer
    {
        public string Id { get; set; }
        public string Output { get; set; }
        public string Template { get; set; }
        public string TemplatePath
        {
            get
            {
                return Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Template", this.Template);
            }
        }
        public string Name { get; set; }
        public int Type { get; set; }
        /// <summary>
        /// default is 1
        /// </summary>
        public int Copy { get; set; }

        /// <summary>
        /// default is false
        /// </summary>
        public bool ChangeStock { get; set; }
        /// <summary>
        /// default is null
        /// </summary>
        public string StockName { get; set; }
        /// <summary>
        /// default is 0
        /// </summary>
        public int StockID { get; set; }
        /// <summary>
        /// default is 1, Portrait
        /// </summary>
        public int Orientation { get; set; }

        public void Print(RecordSet data, string printer_name = null, string copy = null)
        {
            string printerName= string.IsNullOrEmpty(printer_name) ? this.Name : printer_name;
            if (this.ChangeStock)
            {
                PrinterHelper ph = new PrinterHelper();
                PmsNCRWcf.Helper.PrinterHelper.DEVMODE dm = ph.GetPrinterSettings(printerName);
                PrinterData pd = new PrinterData() { Size = this.StockID, Duplex = dm.dmDuplex, Orientation = this.Orientation };
                ph.ChangePrinterSetting(printerName, pd);
            }
            IReportGen gen = new TecITGener();
            ReportGenConfig config = new ReportGenConfig()
            {
                Printer =printerName,
                NumberOfCopies = string.IsNullOrEmpty(copy) ? this.Copy : int.Parse(copy),
                PrinterType = (PrinterType)this.Type,
                Template = this.TemplatePath
            };
            gen.Print(data, config);
        }
    }
}
