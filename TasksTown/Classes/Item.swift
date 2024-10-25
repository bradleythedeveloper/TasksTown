//
//  Item.swift
//  TasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import Foundation
import GRDB

class Item: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var name: String = ""
    var description: String?
    var dueDate: Date?
    //var dateType:
    //var color: ItemColor
}
