//
//  CharacterCoordinator.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//
import UIKit

final class CharacterCoordinator: Coordinator {

    var rootViewController = UINavigationController()
    var onEnd: () -> () = {}
    
    lazy var characterViewController: CharacterViewController = {
        let vc = CharacterViewController()
        vc.onEnd = { [weak self] in
            self?.onEnd()
        }
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([characterViewController], animated: false)
    }
}
