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
    
    func resetTimer(){
        secondsPassed = 0
        manager.stopUpdatingLocation()
    }
    func configureLocationManager(){
        self.secondsPassed = 0
        let status = manager.authorizationStatus
        switch status{
            case .authorizedAlways:

               
                
            
                manager.startUpdatingLocation()
                break
            case .authorizedWhenInUse:
               
                  
                
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
        self.configureLocationManager()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        self.secondsPassed += 1
        print("SECONDS PASSED IS \(secondsPassed)")
        if secondsPassed >= 30{
            
            if let location = locations.first{
                
                
                print(location)
 
                self.delegate?.didUpdateLocation(location: location)
                 secondsPassed = 0
                
            }
        }
   
      
       
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      
       
        self.delegate?.didFailToUpdateLocation(error: error)
    }
}
