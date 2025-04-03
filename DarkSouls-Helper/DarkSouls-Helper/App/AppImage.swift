//
//  AppImage.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit
import Foundation

struct AppImage {
    struct TabBar {
        //private static let configuration = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
     
        static let background = UIImage(named: "tabBar")
        
        static let bonfire = UIImage(named: "bonfire")?.resizedImage(targetSize: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysOriginal)
        static let bonfireUnselected = UIImage(named: "bonfire_unselected")?.resizedImage(targetSize: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysOriginal)
        
        static let stats = UIImage(named: "stats")?.resizedImage(targetSize: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysOriginal)
        static let statsUnselected = UIImage(named: "stats_unselected")?.resizedImage(targetSize: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysOriginal)
        
        static let path = UIImage(named: "path")?.resizedImage(targetSize: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysOriginal)
        static let pathUnselected = UIImage(named: "path_unselected")?.resizedImage(targetSize: CGSize(width: 40, height: 40))?.withRenderingMode(.alwaysOriginal)
    }
    
    struct View {
        static let background = UIImage(named: "background")
        static let goldBackground = UIImage(named: "gold")
        
        static let separator = UIImage(named: "separator")
        static let column = UIImage(named: "column")
        
        static let bigBonfire = UIImage(named: "big_bonfire")
    }
}
