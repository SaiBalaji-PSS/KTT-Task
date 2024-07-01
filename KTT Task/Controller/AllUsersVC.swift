//
//  AllUsersVC.swift
//  KTT Task
//
//  Created by Sai Balaji on 01/07/24.
//

import UIKit

protocol AllUseresDelegate: AnyObject{
    func didSelectUser(currentUser: CurrentUser)
}
class AllUsersVC: UIViewController {
    weak var delegate: AllUseresDelegate?
    private var userList = [UserModel]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
    }
    

    func configureUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "CELL")
   
        RealmService.shared.readDataFromRealm(modelType: UserModel.self) { results in
            if let results{
                self.userList = Array(results)
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension AllUsersVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = "\(self.userList[indexPath.row].userName) (\(self.userList[indexPath.row].email))"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        self.delegate?.didSelectUser(currentUser: CurrentUser(userName: self.userList[indexPath.row].userName, email:  self.userList[indexPath.row].email))
        self.dismiss(animated: true)
    }
}
