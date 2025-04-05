//
//  StatsManager.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 04.04.2025.
//

import UIKit
import Combine

final class StatsManager {
    public static var shared: StatsManager = .init()
    public var classes: [CharacterClass] = []
    @Published public var selectedClass: CharacterClass?
    
    private init() {
        loadClasses()
    }
    
    public func loadClasses() {
        guard let url = Bundle.main.url(forResource: AppString.JSON.name, withExtension: AppString.JSON.extension) else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let gameClasses = try decoder.decode(GameClasses.self, from: data)
            self.classes = gameClasses.classes
        } catch {
            print("Error decoding JSON: \(error)")
            return
        }
    }
    
    public func loadDefaultClass() {
        self.selectedClass = classes[9]
    }
}
