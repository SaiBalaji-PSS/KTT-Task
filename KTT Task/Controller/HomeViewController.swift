//
//  HomeViewController.swift
//  KTT Task
//
//  Created by Sai Balaji on 01/07/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var currentUserLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
    }
    
    func configureUI(){
        if let currentUser = AuthManager.shared.readFromUserDefault(type: CurrentUser.self){
            self.currentUserLbl.text = currentUser.email
        }
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        AuthManager.shared.clearUserDefault()
        AppSession.shared.showSignInScreen()
    }
    
    @IBAction func switchAccountBtnPressed(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllUsersVC") as? AllUsersVC{
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
}


extension HomeViewController: AllUseresDelegate{
    func didSelectUser(currentUser: CurrentUser) {
        self.currentUserLbl.text = currentUser.email
        AuthManager.shared.clearUserDefault()
        AuthManager.shared.saveToUserDefault(object: currentUser)
    }
}
