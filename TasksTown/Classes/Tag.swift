//
//  Tag.swift
//  TasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import Foundation
import SwiftUI
import GRDB

class Tag: Identifiable, Codable, FetchableRecord, MutablePersistableRecord {
    var id = UUID().uuidString
    var name: String
    //var color: Color
    var isEditing: Bool = false
    init(id: String = UUID().uuidString, name: String, /*color: Color,*/ isEditing: Bool) {
        self.id = id
        self.name = name
        //self.color = color
        self.isEditing = isEditing
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
}
