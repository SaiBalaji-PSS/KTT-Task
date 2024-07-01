//
//  AuthManager.swift
//  KTT Task
//
//  Created by Sai Balaji on 01/07/24.
//

import Foundation



class AuthManager{
    private init(){}
    static var shared = AuthManager()
    
    func saveToUserDefault<T: Codable>(object: T){
        do {
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(object)
            UserDefaults.standard.set(data, forKey: "currentUser")
        } catch {
           
            print(error)
        }
    }
    
    func readFromUserDefault<T: Codable>(type: T.Type) -> T?{
        guard let data = UserDefaults.standard.data(forKey: "currentUser") else {
            return nil
        }
        if let currentUser = try? JSONDecoder().decode(T.self, from: data){
            return currentUser
        }
        return nil
     
    }
    
    func clearUserDefault(){
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}
