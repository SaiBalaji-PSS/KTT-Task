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
                if self.checkIfGivenEmailIsValid(email: email) == false{
                    self.didSignInSucccess?(RegistrationError.invalidEmailId,"")
                }
                else{
                    if isPresentInDB == false{
                        self.didSignInSucccess?(RegistrationError.userDoesNotExist,"The given email Id or password is wrong")
                    }
                    else{
                       if let currentUser = result.filter { userModel in
                            userModel.email == email
                       }.first{
                           AuthManager.shared.saveToUserDefault(object: CurrentUser(userName: currentUser.userName, email: currentUser.email))
                           self.didSignInSucccess?(nil,"Sign In Success")
                       }
      
                    }
                }
               
            }
            
        }
    }
    
    func checkIfGivenEmailIsValid(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
