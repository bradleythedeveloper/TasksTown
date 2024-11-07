//
//  DatabaseAccessTest.swift
//  tasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import SwiftUI
import GRDBQuery
import GRDB

class DBTest: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var name: String
    init(name: String) {
        self.name = name
    }
}

struct DatabaseAccessTest: View {
    @State var name: String = ""
    @Query(TestsRequest()) var tests: [DBTest]
    private let db = LocalDatabase.database
    
    func createTestData() async {
        do {
            try await db.insertTestData(name: name)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        List {
            TextField("Name", text: $name)
            Button("Save") {
                Task {
                    await createTestData()
                }
            }
            ForEach(tests) { test in
                Text(test.name)
            }
        }
    }
}

struct TestsRequest: ValueObservationQueryable {
    static var defaultValue: [DBTest] { [] }

    func fetch(_ db: Database) throws -> [DBTest] {
        try DBTest.fetchAll(db)
    }
}

#Preview {
    DatabaseAccessTest()
}
