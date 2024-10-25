//
//  DatabaseAccessTest.swift
//  tasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import SwiftUI
import GRDBQuery
import GRDB

struct DatabaseAccessTest: View {
    @State var name: String = ""
    @Query(TestsRequest()) var tests: [Test]
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
    static var defaultValue: [Test] { [] }

    func fetch(_ db: Database) throws -> [Test] {
        try Test.fetchAll(db)
    }
}

#Preview {
    DatabaseAccessTest()
}
