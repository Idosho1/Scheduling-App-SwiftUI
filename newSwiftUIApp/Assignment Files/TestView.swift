//
//  TestView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI
import CoreData

struct TestView: View {
    @State var showingDetail = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Assignment.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Assignment.dueDate, ascending: true),
        ]
    ) var tests: FetchedResults<Assignment>
    
    func removeTest(at offsets: IndexSet) {
        for index in offsets {
            let test = tests[index]
            test.complete = true
            managedObjectContext.delete(test)
        }
        pdfStruct.updateNotifications(tests)
    }
    
    var body: some View {
        
        VStack {
            
            NavigationView {
                List {
                    ForEach(tests, id: \.self) { hw in
                        Group {
                            if hw.test {
                                NavigationLink(destination: DetailView(assignment: hw)) {
                                    NewAssignmentView(homework: hw)
                                }
                            }
                        }
                    }.onDelete(perform: removeTest)
                } .navigationBarTitle(Text("Tests"))
            }
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Image(systemName: "plus")
            }.sheet(isPresented: $showingDetail) {
                AddTestView().environment(\.managedObjectContext, self.managedObjectContext)
            } .padding(.bottom, 25)
        }.onAppear{pdfStruct.updateHW()
            for hw in pdfStruct.homework {
                print(hw)
            }
        }.onDisappear{pdfStruct.updateHW()}
        
        
    }
}

