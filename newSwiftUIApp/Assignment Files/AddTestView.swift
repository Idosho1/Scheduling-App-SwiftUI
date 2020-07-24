//
//  AddTestView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI
import CoreData

struct AddTestView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Assignment.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Assignment.dueDate, ascending: true),
        ]
    ) var assignments: FetchedResults<Assignment>
    
    @State var singleIsPresented = false
    //@State var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var courseName: String
    
    init(courseName: String = "") {
        self.courseName = courseName
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    @State private var showingAlert = false

    @State private var name: String = ""
    @State private var selectedClass = 0
    @State private var missingInfo = false
    @State private var dueDate = Date().addingTimeInterval(86400)
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        
        NavigationView {
            Form {
                
                Section(header: Text("Title").padding(.top, 20)) {
                    TextField("Title", text: $name)
                }
                
                Section(header: Text("Due Date").padding(.top, 20)) {
                    DatePicker.init(selection: $dueDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
                    EmptyView()
                    })
                    .labelsHidden()
                }
                
                Section(header: Text("Course").padding(.top, 20)) {
                    if pdfStruct.semester == 1 {
                        Picker("Select a Course", selection: $selectedClass) {
                        ForEach(0 ..< pdfStruct.uniqueClassList1.count) {
                            Text(pdfStruct.uniqueClassList1[$0].courseName)
                       }
                        } .labelsHidden()//.padding()
                    } else {
                        Picker("Select a Course", selection: $selectedClass) {
                         ForEach(0 ..< pdfStruct.uniqueClassList2.count) {
                             Text(pdfStruct.uniqueClassList2[$0].courseName)
                        }
                         } //.labelsHidden()//.padding()
                    }
                }
                
                Button(action: {
                    if self.name != "" {
                    //pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: self.rkManager1.selectedDate, test: true)
                        
                        //ADD NEW TEST
                        let test = Assignment(context: self.managedObjectContext)
                        test.name = self.name
                        test.courseName = pdfStruct.uniqueClassList[self.selectedClass].courseName
                        test.dueDate = self.dueDate
                        test.test = true
                        test.complete = false
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                        
                            
                    
                    self.presentationMode.wrappedValue.dismiss()
                    } else {
                        self.missingInfo = true
                    }}) {
                    HStack {
                        Spacer()
                        Text("Done")//.padding()
                        Spacer()
                    }
                }.alert(isPresented: $missingInfo) {
                    Alert(title: Text("Missing Information"), message: Text("Missing assignment title"), dismissButton: .default(Text("Done")))
                }
                
            }.navigationBarTitle("Add Test")
            
            
            
        }.onDisappear() {
            pdfStruct.updateNotifications(assignments)
        }
        
        
        
        
        /*
        VStack {
            Text("Add Test").padding().font(Font(UIFont(name: "Avenir", size: 25)!))
            
            TextField("Title", text: $name).padding().multilineTextAlignment(.center).font(Font(UIFont(name: "Avenir", size: 18)!))
            

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
            
            DatePicker.init(selection: $dueDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
            EmptyView()
            })
            .labelsHidden().frame(maxHeight: 100)
            
            
            
            /*
            Button(action: { self.singleIsPresented.toggle() }) {
                Text("Select a due date").foregroundColor(.blue).padding()
            }
            .sheet(isPresented: self.$singleIsPresented, content: {
                RKViewController(isPresented: self.$singleIsPresented, rkManager: self.rkManager1)})
            Text(self.getTextFromDate(date: self.rkManager1.selectedDate))
            */

            
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
                if self.rkManager1.selectedDate != nil && self.name != "" {
                //pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: self.rkManager1.selectedDate, test: true)
                    
                    //ADD NEW TEST
                    let test = Assignment(context: self.managedObjectContext)
                    test.name = self.name
                    test.courseName = pdfStruct.uniqueClassList[self.selectedClass].courseName
                    test.dueDate = self.rkManager1.selectedDate
                    test.test = true
                    test.complete = false
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    
                        
                
                self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.missingInfo = true
                }}) {
                Text("Done").padding()
            }.alert(isPresented: $missingInfo) {
                Alert(title: Text("Missing Information"), message: Text("Missing title or due date"), dismissButton: .default(Text("Done")))
            }
            if self.missingInfo {
                //Text("Missing Title or Date").bold().foregroundColor(.red).padding()
                //Alert(title: Text("Important message"), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
            }
        } .font(Font(UIFont(name: "Avenir", size: 18)!)).padding().navigationViewStyle(StackNavigationViewStyle()).onAppear {
            if self.courseName != "" {
                for n in 0..<pdfStruct.uniqueClassList.count {
                    if pdfStruct.uniqueClassList[n].courseName == self.courseName {
                        self.selectedClass = n
                        break
                    }
                }
            }
        }.onDisappear() {
            pdfStruct.updateNotifications(assignments)
        }
 */
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
