//
//  UserModel.swift
//  KTT Task
//
//  Created by Sai Balaji on 30/06/24.
//

import Foundation
import RealmSwift


class UserModel: Object{
    @Persisted(primaryKey: true) var userId: ObjectId
    @Persisted var userName: String = ""
    @Persisted var email: String = ""
    @Persisted var password: String = ""
    @Persisted var coordinates: List<Coordinates>
}


class Coordinates: Object{
    @Persisted(primaryKey: true) var coordinateId: ObjectId
   // @Persisted var userName: String = ""
    @Persisted var email: String = ""
    @Persisted var latitude: String = ""
    @Persisted var longitude: String = ""
    
}


struct CurrentUser: Codable{
    let userName: String
    let email: String
    
}
