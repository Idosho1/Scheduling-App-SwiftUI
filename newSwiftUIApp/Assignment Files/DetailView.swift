//
//  DetailView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 7/19/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation

struct DetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isEditing = false
    
    @State var singleIsPresented = false
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)

    var assignment: Assignment
    @State private var newName: String = ""
    @State private var selectedClass = 0
    @State private var dueDate = Date()
    @State private var newDate = Date()
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        VStack {
            
            
            if isEditing {
                NavigationView {
                    Form {
                    
                        Section(header: Text("Title").padding(.top, 20)) {
                            TextField("Title", text: $newName)
                        }
                        
                        Section(header: Text("Due Date").padding(.top, 20)) {
                            DatePicker.init(selection: $newDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
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
                    
                    }.navigationBarTitle("Editing Asssignment")
                }
            } else {
                NavigationView {
                    Form {
                    
                        Section(header: Text("Title").padding(.top, 20)) {
                            Text(newName)
                        }
                        
                        Section(header: Text("Due Date").padding(.top, 20)) {
                            DatePicker.init(selection: $newDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
                            EmptyView()
                            })
                            .labelsHidden().disabled(true)
                        }
                        
                        Text(assignment.courseName!)
                    
                    }.navigationBarTitle("Asssignment Details")
                }
            }
            
            
            
            
            
            
            
            
        }
        .onAppear {
            
                for n in 0..<pdfStruct.uniqueClassList.count {
                    if pdfStruct.uniqueClassList[n].courseName == assignment.courseName {
                        self.selectedClass = n
                        break
                    }
                }
            
            
            self.newName = assignment.name!
            self.newDate = assignment.dueDate!
        }.onDisappear {
            //assignment.name = newName
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
            }
        }.navigationBarItems(trailing: Button(action: {
            self.isEditing.toggle()
            
            if !isEditing {
                assignment.name = newName
                assignment.dueDate = newDate
                assignment.courseName = pdfStruct.uniqueClassList[self.selectedClass].courseName
            }
            
        }) {
            Text(isEditing ? "Done" : "Edit")
        })
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


