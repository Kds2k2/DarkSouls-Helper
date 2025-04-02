//
//  UIFont+ebgGaramondFont.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import Foundation
import UIKit

extension UIFont {
    static func ebgGaramondFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        var fontName: String
        switch weight{
            case .regular: fontName = "EBGaramond-Regular"
            case .medium: fontName = "EBGaramond-Medium"
            case .semibold: fontName = "EBGaramond-SemiBold"
            case .bold: fontName = "EBGaramond-Bold"
            default: fontName = "EBGaramond-Regular"
        }
        
        guard let font = UIFont(name: fontName, size: fontSize) else {
            fatalError("Font with name \"\(fontName)\" not found!")
        }
        
        return font
    }
}
