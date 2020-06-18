//
//  ContentView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 1/3/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//
import Foundation
import SwiftUI
import PDFKit
import Combine
import MobileCoreServices

var rwt = ReadWriteText()
//var pdfD = PDFDocument(url: URL(string: "https://github.com/IdoshoCSClub/Host/raw/master/test.pdf")!)!
var pdfD = PDFDocument()
//var pdfD = PDFDocument(url: URL(fileURLWithPath: "/Users/ido/Desktop/test4.pdf"))!
var pdfStruct = PDF()
var classCount = 0

struct ContentViewA: View {
    
    @ObservedObject var viewRouter: ViewRouter

    var body: some View {
        if rwt.readFile(fileName: "Save15") != "" {
            print(rwt.readFile(fileName: "Save15"))
            self.viewRouter.currentPage = "page4"
        } else {return ViewControllerWrapper()}
        return ViewControllerWrapper()
    }
}

struct ContentViewB: View {
    
    @ObservedObject var viewRouter: ViewRouter

    var body: some View {
        VStack {
        Text("Welcome \(pdfStruct.returnName())!").fontWeight(.heavy)
            Button(action: {self.viewRouter.currentPage = "page3"; print(pdfStruct.classList)}) {
                Text("Continue").fontWeight(.heavy).frame(width: 300, height: 20, alignment: .center).padding()
            }
        }
        }
    }



/*
struct ContentViewC: View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    var colors = [#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)]
    @State private var selectedColor = 0
    
    let classList = pdfStruct.uniqueClassList
    let Class: Class
    
    var body: some View {

        ZStack {
            Color.init(colors[selectedColor]).edgesIgnoringSafeArea(.all).opacity(0.7)
        VStack {
            
            Text(Class.courseName).fontWeight(.heavy)
            Text("\(Class.block)  \(Class.semester)").fontWeight(.heavy)
            Picker(selection: $selectedColor, label: Text("Please choose a color")) {
               ForEach(0 ..< colors.count) {
                  Color(self.colors[$0])
               }
            } .labelsHidden()
            Button(action: {classCount+=1;pdfStruct.classColors[self.Class.courseName] = self.colors[self.selectedColor]; self.selectedColor = 0; if classCount == self.classList.count {self.viewRouter.currentPage = "page4"; print(pdfStruct.classColors); pdfStruct.saveColors()} else { self.viewRouter.currentPage = "page3"}}) {
                Text("Next...").fontWeight(.heavy).padding()
            }
        }
    }
    }
}*/

import ColorPicker

struct ContentViewC: View {
    
    @ObservedObject var viewRouter: ViewRouter
    @State var color = UIColor.red
    
    let classList = pdfStruct.uniqueClassList
    let Class: Class
    
    var body: some View {

        ZStack {
            Color.init(color).edgesIgnoringSafeArea(.all).opacity(0.7)
        VStack {
            
            Text(Class.courseName).fontWeight(.heavy)
            Text("\(Class.block)  \(Class.semester)").fontWeight(.heavy)
            /*Picker(selection: $selectedColor, label: Text("Please choose a color")) {
               ForEach(0 ..< colors.count) {
                  Color(self.colors[$0])
               }
            } .labelsHidden()*/
            
            ColorPicker(color: $color, strokeWidth: 30)
                .frame(width: 200, height: 200, alignment: .center)
                .padding()
            
            Button(action: {classCount+=1;pdfStruct.classColors[self.Class.courseName] = self.color; self.color = UIColor.red; if classCount == self.classList.count {self.viewRouter.currentPage = "page4"; print(pdfStruct.classColors); pdfStruct.saveColors()} else { self.viewRouter.currentPage = "page3"}}) {
                Text("Next...").fontWeight(.heavy).padding()
            }
        }
    }
    }
}




/*
struct ContentView_PreviewsA: PreviewProvider {
    static var previews: some View {
        ContentViewA(viewRouter: ViewRouter())
    }
}

struct ContentView_PreviewsB: PreviewProvider {
    static var previews: some View {
        ContentViewB(viewRouter: ViewRouter())
    }
}

struct ContentView_PreviewsC: PreviewProvider {
    static var previews: some View {
        ContentViewC(viewRouter: ViewRouter(), Class: pdfStruct.uniqueClassList[0])
    }
}*/



