using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using Brilliantech.Framwork.Utils.ConfigUtil;

namespace PmsNCRWcf.Config
{
    public class WPCSConfig
    {
        private static ConfigUtil config;

        private static string serverOrderFolder;
        private static string serverOrderDir;

        private static string serverDataFolder;
        private static string serverDataDir;

        private static string clientDataFolder;
        private static string clientDataDir;    

        private static string machineNr;
        private static string machineIP;

        private static int scanClientFolderInterval = 1000;
        private static bool deleteFileAfterRead = false;

        private static string scanedFileClientFolder;    
        private static string scanedFileClientDir;

        private static string processsedFileClientFolder;
        private static string processsedFileClientDir;

      

        static WPCSConfig()
        {
            config = new ConfigUtil("WPCS", "Ini/wpcs.ini");

            serverOrderFolder = config.Get("ServerOrderFolder");
            serverOrderDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, serverOrderFolder);

            serverDataFolder = config.Get("ServerDataFolder");
            serverDataDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, serverDataFolder);

            clientDataFolder = config.Get("ClientDataFolder");
            clientDataDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, clientDataFolder);

            machineNr = config.Get("MachineNr");
            machineIP = config.Get("MachineIP");

            if (!int.TryParse(config.Get("ScanClientFolderInterval"), out scanClientFolderInterval))
            {
                scanClientFolderInterval = 1000;
            }

            if (!bool.TryParse(config.Get("DeleteFileAfterRead"), out deleteFileAfterRead))
            {
                deleteFileAfterRead = false;
            }

            scanedFileClientFolder = config.Get("ScanedFileClientFolder");
            scanedFileClientDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, scanedFileClientFolder);


            processsedFileClientFolder = config.Get("ProcesssedFileClientFolder");
            processsedFileClientDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, processsedFileClientFolder);
        }


        /// <summary>
        /// get server order full path by order file name
        /// </summary>
        /// <param name="fileName">file name</param>
        /// <returns></returns>
        public static string GetServerOrderFullPath(string fileName)
        {
            return Path.Combine(WPCSConfig.ServerOrderDir, fileName);
        }

        public static string ServerOrderFolder
        {
            get { return WPCSConfig.serverOrderFolder; }
            set { WPCSConfig.serverOrderFolder = value; }
        }
        public static string ServerDataFolder
        {
            get { return WPCSConfig.serverDataFolder; }
            set { WPCSConfig.serverDataFolder = value; }
        }

        public static string ServerOrderDir
        {
            get { return WPCSConfig.serverOrderDir; }
        }

        public static string ServerDataDir
        {
            get { return WPCSConfig.serverDataDir; }
        }

        public static string ClientDataFolder
        {
            get { return WPCSConfig.clientDataFolder; }
            set { WPCSConfig.clientDataFolder = value; }
        }

        public static string ClientDataDir
        {
            get { return WPCSConfig.clientDataDir; }
            set { WPCSConfig.clientDataDir = value; }
        }


        public static string MachineNr
        {
            get { return WPCSConfig.machineNr; }
            set { WPCSConfig.machineNr = value; }
        }
        public static string MachineIP
        {
            get { return WPCSConfig.machineIP; }
            set { WPCSConfig.machineIP = value; }
        }

        public static int ScanClientFolderInterval
        {
            get { return WPCSConfig.scanClientFolderInterval; }
            set { WPCSConfig.scanClientFolderInterval = value; }
        }

        public static bool DeleteFileAfterRead
        {
            get { return WPCSConfig.deleteFileAfterRead; }
            set { WPCSConfig.deleteFileAfterRead = value; }
        }

        public static string ScanedFileClientFolder
        {
            get { return WPCSConfig.scanedFileClientFolder; }
            set { WPCSConfig.scanedFileClientFolder = value; }
        }
        public static string ScanedFileClientDir
        {
            get { return WPCSConfig.scanedFileClientDir; }
            set { WPCSConfig.scanedFileClientDir = value; }
        }

        public static string ProcesssedFileClientFolder
        {
            get { return WPCSConfig.processsedFileClientFolder; }
            set { WPCSConfig.processsedFileClientFolder = value; }
        }
        public static string ProcesssedFileClientDir
        {
            get { return WPCSConfig.processsedFileClientDir; }
            set { WPCSConfig.processsedFileClientDir = value; }
        }
    }
}