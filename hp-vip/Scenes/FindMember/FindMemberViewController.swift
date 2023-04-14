//
//  FindMemberViewController.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 13/04/23.
//

import UIKit
import MapKit

class FindMemberViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var viewModel: MemberViewModel?
    var zoomArea = 500.0
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsUserLocation = true
        
        map.register(FindMemberLocationView.self, forAnnotationViewWithReuseIdentifier: "FindMemberLocationView")
        map.delegate = self
        
        return map
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        locationUpdate(start: false)
    }
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = .white
        view.addSubview(mapView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initLocation()
        initObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.frame = view.frame
    }
    
    private func initLocation() {
        
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                locationManager.requestWhenInUseAuthorization()
            }
            locationUpdate(start: true)
        } else {
            let url = URL(string: "prefs:root=LOCATION_SERVICES")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func initObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackgroundObserver), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForegroundObserver), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func enterBackgroundObserver(notification: Notification) {
        locationUpdate(start: false)
    }
    
    @objc func enterForegroundObserver(notification: Notification) {
        locationUpdate(start: true)
    }
    
    private func locationUpdate(start: Bool) {
        if start {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
}

extension FindMemberViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = manager.location?.coordinate.latitude ?? 0
        let longitude = manager.location?.coordinate.longitude ?? 0
        
        let coordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let coordinateRegion = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: zoomArea, longitudinalMeters: zoomArea)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension FindMemberViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let findMemberLocationView = FindMemberLocationView(annotation: annotation, reuseIdentifier: "FindMemberLocationView")
        findMemberLocationView.updateData(member: viewModel!)
        return findMemberLocationView
    }
}
