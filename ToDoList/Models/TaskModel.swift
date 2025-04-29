//
//  TaskModel.swift
//  ToDoList
//
//  Created by Алеся Афанасенкова on 04.04.2025.
//

import Foundation
import RealmSwift

struct Task {
    let id: String
    let catagory: Catagory
    let caption: String
    let createdData: Date
    var isComplited: Bool
}

class LocalTask: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var catagory = Catagory.study
    @Persisted var caption = ""
    @Persisted var createdDate = Date()
    @Persisted var isComplited = false
    
}
