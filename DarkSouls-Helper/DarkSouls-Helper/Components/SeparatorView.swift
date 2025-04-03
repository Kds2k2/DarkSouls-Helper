//
//  SeparatorView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 03.04.2025.
//
import UIKit

final public class SeparatorView: UIView {

    private var backgroundView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.separator
        view.contentMode = .scaleAspectFill
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
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: -5),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: -5),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: 5),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
