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
    
    func getLength() -> Int {
        /*let s = Int(timeStart[0])! * 60 + Int(timeStart[2])! * 10 + Int(timeStart[3])!
        let e = Int(timeEnd[0])! * 60 + Int(timeEnd[2])! * 10 + Int(timeEnd[3])!*/
        let s = timeStart.replacingOccurrences(of: ":", with: " ")
        let split = splitStringIntoParts(s)
        var sHR = Int(split[0])!
        if sHR >= 1 && sHR <= 3 {sHR += 12}
        let sMin = Int(split[1])!
        
        let e = timeEnd.replacingOccurrences(of: ":", with: " ")
        let split2 = splitStringIntoParts(e)
        var eHR = Int(split2[0])!
        if eHR >= 1 && eHR <= 3 {eHR += 12}
        let eMin = Int(split2[1])!
        
        return((eHR-sHR)*60 + (eMin-sMin))
    }
    
    func getEnd() -> Int {
        let e = timeEnd.replacingOccurrences(of: ":", with: " ")
            let split2 = splitStringIntoParts(e)
            var eHR = Int(split2[0])!
            if eHR >= 1 && eHR <= 3 {eHR += 12}
            let eMin = Int(split2[1])!
            
            return((eHR)*60 + (eMin))
    }
    
    func isCurrent() -> Bool {
        return pdfStruct.schedule[pdfStruct.getCurrentDay()]![pdfStruct.getCurrentClassIndex()].courseName == self.courseName
    }
}

struct ScheduleObject {
    var schedule:[Day:[Class]]
    var userName: String
}

class Homework: Identifiable, Hashable, ObservableObject, Equatable {
    
    static func == (lhs: Homework, rhs: Homework) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    var dueDate: Date
    var name: String
    var cls: Class
    let test: Bool
    var complete: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(name: String, cls: Class, dueDate: Date, test: Bool = false) {
        self.name = name
        self.cls = cls
        self.dueDate = dueDate
        self.test = test
    }
}


