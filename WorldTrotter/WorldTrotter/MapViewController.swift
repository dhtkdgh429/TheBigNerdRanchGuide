//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Oh Sangho on 17/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private var mapView: MKMapView!
    
    override func loadView() {
        print("Map View loading!!")
        
        // 지도 뷰 생성
        mapView = MKMapView()
        
        // 지도 뷰를 이 뷰컨트롤러의 view로 설정...
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(segControl:)), for: .valueChanged)
        
        // auto layout programmatically
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }

    @objc func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2 :
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        print("Map View did load!!")
        
    }
}
