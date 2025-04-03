//
//  PathViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

class PathViewController: UIViewController {

    var onEnd: () -> () = {}
    
    private lazy var emptyImageView: EmptyView = {
        let view = EmptyView()
        view.titleText = "Not available yet."
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.background
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.background
        
        view.addSubview(backgroundImageView)
        view.addSubview(emptyImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            emptyImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func didButtonTap() {
        onEnd()
    }
}
