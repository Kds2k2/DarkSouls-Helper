//
//  BonfireViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

class BonfireViewController: UIViewController {

    var onEnd: () -> () = {}
    
    private lazy var bonfireImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.bigBonfire
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.background
        view.addSubview(bonfireImageView)
        NSLayoutConstraint.activate([
            bonfireImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bonfireImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bonfireImageView.heightAnchor.constraint(equalToConstant: 230),
        ])
    }
    
    private func didButtonTap() {
        onEnd()
    }
}
