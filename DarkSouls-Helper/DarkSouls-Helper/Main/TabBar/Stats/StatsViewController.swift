//
//  StatsViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

class StatsViewController: UIViewController {

    var onEnd: () -> () = {}
    
    private lazy var button: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.title               = "Next"
        let action = UIAction { _ in self.didButtonTap() }
        let button = UIButton(configuration: configuration, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.background
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private func didButtonTap() {
        onEnd()
    }
}
