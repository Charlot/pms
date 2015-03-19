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
using System.Timers;
using System.IO;
using Brilliantech.Framwork.Utils.LogUtil;

namespace PmsNCR
{
    /// <summary>
    /// ClientDataWatcher.xaml 的交互逻辑
    /// </summary>
    public partial class ClientDataWatcher : Window
    {

        private System.Timers.Timer scanTimer;

        private static Object fileLocker = new Object();
        private static Object dirLocker = new Object();
         

        public ClientDataWatcher()
        {
            InitializeComponent();
            this.WindowState = WindowState.Minimized;
        }



        /// <summary>
        /// init timer
        /// </summary>
        private void InitTimer()
        {
            this.scanTimer = new System.Timers.Timer();
            ((System.ComponentModel.ISupportInitialize)(this.scanTimer)).BeginInit();
            this.scanTimer.Enabled = true;
            this.scanTimer.Interval = WPCSConfig.ScanClientFolderInterval;
            this.scanTimer.Elapsed += new System.Timers.ElapsedEventHandler(this.scanTimer_Elapsed);
            ((System.ComponentModel.ISupportInitialize)(this.scanTimer)).EndInit();
        }


        /// <summary>
        /// Scan File Timer
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void scanTimer_Elapsed(object sender, ElapsedEventArgs e)
        {
            scanTimer.Stop();
            List<string> files = GetAllFilesFromDirectory(WPCSConfig.ClientDataDir);
            foreach (string file in files)
            {
                if (IsFileClosed(file))
                {
                    Process(file);
                }
            }
            scanTimer.Enabled = true;
            scanTimer.Start();
        }

        /// <summary>
        /// Process File
        /// </summary>
        /// <param name="fullPath"></param>
        private void Process(string fullPath)
        {
            bool canRemoveErrorFile = true;

            string nextDir = System.IO.Path.Combine(WPCSConfig.ScanedFileClientFolder, DateTime.Today.ToString("yyyy-MM-dd"));
            try
            {
                if (IsFileClosed(fullPath))
                {
                    using (FileStream fs = File.Open(fullPath, FileMode.Open, FileAccess.Read))
                    {
                        using (StreamReader reader = new StreamReader(fs))
                        {
                             
                        }
                    }
                }
            }
            catch (Exception e)
            {
                LogUtil.Logger.Error(e.GetType()); 
                canRemoveErrorFile = false;
                LogUtil.Logger.Error(e.Message);
            }
            // 是否可以访问服务 不可以访问时保持文件不处理
            if (canRemoveErrorFile)
            {
                // 是否删除文件
                if (WPCSConfig.DeleteFileAfterRead)
                {
                    // 删除文件
                    if (IsFileClosed(fullPath))
                    {
                        File.Delete(fullPath);
                        LogUtil.Logger.Warn("【删除读完的数据文件】" + fullPath);
                    }
                }
                else
                {
                    // 移动文件
                    CheckDirectory(nextDir);
                    MoveFile(fullPath, System.IO.Path.Combine(nextDir, System.IO.Path.GetFileName(fullPath)));
                }
            }
        }

        /// <summary>
        /// Get all files in directory
        /// </summary>
        /// <param name="direcctory"></param>
        /// <returns></returns>
        private List<string> GetAllFilesFromDirectory(string directory)
        {
            try
            {
                return Directory.GetFiles(directory.Trim()).ToList();
            }
            catch (Exception e)
            {
                LogUtil.Logger.Error("【获取所有文件出现异常】" + e.Message);
                return null;
            }
        }

        /// <summary>
        /// Move file
        /// </summary>
        /// <param name="sourceFileName"></param>
        /// <param name="destFileName"></param>
        /// <param name="autoRename"></param>
        private static void MoveFile(string sourceFileName, string destFileName, bool autoRename = true)
        {
            try
            {
                lock (fileLocker)
                {
                    if (File.Exists(sourceFileName))
                    {
                        if (autoRename)
                        {
                            destFileName = System.IO.Path.Combine(System.IO.Path.GetDirectoryName(destFileName),
                                DateTime.Now.ToString("HHmmSSS") + "_" 
                                +System.IO.Path.GetFileNameWithoutExtension(sourceFileName) 
                                + "_" + Guid.NewGuid().ToString() + System.IO.Path.GetExtension(sourceFileName));
                        }
                        else
                        {
                            throw new IOException("目标文件已经存在");
                        }
                    }
                    File.Move(sourceFileName, destFileName);
                    LogUtil.Logger.Info("【文件移动】【自】" + sourceFileName + "【至】" + destFileName);
                }
            }
            catch (Exception e)
            {
                LogUtil.Logger.Error("【文件移动】【自】" + sourceFileName + "【至】" + destFileName + "【错误】" + e.Message);
            }
        }

        /// <summary>
        /// Check directory
        /// </summary>
        /// <param name="dirName"></param>
        /// <param name="autoCreate"></param>
        /// <returns></returns>
        private static bool CheckDirectory(string dirName, bool autoCreate = true)
        {
            bool result = false;
            lock (dirLocker)
            {
                if (Directory.Exists(dirName))
                {
                    result = true;
                }
                else
                {
                    if (autoCreate)
                    {
                        Directory.CreateDirectory(dirName);
                        result = true;
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// Check file is closed 
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        private bool IsFileClosed(string fileName)
        {
            try
            {
                using (File.Open(fileName, FileMode.Open, FileAccess.ReadWrite, FileShare.None))
                {
                    return true;
                }
            }
            catch (Exception e)
            {
                LogUtil.Logger.Warn(fileName + "文件未关闭." + e.Message);
                return false;
            }
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            e.Cancel = true;
            this.WindowState = WindowState.Minimized;
        }


    }
}
