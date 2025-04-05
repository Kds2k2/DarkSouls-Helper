//
//  Class.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 04.04.2025.
//
import UIKit
import Foundation

public struct GameClasses: Codable {
    let classes: [CharacterClass]
}

public struct CharacterClass: Codable {
    let title: String
    var level: Int
    
    var souls: Int {
        get {
            return level * soulsToNextLevel
        }
    }
    
    var soulsToNextLevel: Int
    var vitality: Int
    var attunement: Int
    var endurance: Int
    var strength: Int
    var dexterity: Int
    var resistance: Int
    var intelligence: Int
    var faith: Int
}
