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
using PmsNCRWcf.Model;
using PmsNCRWcf.Config;

using System.Runtime.InteropServices;
using System.Windows.Interop;
namespace PmsNCR
{
    /// <summary>
    /// Scrap.xaml 的交互逻辑
    /// </summary>
    public partial class Scrap : Window
    {
        //disable close button
        //private const int GWL_STYLE = -16;
        //private const int WS_SYSMENU = 0x80000;
        //[DllImport("user32.dll", SetLastError = true)]
        //private static extern int GetWindowLong(IntPtr hWnd, int nIndex);
        //[DllImport("user32.dll")]
        //private static extern int SetWindowLong(IntPtr hwnd, int nIndex, int dwNewLong);


        OrderItemCheck currentOrder;

        public Scrap()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            //var hwnd = new WindowInteropHelper(this).Handle;
            //SetWindowLong(hwnd, GWL_STYLE, GetWindowLong(hwnd, GWL_STYLE) & ~WS_SYSMENU);

            LoadSPCStandard();
        }

        private void LoadSPCStandard() {
              currentOrder = MainWindow.CurrentOrder;
            if (currentOrder == null)
            {
                order.Content = "No Order!";
                order.Foreground = new SolidColorBrush(Colors.Red);
                ok.IsEnabled=false ;
            }
            else
            {
                order.Content = currentOrder.ItemNr;
                kanban.Content = currentOrder.KanbanNr;
                user.Content = WPCSConfig.UserNr;
                
                wireunit.Content = currentOrder.WireUnit;
                terminal1unit.Content = currentOrder.Terminal1Unit;
                terminal2unit.Content = currentOrder.Terminal2Unit;
                seal1unit.Content = currentOrder.Seal1Unit;
                seal2unit.Content = currentOrder.Seal2Unit;

            }
        }

        private void ok_Click(object sender, RoutedEventArgs e)
        {
            ScrapData();
            ForEach();
        }

        private void ScrapData() {
            OrderItemCheck orderNr = MainWindow.CurrentOrder;
            string[] ScrapAllData = new string[8];
            ScrapAllData[0] = orderNr.ItemNr;
            ScrapAllData[1] = orderNr.KanbanNr;
            ScrapAllData[2] = WPCSConfig.UserNr;
            ScrapAllData[3] = wire.Text;
            ScrapAllData[4] = terminal1.Text;
            ScrapAllData[5] = terminal2.Text;
            ScrapAllData[6] = seal1.Text;
            ScrapAllData[7] = seal2.Text;
            
           Msg<string> msg = new OrderService().StoreScrapData(ScrapAllData);
        }

        //Is the value Empty
        private bool CheckStringIsInvalid(string value) { 
            double v = 0;
            return !double.TryParse(value, out v);
        }

        private void ForEach() {
            foreach (UIElement ui in Input_StackPanel.Children)
            {
                if (ui is TextBox) {
                    TextBox current = ((TextBox)ui);
                    if (current.Text == null || current.Text == "")
                    {
                        current.Background = Brushes.White;
                    }
                    else
                    {
                        if (CheckStringIsInvalid(current.Text))
                            current.Background = Brushes.Red;
                        else
                            current.Background = Brushes.White;
                    }
                }
              
            }
           
        }

        private void BtnClose(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

    }
}
