//class Test {
//    var text: String
//    var isCompleted: Bool
//}
//
//Test(

import FirebaseCore
import FirebaseFirestore
import SwiftUI

class TaskItem: Item {
    func addToDatabase() {
        let db = Firestore.firestore()
        do {
            let newTaskItemRef = db.collection("taskItems").document()
            try newTaskItemRef.setData(from: self)
            print("Task saved successfully")
        } catch let error {
          print("Error writing task to Firestore: \(error)")
        }
    }
}
