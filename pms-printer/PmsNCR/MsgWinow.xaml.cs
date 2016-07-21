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

namespace PmsNCR
{
    /// <summary>
    /// MsgWinow.xaml 的交互逻辑
    /// </summary>
    public partial class MsgWinow : Window
    {
        public MsgWinow()
        {
            InitializeComponent();
        }

        public MsgWinow(string msg)
        {
            InitializeComponent();
            msgLabel.Content = msg;
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
