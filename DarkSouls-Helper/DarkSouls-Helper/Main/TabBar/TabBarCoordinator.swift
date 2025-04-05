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
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundImage = AppImage.TabBar.background
        appearance.backgroundImageContentMode  = .scaleAspectFill
        
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
}
