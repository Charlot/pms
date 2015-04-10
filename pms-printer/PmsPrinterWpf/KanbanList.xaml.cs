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
using PmsPrinterWpf.Service;
using PmsPrinterWpf.Model;

namespace PmsPrinterWpf
{
    /// <summary>
    /// KanbanList.xaml 的交互逻辑
    /// </summary>
    public partial class KanbanList : Window
    {
        public KanbanList()
        {
            InitializeComponent();
        }



        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            InitLoad();
        }

        private void InitLoad()
        {
            if (LoadTypes()) {
               // LoadKanbanList(int.Parse(PageLabel.Content.ToString()));
            }
        }

        private bool LoadTypes()
        {
            KanbanService ks = new KanbanService();
            Msg<List<SelectOption>> msg = ks.TypeList();
            if (msg.Result)
            {
                KanbanTypeCB.ItemsSource = msg.Object;
                //KanbanTypeCB.SelectedValuePath = "value";
                //KanbanTypeCB.DisplayMemberPath = "dispaly";
            }
            return msg.Result;
        }

        private bool LoadKanbanList(int page) {
            if (KanbanTypeCB.SelectedIndex > -1)
            {
                KanbanService ks = new KanbanService();
                SelectOption so = KanbanTypeCB.SelectedItem as SelectOption;
                Msg<List<Kanban>> msg = ks.List(so.value,page);
                if (msg.Result)
                {
                    KanbanListDG.ItemsSource = msg.Object;
                }
                return msg.Result;
            }
            return false;
        }

        private void NextPageBtn_Click(object sender, RoutedEventArgs e)
        {
            if (LoadKanbanList(int.Parse(PageLabel.Content.ToString())+1)) {
                PageLabel.Content = int.Parse(PageLabel.Content.ToString()) + 1;
            }
        }


        private void LoadBtn_Click(object sender, RoutedEventArgs e)
        {
            LoadKanbanList(int.Parse(PageLabel.Content.ToString()));
        }

        private void PrevPageBtn_Click(object sender, RoutedEventArgs e)
        {
            int page = int.Parse(PageLabel.Content.ToString()) -1;
            if (page>0 && LoadKanbanList(page))
            {
                PageLabel.Content = int.Parse(PageLabel.Content.ToString()) - 1;
            }
        }

        private void PrintBtn_Click(object sender, RoutedEventArgs e)
        {
            if (KanbanListDG.SelectedItems.Count > 0)
            {
                List<string> kanbans = new List<string>();
                for (int i = 0; i < KanbanListDG.SelectedItems.Count; i++) {
                    kanbans.Add((KanbanListDG.SelectedItems[i] as Kanban).Nr);
                }
                foreach (string kbnr in kanbans)
                {
                    Msg<string> msg = new KanbanService().GetPrintCode(kbnr);
                    if (msg.Result)
                    {
                      Msg<string> pms=  new PrintService().Print(msg.Object, kbnr);
                      if (!pms.Result) {
                          break;
                      }
                    }
                    else
                    {
                        MessageBox.Show(msg.Content);
                    }
                }
             //List<string> kanbans=KanbanListDG.SelectedItems.t
            }
        }
    }
}
