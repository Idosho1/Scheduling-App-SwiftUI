//
//  AssignmentView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI

struct NewAssignmentView: View {

    var picName: String = "circle"
    @ObservedObject var homework: Assignment
    @State var complete = false
    @State var showingDetail = false
    
    let df = DateFormatter()
    let dfDay = DateFormatter()
    
    
var body: some View {
    df.dateFormat = "MM-dd";
    
    dfDay.dateFormat = "EEE";
    
    return HStack {
        VStack {
            Color.init(pdfStruct.classColors[homework.courseName!]!)
        } .frame(width: 10, height: 85, alignment: .leading)
        VStack(alignment: .leading) {
            //Text("\(homework.courseName!) - \(pdfStruct.class)")
            Text("\(homework.courseName!)")
            Text(homework.name!).padding(.bottom, 10)
            

            //Text("\(dfDay.string(from: homework.dueDate!)) - \(df.string(from: homework.dueDate!))")
        }.padding(5)
        
        Spacer()
        
        VStack {
            Text("\(dfDay.string(from: homework.dueDate!)) - \(df.string(from: homework.dueDate!))")
        }
        
        
    }.cornerRadius(10)
                
            }
        }
