//
//  RealmService.swift
//  KTT Task
//
//  Created by Sai Balaji on 30/06/24.
//

import Foundation
import RealmSwift




class RealmService{
 
    var realmFile: Realm?
    static var shared = RealmService()
    private init(){
    }
    func openRealmFile(onCompletion:@escaping(Error?)->(Void)){
        do{
            realmFile = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL)
            onCompletion(nil)
        }
        catch{
            print(error)
            onCompletion(error)
        }
    }
    
    func saveDataToRealm<T: Object>(object: T,onCompletion:@escaping(Error?)->(Void)){
        do{
            try realmFile?.write({
                self.realmFile?.add(object)
                onCompletion(nil)
            })
            
        }
        catch{
            print(error)
            onCompletion(error)
        }
    }
    func readDataFromRealm<T: Object>(modelType: T.Type,onCompletion:@escaping(Results<T>?)->(Void)){
        if let objects = realmFile?.objects(T.self){
            onCompletion(objects)
            
        }
        else{
            onCompletion(nil)
        }
        
    }
    
    
   
}
