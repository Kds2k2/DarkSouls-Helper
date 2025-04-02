//
//  BonfireCoordinator.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//
import UIKit

final class BonfireCoordinator: Coordinator {
    
    var rootViewController = UINavigationController()
    
    lazy var bonfireViewController: BonfireViewController = {
        let vc = BonfireViewController()
        let item = UITabBarItem(title: "Bonfire", image: AppImage.TabBar.bonfireUnselected, selectedImage: AppImage.TabBar.bonfire)

        item.setTitleTextAttributes([
            .font: AppFont.TabBar.title,
            .foregroundColor: AppColor.titleUnselected
        ], for: .normal)

        item.setTitleTextAttributes([
            .font: AppFont.TabBar.title,
            .foregroundColor: AppColor.title
        ], for: .selected)
        
        vc.tabBarItem = item
        vc.tabBarItem.tag = 2
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([bonfireViewController], animated: false)
    }
}
