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
using PmsNCRWcf.Converter;
using Brilliantech.Framwork.Utils.LogUtil;

namespace PmsNCR
{
    /// <summary>
    /// MaterialCheck.xaml 的交互逻辑
    /// </summary>
    public partial class MaterialCheck : Window
    {
        private OrderItemCheck orderItem = null;

        public MaterialCheck()
        {
            InitializeComponent();
            if (LoadOrderItemCheck())
            {
                InitCheckGraph();
            }
            ScanCodeTB.Focus();
        }

        private bool LoadOrderItemCheck()
        {
            OrderService s = new OrderService();
            Msg<OrderItemCheck> msg = s.GetOrderItemForCheck("M002");
            if (msg.Result)
            {
                orderItem = msg.Object;
            }
            else
            {
                MessageBox.Show(msg.Content);
            }
            return msg.Result;
        }

        private void InitCheckGraph()
        {
            OrderNrLab.Content = orderItem.ItemNr;
            WireNrTB.Text = orderItem.WireNr;
            WireCusNrTB.Text = orderItem.WireCusNr;
            WireLenghLab.Content = orderItem.WireLength;

            if (orderItem.Terminal1StripLength != null)
            {
                StripLength1Lab.Content = orderItem.Terminal1StripLength.ToString();
            }

            if (orderItem.Terminal2StripLength != null)
            {
                StripLength2Lab.Content = orderItem.Terminal2StripLength.ToString();
            }

            if (orderItem.Terminal1Nr != null)
            {
                WorkArea1.Visibility = Visibility.Visible;
                TerminalNr1TB.Text = orderItem.Terminal1Nr;
                TerminalCusNr1TB.Text = orderItem.Terminal1CusNr;
                Tool1NrTB.Text = orderItem.Tool1Nr;
                Terminal1GraphLab.Visibility = Visibility.Visible;
            }

            if (orderItem.Terminal2Nr != null)
            {
                WorkArea2.Visibility = Visibility.Visible;
                TerminalNr2TB.Text = orderItem.Terminal2Nr;
                TerminalCusNr2TB.Text = orderItem.Terminal2CusNr;
                Tool2NrTB.Text = orderItem.Tool2Nr;
                Terminal2GraphLab.Visibility = Visibility.Visible;
            }
        }

        private void ScanCodeTB_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                string text = ScanCodeTB.Text;
                if (text.Length > 1)
                {
                    string prefix = text.Substring(0, 1);
                    string content = text.Substring(1, text.Length - 1);
                    if (prefix.Equals(MaterialCheckConfig.AreaPrefix))
                    {
                        CurrentAreaTB.Text = content;
                    }
                    else if (prefix.Equals(MaterialCheckConfig.WirePrefix))
                    {
                        WireCB.IsChecked = WireNrTB.Text.Equals(content);
                    }
                    else if (prefix.Equals(MaterialCheckConfig.TerminalPrefix))
                    {
                        if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area1))
                        {
                            Terminal1CB.IsChecked = TerminalNr1TB.Text.Equals(content);
                        }
                        else if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area2))
                        {
                            Terminal2CB.IsChecked = TerminalNr2TB.Text.Equals(content);
                        }

                    }
                    else if (prefix.Equals(MaterialCheckConfig.ToolPrefix))
                    {

                        if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area1))
                        {
                            Tool1CB.IsChecked = Tool1NrTB.Text.Equals(content);
                        }
                        else if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area2))
                        {
                            Tool2CB.IsChecked = Tool2NrTB.Text.Equals(content);
                        }
                    }

                    if (CanStartProduce())
                    {
                        StartProduceBtn.IsEnabled = true;
                    }
                }

                if (AutoCleanScanCB.IsChecked.Value)
                {
                    ScanCodeTB.Text = String.Empty;
                }
            }

        }

        private void CleanScanBtn_Click(object sender, RoutedEventArgs e)
        {
            ScanCodeTB.Text = String.Empty;
            ScanCodeTB.Focus();
        }

        private bool CanStartProduce()
        {
            bool wireCan = WireCB.IsChecked.Value;
            bool area1Can = true;
            bool area2Can = true;

            if (WorkArea1.IsVisible)
            {
                area1Can = Terminal1CB.IsChecked.Value && Tool1CB.IsChecked.Value;
            }
            if (WorkArea2.IsVisible)
            {
                area2Can = Terminal2CB.IsChecked.Value && Tool2CB.IsChecked.Value;
            }
            return wireCan && area1Can && area2Can;
        }
        private void StartProduceBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                OrderService s = new OrderService();
                Msg<string> msg = s.GetOrderItemForProduce(orderItem.Id);
                if (msg.Result)
                {
                    if (OrderItem.WirteToFile(orderItem.FileName, msg.Object))
                    {
                        OrderDDSConverter.ConvertJsonOrderToDDS(orderItem.FileName);
                    }
                }
                else
                {
                    MessageBox.Show(msg.Content);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                LogUtil.Logger.Error(ex.Message);
            }
        }
    }
}
