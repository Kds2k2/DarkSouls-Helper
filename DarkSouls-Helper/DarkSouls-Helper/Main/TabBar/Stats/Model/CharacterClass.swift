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
    let level: Int
    let stats: [Stat]
}

public struct Stat: Codable {
    let name: String
    let value: Int
}
