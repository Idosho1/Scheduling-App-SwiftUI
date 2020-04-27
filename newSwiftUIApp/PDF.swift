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


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}


extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

func readTextFile(_ path: String) -> (message: String?, fileText: String?) {
    let text: String
    do {
        text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }
    catch {
        return ("\(error)", nil)
    }
    return(nil, text)
}

func writeTextFile(_ path: String, data: String) -> String? {
    let url = NSURL.fileURL(withPath: path)
    do {
        try data.write(to: url, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        return "Failed writing to URL: \(url), Error: " + error.localizedDescription
    }
    return nil
}

func doStringContainsNumber( _string : String) -> Bool{

let numberRegEx  = ".*[0-9]+.*"
let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
    let containsNumber = testCase.evaluate(with: _string)

return containsNumber
}

extension String {

  subscript (i: Int) -> String {
    return self[i ..< i + 1]
  }

  func substring(fromIndex: Int) -> String {
    return self[min(fromIndex, count) ..< count]
  }

  func substring(toIndex: Int) -> String {
    return self[0 ..< max(0, toIndex)]
  }

  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                        upper: min(count, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }

}


func splitStringIntoParts(_ expression: String) -> [String] {
    return expression.split{$0 == " "}.map{ String($0) }
}
func splitStringIntoLines(_ expression: String) -> [String] {
    return expression.split{$0 == "\n"}.map{ String($0) }
}



enum Day: String {
    case Mon = "Mon"
    case Tue = "Tue"
    case Wed = "Wed"
    case Thu = "Thu"
    case Fri = "Fri"
    case Sat = "Sat"
    case Sun = "Sun"
}

var dayBlocks = [Day.Mon : ["A1 7:40 8:35", "B1 8:40 9:35", "adv 9:40 9:45", "C1 9:50 10:45", "D1 10:50 12:35", "E1 12:40 1:35", "F1 1:40 2:35", "J1 2:40 3:20"], Day.Tue : ["G1 7:40 8:35", "F2 8:40 9:35", "adv 9:40 10:05", "C2 10:10 11:05", "E2 11:10 12:55", "D2 1:00 1:55"], Day.Wed : ["A2 7:40 8:55", "B2 9:00 9:55", "G2 10:00 10:55", "F3 11:00 12:45", "D3 12:50 1:45", "E3 1:50 2:45", "J2 2:50 3:20"], Day.Thu : ["A3 7:40 8:35", "B3 8:40 9:35", "adv 9:40 9:45", "F4 9:50 10:45", "G3 10:50 12:35", "E4 12:40 1:35", "C3 1:40 2:35", "J3 2:40 3:20"], Day.Fri : ["A4 7:40 8:35", "B4 8:40 9:55", "adv 10:00 10:05", "G4 10:10 11:05", "C4 11:10 12:55", "D4 1:00 1:55"]]

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
    
    init(_ pdfFile: PDFDocument) {
        //pdfFile = PDFDocument(url: URL(string: pdfURL)!)!
        pdfAsText = (pdfFile.string)!
        classList = []
        uniqueClassList = []
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
        textArray = []
        generalInfoLine = ""
        splitInfo = []
    }
    
    func findHWIndex(dueDate: Date) -> Int {
        var n = 0
        
        while n<homework.count {
            if dueDate < homework[n].dueDate {
                n += 1
            }
            else {return n}
            print("!!")
        }
        
        return n
    }
    
    mutating func addHW(name: String, cls: Class, dueDate: Date, test: Bool = false) {
        homework.insert(Homework(name: name, cls: cls, dueDate: dueDate, test: test), at: findHWIndex(dueDate: dueDate))
        
        let hwArray = splitStringIntoLines(homeworkSaveString)
        if !hwArray.contains(name) {
            homeworkSaveString += "\(name)\n\(cls.courseName)\n\(dueDate)\n\(test)\n"
        rwt.writeFile(writeString: homeworkSaveString, fileName: "saveHW15")
        }
    }
    
    //mutating func addHWInt(name: String, cls: Class, dueDate: Date) {
    //    homework.insert(Homework(name: name, cls: cls, dueDate: dueDate), at: findHWIndex(dueDate: dueDate))
    //}
    
    mutating func deleteHW(name: String) {
        for n in 0..<homework.count {
            if homework[n].name == name {
                homework[n].complete = true
                updateHW()
                break
                //homework.remove(at: n)
            }
        }
        
    }
    
    func numberHWDueTomorrow() -> Int {
        var sum = 0
        
        for hw in homework {
            if !hw.test && Calendar.current.isDateInTomorrow(hw.dueDate) {
                sum += 1
            }
        }
        return sum
    }
    
    func numberTestsDueTomorrow() -> Int {
        var sum = 0
        
        for hw in homework {
            if hw.test && Calendar.current.isDateInTomorrow(hw.dueDate) {
                sum += 1
            }
        }
        return sum
    }
    
    mutating func updateHW() {
        var hwStringArray = splitStringIntoLines(homeworkSaveString)
        var removeHWNames: [String] = []
        
        /*for n in 0..<homework.count {
            if homework[n].complete {
                removeHWNames.append(homework[n].name)
                homework.remove(at: n)
            }
        }*/
        var n = 0
        
        while n<homework.count {
            if homework[n].complete {
                removeHWNames.append(homework[n].name)
                homework.remove(at: n)
            }
            n += 1
        }
        
        
        var i = 0
        
        while i<hwStringArray.count-3 {
            if removeHWNames.contains(hwStringArray[i]) {
                hwStringArray.remove(at: i)
                hwStringArray.remove(at: i)
                hwStringArray.remove(at: i)
                hwStringArray.remove(at: i)
            }
            i += 4
        }
        
        homeworkSaveString = ""
        
        for n in hwStringArray {
            homeworkSaveString += "\(n)\n"
        }
        
        rwt.writeFile(writeString: homeworkSaveString, fileName: "saveHW15")
        
        var newHW = [Homework]()
        var hwNames = [String]()
        
        for n in homework {
            if !hwNames.contains(n.name) {
                hwNames.append(n.name)
                newHW.append(n)
            }
        }
        
        self.homework = newHW
        
        
        
        print(homework)
        print(newHW)
        print(rwt.readFile(fileName: "saveHW15"))
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
    
    func getNextClassDate(_ cls: Class) -> Date {
        var cont = true
        var day = getNextDay(getCurrentDay())
        var numDays = 0
        
        while cont {
            numDays += 1
            //if getCurrentDay() == .Fri {numDays += 2}
            //if getCurrentDay() == .Sat {numDays += 1}
            if containsClass(day: day, cls: cls) {
                cont = false
                return Date().addingTimeInterval(Double(86400 * numDays))
            }
            let nd = getNextDay(day)
            day = nd
            print(day)
        }
    }
    
    func containsClass(day: Day, cls: Class) -> Bool {
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
        
        for (d,ca) in schedule {
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
        }
        
        for (d,ca) in schedule2 {
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
        }
        
        for (d,ca) in schedule {
            var clsArray = [Class]()
            for cls in ca {
                if cls.semester != "S1" {
                    clsArray.append(cls)
                }
            }
            schedule2[d] = clsArray
        }
        
        currentSchedule.schedule = schedule
        currentSchedule.userName = returnName()
    }
    
    mutating func restore() {
        let classString = rwt.readFile(fileName: "Save9")
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
        
        
        for (d,ca) in schedule {
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
        }
        
        for (d,ca) in schedule2 {
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
        }
        
        currentSchedule.schedule = schedule
        currentSchedule.userName = returnName()
        
        
        
        
        
        
        
        for (day,classes) in schedule {
            print("\(day)\n")
            print(classes)
        }
        
        let classColorsString = rwt.readFile(fileName: "SaveColors9")
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
    
    func getCurrentTime() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        print(hour)
        return (60*hour + minutes)
    }
    
    func getCurrentClassIndex() -> Int {
        let classArray = schedule[getCurrentDay()]!
        var i = 0
        while i < classArray.count {
            let ct = getCurrentTime()
            
            let e = classArray[i].timeEnd.replacingOccurrences(of: ":", with: " ")
            let split = splitStringIntoParts(e)
            var eHR = Int(split[0])!
            if eHR >= 1 && eHR <= 3 {eHR += 12}
            let eMin = Int(split[1])!
            
            if (ct - (60*eHR+eMin)) > 0 {
                i += 1
            } else {return i}
        }
        return i - 1
    }
    
    func findTimeIndex() -> Int {
        let currentTime = getCurrentTime()
        let startTimeString = schedule[getCurrentDay()]![getCurrentClassIndex()].timeStart
        let e = startTimeString.replacingOccurrences(of: ":", with: " ")
        let split = splitStringIntoParts(e)
        var eHR = Int(split[0])!
        if eHR >= 1 && eHR <= 3 {eHR += 12}
        let eMin = Int(split[1])!
        let startTime = (60*eHR+eMin)
        
        let diff = currentTime - startTime
        
        return Int(round(Double(diff)/5.0))
    }
    
    func currentBlock() -> String {
        return schedule[getCurrentDay()]![getCurrentClassIndex()].block
    }
    
    /*mutating func restore() {
        let classString = rwt.readFile(fileName: "Save9")
        let classArray = splitStringIntoLines(classString)
        textArray = classArray
        self.generalInfoLine = classArray[0]
        for n in stride(from: 1, to: classArray.count-1, by: 6) {
            let newClass = Class(roomNumber: classArray[n+4], courseName: classArray[n+1], semester: classArray[n], timeStart: classArray[n+2], timeEnd: classArray[n+3], block: classArray[n+5])
            classList.append(newClass)
        }
        print(classList)
        makeSchedule()
        for (day,classes) in schedule {
            print("\(day)\n")
            print(classes)
        }
        
        let classColorsString = rwt.readFile(fileName: "SaveColors9")
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
        
    }*/
    
    func getScrollValue() -> Int {
        print("***********")
        print(UIScreen.screenHeight)
        print("***********")
        
        let h = UIScreen.screenHeight
        
        if getCurrentTime() > schedule[getCurrentDay()]![getCurrentClassIndex()].getEnd() {
            return 0
        }
        
        var ci = getCurrentClassIndex()
        
        if ci == 0 {
            return 0
        }
        
        var totalLength = 0
        
        
        if ci == schedule[getCurrentDay()]!.count-1 {
            //totalLength -= 41
            totalLength -= Int(h/21.85365854)
            
            //TESTED
            if (schedule[getCurrentDay()]![ci].block[0].lowercased() == "j") {
                //totalLength -= 25
                totalLength -= Int(h/35.84)
            }
            
            if h < 896.0 {
                totalLength += 5
            }
        }
        
        
        //TESTED
        if (ci == schedule[getCurrentDay()]!.count-2) && ((schedule[getCurrentDay()]![ci+1].block[0].lowercased() == "j")) {
            //totalLength -= 10
            totalLength -= Int(h/89.6)
        }
        
        
        
        
        for n in 0..<ci {
            totalLength += schedule[getCurrentDay()]![n].getLength()
        }
        
        //return 7 * (totalLength - 10)
        return 7 * (totalLength - Int(h/89.6))
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
        
        
        //CHANGE STARTS NOW
        
        //var end = 9
        //var i = 4
        
        /*while i <= textArray.count - end {
            if Int((textArray[i].trimmingCharacters(in: .whitespaces))[0]) != nil {

            let infoLine = textArray[i+1]
                
                if !infoLine.contains(",") {
                    textArray[i+1] += " \(textArray[i+2])"
                    textArray.remove(at: i+2)
                    end += 1
                }
            }
            i += 2
        }*/
        
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
        rwt.writeFile(writeString: saveString, fileName: "Save9")
        //writeTextFile("abc", data: saveString)
        print(saveString)
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
    }
    
    func saveColors() {
        var saveString = ""
        for (className, color) in classColors {
            saveString += "\(className)\n\(color)\n"
        }
        rwt.writeFile(writeString: saveString, fileName: "SaveColors9")
    }
    
    mutating func restoreHomework() {
        let homeworkSaveArray = splitStringIntoLines(rwt.readFile(fileName: "saveHW15"))
        print(homeworkSaveArray)
        for n in stride(from: 0, to: homeworkSaveArray.count-2, by: 4) {
            let name = homeworkSaveArray[n]
            
            var i = 0
            print("******")
            print(homeworkSaveArray)
            print("******")
            while homeworkSaveArray[n+1] != uniqueClassList[i].courseName {
                i += 1
            }
            
            let cls = uniqueClassList[i]
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZZ"
            let dueDate = df.date(from: homeworkSaveArray[n+2])!
            let test = homeworkSaveArray[n+3]
            
            print("adding hw \(name) for class \(cls.courseName) for date \(dueDate)")
            addHW(name: name, cls: cls, dueDate: dueDate, test: Bool(test)!)
            
        }
    }
    
/* mutating func makeBlockDict() {
        let classArray = makeClassArray()
        var blockDict: [Character: Class]
        for Class in classArray {
            blockDict[Class.block] = Class
        }
    }*/
    
}
