//
//  LocationManager.swift
//
//  Created by Eilon Krauthammer on 17/12/2019.
//  Copyright © 2019 Eilon Krauthammer. All rights reserved.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject {
    struct Location {
        let latitude, longitude: Double
    }
    
    // Singleton
    static let shared: LocationManager = LocationManager()
    
    private let manager: CLLocationManager = CLLocationManager()
    
    public var lastLocation: CLLocation?
    public var authorizationStatus: CLAuthorizationStatus = .notDetermined {
        didSet {
            if oldValue == .denied && authorizationStatus == .authorizedWhenInUse {
                manager.startUpdatingLocation()
            }
        }
    }
    
    typealias Handler = () -> Void
    
    private var locationCallback: LocationCallback?
    
    public var deniedAuthorizationCallback: Handler?
    public var onAuthorizationStatusChange: ((CLAuthorizationStatus) -> Void)?
    
    private var readOnce: Bool = true
    
    typealias LocationCallback = (Location?) -> Void
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
    }
    
    public func startMonitoringLocation(once: Bool = true, callback: LocationCallback? = nil) {
        self.readOnce = once
        self.locationCallback = callback ?? self.locationCallback                               
        manager.startUpdatingLocation()
    }
    
    public func stopMonitoringLocation() {
        manager.stopUpdatingLocation()
    }
    
    deinit {
         manager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if readOnce {
            self.manager.stopUpdatingLocation()
            self.manager.stopMonitoringSignificantLocationChanges()
        }
        
        let location = locations.last
        self.lastLocation = location
        self.locationCallback?(location?.location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.manager.stopUpdatingLocation()
        self.manager.stopMonitoringSignificantLocationChanges()
        self.locationCallback?(nil)
        if Environment.isDebug {
            print("Location manager failed with error:")
            print(error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        onAuthorizationStatusChange?(status)
    }
}

// MARK: - Descriptions

extension LocationManager {
    static func locationDescription(for loc: CLLocation?, handler: @escaping (String?) -> Void) {
        guard let location = loc else { print("location is nil."); return }
        
        var locationDescription: String?
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error fetching placemark from location: \n \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                locationDescription = (placemark.locality ?? "") + ", " + (placemark.thoroughfare ?? "")
            } else {
                print("Unknown error fetching placemark from location.")
            }
            
            handler(locationDescription)
        }
    }
}

extension CLLocation {
    var location: LocationManager.Location {
        LocationManager.Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
