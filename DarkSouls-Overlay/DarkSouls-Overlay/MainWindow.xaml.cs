using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.Json;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace DarkSouls_Overlay
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
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

        // Game Process
        private Process gameProcess;

        // Player Variables
        private PlayerStats playerStats;

        // Property for Player Name Label
        private string _playerName;
        public string PlayerName
        {
            get => _playerName;
            set
            {
                _playerName = value;
                Dispatcher.Invoke(() =>
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
                playerStats.TotalDeath = _deathCount;

                Dispatcher.Invoke(() =>
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
                Dispatcher.Invoke(() =>
                {
                    locationLabel.Content = _currentLocation ?? "Unknown Location";
                });
            }
        }

        private string _lastBoss;
        public string LastBoss
        {
            get => _lastBoss;
            set
            {
                _lastBoss = value;
                playerStats.LastBoss = _lastBoss ?? "Unknown";
                Dispatcher.Invoke(() =>
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
                            lastBossLabel.Visibility = Visibility.Collapsed;
                        }
                        else if (bossesListBox.Visibility == Visibility.Visible)
                        {
                            bossesListBox.Visibility = Visibility.Collapsed;
                            lastBossLabel.Visibility = Visibility.Visible;
                        }
                    });
                }
            }

            return CallNextHookEx(_hookID, nCode, wParam, lParam);
        }

        // Scanner method
        private void RunGameScanner()
        {
            Scanner scan = new Scanner(gameProcess);
            Dispatcher.Invoke(() => loadingLabel.Content = "Loading BaseB"); //0%

            // BaseB
            var resultsB = scan.Scan(Base.patternB);
            var getB = resultsB[0];
            var baseB = scan.Read(getB) ?? IntPtr.Zero;

            if (baseB == IntPtr.Zero)
            {
                Dispatcher.Invoke(() => MessageBox.Show("BaseB is null"));
                return;
            }
            Dispatcher.Invoke(() => progressBar.Value += 25);
            Dispatcher.Invoke(() => loadingLabel.Content = "Loading BaseX"); //25%

            // BaseX
            var resultsX = scan.Scan(Base.patternX);
            var getX = resultsX[0];
            var baseX = scan.Read(getX) ?? IntPtr.Zero;

            if (baseX == IntPtr.Zero)
            {
                Dispatcher.Invoke(() => MessageBox.Show("BaseX is null"));
                return;
            }
            Dispatcher.Invoke(() => progressBar.Value += 25);
            Dispatcher.Invoke(() => loadingLabel.Content = "Loading BasePF"); //50%

            // BasePF
            var resultsPF = scan.Scan(Base.patternPF);
            var getPF = resultsPF[0];
            var basePF = scan.Read(getPF) ?? IntPtr.Zero;

            if (basePF == IntPtr.Zero)
            {
                Dispatcher.Invoke(() => MessageBox.Show("BasePF is null"));
                return;
            }
            Dispatcher.Invoke(() => progressBar.Value += 25);
            Dispatcher.Invoke(() => loadingLabel.Content = "Loading BaseBS"); //75%

            // BaseBS
            var resultsBS = scan.Scan(Base.patternBS);
            var getBS = resultsBS[0];
            var baseBS = scan.Read(getBS) ?? IntPtr.Zero;

            if (baseBS == IntPtr.Zero)
            {
                Dispatcher.Invoke(() => MessageBox.Show("BaseBS is null"));
                return;
            }
            Dispatcher.Invoke(() => progressBar.Value += 25);
            Dispatcher.Invoke(() => loadingLabel.Content = "Done.");         //100%

            // Change UI
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
                    playerStats = LoadPlayerStats($"{PlayerName}.json");
                    LastBoss = playerStats.LastBoss;
                }

                var death = scan.Get(baseB, [0x98]);
                var location = scan.Get(baseBS, [0x10, 0x8, 0x68, 0x8, 0xF44]);

                if (death > playerStats.TotalDeath)
                {                    
                    var name = scan.GetString(baseB, [0x10, 0xA8]).Replace("\u0000", "");

                    if (Location.locations.TryGetValue(location, out string bossName) && !isFirstTime)
                    {
                        if (playerStats.Bosses.ContainsKey(bossName))
                        {
                            playerStats.Bosses[bossName] += 1;
                            LastBoss = $"{bossName}: {playerStats.Bosses[bossName]}";
                            PopulateBossesList();
                        }
                    }

                    SavePlayerStats(playerStats, $"{name}.json");
                    SendPlayerStats();
                    isFirstTime = false;
                }

                DeathCount = death;
                CurrentLocation = Location.locations.GetValueOrDefault(location) ?? "Unknown Location";

                Thread.Sleep(500);
            } while (true);
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
                this.Left = rect.Left + 40;
                this.Top = rect.Top + 40;
                this.Height = rect.Bottom - this.Top;
            }
        }

        // Player methods
        public void SavePlayerStats(PlayerStats stats, string filePath)
        {
            string json = JsonSerializer.Serialize(stats, new JsonSerializerOptions { WriteIndented = true });
            File.WriteAllText(filePath, json);
        }
        public PlayerStats LoadPlayerStats(string filePath)
        {
            if (!File.Exists(filePath))
            {
                return new PlayerStats {
                    Nickname = PlayerName,
                    LastBoss = "No last boss",
                    TotalDeath = DeathCount,
                    Bosses = new Dictionary<string, int>
                    {
                        { "Gwyndolin", 0 },
                        { "Non Invadeable Area", 0 },
                        { "Gaping Dragon", 0 },
                        { "Gargoyles", 0 },
                        { "Crossbreed Priscilla", 0 },
                        { "Sif", 0 },
                        { "Pinwheel", 0 },
                        { "Gravelord Nito", 0 },
                        { "Quelaag", 0 },
                        { "Bed of Chaos", 0 },
                        { "Iron Golem", 0 },
                        { "O&S", 0 },
                        { "Four Kings", 0 },
                        { "Seath", 0 },
                        { "Gwyn", 0 },
                        { "Asylum Demon", 0 },
                        { "Taurus Demon", 0 },
                        { "Capra Demon", 0 },
                        { "Moonlight Butterfly", 0 },
                        { "Sanctuary Guardian", 0 },
                        { "Artorias", 0 },
                        { "Manus", 0 },
                        { "Kalameet", 0 },
                        { "Demon Firesage", 0 },
                        { "Ceaseless Discharge", 0 },
                        { "Centipede Demon", 0 },
                        { "Stray Demon", 0 },
                    }
                };
            }

            string json = File.ReadAllText(filePath);
            return JsonSerializer.Deserialize<PlayerStats>(json);
        }
        private void PopulateBossesList()
        {
            Dispatcher.Invoke(() =>
            {
                bossesListBox.Items.Clear();
                foreach (var boss in playerStats.Bosses)
                {
                    bossesListBox.Items.Add($"{boss.Key}: {boss.Value}");
                }

                bossesListBox.Height = bossesListBox.Items.Count * 30;
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
                TotalDeaths = playerStats.TotalDeath,
                BossDeaths = playerStats.Bosses
            };

            Server.shared.SendJson(data);
        }
    }
}