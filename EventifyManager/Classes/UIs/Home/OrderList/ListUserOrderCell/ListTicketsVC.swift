//
//  ListTicketsVC.swift
//  EventifyManager
//
//  Created by Lê Anh Tuấn on 1/5/18.
//  Copyright © 2018 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class ListTicketsVC: UIViewController {

    @IBOutlet weak var tblTickets: UITableView!
    
    var order: OrderObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tblTickets.register(UINib(nibName: "TicketsCell", bundle: nil), forCellReuseIdentifier: "TicketsCell")
        tblTickets.delegate = self
        tblTickets.dataSource = self
        tblTickets.estimatedRowHeight = 80
    }

}

extension ListTicketsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.ticketsOrder?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketsCell", for: indexPath) as? TicketsCell else {
            return UITableViewCell()
        }
        
        guard let tickets = self.order?.ticketsOrder else {
            return UITableViewCell()
        }
        
        cell.lblStatus.text = (tickets[indexPath.row].isCheckedIn ?? false) == true ? "Đã check in" : "Chưa check in"
        cell.lblIdTicket.text = "#\(tickets[indexPath.row].id)"
        cell.lblTicketType.text = tickets[indexPath.row].informations?.name ?? "Không rõ"
        cell.lblTimeCheckIn.text = tickets[indexPath.row].timeCheckIn?.toTimeStamp()
        
        return cell
    }
}


