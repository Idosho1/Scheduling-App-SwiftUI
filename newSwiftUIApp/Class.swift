//
//  Class.swift
//  ScheduleAppSwiftUI
//
//  Created by Ido Shoshani on 9/21/19.
//  Copyright © 2019 Ido Shoshani. All rights reserved.

import Foundation

struct Class {
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
