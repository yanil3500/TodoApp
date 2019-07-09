//
//  CategoryStorage.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 7/8/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import Foundation
import RealmSwift

protocol Saveable: Object {}

class CategoryStorage {
    private init() {}
    private let realm = try! Realm()

    static let shared = CategoryStorage()

    typealias Operation = (Realm?) -> Void

    func save(_ operation: Operation) {
        do {
            try realm.write {
                operation(realm)
            }
        } catch {
            print("Error saving data to context: \(error)")
        }
    }

    func update(_ operation: Operation) {
        save(operation)
    }

    func load() -> Results<Category> {
        return realm.objects(Category.self)
    }
}
