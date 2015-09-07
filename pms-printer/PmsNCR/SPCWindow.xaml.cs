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
    /// SPCWindow.xaml 的交互逻辑
    /// </summary>
    public partial class SPCWindow : Window
    {
        public SPCWindow()
        {
            InitializeComponent();
            CurrentJobLab.Content = MainWindow.CurrentOrder;
            //barSeries1.ItemsSource = new List<int>() { 3, 3, 7, 8 };
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
