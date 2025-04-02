//
//  StatsCoordinator.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

final class StatsCoordinator: Coordinator {
    
    var rootViewController = UINavigationController()
    
    lazy var statsViewController: StatsViewController = {
        let vc = StatsViewController()
        let item = UITabBarItem(title: "Stats", image: AppImage.TabBar.statsUnselected, selectedImage: AppImage.TabBar.stats)
        
        item.setTitleTextAttributes([
            .font: AppFont.TabBar.title,
            .foregroundColor: UIColor.gray
        ], for: .normal)

        item.setTitleTextAttributes([
            .font: AppFont.TabBar.title,
            .foregroundColor: UIColor.orange
        ], for: .selected)
        
        vc.tabBarItem = item
        vc.tabBarItem.tag = 3
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([statsViewController], animated: false)
    }
}
