//
//  TabsView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI

 struct ContentViewD: View {
 @ObservedObject var viewRouter: ViewRouter
 @State private var selection = 1
     
 var body: some View {
     
     TabView(selection:$selection) {
         
         TestView()
         
             .tabItem {
                 VStack {
                     Image(systemName: "doc.on.doc")
                     Text("Tests")
                 }
         }.tag(2)
         
         
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
         }.tag(3)
             
         Experimental(viewRouter: viewRouter)
         
             .tabItem {
                 VStack {
                 Image(systemName: "gear")
                 Text("Settings")
                 }
         }.tag(4)
         
     }.onAppear {pdfStruct.restore(); print("done"); pdfStruct.updateNotifications()
         //REALLY IMPORTANT!!!!!!!
         
         print("\n\n\nS1 Schedule:")
         print(pdfStruct.schedule)
         print("\n\n\nS2 Schedule:")
         print(pdfStruct.schedule2)
         
     }
     }
 }
