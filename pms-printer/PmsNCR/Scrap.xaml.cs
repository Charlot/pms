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
using System.Collections;
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
        Dictionary<string, string> parts;
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

                wire.Tag = wireNr.Content = currentOrder.WireNr;
                terminal1.Tag = terminal1Nr.Content = currentOrder.Terminal1Nr;
                terminal2.Tag = terminal2Nr.Content = currentOrder.Terminal2Nr;
                seal1.Tag = seal1Nr.Content = currentOrder.Seal1Nr;
                seal2.Tag = seal2Nr.Content = currentOrder.Seal2Nr;
                if (string.IsNullOrEmpty(currentOrder.WireNr))
                {
                    wire.IsEnabled = false;
                }

                if (string.IsNullOrEmpty(currentOrder.Terminal1Nr))
                {
                    terminal1.IsEnabled = false;
                }

                if (string.IsNullOrEmpty(currentOrder.Terminal2Nr))
                {
                    terminal2.IsEnabled = false;
                }
                if (string.IsNullOrEmpty(currentOrder.Seal1Nr))
                {
                    seal1.IsEnabled = false;
                }

                if (string.IsNullOrEmpty(currentOrder.Seal2Nr))
                {
                   seal2.IsEnabled = false;
                }
            }
        }

        private void ok_Click(object sender, RoutedEventArgs e)
        {
            if (ForEach() && parts.Count > 0)
            {

                List<ScrapDataPart> scrapPart = new List<ScrapDataPart>();
                foreach (var p in parts)
                {
                    scrapPart.Add(new ScrapDataPart()
                    {
                        nr = p.Key,
                        qty = p.Value
                    });
                }
                ScrapData scrap = new ScrapData()
                {
                    order_nr = currentOrder.OrderNr,
                    kanban_nr = currentOrder.KanbanNr,
                    machine_nr = WPCSConfig.MachineNr,
                    user_nr = WPCSConfig.UserNr,
                    scrap_time = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    parts = scrapPart
                };


                Msg<string> msg = new OrderService().StoreScrapData(scrap);
                error.Content = msg.Content;
                if (msg.Result)
                {
                    ok.IsEnabled = false;
                }
            }
            else
            {
                parts = null;
            }
        }

        //Is the value Empty
        private bool CheckStringIsInvalid(string value) { 
            double v = 0;
            return !double.TryParse(value, out v);
        }

        //Get the UI foreach
        private bool ForEach() {
            bool result = true;
            parts = new Dictionary<string, string>();
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
                        {
                            current.Background = Brushes.Red;
                            result = false;
                        }
                        else
                        {
                            current.Background = Brushes.White;
                            if(current.Tag!=null){
                            parts.Add(current.Tag.ToString(), current.Text);
                            }
                        }
                    }
                }
              
            }
            return result;
           
        }

        //close button
        private void BtnClose(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

    }
}
