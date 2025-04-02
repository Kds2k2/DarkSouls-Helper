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
    
    init() {
        rootViewController = UITabBarController()
        rootViewController.setValue(CustomTabBar(), forKey: "tabBar")
        
        //rootViewController.tabBar.backgroundColor = .white
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
}
