using DarkSouls_Overlay.Managers;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Data;
using System.Windows.Input;
using System.Windows.Threading;

namespace DarkSouls_Overlay
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>hh
    public partial class MainWindow : Window
    {
        // Timer Import
        [DllImport("user32.dll", SetLastError = true)]
        private static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

        // Timer Variables
        private DispatcherTimer positionUpdateTimer;
        private IntPtr gameWindowHandle;

        // Keyboard Imports
        [DllImport("user32.dll")]
        private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

        [DllImport("user32.dll")]
        private static extern bool UnhookWindowsHookEx(IntPtr hhk);

        [DllImport("user32.dll")]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

        [DllImport("kernel32.dll")]
        private static extern IntPtr GetModuleHandle(string lpModuleName);

        // Keyboard Delegate
        private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

        // Keyboard Variables
        private const int WH_KEYBOARD_LL = 13;
        private const int WM_KEYDOWN = 0x0100;

        private LowLevelKeyboardProc _keyboardProc;
        private IntPtr _hookID = IntPtr.Zero;
        private bool isReady = false;

        // Collection Variables
        private int currentPage = 0;
        private int itemsPerPage = 9;
        private ICollectionView pagedView;

        // Scanner Variables
        private IntPtr baseB;
        //private IntPtr baseX;
        //private IntPtr basePF;
        private IntPtr baseBS;

        // Game Process
        private Process gameProcess;

        // PlayerManager
        private PlayerStatsManager playerManager;

        // Property for Player Name Label
        private string _playerName;
        public string PlayerName
        {
            get => _playerName;
            set
            {
                _playerName = value;
                Dispatcher.BeginInvoke(() =>
                {
                    playerNameLabel.Content = $"Player: {_playerName ?? "Unknown"}";
                });
            }
        }

        // Property for Death Label
        private int _deathCount;
        public int DeathCount
        {
            get => _deathCount;
            set
            {
                _deathCount = value;
                playerManager.PlayerStats.TotalDeath = _deathCount;

                Dispatcher.BeginInvoke(() =>
                {
                    deathLabel.Content = $"Death: {_deathCount}";    
                });
            }
        }

        // Property for Location Label
        private string _currentLocation;
        public string CurrentLocation
        {
            get => _currentLocation;
            set
            {
                _currentLocation = value;
                Dispatcher.BeginInvoke(() =>
                {
                    locationLabel.Content = _currentLocation ?? "Unknown Location";
                });
            }
        }

        // Property for Last Boss Label
        private string _lastBoss;
        public string LastBoss
        {
            get => _lastBoss;
            set
            {
                _lastBoss = value;
                playerManager.PlayerStats.LastBoss = _lastBoss ?? "Unknown";
                Dispatcher.BeginInvoke(() =>
                {
                    lastBossLabel.Content = $"Last Boss: {_lastBoss ?? "Unknown"}";
                });
            }
        }

        // Main
        public MainWindow()
        {
            InitializeComponent();
            _keyboardProc = HookCallback;
        }

        // Lifecycle methods
        private async void Window_Loaded(object sender, RoutedEventArgs e)
        {
            // Set game process
            var process = Process.GetProcessesByName(Game.processName).FirstOrDefault();
            if (process == null)
            {
                Dispatcher.Invoke(() => MessageBox.Show("Game process not found!"));
                Application.Current.Shutdown();
                return;
            }
            gameProcess = process;

            // Start monitoring game process
            MonitorGameProcess();
            AttachToGameWindow();

            // Start Server
            StartServer();

            // Hook
            _hookID = SetHook(_keyboardProc);

            // Start scanning
            await Task.Run(() => RunGameScanner());
        }
        private void Window_Closed(object sender, EventArgs e)
        {
            // Close server
            Server.shared.Close();
            // Unhook
            UnhookWindowsHookEx(_hookID);
        }
        private void Window_KeyDown(object sender, KeyEventArgs e)
        {
            //TODO: ...
        }

        // Game Process method
        private async void MonitorGameProcess()
        {
            await Task.Run(() =>
            {
                while (!gameProcess.HasExited)
                {
                    Thread.Sleep(1000); // 1 s;
                }

                Dispatcher.Invoke(() =>
                {
                    Application.Current.Shutdown();
                });
            });
        }

        // Keyboard methods
        private IntPtr SetHook(LowLevelKeyboardProc proc)
        {
            if (gameProcess.MainModule != null) 
            {
                return SetWindowsHookEx(WH_KEYBOARD_LL, proc, GetModuleHandle(gameProcess.MainModule.ModuleName), 0);
            }

            Dispatcher.Invoke(() => MessageBox.Show("Keyboard Hook is zero!"));
            return IntPtr.Zero;
        }
        private IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN)
            {
                int vkCode = Marshal.ReadInt32(lParam);

                if (isReady && vkCode == KeyInterop.VirtualKeyFromKey(Key.H))
                {
                    Dispatcher.Invoke(() =>
                    {
                        if (bossesListBox.Visibility == Visibility.Collapsed && lastBossLabel.Visibility == Visibility.Visible)
                        {
                            PopulateBossesList();
                            bossesListBox.Visibility = Visibility.Visible;
                            pageLabel.Visibility = Visibility.Visible; // Show page label
                            lastBossLabel.Visibility = Visibility.Collapsed;
                        }
                        else if (bossesListBox.Visibility == Visibility.Visible)
                        {
                            bossesListBox.Visibility = Visibility.Collapsed;
                            pageLabel.Visibility = Visibility.Collapsed; // Hide page label
                            lastBossLabel.Visibility = Visibility.Visible;
                        }
                    });
                }

                if (isReady && bossesListBox.Visibility == Visibility.Visible)
                {
                    if (vkCode == KeyInterop.VirtualKeyFromKey(Key.Right))
                    {
                        MoveToPage(currentPage + 1); // Next page
                    }
                    else if (vkCode == KeyInterop.VirtualKeyFromKey(Key.Left))
                    {
                        MoveToPage(currentPage - 1); // Previous page
                    }
                }
            }

            return CallNextHookEx(_hookID, nCode, wParam, lParam);
        }

        // Scanner method
        private void RunGameScanner()
        {
            Scanner scan = new Scanner(gameProcess);
            Dispatcher.Invoke(() => loadingLabel.Content = "Loading BaseB");

            baseB = GetBaseAddress(scan, Base.patternB, "BaseB");
            Dispatcher.Invoke(() => {
                loadingLabel.Content = "Loading BaseBS";
                progressBar.Value += 50;
            });

            //baseX = GetBaseAddress(scan, Base.patternX, "BaseX");
            //Dispatcher.Invoke(() => {
            //    loadingLabel.Content = "Loading BasePF";
            //    progressBar.Value += 25;
            //});

            //basePF = GetBaseAddress(scan, Base.patternPF, "BasePF");
            //Dispatcher.Invoke(() => {
            //    loadingLabel.Content = "Loading BaseBS";
            //    progressBar.Value += 25;
            //});

            baseBS = GetBaseAddress(scan, Base.patternBS, "BaseBS");
            Dispatcher.Invoke(() => {
                loadingLabel.Content = "Done.";
                progressBar.Value += 50;
            });

            Dispatcher.Invoke(() =>
            {
                loadingGrid.Visibility = Visibility.Collapsed;
                labelsGrid.Visibility = Visibility.Visible;
                isReady = true;
            });

            bool isFirstTime = true;
            do
            {
                if (isFirstTime)
                {
                    PlayerName = scan.GetString(baseB, [0x10, 0xA8]).Replace("\u0000", "");
                    playerManager = new PlayerStatsManager(PlayerName);
                    LastBoss = playerManager.PlayerStats.LastBoss;
                    SendPlayerStats();
                }

                var death = scan.Get(baseB, [0x98]);
                var location = scan.Get(baseBS, [0x10, 0x8, 0x68, 0x8, 0xF44]);

                if (death > playerManager.PlayerStats.TotalDeath)
                {                    
                    var name = scan.GetString(baseB, [0x10, 0xA8]).Replace("\u0000", "");

                    if (Location.locations.TryGetValue(location, out string bossName) && !isFirstTime)
                    {
                        if (playerManager.PlayerStats.Bosses.ContainsKey(bossName))
                        {
                            playerManager.PlayerStats.Bosses[bossName] += 1;
                            LastBoss = $"{bossName}: {playerManager.PlayerStats.Bosses[bossName]}";
                            PopulateBossesList();
                        }
                    }

                    playerManager.SavePlayerStats();
                    SendPlayerStats();
                    isFirstTime = false;
                }

                DeathCount = death;
                CurrentLocation = Location.locations.GetValueOrDefault(location) ?? "Unknown Location";

                Thread.Sleep(500);
            } while (true);
        }
        private IntPtr GetBaseAddress(Scanner scan, string pattern, string name)
        {
            var results = scan.Scan(pattern);
            var address = scan.Read(results[0]) ?? IntPtr.Zero;

            if (address == IntPtr.Zero)
            {
                // Make AlertManager (HandleError)
                Dispatcher.Invoke(() => { MessageBox.Show($"{name} is null"); });
                return IntPtr.Zero;
            }

            return address;
        }

        // Timer methods
        private void AttachToGameWindow()
        {
            gameWindowHandle = gameProcess.MainWindowHandle;
            if (gameWindowHandle == IntPtr.Zero)
            {
                MessageBox.Show("Game window handle is invalid!");
                return;
            }

            UpdateOverlayPosition();
            StartPositionUpdateTimer();
        }
        private void StartPositionUpdateTimer()
        {
            positionUpdateTimer = new DispatcherTimer
            {
                Interval = TimeSpan.FromMilliseconds(500) //0.5 s;
            };
            positionUpdateTimer.Tick += (s, e) => UpdateOverlayPosition();
            positionUpdateTimer.Start();
        }
        private void UpdateOverlayPosition()
        {
            if (gameWindowHandle == IntPtr.Zero)
                return;

            if (GetWindowRect(gameWindowHandle, out RECT rect))
            {
                this.Left = rect.Right - this.Width;
                this.Top = rect.Top + 40;
                this.Height = rect.Bottom - rect.Top;
            }
        }
        private void PopulateBossesList()
        {
            List<string> items = playerManager.GetBossItems();

            pagedView = CollectionViewSource.GetDefaultView(items);
            pagedView.Filter = PageFilter;

            Dispatcher.Invoke(() =>
            {
                bossesListBox.ItemsSource = pagedView;
                pagedView.Refresh();

                int totalPages = (int)Math.Ceiling((double)items.Count / itemsPerPage);
                pageLabel.Content = $"<-- Page: {currentPage + 1}/{totalPages} -->";
            });
        }

        // Paging methods
        private bool PageFilter(object item)
        {
            List<string> items = playerManager.GetBossItems();

            int index = items.IndexOf(item as string);
            return index >= currentPage * itemsPerPage && index < (currentPage + 1) * itemsPerPage;
        }
        private void MoveToPage(int page)
        {
            List<string> items = playerManager.GetBossItems();

            int totalPages = (int)Math.Ceiling((double)items.Count / itemsPerPage);

            if (page < 0 || page >= totalPages)
                return;

            currentPage = page;
            pagedView.Refresh();

            Dispatcher.Invoke(() =>
            {
                pageLabel.Content = $"<-- Page: {currentPage + 1}/{totalPages} -->";
            });
        }

        // Server method
        private void StartServer()
        {
            Server.shared.Start();

            Dispatcher.Invoke(() => serverStatusLabel.Content = "Status: Server Started");

            Server.shared.OnClientConnected += () =>
            {
                // Green
                Dispatcher.Invoke(() => serverStatusLabel.Content = "Status: Client Connected");
            };

            Server.shared.OnClientDisconnected += () =>
            {
                // Red
                Dispatcher.Invoke(() => serverStatusLabel.Content = "Status: Client Disconnected");
            };
        }
        private void SendPlayerStats()
        {
            var data = new
            {
                PlayerName = PlayerName,
                TotalDeaths = playerManager.PlayerStats.TotalDeath,
                BossDeaths = playerManager.PlayerStats.Bosses
            };

            Server.shared.SendJson(data);
        }
    }
}