//
//  +Migrator.swift
//  tasksTown
//
//  Created by Bradley Austin on 22/10/2024.
//

import Foundation
import GRDB

extension LocalDatabase {
    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif

        // First migration
        // Creating all original tables
        migrator.registerMigration("v1.0") { db in
            try createUserTable(db)
            try createTestTable(db)
        }

        return migrator

    }
    
    private func createUserTable(_ db: Database) throws {
        try db.create(table: "user") { table in
            // The "user" table is a single row table.
            // Any inserts will replace the row rather than create a new one
            table.primaryKey("id", .integer, onConflict: .replace)
                .check { $0 == 1 } // the ID column will always be 1
            table.column("isEmpty", .boolean)
            table.column("username", .text).notNull()
            table.column("firstName", .text).notNull()
            table.column("lastName", .text).notNull()
            //table.column("email", .text).notNull()
        }
    }
    
    private func createTestTable(_ db: Database) throws {
        try db.create(table: "test") { table in
            table.column("name", .text).notNull()
        }
    }
}
