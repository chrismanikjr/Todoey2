//
//  Category.swift
//  Todoey2
//
//  Created by Chris Manik on 10/2/19.
//  Copyright © 2019 Natanail Manik. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
