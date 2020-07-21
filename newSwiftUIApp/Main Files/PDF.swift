//
//  pdf.swift
//  Schedule App
//
//  Created by Ido Shoshani on 9/16/19.
//  Copyright © 2019 Ido Shoshani. All rights reserved.
//

import Foundation
import UIKit
import PDFKit


struct PDF {
    var schedule: [Day:[Class]] = [Day.Mon:[],Day.Tue:[],Day.Wed:[],Day.Thu:[],Day.Fri:[]]
    var schedule2: [Day:[Class]] = [Day.Mon:[],Day.Tue:[],Day.Wed:[],Day.Thu:[],Day.Fri:[]]
    var currentSchedule = ScheduleObject(schedule: [:], userName: "")
    var generalInfoLine: String
    var splitInfo: [String]
    var classList: [Class]
    var uniqueClassList: [Class]
    //var pdfFile: PDFDocument //= PDFDocument(url: URL(fileURLWithPath: "/Users/ido/Desktop/test.pdf"))!
    var pdfAsText: String
    var textArrayUnedited: [String]
    var textArray: [String]
    var classColors: [String:UIColor] = [:]
    var homework: [Homework] = []
    var homeworkSaveString: String = ""
    var semester = 1
    var uniqueClassList1: [Class]
    var uniqueClassList2: [Class]
    var notifications = true
    var hour = 19
    var minute = 0
    
    
    
    init(_ pdfFile: PDFDocument) {
        //pdfFile = PDFDocument(url: URL(string: pdfURL)!)!
        pdfAsText = (pdfFile.string)!
        classList = []
        uniqueClassList = []
        uniqueClassList1 = []
        uniqueClassList2 = []
        textArrayUnedited = splitStringIntoLines(pdfAsText)
        textArray = []
        for n in textArrayUnedited {
            if n.trimmingCharacters(in: .whitespaces) == "1" {
                break
            }
            textArray.append(n)
        }
        print("&&&&&")
        print(textArray)
        print("&&&&&")
        generalInfoLine = textArray[1]
        splitInfo = splitStringIntoParts(generalInfoLine)
        print(textArray)
    }
    
    init() {
        pdfAsText = ""
        classList = []
        textArrayUnedited = []
        uniqueClassList = []
        uniqueClassList1 = []
        uniqueClassList2 = []
        textArray = []
        generalInfoLine = ""
        splitInfo = []
    }
    
    mutating func toggleSemester() {
        if semester == 1 {semester = 2}
        else {semester = 1}
    }
    
    
    
    static func intToDay(i: Int) -> String {
        switch i {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return ""
        }
    }
    
    func returnName() -> String {
        return splitInfo[1] + " \((splitInfo[0]).dropLast())"
    }
    
    func returnGrade() -> Int {
        return Int(splitInfo[3])!
    }
    
    func returnHomeroom() -> Int {
        return Int(splitInfo[5].dropLast())!
    }
    
    func returnID() -> Int {
        return Int(splitInfo[7])!
    }
    
    
    
    func containsC(day: Day, cls: Class) -> Bool {
        if semester == 1 {
        let classes = schedule[day]!
        for n in classes {
            if n.courseName == cls.courseName {
                return true
            }
        }
        return false
        }
        else {
            let classes = schedule2[day]!
            for n in classes {
                if n.courseName == cls.courseName {
                    return true
                }
            }
            return false
        }
    }
    
    func containsClass(day: Day, cls: Class) -> Bool {
        // DO NOT CHANGE
        let classes = schedule[day]!
        for n in classes {
            if n.courseName == cls.courseName {
                return true
            }
        }
        return false
    }
    
    func getNextDay(_ day: Day) -> Day {
        let currentDay = day
        switch currentDay.rawValue {
            case "Mon": return .Tue
            case "Tue": return .Wed
            case "Wed": return .Thu
            case "Thu": return .Fri
            case "Fri": return .Sat
            case "Sat": return .Sun
            case "Sun": return .Mon
            default: return .Mon
        }
    }
    
    func getCurrentDay() -> Day {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        return Day(rawValue: dayOfTheWeekString)!
    }
    
    func matchFullBlock(_ block: String,_ line: String) -> Bool {
        if block == splitStringIntoParts(line)[0][0] {return true}
        return false
    }
    
    func matchBlock(_ block: String,_ line: String) -> Bool {
        if block == splitStringIntoParts(line)[0] {return true}
        return false
    }
    
    func matchStart(_ start: String,_ line: String) -> Bool {
        if start == splitStringIntoParts(line)[1] {return true}
        return false
    }
    
    func matchEnd(_ end: String,_ line: String) -> Bool {
        if end == splitStringIntoParts(line)[2] {return true}
        return false
    }
    
    mutating func makeSchedule() {
        var classes = makeClassArray()
        makeUniqueClassList()
        for cls in classes {

            //if cls.semester != "S2" { // SEMESTER 2 FIX LATER
                print("***")
                print(cls.semester)
                print("***")
            let block = cls.block
            let start = cls.timeStart
            let end = cls.timeEnd
            if block.count == 1 {
                for (day, blocks) in dayBlocks {
                    for line in blocks {
                    if matchFullBlock(block, line) && matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls) {
                        schedule[day]!.append(cls)
                    }
                }
                }
            }
            else if block.count == 2 {
                for (day, blocks) in dayBlocks {
                    for line in blocks {
                    if matchBlock(block, line) && matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls)  {
                        schedule[day]!.append(cls)
                    }
                }
                }
            }
            else if block == "adv" {
                for (day, blocks) in dayBlocks {
                    for line in blocks {
                if matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls)  {
                    schedule[day]!.append(cls)
                }
            }
            }
            }
            else if block.count == 3 {
                for (day, blocks) in dayBlocks {
                    for line in blocks {
                        if matchBlock(block[0..<2], line) && matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls)  {
                        schedule[day]!.append(cls)
                    }
                    if matchBlock(block[0] + block[2], line) && matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls)  {
                        schedule[day]!.append(cls)
                    }
                }
                }
            }
        }
        //}//END
        
        schedule2 = schedule
        
        /*for (d,ca) in schedule {
            var i = 0
            var count = ca.count
            
            while i < count {
                if ca[i].semester == "S2" {
                    schedule[d]!.remove(at: i)
                    //i -= 1
                    count -= 1
                }
                i += 1
            }
        }*/
        
        for (d,ca) in schedule {
            
            var i = 0
            
            while i < schedule[d]!.count {
                if schedule[d]![i].semester == "S2" {
                    schedule[d]!.remove(at: i)
                } else {
                    i += 1
                }
            }
            
        }
        
        // START --------------------------------------------------
        
        /*for (d,ca) in schedule2 {
            var i = 0
            var count = ca.count
            
            while i < count {
                if ca[i].semester == "S1" {
                    schedule2[d]!.remove(at: i)
                    //i -= 1
                    count -= 1
                }
                i += 1
            }
        }*/
        
        
        for (d,ca) in schedule2 {
            
            var i = 0
            
            while i < schedule2[d]!.count {
                if schedule2[d]![i].semester == "S1" {
                    schedule2[d]!.remove(at: i)
                } else {
                    i += 1
                }
            }
            
        }
        
        //currentSchedule.schedule = schedule
        //currentSchedule.userName = returnName()
        
        
    }
    
    
    
    
    
    mutating func restore() {

        restoreSemester()
        restoreNotifications()
        restoreDate()
 
        let classString = rwt.readFile(fileName: "Save15")
        let classArray = splitStringIntoLines(classString)
        self.generalInfoLine = classArray[0]
        self.splitInfo = splitStringIntoParts(generalInfoLine)
        for n in stride(from: 1, to: classArray.count-1, by: 6) {
            let newClass = Class(roomNumber: classArray[n+4], courseName: classArray[n+1], semester: classArray[n], timeStart: classArray[n+2], timeEnd: classArray[n+3], block: classArray[n+5])
            classList.append(newClass)
        }
        print(classList)
        
        
        makeUniqueClassList()
        schedule[.Sat] = []
        schedule[.Sun] = []
        schedule2[.Sat] = []
        schedule2[.Sun] = []
        for cls in classList {
            //if cls.semester != "S2" { // SEMESTER 2 FIX LATER
            let block = cls.block
            let start = cls.timeStart
            let end = cls.timeEnd
            if block.count == 1 {
                for (day, blocks) in dayBlocks {
                    for line in blocks {
                    if matchFullBlock(block, line) && matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls) {
                        schedule[day]!.append(cls)
                    }
                }
                }
            }
            else if block.count == 2 {
                for (day, blocks) in dayBlocks {
                    for line in blocks {
                    if matchBlock(block, line) && matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls)  {
                        schedule[day]!.append(cls)
                    }
                }
                }
            }
            else if block == "adv" {
                for (day, blocks) in dayBlocks {
                    for line in blocks {
                if matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls)  {
                    schedule[day]!.append(cls)
                }
            }
            }
            }
            else if block.count == 3 {
                for (day, blocks) in dayBlocks {
                    for line in blocks {
                        if matchBlock(block[0..<2], line) && matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls)  {
                        schedule[day]!.append(cls)
                    }
                    if matchBlock(block[0] + block[2], line) && matchStart(start, line) && matchEnd(end, line) && !containsClass(day: day, cls: cls)  {
                        schedule[day]!.append(cls)
                    }
                }
                }
            }
        }
    //}
        
        /*for (d,ca) in schedule {
            var clsArray = [Class]()
            for cls in ca {
                if cls.semester != "S1" {
                    clsArray.append(cls)
                }
            }
            schedule2[d] = clsArray
        }*/
        
        
        schedule2 = schedule
        print("Schedule 2 before change")
        print(schedule2)
        
        
        /*for (d,ca) in schedule {
            var i = 0
            var count = ca.count
            
            while i < count {
                if ca[i].semester == "S2" {
                    schedule[d]!.remove(at: i)
                    //i -= 1
                    count -= 1
                }
                i += 1
            }
        }*/
        
        for (d,ca) in schedule {
            
            var i = 0
            
            while i < schedule[d]!.count {
                if schedule[d]![i].semester == "S2" {
                    schedule[d]!.remove(at: i)
                } else {
                    i += 1
                }
            }
            
        }
        
        // START --------------------------------------------------
        
        /*for (d,ca) in schedule2 {
            var i = 0
            var count = ca.count
            
            while i < count {
                if ca[i].semester == "S1" {
                    schedule2[d]!.remove(at: i)
                    //i -= 1
                    count -= 1
                }
                i += 1
            }
        }*/
        
        
        for (d,ca) in schedule2 {
            
            var i = 0
            
            while i < schedule2[d]!.count {
                if schedule2[d]![i].semester == "S1" {
                    schedule2[d]!.remove(at: i)
                } else {
                    i += 1
                }
            }
            
        }
        
        //currentSchedule.schedule = schedule
        //currentSchedule.userName = returnName()
        
        
        // END ----------------------------------------------------
        
        print("Schedule2")
        print(schedule2)
        
        
        for (day,classes) in schedule {
            print("\(day)\n")
            print(classes)
        }
        
        let classColorsString = rwt.readFile(fileName: "SaveColors13")
        let classColorsArray = splitStringIntoLines(classColorsString)
        print(classColorsArray)
        for n in stride(from: 0, to: classColorsArray.count-1, by: 2) {
            let cls = classColorsArray[n]
            let colorParts = splitStringIntoParts(classColorsArray[n+1])
            let color = UIColor(red: CGFloat(Double(colorParts[1])!), green: CGFloat(Double(colorParts[2])!), blue: CGFloat(Double(colorParts[3])!), alpha: CGFloat(Double(colorParts[4])!))
            classColors[cls] = color
            print(cls)
            print(color)
            print(classColors)
        }
        
        print(classColors)
        restoreHomework()
        print(homework)
    }
    
     
    
    mutating func makeClassArray() -> [Class] {
        print("TEXT ARRAY: \(textArray)")
        
        //FIX PLEASE
        var newTextArray = [String]()
        
        for n in 0...3 {
            newTextArray.append(textArray[n])
        }
        
        //for n in stride(from: 4, to: textArray.count-2, by: 2) {
            
            var n = 4
            
            while n <= textArray.count-2 {
            
            let timeLine = textArray[n].trimmingCharacters(in: .whitespaces)
            var infoLine = textArray[n+1]
            
            if n+2 <= textArray.count-1 {
                let nextTimeLine = textArray[n+2].trimmingCharacters(in: .whitespaces)
                if !nextTimeLine[0].isInt {
                    infoLine += " \(nextTimeLine)"
                    n += 1
                }
                
    
            }
            
            newTextArray.append(timeLine)
            newTextArray.append(infoLine)
            n += 2
            }
            
        print("****")
        print(newTextArray)
        print("****")
        //}
        
        textArray = newTextArray
        
        
        var index = 4
            repeat {
            if Int((textArray[index].trimmingCharacters(in: .whitespaces))[0]) != nil {
            let timeLine = textArray[index]
            let time = timeLine.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "-", with: " ")
            let timeStart = splitStringIntoParts(time)[0]
            let timeEnd = splitStringIntoParts(time)[1]
            let infoLine = textArray[index+1]
            let infoArray = splitStringIntoParts(infoLine)
                
                print("Time Line: \(timeLine)")
                print("Info Line: \(infoLine)")

                let semester = infoArray[0].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")

                var courseName = ""
                var block = ""
                
                var ind = 1
                var newArray: [String] = []
                
                repeat {
                    newArray.append(infoArray[ind])
                    ind += 1
                } while(!infoArray[ind].contains(",") && ind != infoArray.count-1)
                
                
                if newArray[0] != "Advisory/HR" {
                while(!((newArray[newArray.count-1]).count <= 2) && !doStringContainsNumber(_string: newArray[newArray.count-1])) {
                    newArray.remove(at: newArray.count-1)
                }
                    newArray = newArray.filter {$0 != "-"}
                    
                    block = newArray[newArray.count-1].replacingOccurrences(of: "-", with: "")
                    newArray.remove(at: newArray.count-1)

                    for n in newArray {
                        courseName += " \(n)"
                    }
                
                    courseName = courseName[1..<courseName.count]
                }
                else {
                    courseName = "Advisory/HR"
                    block = "adv"
                }
                
                let classroom = Class(roomNumber: infoArray[infoArray.count-1], courseName: courseName, semester: semester, timeStart: timeStart, timeEnd: timeEnd, block: block)
                classList.append(classroom)
            }
                index += 2
            } while(index <= textArray.count - 1)
        
        //print(classList)
        var saveString = "\(returnName()), \(returnGrade()) \(returnHomeroom()) \(returnID())\n"
        for Class in classList {
            saveString += "\(Class.semester)\n"
            saveString += "\(Class.courseName)\n"
            saveString += "\(Class.timeStart)\n"
            saveString += "\(Class.timeEnd)\n"
            saveString += "\(Class.roomNumber)\n"
            saveString += "\(Class.block)\n"
        }
        //print(saveString)
        rwt.writeFile(writeString: saveString, fileName: "Save15")
        //writeTextFile("abc", data: saveString)
        print(saveString)
        //restore()
        return classList
    }
    
    mutating func makeUniqueClassList() {
        var uniqueS = [String]()
        var uniqueC = [Class]()
        for c in classList {
            if !(uniqueS.contains(c.courseName)) {
                uniqueS.append(c.courseName)
                uniqueC.append(c)
            }
        }
        uniqueClassList = uniqueC
        
        var uniqueC1 = [Class]()
        for c in uniqueC {
            if c.semester == "S1" || c.semester == "FY" {
                uniqueC1.append(c)
            }
        }
        uniqueClassList1 = uniqueC1
        
        
        var uniqueC2 = [Class]()
        for c in uniqueC {
            if c.semester == "S2" || c.semester == "FY" {
                uniqueC2.append(c)
            }
        }
        uniqueClassList2 = uniqueC2
    }
    
}
