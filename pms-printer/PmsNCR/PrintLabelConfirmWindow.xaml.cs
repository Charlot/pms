using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using PmsNCRWcf.Model;
using System.Configuration;
using PmsNCRWcf.Config;
using PmsNCRWcf;

namespace PmsNCR
{
    /// <summary>
    /// PrintLabelConfirmWindow.xaml 的交互逻辑
    /// </summary>
    public partial class PrintLabelConfirmWindow : Window
    {
        OrderItemCheck item;
        bool inStore = false;
        int bundleNo = 1;
        public PrintLabelConfirmWindow()
        {
            InitializeComponent();
        }

        public PrintLabelConfirmWindow(OrderItemCheck item,bool inStore=false,int bundleNo=1)
        {
            InitializeComponent();
            this.item = item;
            if (item != null)
            {
                OrderLab.Content = item.ItemNr;
                this.inStore = inStore;
                this.bundleNo = bundleNo;
            }
        }

        private void PrintBtn_Click(object sender, RoutedEventArgs e)
        {
            if (PasswdTB.Password.Equals(ConfigurationManager.AppSettings["PrintLabelPasswd"]))
            {
                if (item != null)
                {
                   // new PrintService().PrintKB("P002", item.ItemNr, WPCSConfig.MachineNr);
                    new PrintService().PrintBundleLabel("P003", item.ItemNr, WPCSConfig.MachineNr, this.bundleNo, this.inStore);          
                    this.Close();
                }
            }
            else
            {
                MsgLabel.Content = "Password Error!";
            }
        }
    }
}
