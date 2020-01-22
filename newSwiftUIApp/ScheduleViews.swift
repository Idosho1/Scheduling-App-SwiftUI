//
//  ScheduleViews.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 1/8/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentViewD: View {
@ObservedObject var viewRouter: ViewRouter

var body: some View {
    
    TabView {
        
        ScheduleView()
        
        .tabItem {
            VStack {
                Image(systemName: "clock")
                Text("Schedule")
                }
        }.tag(1)
        
        HomeworkView()
        
        .tabItem {
            VStack {
                Image(systemName: "pencil")
                Text("Homework")
                }
        }.tag(2)
        
    }.onAppear {pdfStruct.restore()}
    
    }
}

struct ScheduleView: View {

var body: some View {
    VStack {
        Text("Schedule View")
        Button(action: {rwt.writeFile(writeString: "", fileName: "Save7")}) {
        Text("Restart")
        }.padding()
    }
    }
}

struct HomeworkView: View {
    @State var showingDetail = false
var body: some View {
    VStack {
        NavigationView {
            List {
                ForEach(pdfStruct.homework, id: \.self) { hw in
                    AssignmentView(homework: hw)
                } .onDelete(perform: delete)
            }
        }
        Button(action: {
            self.showingDetail.toggle()
        }) {
            Image(systemName: "plus")
        }.sheet(isPresented: $showingDetail) {
            AddHomeworkView()
            } .padding()
    }
    

    }
    
    func delete(at offsets: IndexSet) {
        pdfStruct.homework.remove(atOffsets: offsets)
    }
}

struct AddHomeworkView: View {
    @State private var name: String = ""
    @State private var desc: String = ""
    @State private var selectedClass = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Add Homework")
            TextField("Title", text: $name)
            TextField("Description", text: $desc)
            
            Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                ForEach(0 ..< pdfStruct.uniqueClassList.count) {
                    Text(pdfStruct.uniqueClassList[$0].courseName)
               }
            } .labelsHidden()
            
            
            Button(action: {pdfStruct.addHW(name: self.name, description: self.desc, cls: pdfStruct.uniqueClassList[self.selectedClass]); self.presentationMode.wrappedValue.dismiss()}) {
                Text("Done")
            }
            } .padding()
    }
}

struct AssignmentView: View {

    var homework: Homework
    
var body: some View {
    HStack {
        VStack {
            Color.init(pdfStruct.classColors[homework.cls.courseName]!)
        } .frame(width: 10, height: 70, alignment: .leading)
        VStack(alignment: .leading) {
        Text("\(homework.cls.courseName) - \(homework.cls.block)")
        Text(homework.name)
        }
        Spacer()
        Button(action: {}) {
            Image(systemName: "checkmark.circle")
        }
    }
    }
}


struct ContentView_PreviewsD: PreviewProvider {
    static var previews: some View {
        ContentViewD(viewRouter: ViewRouter())
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

struct HomeworkView_Previews: PreviewProvider {
    static var previews: some View {
        HomeworkView()
    }
}

struct AssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentView(homework: Homework(name: "Name", description: "Description", cls: Class(roomNumber: "1", courseName: "AP Calculus BC", semester: "FY", timeStart: "7:40", timeEnd: "8:40", block: "A")))
        .previewLayout(.fixed(width: 300, height: 70))
    }
}



/*
 VStack {
       Text("All Done!").fontWeight(.heavy)
     Button(action: {rwt.writeFile(writeString: "", fileName: "Save6"); self.viewRouter.currentPage = "page1"}) {
         Text("Reset").fontWeight(.heavy).padding()
     }
 } .onAppear {classCount = 0}
 */
