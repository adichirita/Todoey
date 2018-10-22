//
//  Item.swift
//  Todoey
//
//  Created by Adrian Chirita on 10/21/18.
//  Copyright © 2018 Zenegant. All rights reserved.
//

import Foundation
//inherit from Codable for swift to be able to infer it's type when encoding it
class Item : Codable {
    
    var title : String = ""
    var done: Bool = false
    
}
