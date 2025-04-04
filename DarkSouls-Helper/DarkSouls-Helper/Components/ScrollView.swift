//
//  CharacterClassView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 03.04.2025.
//

import Foundation
import UIKit

protocol ScrollViewDelegate: AnyObject {
    func didSelected(_ characterClass: CharacterClass)
}

extension ScrollViewDelegate {
    func didSelected(_ characterClass: CharacterClass) {}
}

final public class ScrollView: UIView {

    weak var delegate: ScrollViewDelegate?
    private var classes = StatsManager.shared.loadClasses()
    public var selectedClass: CharacterClass? {
        didSet {
            addClasses()
        }
    }
    
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
        guard let classes = classes else { return }

        stackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        classes.forEach { `class` in
            let classView = CharacterClassView()
            classView.class = `class`
            classView.isUserInteractionEnabled = true
            
            if `class`.title.lowercased() == selectedClass?.title.lowercased() {
                classView.isSelected = true
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(classTapped(_:)))
            classView.addGestureRecognizer(tapGesture)
            
            stackView.addArrangedSubview(classView)
        }
    }
    
    @objc private func classTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedClassView = sender.view as? CharacterClassView,
              let characterClass = tappedClassView.class else { return }
        
        delegate?.didSelected(characterClass)
    }
}
