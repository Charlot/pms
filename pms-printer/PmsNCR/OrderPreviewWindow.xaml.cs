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
        public static bool IsShow = false;

        public OrderPreviewWindow()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            IsShow = true;
            LoadOrderListForPreview();
        }

        private void LoadOrderListForPreview() {
            OrderService service = new OrderService();
            Msg<List<OrderItemCheck>> msg = null;
            if (OrderStateCB.SelectedIndex == 0)
            {
                msg = service.GetOrderPreviewList(WPCSConfig.MachineNr);
            }
            else if (OrderStateCB.SelectedIndex == 1) {
                msg = service.GetOrderPassedList(WPCSConfig.MachineNr);
            }
            if (msg.Result)
            {
                List<OrderItemCheck> items = msg.Object;
                PreviewOrderDG.ItemsSource = items;
            }
            else
            {
                MessageBox.Show(msg.Content);
            }
        }
         

        private void UpdatePreviewBtn_Click(object sender, RoutedEventArgs e)
        {
            LoadOrderListForPreview();
            BundleNoTB.Text = string.Empty;
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            IsShow = false;
        }

        private void PrintKanbanBtn_Click(object sender, RoutedEventArgs e)
        {
            if (PreviewOrderDG.SelectedItems.Count == 1)
            {
                OrderItemCheck item = PreviewOrderDG.SelectedItem as OrderItemCheck;
                //new PrintService().PrintKB("P002", item.ItemNr, WPCSConfig.MachineNr);
                new PrintKBConfirmWindow(item).ShowDialog();
            }
        }

        private void TerminatetKanbanBtn_Click(object sender, RoutedEventArgs e)
        {
            if (PreviewOrderDG.SelectedItems.Count == 1)
            {
                OrderItemCheck item = PreviewOrderDG.SelectedItem as OrderItemCheck;
                new TerminateProductionConfirmWindow(item).ShowDialog();
            }
        }

        private void PrintBundleLabelBtn_Click(object sender, RoutedEventArgs e)
        {
            int bundleNo = 0;
            int.TryParse(BundleNoTB.Text, out bundleNo);
            if (bundleNo > 0 && PreviewOrderDG.SelectedItems.Count == 1)
            {
                OrderItemCheck item = PreviewOrderDG.SelectedItem as OrderItemCheck;
                new PrintLabelConfirmWindow(item, InstoreCheck.IsChecked.Value,bundleNo).ShowDialog();
                BundleNoTB.Text = string.Empty;
                InstoreCheck.IsChecked = false;
              //  new PrintService().PrintBundleLabel("P003", item.ItemNr, WPCSConfig.MachineNr,bundleNo,InstoreCheck.IsChecked.Value);          
            }
        }
         
    }
}