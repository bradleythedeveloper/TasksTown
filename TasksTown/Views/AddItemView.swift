//
//  AddItemView.swift
//  TasksTown
//
//  Created by Bradley Austin on 26/10/2024.
//

import SwiftUI
import GRDB
import GRDBQuery

// MARK: - Main View
struct AddItemView: View {
    
    // MARK: - Defining variables
    
    // Environment variables
    @Environment(\.dismiss) var dismiss
    
    // Database connnection
    private let db = LocalDatabase.database
    
    // Type of item being added
    @State var itemType: ItemType = .task
    
    // Parameters applicable across all item types
    @State var date: Date = Date()
    @State var dateType: Item.DateType = .due
    @State var color: Item.PriorityColor = .none
    @State var tag: Tag?
    
    // Intialising objects for each item type
    @State var task = TaskItem(name: "", description: "")
    
    // Configuring whether sub-sheets are shown
    @State var showDateSubSheet = false
    
    @State var testTag: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Item Type Picker
                
                Section {
                    // Item type picker
                    // User chooses what type of item they want to add
                    Picker("", selection: $itemType) {
                        ForEach(ItemType.allCases) { itemType in
                            Text(itemType.name).tag(itemType)
                        }
                    }
                    .pickerStyle(.segmented) // Picker is presented as a slider
                    .listRowSeparator(.hidden)
                }
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                
                // MARK: - Name & Description Section
                
                Section {
                    VStack {
                        if itemType == .task { // If the user is creating a task
                            // TextField for task name
                            TextField("What do you want to do?", text: $task.name, axis: .vertical)
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.top)
                            // TextField for task description
                            TextField("Add a description", text: $task.description, axis: .vertical)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                // MARK: - Other Details Section
                
                Section {
                    // Date DisclosureGroup
                    DisclosureGroup { // Allows the content to be opened and closed
                        VStack {
                            Picker("", selection: $dateType) {
                                ForEach(Item.DateType.allCases) { dateType in
                                    Text(dateType.rawValue).tag(dateType)
                                }
                            }
                            .pickerStyle(.segmented)
                            if dateType != .noDate {
                                DatePicker("Select a date",selection: $date)
                                    .labelsHidden()
                                    .datePickerStyle(.graphical)
                            }
                        }
                    } label: {
                        DetailDisclosureGroupLabel(
                            name: "\(formattedDueDate(dateBinding: $date, dateTypeBinding: $dateType))",
                            systemIcon: "calendar",
                            color: .red
                        )
                    }
                    .padding(.top,5)
                    
                    // Colour DisclosureGroup
                    DisclosureGroup {
                        HStack {
                            VStack(alignment: .trailing) {
                                Text("This \(itemType.rawValue) is important & urgent.") // Red color description
                                    .font(.caption)
                            }
                            ColorSelectButton(color: .red, colorBinding: $color)
                        }
                        HStack {
                            VStack(alignment: .trailing) {
                                Text("This \(itemType.rawValue) is important & not urgent.") // Yellow color description
                                    .font(.caption)
                            }
                            ColorSelectButton(color: .yellow, colorBinding: $color)
                        }
                        HStack {
                            VStack(alignment: .trailing) {
                                Text("This \(itemType.rawValue) is not important & not urgent.") // Green color description
                                    .font(.caption)
                                    .multilineTextAlignment(.trailing)
                                AISuggestionLabel()
                            }
                            ColorSelectButton(color: .green, colorBinding: $color)
                        }
                        ColorSelectButton(color: .none, colorBinding: $color)
                    } label: {
                        HStack {
                            DetailDisclosureGroupLabel(name: "\(color.name)", systemIcon: "\(color.icon)", color: color.color)
                            AISuggestionLabel()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    // Tag DisclosureGroup
                    DisclosureGroup(isExpanded: .constant(true)) {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(
                                    ["School","Work","Family","Friends"], id: \.self
                                ) { tag in
                                    HStack {
                                        Toggle(isOn: Binding(
                                            get: { self.testTag == tag },
                                            set: { isOn in
                                                if isOn {
                                                    self.testTag = tag
                                                }
                                            }
                                        )) {
                                            Text("\(tag)")
                                        }
                                        .toggleStyle(.button)
                                        //.buttonStyle(.borderedProminent)
                                    }
                                }
                                Button("Add Tag") {
                                    
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .scrollIndicators(.never)
                        .foregroundStyle(.foreground)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThickMaterial)
                        }
                        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
                    } label: {
                        DetailDisclosureGroupLabel(name: "\(tag?.name ?? "No Tag")", systemIcon: "tag.fill", color: .teal)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .navigationTitle("Add to Journal")
            .toolbar {
                ToolbarItem(placement:.cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement:.confirmationAction) {
                    Button("Add") {
                        Task {
                            if itemType == .task {
                                await addTask(task: task)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - View Functions
extension AddItemView {
    func addTask(task: TaskItem) async {
        task.dueDate = date
        task.dateType = dateType
        task.color = color
        task.tag = tag
        do {
            try await db.insertTaskItem(task)
            dismiss()
        } catch {
            print(error)
        }
    }
}

// MARK: - General Functions

/// Formats a given date to be printed, based on a given date type
/// - Parameters:
///   - dateBinding: Binding to a Date value
///   - dateTypeBinding: Binding to an Item.DateType value
/// - Returns: Formatted date in the form of a String
func formattedDueDate(dateBinding: Binding<Date>, dateTypeBinding: Binding<Item.DateType>) -> String {
    let date = dateBinding.wrappedValue
    let dateType = dateTypeBinding.wrappedValue
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    if dateType != .noDate {
        return "\(dateType.rawValue) \(formatter.string(from: date))"
    } else {
        return "No Date"
    }
}

// MARK: - Enums

enum ItemType: String, CaseIterable, Identifiable {
    case task, event, habit, photo, link
    var id: Self { self }
    var name: String { self.rawValue.localizedCapitalized }
}

// MARK: - Subviews
struct DetailDisclosureGroupLabel: View {
    var name: String
    var systemIcon: String
    var color: Color
    var body: some View {
        Label {
            Text(name)
        } icon: {
            Image(systemName: systemIcon)
                .foregroundStyle(color.gradient)
        }
    }
}

struct ColorButtonLabel: View {
    var color: Item.PriorityColor
    var body: some View {
        HStack {
            Image(systemName: "\(color.icon)")
            Text(color.name)
        }
        .font(.caption)
        .padding()
        .frame(width: 115)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.color.gradient)
        )
        .foregroundStyle(.white)
    }
}

struct AISuggestionLabel: View {
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "sparkles")
            Text("Suggested by AI")
        }
        .font(.caption)
        .foregroundStyle(.purple.gradient)
    }
}

struct ColorSelectButton: View {
    var color: Item.PriorityColor
    var colorBinding: Binding<Item.PriorityColor>
    var body: some View {
        ColorButtonLabel(color: color)
            .overlay(alignment:.bottomTrailing) {
                if colorBinding.wrappedValue == color {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .padding(5)
                        //.transition(.opacity)
                }
            }
            .onTapGesture {
                withAnimation {
                    colorBinding.wrappedValue = color
                }
            }
    }
}

// MARK: - Styles

struct ColorButtonToggleStyle: ToggleStyle {
    var color: Item.PriorityColor
    func makeBody(configuration: ToggleStyleConfiguration) -> some View {
        HStack {
            Button {
                configuration.isOn = true
            } label: {
                ColorButtonLabel(color: color)
                    .overlay(alignment:.bottomTrailing) {
                        if configuration.isOn {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .padding(5)
                        }
                    }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var showAddItemView = true
    Button("Show Item View") {
        showAddItemView.toggle()
    }
    .sheet(isPresented: $showAddItemView) {
        AddItemView()
            //.presentationDetents([.medium, .large])
            //.presentationDetents([.fraction(0.4)])
    }
}
