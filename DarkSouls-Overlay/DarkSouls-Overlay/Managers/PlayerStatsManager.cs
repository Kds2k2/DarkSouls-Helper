using System.IO;
using System.Text.Json;

namespace DarkSouls_Overlay.Managers
{
    public class PlayerStatsManager
    {
        // Properties
        private string Path { get; set; }
        private string PlayerName { get; set; }
        public PlayerStats PlayerStats { get; set; }

        // Constructor
        public PlayerStatsManager(string playerName)
        {
            PlayerName = playerName;
            Path = $"{playerName}.json";
            PlayerStats = LoadPlayerStats();
        }

        // Methods
        public PlayerStats LoadPlayerStats()
        {
            if (!File.Exists(Path))
            {
                return new PlayerStats
                {
                    Nickname = PlayerName,
                    LastBoss = "No last boss",
                    TotalDeath = 0,
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

            string json = File.ReadAllText(Path);
            return JsonSerializer.Deserialize<PlayerStats>(json);
        }
        public void SavePlayerStats()
        {
            string json = JsonSerializer.Serialize(PlayerStats, new JsonSerializerOptions { WriteIndented = true });
            File.WriteAllText(Path, json);
        }
        public List<string> GetBossItems()
        {
            return PlayerStats.Bosses.Select(boss => $"{boss.Key}: {boss.Value}").ToList();
        }
    }

    public class PlayerStats
    {
        public string Nickname { get; set; }
        public int TotalDeath { get; set; }
        public string LastBoss { get; set; }
        public Dictionary<string, int> Bosses { get; set; } = new Dictionary<string, int>();
    }
}