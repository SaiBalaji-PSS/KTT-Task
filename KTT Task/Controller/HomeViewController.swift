//
//  HomeViewController.swift
//  KTT Task
//
//  Created by Sai Balaji on 01/07/24.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var currentUserLbl: UILabel!
    private var selectedCurrentUser: UserModel?
    private var userCoordinates = [Coordinates]()
    private var locationManager = LocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
    }
    
    func configureUI(){
        if let currentUser = AuthManager.shared.readFromUserDefault(type: CurrentUser.self){
            self.currentUserLbl.text = currentUser.email
            
        }
        locationManager.delegate = self
        locationManager.configureLocationManager()
      
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        AuthManager.shared.clearUserDefault()
        AppSession.shared.showSignInScreen()
    }
    
    @IBAction func switchAccountBtnPressed(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllUsersVC") as? AllUsersVC{
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
}


extension HomeViewController: AllUseresDelegate{
    func didSelectUser(currentUser: UserModel) {
        self.currentUserLbl.text = currentUser.email
        AuthManager.shared.clearUserDefault()
        AuthManager.shared.saveToUserDefault(object: CurrentUser(userName: currentUser.userName, email: currentUser.email))
        self.selectedCurrentUser = currentUser
    }
}

extension HomeViewController: LocationManagerDelegate{
    func didUpdateLocation(location: CLLocation) {
            print(location)
        if let selectedCurrentUser{
            let coordinateToBeSaved = Coordinates()
            coordinateToBeSaved.latitude = "\(location.coordinate.latitude)"
            coordinateToBeSaved.longitude = "\(location.coordinate.longitude)"
           
            do{
                try RealmService.shared.realmFile?.write({
                    selectedCurrentUser.coordinates.append(coordinateToBeSaved)
                })
            }
            catch{
                print(error)
            }
           
        }
     
            
        
       
    }
    
    func didFailToUpdateLocation(error: Error?) {
        
    }
    
    
}
