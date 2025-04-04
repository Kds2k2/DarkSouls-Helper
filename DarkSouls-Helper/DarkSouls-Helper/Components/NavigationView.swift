//
//  NavigationView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 04.04.2025.
//

import UIKit

public protocol NavigationViewDelegate: AnyObject {
    func showCharacterMenu()
}

extension NavigationViewDelegate {
    func showCharacterMenu() {}
}

final public class NavigationView: UIView {

    weak var delegate: NavigationViewDelegate?
    private var stackBottomConstraint: NSLayoutConstraint?
    
    public var selectedClass: CharacterClass? {
        didSet {
            guard let selectedClass = selectedClass else { return }
            titleLabel.text = selectedClass.title
        }
    }
    
    private var backgroundView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.TabBar.background
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var separatorView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.bottomSeparator
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 15
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var classImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.classImage
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.text = "Some Class"
        view.font = AppFont.View.title
        view.textColor = .white
        view.textAlignment = .center
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
        
        addSubview(backgroundView)
        addSubview(separatorView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(classImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(UIView())
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: -5),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: 5),
            separatorView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 50),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 50),
            stackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: 15),
            
            classImageView.heightAnchor.constraint(equalToConstant: 64),
            classImageView.widthAnchor.constraint(equalToConstant: 64),
        ])
        
        addGesture()
    }
    
    private func addGesture() {
        let stackViewTap = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        stackView.addGestureRecognizer(stackViewTap)
    }
    
    @objc
    private func stackViewTapped() {
        delegate?.showCharacterMenu()
    }
}
