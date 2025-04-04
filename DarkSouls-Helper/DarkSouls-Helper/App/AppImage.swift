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
        static let backgroundSlice = UIImage(named: "backgroundSlice")
        static let goldBackground = UIImage(named: "gold")
        
        static let statsFrame = UIImage(named: "statsFrame")
        static let statSeparator = UIImage(named: "statSeparator")
        
        static let map = UIImage(named: "fullmap")
        
        static let skull = UIImage(named: "skull")
        static let humanity = UIImage(named: "humanity")
        
        static let separator = UIImage(named: "separator")
        static let bottomSeparator = UIImage(named: "bottomSeparator")
        static let column = UIImage(named: "column")
        
        static let bigBonfire = UIImage(named: "big_bonfire")
        
        static let classImage = UIImage(named: "classImage")
        static let classFrame = UIImage(named: "classFrame")
        static let scroll = UIImage(named: "scroll")
    }
}
