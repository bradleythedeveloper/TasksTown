//
//  Tasks.swift
//  TasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import Foundation
import GRDB

class TaskItem: Item {
    // Encoding and decoding 
    override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container) // Encoding properties from Item
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder) // Using item's decoder
    }
    required init(row: Row) {
        super.init(row: row) // Using item's row decoder
    }
    
    // Initialisation of TaskItem
    override init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        dateType: DateType = .due,
        color: PriorityColor = .none,
        tag: Tag? = nil
    ) {
        super.init(id: id, name: name, description: description, dueDate: dueDate, isCompleted: isCompleted, dateType: dateType, color: color, tag: tag)
    }
}
