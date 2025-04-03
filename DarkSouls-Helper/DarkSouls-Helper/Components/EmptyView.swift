//
//  EmptyView.swift
//  Project_PomodoroTimer
//
//  Created by Dmitro Kryzhanovsky on 16.03.2025.
//

import UIKit

final public class EmptyView: UIView {

    public var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }

    private var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.goldBackground
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.font = AppFont.View.title
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -15),
        ])
    }
}
