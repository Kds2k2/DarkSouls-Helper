//
//  FrameView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 03.04.2025.
//
import UIKit

final public class FrameView: UIView {

    private var topImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.separator
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var leftColumnImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.column
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var rightColumnImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = AppImage.View.column
        view.contentMode = .scaleToFill
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
        
        addSubview(topImageView)
        addSubview(leftColumnImageView)
        addSubview(rightColumnImageView)
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: topAnchor),
            topImageView.leftAnchor.constraint(equalTo: leftAnchor),
            topImageView.rightAnchor.constraint(equalTo: rightAnchor),
            topImageView.heightAnchor.constraint(equalToConstant: 40),
            
            leftColumnImageView.topAnchor.constraint(equalTo: topImageView.bottomAnchor),
            leftColumnImageView.leftAnchor.constraint(equalTo: leftAnchor),
            leftColumnImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            rightColumnImageView.topAnchor.constraint(equalTo: topImageView.bottomAnchor),
            rightColumnImageView.rightAnchor.constraint(equalTo: rightAnchor),
            rightColumnImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
