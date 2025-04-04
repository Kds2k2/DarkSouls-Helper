//
//  StatsManager.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 04.04.2025.
//

import UIKit

final class StatsManager {
    public static var shared: StatsManager = .init()
    private init() {}
    
    public func loadClasses() -> [CharacterClass]? {
        guard let url = Bundle.main.url(forResource: "classes", withExtension: "json") else {
            print("JSON file not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let gameClasses = try decoder.decode(GameClasses.self, from: data)
            return gameClasses.classes
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
