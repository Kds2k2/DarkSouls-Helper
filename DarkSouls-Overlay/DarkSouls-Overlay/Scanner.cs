using System.Text;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Windows.Threading;
using System.Windows;
using System.Net;

namespace DarkSouls_Overlay
{
    public class Scanner
    {
        // Class variables
        private Process targetProcess;
        private IntPtr processHandle;

        // Desired rights
        private const uint PROCESS_ALL_ACCESS = 0x1F0FFF;
        // Constants for memory regions
        private const int MEM_COMMIT = 0x1000;
        private const int PROCESS_VM_READ = 0x0010;
        private const int PROCESS_QUERY_INFORMATION = 0x0400;
        private const int PAGE_READONLY = 0x02;
        private const int PAGE_READWRITE = 0x04;

        // Constructor
        public Scanner(Process process) 
        {
            targetProcess = process;
            processHandle = OpenProcess(PROCESS_ALL_ACCESS, false, targetProcess.Id);
        }

        // Convert byte string to byte array
        public byte[] ConvertStringToBytes(string byteString) 
        {
            string[] elements = byteString.Split(' '); // FF FF A0 -> FF, FF, A0
            byte[] convertedBytes = new byte[elements.Length];

            for (int i = 0; i < elements.Length; i++) 
            {
                if (elements[i].Contains("?")) // Skip
                {
                    convertedBytes[i] = 0x0;
                }
                else
                {
                    convertedBytes[i] = Convert.ToByte(elements[i], 16); // Hex
                }
            }

            return convertedBytes;
        }

        // Memory Scanner
        public List<IntPtr> Scan(string byteString) 
        {
            List<IntPtr> results = new List<IntPtr>();
            IntPtr currentAddress = IntPtr.Zero;
            int bytesRead = 0; // For chunkreading

            byte[] signatureByteArray = ConvertStringToBytes(byteString);

            // Begin iteration through all memory for signature
            while (VirtualQueryEx(processHandle, currentAddress, out MEMORY_BASIC_INFORMATION mbi, (uint)Marshal.SizeOf(typeof(MEMORY_BASIC_INFORMATION))))
            {
                if (mbi.State == MEM_COMMIT && (mbi.Protect != PAGE_READWRITE || mbi.Protect != PAGE_READONLY)) 
                {
                    // if state = OK, try to read the memory
                    byte[] buffer = new byte[(int)mbi.RegionSize];

                    if (ReadProcessMemory(processHandle, mbi.BaseAddress, buffer, buffer.Length, out bytesRead))
                    {
                        for (int i = 0; i < bytesRead - signatureByteArray.Length; i++) 
                        {
                            bool match = true;

                            for (int j = 0; j < signatureByteArray.Length; j++) 
                            {
                                if ((signatureByteArray[j] != 0 && buffer[i + j] != signatureByteArray[j]))
                                {
                                    match = false; 
                                    break;
                                }
                            }

                            if (match) 
                            {
                                results.Add(mbi.BaseAddress + i);
                            }
                        }
                    }
                }

                currentAddress = new IntPtr(currentAddress.ToInt64() + mbi.RegionSize.ToInt64()); // Move to next
            }

            return results;
        }

        // Memory Read
        public IntPtr? Read(IntPtr pointer) 
        {
            IntPtr get = pointer;
            IntPtr hProcess = OpenProcess(PROCESS_VM_READ | PROCESS_QUERY_INFORMATION, false, targetProcess.Id);

            if (hProcess == IntPtr.Zero)
            {
                Application.Current.Dispatcher.Invoke(() => MessageBox.Show("Can't open process!"));
                Application.Current.Shutdown();
                return null;
            }

            byte[] buffer = new byte[4];
            IntPtr bytesRead;
            IntPtr addressToRead = get + 3;

            if (ReadProcessMemory(hProcess, addressToRead, buffer, buffer.Length, out bytesRead))
            {
                int offset = BitConverter.ToInt32(buffer, 0);
                IntPtr Base = get + 7 + offset;
                return Base;
            }
            else
            {
                // al
                Application.Current.Dispatcher.Invoke(() => MessageBox.Show("Can't read memory!"));
                Application.Current.Shutdown();
                return null;
            }
        }

        // Get value from address
        public int Get(IntPtr Base, int[] offsets, int startbit)
        {
            byte[] pointerBuffer = new byte[8];
            IntPtr currentAddress;
            IntPtr hProcess = OpenProcess(PROCESS_VM_READ | PROCESS_QUERY_INFORMATION, false, targetProcess.Id);

            if (!ReadProcessMemory(hProcess, Base, pointerBuffer, pointerBuffer.Length, out int _))
            {
                HandleError($"Failed to read first pointer at {Base:X}!");
                return -1;
            }


            currentAddress = (IntPtr)BitConverter.ToInt64(pointerBuffer, 0);

            for (int i = 0; i < offsets.Length - 1; i++)
            {
                IntPtr nextAddress = currentAddress + offsets[i];

                if (!ReadProcessMemory(hProcess, nextAddress, pointerBuffer, pointerBuffer.Length, out int _))
                {
                    HandleError($"Failed to read next pointer at {nextAddress:X}!");
                    return -1;
                }

                currentAddress = (IntPtr)BitConverter.ToInt64(pointerBuffer, 0);
            }

            IntPtr finalAddress = currentAddress + offsets[offsets.Length - 1];

            byte[] valueBuffer = new byte[1];

            if (ReadProcessMemory(hProcess, finalAddress, valueBuffer, 1, out nint _))
            {
                byte value = valueBuffer[0];
                return (value >> startbit) & 1;
            }

            Application.Current.Dispatcher.Invoke(() => MessageBox.Show($"Failed to read int(bit) at {finalAddress:X}!"));
            Application.Current.Shutdown();
            return -1;
        }
        public int Get(IntPtr Base, int[] offsets)
        {
            byte[] pointerBuffer = new byte[8];
            IntPtr currentAddress;
            IntPtr hProcess = OpenProcess(PROCESS_VM_READ | PROCESS_QUERY_INFORMATION, false, targetProcess.Id);

            if (!ReadProcessMemory(hProcess, Base, pointerBuffer, pointerBuffer.Length, out int _))
            {
                HandleError($"Failed to read first pointer at {Base:X}!");
                return -1;
            }

            currentAddress = (IntPtr)BitConverter.ToInt64(pointerBuffer, 0);

            for (int i = 0; i < offsets.Length - 1; i++)
            {
                IntPtr nextAddress = currentAddress + offsets[i];

                if (!ReadProcessMemory(hProcess, nextAddress, pointerBuffer, pointerBuffer.Length, out int _))
                {
                    HandleError($"Failed to read next pointer at {nextAddress:X}!");
                    return -1;
                }

                currentAddress = (IntPtr)BitConverter.ToInt64(pointerBuffer, 0);
            }

            IntPtr finalAddress = currentAddress + offsets[offsets.Length - 1];

            byte[] valueBuffer = new byte[4]; // reading an int (4 bytes)
            if (ReadProcessMemory(hProcess, finalAddress, valueBuffer, valueBuffer.Length, out int _))
            {
                return BitConverter.ToInt32(valueBuffer, 0);
            }

            Application.Current.Dispatcher.Invoke(() => MessageBox.Show($"Failed to read int at {finalAddress:X}!"));
            Application.Current.Shutdown();
            return -1;
        }
        public string GetString(IntPtr Base, int[] offsets)
        {
            byte[] pointerBuffer = new byte[8]; // 64-bit pointers
            IntPtr currentAddress;
            IntPtr hProcess = OpenProcess(PROCESS_VM_READ | PROCESS_QUERY_INFORMATION, false, targetProcess.Id);

            if (!ReadProcessMemory(hProcess, Base, pointerBuffer, pointerBuffer.Length, out int _))
            {
                HandleError($"Failed to read first pointer at {Base:X}!");
                return string.Empty;
            }

            currentAddress = (IntPtr)BitConverter.ToInt64(pointerBuffer, 0);

            for (int i = 0; i < offsets.Length - 1; i++)
            {
                IntPtr nextAddress = currentAddress + offsets[i];

                if (!ReadProcessMemory(hProcess, nextAddress, pointerBuffer, pointerBuffer.Length, out int _))
                {
                    HandleError($"Failed to read next pointer at {nextAddress:X}!");
                    return string.Empty;
                }

                currentAddress = (IntPtr)BitConverter.ToInt64(pointerBuffer, 0);
            }

            IntPtr finalAddress = currentAddress + offsets[offsets.Length - 1];

            byte[] valueBuffer = new byte[32]; //reading a string (32 bytes)
            ReadProcessMemory(hProcess, finalAddress, valueBuffer, valueBuffer.Length, IntPtr.Zero);
            return Encoding.UTF8.GetString(valueBuffer);

            //Application.Current.Dispatcher.Invoke(() => MessageBox.Show($"Failed to read string at {finalAddress:X}!"));
            //Application.Current.Shutdown();
            //return string.Empty;
        }

        // Handle
        private void HandleError(string message)
        {
            Application.Current.Dispatcher.Invoke(() =>
            {
                MessageBox.Show(message);
                Application.Current.Shutdown();
            });
        }

        // Imports
        [DllImport("kernel32.dll")] // Open process with desired access
        static extern IntPtr OpenProcess(uint dwDesiredAccess, bool bInheritHandle, int dwProcessId);

        [DllImport("kernel32.dll")] // Read Memory x1
        static extern bool ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, [Out] byte[] lpBuffer, int dwSize, out int lpNumberOfBytesRead);

        [DllImport("kernel32.dll")] // Read Memory x2
        static extern bool ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, [Out] byte[] lpBuffer, int dwSize, out IntPtr lpNumberOfBytesRead);

        [DllImport("kernel32.dll")] // Read Memory x3
        static extern bool ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, [Out] byte[] lpBuffer, int nSize, IntPtr lpNumberOfBytesRead);

        [DllImport("kernel32.dll")] // Get info on memory pages
        static extern bool VirtualQueryEx(IntPtr hProcess, IntPtr lpAddress, out MEMORY_BASIC_INFORMATION lpBuffer, uint dwLenght);
    }
}
