//
//  CustomMapView.swift
//  KTT Task
//
//  Created by Sai Balaji on 02/07/24.
//

import UIKit
import GoogleMaps

class CustomMapView: UIView {

    var mapView = GMSMapView()
    var options = GMSMapViewOptions()
    override  func awakeFromNib() {
        super.awakeFromNib()
       
   // options.camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    options.frame = self.bounds

         mapView = GMSMapView(options: options)
        self.addSubview(mapView)
    }
    
 
   
    

}
