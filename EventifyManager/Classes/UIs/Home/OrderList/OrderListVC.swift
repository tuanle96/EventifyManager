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
    
    var listOrders = [OrderObject]()
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
        
        self.loadOrders()
    }
    
    
    
    func loadOrders() {
        
        guard let id = (self.tabBarController as? MyEventTabBarVC)?.myEvent?.id else {
            return
        }
        
        self.loading.showLoadingDialog(self)
        
        EventServices.shared.getOrders(with: id) { (orders, error) in
            self.loading.stopAnimating()
            
            if let error = error {
                self.showAlert(error, title: "Whoops", buttons: nil)
                return
            }
            
            self.listOrders = orders ?? []
            self.tblUser.reloadData()
        }
    }
}

extension OrderListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListUserOrderCell", for: indexPath) as? ListUserOrderCell else {
            return UITableViewCell()
        }
        
        if let imgPath = self.listOrders[indexPath.row].orderBy?.photoDisplayPath {
            cell.imgAva?.downloadedFrom(link: imgPath)
        }
        
        cell.user = self.listOrders[indexPath.row].orderBy
        cell.lblPhone.text = self.listOrders[indexPath.row].orderBy?.phoneNumber
        cell.lblEmail.text = self.listOrders[indexPath.row].orderBy?.email
        cell.lblName.text = self.listOrders[indexPath.row].orderBy?.fullName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ListTicketsVC") as? ListTicketsVC else {
            return
        }
        
        vc.order = self.listOrders[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

