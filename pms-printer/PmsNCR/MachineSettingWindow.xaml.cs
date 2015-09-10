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
using PmsNCRWcf.Config;
using PmsNCRWcf;
using PmsNCRWcf.Model;

namespace PmsNCR
{
    /// <summary>
    /// MachineSettingWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MachineSettingWindow : Window
    {
        public MachineSettingWindow()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            MachineNrTB.Text = WPCSConfig.MachineNr;
            MachineIPTB.Text = WPCSConfig.MachineIP;
           // MachineTypeTB.Text = WPCSConfig.MachineType;
            MachineTypesCB.ItemsSource = WPCSConfig.MachineTypes;

            for (int i = 0; i < MachineTypesCB.Items.Count; i++)
            {
                if (MachineTypesCB.Items[i].Equals(WPCSConfig.MachineType))
                {
                    MachineTypesCB.SelectedIndex = i;
                    break;
                }
            }
            PrintSleepTB.Text = WPCSConfig.PrintSleep.ToString();
            ServerIPTB.Text = ApiConfig.Host;
        }

        private void SaveBtn_Click(object sender, RoutedEventArgs e)
        {
            WPCSConfig.MachineNr = MachineNrTB.Text;
            WPCSConfig.MachineIP = MachineIPTB.Text;
            WPCSConfig.PrintSleep = int.Parse(PrintSleepTB.Text);

            if (MachineTypesCB.SelectedIndex > -1)
            {
                WPCSConfig.MachineType = MachineTypesCB.SelectedValue.ToString();
            }

            //ApiConfig.Host = ServerIPTB.Text;
            //MachineService ms = new MachineService();
            //Msg<string> msg = ms.SettingIP(WPCSConfig.MachineNr, WPCSConfig.MachineIP);
            //MessageBox.Show(msg.Content);
        }

    }
}
