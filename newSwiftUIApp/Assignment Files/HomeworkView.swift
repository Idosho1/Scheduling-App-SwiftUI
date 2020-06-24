//
//  HomeworkView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI



struct HomeworkView: View {
    @State var showingDetail = false
    //@State private var selectedTab = 1
    //@State var period = "Today"
    
    @State private var selectedTab = 1
    @State var periods = ["Overdue", "Today", "Tomorrow", "Week", "Month"]
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Avenir", size: 35)!]
        UITableView.appearance().tableFooterView = UIView()
    }

var body: some View {
    
    
    /*
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
*/
    
    
    
    
    
    return ZStack {
        VStack {
            
        NavigationView {
            
            VStack {
                
                Picker("", selection: $selectedTab) {
                    ForEach(0..<periods.count) { index in
                        Text(self.periods[index]).tag(index)
                    }
                    }.pickerStyle(SegmentedPickerStyle()).padding()
                .onReceive([self.selectedTab].publisher.first()) { (value) in
                    pdfStruct.updateHW()
                }
                
                Spacer()
            
            List {
                ForEach(pdfStruct.homework.reversed(), id: \.self) { hw in
                    // START
                    
                    
                        
                    
                    
                    Group {
                        
                        if !hw.complete && !hw.test {
                            if self.selectedTab == 0 && ((...Calendar.current.startOfDay(for: Date().addingTimeInterval(-86400))).contains(Calendar.current.startOfDay(for: hw.dueDate))) {
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // Overdue
                                //}
                                
                            }
                            if self.selectedTab == 1 && (Calendar.current.isDateInToday(hw.dueDate)) {
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // Today
                                //}
                                
                            }
                            if self.selectedTab == 2 && (Calendar.current.isDateInTomorrow(hw.dueDate)) {
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // Tomorrow
                                //}
                                
                            }
                            if self.selectedTab == 3 && ((Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*2))...Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*7))).contains(Calendar.current.startOfDay(for: hw.dueDate))) {
                                
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // This Week
                                //}
                                
                            }
                            if self.selectedTab == 4 && ((Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*8))...).contains(Calendar.current.startOfDay(for: hw.dueDate))) {
                                
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // This Month
                                //}
                                
                            }
                    }
                      
                    }
                   
                        
                        
                    // END
                }
                }
                } .navigationBarTitle(Text("Homework"))
            
            }
           
            
        HStack {
            
            /*Button(action: {self.selectedTab -= 1; updatePeriod(); pdfStruct.updateHW()}) {
            Image(systemName: "arrow.left")
                    }.padding(.horizontal, 70).disabled(!(selectedTab>=1))
            */
        
        
        Button(action: {
            self.showingDetail.toggle()
        }) {
            Image(systemName: "plus")
        }.sheet(isPresented: $showingDetail) {
            AddHomeworkView()
            } //.padding()
        
            /*
                Button(action: {self.selectedTab += 1; updatePeriod(); pdfStruct.updateHW()}) {
            Image(systemName: "arrow.right")
                    }.padding(.horizontal, 70).disabled(!(selectedTab<=3))
            */
        }.padding(.bottom, 25)
            
            
        
        }.onAppear{self.selectedTab = 1; pdfStruct.updateHW()}.onDisappear{pdfStruct.updateHW()}

    }
    
    }
    
    
}


