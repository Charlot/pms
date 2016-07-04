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
using Visifire.Charts;
using Visifire.Gauges;
using PmsNCRWcf;
using PmsNCRWcf.Model;
using PmsNCRWcf.Config;
using System.IO.Ports;
using Brilliantech.Framwork.Utils.LogUtil;
using System.Text.RegularExpressions;
using System.Windows.Threading; 
namespace PmsNCR
{
    /// <summary>
    /// SPCWindow.xaml 的交互逻辑
    /// </summary>
    public partial class SPCWindow : Window
    { 
            SerialPort sp;
        public SPCWindow()
        {
            InitializeComponent();
        }


        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            //barSeries1.ItemsSource = new List<int>() { 3, 3, 7, 8 };
            try
            {
                LoadSPCStandard();
            }
            catch
            {
                ServerError.Content = "ISO not Found.";
            }
            openCom();
        }

        void openCom() {

            if (sp == null)
            {
                sp = new SerialPort(SPCConfig.Com,9600);
                sp.DataBits = 8;
                sp.StopBits = StopBits.One;
                sp.Parity = Parity.None;

                if (!sp.IsOpen)
                {
                    try
                    {
                        sp.Open();

                        sp.DataReceived += new SerialDataReceivedEventHandler(sp_DataReceived);
                        LogUtil.Logger.Info("OpenCom Success");
                    }
                    catch (Exception ex)
                    {
                        LogUtil.Logger.Error("OpenCom Error");
                        LogUtil.Logger.Error(ex.Message);
                    }
                }
            }
        }

        void sp_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            System.Threading.Thread.Sleep(50);
            try
            {
                string data = sp.ReadExisting();
                LogUtil.Logger.Info("[Read Data]" + data);

                Regex r = new Regex(SPCConfig.RuleValueRegex);
                Match m = r.Match(data);
                if (m.Success)
                {
                    float f = float.Parse(m.Value);
                    this.Dispatcher.Invoke(DispatcherPriority.Normal, (System.Windows.Forms.MethodInvoker)delegate()
                    {
                        TextBox currentTB = getFocusedTB();
                        if (currentTB != null) {
                            currentTB.Text = string.Empty;
                            currentTB.Text = f.ToString();
                            currentTB.SelectAll();
                            currentTB.Focus();

                            TextBox nextTB = getNextTB(int.Parse(currentTB.Tag.ToString()));
                            if (nextTB != null)
                            {
                                nextTB.Focus();
                            }
                        }
                    });
                }
            }
            catch (Exception ex)
            {

                LogUtil.Logger.Error("Read Com Error");
                LogUtil.Logger.Error(ex.Message);
            }
            // throw new NotImplementedException();
        }

        TextBox getFocusedTB() {
            foreach (var ctrl in InputSide1.Children)
            {
                if (ctrl is TextBox)
                {
                    if ((ctrl as TextBox).IsFocused) {
                        return ctrl as TextBox;
                       
                    }
                }
            }

            foreach (var ctrl in InputSide2.Children)
            {
                if (ctrl is TextBox)
                {
                    if ((ctrl as TextBox).IsFocused)
                    {
                        return ctrl as TextBox;
                    }
                }
            }

            return null;
        }

        TextBox getNextTB(int currenTag)
        {
            int nextTag = currenTag + 1;
            foreach (var ctrl in InputSide1.Children)
            {
                if (ctrl is TextBox)
                {
                    if ((ctrl as TextBox).Tag.ToString().Equals(nextTag.ToString()))
                    {
                        if ((ctrl as TextBox).IsVisible)
                        {
                            return ctrl as TextBox;
                        }
                        else
                        {
                            return null;
                        }
                    }
                }
            }

            foreach (var ctrl in InputSide2.Children)
            {
                if (ctrl is TextBox)
                {
                    if ((ctrl as TextBox).Tag.ToString().Equals(nextTag.ToString()))
                    {
                        if ((ctrl as TextBox).IsVisible)
                        {
                            return ctrl as TextBox;
                        }
                        else
                        {
                            return null;
                        }
                    }
                }
            }

            return null;
        }

        //X axis data is fixed
        private List<string> strListx = new List<string>() { "1", "2", "3", "4", "5" };


        #region Click
        //Click
        void dataPoint_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            DataPoint dp = sender as DataPoint;
        }
        #endregion

        private void Btn_Close(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        //Judge Side 
        private bool CheckSide1()
        {
            bool passside1 = true;
            //Judge Side1
            if (CriHigStaSid1.Text != "" && CriHigStaSid1Fau.Text != "" && CriWidStaSide1.Text != "" && CriWidFauSide1.Text != "")
            {
                double CriHigStaSid1Str = System.Convert.ToDouble(CriHigStaSid1.Text);
                double CriHigStaSid1FauStr = System.Convert.ToDouble(CriHigStaSid1Fau.Text);

                double CriWidStaSide1Str = System.Convert.ToDouble(CriWidStaSide1.Text);
                double CriWidFauSide1Str = System.Convert.ToDouble(CriWidFauSide1.Text);
                double CriHigHigSide1Str = CriHigStaSid1Str + CriHigStaSid1FauStr;
                double CriHigLowSide1Str = CriHigStaSid1Str - CriHigStaSid1FauStr;
                if (CheckStringIsInvalid(CriHig1Side1.Text))
                {
                    CriHig1Side1.Background = new SolidColorBrush(Colors.Red);
                    //CriHig1Warning.Content = CheckCrimpHeightInvalidString("1");//"Crimp Height 1 Can't be Empty";
                    passside1 = false;
                }
                else
                {
                    double CriHig1Side1Str = System.Convert.ToDouble(CriHig1Side1.Text);
                    if (!CheckCriHig(CriHig1Side1, CriHig1Side1Str, CriHigLowSide1Str, CriHigHigSide1Str, CriHig1Warning))
                    {
                        passside1 = false;
                    }
                }

                if (CheckStringIsInvalid(CriHig2Side1.Text))
                {
                    CriHig2Side1.Background = new SolidColorBrush(Colors.Red);
                    //  CriHig2Warning.Content = "Crimp Height 2 Can't be Empty";
                    passside1 = false;
                }
                else
                {
                    double CriHig2Side1Str = System.Convert.ToDouble(CriHig2Side1.Text);
                    if (!CheckCriHig(CriHig2Side1, CriHig2Side1Str, CriHigLowSide1Str, CriHigHigSide1Str, CriHig2Warning))
                    {
                        passside1 = false;
                    }
                }

                if (CheckStringIsInvalid(CriHig3Side1.Text))
                {
                    CriHig3Side1.Background = new SolidColorBrush(Colors.Red);
                    //CriHig3Warning.Content = "Crimp Height 3 Can't be Empty";
                    passside1 = false;
                }
                else
                {
                    double CriHig3Side1Str = System.Convert.ToDouble(CriHig3Side1.Text);
                    if (!CheckCriHig(CriHig3Side1, CriHig3Side1Str, CriHigLowSide1Str, CriHigHigSide1Str, CriHig3Warning))
                    {
                        passside1 = false;
                    }
                }
                if (CheckStringIsInvalid(CriHig4Side1.Text))
                {
                    CriHig4Side1.Background = new SolidColorBrush(Colors.Red);
                    // CriHig4Warning.Content = "Crimp Height 4 Can't be Empty";
                    passside1 = false;
                }
                else
                {
                    double CriHig4Side1Str = System.Convert.ToDouble(CriHig4Side1.Text);
                    if (!CheckCriHig(CriHig4Side1, CriHig4Side1Str, CriHigLowSide1Str, CriHigHigSide1Str, CriHig4Warning))
                    {
                        passside1 = false;
                    }
                }

                if (CheckStringIsInvalid(CriHig5Side1.Text))
                {
                    CriHig5Side1.Background = new SolidColorBrush(Colors.Red);
                    // CriHig5Warning.Content = "Crimp Height 5 Can't be Empty";
                    passside1 = false;
                }
                else
                {
                    double CriHig5Side1Str = System.Convert.ToDouble(CriHig5Side1.Text);
                    if (!CheckCriHig(CriHig5Side1, CriHig5Side1Str, CriHigLowSide1Str, CriHigHigSide1Str, CriHig5Warning))
                    {
                        passside1 = false;
                    }
                }

                //Low Crime Width 1 & 2
                double CriWidLowSide1Str = CriWidStaSide1Str - CriWidFauSide1Str;
                double CriWidHigSide1Str = CriWidStaSide1Str + CriWidFauSide1Str;

                if (CheckStringIsInvalid(CriWidSide1.Text))
                {
                    CriWidSide1.Background = new SolidColorBrush(Colors.Red);
                    // CriWidWarning.Content = "Crimp Width Can't be Empty";
                    passside1 = false;
                }
                else
                {
                    double CriWidSide1Str = System.Convert.ToDouble(CriWidSide1.Text);
                    if (!CheckCriWid(CriWidSide1, CriWidSide1Str, CriWidLowSide1Str, CriWidHigSide1Str, CriWidWarning))
                    {
                        passside1 = false;
                    }
                }
                //Pulloff Standard
                double PullOffStaSide1Str = System.Convert.ToDouble(PullOffStaSide1.Text);

                if (CheckStringIsInvalid(PullOffSide1.Text))
                {
                    PullOffSide1.Background = new SolidColorBrush(Colors.Red);
                    //  PullOffWarning.Content = "Pulloff Can't be Empty";
                    passside1 = false;
                }
                else
                {
                    double PullOffSide1Str = System.Convert.ToDouble(PullOffSide1.Text);
                    if (!CheckPullOff(PullOffSide1, PullOffSide1Str, PullOffStaSide1Str, PullOffWarning))
                    {
                        passside1 = false;
                    }
                }
            }
            return passside1;
        }
        private bool CheckSide2()
        {
            bool passside2 = true;

            //side2
            if (CriHigStaSid2.Text != "" && CriHigStaSid2Fau.Text != "" && CriWidStaSide2.Text != "" && CriWidFauSide2.Text != "")
            {
                double CriHigStaSid2Str = System.Convert.ToDouble(CriHigStaSid2.Text);
                double CriHigStaSid2FauStr = System.Convert.ToDouble(CriHigStaSid2Fau.Text);

                double CriWidStaSide2Str = System.Convert.ToDouble(CriWidStaSide2.Text);
                double CriWidFauSide2Str = System.Convert.ToDouble(CriWidFauSide2.Text);
                double CriHigHigSide2Str = CriHigStaSid2Str + CriHigStaSid2FauStr;
                double CriHigLowSide2Str = CriHigStaSid2Str - CriHigStaSid2FauStr;

                if (CheckStringIsInvalid(CriHig1Side2.Text))
                {
                    CriHig1Side2.Background = new SolidColorBrush(Colors.Red);
                    //CriHig1Warning.Content = "Crimp Height 1 Can't be Empty";
                    passside2 = false;
                }
                else
                {
                    double CriHig1Side2Str = System.Convert.ToDouble(CriHig1Side2.Text);
                    if (!CheckCriHig(CriHig1Side2, CriHig1Side2Str, CriHigLowSide2Str, CriHigHigSide2Str, CriHig1Warning))
                    {
                        passside2 = false;
                    }
                }

                if (CheckStringIsInvalid(CriHig2Side2.Text))
                {
                    CriHig2Side2.Background = new SolidColorBrush(Colors.Red);
                    //   CriHig2Warning.Content = "Crimp Height 2 Can't be Empty";
                    passside2 = false;
                }
                else
                {
                    double CriHig2Side2Str = System.Convert.ToDouble(CriHig2Side2.Text);
                    if (!CheckCriHig(CriHig2Side2, CriHig2Side2Str, CriHigLowSide2Str, CriHigHigSide2Str, CriHig2Warning))
                    {
                        passside2 = false;
                    }
                }

                if (CheckStringIsInvalid(CriHig3Side2.Text))
                {
                    CriHig3Side2.Background = new SolidColorBrush(Colors.Red);
                    // CriHig3Warning.Content = "Crimp Height 3 Can't be Empty";
                    passside2 = false;
                }
                else
                {
                    double CriHig3Side2Str = System.Convert.ToDouble(CriHig3Side2.Text);
                    if (!CheckCriHig(CriHig3Side2, CriHig3Side2Str, CriHigLowSide2Str, CriHigHigSide2Str, CriHig3Warning))
                    {
                        passside2 = false;
                    }
                }


                if (CheckStringIsInvalid(CriHig4Side2.Text))
                {
                    CriHig4Side2.Background = new SolidColorBrush(Colors.Red);
                    //  CriHig4Warning.Content = "Crimp Height 4 Can't be Empty";
                    passside2 = false;
                }
                else
                {
                    double CriHig4Side2Str = System.Convert.ToDouble(CriHig4Side2.Text);
                    if (!CheckCriHig(CriHig4Side2, CriHig4Side2Str, CriHigLowSide2Str, CriHigHigSide2Str, CriHig4Warning))
                    {
                        passside2 = false;
                    }
                }

                if (CheckStringIsInvalid(CriHig5Side2.Text))
                {
                    CriHig5Side2.Background = new SolidColorBrush(Colors.Red);
                    // CriHig5Warning.Content = "Crimp Height 5 Can't be Empty";
                    passside2 = false;
                }
                else
                {
                    double CriHig5Side2Str = System.Convert.ToDouble(CriHig5Side2.Text);
                    if (!CheckCriHig(CriHig5Side2, CriHig5Side2Str, CriHigLowSide2Str, CriHigHigSide2Str, CriHig5Warning))
                    {
                        passside2 = false;
                    }
                }

                double CriWidLowSide2Str = CriWidStaSide2Str - CriWidFauSide2Str;
                double CriWidHigSide2Str = CriWidStaSide2Str + CriWidFauSide2Str;

                if (CheckStringIsInvalid(CriWidSide2.Text))
                {
                    CriWidSide2.Background = new SolidColorBrush(Colors.Red);
                    //CriWidWarning.Content = "Crimp Width Can't be Empty";
                    passside2 = false;
                }
                else
                {
                    double CriWidSide2Str = System.Convert.ToDouble(CriWidSide2.Text);
                    if (!CheckCriWid(CriWidSide2, CriWidSide2Str, CriWidLowSide2Str, CriWidHigSide2Str, CriWidWarning))
                    {
                        passside2 = false;
                    }
                }

                double PullOffStaSide2Str = System.Convert.ToDouble(PullOffStaSide2.Text);
                if (CheckStringIsInvalid(PullOffSide2.Text))
                {
                    PullOffSide2.Background = new SolidColorBrush(Colors.Red);
                    //PullOffWarning.Content = "Pulloff Can't be Empty";
                    passside2 = false;
                }
                else
                {
                    double PullOffSide2Str = System.Convert.ToDouble(PullOffSide2.Text);
                    if (!CheckPullOff(PullOffSide2, PullOffSide2Str, PullOffStaSide2Str, PullOffWarning))
                    {
                        passside2 = false;
                    }
                }
            }
            return passside2;
        }

        //"Check" data to send
        OrderItemCheck order = MainWindow.CurrentOrder;
        private void MeasureSide1(string note)
        {
            string[] MeasuredDataSide1 = new string[12];
            MeasuredDataSide1[0] = order.ItemNr;
            MeasuredDataSide1[1] = WPCSConfig.MachineNr;
            MeasuredDataSide1[2] = CriHig1Side1.Text;
            MeasuredDataSide1[3] = CriHig2Side1.Text;
            MeasuredDataSide1[4] = CriHig3Side1.Text;
            MeasuredDataSide1[5] = CriHig4Side1.Text;
            MeasuredDataSide1[6] = CriHig5Side1.Text;
            MeasuredDataSide1[7] = CriWidSide1.Text;
            MeasuredDataSide1[8] = "";
            MeasuredDataSide1[9] = "";
            MeasuredDataSide1[10] = PullOffSide1.Text;
            MeasuredDataSide1[11] = note;
            Msg<string> msg = new OrderService().StoreMeasuredData(MeasuredDataSide1);
        }
        private void MeasureSide2(string note)
        {
            string[] MeasuredDataSide2 = new string[12];
            MeasuredDataSide2[0] = order.ItemNr;
            MeasuredDataSide2[1] = WPCSConfig.MachineNr;
            MeasuredDataSide2[2] = CriHig1Side2.Text;
            MeasuredDataSide2[3] = CriHig2Side2.Text;
            MeasuredDataSide2[4] = CriHig3Side2.Text;
            MeasuredDataSide2[5] = CriHig4Side2.Text;
            MeasuredDataSide2[6] = CriHig5Side2.Text;
            MeasuredDataSide2[7] = CriWidSide2.Text;
            MeasuredDataSide2[8] = "";
            MeasuredDataSide2[9] = "";
            MeasuredDataSide2[10] = PullOffSide2.Text;
            MeasuredDataSide2[11] = note;
            Msg<string> msg = new OrderService().StoreMeasuredData(MeasuredDataSide2);
        }

        //Check Button
        private void Btn_Check(object sender, RoutedEventArgs e)
        {
            DrawLine();

            bool passside1 = CheckSide1();
            bool passside2 = CheckSide2();
            //Judge
            if (passside1 && passside2)
            {
                if (order.Terminal1Nr != null)
                {
                    MeasureSide1("true");
                }
                if (order.Terminal2Nr != null)
                {
                    MeasureSide2("true");
                }
            }
            else if (!passside1 && passside2)
            {
                if (order.Terminal1Nr != null)
                {
                    MeasureSide1("false");
                }
                if (order.Terminal2Nr != null)
                {
                    MeasureSide2("true");
                }
            }
            else if (passside1 && !passside2)
            {
                if (order.Terminal1Nr != null)
                {
                    MeasureSide1("true");
                }
                if (order.Terminal2Nr != null)
                {
                    MeasureSide2("false");
                }
            }
            else
            {
                if (order.Terminal1Nr != null)
                {
                    MeasureSide1("false");
                }
                if (order.Terminal2Nr != null)
                {
                    MeasureSide2("false");
                }
            }
        }

        //Crimp height function
        private bool CheckCriHig(TextBox CriHig, double CriHigStr, double CriHigLowStr, double CriHigHigStr, Label CriHigWarning)
        {
            CriHig.Background = new SolidColorBrush(Colors.White);
            CriHigWarning.Content = "";
            if (CriHigStr < CriHigLowStr || CriHigStr > CriHigHigStr)
            {
                CriHig.Background = new SolidColorBrush(Colors.Red);
                //   CriHigWarning.Content = "Crimp Height isn't meet requirements";
                return false;
            }
            else
            {
                CriHigWarning.Content = "";
                CriHig.Background = new SolidColorBrush(Colors.White);
                return true;
            }
        }
        //Crimp width function
        private bool CheckCriWid(TextBox CriWid, double CriWidStr, double CriWidLowStr, double CriWidHigStr, Label CriWidWarning)
        {
            CriWid.Background = new SolidColorBrush(Colors.White);
            CriWidWarning.Content = "";
            if (CriWidStr < CriWidLowStr || CriWidStr > CriWidHigStr)
            {
                CriWid.Background = new SolidColorBrush(Colors.Red);
                //    CriWidWarning.Content = "Crimp Width isn't meet requirements "; 
                return false;
            }
            else
            {
                CriWidWarning.Content = "";
                CriWid.Background = new SolidColorBrush(Colors.White);
                return true;
            }
        }
        //Pulloff function
        private bool CheckPullOff(TextBox PullOff, double PullOffStr, double PullOffStaStr, Label PullOffWarning)
        {
            PullOff.Background = new SolidColorBrush(Colors.White);
            PullOffWarning.Content = "";
            if (PullOffStr < PullOffStaStr)
            {
                PullOff.Background = new SolidColorBrush(Colors.Red);
                //  PullOffWarning.Content = "Pulloff isn't meet requirements ";
                return false;
            }
            else
            {
                PullOffWarning.Content = "";
                PullOff.Background = new SolidColorBrush(Colors.White);
                return true;
            }
        }

        //Draw Chart
        private void DrawLine()
        {

            List<string> strListy = new List<string>(5);
            strListy.Add(CriHig1Side1.Text);
            strListy.Add(CriHig2Side1.Text);
            strListy.Add(CriHig3Side1.Text);
            strListy.Add(CriHig4Side1.Text);
            strListy.Add(CriHig5Side1.Text);

            if (CriHig1Side1.Text.Trim() == "")
            {
                DrawWaringText.Content = "Crime Height 1 is Empty";
                CriHig1Side1.Background = new SolidColorBrush(Colors.Red);
                LineChart1.Children.Clear();
            }
            else if (CriHig2Side1.Text.Trim() == "")
            {
                CriHig1Side1.Background = new SolidColorBrush(Colors.White);
                DrawWaringText.Content = "Crime Height 2 is Empty";
                CriHig2Side1.Background = new SolidColorBrush(Colors.Red);
                LineChart1.Children.Clear();
            }
            else if (CriHig3Side1.Text.Trim() == "")
            {
                CriHig2Side1.Background = new SolidColorBrush(Colors.White);
                DrawWaringText.Content = "Crime Height 3 is Empty";
                CriHig3Side1.Background = new SolidColorBrush(Colors.Red);
                LineChart1.Children.Clear();
            }
            else if (CriHig4Side1.Text.Trim() == "")
            {
                CriHig3Side1.Background = new SolidColorBrush(Colors.White);
                DrawWaringText.Content = "Crime Height 4 is Empty";
                CriHig4Side1.Background = new SolidColorBrush(Colors.Red);
                LineChart1.Children.Clear();
            }
            else if (CriHig5Side1.Text.Trim() == "")
            {
                CriHig4Side1.Background = new SolidColorBrush(Colors.White);
                DrawWaringText.Content = "Crime Height 5 is Empty";
                CriHig5Side1.Background = new SolidColorBrush(Colors.Red);
                LineChart1.Children.Clear();
            }
            else
            {
                DrawWaringText.Content = "";
                //clear style
                LineChart1.Children.Clear();
                CriHig5Side1.Background = new SolidColorBrush(Colors.White);
                CreateChartColumn("", strListx, strListy);
            }

            List<string> strListy2 = new List<string>(5);
            strListy2.Add(CriHig1Side2.Text);
            strListy2.Add(CriHig2Side2.Text);
            strListy2.Add(CriHig3Side2.Text);
            strListy2.Add(CriHig4Side2.Text);
            strListy2.Add(CriHig5Side2.Text);

            if (CriHig1Side2.Text.Trim() == "")
            {
                DrawWaringText2.Content = "Crime Height 1 is Empty";
                CriHig1Side2.Background = new SolidColorBrush(Colors.Red);
                LineChart2.Children.Clear();
            }
            else if (CriHig2Side2.Text.Trim() == "")
            {
                CriHig1Side2.Background = new SolidColorBrush(Colors.White);
                DrawWaringText2.Content = "Crime Height 2 is Empty";
                CriHig2Side2.Background = new SolidColorBrush(Colors.Red);
                LineChart2.Children.Clear();
            }
            else if (CriHig3Side2.Text.Trim() == "")
            {
                CriHig2Side2.Background = new SolidColorBrush(Colors.White);
                DrawWaringText2.Content = "Crime Height 3 is Empty";
                CriHig3Side2.Background = new SolidColorBrush(Colors.Red);
                LineChart2.Children.Clear();
            }
            else if (CriHig4Side2.Text.Trim() == "")
            {
                CriHig3Side2.Background = new SolidColorBrush(Colors.White);
                DrawWaringText2.Content = "Crime Height 4 is Empty";
                CriHig4Side2.Background = new SolidColorBrush(Colors.Red);
                LineChart2.Children.Clear();
            }
            else if (CriHig5Side2.Text.Trim() == "")
            {
                CriHig4Side2.Background = new SolidColorBrush(Colors.White);
                DrawWaringText2.Content = "Crime Height 5 is Empty";
                CriHig5Side2.Background = new SolidColorBrush(Colors.Red);
                LineChart2.Children.Clear();
            }
            else
            {
                DrawWaringText2.Content = "";
                //clear style
                LineChart2.Children.Clear();
                CriHig5Side2.Background = new SolidColorBrush(Colors.White);
                CreateChartColumn2("", strListx, strListy2);
            }
        }
        //Draw Chart 1
        public void CreateChartColumn(string name, List<string> valuex, List<string> valuey)
        {
            //get Standard
            double CriHigStaSid1Vau = System.Convert.ToDouble(CriHigStaSid1.Text);
            double CriHigStaSid1FauVau = System.Convert.ToDouble(CriHigStaSid1Fau.Text);
            double CriHigLowVau = CriHigStaSid1Vau - CriHigStaSid1FauVau * 4 / 3;
            double CriHigVau = CriHigStaSid1Vau + CriHigStaSid1FauVau * 4 / 3;

            //new Chart
            Chart chart = new Chart();

            //set Width and Height
            chart.Width = 400;
            chart.Height = 200;
            chart.Margin = new Thickness(0, 10, 0, 0);
            chart.ToolBarEnabled = true;
            chart.BorderThickness = new Thickness(0);
            //set background White
            //chart.Background = new SolidColorBrush(Colors.Transparent);
            chart.Background = new SolidColorBrush(Color.FromArgb(1, 255, 255, 255));
            chart.AnimationEnabled = true;
            chart.ColorSet = "VisiBlue";

            chart.ScrollingEnabled = false;
            chart.View3D = false;

            //create title
            Title title = new Title();

            //set title name
            title.Text = name;
            title.Padding = new Thickness(0, 10, 10, 0);
            title.FontColor = new SolidColorBrush(Colors.Black);
            FontFamilyConverter fontfamilyConver = new FontFamilyConverter();
            title.FontFamily = (System.Windows.Media.FontFamily)fontfamilyConver.ConvertFrom("Arial");
            chart.Titles.Add(title);

            Axis yAxis = new Axis();
            Axis xAxis = new Axis();

            xAxis.Title = "Number of measures";
            //xAxis.Enabled = false;
            chart.AxesX.Add(xAxis);

            ChartGrid ygrid = new ChartGrid();
            ygrid.Enabled = false;
            yAxis.Grids.Add(ygrid);

            yAxis.AxisMinimum = CriHigLowVau;
            yAxis.Prefix = "";
            yAxis.Suffix = "";
            //yAxis.AxisType = AxisTypes.Secondary; 
            ///yAxis.AxisType = AxisTypes.Primary;
            yAxis.AxisMaximum = CriHigVau;
            //yAxis.Enabled = false;
            yAxis.Interval = 0.025;
            yAxis.ValueFormatString = "#0.000";
            yAxis.Title = "Values";

            chart.AxesY.Add(yAxis);

            DataSeries dataSeries = new DataSeries();

            dataSeries.LegendText = "Number";
            dataSeries.YValueFormatString = "#0.000";
            dataSeries.RenderAs = RenderAs.Line;
            dataSeries.LabelEnabled = true;
            dataSeries.MarkerType = Visifire.Commons.MarkerTypes.Square;
            dataSeries.MarkerSize = 8;
            DataPoint dataPoint;
            for (int i = 0; i < valuex.Count; i++)
            {
                dataPoint = new DataPoint();
                dataPoint.AxisXLabel = valuex[i];
                //dataPoint.YValue = System.Convert.ToDouble(valuey[i]);
                double value = 0;
                double.TryParse(valuey[i], out value);
                dataPoint.YValue = value;
                //dataPoint.YValue = Convert.ToDouble(valuey[i]);
                //dataPoint.MarkerSize = 20;
                //dataPoint.MarkerColor = new SolidColorBrush(Colors.Red);
                dataPoint.MouseLeftButtonDown += new MouseButtonEventHandler(dataPoint_MouseLeftButtonDown);
                dataSeries.DataPoints.Add(dataPoint);
            }

            chart.Series.Add(dataSeries);
            Grid gr = new Grid();
            gr.Children.Add(chart);
            LineChart1.Children.Add(gr);
        }
        //Draw Chart 2
        public void CreateChartColumn2(string name, List<string> valuex, List<string> valuey2)
        {
            double CriHigStaSid2Vau = System.Convert.ToDouble(CriHigStaSid2.Text);
            double CriHigStaSid2FauVau = System.Convert.ToDouble(CriHigStaSid2Fau.Text);
            double CriHigLowVau = CriHigStaSid2Vau - CriHigStaSid2FauVau * 4 / 3;
            double CriHigVau = CriHigStaSid2Vau + CriHigStaSid2FauVau * 4 / 3;

            Chart chart = new Chart();

            chart.Width = 400;
            chart.Height = 200;
            chart.Margin = new Thickness(0, 10, 0, 0);
            chart.ToolBarEnabled = true;
            chart.BorderThickness = new Thickness(0);
            //chart.Background = new SolidColorBrush(Colors.Transparent);
            chart.Background = new SolidColorBrush(Color.FromArgb(1, 255, 255, 255));

            chart.AnimationEnabled = true;
            chart.ColorSet = "VisiBlue";

            chart.ScrollingEnabled = false;
            chart.View3D = false;

            Title title = new Title();

            title.Text = name;
            title.Padding = new Thickness(0, 10, 5, 0);
            title.FontColor = new SolidColorBrush(Colors.Black);
            FontFamilyConverter fontfamilyConver = new FontFamilyConverter();
            title.FontFamily = (System.Windows.Media.FontFamily)fontfamilyConver.ConvertFrom("Arial");
            chart.Titles.Add(title);

            Axis yAxis = new Axis();
            Axis xAxis = new Axis();

            xAxis.Title = "Number of measures";
            //xAxis.Enabled = false;
            chart.AxesX.Add(xAxis);

            ChartGrid ygrid = new ChartGrid();
            ygrid.Enabled = false;
            yAxis.Grids.Add(ygrid);

            yAxis.Title = "Values";
            yAxis.AxisMinimum = CriHigLowVau;
            //yAxis.Prefix = "";
            //yAxis.Suffix = "";
            yAxis.AxisMaximum = CriHigVau;
            yAxis.Interval = 0.025;
            //yAxis.Enabled = false;
            yAxis.AxisLabels = new AxisLabels
            {
                //Enabled = true,
                //Angle = 45
            };
            yAxis.ValueFormatString = "#0.000";
            chart.AxesY.Add(yAxis);

            DataSeries dataSeries = new DataSeries();

            dataSeries.YValueFormatString = "#0.000";
            dataSeries.LegendText = "Number2";
            dataSeries.RenderAs = RenderAs.Line;
            dataSeries.LabelEnabled = true;
            dataSeries.MarkerType = Visifire.Commons.MarkerTypes.Square;
            dataSeries.MarkerSize = 8;

            DataPoint dataPoint;
            for (int i = 0; i < valuex.Count; i++)
            {
                dataPoint = new DataPoint();
                dataPoint.AxisXLabel = valuex[i];
                //dataPoint.YValue = double.Parse(valuey2[i]);

                double value = 0;
                double.TryParse(valuey2[i], out value);
                dataPoint.YValue = value;

                // dataPoint.YValue = Convert.ToDouble(valuey2[i]);
                dataPoint.MouseLeftButtonDown += new MouseButtonEventHandler(dataPoint_MouseLeftButtonDown);
                dataSeries.DataPoints.Add(dataPoint);
            }

            chart.Series.Add(dataSeries);
            Grid gr = new Grid();
            gr.Children.Add(chart);
            LineChart2.Children.Add(gr);
        }

        //Hidden Side

        private void HidSide1()
        {
            InputSide1.Visibility = Visibility.Hidden;
            StandardSide1.Visibility = Visibility.Hidden;
            LineSide1.Visibility = Visibility.Hidden;
            LineSide1Bg.Visibility = Visibility.Hidden;
        }
        private void HidSide2()
        {
            InputSide2.Visibility = Visibility.Hidden;
            StandardSide2.Visibility = Visibility.Hidden;
            LineSide2.Visibility = Visibility.Hidden;
            LineSide2Bg.Visibility = Visibility.Hidden;
        }

        //private void Window_Loaded(object sender, RoutedEventArgs e)
        //{
        //    LoadSPCStandard();
        //}

        //Receives standard value or rule
        private void LoadSPCStandard()
        {
            OrderItemCheck order = MainWindow.CurrentOrder;

            if (order == null)
            {
                CurrentJobLab.Content = "No Order!";
                CurrentJobLab.Foreground = new SolidColorBrush(Colors.Red);
                HidSide1();
                HidSide2();
                ServerError.Content = "No Order,Please Check";
                Check.IsEnabled = false;
            }
            else
            {
                string orderNr = order.ItemNr;
                CurrentJobLab.Content = orderNr;
                kanbanLabel.Content = order.KanbanNr;
                Msg<Dictionary<string, SPCStandard>> msg = new OrderService().OrderItemGetConfigAction(orderNr);
                if (msg.Result)
                {
                    Dictionary<string, SPCStandard> standard = msg.Object;
                    if (order.Terminal1Nr != null && standard.Count != 0)
                    {
                        try
                        {
                            PullOffStaSide1.Text = standard[order.Terminal1Nr].Min_pullOff_value.ToString();
                            CriHigStaSid1.Text = standard[order.Terminal1Nr].Crimp_height.ToString();
                            CriHigStaSid1Fau.Text = standard[order.Terminal1Nr].Crimp_height_iso.ToString();
                            CriWidStaSide1.Text = standard[order.Terminal1Nr].Crimp_width.ToString();
                            CriWidFauSide1.Text = standard[order.Terminal1Nr].Crimp_width_iso.ToString();

                            Chart1Title.Content = "Latest for tool:" + order.Tool1Nr + "/" + order.Terminal1Nr;
                        }
                        catch
                        {
                            HidSide1();
                            ServerError.Content = "Termina1Nr:" + order.Terminal1Nr + ",ISO not Found.";
                            Check.IsEnabled = false;
                        }

                    }
                    else if (order.Terminal1Nr == null)
                    {
                        HidSide1();
                    }
                    else
                    {
                        HidSide1();
                        ServerError.Content = "order.TerminalNr:" + order.Terminal1Nr + ",ISO not Found.";
                        Check.IsEnabled = false;
                    }

                    if (order.Terminal2Nr != null && standard.Count != 0)
                    {
                        try {
                            PullOffStaSide2.Text = standard[order.Terminal2Nr].Min_pullOff_value.ToString();
                            CriHigStaSid2.Text = standard[order.Terminal2Nr].Crimp_height.ToString();
                            CriHigStaSid2Fau.Text = standard[order.Terminal2Nr].Crimp_height_iso.ToString();
                            CriWidStaSide2.Text = standard[order.Terminal2Nr].Crimp_width.ToString();
                            CriWidFauSide2.Text = standard[order.Terminal2Nr].Crimp_width_iso.ToString();

                            Chart2Title.Content = "Latest for tool:" + order.Tool2Nr + "/" + order.Terminal2Nr;
                        }
                        catch {
                            HidSide2();
                            ServerError2.Content = "order.Termina2Nr:" + order.Terminal2Nr + ",ISO not Found.";
                            Check.IsEnabled = false;
                        }
                        
                    }
                    else if (order.Terminal2Nr == null)
                    {
                        HidSide2();
                    }
                    else
                    {
                        HidSide2();
                        ServerError2.Content = "order.Termina2Nr:" + order.Terminal2Nr + ",ISO not Found.";
                        Check.IsEnabled = false;
                    }
                }
            }
        }

        // check input is double
        public bool CheckStringIsInvalid(string value)
        {
            //if (string.IsNullOrWhiteSpace(value)) {
            //    return false;
            //}
            double v = 0;
            return !double.TryParse(value, out v);
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if (sp != null)
            {
                try
                {
                    sp.Close();
                    LogUtil.Logger.Info("Close Success");

                }
                catch (Exception ex)
                {
                    LogUtil.Logger.Error("Close Error");
                    LogUtil.Logger.Error(ex.Message);

                }

            }
        }

        //private string CheckCrimpWidthInvalidString(string input)
        //{
        //    return CheckStringInvalidString("Crimp Width", input);
        //}

        //private string CheckCrimpHeightInvalidString(string input) {
        //  return  CheckStringInvalidString("Crimp Height",input);
        //}

        //private string CheckStringInvalidString( params string[] inputs) {
        //    return string.Format("%s %s Is Invalid!",inputs);
        //}


    }
}
