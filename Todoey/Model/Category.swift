//
//  Category.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 7/8/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object, Saveable {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String? = ""
    let items = List<Item>()
}
