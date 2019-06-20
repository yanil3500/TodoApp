//
//  Item.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 6/18/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import Foundation


// By conforming to the Codable protocol, we're saying this is a type that only contains standard types that can encoded/decoded to/from another representation.
class Item: Codable {
    let title: String
    private(set) var isDone: Bool = false

    func toggleDone() {
        self.isDone = !self.isDone
    }

    init(title: String) {
        self.title = title
    }
}
