//
//  Category.swift
//  Todoey
//
//  Created by Ess on 10/09/2019.
//  Copyright © 2019 Ess. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
