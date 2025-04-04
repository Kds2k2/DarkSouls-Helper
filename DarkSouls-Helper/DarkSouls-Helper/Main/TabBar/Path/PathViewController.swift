//
//  PathViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

class PathViewController: UIViewController, UIScrollViewDelegate {

    var onEnd: () -> () = {}
    
    let scrollView = UIScrollView()
    
    private lazy var mapImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.map
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.3
        scrollView.maximumZoomScale = 4.0
        scrollView.addSubview(mapImageView)
        scrollView.contentSize = mapImageView.bounds.size

        view.addSubview(scrollView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
    
    private func didButtonTap() {
        onEnd()
    }
}
