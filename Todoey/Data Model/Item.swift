//
//  Item.swift
//  Todoey
//
//  Created by Adrian Chirita on 10/23/18.
//  Copyright © 2018 Zenegant. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object{
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //name of the forward relationship in the category class
    
}
