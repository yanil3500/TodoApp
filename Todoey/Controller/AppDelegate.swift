//
//  AppDelegate.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 6/17/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import CoreData
import RealmSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        do {
            let realm = try Realm()
            print(realm.configuration.fileURL!)
        } catch {
            print("Error initializing new realm: \(error)")
        }

        return true
    }
}
