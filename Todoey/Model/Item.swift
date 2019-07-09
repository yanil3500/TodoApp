//
//  Item.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 7/8/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object, Saveable {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

    required convenience init(date: Date) {
        self.init()
        dateCreated = date
    }
}
