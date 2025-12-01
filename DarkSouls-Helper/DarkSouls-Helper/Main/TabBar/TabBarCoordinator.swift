//
//  TabBarCoordinator.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//
import UIKit

final class TabBarCoordinator: Coordinator {
    
    var rootViewController = UITabBarController()
    
    var childCoordinators = [Coordinator]()
    
    private var websocketManager: WebsocketManager?
    
    init() {
        rootViewController = UITabBarController()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(patternImage: AppImage.TabBar.background!)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.Text.gray,
            .font: AppFont.TabBar.title
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.Text.gold,
            .font: AppFont.TabBar.title
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes   = attributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
   
        let tabBar = CustomTabBar()
        tabBar.tintColor               = AppColor.Text.orange
        tabBar.standardAppearance      = appearance
        tabBar.scrollEdgeAppearance    = appearance
        
        rootViewController.setValue(tabBar, forKey: "tabBar")
        setupWebSocket()
        addCustomViewToTabBar()
    }
    
    func start() {
        let bonfireCoordinator = BonfireCoordinator()
        bonfireCoordinator.start()
        self.childCoordinators.append(bonfireCoordinator)
        
        let pathCoordinator = PathCoordinator()
        pathCoordinator.start()
        self.childCoordinators.append(pathCoordinator)
        
        let statsCoordinator = StatsCoordinator()
        statsCoordinator.start()
        self.childCoordinators.append(statsCoordinator)
        
        self.rootViewController.viewControllers = [pathCoordinator.rootViewController,
                                                   bonfireCoordinator.bonfireViewController,
                                                   statsCoordinator.rootViewController
                                                  ]
        self.rootViewController.selectedIndex = 1
    }
    
    func addCustomViewToTabBar() {
        let tabBar = rootViewController.tabBar

        let frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 40)
        let customView = SeparatorView(frame: frame)
        customView.center = CGPoint(x: tabBar.bounds.midX, y: tabBar.bounds.minY + 20)

        tabBar.addSubview(customView)
    }
    
    func setupWebSocket() {
        guard let url = URL(string: "ws://192.168.88.112:8181") else { return }

        websocketManager = WebsocketManager(url: url)
        websocketManager?.delegate = self
        websocketManager?.connect()
    }
}

extension TabBarCoordinator: WebsocketManagerDelegate {
    func websocketDidReceiveMessage(_ message: String) {
        if let jsonData = message.data(using: .utf8) {
            do {
                let player = try JSONDecoder().decode(Player.self, from: jsonData)
                PlayerManager.shared.player = player
            } catch {
                print("Decoding error: \(error)")
            }
        } else {
            print("📩 Received message: \(message)")
        }
    }

    func websocketDidDisconnect(error: Error?) {
        print("❌ WebSocket disconnected: \(error?.localizedDescription ?? "Unknown error")")
    }

    func websocketDidConnect() {
        print("✅ WebSocket connected")
    }
}
