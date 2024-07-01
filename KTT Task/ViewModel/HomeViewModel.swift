//
//  HomeViewModel.swift
//  KTT Task
//
//  Created by Sai Balaji on 01/07/24.
//

import Foundation
import CoreLocation
import Combine

class HomeViewModel: ObservableObject{
    @Published var currentUserCoordinates = [Coordinates]()
    
    func getCurrentUserFromRealm(email: String) -> UserModel?{
        var currentUser: UserModel?
        RealmService.shared.readDataFromRealm(modelType: UserModel.self) { result  in
            if let result{
                currentUser = Array(result).filter({ userModel in
                    userModel.email == email
                }).first
                
               
            }
        }
        return currentUser
    }
    
    func getAllCoordinatesForGivenUser(user: UserModel){
        var currentUser: UserModel?
        RealmService.shared.readDataFromRealm(modelType: UserModel.self) { result  in
            if let result{
                currentUser = Array(result).filter({ userModel in
                    userModel == user
                }).first
                //and get all the saved coordinates
                if let currentUser{
                    self.currentUserCoordinates.removeAll()
                    self.currentUserCoordinates = Array(currentUser.coordinates)
                }
               
            }
        }
    }
   
    func updateCoordinatesForCurrentUser(currentUser: UserModel,coordinate: CLLocationCoordinate2D){
        let coordinateToBeSaved = Coordinates()
        coordinateToBeSaved.email = currentUser.email
        coordinateToBeSaved.latitude = "\(coordinate.latitude)"
        coordinateToBeSaved.longitude = "\(coordinate.longitude)"
       
        do{
            try RealmService.shared.realmFile?.write({
                currentUser.coordinates.append(coordinateToBeSaved)
                self.currentUserCoordinates.append(coordinateToBeSaved)
            })
        }
        catch{
            print(error)
        }
    }
}
