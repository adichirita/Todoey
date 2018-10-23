//
//  Category.swift
//  Todoey
//
//  Created by Adrian Chirita on 10/23/18.
//  Copyright © 2018 Zenegant. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>() //this is a realm List
    
}

