//
//  Item.swift
//  TasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import Foundation
import GRDB
import SwiftUI

class Item: Identifiable, Hashable, Codable {
    
    // Defining properties
    var id: String?
    var name: String = ""
    var description: String = ""
    var dueDate: Date?
    var isCompleted: Bool = false
    var dateType: DateType = .due
    var color: PriorityColor = .none
    var tagID: String?
    
    // Initialisation of Item
    init() {}
    init(id: String = UUID().uuidString, name: String, description: String, dueDate: Date? = nil, isCompleted: Bool, dateType: DateType, color: PriorityColor, tag: Tag? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.dateType = dateType
        self.color = color
        self.tagID = tag?.id
    }
    
    // Conforming to Hashable and Equatable protocols
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, dueDate, isCompleted, dateType, color, tagID
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(dateType.rawValue, forKey: .dateType)
        try container.encode(color.rawValue, forKey: .color)
        try container.encode(tagID, forKey: .tagID)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        self.dateType = try container.decode(DateType.self, forKey: .dateType)
        self.color = try container.decode(PriorityColor.self, forKey: .color)
        self.tagID = try container.decodeIfPresent(String.self, forKey: .tagID)
    }
}

enum DateType: String, Codable, CaseIterable, Identifiable {
    case due = "Due" // The item is due on DueDate
    case completeBy = "Complete by" // The item should be marked as completed by DueDate
    case noDate = "No Date"
    var id: Self { self }
}

enum PriorityColor: String, Codable, CaseIterable, Identifiable {
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
