//
//  EmptyNavigationView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 05.04.2025.
//

import UIKit
import Combine

final public class EmptyNavigationView: UIView {
    private var stackBottomConstraint: NSLayoutConstraint?
    
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
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: -5),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: 5),
            separatorView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
