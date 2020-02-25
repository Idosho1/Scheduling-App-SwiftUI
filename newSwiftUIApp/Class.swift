//
//  Class.swift
//  ScheduleAppSwiftUI
//
//  Created by Ido Shoshani on 9/21/19.
//  Copyright © 2019 Ido Shoshani. All rights reserved.

import Foundation
import SwiftUI

struct Class: Hashable {
    let roomNumber: String
    let courseName: String
    let semester: String
    let timeStart: String
    let timeEnd: String
    let block: String
}

struct ScheduleObject {
    var schedule:[Day:[Class]]
    var userName: String
}

class Homework: Identifiable, Hashable, ObservableObject {
    static func == (lhs: Homework, rhs: Homework) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let dueDate: Date
    let name: String
    let cls: Class
    var complete: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(name: String, cls: Class, dueDate: Date) {
        self.name = name
        self.cls = cls
        self.dueDate = dueDate
    }
}


