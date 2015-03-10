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
using Brilliantech.Framwork.Utils.LogUtil;
using PmsPrinter.Service;

namespace PmsPrinter
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }



        private void PrintBtn_Click(object sender, RoutedEventArgs e)
        {
            string kanbanNr = KanbanNrTB.Text.Trim();

            if (kanbanNr.Length > 0)
            {
                new PrintService().Print("P001", kanbanNr);
            }
            else
            {
                KanbanNrTB.Text = String.Empty;
                MessageBox.Show("请输入需要打印的Kanban号");
                KanbanNrTB.Focus();
            }
        }

        private void SetServerBtn_Click(object sender, RoutedEventArgs e)
        {
            new ServerSetting().ShowDialog();
        }

        private void SetPrinterBtn_Click(object sender, RoutedEventArgs e)
        {
            new PrinterSetting().ShowDialog();
        }
    }
}
