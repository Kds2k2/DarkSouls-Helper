//
//  WebsocketManager.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 24.04.2025.
//

import Foundation

protocol WebsocketManagerDelegate: AnyObject {
    func websocketDidReceiveMessage(_ message: String)
    func websocketDidDisconnect(error: Error?)
    func websocketDidConnect()
}

class WebsocketManager {
    private var webSocketTask: URLSessionWebSocketTask?
    private var url: URL
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 10
    private let reconnectDelay: TimeInterval = 3.0
    weak var delegate: WebsocketManagerDelegate?

    init(url: URL) {
        self.url = url
    }

    func connect() {
        // Cancel any existing connection
        webSocketTask?.cancel(with: .goingAway, reason: nil)

        let request = URLRequest(url: url)
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: request)
        webSocketTask?.resume()

        delegate?.websocketDidConnect()
        listen()
    }

    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let message):
                self.reconnectAttempts = 0

                switch message {
                case .string(let text):
                    self.delegate?.websocketDidReceiveMessage(text)
                case .data(let data):
                    self.delegate?.websocketDidReceiveMessage("Binary data received: \(data.count) bytes")
                @unknown default:
                    break
                }

                self.listen()

            case .failure(let error):
                self.delegate?.websocketDidDisconnect(error: error)
                self.reconnect()
            }
        }
    }

    private func reconnect() {
        guard reconnectAttempts < maxReconnectAttempts else {
            print("🚫 Max reconnect attempts reached")
            return
        }

        reconnectAttempts += 1
        print("🔁 Reconnecting in \(reconnectDelay)s... (Attempt \(reconnectAttempts))")

        DispatchQueue.main.asyncAfter(deadline: .now() + reconnectDelay) {
            self.connect()
        }
    }

    func send(text: String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("❌ Failed to send message: \(error)")
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    deinit {
        disconnect()
    }
}
