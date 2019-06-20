//
//  Item.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 6/18/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import Foundation

class Item {
    let title : String
    private(set) var isDone : Bool = false
    
    func toggleDone() {
        self.isDone = !self.isDone
    }
    
    init(title: String) {
        self.title = title
    }
}
