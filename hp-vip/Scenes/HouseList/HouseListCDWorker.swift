//
//  HouseListCDWorker.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 30/03/23.
//

import Foundation
import CoreData
import UIKit

protocol HouseListCDWorkerLogic: CDWorkerProtocol where T == HouseAPIModel { }

class HouseListCDWorker: HouseListCDWorkerLogic {
    let appDelegate: AppDelegate
    
    var ENTITY: String { "House" }
    
    init(appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func save<P>(param: [P]) {
        guard let param = param as? [T] else { return }
        param.forEach { house in
            _ = house.toEntity(entity: NSEntityDescription.insertNewObject(forEntityName: ENTITY, into: appDelegate.persistentContainer.viewContext))
        }

        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch {
            print("fail")
        }
    }
    
    func fetch() -> [T] {
        let request = NSFetchRequest<NSManagedObject>(entityName: ENTITY)
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(request)

            return result.map { item in
                return T(managedObject: item)
            }
        } catch {
            return []
        }
    }
    
    
}
