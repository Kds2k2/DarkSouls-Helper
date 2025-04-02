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
        
        if let existed = UserDefaultsManager.shared.isCharacterExisted, existed {
            let tabBarCoordinator = TabBarCoordinator()
            tabBarCoordinator.start()
            self.childCoordinators = [tabBarCoordinator]
            window.rootViewController = tabBarCoordinator.rootViewController
        } else {
            let characterCoordinator = CharacterCoordinator()
            characterCoordinator.start()
            characterCoordinator.onEnd = { [weak self] in
                DispatchQueue.main.async {
                    UserDefaultsManager.shared.isCharacterExisted = true
                    self?.goToTabs()
                }
            }
            self.childCoordinators = [characterCoordinator]
            window.rootViewController = characterCoordinator.rootViewController
        }
    }
    
    private func goToTabs() {
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.start()
        self.childCoordinators = [tabBarCoordinator]
        window.rootViewController = tabBarCoordinator.rootViewController
        
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        window.layer.add(transition, forKey: kCATransition)
    }
}
