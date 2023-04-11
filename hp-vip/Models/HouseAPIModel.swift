//
//  HouseListAPIModel.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 14/03/23.
//

import Foundation
import CoreData

struct HouseAPIModel: Codable, Equatable {
    let id: Int
    let name: String
    let image_url: String
    let members: Int
    
    init(id: Int, name: String, image_url: String, members: Int) {
        self.id = id
        self.name = name
        self.image_url = image_url
        self.members = members
    }
    
    init(managedObject: NSManagedObject) {
        self.id = managedObject.value(forKey: "id") as! Int
        self.name = managedObject.value(forKey: "name") as! String
        self.image_url = managedObject.value(forKey: "image_url") as! String
        self.members = managedObject.value(forKey: "members") as! Int
    }
    
    func toEntity(entity: NSManagedObject) -> NSManagedObject {
        entity.setValue(self.id, forKey: "id")
        entity.setValue(self.name, forKey: "name")
        entity.setValue(self.image_url, forKey: "image_url")
        entity.setValue(self.members, forKey: "members")
        return entity
    }
}
