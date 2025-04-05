//
//  CharacterClassView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 04.04.2025.
//

import Foundation
import UIKit

final public class CharacterClassView: UIView {

    var `class`: CharacterClass? {
        didSet {
            configure()
        }
    }
    
    var isSelected: Bool? {
        didSet {
            guard let isSelected = isSelected else { return }
            backgroundView.isHidden = !isSelected
        }
    }
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        view.alpha = 0.2
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var classFrameImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.classFrame
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.text = "SomeClass"
        view.font = AppFont.View.title
        view.textColor = AppColor.Text.brown
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
        
        addSubview(backgroundView)
        addSubview(classFrameImageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            classFrameImageView.topAnchor.constraint(equalTo: topAnchor),
            classFrameImageView.leftAnchor.constraint(equalTo: leftAnchor),
            classFrameImageView.rightAnchor.constraint(equalTo: rightAnchor),
            classFrameImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func configure() {
        guard let `class` = `class` else { return }
        titleLabel.text = `class`.title
    }
}
