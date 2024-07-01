//
//  SignInViewModel.swift
//  KTT Task
//
//  Created by Sai Balaji on 01/07/24.
//

import Foundation

class SignInViewModel{
    var didSignInSucccess: ((Error?,String)->(Void))?
    
    func signInUser(email: String,password: String){
        RealmService.shared.readDataFromRealm(modelType: UserModel.self) { result in
            if let result{
                let isPresentInDB = result.contains { userModel in
                    (userModel.email == email && userModel.password == password)
                }
                if isPresentInDB == false{
                    self.didSignInSucccess?(RegistrationError.userDoesNotExist,"The given email Id or password is wrong")
                }
                else{
                    self.didSignInSucccess?(nil,"Sign In Success")
                }
            }
            
        }
    }
    
    
}
