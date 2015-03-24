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
using PmsNCRWcf.Config;
using PmsNCRWcf.Model;

namespace PmsNCR
{
    /// <summary>
    /// OrderPreviewWindow.xaml 的交互逻辑
    /// </summary>
    public partial class OrderPreviewWindow : Window
    {
        public OrderPreviewWindow()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            LoadOrderListForPreview();
        }

        private void LoadOrderListForPreview() {

            OrderService service = new OrderService();
            Msg<List<OrderItemCheck>> msg = service.GetOrderPreviewList(WPCSConfig.MachineNr);
            if (msg.Result)
            {
                List<OrderItemCheck> items = msg.Object;
            }
            else
            {
                MessageBox.Show(msg.Content);
            }
        }
    }
}
