//
//  CharacterClassView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 03.04.2025.
//

import Foundation
import UIKit
import Combine

protocol ScrollViewDelegate: AnyObject {
    func didSelected()
}

extension ScrollViewDelegate {
    func didSelected() {}
}

final public class ScrollView: UIView {

    weak var delegate: ScrollViewDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    private var stackTopConstraint: NSLayoutConstraint?
    private var stackLeftConstraint: NSLayoutConstraint?
    private var stackRightConstraint: NSLayoutConstraint?
    private var stackBottomConstraint: NSLayoutConstraint?
    
    private var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.scroll
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 0
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        
        addSubview(backgroundImageView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        stackTopConstraint = stackView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor)
        stackLeftConstraint = stackView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor)
        stackRightConstraint = stackView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor)
        stackBottomConstraint = stackView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            stackTopConstraint!,
            stackLeftConstraint!,
            stackRightConstraint!,
            stackBottomConstraint!
        ])
        
        addClasses()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        stackTopConstraint?.constant = backgroundImageView.bounds.height * 0.13
        stackLeftConstraint?.constant = backgroundImageView.bounds.width * 0.15
        stackRightConstraint?.constant = -backgroundImageView.bounds.width * 0.15
        stackBottomConstraint?.constant = -backgroundImageView.bounds.height * 0.13
    }
    
    private func addClasses() {
        StatsManager.shared.$selectedClass
        .receive(on: DispatchQueue.main)
        .sink { [weak self] selectedGameClass in
            guard let self = self else { return }
            
            self.stackView.arrangedSubviews.forEach { subview in
                subview.removeFromSuperview()
            }
            
            StatsManager.shared.classes.forEach { gameClass in
                let classView = CharacterClassView()
                classView.class = gameClass
                classView.isUserInteractionEnabled = true
                
                if gameClass.title.lowercased() == selectedGameClass?.title.lowercased() {
                    classView.isSelected = true
                }
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.classTapped(_:)))
                classView.addGestureRecognizer(tapGesture)
                
                self.stackView.addArrangedSubview(classView)
            }
        }
        .store(in: &cancellables)
    }
    
    @objc
    private func classTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedClassView = sender.view as? CharacterClassView,
              let characterClass = tappedClassView.class else { return }
        
        print("Tap")
        StatsManager.shared.selectedClass = characterClass
        delegate?.didSelected()
    }
}
