//
//  TaskModel.swift
//  ToDoList
//
//  Created by Алеся Афанасенкова on 04.04.2025.
//

import Foundation

struct Task {
    let id: String
    let catagory: Catagory
    let caption: String
    let createdData: Date
    var isComplited: Bool
}
