//
//  Item.swift
//  TasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import Foundation
import GRDB
import SwiftUI

class Item: Identifiable, Codable, Hashable, MutablePersistableRecord, FetchableRecord {
    
    // Defining properties
    var id = UUID().uuidString
    var name: String = ""
    var description: String = ""
    var dueDate: Date?
    var isCompleted: Bool = false
    var dateType: DateType = .due
    var color: PriorityColor = .none
    var tag: Tag?
    
    // Initialisation of Item
    init(id: String = UUID().uuidString, name: String, description: String, dueDate: Date? = nil, isCompleted: Bool, dateType: DateType, color: PriorityColor, tag: Tag? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.dateType = dateType
        self.color = color
        self.tag = tag
    }
    
    // Encoding and decoding Item
    func encode(to container: inout PersistenceContainer) {
        container["id"] = self.id
        container["name"] = self.name
        container["description"] = self.description
        container["dueDate"] = self.dueDate
        container["isCompleted"] = self.isCompleted
        container["dateType"] = self.dateType
        container["color"] = self.color
        container["tagID"] = (self.tag != nil) ? self.tag?.id : nil
    }
    required init(row: Row) {
        id = row["id"]
        name = row["name"]
        description = row["description"]
        dueDate = row["dueDate"]
        isCompleted = row["isCompleted"]
        dateType = row["dateType"]
        color = row["color"]
        //tagID = row["tagID"]
    }
    
    // Conforming to Hashable and Equatable protocols
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
}

// MARK: Enums for Item
extension Item {
    enum DateType: String, Codable, CaseIterable, Identifiable, DatabaseValueConvertible {
        case due = "Due" // The item is due on DueDate
        case completeBy = "Complete by" // The item should be marked as completed by DueDate
        case noDate = "No Date"
        var id: Self { self }
    }
    
    enum PriorityColor: String, Codable, CaseIterable, Identifiable, DatabaseValueConvertible {
        case red
        case yellow
        case green
        case none = "No Colour"
        var id: Self { self }
        var name: String { rawValue.localizedCapitalized }
        var color: Color {
            switch self {
            case .red:
                return .red
            case .yellow:
                return .yellow
            case .green:
                return .green
            default:
                return .gray
            }
        }
        var icon: String {
            switch self {
            case .red:
                return "exclamationmark.3"
            case .yellow:
                return "exclamationmark.2"
            case .green:
                return "exclamationmark"
            default:
                return "nosign"
            }
        }
    }
}

extension Item: TableRecord {
    static let tagRelation = belongsTo(Tag.self)
}
