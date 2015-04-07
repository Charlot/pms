using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Brilliantech.ReportGenConnector;
using TECIT.TFORMer;
using System.IO;

namespace PmsTESTWin
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            IReportGen gen = new TecITGener();
            RecordSet rs = new RecordSet();
            RecordData rd = new RecordData();
            rd.Add("A","AAA");
            rs.Add(rd);

            ReportGenConfig config = new ReportGenConfig()
            {
                Printer = "Microsoft XPS Document Writer",
                NumberOfCopies = 1,
                PrinterType = PrinterType.Default,
                Template = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Template\\t1.tff")
            };
            gen.Print(rs, config);
        }
    }
}
