//
//  PlayerManager.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 25.04.2025.
//

import UIKit
import Combine

final class PlayerManager {
    public static var shared: PlayerManager = .init()
    @Published public var player: Player?
    
    private init() {
        //TODO: ...
    }
}
