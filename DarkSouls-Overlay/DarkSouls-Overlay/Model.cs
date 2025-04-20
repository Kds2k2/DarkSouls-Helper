using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace DarkSouls_Overlay
{
    public static class Game
    {
        public static string processName = "DarkSoulsRemastered";
        public static string moduleName  = "DarkSoulsRemastered.exe";
    }

    public static class Base
    {
        public static string patternB  = "48 8B 05 ?? ?? ?? ?? 45 33 ED 48 8B F1 48 85 C0";
        public static string patternX  = "48 8B 05 ?? ?? ?? ?? 48 39 48 68 0F 94 C0 C3";
        public static string patternPF = "48 8B 0D ?? ?? ?? ?? 41 B8 01 00 00 00 44";
        public static string patternBS = "48 8B 0D ?? ?? ?? ?? 0F 28 CE E8 ?? ?? ?? ?? 8B 83 ?? ?? ?? ?";
    }

    public static class Location
    {
        public static Dictionary<int, string> locations = new Dictionary<int, string>
        {
            { -1, "Gwyndolin" },
            { -2, "Non Invadeable Area" },
            { -12, "Gaping Dragon" },
            { -13, "Gargoyles" },
            { -14, "Crossbreed Priscilla" },
            { -15, "Sif" },
            { -16, "Pinwheel" },
            { -17, "Gravelord Nito" },
            { -19, "Quelaag" },
            { -20, "Bed of Chaos" },
            { -21, "Iron Golem" },
            { -22, "O&S" },
            { -23, "Four Kings" },
            { -24, "Seath" },
            { -25, "Gwyn" },
            { -26, "Asylum Demon" },
            { -11010911, "Taurus Demon" },
            { -11010912, "Capra Demon" },
            { -11200910, "Moonlight Butterfly" },
            { -11210010, "Sanctuary Guardian" },
            { -11210011, "Artorias" },
            { -11210012, "Manus" },
            { -11210014, "Kalameet" },
            { -11410420, "Demon Firesage" },
            { -11410910, "Ceaseless Discharge" },
            { -11410911, "Centipede Demon" },
            { -11810910, "Stray Demon" },
        };

        public static Dictionary<string, int> bosses = new Dictionary<string, int>
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
        };
    }

    public class PlayerStats
    {
        public string Nickname { get; set; }
        public int TotalDeath { get; set; }
        public string LastBoss { get; set; }
        public Dictionary<string, int> Bosses { get; set; } = new Dictionary<string, int>();
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MEMORY_BASIC_INFORMATION
    {
        public IntPtr BaseAddress;
        public IntPtr AllocationBase;
        public uint AllocationProtect;
        public IntPtr RegionSize;
        public int State;
        public int Protect;
        public int Type;
    }
}
