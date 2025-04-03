//
//  StatsViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

class StatsViewController: UIViewController {

    var onEnd: () -> () = {}
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.backgroundSlice
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statsImageView: StatsView = {
        let view = StatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.background
        
        view.addSubview(backgroundImageView)
        view.addSubview(statsImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -15),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -15),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
            
            statsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            statsImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            statsImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            statsImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
        ])
    }
    
    private func didButtonTap() {
        onEnd()
    }
}
