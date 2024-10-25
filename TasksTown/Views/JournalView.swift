//
//  JournalView.swift
//  TasksTown
//
//  Created by Bradley Austin on 25/10/2024.
//

import SwiftUI

struct JournalView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ScrollView(.horizontal) {
                        HStack(spacing:15) {
                            Button {} label: {
                                Label("Today", systemImage: "clock.fill")
                            }
                            Button {} label: {
                                Label("Tasks", systemImage: "checkmark")
                            }
                            Button {} label: {
                                Label("Calendar", systemImage: "calendar")
                            }
                            ForEach(1..<4) { tag in
                                Button {} label: {
                                    Label("Tag \(tag)", systemImage: "tag.fill")
                                }
                            }
                        }
                        .foregroundStyle(.foreground)
                    }
                    .safeAreaPadding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.ultraThickMaterial)
                    )
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                }
                .listRowSeparator(.hidden)
                .listSectionSpacing(20)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                Section {
                    ForEach(0..<4) { _ in
                        NavigationLink {
                            Text("Hello")
                        } label: {
                            HStack(spacing: 7) {
                                Image(systemName: "circle")
                                    .font(.title2)
                                VStack(alignment:.leading) {
                                    Text("Task")
                                        .font(.headline)
                                    HStack(spacing: 5) {
                                        Image(systemName: "calendar")
                                            .font(.title2)
                                        Text("Due Tomorrow")
                                    }
                                }
                                Spacer()
                                Menu {

                                } label: {
                                    HStack {
                                        Image(systemName: "exclamationmark.2")
                                        Text("Yellow")
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.vertical,10)
                                    .frame(width: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.yellow.gradient.opacity(0.8))
                                    )
                                }
                            }
                            .padding(0)
                            .padding(.vertical,-5)
                        }
                    }
                } header: {
                    HStack(alignment:.center) {
                        Image(systemName: "checkmark")
                        Text("Tasks & Events")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Text("For Today")
                            .font(.headline)
                        NavigationLink("View All") {
                            
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .headerProminence(.increased)
                
                Section {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 200)
                        .foregroundStyle(.gray)
                        .overlay(
                            Text("Picture")
                        )
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 200)
                        .foregroundStyle(.gray)
                        .overlay(
                            ZStack {
                                Text("Video")
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(
                                        LinearGradient(stops: [
                                            Gradient.Stop(color: .clear, location: 0.65),
                                            Gradient.Stop(color: .black.opacity(0.5), location: 0.95),
                                        ], startPoint: .top, endPoint: .bottom)
                                    )
                                VStack(alignment:.leading) {
                                    Spacer()
                                    HStack {
                                        Text("Video 1")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Image(systemName: "play.fill")
                                    }
                                    .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .padding()
                            }
                        )
                } header: {
                    HStack(alignment:.center) {
                        Image(systemName: "bookmark.fill")
                        Text("Saved")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Text("For Today")
                            .font(.headline)
                        NavigationLink("View All") {
                            
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .headerProminence(.increased)
                
            }
            .navigationTitle("Journal")
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
            .listSectionSpacing(.compact)
        }
    }
}

#Preview {
    JournalView()
}
