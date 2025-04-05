//
//  MarkerView.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 05.04.2025.
//

import Foundation
import UIKit

//MARK: - MarkerView
public class MarkerView: UIImageView {
    weak var delegate: MarkerViewDelegate?
    var location: Location?
    var yPCT: CGFloat = 0
    var xPCT: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTapGesture()
    }

    private func setupTapGesture() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSelf))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapSelf() {
        guard let location = location else { return }
        delegate?.open(location: location)
    }
}

//MARK: - MarkerViewDelegate
protocol MarkerViewDelegate: AnyObject {
    func open(location: Location)
}

extension MarkerViewDelegate {
    func open(location: Location) {}
}
