//
//  UserDefaultsManager.swift
//  Project_PomodoroTimer
//
//  Created by Dmitro Kryzhanovsky on 12.03.2025.
//
import UIKit

public class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    struct Keys {
        static let isCharacterExisted = "isCharacterExisted"
    }
    
    var isCharacterExisted: Bool? {
        get {
            return UserDefaults.standard.object(forKey: Keys.isCharacterExisted) as? Bool;
        }
        set {
            if let isCharacterExisted = newValue {
                UserDefaults.standard.setValue(isCharacterExisted, forKey: Keys.isCharacterExisted)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.isCharacterExisted)
            }
        }
    }
}
