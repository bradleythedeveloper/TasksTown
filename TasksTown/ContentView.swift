//
//  ContentView.swift
//  TasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Hello, World!")
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book.pages.fill")
                }
            DatabaseAccessTest()
                .tabItem {
                    Label("Test", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    ContentView()
        .databaseContext(.readWrite { LocalDatabase.database.writer })
}
