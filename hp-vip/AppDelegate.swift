//
//  AppDelegate.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 14/03/23.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var rootViewController: UIViewController!
        
        if ProcessInfo.processInfo.arguments.firstIndex(of: "isTest") != nil {
            rootViewController = UIViewController()
            rootViewController.view = UIView()
            rootViewController.view.backgroundColor = .red
        } else {
            rootViewController = HouseListViewController()
            HouseListConfiguration.configure(viewController: rootViewController as! HouseListViewController)
        }
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        configureNotificationCenter()
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem) async -> Bool {
        let houseViewController = window?.rootViewController?.children.last as? HouseListViewController
        houseViewController?.router?.membersList(with: shortcutItem.localizedTitle)
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(createDynamicShortcutItem),
                                               name:.addShortcutItemNotification,
                                               object: nil)
    }
    
    @objc func createDynamicShortcutItem(notification: NSNotification) {
        guard let houseName = notification.object as? String else { return }
        
        DispatchQueue.main.async {
            QuickActionWorker.addShortcut(houseName: houseName)
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataBaseModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
}

