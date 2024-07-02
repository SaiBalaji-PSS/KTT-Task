//
//  HomeViewController.swift
//  KTT Task
//
//  Created by Sai Balaji on 01/07/24.
//

import UIKit
import CoreLocation
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var currentUserLbl: UILabel!
    
    @IBOutlet weak var stopLocationBton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var vm = HomeViewModel()
    private var selectedCurrentUser: UserModel?
    private var locationManager = LocationManager()
    private var coordinateSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        self.setupBinding()
    }
    
    func configureUI(){
        if let currentUser = AuthManager.shared.readFromUserDefault(type: CurrentUser.self){
            self.currentUserLbl.text = currentUser.email
            if let currentUserFromRealm = self.vm.getCurrentUserFromRealm(email: currentUser.email){
                self.selectedCurrentUser = currentUserFromRealm
                vm.getAllCoordinatesForGivenUser(user: currentUserFromRealm)
            }
        }
        
        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        locationManager.configureLocationManager()
      
    }
    
    func setupBinding(){
        coordinateSubscriber = vm.$currentUserCoordinates
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { coordinates in
           
                self.tableView.reloadData()
            
        }
    }
    
    
    @IBAction func stopLocationBtnPressed(_ sender: Any) {
        if stopLocationBton.titleLabel?.text == "Pause Location"{
            locationManager.resetTimer()
            stopLocationBton.setTitle("Resume", for: .normal)
        }
        else{
            locationManager.configureLocationManager()
            stopLocationBton.setTitle("Pause Location", for: .normal)
            
        }
        
        
    }
    
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        locationManager.resetTimer()
        AuthManager.shared.clearUserDefault()
        AppSession.shared.showSignInScreen()
        
        
    }
    
    @IBAction func switchAccountBtnPressed(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllUsersVC") as? AllUsersVC{
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    func showMessage(title: String,message: String){
        var avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in
            if message.contains("privacy"){
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                           return
                       }

                       if UIApplication.shared.canOpenURL(settingsUrl) {
                           UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                               print("Settings opened: \(success)")
                           })
                       }
            }
        }))
        self.present(avc, animated: true)
    }
}


extension HomeViewController: AllUseresDelegate{
    func didSelectUser(currentUser: UserModel) {
        self.currentUserLbl.text = currentUser.email
        AuthManager.shared.clearUserDefault()
        AuthManager.shared.saveToUserDefault(object: CurrentUser(userName: currentUser.userName, email: currentUser.email))
        
        self.selectedCurrentUser = currentUser
//        self.vm.currentUserCoordinates.removeAll()
//        self.tableView.reloadData()
        self.vm.getAllCoordinatesForGivenUser(user: currentUser)
        
    }
}

extension HomeViewController: LocationManagerDelegate{
    func didUpdateLocation(location: CLLocation) {
            print(location)
        
        if let selectedCurrentUser{
            self.vm.updateCoordinatesForCurrentUser(currentUser: selectedCurrentUser, coordinate: location.coordinate)
           
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
     
            
        
       
    }
    
    func didFailToUpdateLocation(error: Error?) {
        if let error{
            self.showMessage(title: "Info", message: error.localizedDescription)
        }
        
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.currentUserCoordinates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = "(\(self.vm.currentUserCoordinates[indexPath.row].latitude),\(self.vm.currentUserCoordinates[indexPath.row].longitude))"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController{
            vc.currentUserCoordinates = self.vm.currentUserCoordinates
            self.present(vc, animated: true)
        }
    }
}
