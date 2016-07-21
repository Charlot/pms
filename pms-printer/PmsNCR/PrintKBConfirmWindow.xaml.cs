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
using PmsNCRWcf;
using PmsNCRWcf.Config;

namespace PmsNCR
{
    /// <summary>
    /// PrintKBConfirmWindow.xaml 的交互逻辑
    /// </summary>
    public partial class PrintKBConfirmWindow : Window
    {
        OrderItemCheck item;
        public PrintKBConfirmWindow()
        {
            InitializeComponent();
        }

        public PrintKBConfirmWindow(OrderItemCheck item)
        {
            InitializeComponent();
            this.item = item;
            if (item != null)
            {
                OrderLab.Content = item.ItemNr;
            }
        }

        private void PrintBtn_Click(object sender, RoutedEventArgs e)
        {
            if (PasswdTB.Password.Equals(ConfigurationManager.AppSettings["PrintKbPasswd"]) || PasswdTB.Password.Equals(ConfigurationManager.AppSettings["AdminPwd"]))
            {
                if (item != null)
                {
                    new PrintService().PrintKB("P002", item.ItemNr, WPCSConfig.MachineNr);
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
