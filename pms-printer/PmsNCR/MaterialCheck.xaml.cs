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
        public static bool IsShow = false;
        private OrderItemCheck orderItem = null;

        public MaterialCheck()
        {
            InitializeComponent();
            LoadCheck();           
            ScanCodeTB.Focus();
            IsShow = true;
        }

        public void LoadCheck() {
            if (LoadOrderItemCheck())
            {
                InitCheckGraph();
            }
        }
        private bool LoadOrderItemCheck()
        {
            OrderService s = new OrderService();
            Msg<OrderItemCheck> msg = s.GetOrderItemForCheck(WPCSConfig.MachineNr);
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
            JobNrLab.Content = orderItem.ItemNr;
            WireNrTB.Text = orderItem.WireNr;
            WireCusNrTB.Text = orderItem.WireCusNr;
            WireLenghLab.Content = orderItem.WireLength;

            if (orderItem.Terminal1StripLength != null)
            {
                StripLength1Lab.Content = orderItem.Terminal1StripLength.ToString();
            }
            else
            {
                StripLength1Lab.Content = null;
            }

            if (orderItem.Terminal2StripLength != null)
            {
                StripLength2Lab.Content = orderItem.Terminal2StripLength.ToString();
            }
            else
            {

                StripLength2Lab.Content = null;
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
                    string content = String.Empty;
                    if (prefix.Equals(MaterialCheckConfig.AreaPrefix))
                    {
                        content = text.Substring(MaterialCheckConfig.AreaPrefix.Length, text.Length - 1);
                        CurrentAreaTB.Text = content;
                    }
                    else if (CurrentAreaTB.Text.Length==0 && prefix.Equals(MaterialCheckConfig.WirePrefix))
                    {
                        content = text.Substring(MaterialCheckConfig.WirePrefix.Length, text.Length - 1);
                        WireCB.IsChecked = WireNrTB.Text.Equals(content);
                    }
                    else if (prefix.Equals(MaterialCheckConfig.TerminalPrefix))
                    {
                        content = text.Substring(MaterialCheckConfig.TerminalPrefix.Length, text.Length - 1);
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
                        content = text.Substring(MaterialCheckConfig.ToolPrefix.Length, text.Length - 1);

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
            MessageBoxResult result = MessageBox.Show("Confirm Start?");
            if (result.Equals(MessageBoxResult.OK))
            {
                try
                {
                    OrderService s = new OrderService();
                    Msg<string> msg = s.GetOrderItemForProduce(orderItem.Id,mirror);
                    if (msg.Result)
                    {
                        if (OrderItemFile.WirteToFile(orderItem.FileName, msg.Object))
                        {
                            if (OrderDDSConverter.ConvertJsonOrderToDDS(orderItem.FileName))
                            {
                                MessageBox.Show("Order Created, Please Use EASY to work!");
                                this.Close();
                            }
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

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            IsShow = false;
        }

        private void AbortBtn_Click(object sender, RoutedEventArgs e)
        {
            new AbortConfirmWindow(this,JobNrLab.Content.ToString()).ShowDialog();
        }

        private bool mirror = false;
        private void MirrorBtn_Click(object sender, RoutedEventArgs e)
        {
            if (!mirror)
            {
                mirror = true;
                MirrorBtn.FontWeight = FontWeights.Bold;
                MirrorBtn.Foreground = new SolidColorBrush(Colors.Red);
                MirrorBtn.Content = "!Mirror!";
            }
            else
            {
                mirror = false;                
                MirrorBtn.FontWeight = FontWeights.Normal;
                MirrorBtn.Foreground = new SolidColorBrush(Colors.Black);
                MirrorBtn.Content = "Mirror";
            }
            MirrorArea();
        }

        private void MirrorArea() {
            object strip1 = StripLength1Lab.Content;
            StripLength1Lab.Content =StripLength2Lab.Content;
            StripLength2Lab.Content = strip1;

            Visibility tervisi = Terminal1GraphLab.Visibility;
            Terminal1GraphLab.Visibility = Terminal2GraphLab.Visibility;
            Terminal2GraphLab.Visibility = tervisi;

            string ter1 = TerminalNr1TB.Text;
            TerminalNr1TB.Text = TerminalNr2TB.Text;
            TerminalNr2TB.Text = ter1;

            string ter1cus = TerminalCusNr1TB.Text;
            TerminalCusNr1TB.Text = TerminalCusNr2TB.Text;
            TerminalCusNr2TB.Text = ter1cus;


            string tool1 = Tool1NrTB.Text;
            Tool1NrTB.Text = Tool2NrTB.Text;
            Tool2NrTB.Text = tool1;

            Visibility visibility= WorkArea1.Visibility;
            WorkArea1.Visibility = WorkArea2.Visibility;
            WorkArea2.Visibility = visibility;



        }

    }
}