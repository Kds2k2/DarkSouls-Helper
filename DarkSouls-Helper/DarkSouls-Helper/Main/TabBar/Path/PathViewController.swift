//
//  PathViewController.swift
//  DarkSouls-Helper
//
//  Created by Dmitro Kryzhanovsky on 02.04.2025.
//

import UIKit

class PathViewController: UIViewController {

    var locations: [Location] = [
        Location(name: "Fire Shrine", link: nil, coordinates: CGPoint(x: 2821, y: 2481)),
        Location(name: "Sen's Fortress", link: nil, coordinates: CGPoint(x: 2668, y: 1807)),
        Location(name: "Catacombs", link: nil, coordinates: CGPoint(x: 1721, y: 1949))
    ]
    
    var markers: [MarkerView] = []
    
    private lazy var emptyImageView: EmptyNavigationView = {
        let view = EmptyNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.maximumZoomScale = 1.0
        view.minimumZoomScale = 0.2
        view.zoomScale = 0.4
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.bouncesHorizontally = false
        view.bouncesVertically = false
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var mapImageView: UIImageView = {
        let view = UIImageView()
        view.image = AppImage.View.map
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        view.addSubview(scrollView)
        scrollView.addSubview(mapImageView)
        view.addSubview(emptyImageView)
        
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -5),
            emptyImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            emptyImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mapImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mapImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mapImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mapImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        addPoints()
    }
    
    private func addPoints() {
        locations.forEach { location in
            let size = CGSize(width: 30.0, height: 30.0)
            let v = MarkerView(frame: CGRect(origin: .zero, size: size))
            v.delegate = self
            v.location = location
            v.image = UIImage(systemName: "questionmark.circle.fill")
            v.tintColor = .title
            v.contentMode = .scaleAspectFit
            scrollView.addSubview(v)
            markers.append(v)
            v.yPCT = location.coordinates.y / AppImage.View.map!.size.height
            v.xPCT = location.coordinates.x / AppImage.View.map!.size.width
            v.frame = CGRect(origin: .zero, size: CGSize(width: 30.0, height: 30.0))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        markers.forEach { v in
            v.center = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
            v.alpha = 0.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.markers.forEach { v in
                v.alpha = 1.0
            }
            self.updateMarkers()
        })
    }
    
    func updateMarkers() {
        markers.forEach { v in
            let x = mapImageView.frame.origin.x + v.xPCT * mapImageView.frame.width
            let y = mapImageView.frame.origin.y + v.yPCT * mapImageView.frame.height
            
            v.frame.origin = CGPoint(x: x + v.frame.width / 2, y: y - v.frame.height)
            
            v.center = CGPoint(x: x, y: y)
        }
    }
}

//MARK: - UIScrollViewDelegate
extension PathViewController: UIScrollViewDelegate {
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateMarkers()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
}

extension PathViewController: MarkerViewDelegate {
    func open(location: Location) {
        let vc = LocationViewController()
        vc.location = location
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 20
        }

        present(vc, animated: true, completion: nil)
    }
}
