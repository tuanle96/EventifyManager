//
//  OrderListVC.swift
//  EventifyManager
//
//  Created by Lê Anh Tuấn on 12/30/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit


enum TypeOfCheckIn {
    case all
    case checkedIn
    case unCheckedIn
}

class OrderListVC: UIViewController {
    
    var listUsers = [UserObject]()
    var typeOfCheckIn = TypeOfCheckIn.all
    
    let loading = UIActivityIndicatorView()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tblUser: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblUser.delegate = self
        tblUser.dataSource = self
        tblUser.estimatedRowHeight = 70
        tblUser.register(UINib(nibName: "ListUserOrderCell", bundle: nil), forCellReuseIdentifier: "ListUserOrderCell")
        
        self.loadUser()
    }
    
    func loadUser() {
        
        guard let id = (self.tabBarController as? MyEventTabBarVC)?.myEvent?.id else {
            return
        }
        
        self.loading.showLoadingDialog(self)
        
        EventServices.shared.getUserOrdered(with: id) { (users, error) in
            
            self.loading.stopAnimating()
            
            if let error = error {
                self.showAlert(error, title: "Whoops", buttons: nil)
                return
            }
            
            self.listUsers = users ?? []
            self.tblUser.reloadData()
        }
    }
}

extension OrderListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListUserOrderCell", for: indexPath) as? ListUserOrderCell else {
            return UITableViewCell()
        }
        
        if let imgPath = self.listUsers[indexPath.row].photoDisplayPath {
            cell.imgAva?.downloadedFrom(link: imgPath)
        }
        
        cell.user = self.listUsers[indexPath.row]
        cell.lblPhone.text = self.listUsers[indexPath.row].phoneNumber
        cell.lblEmail.text = self.listUsers[indexPath.row].email
        cell.lblName.text = self.listUsers[indexPath.row].fullName
        
        return cell
    }
}
