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


var pdfStruct = PDF("https://c6908a4a-ca15-4236-83a1-86c396a6f39a.filesusr.com/ugd/e168cf_2ef43921853c4c6ea731bf7e6d790ce7.pdf")
var rwt = ReadWriteText()


struct ContentViewA: View {
    
    @ObservedObject var viewRouter: ViewRouter

    var body: some View {
        VStack {
            Button(action: {self.viewRouter.currentPage = "page2"; pdfStruct.makeSchedule()}) {
            Text("Import Schedule").fontWeight(.heavy)
            }
            Button(action: {pdfStruct.restore()}) {
                Text("Restore").fontWeight(.heavy).padding()
            }
        }.onAppear {if rwt.readFile(fileName: "Save6") != "" {self.viewRouter.currentPage = "page4"}}
    }
}

struct ContentViewB: View {
    
    @ObservedObject var viewRouter: ViewRouter

    var body: some View {
        VStack {
        Text("Welcome \(pdfStruct.returnName())").fontWeight(.heavy)
            Button(action: {self.viewRouter.currentPage = "page3"; print(pdfStruct.classList)}) {
            Text("Continue").fontWeight(.heavy).padding()
            }
        }
    }
}

var classCount = 0

struct ContentViewC: View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    var colors = [#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1), #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1),]
    @State private var selectedColor = 0
    
    let classList = pdfStruct.uniqueClassList
    let Class: Class
    
    var body: some View {

        ZStack {
            Color.init(colors[selectedColor]).edgesIgnoringSafeArea(.all).opacity(0.7)
        VStack {
            
            Text(Class.courseName).fontWeight(.heavy)
            Picker(selection: $selectedColor, label: Text("Please choose a color")) {
               ForEach(0 ..< colors.count) {
                  Color(self.colors[$0])
               }
            } .labelsHidden()
            Button(action: {classCount+=1; pdfStruct.classColors[self.Class.courseName] = self.colors[self.selectedColor]; if classCount == self.classList.count {self.viewRouter.currentPage = "page4"; print(pdfStruct.classColors); pdfStruct.saveColors()} else { self.viewRouter.currentPage = "page3"}}) {
                Text("Next...").fontWeight(.heavy).padding()
            }
        }
    }
    }
}

struct ContentViewD: View {
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
              Text("All Done!").fontWeight(.heavy)
            Button(action: {rwt.writeFile(writeString: "", fileName: "Save6")}) {
                Text("Reset").fontWeight(.heavy).padding()
            }
           }
        }
    }


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
}