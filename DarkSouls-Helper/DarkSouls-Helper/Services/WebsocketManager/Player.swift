//
//  Player.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 25.04.2025.
//

struct Player: Codable {
    var PlayerName: String
    var TotalDeaths: Int
    var BossDeaths: Dictionary<String, Int>
}
