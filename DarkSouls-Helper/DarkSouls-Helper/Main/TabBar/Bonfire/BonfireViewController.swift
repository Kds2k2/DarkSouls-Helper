//
//  BonfireViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit
import Combine

class BonfireViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    
    var deathCount: Int = 0 {
        didSet {
            deathLabel.text = "\(deathCount)"
        }
    }
    
    var onEnd: () -> () = {}
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.backgroundSlice
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var frameImageView: FrameView = {
        let view = FrameView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bonfireImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.bigBonfire
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var skullImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.skull
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var humanityImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.humanity
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var deathLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.text = "0"
        view.font = AppFont.View.number
        view.textColor = .white
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.background
        
        view.addSubview(backgroundImageView)
        view.addSubview(frameImageView)
        view.addSubview(bonfireImageView)

        view.addSubview(skullImageView)
        view.addSubview(humanityImageView)
        view.addSubview(deathLabel)
        
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
            
            humanityImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            humanityImageView.leftAnchor.constraint(equalTo: frameImageView.leftAnchor, constant: 30),
            humanityImageView.heightAnchor.constraint(equalToConstant: 64),
            humanityImageView.widthAnchor.constraint(equalToConstant: 64),
            
            skullImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            skullImageView.rightAnchor.constraint(equalTo: frameImageView.rightAnchor, constant: -30),
            skullImageView.heightAnchor.constraint(equalToConstant: 64),
            skullImageView.widthAnchor.constraint(equalToConstant: 64),
            
            deathLabel.centerYAnchor.constraint(equalTo: skullImageView.centerYAnchor),
            deathLabel.rightAnchor.constraint(equalTo: skullImageView.leftAnchor, constant: -12),
        ])
        
        binding()
        addGesture()
    }
    
    private func binding() {
        PlayerManager.shared.$player
            .receive(on: DispatchQueue.main)
            .sink { [weak self] player in
                guard let self = self, let player = player else { return }
                self.deathCount = player.TotalDeaths
            }
            .store(in: &cancellables)
    }
    
    private func addGesture() {
        let bonfireTap = UITapGestureRecognizer(target: self, action: #selector(bonfireTapped))
        bonfireImageView.addGestureRecognizer(bonfireTap)

        let humanityTap = UITapGestureRecognizer(target: self, action: #selector(humanityTapped))
        humanityImageView.addGestureRecognizer(humanityTap)
    }
    
    @objc
    private func bonfireTapped() {
        print("Bonfire tapped!")
        deathCount += 1
    }

    @objc
    private func humanityTapped() {
        print("Humanity tapped!")
        deathCount = 0
    }
    
    private func didButtonTap() {
        onEnd()
    }
}
