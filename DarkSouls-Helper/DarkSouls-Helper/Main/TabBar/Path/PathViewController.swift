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
        view.image = AppImage.View.backgroundSlice
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.background
        
        view.addSubview(backgroundImageView)
        view.addSubview(emptyImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -15),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -15),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
            
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
