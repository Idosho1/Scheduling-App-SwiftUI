//
//  AssignmentView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI

struct AssignmentView: View {

    var picName: String = "circle"
    @ObservedObject var homework: Homework
    @State var complete = false
    @State var showingDetail = false
    
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
                pdfStruct.updateHW()
                pdfStruct.updateNotifications()
            }
            else {
                self.homework.complete = false
                self.complete = false
                pdfStruct.updateHW()
                pdfStruct.addHW(name: self.homework.name, cls: self.homework.cls, dueDate: self.homework.dueDate, test: self.homework.test)
                pdfStruct.updateNotifications()
            }
        }
            
            //(homework.complete == false ? Image(systemName: "circle") : Image(systemName: "checkmark.circle")).resizable()
            /*if complete {
                Image(systemName: "pencil").resizable().onTapGesture {
                    
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
        
        
    }.cornerRadius(10)
                
            }
        }
