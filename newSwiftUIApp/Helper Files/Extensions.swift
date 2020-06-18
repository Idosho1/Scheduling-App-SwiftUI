//
//  Extensions.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI
import UIKit

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
