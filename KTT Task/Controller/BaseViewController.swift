//
//  BaseViewController.swift
//  KTT Task
//
//  Created by Sai Balaji on 02/07/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showMessage(title: String,message: String){
        var avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Ok", style: .default))
        avc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(avc, animated: true)
    }

}
