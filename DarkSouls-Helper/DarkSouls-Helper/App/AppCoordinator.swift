//
//  AppCoordinator.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//
import UIKit

final class AppCoordinator: Coordinator {

    let window: UIWindow
    
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.start()
        self.childCoordinators = [tabBarCoordinator]
        window.rootViewController = tabBarCoordinator.rootViewController
    }
}
