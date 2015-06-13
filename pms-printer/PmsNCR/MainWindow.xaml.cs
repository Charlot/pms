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
//using System.ServiceModel.Web;
using PmsNCRWcf;
//using Brilliantech.Framwork.Utils.LogUtil;
using PmsNCRWcf.Converter;
using PmsNCRWcf.Model;
using PmsNCRWcf.Config;
//using PmsNCRWcf.Config;

namespace PmsNCR
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window
    {
        public static string CurrentOrder = string.Empty;

        //WebServiceHost host = null;

        MaterialCheck materialCheck = null;
        OrderPreviewWindow previewWindow = null;

        public MainWindow()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            new Login().ShowDialog();
            this.Title = WPCSConfig.MachineNr + "/" + WPCSConfig.UserNr + "/" + WPCSConfig.UserGroupNr;
            // if (startService()) {
            new ClientDataWatcher().Show();
            //}
        }

        //private bool startService()
        //{ 
        //    try
        //    {
        //        if (host == null)
        //        {
        //            host = new WebServiceHost(typeof(ReceiverService));
        //        }
        //        host.Open();
        //        LogUtil.Logger.Info("NCR接受服务启动:"+host.Description.Endpoints[0].Address);
        //        return true;
        //    }
        //    catch (Exception ex)
        //    {
        //        MessageBox.Show(ex.Message);
        //        LogUtil.Logger.Error(ex.Message);              
        //    }
        //    return false;
        //}
        

        private void MaterialCheckBtn_Click(object sender, RoutedEventArgs e)
        {
            if (MaterialCheck.IsShow == false)
            {
                materialCheck = new MaterialCheck();
                materialCheck.Show();
            }
            else {
                materialCheck.Show();
                materialCheck.Activate();
            }
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if (MessageBox.Show("Confirm Close?")==MessageBoxResult.OK) {
                Application.Current.Shutdown();
            }
        }

        private void PrinterSettingBtn_Click(object sender, RoutedEventArgs e)
        {
            new PrinterSetting().ShowDialog();
        }

        private void OrderPreviewBtn_Click(object sender, RoutedEventArgs e)
        {
            if (OrderPreviewWindow.IsShow == false)
            {
               previewWindow= new OrderPreviewWindow();
                previewWindow.Show();
            }
            else
            { 
                previewWindow.Show();
                previewWindow.Activate();
            }
        }

        private void MachineSettingBtn_Click(object sender, RoutedEventArgs e)
        {
            new MachineSettingWindow().ShowDialog(); 
        }

        private void SPCBtn_Click(object sender, RoutedEventArgs e)
        {
            new SPCWindow().ShowDialog();
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            new AdminWindow().Show();
        }
    }
}
