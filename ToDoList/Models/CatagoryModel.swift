//
//  CatagoryModel.swift
//  ToDoList
//
//  Created by Алеся Афанасенкова on 03.04.2025.
//

import Foundation
import UIKit
import RealmSwift

enum Catagory: String, CaseIterable, PersistableEnum {
    case work = "Work", study = "Study", excercise = "Excercise"
    
    
    var color: UIColor {
        switch self {
            
        case .work:
            return UIColor.work1
        case .study:
            return UIColor.study1
        case .excercise:
            return UIColor.excercise1
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .work:
            return UIColor.secondaryWork
        case .study:
            return UIColor.secondaryStudy
        case .excercise:
            return UIColor.secondaryExcercise
        }
    }
}
