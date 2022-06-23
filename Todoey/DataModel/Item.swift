//
//  Item.swift
//  Todoey
//
//  Created by Cory Carte on 6/21/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var created: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
