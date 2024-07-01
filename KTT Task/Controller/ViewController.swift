//
//  ViewController.swift
//  KTT Task
//
//  Created by Sai Balaji on 30/06/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var vm = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupBinding()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func setupBinding(){
        vm.didSignInSucccess = { error, message in
            if let error{
                self.showAlert(title: "Info", message: error.localizedDescription, onCompletion: {
                    
                })
            }
            else{
                self.showAlert(title: "Info", message: message,onCompletion: {
                    //navigate to HomeScreen
                    AppSession.shared.showMainTabbar()
                })
               
            }
            
            
        }
    }

    @IBAction func signInBtnPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            vm.signInUser(email: email, password: password)
        }
       
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert(title: String,message: String,onCompletion:@escaping()->(Void)){
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in
            onCompletion()
        }))
        self.present(avc, animated: true)
    }
}

