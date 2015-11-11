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
using PmsNCR.Helper;

namespace PmsNCR
{
    /// <summary>
    /// Login.xaml 的交互逻辑
    /// </summary>
    public partial class Login : Window
    {
        bool logined = false;
        public Login()
        {
            InitializeComponent();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            ShiftCB.ItemsSource = WPCSConfig.UserGroupsNr;
            VersionLab.Content = SettingReader.Version;
        }

        private void OKBtn_Click(object sender, RoutedEventArgs e)
        {
            if (ShiftCB.SelectedIndex > -1 && UserNrText.Text.Trim().Length > 0) {
                WPCSConfig.UserGroupNr = ShiftCB.SelectedValue.ToString() ;
                WPCSConfig.UserNr = UserNrText.Text;
                logined = true;
                this.Close();
            }
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            e.Cancel = !logined;
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            if (MessageBox.Show("Confirm Close?", "Confirm", MessageBoxButton.YesNo) == MessageBoxResult.Yes)
            {
                Application.Current.Shutdown();
            }
        }
    }
}
