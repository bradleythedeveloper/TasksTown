//
//  TestDatabaseClass.swift
//  tasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import Foundation
import GRDB

class Test: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var name: String
    init(name: String) {
        self.name = name
    }
}


