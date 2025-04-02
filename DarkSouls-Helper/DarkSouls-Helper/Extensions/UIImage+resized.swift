//
//  UIImage+resized.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

extension UIImage {
    func resizedImage(targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
