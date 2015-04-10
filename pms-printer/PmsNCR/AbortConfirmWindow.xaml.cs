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
using PmsNCRWcf;
using PmsNCRWcf.Enmu;
using PmsNCR.Helper;

namespace PmsNCR
{
    /// <summary>
    /// AbortConfirmWindow.xaml 的交互逻辑
    /// </summary>
    public partial class AbortConfirmWindow : Window
    {
        MaterialCheck mc = null;
        public AbortConfirmWindow()
        {
            InitializeComponent();
        }

        public AbortConfirmWindow(MaterialCheck mc,string OrderNr)
        {
            InitializeComponent();
            OrderLab.Content = OrderNr;
            this.mc = mc;
        }

        private void AbortBtn_Click(object sender, RoutedEventArgs e)
        {
            if (PasswdTB.Password.Equals(SettingReader.OrderAbortPasswd))
            {
                OrderService service = new OrderService();
                bool result = service.ChangeOrderItemState(OrderLab.Content.ToString(), OrderItemState.MANUAL_ABORTED).Result;
                if (result)
                {
                    MsgLabel.Content = "Abort Success!";
                    MessageBox.Show("Abort Success! Next Order is Loaded!");
                    this.Close();
                    mc.LoadCheck();
                }
                else
                {
                    MsgLabel.Content = "Fail! Please contact IT";
                }
            }
            else {
                MsgLabel.Content = "Password Error!";
            }
        }
    }
}
