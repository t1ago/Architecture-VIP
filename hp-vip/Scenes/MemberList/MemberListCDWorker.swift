//
//  MemberListCDWorker.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 31/03/23.
//

import Foundation
import CoreData
import UIKit

protocol MemberListCDWorkerLogic: CDWorkerProtocol where T == MemberAPIModel {
    func fetch(houseName: String) -> [T]
    func save<P>(houseName: String, param: [P])
    func remove(houseName: String)
}

class MemberListCDWorker: MemberListCDWorkerLogic {
    
    let appDelegate: AppDelegate
    
    var ENTITY: String { "Member" }
    
    init(appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func remove(houseName: String) {
        guard let house = retrieveHouse(houseName: houseName) else { return }
        house.mutableSetValue(forKey: "fkMembers").removeAllObjects()
        
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch {
            print("fail")
        }
    }
    
    func save<P>(houseName: String, param: [P]) {
        guard let param = param as? [T] else { return }
        guard let house = retrieveHouse(houseName: houseName) else { return }
        
        let entities = param.map { member in
            return member.toEntity(entity: NSEntityDescription.insertNewObject(forEntityName: ENTITY, into: appDelegate.persistentContainer.viewContext))
        }
        
        house.mutableSetValue(forKey: "fkMembers").addObjects(from: entities)

        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch {
            print("fail")
        }
    }
    
    func fetch(houseName: String) -> [T] {
        guard let house = retrieveHouse(houseName: houseName) else { return [] }
        guard let context = house.managedObjectContext else { return [] }
        let request = NSFetchRequest<NSManagedObject>(entityName: ENTITY)
        let predicate = NSPredicate(format: "fkHouses == %@", house)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)

            return result.map { item in
                return T(managedObject: item)
            }
        } catch {
            return []
        }
    }
    
    private func retrieveHouse(houseName: String) -> NSManagedObject? {
        let entity = "House"
        let request = NSFetchRequest<NSManagedObject>(entityName: entity)
        let predicate = NSPredicate(format: "name == %@", houseName)
        request.predicate = predicate
        
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(request).first

            return result
        } catch {
            return nil
        }
    }
}
