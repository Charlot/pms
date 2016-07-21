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
using System.Text.RegularExpressions;

namespace PmsNCR
{
    /// <summary>
    /// MaterialCheck.xaml 的交互逻辑
    /// </summary>
    public partial class MaterialCheck : Window
    {
        public bool canStart = true;
        public static bool IsShow = false;
        private OrderItemCheck orderItem = null;
        private string currentTool1;
        private string currentTool2;

        bool recheck = false;
        List<MCSelectType> types;

        public MaterialCheck(bool recheck=false,List<MCSelectType> types=null)
        {
            InitializeComponent();

            this.recheck = recheck;
            this.types = types;

            LoadCheck();          
            ScanCodeTB.Focus();
            IsShow = true;

        } 

        public void LoadCheck()
        {
            if (LoadOrderItemCheck())
            {
                InitCheckGraph();
            }
            if (!recheck)
            {
                OrderService os = new OrderService();
                Msg<OrderItemCheck> msg = os.GetOrderItemByNr(WPCSConfig.CurrentOrderNr);
                if (msg.Result && msg.Object.State == 200)
                {
                    canStart = false;
                    new MsgWinow(string.Format("Order: {0} is not terminate!", msg.Object.ItemNr)).ShowDialog();
                    WarnLab.Content = string.Format("!! Order: {0} is not terminate!", msg.Object.OrderNr);
                }
            }
        }
        private bool LoadOrderItemCheck()
        {
            if (recheck)
            {
                orderItem = MainWindow.CurrentOrder;
                return true;
            }
            else
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
        }

        private void InitCheckGraph()
        {
            // set wire color
            try
            {
                if (!string.IsNullOrEmpty(orderItem.WireColor))
                {
                    List<string> colors = ShortColorConverter.Converts(orderItem.WireColor);
                    if (colors!=null)
                    {
                        try
                        {
                            if (colors.Count == 1)
                            {
                                WireColorLab1.Background = WireColorLab2.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString(colors[0]));
                            }
                            else
                            {
                                WireColorLab1.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString(colors[0]));
                                WireColorLab2.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString(colors[1]));
                            }
                        }
                        catch (Exception e)
                        {
                            LogUtil.Logger.Error(e.Message);
                        }
                    }
                }
            }
            catch { }
            
                WireColorTB.Text = orderItem.WireColor;
                WireCB.IsEnabled = !MaterialCheckConfig.WireLockCheck;
                Terminal1CB.IsEnabled = Terminal2CB.IsEnabled = !MaterialCheckConfig.TerminalLockCheck;
                Tool1CB.IsEnabled = Tool2CB.IsEnabled = !MaterialCheckConfig.ToolLockCheck;
                Seal1CB.IsEnabled = Seal2CB.IsEnabled = !MaterialCheckConfig.SealLockCheck;

                JobNrLab.Content = orderItem.ItemNr;
                WireNrTB.Text = orderItem.WireNr;
                WireCusNrTB.Text = orderItem.WireCusNr;
                WireLenghLab.Content = orderItem.WireLength;

                if (recheck)
                {
                    if (!types.Contains(MCSelectType.Wire))
                    {
                        WireCB.IsChecked = true;
                    }
                }
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
                    if (recheck) {   
                        Tool1CB.IsChecked = true;
                        if (!types.Contains(MCSelectType.Terminal1)) {
                            Terminal1CB.IsChecked = true;
                            CurrentMold1.Content = orderItem.Tool1Nr;
                        }
                    }
                }

                if (!string.IsNullOrWhiteSpace(orderItem.Seal1Nr))
                {
                    WorkArea1.Visibility = Seal1Lab.Visibility = Seal1TB.Visibility = Seal1CB.Visibility = Visibility.Visible;
                    Seal1TB.Text = orderItem.Seal1Nr;
                    if (recheck)
                    {
                        if (!types.Contains(MCSelectType.Seal1))
                        {
                            Seal1CB.IsChecked = true;
                        }
                    }
                }
                else
                {
                    Seal1Lab.Visibility = Seal1TB.Visibility = Seal1CB.Visibility = Visibility.Hidden;
                    Seal1CB.IsChecked = true;
                }

                if (orderItem.Terminal2Nr != null)
                {
                    WorkArea2.Visibility = Visibility.Visible;
                    TerminalNr2TB.Text = orderItem.Terminal2Nr;
                    TerminalCusNr2TB.Text = orderItem.Terminal2CusNr;
                    Tool2NrTB.Text = orderItem.Tool2Nr;
                    Terminal2GraphLab.Visibility = Visibility.Visible;
                    if (recheck)
                    {
                            Tool2CB.IsChecked = true;
                        if (!types.Contains(MCSelectType.Terminal2))
                        {
                            Terminal2CB.IsChecked = true;
                            CurrentMold2.Content = orderItem.Tool2Nr;
                        }
                    }
                }

                if (!string.IsNullOrWhiteSpace(orderItem.Seal2Nr))
                {
                    WorkArea2.Visibility = Seal2Lab.Visibility = Seal2TB.Visibility = Seal2CB.Visibility = Visibility.Visible;
                    Seal2TB.Text = orderItem.Seal2Nr;
                    if (recheck)
                    {
                        if (!types.Contains(MCSelectType.Seal2))
                        {
                            Seal2CB.IsChecked = true;
                        }
                    }
                }
                else
                {
                    Seal2Lab.Visibility = Seal2TB.Visibility = Seal2CB.Visibility = Visibility.Hidden;
                    Seal2CB.IsChecked = true;
                }
            
        }

        private void ScanCodeTB_KeyUp(object sender, KeyEventArgs e)
        {
          
            if (e.Key == Key.Enter)
            {  
                CheckMaterial();
               // CleanScanText();
            }

        }

        private void CleanScanText() {
            if (AutoCleanScanCB.IsChecked.Value)
            {
                ScanCodeTB.Text = String.Empty;
            }
        }

        private void CheckMaterial()
        {
            string text = ScanCodeTB.Text;
            if (text.Length > 1)
            {
                // string prefix = text.Substring(0, 1);
                string content = String.Empty;

                Regex areaRegex = new Regex(MaterialCheckConfig.AreaPattern, RegexOptions.IgnoreCase);
                Regex wireRegex = new Regex(MaterialCheckConfig.WirePattern, RegexOptions.IgnoreCase);
                Regex terminalRegex = new Regex(MaterialCheckConfig.TerminalPattern, RegexOptions.IgnoreCase);
                Regex toolRegex = new Regex(MaterialCheckConfig.ToolPattern, RegexOptions.IgnoreCase);
                Regex sealRegex = new Regex(MaterialCheckConfig.SealPattern, RegexOptions.IgnoreCase);
                if (wireRegex.Match(text).Success)
                {
                    if (!WireCB.IsChecked.Value)
                    {
                        content = text.Substring(MaterialCheckConfig.WirePrefix.Length, text.Length - MaterialCheckConfig.WirePrefix.Length);
                        WireCB.IsChecked = WireNrTB.Text.Equals(content);                        
                    }
                    if (WireCB.IsChecked.Value) {
                        CleanScanText();
                    }
                }
                if (areaRegex.Match(text).Success)
                {
                    content = text.Substring(MaterialCheckConfig.AreaPrefix.Length, text.Length - MaterialCheckConfig.AreaPrefix.Length);
                    if (content.Equals(MaterialCheckConfig.Area1) || content.Equals(MaterialCheckConfig.Area2))
                    {
                        CurrentAreaTB.Text = content;
                        CleanScanText();
                    }
                }

                if (terminalRegex.Match(text).Success && CurrentAreaTB.Text.Length>0)
                {
                    
                    content = text.Substring(MaterialCheckConfig.TerminalPrefix.Length, text.Length - MaterialCheckConfig.TerminalPrefix.Length);
                    if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area1))
                    {
                        if (!Terminal1CB.IsChecked.Value)
                        {
                            Terminal1CB.IsChecked = TerminalNr1TB.Text.Equals(content);
                        }
                        if (Terminal1CB.IsChecked.Value)
                        {
                            CleanScanText();
                        }
                    }
                    else if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area2))
                    {
                        if (!Terminal2CB.IsChecked.Value)
                        {
                            Terminal2CB.IsChecked = TerminalNr2TB.Text.Equals(content);                           
                        }
                        if (Terminal2CB.IsChecked.Value)
                        {
                            CleanScanText();
                        }
                    }

                }

                if (toolRegex.Match(text).Success && CurrentAreaTB.Text.Length > 0)
                {
                    content = text.Substring(MaterialCheckConfig.ToolPrefix.Length, text.Length - MaterialCheckConfig.ToolPrefix.Length);

                    if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area1))
                    {
                        if (!Tool1CB.IsChecked.Value)
                        {
                            Tool1CB.IsChecked = CheckMutiTool(Tool1NrTB.Text, content);
                        }
                        if (Tool1CB.IsChecked.Value)
                        {
                            CurrentMold1.Content = currentTool1 = content;
                            CleanScanText();
                        }
                    }
                    else if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area2))
                    {
                        if (!Tool2CB.IsChecked.Value)
                        {
                            Tool2CB.IsChecked = CheckMutiTool(Tool2NrTB.Text, content);
                        }
                        if (Tool2CB.IsChecked.Value)
                        {
                            CurrentMold2.Content = currentTool2 = content;
                            CleanScanText();
                        }
                    }
                }

                if (sealRegex.Match(text).Success && CurrentAreaTB.Text.Length > 0)
                {
                    content = text.Substring(MaterialCheckConfig.SealPrefix.Length, text.Length - MaterialCheckConfig.SealPrefix.Length);
                    if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area1))
                    {
                        if (!Seal1CB.IsChecked.Value)
                        {
                            Seal1CB.IsChecked = Seal1TB.Text.Equals(content);
                        }
                        if (Seal1CB.IsChecked.Value)
                        {
                            CleanScanText();
                        }
                    }
                    else if (CurrentAreaTB.Text.Equals(MaterialCheckConfig.Area2))
                    {
                        if (!Seal2CB.IsChecked.Value)
                        {
                            Seal2CB.IsChecked = Seal2TB.Text.Equals(content);
                        }
                        if (Seal2CB.IsChecked.Value)
                        {
                            CleanScanText();
                        }
                    }
                }


                if (CanStartProduce())
                {
                    StartProduceBtn.IsEnabled = true;
                }
            }
        }

        private bool CheckMutiTool(string tools, string tool) {
            return string.Format(",{0},", tools).Contains(string.Format(",{0},", tool));
        }

        private void CleanScanBtn_Click(object sender, RoutedEventArgs e)
        {
            ScanCodeTB.Text = String.Empty;
            CurrentAreaTB.Text = String.Empty;
            ScanCodeTB.Focus();
        }

        private bool CanStartProduce()
        {
            bool wireCan = WireCB.IsChecked.Value;
            bool area1Can = true;
            bool area2Can = true;

            if (WorkArea1.IsVisible)
            {
                area1Can = Terminal1CB.IsChecked.Value && Tool1CB.IsChecked.Value && Seal1CB.IsChecked.Value;
            }
            if (WorkArea2.IsVisible)
            {
                area2Can = Terminal2CB.IsChecked.Value && Tool2CB.IsChecked.Value && Seal2CB.IsChecked.Value;
            }
            return wireCan && area1Can && area2Can && canStart;
        }

        private void StartProduceBtn_Click(object sender, RoutedEventArgs e)
        {
            if (recheck)
            {

                this.Close();
                return;
            }
            MessageBoxResult result = MessageBox.Show("Confirm Start?");
            if (result.Equals(MessageBoxResult.OK))
            {
                try
                {
                    OrderService s = new OrderService();
                    Msg<string> msg = s.GetOrderItemForProduce(orderItem.Id, WPCSConfig.MachineType, mirror);
                    if (msg.Result)
                    {
                        if (OrderItemFile.WirteToFile(orderItem.FileName, msg.Object))
                        {
                            if (OrderDDSConverter.ConvertJsonOrderToDDS(orderItem.FileName))
                            {
                                s.SetOrderItemTool(orderItem.ItemNr, currentTool1.Trim(), currentTool2.Trim());
                                orderItem.Tool1Nr = currentTool1;
                                orderItem.Tool2Nr = currentTool2;

                                MainWindow.CurrentOrder = orderItem;
                                WPCSConfig.CurrentOrderNr = orderItem.ItemNr;

                                MessageBox.Show("Order Created, Please Use EASY to work!");
                                // auto load order to print kb
                                if (MaterialCheckConfig.AutoLoad) {
                                    OrderSDCConverter.GenerateJobStartedSDC(orderItem);
                                }
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


            string seal1 = Seal1TB.Text;
            Seal1TB.Text = Seal2TB.Text;
            Seal2TB.Text = seal1;

            string mold1 = CurrentMold1.Content.ToString();
            CurrentMold1.Content = CurrentMold2.Content;
            CurrentMold2.Content = mold1;

            Visibility visibility= WorkArea1.Visibility;
            WorkArea1.Visibility = WorkArea2.Visibility;
            WorkArea2.Visibility = visibility;



        }

        //private void ScanCodeTB_TextChanged(object sender, TextChangedEventArgs e)
        //{
        //    if (ScanCodeTB.Text.Length>0)
        //    {
        //        CheckMaterial();
        //    }
        //}

        private void MaterialCB_Checked(object sender, RoutedEventArgs e)
        {
            CheckBox cb = (sender as CheckBox);
            if (!Tool1NrTB.Text.Contains(",")) {
                CurrentMold1.Content = Tool1NrTB.Text;
            }

            if (!Tool2NrTB.Text.Contains(","))
            {
                CurrentMold2.Content = Tool2NrTB.Text;
            }

            if (cb.Name == "Tool1CB") {
                 currentTool1 = CurrentMold1.Content.ToString();
            }
            else if (cb.Name == "Tool2CB") {
                currentTool2 = CurrentMold2.Content.ToString();
            }

            if (AutoCleanScanCB.IsChecked.Value)
            {
                ScanCodeTB.Text = String.Empty;
            }
            StartProduceBtn.IsEnabled = CanStartProduce();

        }

    }
}