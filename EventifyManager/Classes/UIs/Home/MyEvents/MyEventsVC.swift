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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
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
        
    }
    
    @IBAction func btnEventsClicked(_ sender: Any) {
        btnUpcomingEvent.backgroundColor = #colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1)
        btnUpcomingEvent.layer.zPosition = 100
        btnUpcomingEvent.setTitleColor(#colorLiteral(red: 0.9714086652, green: 0.9793576598, blue: 0.9995563626, alpha: 1), for: UIControlState.normal)
        
        btnPreviousEvent.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998719096, alpha: 1)
        btnPreviousEvent.layer.zPosition = 99
        btnPreviousEvent.setTitleColor(#colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1), for: UIControlState.normal)
        
        if self.selectedTypeEvents == .upcomingEvents {
            return
        }
        
        self.selectedTypeEvents = .upcomingEvents
    }
    
    @IBAction func btnPlacesClicked(_ sender: Any) {
        btnUpcomingEvent.backgroundColor = #colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1)
        btnUpcomingEvent.layer.zPosition = 100
        btnUpcomingEvent.setTitleColor(#colorLiteral(red: 0.9714086652, green: 0.9793576598, blue: 0.9995563626, alpha: 1), for: UIControlState.normal)
        
        btnPreviousEvent.backgroundColor = #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998719096, alpha: 1)
        btnPreviousEvent.layer.zPosition = 99
        btnPreviousEvent.setTitleColor(#colorLiteral(red: 0.6353397965, green: 0.6384146214, blue: 0.7479377389, alpha: 1), for: UIControlState.normal)
        
        if self.selectedTypeEvents == .previousEvents {
            return
        }
        
        self.selectedTypeEvents = .previousEvents
    }
}

extension MyEventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventCell", for: indexPath) as? MyEventCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
