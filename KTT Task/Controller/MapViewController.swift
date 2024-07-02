//
//  MapViewController.swift
//  KTT Task
//
//  Created by Sai Balaji on 02/07/24.
//

import UIKit
import GoogleMaps

class MapViewController: BaseViewController {

    @IBOutlet weak var animateBtn: UIButton!
    @IBOutlet weak var customMapView: CustomMapView!
    var currentUserCoordinates = [Coordinates]()
    
    @IBOutlet weak var coordinateLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    var path = GMSMutablePath()
    var vm = MapViewModel()
    var timer = Timer()
    var currentCoordinateIndex = 0
    let geocoder = GMSGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        populateMap()
        
    }
    
    @IBAction func animateBtnPressed(_ sender: Any) {
        if animateBtn.titleLabel?.text == "Animate"{
            self.startAnimation()
            self.animateBtn.setTitle("Stop Animation", for: .normal)
        }
        else{
            self.stopAnimation()
            self.animateBtn.setTitle("Animate", for: .normal)
        }
     
    }
    func startAnimation(){
        self.currentCoordinateIndex = 0
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(animateToPoint), userInfo: nil, repeats: true)
    }
    func stopAnimation(){
        timer.invalidate()
    }
    @objc func animateToPoint(){
        if self.currentCoordinateIndex > (self.currentUserCoordinates.count - 1){
            self.stopAnimation()
            return
        }
        if let lat = Double(self.currentUserCoordinates[currentCoordinateIndex].latitude), let long = Double(self.currentUserCoordinates[currentCoordinateIndex].longitude){
            self.currentCoordinateIndex += 1
            self.customMapView.mapView.animate(to: GMSCameraPosition(latitude: lat, longitude: long, zoom: 15.0))
            self.coordinateLbl.text = "\(lat),\(long)"
            geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: long)) { response , error in
                if let error{
                    print(error)
                }
                if let firstResult = response?.firstResult(){
                    
                    self.addressLbl.text =  (firstResult.subLocality ?? "")+" "+(firstResult.locality ?? "")  + " " + (firstResult.country ?? "")
                }
            }
            
        }

        
    }
    func populateMap(){
        for (index,coordinate) in currentUserCoordinates.enumerated() {
            if let lat = Double(coordinate.latitude),let long = Double(coordinate.longitude){
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
                marker.title = "Point number \(index)"
                marker.icon = UIImage(named: "pin")
                marker.map = customMapView.mapView
                customMapView.mapView.animate(to: GMSCameraPosition(latitude: lat, longitude: long, zoom: 15.0))
                path.add(CLLocationCoordinate2D(latitude: lat, longitude: long))
            }
        }
      
        let wayPoints = currentUserCoordinates.map { coordinate in
            "\(coordinate.latitude),\(coordinate.longitude)"
        }
       // print(wayPoints)
        
        Task{
            let result = await vm.drawPolyline(wayPoints:wayPoints)
            switch result {
            case .success(let response):
                print(response)
                
                let path = GMSPath(fromEncodedPath: response ?? "")
                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = UIColor.green
                polyline.strokeWidth = 8
                polyline.map = customMapView.mapView
            case .failure(let error):
                print(error)
                showMessage(title: "Error", message: error.localizedDescription)
            }
        }
      
    }
    

}
