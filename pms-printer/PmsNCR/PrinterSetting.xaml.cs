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
using Brilliantech.Framwork.Utils.LogUtil;
using System.Drawing.Printing;
using PmsNCRWcf.Model;
using PmsNCRWcf.Config;

namespace PmsNCR
{
    /// <summary>
    /// PrinterSetting.xaml 的交互逻辑
    /// </summary>
    public partial class PrinterSetting : Window
    {
        public PrinterSetting()
        {
            InitializeComponent();
            LoadDefaultSettings();
        }

        private void LoadDefaultSettings()
        {
            try
            {
                List<Printer> printers = PrinterConfig.Printers;
                PrintServiceCB.ItemsSource = printers;
                foreach (string printer in PrinterSettings.InstalledPrinters)
                {
                    PrinterCB.Items.Add(printer);
                }
                initPrinter((Printer)PrintServiceCB.Items[0]);
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
                LogUtil.Logger.Error(e.Message);
            }
        }

        private void PrintServiceCB_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            initPrinter((Printer)PrintServiceCB.SelectedItem);
        }

        private void initPrinter(Printer printer)
        {
            for (int i = 0; i < PrinterCB.Items.Count; i++)
            {
                if (PrinterCB.Items[i].Equals(printer.Name))
                {
                    PrinterCB.SelectedIndex = i;
                    break;
                }
            }

            for (int i = 0; i < PrintTypeCB.Items.Count; i++)
            {
                if (int.Parse((PrintTypeCB.Items[i] as ComboBoxItem).Tag.ToString()) == printer.Type)
                {
                    PrintTypeCB.SelectedIndex = i;
                    break;
                }
            }
            TemplateLB.Content = printer.Template;
            CopyTB.Text = printer.Copy.ToString();
        }

        private void SaveBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (AllPrinterSetCB.IsChecked.Value)
                {
                    List<Printer> printers = PrinterConfig.Printers;
                    foreach (Printer p in printers)
                    {
                        p.Name = PrinterCB.SelectedItem.ToString();
                        PrinterConfig.Save(p);
                    }
                }
                Printer printer = PrintServiceCB.SelectedItem as Printer;
                int copy = printer.Copy;
                if (int.TryParse(CopyTB.Text, out copy) && copy > 0)
                {


                    printer.Name = PrinterCB.SelectedItem.ToString();
                    printer.Type = int.Parse((PrintTypeCB.SelectedItem as ComboBoxItem).Tag.ToString());
                    printer.Copy = copy;
                    PrinterConfig.Save(printer);
                    MessageBox.Show("Printer Setting Success");
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                LogUtil.Logger.Error(ex.Message);
            }
        }
    }
}
