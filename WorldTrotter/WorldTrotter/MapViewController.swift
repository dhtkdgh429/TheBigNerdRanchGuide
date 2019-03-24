//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Oh Sangho on 17/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    
    private var currentLocationButton: UIButton!
    private var zoomInButton: UIButton!
    private var zoomOutButton: UIButton!
    private var pinButton: UIButton!
    
    private var isExistsPin: Bool = false
    private var showCount: Int = 0
    
    // data...
    private let titleArr = ["Home", "Hollys", "Seohyun Station"]
    private let subTitleArr = ["My Home", "My Study Cafe", "nearby Station"]
    private let latitudeArr = [37.385201, 37.384301, 37.3849906]
    private let longitudeArr = [127.129227, 127.130915, 127.1229633]
    
    
    override func loadView() {
        print("Map View load!!")
        
        // 지도 뷰 생성
        mapView = MKMapView()
        
        // 지도 뷰를 이 뷰컨트롤러의 view로 설정...
        view = mapView
        
        // 위치 이벤트 매니저
        
        locationManager.delegate = self
        // private. 사용자 승인 요청.
        locationManager.requestWhenInUseAuthorization()
        // 정확도 설정.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 업데이트 시작.
        locationManager.startUpdatingLocation()
        print("start location update")
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 현재위치 버튼.
        currentLocationButton = UIButton(type: .custom)
        currentLocationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        currentLocationButton.setTitleColor(UIColor.black, for: .normal)
        currentLocationButton.setTitle("현재 위치", for: .normal)
        currentLocationButton.addTarget(self, action: #selector(touchedCurrentUserLocationButton), for: .touchUpInside)
        view.addSubview(currentLocationButton!)
        // 버튼 width = 스크린 넓이/2 - layout 마진 8.0 (11버전 이상에서는 20)
        var screenWidth = UIScreen.main.bounds.width / 2 - 8.0
        if #available(iOS 11, *) {
            screenWidth = UIScreen.main.bounds.width / 2 - 20.0
        }
        let currentBtnLeading = currentLocationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let currentBtnBottom = currentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0)
        let currentBtnWidth = currentLocationButton.widthAnchor.constraint(equalToConstant: screenWidth)
        currentBtnLeading.isActive = true
        currentBtnBottom.isActive = true
        currentBtnWidth.isActive = true
        
        // 줌 인 버튼..
        zoomInButton = UIButton(type: .custom)
        zoomInButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        zoomInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        zoomInButton.setTitleColor(UIColor.black, for: .normal)
        zoomInButton.setTitle("+", for: .normal)
        zoomInButton.addTarget(self, action: #selector(touchedZoomInButton), for: .touchUpInside)
        view.addSubview(zoomInButton!)
        
        let zoomInBtnLeading = zoomInButton.leadingAnchor.constraint(equalTo: currentLocationButton.trailingAnchor, constant: 5.0)
        let zoomInBtnBottom = zoomInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0)
        zoomInBtnLeading.isActive = true
        zoomInBtnBottom.isActive = true
        
        // 줌 아웃 버튼..
        zoomOutButton = UIButton(type: .custom)
        zoomOutButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        zoomOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        zoomOutButton.setTitleColor(UIColor.black, for: .normal)
        zoomOutButton.setTitle("-", for: .normal)
        zoomOutButton.addTarget(self, action: #selector(touchedZoomOutButton), for: .touchUpInside)
        view.addSubview(zoomOutButton)
        
        let zoomOutBtnLeading = zoomOutButton.leadingAnchor.constraint(equalTo: zoomInButton.trailingAnchor, constant: 5.0)
        let zoomOutBtnTrailing = zoomOutButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        let zoomOutBtnBottom = zoomOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0)
        let zoomOutBtnWidth = zoomOutButton.widthAnchor.constraint(equalTo: zoomInButton.widthAnchor, multiplier: 1.0)
        zoomOutBtnLeading.isActive = true
        zoomOutBtnTrailing.isActive = true
        zoomOutBtnBottom.isActive = true
        zoomOutBtnWidth.isActive = true
        
        // 핀 버튼...
        pinButton = UIButton(type: .custom)
        pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        pinButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        pinButton.setTitleColor(UIColor.black, for: .normal)
        pinButton.setTitle("Pin", for: .normal)
        pinButton.addTarget(self, action: #selector(touchedPinButton), for: .touchUpInside)
        view.addSubview(pinButton)
        
        let pinBtnLeading = pinButton.leadingAnchor.constraint(equalTo: zoomOutButton.leadingAnchor)
        let pinBtnTrailing = pinButton.trailingAnchor.constraint(equalTo: zoomOutButton.trailingAnchor)
        let pinBtnBottom = pinButton.bottomAnchor.constraint(equalTo: zoomOutButton.topAnchor, constant: -10.0)
        
        pinBtnLeading.isActive = true
        pinBtnTrailing.isActive = true
        pinBtnBottom.isActive = true
        
        // 맵 컨트롤 버튼 추가하기.
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
    
    override func viewDidLoad() {
        print("Map View did load!!")
        
    }
    
    @objc func updateUserLocation(span: MKCoordinateSpan, button: UIButton) {
        var region = MKCoordinateRegion()
        let userCoord = mapView.userLocation.coordinate
        
        //Zoom 설정
        region.span = span

        //위치(경도,위도) 설정
        let coordinate = CLLocationCoordinate2D(latitude: userCoord.latitude, longitude: userCoord.longitude)
        
        //center 설정. zoom 버튼 예외처리.
        if button == zoomInButton || button == zoomOutButton {
            region.center = mapView.centerCoordinate
        } else {
            region.center = coordinate
        }
    
        mapView.setRegion(region, animated: true)
        print("update")
        
    }
    
    private func addPinPoint() {
        for index in 0..<3 {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitudeArr[index], longitude: longitudeArr[index])
            annotation.title = titleArr[index]
            annotation.subtitle = subTitleArr[index]
            mapView.addAnnotation(annotation)
            print("Add Pin : \(titleArr[index])")
        }
        isExistsPin = true
    }
    
    private func showPinPoint(index: Int) {
        
        var pinList = [MKAnnotation]()
        
        for annotation in mapView.annotations {
            if annotation.isKind(of: MKPointAnnotation.self) {
                pinList.append(annotation)
            }
        }
        
        if let annotation = pinList[index] as? MKPointAnnotation {
            var region = MKCoordinateRegion()
            let coordinate = annotation.coordinate
            region.center = coordinate
            region.span = mapView.region.span
            
            mapView.setRegion(region, animated: true)
        }
        showCount += 1
        if showCount == 3 {
            showCount = 0
        }
    }
    
    // 맵 컨트롤 버튼 액션
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
    
    @objc func touchedCurrentUserLocationButton() {
        print("Current Location Update : \(mapView.userLocation.coordinate)")
        updateUserLocation(span: mapView.region.span, button: currentLocationButton)
    }
    
    
    @objc func touchedZoomInButton() {
        print("Zoom In x 10")
        let currentSpan = mapView.region.span
        let span = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 2, longitudeDelta: currentSpan.longitudeDelta / 2)
        updateUserLocation(span: span, button: zoomInButton)
    }
    
    @objc func touchedZoomOutButton() {
        print("Zoom Out")
        let currentSpan = mapView.region.span
        let span = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta * 2, longitudeDelta: currentSpan.longitudeDelta * 2)
        updateUserLocation(span: span, button: zoomInButton)
    }
    
    // pin button action
    @objc func touchedPinButton() {
        if !isExistsPin {
            print("call add Pin")
            addPinPoint()
        } else {
            print("call show pin")
            showPinPoint(index: showCount)
        }
    }
}

extension MapViewController : MKMapViewDelegate {
    //Adjusting the zoom
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // delta 0.01.. 100배 확대.
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        self.updateUserLocation(span: span, button: currentLocationButton)
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("starting locating")
    }
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("stop locating")
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        debugPrint("receive location")
    }
}
