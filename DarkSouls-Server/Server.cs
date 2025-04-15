using Fleck;

namespace Test_WebSocket
{
    internal class Server
    {
        private const string location = "ws://0.0.0.0:8181";

        public static Server shared = new Server();
        private WebSocketServer server;
        private List<IWebSocketConnection> connections = new List<IWebSocketConnection>();

        private Server() { }

        public void Start() {
            //Initialize server.
            server = new WebSocketServer(location);

            //Start Server.
            server.Start(config =>
            {
                config.OnOpen = () => {
                    Console.WriteLine("Server open.");
                    connections.Add(config);
                };

                config.OnMessage = message => {
                    Console.WriteLine($"Message: {message}");
                };

                config.OnClose = () => {
                    Console.WriteLine("Server closed.");
                };
            });
        }

        public void Send(string message) {
            foreach (var connection in connections) { 
                connection.Send(message);
            }
        }

        public void Close() { 
            server.Dispose();
        }
    }
}
