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
        static let title = UIFont.ebgGaramondFont(ofSize: 18, weight: .regular)
    }
    
    struct View {
        static let title = UIFont.ebgGaramondFont(ofSize: 24, weight: .semibold)
    }
}
