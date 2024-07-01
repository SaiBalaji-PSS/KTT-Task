//
//  AppSession.swift
//  KTT Task
//
//  Created by Sai Balaji on 01/07/24.
//

import Foundation
import UIKit

class AppSession{
    private init(){}
    static var shared = AppSession()
    private var window: UIWindow!
    func start(window: UIWindow){
        self.window = window
        if AuthManager.shared.readFromUserDefault(type: CurrentUser.self) != nil{
            //show home screen
            print("SHOW HOME SCREEN")
            self.showMainTabbar()
        }
        else{
            //show sign in screen
            self.showSignInScreen()
        }
       // if Auth.auth().currentUser == nil{
//            showSignInScreen()
//        }
//        else{
//           showMainTabbar()
//        }
    }
    
    func showSignInScreen(){
        if let window{
            if let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as? ViewController{
                window.rootViewController = UINavigationController(rootViewController: signInVC)
            }
        }
    }
    
    func showMainTabbar(){
        if let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController{
            window.rootViewController = homeVC
        }
    }
    
}
