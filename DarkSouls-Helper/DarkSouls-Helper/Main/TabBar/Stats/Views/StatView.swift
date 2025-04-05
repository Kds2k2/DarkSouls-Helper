//
//  StatView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 03.04.2025.
//
import Foundation
import UIKit

public protocol StatViewDelegate: AnyObject {
    func increase()
    func decrease()
}

extension StatViewDelegate {
    func increase() {}
    func decrease() {}
}

final public class StatView: UIView {

    public weak var delegate: StatViewDelegate?
    
    private var increaseTimer: Timer?
    private var decreaseTimer: Timer?
    
    public var statName: String? {
        didSet {
            guard let statName = statName else { return }
            titleLabel.text = statName
        }
    }
    
    private(set) var currentStatValue: Int? {
        didSet {
            if currentStatValue != statValue {
                numberLabel.textColor = .systemBlue
            } else {
                numberLabel.textColor = .white
            }
            
            guard let currentStatValue = currentStatValue else { return }
            numberLabel.text = currentStatValue.description
        }
    }
    
    public var statValue: Int? {
        didSet {
            guard let statValue = statValue else { return }
            currentStatValue = statValue
        }
    }
    
    public var statImage: UIImage? {
        didSet {
            guard let statImage = statImage else { return }
            statImageView.image = statImage
        }
    }
    
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 5
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
    
    private var leftChevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.left")
        view.backgroundColor = .clear
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var rightChevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.right")
        view.backgroundColor = .clear
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
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
        stackView.addArrangedSubview(leftChevronImageView)
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(rightChevronImageView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            statImageView.heightAnchor.constraint(equalToConstant: 24),
            statImageView.widthAnchor.constraint(equalToConstant: 24),
            
            rightChevronImageView.heightAnchor.constraint(equalToConstant: 24),
            rightChevronImageView.widthAnchor.constraint(equalToConstant: 24),
            
            leftChevronImageView.heightAnchor.constraint(equalToConstant: 24),
            leftChevronImageView.widthAnchor.constraint(equalToConstant: 24),
            
            numberLabel.widthAnchor.constraint(equalToConstant: 24),
        ])
        
        addGesture()
    }
    
    private func addGesture() {
        let increaseTap = UITapGestureRecognizer(target: self, action: #selector(increaseTapped))
        rightChevronImageView.addGestureRecognizer(increaseTap)
        
        let decreaseTap = UITapGestureRecognizer(target: self, action: #selector(decreaseTapped))
        leftChevronImageView.addGestureRecognizer(decreaseTap)

        let increaseLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleIncreaseLongPress(_:)))
        rightChevronImageView.addGestureRecognizer(increaseLongPress)

        let decreaseLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleDecreaseLongPress(_:)))
        leftChevronImageView.addGestureRecognizer(decreaseLongPress)
    }

    @objc
    private func increaseTapped() {
        currentStatValue! += 1
        delegate?.increase()
    }

    @objc
    private func decreaseTapped() {
        currentStatValue! -= 1
        delegate?.decrease()
    }
    
    @objc
    private func handleIncreaseLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            startIncreasing()
        case .ended, .cancelled, .failed:
            stopIncreasing()
        default:
            break
        }
    }

    @objc
    private func handleDecreaseLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            startDecreasing()
        case .ended, .cancelled, .failed:
            stopDecreasing()
        default:
            break
        }
    }

    private func startIncreasing() {
        stopIncreasing()
        increaseTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.increaseTapped()
        }
    }

    private func stopIncreasing() {
        increaseTimer?.invalidate()
        increaseTimer = nil
    }

    private func startDecreasing() {
        stopDecreasing()
        decreaseTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.decreaseTapped()
        }
    }

    private func stopDecreasing() {
        decreaseTimer?.invalidate()
        decreaseTimer = nil
    }
}
