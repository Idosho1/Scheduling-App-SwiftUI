//
//  PDFExtension.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI

extension PDF {
    
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
        //pdfStruct.updateNotifications()
    }
    
    func getNextClassDate(_ cls: Class) -> Date {
        var cont = true
        var day = getNextDay(getCurrentDay())
        var numDays = 0
        
        while cont {
            numDays += 1
            //if getCurrentDay() == .Fri {numDays += 2}
            //if getCurrentDay() == .Sat {numDays += 1}
            if containsC(day: day, cls: cls) {
                cont = false
                return Date().addingTimeInterval(Double(86400 * numDays))
            }
            let nd = getNextDay(day)
            day = nd
            print(day)
        }
    }
    
    mutating func restoreSemester() {
        let semesterString = rwt.readFile(fileName: "semester")
        print("semester string is : \(semesterString)")
        if semesterString == "1" {self.semester = 1}
        else {self.semester = 2}
    }
    
    mutating func restoreDate() {
        let hourString = rwt.readFile(fileName: "hour")
        let minString = rwt.readFile(fileName: "min")
        
        self.hour = Int(hourString)!
        self.minute = Int(minString)!
    }
    
    
    mutating func restoreNotifications() {
        let notificationString = rwt.readFile(fileName: "notification")
        if notificationString == "false" {self.notifications = false}
        else {self.notifications = true}
        
        
        
        
        
        if self.notifications {
            //updateNotifications()
        }
        
        else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
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
        if semester == 1 {
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
        } else {
            let classArray = schedule2[getCurrentDay()]!
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
        if semester == 1 {
        return schedule[getCurrentDay()]![getCurrentClassIndex()].block
        } else {
        return schedule2[getCurrentDay()]![getCurrentClassIndex()].block
        }
    }
    
    func updateNotifications() {
        if notifications {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            
            
            // 1
            var dateComponents = DateComponents()
            dateComponents.hour = self.hour
            dateComponents.minute = self.minute
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            // 2
            let content = UNMutableNotificationContent()
            content.title = "Homework Reminder"
            
            if pdfStruct.numberHWDueTomorrow() == 0 {
                content.body = "You are done with all your homework for tomorrow!"
            } else if pdfStruct.numberHWDueTomorrow() == 1 {
                content.body = "You have 1 homework assignment due tomorrow!"
            } else {
            content.body = "You have " + String(pdfStruct.numberHWDueTomorrow()) + " homework assignments due tomorrow!"
            }
            let randomIdentifier = UUID().uuidString
            let request = UNNotificationRequest(identifier: randomIdentifier, content: content, trigger: trigger)

            if pdfStruct.numberTestsDueTomorrow() != 0 {
                let content2 = UNMutableNotificationContent()
                content2.title = "Tests Reminder"
                
                if pdfStruct.numberTestsDueTomorrow() == 1 {
                    content2.body = "You have 1 test tomorrow!"
                } else {
                    content2.body = "You have " + String(pdfStruct.numberTestsDueTomorrow()) + " tests tomorrow!"
                }
                
                let randomIdentifier2 = UUID().uuidString
                let request2 = UNNotificationRequest(identifier: randomIdentifier2, content: content2, trigger: trigger)
                UNUserNotificationCenter.current().add(request2) { error in
                  if error != nil {
                    print("something went wrong")
                  }
                }
            }
            
            
            
            // 3
            UNUserNotificationCenter.current().add(request) { error in
              if error != nil {
                print("something went wrong")
              }
            }
            print("updateNotification")
        }
    }
    
    
    func saveColors() {
        var saveString = ""
        for (className, color) in classColors {
            saveString += "\(className)\n\(color)\n"
        }
        rwt.writeFile(writeString: saveString, fileName: "SaveColors13")
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
    
    func getScrollValue() -> Int {
        if semester == 1 {
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
        
        /*if schedule[getCurrentDay()]![ci].getLength() == 105 {
            
        }*/
        
        
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
        else {
            
            print("***********")
            print(UIScreen.screenHeight)
            print("***********")
            
            let h = UIScreen.screenHeight
            
            if getCurrentTime() > schedule2[getCurrentDay()]![getCurrentClassIndex()].getEnd() {
                return 0
            }
            
            var ci = getCurrentClassIndex()
            
            if ci == 0 {
                return 0
            }
            
            var totalLength = 0
            
            /*if schedule[getCurrentDay()]![ci].getLength() == 105 {
                
            }*/
            
            
            if ci == schedule2[getCurrentDay()]!.count-1 {
                //totalLength -= 41
                totalLength -= Int(h/21.85365854)
                
                //TESTED
                if (schedule2[getCurrentDay()]![ci].block[0].lowercased() == "j") {
                    //totalLength -= 25
                    totalLength -= Int(h/35.84)
                }
                
                if h < 896.0 {
                    totalLength += 5
                }
            }
            
            
            //TESTED
            if (ci == schedule2[getCurrentDay()]!.count-2) && ((schedule2[getCurrentDay()]![ci+1].block[0].lowercased() == "j")) {
                //totalLength -= 10
                totalLength -= Int(h/89.6)
            }
            
            
            
            
            for n in 0..<ci {
                totalLength += schedule2[getCurrentDay()]![n].getLength()
            }
            
            //return 7 * (totalLength - 10)
            return 7 * (totalLength - Int(h/89.6))
        }
    }
    
    
    
    
    
}
