//
//  Item.swift
//  Todoey2
//
//  Created by Chris Manik on 10/2/19.
//  Copyright © 2019 Natanail Manik. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var currentDate: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
