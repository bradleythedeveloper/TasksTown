//
//  LocalDatabase+Shared.swift
//  tasksTown
//
//  Created by Bradley Austin on 24/10/2024.
//

import Foundation
import GRDB

extension LocalDatabase {
    static let database = makeDatabaseInAppGroup()
    static func makeDatabaseInAppGroup() -> LocalDatabase {
        do {
            let fileManager = FileManager()
            guard let folder = fileManager.containerURL(
                forSecurityApplicationGroupIdentifier: "group.com.bradleythedeveloper.TasksTownApp"
            )?.appendingPathComponent("database", isDirectory: true) else {
                fatalError("Could not find app group container")
            }
            try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
            let databaseURL = folder.appendingPathComponent("database.sqlite")
            let writer = try DatabasePool(path: databaseURL.path)
            let database = try LocalDatabase(writer)
            return database
        } catch {
            fatalError("ERROR: \(error)")
        }
    }
}
