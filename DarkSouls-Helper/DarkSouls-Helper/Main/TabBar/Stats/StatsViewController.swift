//
//  StatsViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit
import Combine

class StatsViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    
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
    
    private lazy var classImageView: NavigationView = {
        let view = NavigationView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollImageView: ScrollView = {
        let view = ScrollView()
        view.isHidden = true
        view.alpha    = 0
        view.delegate = self
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var effectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.backgroundColor = .clear
        view.effect = .none
        view.isHidden = true
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColor.background
        
        view.addSubview(backgroundImageView)
        view.addSubview(statsImageView)
        view.addSubview(classImageView)
        view.addSubview(effectView)
        view.addSubview(scrollImageView)
        
        NSLayoutConstraint.activate([
            classImageView.topAnchor.constraint(equalTo: view.topAnchor),
            classImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            classImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            classImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -15),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -15),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
            
            statsImageView.topAnchor.constraint(equalTo: classImageView.bottomAnchor, constant: 20),
            statsImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            statsImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            statsImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            
            effectView.topAnchor.constraint(equalTo: view.topAnchor, constant: -15),
            effectView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -15),
            effectView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15),
            effectView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
            
            scrollImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.2),
            scrollImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.2),
        ])
        
        addGesture()
        StatsManager.shared.loadDefaultClass()
    }
    
    func addGesture() {
        let effectTap = UITapGestureRecognizer(target: self, action: #selector(hideCustomAlert))
        effectView.addGestureRecognizer(effectTap)
    }
    
    func showCustomAlert() {
        effectView.isHidden = false
        effectView.isUserInteractionEnabled = true
        scrollImageView.isHidden = false
        scrollImageView.isUserInteractionEnabled = true
        effectView.alpha = 0
        scrollImageView.alpha = 0
        
        let blurEffect = UIBlurEffect(style: .dark)
        effectView.effect = blurEffect

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.effectView.alpha = 1
            self?.scrollImageView.alpha = 1
        }
    }
    
    @objc
    func hideCustomAlert() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.effectView.alpha = 0
            self?.scrollImageView.alpha = 0
        }, completion: { [weak self] _ in
            self?.effectView.isHidden = true
            self?.effectView.isUserInteractionEnabled = false
            self?.effectView.effect = .none
            self?.scrollImageView.isHidden = true
            self?.scrollImageView.isUserInteractionEnabled = false
        })
    }
}

//MARK: - NavigationViewDelegate
extension StatsViewController: NavigationViewDelegate {
    func showCharacterMenu() {
        showCustomAlert()
    }
}

//MARK: - NavigationViewDelegate
extension StatsViewController: ScrollViewDelegate {
    func didSelected() {
        hideCustomAlert()
    }
}
