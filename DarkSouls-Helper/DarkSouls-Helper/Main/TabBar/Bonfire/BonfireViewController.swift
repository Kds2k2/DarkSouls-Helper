//
//  BonfireViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

class BonfireViewController: UIViewController {

    var onEnd: () -> () = {}
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.backgroundSlice
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bonfireImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.bigBonfire
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var frameImageView: FrameView = {
        let view = FrameView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.background
        
        view.addSubview(backgroundImageView)
        view.addSubview(frameImageView)
        view.addSubview(bonfireImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -15),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -15),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
            
            frameImageView.topAnchor.constraint(equalTo: view.topAnchor),
            frameImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            frameImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            frameImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bonfireImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bonfireImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bonfireImageView.heightAnchor.constraint(equalToConstant: 230),
            
        ])
    }
    
    private func didButtonTap() {
        onEnd()
    }
}
