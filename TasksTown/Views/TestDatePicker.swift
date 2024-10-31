//
//  TestDatePicker.swift
//  TasksTown
//
//  Created by Bradley Austin on 26/10/2024.
//

import SwiftUI

struct MyDatePicker: View {
    @State private var selectedDate = Date()

    var body: some View {
        
        // Put your own design here
        VStack {
            Text(selectedDate.formatted(.dateTime.day().month().year()))
        }

        // Put the actual DataPicker here with overlay
        .overlay {
            DatePicker(selection: $selectedDate, displayedComponents: .date) {}
                .labelsHidden()
                .colorMultiply(.clear)       // <<< here
        }

    }
}

#Preview {
    MyDatePicker()
}
