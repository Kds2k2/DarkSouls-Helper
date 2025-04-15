using Test_WebSocket;

namespace DarkSouls_Server
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Server.shared.Start();

            Console.WriteLine("Press Enter to send message.");
            Console.ReadLine();
            Server.shared.Send("SomeMessage");

            Console.ReadKey();
            Server.shared.Close();
        }
    }
}
