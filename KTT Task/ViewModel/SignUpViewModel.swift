//
//  SignUpViewModel.swift
//  KTT Task
//
//  Created by Sai Balaji on 30/06/24.
//

import Foundation

import Combine

enum RegistrationError: Error{
    case userAlreadyExist
    case userDoesNotExist
}
extension RegistrationError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .userAlreadyExist:
            return "The given account already exist please Login using that account."
        case .userDoesNotExist:
            return "The gives email or password is wrong."

        }
        
    }
}

class SignUpViewModel{

   
    var didRegisterUser: ((Error?,UserModel?) -> Void)?
    func registerUser(user: UserModel){
        if checkIsUserAlreadyExist(user: user) == false{
            RealmService.shared.saveDataToRealm(object: user) { error  in
                if let error{
                    self.didRegisterUser?(error,nil)
                }
                else{
                    self.didRegisterUser?(nil,user)
                }
            }
        }
        else{
            self.didRegisterUser?(RegistrationError.userAlreadyExist,nil)
        }
      
    }
    
    func checkIsUserAlreadyExist(user: UserModel) -> Bool{
        var userData = [UserModel]()
        RealmService.shared.readDataFromRealm(modelType: UserModel.self) { result  in
            if let result{
                userData = Array(result)
            }
            
        }
        return userData.contains(where: {$0.email == user.email})
    }
    
    func checkIfGivenEmailIsValid(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
  
    
    
}
