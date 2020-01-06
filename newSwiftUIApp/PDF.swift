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

let pdf = PDFDocument(url: URL(fileURLWithPath: "/Users/ido/Desktop/test4.pdf"))
var text = (pdf?.string)!

func splitStringIntoParts(_ expression: String) -> [String] {
    return expression.split{$0 == " "}.map{ String($0) }
}
func splitStringIntoLines(_ expression: String) -> [String] {
    return expression.split{$0 == "\n"}.map{ String($0) }
}

func printText() {
    print(splitStringIntoLines((pdf?.string)!))
}

enum Day {
    case Mon, Tue, Wed, Thu, Fri
}

var dayBlocks = [Day.Mon : ["A1 7:40 8:35", "B1 8:40 9:35", "adv 9:40 9:45", "C1 9:50 10:45", "D1 10:50 12:35", "E1 12:40 1:35", "F1 1:40 2:35", "J1 2:40 3:20"], Day.Tue : ["G1 7:40 8:35", "F2 8:40 9:35", "adv 9:40 10:05", "C2 10:10 11:05", "E2 11:10 12:55", "D2 1:00 1:55"], Day.Wed : ["A2 7:40 8:55", "B2 9:00 9:55", "G2 10:00 10:55", "F3 11:00 12:45", "D3 12:50 1:45", "E3 1:50 2:45", "J2 2:50 3:20"], Day.Thu : ["A3 7:40 8:35", "B3 8:40 9:35", "adv 9:40 9:45", "F4 9:50 10:45", "G3 10:50 12:35", "E4 12:40 1:35", "C3 1:40 2:35", "J3 2:40 3:20"], Day.Fri : ["A4 7:40 8:35", "B4 8:40 9:55", "adv 10:00 10:05", "G4 10:10 11:05", "C4 11:10 12:55", "D4 1:00 1:55"]]

struct PDF {
    var schedule: [Day:[Class]] = [Day.Mon:[],Day.Tue:[],Day.Wed:[],Day.Thu:[],Day.Fri:[]]
    var currentSchedule = ScheduleObject(schedule: [:], userName: "")
    var generalInfoLine: String
    var splitInfo: [String]
    var classList: [Class]
    var uniqueClassList: [Class]
    var pdfFile: PDFDocument //= PDFDocument(url: URL(fileURLWithPath: "/Users/ido/Desktop/test.pdf"))!
    var pdfAsText: String
    var textArray: [String]
    var classColors: [String:UIColor] = [:]
    
    init(_ pdfURL: String) {
        pdfFile = PDFDocument(url: URL(string: pdfURL)!)!
        pdfAsText = (pdfFile.string)!
        classList = []
        uniqueClassList = []
        textArray = splitStringIntoLines(pdfAsText)
        generalInfoLine = textArray[1]
        splitInfo = splitStringIntoParts(generalInfoLine)
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
    
    func containsClass(day: Day, cls: Class) -> Bool {
        let classes = schedule[day]!
        for n in classes {
            if n.courseName == cls.courseName {
                return true
            }
        }
        return false
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
        currentSchedule.schedule = schedule
        currentSchedule.userName = returnName()
    }
    
    mutating func restore() {
        let classString = rwt.readFile(fileName: "Save6")
        //print(classString)
        let classArray = splitStringIntoLines(classString)
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
        
        let classColorsString = rwt.readFile(fileName: "SaveColors6")
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
        
    }
    
    mutating func makeClassArray() -> [Class] {
        var end = 9
        var i = 4
        
        while i <= textArray.count - end {
            if Int((textArray[i].trimmingCharacters(in: .whitespaces))[0]) != nil {

            let infoLine = textArray[i+1]
                
                if !infoLine.contains(",") {
                    textArray[i+1] += " \(textArray[i+2])"
                    textArray.remove(at: i+2)
                    end += 1
                }
            }
            i += 2
        }
        
        var index = 4
            repeat {
            if Int((textArray[index].trimmingCharacters(in: .whitespaces))[0]) != nil {
            let timeLine = textArray[index]
            let time = timeLine.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "-", with: " ")
            let timeStart = splitStringIntoParts(time)[0]
            let timeEnd = splitStringIntoParts(time)[1]
            let infoLine = textArray[index+1]
            let infoArray = splitStringIntoParts(infoLine)
                //print(infoLine)
                //print(infoArray)
                let semester = infoArray[0].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                //print(semester)
                var courseName = ""
                var block = ""
                
                var ind = 1
                var newArray: [String] = []
                
                //print(infoArray)
                repeat {
                    newArray.append(infoArray[ind])
                    ind += 1
                } while(!infoArray[ind].contains(",") && ind != infoArray.count-1)
                //print(newArray)
                
                
                if newArray[0] != "Advisory/HR" {
                while(!((newArray[newArray.count-1]).count <= 2) && !doStringContainsNumber(_string: newArray[newArray.count-1])) {
                    newArray.remove(at: newArray.count-1)
                    //print(newArray)
                }
                    newArray = newArray.filter {$0 != "-"}
                    //print(newArray)
                    
                    block = newArray[newArray.count-1].replacingOccurrences(of: "-", with: "")
                    newArray.remove(at: newArray.count-1)
                    //print(newArray)
                    for n in newArray {
                        courseName += " \(n)"
                    }
                
                    courseName = courseName[1..<courseName.count]
                }
                else {
                    courseName = "Advisory/HR"
                    block = "adv"
                }
                
                 /*PRINTING INFO FOR EACH CLASS FOR TESTING
                print(courseName)
                print(timeStart)
                print(timeEnd)
                print(infoArray[infoArray.count-1])
                print(block)
                print("\n")
                */
    
                let classroom = Class(roomNumber: infoArray[infoArray.count-1], courseName: courseName, semester: semester, timeStart: timeStart, timeEnd: timeEnd, block: block)
                classList.append(classroom)
            }
                index += 2
            } while(index <= textArray.count - end - 1)
        
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
        rwt.writeFile(writeString: saveString, fileName: "Save6")
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
        rwt.writeFile(writeString: saveString, fileName: "SaveColors6")
    }
    
    
/* mutating func makeBlockDict() {
        let classArray = makeClassArray()
        var blockDict: [Character: Class]
        for Class in classArray {
            blockDict[Class.block] = Class
        }
    }*/
    
}
