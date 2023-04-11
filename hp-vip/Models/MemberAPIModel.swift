//
//  MemberAPIModel.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import Foundation
import CoreData

struct MemberAPIModel: Codable, Equatable {
    let id: String
    let name: String
    let yearOfBirth: Int?
    let alive: Bool
    let image: String?
    
    init(managedObject: NSManagedObject) {
        self.id = managedObject.value(forKey: "id") as! String
        self.name = managedObject.value(forKey: "name") as! String
        self.yearOfBirth = managedObject.value(forKey: "yearOfBirth") as? Int
        self.alive = managedObject.value(forKey: "alive") as! Bool
        self.image = managedObject.value(forKey: "image") as? String
    }
    
    func toEntity(entity: NSManagedObject) -> NSManagedObject {
        entity.setValue(self.id, forKey: "id")
        entity.setValue(self.name, forKey: "name")
        entity.setValue(self.yearOfBirth, forKey: "yearOfBirth")
        entity.setValue(self.alive, forKey: "alive")
        entity.setValue(self.image, forKey: "image")
        return entity
    }
}
