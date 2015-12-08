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
using PmsNCRWcf.Converter;

namespace PmsNCR
{
    /// <summary>
    /// PrintKBConfirmWindow.xaml 的交互逻辑
    /// </summary>
    public partial class TerminateProductionConfirmWindow : Window
    {
        OrderItemCheck item;
        public TerminateProductionConfirmWindow()
        {
            InitializeComponent();
        }

        public TerminateProductionConfirmWindow(OrderItemCheck item)
        {
            InitializeComponent();
            this.item = item;
            if (item != null)
            {
                OrderLab.Content = item.ItemNr;
            }
        }

        private void TerminateBtn_Click(object sender, RoutedEventArgs e)
        {
            if (PasswdTB.Password.Equals(ConfigurationManager.AppSettings["TeminateProductionPasswd"]))
            {
                if (item != null)
                {
                    OrderSDCConverter.GenerateProductionTerminatedSDC(item);
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
