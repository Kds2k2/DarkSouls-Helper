//
//  StatView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 03.04.2025.
//

import Foundation
import UIKit

final public class CharacterClassView: UIView {

    private var frameImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.statFrame
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.text = "Test"
        view.font = AppFont.View.title
        view.textColor = .white
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private var stackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.distribution = .fillEqually
//        view.alignment = .fill
//        view.spacing = 5
//        view.backgroundColor = .systemBlue
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        
        addSubview(frameImageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            frameImageView.topAnchor.constraint(equalTo: topAnchor),
            frameImageView.leftAnchor.constraint(equalTo: leftAnchor),
            frameImageView.rightAnchor.constraint(equalTo: rightAnchor),
            frameImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
