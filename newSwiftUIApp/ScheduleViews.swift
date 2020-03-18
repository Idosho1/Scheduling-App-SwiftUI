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
        
    }.onAppear {pdfStruct.restore(); print("done")}
    
    }
}

/*VStack {
    Text("Schedule View")
    Button(action: {rwt.writeFile(writeString: "", fileName: "Save7")}) {
    Text("Restart")
    }.padding()
}*/



struct ScheduleView: View {
    var items = [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple,Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple]
    
var body: some View {
    
    ScrollView(Axis.Set.vertical, showsIndicators: false) {
        HStack {
            VStack {
                ForEach(pdfStruct.schedule[pdfStruct.getCurrentDay()]!, id: \.self) { item in
                    ClassSideView(c: item).frame(width: 20)
                }
            }
        VStack {
            ForEach(pdfStruct.schedule[pdfStruct.getCurrentDay()]!, id: \.self) { item in
                ClassView(c: item)
            }
        }
    }
    }
}
}

struct ClassSideView: View {
    
    var c: Class
    
    
    var body: some View {
        
        let num = c.getLength()/5
        var dashes = [String]()
        for _ in 1...num {
            dashes.append("-")
        }
    
        return VStack {
            
            ForEach(dashes, id: \.self) { item in
                Text(item).padding(.bottom, 14)
            }
            
        }.frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: CGFloat(7 * c.getLength()))
    }
    
}


struct ClassView: View {
    
    var c: Class
    
    var body: some View {
    
        VStack {
            
            Text(c.courseName + " - " + c.block).bold().padding()
            Text(c.timeStart + " - " + c.timeEnd).bold().padding()
            Text(c.roomNumber).bold().padding().frame(width: 400)
            
        }.frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: CGFloat(7 * c.getLength()))
        .background(Color.init(pdfStruct.classColors[c.courseName]!).edgesIgnoringSafeArea(.all).opacity(0.7))
    }
    
}

struct HomeworkView: View {
    @State var showingDetail = false
    @State private var selectedTab = 1
    @State var period = "Today"
    

var body: some View {
    
    
    
    func updatePeriod() {
        switch selectedTab {
        case 0: period = "Overdue"
        case 1: period = "Today"
        case 2: period = "Tomorrow"
        case 3: period = "This Week"
        case 4: period = "This Month"
        default: period = "Today"
        }
    }
    
    
    
    
    return ZStack {
        VStack {
        NavigationView {
            List {
                ForEach(pdfStruct.homework.reversed(), id: \.self) { hw in
                    Group {
                        if !hw.complete {
                            if self.selectedTab == 0 && ((...Calendar.current.startOfDay(for: Date().addingTimeInterval(-86400))).contains(Calendar.current.startOfDay(for: hw.dueDate))) {AssignmentView(homework: hw)}
                            if self.selectedTab == 1 && (Calendar.current.isDateInToday(hw.dueDate)) {AssignmentView(homework: hw)}
                            if self.selectedTab == 2 && (Calendar.current.isDateInTomorrow(hw.dueDate)) {AssignmentView(homework: hw)}
                            if self.selectedTab == 3 && ((Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*2))...Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*7))).contains(Calendar.current.startOfDay(for: hw.dueDate))) {AssignmentView(homework: hw)}
                            if self.selectedTab == 4 && ((Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*8))...).contains(Calendar.current.startOfDay(for: hw.dueDate))) {AssignmentView(homework: hw)}
                    }
                        
                    }
                }
            } .navigationBarTitle(Text("Homework - " + period))
        }
        HStack {
            
            
            Button(action: {self.selectedTab -= 1; updatePeriod(); pdfStruct.updateHW()}) {
            Image(systemName: "arrow.left")
                    }.padding(.horizontal, 70).disabled(!(selectedTab>=1))
            
        
        
        Button(action: {
            self.showingDetail.toggle()
        }) {
            Image(systemName: "plus")
        }.sheet(isPresented: $showingDetail) {
            AddHomeworkView()
            } .padding()
        
            
                Button(action: {self.selectedTab += 1; updatePeriod(); pdfStruct.updateHW()}) {
            Image(systemName: "arrow.right")
                    }.padding(.horizontal, 70).disabled(!(selectedTab<=3))
            
        }.padding(.bottom, 30)
        
        
        
    }.onAppear{self.selectedTab = 1; updatePeriod()}.onDisappear{pdfStruct.updateHW()}
    }
    
    }
    
    
}


/*struct CheckView: View {
@State var isChecked:Bool = false
var title:String
func toggle(){isChecked = !isChecked}
var body: some View {
Button(action: toggle){
HStack{
Image(systemName: isChecked ? "checkmark.square": "square")
Text(title)
}

}

}

}*/

struct AddHomeworkView: View {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    @State private var name: String = ""
    @State private var selectedClass = 0
    @State var isChecked: Bool = true
    @State private var dueDate = Date()
    func toggle(){isChecked = !isChecked}
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Add Homework").padding()
            
            TextField("Title", text: $name).padding().multilineTextAlignment(.center)
            
            Button(action: {self.toggle();}){
            HStack{
            Image(systemName: isChecked ? "checkmark.square": "square")
            Text("Due Next Class?")
            }
            }
            
            if !isChecked {
                HStack{
                Spacer()
                    DatePicker.init(selection: $dueDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
                    EmptyView()
                    })
                    .labelsHidden().datePickerStyle(WheelDatePickerStyle())
                Spacer()
                }
            }

            
            Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                ForEach(0 ..< pdfStruct.uniqueClassList.count) {
                    Text(pdfStruct.uniqueClassList[$0].courseName)
               }
                } .labelsHidden().padding()
            
            
            Button(action: {
                if self.isChecked {
                    pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: pdfStruct.getNextClassDate(pdfStruct.uniqueClassList[self.selectedClass]))
                    self.presentationMode.wrappedValue.dismiss()
                }
                else {
                    pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: self.dueDate)
                }
                
                self.presentationMode.wrappedValue.dismiss()
                }) {
                Text("Done").padding()
            }
            } .padding()
    }
}


struct AssignmentView: View {

    var picName: String = "circle"
    @ObservedObject var homework: Homework
    @State var complete = false
    
    let df = DateFormatter()
    let dfDay = DateFormatter()
    
    
var body: some View {
    df.dateFormat = "MM-dd";
    
    dfDay.dateFormat = "EEE";
    
    return HStack {
        VStack {
            Color.init(pdfStruct.classColors[homework.cls.courseName]!)
        } .frame(width: 10, height: 85, alignment: .leading)
        VStack(alignment: .leading) {
        Text("\(homework.cls.courseName) - \(homework.cls.block)")
            Text(homework.name).padding(.bottom, 10)
            

            Text("\(dfDay.string(from: homework.dueDate)) - \(df.string(from: homework.dueDate))")
        }.padding(5)
        
        Spacer()
        
        VStack {
            
            if !complete && !self.homework.complete {
                Image(systemName: "circle").resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .opacity(0.6)
            }
            else {
                Image(systemName: "checkmark.circle.fill").resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .opacity(0.6)
            }
            
        }.onTapGesture {
            print(self.homework.dueDate)
            if !self.complete {
                self.homework.complete = true
                self.complete = true
            }
            else {
                self.homework.complete = false
                self.complete = false
            }
        }
            
            //(homework.complete == false ? Image(systemName: "circle") : Image(systemName: "checkmark.circle")).resizable()
            /*if complete {
                Image(systemName: "pencil").resizable().onTapGesture {
                    <#code#>
                }
                .frame(width: 30, height: 30, alignment: .center)
                .opacity(0.6)
            }
            else {
                Image(systemName: "circle").resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .opacity(0.6)
            }
            
        }
        .onTapGesture {
            for n in 0..<pdfStruct.homework.count {
                if pdfStruct.homework[n].name == self.homework.name {
                    pdfStruct.homework[n].complete = true
                    complete = true
                    print(complete)
                    */
                }
                
            }
        }
        
   // }
    
    //}
//}


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

/*
struct AssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentView(homework: Homework(name: "Name", cls: Class(roomNumber: "1", courseName: "AP Calculus BC", semester: "FY", timeStart: "7:40", timeEnd: "8:40", block: "A")))
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
*/


/*
 VStack {
       Text("All Done!").fontWeight(.heavy)
     Button(action: {rwt.writeFile(writeString: "", fileName: "Save6"); self.viewRouter.currentPage = "page1"}) {
         Text("Reset").fontWeight(.heavy).padding()
     }
 } .onAppear {classCount = 0}
 */
