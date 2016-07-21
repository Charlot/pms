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
    public enum MCSelectType
    {
        Wire,
        Terminal1,
        Terminal2,
        Seal1,
        Seal2
    }
    /// <summary>
    /// MaterialCheckSelect.xaml 的交互逻辑
    /// </summary>
    public partial class MaterialCheckSelect : Window
    {
        public MaterialCheckSelect()
        {
            InitializeComponent();
            Init();
        }

        private void Init( )
        {
            WireLab.Visibility = T1Lab.Visibility = T2Lab.Visibility = S1Lab.Visibility = S2Lab.Visibility = Visibility.Hidden;

            WireCB.Visibility = T1CB.Visibility = T2CB.Visibility = S1CB.Visibility = S2CB.Visibility = Visibility.Hidden;
            if (MainWindow.CurrentOrder != null) {
                if (!string.IsNullOrWhiteSpace(MainWindow.CurrentOrder.WireNr)) {
                    WireLab.Content = MainWindow.CurrentOrder.WireNr;
                    WireCB.Visibility = WireLab.Visibility = Visibility.Visible;
                }

                if (!string.IsNullOrWhiteSpace(MainWindow.CurrentOrder.Terminal1Nr))
                {
                    T1Lab.Content = MainWindow.CurrentOrder.Terminal1Nr;
                    T1CB.Visibility = T1Lab.Visibility = Visibility.Visible;
                }

                if (!string.IsNullOrWhiteSpace(MainWindow.CurrentOrder.Terminal2Nr))
                {
                    T2Lab.Content = MainWindow.CurrentOrder.Terminal2Nr;
                    T2CB.Visibility = T2Lab.Visibility = Visibility.Visible;
                }


                if (!string.IsNullOrWhiteSpace(MainWindow.CurrentOrder.Seal1Nr))
                {
                    S1Lab.Content = MainWindow.CurrentOrder.Seal1Nr;
                    S1CB.Visibility = S1Lab.Visibility = Visibility.Visible;
                }
                if (!string.IsNullOrWhiteSpace(MainWindow.CurrentOrder.Seal2Nr))
                {
                    S2Lab.Content = MainWindow.CurrentOrder.Seal2Nr;
                    S2CB.Visibility = S2Lab.Visibility = Visibility.Visible;
                }
            } 
        }

        private void GoBtn_Click(object sender, RoutedEventArgs e)
        {
            List<MCSelectType> types = new List<MCSelectType>();
            if (WireCB.IsChecked.Value) {
                types.Add(MCSelectType.Wire);
            }
            if (T1CB.IsChecked.Value) {
                types.Add(MCSelectType.Terminal1);
            }
            if (T2CB.IsChecked.Value)
            {
                types.Add(MCSelectType.Terminal2);
            }

            if (S1CB.IsChecked.Value)
            {
                types.Add(MCSelectType.Seal1);
            }
            if (S2CB.IsChecked.Value)
            {
                types.Add(MCSelectType.Seal2);
            }
            if (types.Count > 0) {
                new MaterialCheck(true,types).ShowDialog();
                this.Close();
            }
        }
    }
}
