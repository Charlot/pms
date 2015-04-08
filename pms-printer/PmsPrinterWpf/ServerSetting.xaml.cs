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
using PmsPrinterWpf.Setting;

namespace PmsPrinterWpf
{
    /// <summary>
    /// ServerSetting.xaml 的交互逻辑
    /// </summary>
    public partial class ServerSetting : Window
    {
        public ServerSetting()
        {
            InitializeComponent();
            LoadDefaultSetting();
        }

        private void LoadDefaultSetting()
        {
            IPTB.Text = ApiConfig.Host;
            PortTB.Text = ApiConfig.Port;
        }


        private void SaveBtn_Click(object sender, RoutedEventArgs e)
        {
            ApiConfig.Host = IPTB.Text;
            ApiConfig.Port = PortTB.Text;
        }
    }
}
