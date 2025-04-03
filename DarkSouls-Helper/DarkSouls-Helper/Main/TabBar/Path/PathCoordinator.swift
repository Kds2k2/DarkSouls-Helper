//
//  PathCoordinator.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

final class PathCoordinator: Coordinator {
    
    var rootViewController = UINavigationController()
    
    lazy var pathViewController: PathViewController = {
        let vc = PathViewController()
        let item = UITabBarItem(title: "Path", image: AppImage.TabBar.pathUnselected, selectedImage: AppImage.TabBar.path)
        
        item.setTitleTextAttributes([
            .font: AppFont.TabBar.title,
            .foregroundColor: UIColor.gray
        ], for: .normal)

        item.setTitleTextAttributes([
            .font: AppFont.TabBar.title,
            .foregroundColor: UIColor.orange
        ], for: .selected)
        
        item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        
        vc.tabBarItem = item
        vc.tabBarItem.tag = 1
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([pathViewController], animated: false)
    }
}
