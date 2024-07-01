//
//  SignUpVC.swift
//  KTT Task
//
//  Created by Sai Balaji on 30/06/24.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var vm = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupBinding()
    }
    
    
    func setupBinding(){
        self.vm.didRegisterUser = { error, userData in
            if let error{
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription) {
                    
                }
            }
            else{
                self.showAlert(title: "Info", message: "Registration sucess") {
                    //navigate to home
                }
            }
            
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
  
        
        if let email = emailTextField.text, let password = passwordTextField.text,let userName = userNameTextField.text{
            if vm.checkIfGivenEmailIsValid(email:email){
                var userToRegister = UserModel()
                userToRegister.email = email
                userToRegister.password = password
                userToRegister.userName = userName
                vm.registerUser(user: userToRegister)
            }
            else{
                self.showAlert(title: "Info", message: "Enter a valid email address", onCompletion: {
                    
                })
            }

        }
      
        
       
    }
    
    func showAlert(title: String,message: String,onCompletion:@escaping()->(Void)){
        var avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in
            onCompletion()
        }))
        self.present(avc, animated: true)
    }
    
   

}
