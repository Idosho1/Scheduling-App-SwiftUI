//
//  AddHomeworkView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI

struct AddHomeworkView: View {
    
    @State var singleIsPresented = false
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var courseName: String
    
    init(courseName: String = "") {
        self.courseName = courseName
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    @State private var name: String = ""
    @State private var selectedClass = 0
    @State var isChecked: Bool = true
    @State private var dueDate = Date()
    @State private var missingInfo = false
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
                /*VStack {
                HStack{
                Spacer()
                    DatePicker.init(selection: $dueDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
                    EmptyView()
                    })
                    .labelsHidden().datePickerStyle(WheelDatePickerStyle())
                Spacer()
                }
                    Text(PDF.intToDay(i: Int(Calendar.current.component(.weekday, from: self.dueDate))))
                }*/
                Button(action: { self.singleIsPresented.toggle() }) {
                    Text("Select a due date").foregroundColor(.blue).padding()
                }
                .sheet(isPresented: self.$singleIsPresented, content: {
                    RKViewController(isPresented: self.$singleIsPresented, rkManager: self.rkManager1)})
                Text(self.getTextFromDate(date: self.rkManager1.selectedDate))
            }

            if pdfStruct.semester == 1 {
            Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                ForEach(0 ..< pdfStruct.uniqueClassList1.count) {
                    Text(pdfStruct.uniqueClassList1[$0].courseName)
               }
                } .labelsHidden().padding()
            } else {
                Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                 ForEach(0 ..< pdfStruct.uniqueClassList2.count) {
                     Text(pdfStruct.uniqueClassList2[$0].courseName)
                }
                 } .labelsHidden().padding()
            }
            
            Button(action: {
                if (self.isChecked || self.rkManager1.selectedDate != nil) && self.name != "" {
                if self.isChecked {
                    pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: pdfStruct.getNextClassDate(pdfStruct.uniqueClassList[self.selectedClass]))
                    self.presentationMode.wrappedValue.dismiss()
                }
                else {
                    pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: self.rkManager1.selectedDate)
                }
                
                self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.missingInfo = true
                }}) {
                Text("Done").padding()
            } .alert(isPresented: $missingInfo) {
                Alert(title: Text("Missing Information"), message: Text("Missing title or due date"), dismissButton: .default(Text("Done")))
            }
            /*if self.missingInfo {
                Text("Missing Title or Date").bold().foregroundColor(.red).padding()
            }*/
        }.font(Font(UIFont(name: "Avenir", size: 18)!)) .padding().navigationViewStyle(StackNavigationViewStyle()).onAppear {
            if self.courseName != "" {
                for n in 0..<pdfStruct.uniqueClassList.count {
                    if pdfStruct.uniqueClassList[n].courseName == self.courseName {
                        self.selectedClass = n
                        break
                    }
                }
            }
        }.onDisappear() {
            pdfStruct.updateNotifications()
        }
        
        

    }
    func datesView(dates: [Date]) -> some View {
        ScrollView (.horizontal) {
            HStack {
                ForEach(dates, id: \.self) { date in
                    Text(self.getTextFromDate(date: date))
                }
            }
        }.padding(.horizontal, 15)
    }
    
    func getTextFromDate(date: Date!) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return date == nil ? "" : formatter.string(from: date)
    }
}
