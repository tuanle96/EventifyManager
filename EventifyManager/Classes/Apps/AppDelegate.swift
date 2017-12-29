//
//  AppDelegate.swift
//  Eventify
//
//  Created by Lê Anh Tuấn on 9/29/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Reachability


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    let reachability = Reachability()!
    var timer = Timer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //detect lost connection with server
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        //print("QUAY NÈ")
        return self.orientationLock
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //SocketIOServices.shared.closeConnection()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //SocketIOServices.shared.establishConnection()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func showMainView() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyEventsVC") as? MyEventsVC {
            self.window?.rootViewController = vc
        }
    }
    
    func showSignInView() {
        self.window?.rootViewController = SignInVC()
        
    }
    
    func showSignUpView() {
        self.window?.rootViewController = SignUpVC()
    }
    
    func showForgotPwView() {
    }
    
    func reachabilityChanged(note: Notification) {
        
        guard let reachability = note.object as? Reachability else {
            return
        }
        
        switch reachability.connection {
        case .wifi, .cellular:
            hideNotiLostConnection()
        case .none:
            showNotiLostConnection()
        }
    }
    
    func showNotiLostConnection() {
        
        guard let window = self.window else {
            return
        }
        
        if let vc = UIStoryboard(name: "Dialog", bundle: nil).instantiateViewController(withIdentifier: "DialogNetworkVC") as? DialogNetworkVC {
            vc.view.frame = window.frame
            vc.view.tag = 100
            self.window?.addSubview(vc.view)
        }
    }
    
    func hideNotiLostConnection() {
        
        let instance = SocketIOServices.shared
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            switch instance.socket.status {
            case .connected:
                self.timer.invalidate()
                self.removeSubview()
            case .connecting:
                break
            case .disconnected:
                instance.socket.connect()
            case .notConnected:
                instance.socket.connect()
            }
        })
    }
    
    func removeSubview() {
        if let dialog = self.window?.viewWithTag(100) {
            dialog.removeFromSuperview()
        }
    }
}

