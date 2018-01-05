//
//  MyEventsVC.swift
//  EventifyManager
//
//  Created by Lê Anh Tuấn on 12/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

enum SelectedTypeEvents {
    case upcomingEvents
    case previousEvents
}

class MyEventsVC: UIViewController {
    
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var btnUpcomingEvent: UIButton!
    @IBOutlet weak var btnPreviousEvent: UIButton!
    @IBOutlet weak var tblEvents: UITableView!
    @IBOutlet weak var saparatorView: UIView!
    
    var refreshControl: UIRefreshControl!
    var selectedTypeEvents: SelectedTypeEvents = .upcomingEvents
    var myEvents = [EventObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        loadMyEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUpUI() {
        //pull to refresh
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        //tableview
        tblEvents.delegate = self
        tblEvents.dataSource = self
        tblEvents.register(UINib(nibName: "MyEventCell", bundle: nil), forCellReuseIdentifier: "MyEventCell")
        tblEvents.refreshControl = refreshControl
        tblEvents.estimatedRowHeight = 450
        
        controlView.layer.borderColor = #colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1).cgColor
        controlView.layer.borderWidth = 2
        controlView.layer.cornerRadius = 20
        
        //btnEvents
        btnUpcomingEvent.layer.cornerRadius = 20
        btnPreviousEvent.layer.cornerRadius = 20
    }
    
    func refresh() {
        loadMyEvents(false)
    }
    
    func loadMyEvents(_ isListening: Bool = true) {
        EventServices.shared.getMyEvents(isListening) { (events, error) in
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            if let error = error {
                self.showAlert(error, title: "Whoops", buttons: nil)
            } else {
                self.myEvents = events ?? []
                self.tblEvents.reloadData()
            }
        }
    }
    
    @IBAction func btnEventsClicked(_ sender: Any) {
        btnUpcomingEvent.backgroundColor = #colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1)
        btnUpcomingEvent.layer.zPosition = 100
        btnUpcomingEvent.setTitleColor(#colorLiteral(red: 0.9714086652, green: 0.9793576598, blue: 0.9995563626, alpha: 1), for: UIControlState.normal)
        
        btnPreviousEvent.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998719096, alpha: 1)
        btnPreviousEvent.layer.zPosition = 99
        btnPreviousEvent.setTitleColor(#colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1), for: UIControlState.normal)
        self.selectedTypeEvents = .upcomingEvents
    }
    
    @IBAction func btnPlacesClicked(_ sender: Any) {
        btnPreviousEvent.backgroundColor = #colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1)
        btnPreviousEvent.layer.zPosition = 100
        btnPreviousEvent.setTitleColor(#colorLiteral(red: 0.9714086652, green: 0.9793576598, blue: 0.9995563626, alpha: 1), for: UIControlState.normal)
        
        btnUpcomingEvent.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998719096, alpha: 1)
        btnUpcomingEvent.layer.zPosition = 99
        btnUpcomingEvent.setTitleColor(#colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1), for: UIControlState.normal)
        
        self.selectedTypeEvents = .previousEvents
    }
}

extension MyEventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventCell", for: indexPath) as? MyEventCell else {
            return UITableViewCell()
        }
        
        if let link = self.myEvents[indexPath.row].photoCoverPath {
            cell.imgPhoto.downloadedFrom(link: link)
        }
        
        cell.event = self.myEvents[indexPath.row]
        cell.lblName.text = self.myEvents[indexPath.row].name
        cell.lblAddress.text = self.myEvents[indexPath.row].address?.address
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "MyEventTabBarVC") as? MyEventTabBarVC else {
            return
        }
        tabBar.myEvent = self.myEvents[indexPath.row]
        
        tabBar.selectedIndex = 2
        
        self.navigationController?.pushViewController(tabBar, animated: true)
    }
}

extension MyEventsVC: MyEventDelegate {
    //open summary view controller
    func viewSummary(with event: EventObject) -> Void {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyEventTabBarVC") as? MyEventTabBarVC else{
            return
        }
        
        vc.myEvent = event
        vc.selectedIndex = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //open check in view controller
    func checkIn(with event: EventObject) -> Void {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyEventTabBarVC") as? MyEventTabBarVC else{
            return
        }
        
        vc.myEvent = event
        vc.selectedIndex = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

