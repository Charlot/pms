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
using PmsNCRWcf;
using PmsNCRWcf.Config;

namespace PmsNCR
{
    /// <summary>
    /// SearchOrderItemWindow.xaml 的交互逻辑
    /// </summary>
    public partial class SearchOrderItemWindow : Window
    {
        public SearchOrderItemWindow()
        {
            InitializeComponent();
        }

        private void PrintKanbanBtn_Click(object sender, RoutedEventArgs e)
        {
            if (PreviewOrderDG.SelectedItems.Count == 1)
            {
                OrderItemCheck item = PreviewOrderDG.SelectedItem as OrderItemCheck;
                //new PrintService().PrintKB("P002", item.ItemNr, WPCSConfig.MachineNr);
              //  new PrintKBConfirmWindow(item).ShowDialog();
            }
        }

        private void PrintBundleLabelBtn_Click(object sender, RoutedEventArgs e)
        {
            int bundleNo = 0;
            int.TryParse(BundleNoTB.Text, out bundleNo);
            if (bundleNo > 0 && PreviewOrderDG.SelectedItems.Count == 1)
            {
                OrderItemCheck item = PreviewOrderDG.SelectedItem as OrderItemCheck;
                // new PrintLabelConfirmWindow(item, InstoreCheck.IsChecked.Value, bundleNo).ShowDialog();
                //BundleNoTB.Text = string.Empty;
                // InstoreCheck.IsChecked = false;
                new PrintService().PrintBundleLabel("P003", item.ItemNr, WPCSConfig.MachineNr,bundleNo,InstoreCheck.IsChecked.Value);          
            }
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            OrderService service = new OrderService();
            Msg<List<OrderItemCheck>> msg = service.SearchOrderItem(PartNrTB.Text);
            List<OrderItemCheck> items = msg.Object;
            PreviewOrderDG.ItemsSource = items;
        }
    }
}
