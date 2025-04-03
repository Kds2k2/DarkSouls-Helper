//
//  StatView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 03.04.2025.
//
import Foundation
import UIKit

final public class StatView: UIView {

    var statImage: UIImage? {
        didSet {
            statImageView.image = statImage
        }
    }
    
    private var statImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.statsFrame
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private var stackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.distribution = .fillEqually
//        view.alignment = .fill
//        view.spacing = 5
//        view.backgroundColor = .clear
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
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
        
        addSubview(statImageView)
        addSubview(titleLabel)
        addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            statImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            statImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            statImageView.heightAnchor.constraint(equalToConstant: 24),
            statImageView.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leftAnchor.constraint(equalTo: statImageView.rightAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
        ])
    }
}
