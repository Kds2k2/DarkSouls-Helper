//
//  StatsView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 03.04.2025.
//

import Foundation
import UIKit
import Combine

final public class StatsView: UIView {
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    //MARK: - StatsViews
    private var level: StaticStatView = {
        let view = StaticStatView()
        view.statName  = "Level"
        view.statImage = AppImage.Stats.level
        return view
    }()
    
    private var souls: StaticStatView = {
        let view = StaticStatView()
        view.statName = "Souls"
        view.statImage = AppImage.Stats.souls
        return view
    }()
    
    private var rSouls: StaticStatView = {
        let view = StaticStatView()
        view.statName = "Required Souls"
        view.statImage = AppImage.Stats.souls
        return view
    }()
    
    private var separatorView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.statSeparator
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    
    private var vitality: StatView = {
        let view = StatView()
        view.statName = "Vitality"
        view.statImage = AppImage.Stats.vitality
        return view
    }()
    
    private var attunement: StatView = {
        let view = StatView()
        view.statName = "Attunement"
        view.statImage = AppImage.Stats.attunement
        return view
    }()
    
    private var endurance: StatView = {
        let view = StatView()
        view.statName = "Endurance"
        view.statImage = AppImage.Stats.endurance
        return view
    }()
    
    private var strength: StatView = {
        let view = StatView()
        view.statName = "Strength"
        view.statImage = AppImage.Stats.strength
        return view
    }()
    
    private var dexterity: StatView = {
        let view = StatView()
        view.statName = "Dexterity"
        view.statImage = AppImage.Stats.dexterity
        return view
    }()
    
    private var resistance: StatView = {
        let view = StatView()
        view.statName = "Resistance"
        view.statImage = AppImage.Stats.resistance
        return view
    }()
    
    private var intelligence: StatView = {
        let view = StatView()
        view.statName = "Intelligence"
        view.statImage = AppImage.Stats.intelligence
        return view
    }()
    
    private var faith: StatView = {
        let view = StatView()
        view.statName = "Faith"
        view.statImage = AppImage.Stats.faith
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
        
        addStats()
        addBinding()
    }
    
    private func addStats() {
        stackView.addArrangedSubview(level)
        stackView.addArrangedSubview(souls)
        stackView.addArrangedSubview(rSouls)
        
        stackView.addArrangedSubview(separatorView)
        
        stackView.addArrangedSubview(vitality)
        stackView.addArrangedSubview(attunement)
        stackView.addArrangedSubview(endurance)
        stackView.addArrangedSubview(strength)
        stackView.addArrangedSubview(dexterity)
        stackView.addArrangedSubview(resistance)
        stackView.addArrangedSubview(intelligence)
        stackView.addArrangedSubview(faith)
        stackView.addArrangedSubview(UIView())
        
        vitality.delegate = self
        attunement.delegate = self
        endurance.delegate = self
        strength.delegate = self
        dexterity.delegate = self
        resistance.delegate = self
        intelligence.delegate = self
        faith.delegate = self
    }
    
    private func addBinding() {
        StatsManager.shared.$selectedClass
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gameClass in
                guard let self = self, let gameClass = gameClass else { return }
                
                self.level.statValue = gameClass.level
                self.souls.statValue = 0
                self.rSouls.statValue = soulsRequired(forLevel: gameClass.level)
                
                self.vitality.statValue = gameClass.vitality
                self.attunement.statValue = gameClass.attunement
                self.endurance.statValue = gameClass.endurance
                self.strength.statValue = gameClass.strength
                self.dexterity.statValue = gameClass.dexterity
                self.resistance.statValue = gameClass.resistance
                self.intelligence.statValue = gameClass.intelligence
                self.faith.statValue = gameClass.faith
            }
            .store(in: &cancellables)
    }
    
    func soulsRequired(forLevel level: Int) -> Int {
        
        if level == 1 { return 673 }
        if level == 2 { return 690 }
        if level == 3 { return 707 }
        if level == 4 { return 724 }
        if level == 5 { return 741 }
        if level == 6 { return 758 }
        if level == 7 { return 775 }
        if level == 8 { return 793 }
        if level == 9 { return 811 }
        if level == 10 { return 829 }
        if level == 11 { return 847 }
        if level == 12 { return 1039 }
        
        if level >= 12 {
            let newLevel = level + 1
            return Int(0.02 * pow(Double(newLevel), 3) + 3.06 * pow(Double(newLevel), 2) + 105.6 * Double(newLevel) - 895)
        }
        
        return 0
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        
        stackTopConstraint?.constant = frameImageView.bounds.height * 0.1
        stackLeftConstraint?.constant = frameImageView.bounds.width * 0.176
        stackRightConstraint?.constant = -frameImageView.bounds.width * 0.176
        stackBottomConstraint?.constant = -frameImageView.bounds.height * 0.1
    }
}

//MARK: - StatViewDelegate
extension StatsView: StatViewDelegate {
    public func increase() {
        souls.statValue!  += rSouls.statValue!
        level.statValue!  += 1
        rSouls.statValue! = soulsRequired(forLevel: level.statValue!)
    }
    
    public func decrease() {
        level.statValue!  -= 1
        rSouls.statValue! = soulsRequired(forLevel: level.statValue!)
        souls.statValue!  -= rSouls.statValue!
    }
}
