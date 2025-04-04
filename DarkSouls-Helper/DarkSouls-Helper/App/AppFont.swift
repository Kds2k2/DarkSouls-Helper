//
//  AppFont.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import Foundation
import UIKit

struct AppFont {
    //static let scale: CGFloat = AppInfo.isIpad ? 1.25 : 1
    
    struct TabBar {
        static let title = UIFont.ebgGaramondFont(ofSize: 20, weight: .regular)
    }
    
    struct View {
        static let title = UIFont.ebgGaramondFont(ofSize: 18, weight: .semibold)
        static let smallTitle = UIFont.ebgGaramondFont(ofSize: 14, weight: .semibold)
        static let number = UIFont.ebgGaramondFont(ofSize: 28, weight: .semibold)
    }
}
