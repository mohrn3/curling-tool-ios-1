//
//  LocationManager.swift
//  curling
//
//  Created by 武藤 颯汰 on 2023/02/15.
//

import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var heading: CLLocationDirection = 0.0
    @Published var speed: CLLocationSpeed = 0.0
    let manager = CLLocationManager()

    override init() {
        super.init()

        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        //電子コンパス設定
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.headingFilter      = kCLHeadingFilterNone
        manager.headingOrientation = .portrait
        manager.startUpdatingHeading()
        manager.startUpdatingLocation()
    }

    //電子コンパス値取得
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = newHeading.magneticHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last,
            CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
                return
        }
        self.speed = newLocation.speed
    }

}

