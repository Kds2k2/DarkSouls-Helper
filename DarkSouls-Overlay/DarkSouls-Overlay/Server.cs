using Fleck;
using System.Text.Json;

namespace DarkSouls_Overlay
{
    internal class Server
    {
        private const string location = "ws://0.0.0.0:8181";

        public static Server shared = new Server();
        private WebSocketServer server;
        private List<IWebSocketConnection> connections = new List<IWebSocketConnection>();

        // Events
        public event Action OnClientConnected;
        public event Action OnClientDisconnected;

        private Server() { }

        public void Start()
        {
            // Initialize server
            server = new WebSocketServer(location);

            // Start server
            server.Start(config =>
            {
                config.OnOpen = () =>
                {
                    Console.WriteLine("Client connected.");
                    connections.Add(config);
                    OnClientConnected?.Invoke();
                };

                config.OnClose = () =>
                {
                    Console.WriteLine("Client disconnected.");
                    connections.Remove(config);
                    OnClientDisconnected?.Invoke();
                };

                config.OnMessage = message =>
                {
                    Console.WriteLine($"Message: {message}");
                };
            });
        }
        public void Send(string message)
        {
            foreach (var connection in connections)
            {
                connection.Send(message);
            }
        }
        public void SendJson(object data)
        {
            string json = JsonSerializer.Serialize(data, new JsonSerializerOptions { WriteIndented = true });

            foreach (var connection in connections)
            {
                connection.Send(json);
            }
        }
        public void Close()
        {
            if (server != null) 
            {
                server.Dispose();
            }
        }
    }
}