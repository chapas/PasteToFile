namespace PasteToFile;

using Microsoft.Win32;
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public static class Program
{
    private static readonly bool Verbose = true;

    [STAThread]
    static void Main()
    {
        try
        {
            WriteVerboseMessage("Starting Paste to File setup...");

            // Define paths using the Windows temporary folder
            string toolPath = Path.GetTempPath();
            string exePath = Path.Combine(toolPath, "ptofile.exe");

            // Compile the executable (in .NET 10, we'll assume the executable is the current assembly)
            WriteVerboseMessage("Using current assembly as executable.");

            // Register the context menu entry in the Registry
            RegisterContextMenu(exePath);

            // Refresh Explorer
            RefreshExplorer();

            WriteVerboseMessage("Setup complete. Right-click in any folder and select 'Paste to file' to test.");
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine($"Error during setup: {ex.Message}");
        }
    }

    private static void WriteVerboseMessage(string message)
    {
        if (Verbose)
        {
            Console.WriteLine(message);
        }
    }

    private static void RegisterContextMenu(string exePath)
    {
        try
        {
            string regPathShell = @"HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file";
            string regPathCommand = $@"{regPathShell}\command";

            // Create or update the Registry keys
            using (RegistryKey shellKey = Registry.ClassesRoot.CreateSubKey(@"Directory\Background\shell\Paste to file"))
            {
                shellKey.SetValue("", "Paste to file");
                shellKey.SetValue("Position", "0", RegistryValueKind.String);
            }

            using (RegistryKey commandKey = Registry.ClassesRoot.CreateSubKey(regPathCommand))
            {
                commandKey.SetValue("", $"\"{exePath}\" \"%V\"");
            }

            WriteVerboseMessage("Context menu entry added/updated successfully.");
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine($"Failed to register context menu: {ex.Message}");
            throw;
        }
    }

    private static void RefreshExplorer()
    {
        try
        {
            const uint WM_SETTINGCHANGE = 0x001A;
            const uint SMTO_ABORTIFHUNG = 0x0002;
            IntPtr HWND_BROADCAST = (IntPtr)0xFFFF;

            NativeMethods.SendMessageTimeout(
                HWND_BROADCAST,
                WM_SETTINGCHANGE,
                IntPtr.Zero,
                "Environment",
                SMTO_ABORTIFHUNG,
                5000,
                out _);

            WriteVerboseMessage("Explorer context menu refreshed.");
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine($"Failed to refresh Explorer: {ex.Message}");
            throw;
        }
    }

    private static class NativeMethods
    {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern IntPtr SendMessageTimeout(
            IntPtr hWnd,
            uint Msg,
            IntPtr wParam,
            string lParam,
            uint fuFlags,
            uint uTimeout,
            out IntPtr lpdwResult);
    }

    // Handle clipboard operations when the app is called via context menu
    public static void ProcessClipboard(string targetDirectory)
    {
        if (!Directory.Exists(targetDirectory))
        {
            return;
        }

        if (Clipboard.ContainsImage())
        {
            try
            {
                using (Image img = Clipboard.GetImage())
                {
                    if (img != null)
                    {
                        string baseFileName = "pastedfile";
                        string extension = ".jpg";
                        string fullPath = GetUniqueFileName(targetDirectory, baseFileName, extension);
                        img.Save(fullPath, ImageFormat.Jpeg);
                    }
                }
            }
            catch
            {
                // Silently fail
            }
        }
        else if (Clipboard.ContainsText())
        {
            try
            {
                string text = Clipboard.GetText();
                if (!string.IsNullOrEmpty(text))
                {
                    string baseFileName = "pastedfile";
                    string extension = ".txt";
                    string fullPath = GetUniqueFileName(targetDirectory, baseFileName, extension);
                    File.WriteAllText(fullPath, text);
                }
            }
            catch
            {
                // Silently fail
            }
        }

        // show a message box to indicate the clipboard does not contain an image or text
        if (!Clipboard.ContainsImage() && !Clipboard.ContainsText())
        {
            MessageBox.Show("Clipboard does not contain an image or text.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    private static string GetUniqueFileName(string directory, string baseName, string extension)
    {
        string filePath = Path.Combine(directory, baseName + extension);
        int counter = 1;

        while (File.Exists(filePath))
        {
            filePath = Path.Combine(directory, baseName + counter.ToString() + extension);
            counter++;
        }

        return filePath;
    }
}