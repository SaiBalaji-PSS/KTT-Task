//
//  LocationManager.swift
//  KTT Task
//
//  Created by Sai Balaji on 01/07/24.
//

import Foundation
import CoreLocation
import UIKit

enum LocationManagerError: Error{
    case locationAccessRestricted
    case locationAccessDenined
}


extension LocationManagerError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .locationAccessDenined:
            return "The location access has been denined,change the privacy settings"
        case .locationAccessRestricted:
            return "The location access is restricted,change the privacy settings"
        }
        
    }
}









protocol LocationManagerDelegate: AnyObject{
    func didUpdateLocation(location: CLLocation)
    func didFailToUpdateLocation(error: Error?)
 
}



class LocationManager: NSObject{
    

    weak var delegate: LocationManagerDelegate?
    var timer: Timer?
    var secondsPassed = 0
    private lazy var manager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        return manager
    }()
    
    func startTimer(){
        timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        
    }
    @objc func timerFired(){
       
        secondsPassed += 1
       // print("Timer value is \(secondsPassed)")
    }
    
    func resetTimer(){
        secondsPassed = 0
        self.startTimer()
        
    }
    
    func stopTimer(){
        self.timer?.invalidate()
        
        self.manager.stopUpdatingLocation()
    }
    func configureLocationManager(){
        
        let status = manager.authorizationStatus
        switch status{
            case .authorizedAlways:
               
                    self.startTimer()
                
            
                manager.startUpdatingLocation()
                break
            case .authorizedWhenInUse:
               
                    self.startTimer()
                
                manager.startUpdatingLocation()
                manager.requestAlwaysAuthorization()
                break
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            
                break
            case .denied:
                delegate?.didFailToUpdateLocation(error: LocationManagerError.locationAccessDenined)
                break
            case .restricted:
                delegate?.didFailToUpdateLocation(error: LocationManagerError.locationAccessRestricted)
                break
            
        }
    }
    
    
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //self.configureLocationManager()
        self.configureLocationManager()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //self.manager.stopUpdatingLocation()
        print("SECONDS PASSED \(secondsPassed)")
        if secondsPassed == 5{
            if let location = locations.first{
              
              
                    
                    self.delegate?.didUpdateLocation(location: location)
                    secondsPassed = 0
               
            }
        }
      
//        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//            self.manager.startUpdatingLocation()
//        }
      
       
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.requestWhenInUseAuthorization()
        self.delegate?.didFailToUpdateLocation(error: error)
    }
}
