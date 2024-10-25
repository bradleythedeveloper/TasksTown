//
//  LocalDatabase.swift
//  tasksTown
//
//  Created by Bradley Austin on 22/10/2024.
//

import Foundation
import GRDB

struct LocalDatabase {

    let writer: DatabaseWriter

    init(_ writer: DatabaseWriter) throws {
        self.writer = writer
        try migrator.migrate(writer)
    }

    var reader: DatabaseReader {
        writer
    }
}

// MARK: - Writes
extension LocalDatabase {
    func insertTestData(
        name: String
    ) async throws {
        try await writer.write { db in
            let test = Test(name: name)
            try test.insert(db)
            print("Inserted test data")
        }
    }
}
