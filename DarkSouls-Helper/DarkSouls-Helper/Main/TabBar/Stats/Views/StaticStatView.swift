//
//  StaticStatView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 05.04.2025.
//

import Foundation
import UIKit

final public class StaticStatView: UIView {

    var statName: String? {
        didSet {
            guard let name = statName else { return }
            titleLabel.text = name
        }
    }
    
    var statValue: Int? {
        didSet {
            guard let value = statValue else { return }
            numberLabel.text = "\(value)"
        }
    }
    
    var statImage: UIImage? {
        didSet {
            guard let image = statImage else { return }
            statImageView.image = image
        }
    }
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 0
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var statImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.text = "SomeStat"
        view.font = AppFont.View.title
        view.textColor = .white
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var numberLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.text = "99"
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
    
    private var stackTopConstraint: NSLayoutConstraint?
    private var stackLeftConstraint: NSLayoutConstraint?
    private var stackRightConstraint: NSLayoutConstraint?
    private var stackBottomConstraint: NSLayoutConstraint?
    
    private func setup() {
        backgroundColor = .clear
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(statImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            statImageView.heightAnchor.constraint(equalToConstant: 24),
            statImageView.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
}
