//
//  LocationViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 05.04.2025.
//

import UIKit

class LocationViewController: UIViewController {

    var location: Location? {
        didSet {
            configure()
        }
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.backgroundSlice
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyImageView: EmptyNavigationView = {
        let view = EmptyNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.text = "Some Location"
        view.font = AppFont.View.title
        view.textColor = .white
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.background
        
        view.addSubview(backgroundImageView)
        view.addSubview(emptyImageView)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -5),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -5),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 5),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5),
            
            emptyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -5),
            emptyImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            emptyImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    private func configure() {
        guard let location = location else { return }
        titleLabel.text = location.name
    }
}
