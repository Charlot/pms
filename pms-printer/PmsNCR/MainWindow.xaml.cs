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
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.ServiceModel.Web;
using PmsNCRWcf;
using Brilliantech.Framwork.Utils.LogUtil;

namespace PmsNCR
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window
    {

        WebServiceHost host = null;
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            startService();
        }

        private void startService()
        {
            try
            {
                if (host == null)
                {
                    host = new WebServiceHost(typeof(ReceiverService));
                }
                host.Open();
                LogUtil.Logger.Info("NCR接受服务启动:"+host.Description.Endpoints[0].Address);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                LogUtil.Logger.Error(ex.Message);
            }
        }

    }
}
