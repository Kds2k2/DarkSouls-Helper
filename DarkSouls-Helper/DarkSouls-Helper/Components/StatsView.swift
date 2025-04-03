//
//  StatsView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 03.04.2025.
//

import Foundation
import UIKit

final public class StatsView: UIView {

    private var stackTopConstraint: NSLayoutConstraint?
    private var stackLeftConstraint: NSLayoutConstraint?
    private var stackRightConstraint: NSLayoutConstraint?
    private var stackBottomConstraint: NSLayoutConstraint?
    
    private var frameImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.statsFrame
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 0
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var separatorView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.statSeparator
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
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
        
        addSubview(frameImageView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            frameImageView.topAnchor.constraint(equalTo: topAnchor),
            frameImageView.leftAnchor.constraint(equalTo: leftAnchor),
            frameImageView.rightAnchor.constraint(equalTo: rightAnchor),
            frameImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        stackTopConstraint = stackView.topAnchor.constraint(equalTo: frameImageView.topAnchor)
        stackLeftConstraint = stackView.leftAnchor.constraint(equalTo: frameImageView.leftAnchor)
        stackRightConstraint = stackView.rightAnchor.constraint(equalTo: frameImageView.rightAnchor)
        stackBottomConstraint = stackView.bottomAnchor.constraint(equalTo: frameImageView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            stackTopConstraint!,
            stackLeftConstraint!,
            stackRightConstraint!,
            stackBottomConstraint!
        ])
        
        let souls = StatView()
        souls.statImage = UIImage(named: "souls")

        let level = StatView()
        level.statImage = UIImage(named: "level")
        
        let rSouls = StatView()
        rSouls.statImage = UIImage(named: "souls")
        
        stackView.addArrangedSubview(level)
        stackView.addArrangedSubview(souls)
        stackView.addArrangedSubview(rSouls)
        stackView.addArrangedSubview(separatorView)
        
        for i in 1...8 {
            let cview = StatView()
            cview.statImage = UIImage(named: "stat\(i)")
            stackView.addArrangedSubview(cview)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        stackTopConstraint?.constant = frameImageView.bounds.height * 0.1
        stackLeftConstraint?.constant = frameImageView.bounds.width * 0.176
        stackRightConstraint?.constant = -frameImageView.bounds.width * 0.176
        stackBottomConstraint?.constant = -frameImageView.bounds.height * 0.1
    }
}
